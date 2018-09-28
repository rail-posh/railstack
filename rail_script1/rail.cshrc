source /home/lab.apps/vlsiapps/cshrc/hspice.cshrc


#cadence
source /home/lab.apps/vlsiapps/cshrc/cadence_ic.cshrc
setenv SPECTRE_DEFAULTS -E
setenv CDS_LOAD_ENV CWDElseHome
setenv CDS_AUTO_64BIT ALL
setenv PSF_WRITE_CHUNK_MODE_ON true
setenv ASSURAHOME /home/lab.apps/vlsiapps/assura/current

#spectre path
set path = (/homes/lab.apps/vlsiapps/spectre/current/tools.lnx86/bin/ $path)

#Library compiler
set path = (/homes/lab.apps/vlsiapps/library_compiler/H-2013.03-SP5-2/bin $path)

#ADS
#source /usr/nikola/groups/vlsi/pkgs/ads/ads.cshrc

#Calibre
source /home/lab.apps/vlsiapps/cshrc/calibre.cshrc

######## MMSIM ############
#source /home/lab.apps/vlsiapps/cshrc/cadence_mmsim.cshrc
###########################

#######synopysis##########
source /home/lab.apps/vlsiapps/cshrc/synopsys_syn.cshrc
##########################

#NCverilog
source /home/lab.apps/vlsiapps/cshrc/cadence_ius.cshrc

#Source modelsim - run with 'vsim'
#source /home/lab.apps/vlsiapps/cshrc/modelsim.cshrc

#Source synopsis synthesis
source /home/lab.apps/vlsiapps/cshrc/synopsys_syn.cshrc
source /home/lab.apps/vlsiapps/cshrc/encounter.cshrc
#encounter place and route + cadence RTC compiler
#source /home/lab.apps/vlsiapps/cshrc/soc.cshrc
source /home/lab.apps/vlsiapps/cshrc/milkyway.cshrc

set path = (/homes/lab.apps/vlsiapps/milkyway/I-2013.12-SP2/bin/AMD.64 $path)
set path = (/vaps/icc/current/bin $path)
set path = (/home/lab.apps/vlsiapps/library_compiler/H-2013.03-SP5-2/bin $path)
set path = ($path /home/lab.apps/vlsiapps/primetime/current/bin)

#python
set path = (~/python3/bin $path)
set path = (~/python/bin $path)

source /home/lab.apps/vlsiapps/cshrc/licenses_new.cshrc

#rail setup
setenv modelFile /home/lab.apps/vlsiapps/kits/tsmc/N65LP/tsmcN65/../models/spectre/toplevel.scs
setenv session tt_lib
