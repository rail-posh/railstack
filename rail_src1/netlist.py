import re
import math
from os.path import expanduser

def calculate_parameter(result_file_path, Ron_usr):
	with open(result_file_path,"r") as f:
		for line in f:
			if re.search('[a-zA-z0-9]', line):
				Ron_str = line.split()[0] 
				Roff_str = line.split()[1]
	
				Ron = covert_unit(Ron_str)
				Roff = covert_unit(Roff_str)
	f.closed
	cell_num = math.ceil(Ron/float(Ron_usr));
	return int(cell_num)

	
#create digital netlist
#create .xil config file
def create_verilog_netlist(cell_num, cell):
	home = expanduser("~")
	connection = "("
	netlist_file_path = home+"/simulation/icc/netlist"
	tmp_file_path = home+"/simulation/tmpc/tmpout"
	with open(netlist_file_path,"w") as netlist:
		netlist.write("module dut  (\n")
		with open(tmp_file_path,"r") as tmp:
			firstline = 1 
			for line in tmp:
				direction = line.split()[0]
				name = line.split()[1]
				if firstline == 1:
					netlist.write("\t"+line)
					connection = connection + "."+name+"("+name+")"
					firstline = 0
				else:
					netlist.write("\t,"+line)
					connection = connection + ",."+name+"("+name+")"
			connection = connection + ");"

			tmp.closed
		netlist.write(");\n")
		for i in range(cell_num):
			netlist.write(cell+" "+cell+str(i)+connection+"\n")
		netlist.write("endmodule\n")
		netlist.closed
		
def create_option_xil(lib_name):
	home = expanduser("~")
	xil_file_path = home+"/simulation/icc/option.xil"
	with open(xil_file_path,"w") as xil:
		xil.write("dest_sch_lib := "+lib_name+"\n")
		xil.write("ref_lib_list := rail65,basic,tcbn65lp\n")
		xil.write("import_if_exists := 1\n")
		xil.write("import_cells := 0\n")
		xil.write("import_lib_cells := 0\n")
		xil.write("schematic_view_name := schematic\n")
		xil.write("functional_view_name := functional\n")
		xil.write("netlist_view_name := netlist\n")
		xil.write("symbol_view_name := symbol\n")
		xil.write("overwrite_symbol := 1\n")
		xil.write("log_file_name := ./verilogIn.log\n")
		xil.write("map_file_name := ./verilogIn.map.table\n")
		xil.write("work_area := "+home+"/simulation/\n")
		xil.write("power_net := DVDDX\n")
		xil.write("ground_net := DVSSX\n")
	xil.closed




def covert_unit(str):
	if re.search('K', str):
		return float(str[:len(str)-1]) * 1000
	elif re.search('G', str):
		return float(str[:len(str)-1]) * 1000000000
	else:
		return float(str)
