#####################################################################
#
# Init setup file
# Created by Genus(TM) Synthesis Solution on 10/20/2018 10:53:40
#
#####################################################################


read_mmmc ./SAVED_STATE/permut_sel.mmmc.tcl

read_physical -lef {/sw/ims_db/lib/L035/l035v0v6dc/.lib/layout/L035dc.lef}

read_netlist ./SAVED_STATE/permut_sel.v

init_design -skip_sdc_read
