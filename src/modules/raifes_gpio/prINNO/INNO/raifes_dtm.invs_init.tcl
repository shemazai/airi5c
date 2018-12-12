#####################################################################
#
# Init setup file
# Created by Genus(TM) Synthesis Solution on 11/15/2018 10:55:00
#
#####################################################################


read_mmmc ../prINNO/INNO/raifes_dtm.mmmc.tcl

read_physical -lef {/sw/ims_db/lib/L035/l035v0v6dc/.lib/layout/L035dc.lef}

read_netlist ../prINNO/INNO/raifes_dtm.v

init_design
