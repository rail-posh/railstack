procedure( read_config()
	let( ( tokens fname fpFile )
		fname = "./rail_script1/config.txt"
		unless( fpFile = infile(fname)
			error("Cannot open config file %s" fname )
		)
		modelFile = getShellEnvVar("modelFile")
		session = getShellEnvVar("session")
		;while( gets( line fpFile )
		;  tokens = parseString( line )
		;  cond(
		;	  ((nth( 0 tokens )=="modelFile")
		;		modelFileName=nth( 1 tokens )
		;	  )
		;	  ((nth( 0 tokens )=="session")
		;		session=nth( 1 tokens )
		;	  )
		;	  ((nth( 0 tokens )=="component_cell")
		;		cell=nth( 1 tokens )
		;		sprintf(tb_cell "tb_%s" cell)
		;		sprintf(lib_name "rail_%s" cell)
		;	  )
		;  )
		;) 
		close( fpFile )
	)


)



procedure( create_spectre_netlist()
	envSetVal("asimenv.startup" "projectDir" 'string "~/simulation")
	simulator('spectre)
	design( "rail_lib1" cell "schematic")
	createNetlist( ?recreateAll t)
	design( "rail_tb1" tb_cell "schematic")
	createNetlist( ?recreateAll t)
)

procedure( run_spectre_simulation()
	simulator( 'spectre )
	sprintf(design_file_path "~/simulation/%s/spectre/schematic/netlist/netlist" tb_cell)
	design( design_file_path)
	sprintf(result_file_path "~/simulation/%s/spectre/result" tb_cell)
	resultsDir( result_file_path )
	modelFile(list(modelFileName session))
	analysis('dc ?saveOppoint t  )
	;analysis('tran ?stop "1m"  )
	
	desVar(   "vin" 0.6     )
	desVar(   "vdd" 1.2     )
	desVar(   "sw" 1        )

	;desVar(   "sb" 0     )
	;desVar(   "vin" 1.2   )
	;desVar(   "cload" 1f     )
	;desVar(   "s" 1.2   )
	;desVar(   "vdd" 1.2     )

	envOption(
			'analysisOrder  list("dc")
	)
	save( 'i "/V5/MINUS" "/V8/PLUS" )
	;save( 'i "/I0/IN" "/I14/IN" )
	temp( 27 )
	run()
	
	I_on = IDC("/V5/MINUS")
	R_on = (0.001 / I_on)
	I_off = IDC("/V8/PLUS")
	R_off = (0.01 / I_off)

	;selectResult( 'tran )
	;Ron = average(clip(((v("/out" ?result "tran") - v("/in" ?result "tran")) / IT("/I0/IN")) 5e-10 1e-09))
	;Roff = average(clip(((v("/in2" ?result "tran") - v("/out2" ?result "tran")) / IT("/I14/IN")) 0.0005 0.001))

	sprintf(ocn_file_path "~/simulation/%s/spectre/schematic/psf/result" tb_cell)
	ocnPrint( ?output ocn_file_path R_on R_off)


)

;write_tmp for generating netlist
procedure(write_tmp()
	tmp=outfile("~/simulation/tmpc/tmpout")
	cell_db=dbOpenCellViewByType("rail_lib1" cell "symbol")
	foreach( port cell_db~>portOrder
		
		cond(
			  ((port=="POS" || port=="NEG")
				fprintf(tmp "output %s\n" port)
			  )
			  ((port=="RVDD" || port=="RVSS")
				fprintf(tmp "inout %s\n" port)
			  )
			  (t
				fprintf(tmp "input %s\n" port)
			  )
		  )
	)
	close(tmp)
)

procedure( create_library()
	tf_file = "./demo/demo.tf" 
	;create library if not exist
	dut_lib = ddGetObj(lib_name)
	if(dut_lib==nil then lib_id = dbCreateLib(lib_name))
	
	;create symbol if not exist
	dut_ref=dbOpenCellViewByType("rail_lib1" cell "symbol")
	dut_symbol=dbOpenCellViewByType(lib_name cell "symbol")
	
	;copy symbol from lib
	;if(dut_symbol==nil then  dut_symbol=dbCopyCellView(dut_ref lib_name cell "symbol"))
	if(dut_symbol==nil then  dut_symbol=dbCopyCellView(dut_ref lib_name cell "symbol"))
)


procedure( start_rail()
	printf("*INFO: Starting rail project.\n*")
	read_config()
	create_spectre_netlist()
	run_spectre_simulation()
	write_tmp()
	create_library()
	 


)

rail_started = 0
modelFileName = "/home/lab.apps/vlsiapps/kits/tsmc/N65LP/tsmcN65/../models/spectre/toplevel.scs"
session = "tt_lib"
rail_proc = start_rail()