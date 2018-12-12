#####################################################################
#
# Init setup file
# Created by Genus(TM) Synthesis Solution on 10/15/2018 14:56:25
#
#####################################################################


read_mmmc ./SAVED_STATE/raifes_core.mmmc.tcl

read_physical -lef {/sw/ims_db/lib/L035/l035v0v6dc/.lib/layout/L035dc.lef}

read_netlist ./SAVED_STATE/raifes_core.v

init_design -skip_sdc_read
