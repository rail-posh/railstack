import os
import re
import sys
import argparse
from netlist import * 
from os.path import expanduser
from sys import argv

parser = argparse.ArgumentParser()

def readfile(argv):
	if 'run_ocean' in argv:
		os.system("ocean < ocean_source/netlist/spectre0.ocn")

	with open("./ocean_source/psf/outvalue","r") as f:
		for line in f:
			if re.search('[a-zA-z0-9]', line):
				delay = line

	f.closed
	print(delay)


def read_config(argv):
	#default netlist path
	home = expanduser("~")
	cell = "rail_t_gate"
	Ron_usr = 1000
	lib_name = "demo"
	netlist_path = home+"/simulation/icc/netlist"
	
	while argv:
		if argv[0] == '-libname':
			lib_name = argv[1]
			argv = argv[2:]
		elif argv[0] == '-v':
			netlist_path = argv[1]
			argv = argv[2:]
		else:
			argv = argv[1:]
			
		
	#with open("./rail_script1/config.txt","r") as f:
	#	for line in f:
	#		if line.split()[0]=="component_cell":
	#			cell = line.split()[1]
	#		elif line.split()[0]=="Ron":
	#			Ron_usr = line.split()[1]
	#		elif line.split()[0]=="lib_name":
	#			lib_name = line.split()[1]
	#		elif line.split()[0]=="netlist":
	#			netlist_path = line.split()[1]
				

	#f.closed
	return cell, Ron_usr, lib_name, netlist_path
			

def run_simulation(cell, Ron_usr):
	#os.system("virtuoso -nograph -restore ./rail_src1/run.txt -log rail.log")
	
	os.system("virtuoso -nograph -restore ./rail_src1/run.txt")

	home = expanduser("~")
	result_file_path= home+"/simulation/tb_"+cell+"/spectre/schematic/psf/result"
	cell_num = calculate_parameter(result_file_path, Ron_usr)
	return cell_num

def create_library():
	os.system("virtuoso -nograph -restore ./rail_src1/create_library.txt")
	
def run_icc(netlist_path):
	home = expanduser("~")
	xil_path = home+"/simulation/icc/option.xil"
	command  = "ihdl "+netlist_path+" -param "+xil_path
	print("**RAIL** "+ command)
	os.system(command)
	
def run_drc():
	os.system("calibre -gui -drc -runset drc.runset -batch")

def run_lvs():
	os.system("calibre -gui -lvs -runset lvs.runset -batch")
def run_pex():
	os.system("calibre -gui -pex -runset pex.runset -batch")

if __name__=='__main__':
	cell, Ron_usr, lib_name, netlist_path = read_config(argv)
	#cell_num = run_simulation(cell, Ron_usr)
	#create_verilog_netlist(cell_num, cell)
	
	#post netlist
	create_library()
	create_option_xil(lib_name)
	run_icc(netlist_path)
	#run_drc()
	#run_lvs()
	#run_pex()
	#readfile(sys.argv)
