procedure( create_library(num)
	tf_file = "./demo/demo.tf" 
	library_name = "demo"
 

	;dut symbol
	dut_ref=dbOpenCellViewByType("rail_lib1" cell "symbol")
	dut_symbol=dbOpenCellViewByType("demo" cell "symbol")
	if(dut_symbol==nil then  dut_symbol=dbCopyCellView(dut_ref "demo" cell "symbol"))
	;dut schematic
	dut=dbOpenCellViewByType(lib_id cell "schematic" "schematic" "a") 

	switch_master=dbOpenCellViewByType("rail_lib1" cell "symbol")
	i=0
	while(i<num
		sprintf(inst_name "dut_d_%L" i)
		dbCreateInst(dut switch_master inst_name list(2*i 0) "R0" ) 	;d_cellView d_master t_name l_point t_orient [ x_numInst]
		i = i+1
	)
	
	input_pin = dbOpenCellViewByType("basic" "ipin" "symbol")
	output_pin=dbOpenCellViewByType("basic" "opin" "symbol")
	x=0
	y=1
	
	foreach( port dut_ref~>portOrder
		if(port=="OUT" then 
			;output port
			inst = dbCreateInst(dut output_pin nil x:y "R0" 1)
			pinType="output"
		else
			;input port
			inst = dbCreateInst(dut input_pin nil x:y "R0" 1)
			pinType="input"
		)
		inst~>purpose = "pin"
		net = dbCreateNet(dut port nil)
		if(net==nil then net=dbMakeNet(dut port))
		term = dbCreateTerm(net port pinType)
		pin = dbCreatePin(net inst)
		y = y+0.2
		;line = dbCreateLine(dut list(x y) list(x+0.2 y))~>net=net ;not sure
	)
	;testbench
	tb_ref=dbOpenCellViewByType("rail_tb1" tb_cell "schematic")
	tb=dbOpenCellViewByType("demo" tb_cell "schematic")
	if(tb==nil then  tb=dbCopyCellView(tb_ref "demo" tb_cell "schematic"))
	foreach(instance tb~>instances
		if(instance~>cellName==cell then
			instance~>master = dut_symbol
		else
		)
	)
	;techBindTechFile(ddGetObj(library_name) "tsmcN65" techGetDefaultTechName() t) 
	
)