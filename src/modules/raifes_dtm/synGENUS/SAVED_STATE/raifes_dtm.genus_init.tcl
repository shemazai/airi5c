#####################################################################
#
# Init setup file
# Created by Genus(TM) Synthesis Solution on 11/15/2018 10:54:56
#
#####################################################################


read_mmmc ./SAVED_STATE/raifes_dtm.mmmc.tcl

read_physical -lef {/sw/ims_db/lib/L035/l035v0v6dc/.lib/layout/L035dc.lef}

read_netlist ./SAVED_STATE/raifes_dtm.v

init_design -skip_sdc_read
