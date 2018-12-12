#####################################################################
#
# Init setup file
# Created by Genus(TM) Synthesis Solution on 11/19/2018 14:07:01
#
#####################################################################


read_mmmc ../prINNO/INNO/permut_sel_aio.mmmc.tcl

read_physical -lef {/sw/ims_db/lib/L035/l035v0v6dc/.lib/layout/L035dc.lef}

read_netlist ../prINNO/INNO/permut_sel_aio.v

init_design
