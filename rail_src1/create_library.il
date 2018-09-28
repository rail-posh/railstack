procedure( read_config()
	lib_name = getShellEnvVar("rail_lib_name")
	

	)


)



procedure( create_library()
	tf_file = "/home/lab.apps/vlsiapps/kits/tsmc/N65LP/tsmcN65/tech.db" 

	;create library if not exist
	dut_lib = ddGetObj(lib_name)
	if(dut_lib then 
		ddDeleteObj(dut_lib)
	)
	lib_id = dbCreateLib(lib_name) 
		;lib_id = dbCreateLib("demo")
		;tfId=techOpenTechFile(lib_name techGetDefaultTechName() "a")
		;tcLoadTechFile(tfId tf_file)
	techSetTechLibName(lib_id "tsmcN65")
		;techSaveTechFile(tfId)

	
	;create symbol if not exist
	;dut_ref=dbOpenCellViewByType("rail_lib1" cell "symbol")
	;dut_symbol=dbOpenCellViewByType(lib_name cell "symbol")
	
	;copy symbol from lib
	;if(dut_symbol==nil then  dut_symbol=dbCopyCellView(dut_ref lib_name cell "symbol"))
	;if(dut_symbol==nil then  dut_symbol=dbCopyCellView(dut_ref lib_name cell "symbol"))
)

read_config()
rail_proc=create_library()