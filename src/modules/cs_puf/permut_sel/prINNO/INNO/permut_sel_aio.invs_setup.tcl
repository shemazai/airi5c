#####################################################################
#
# Innovus setup file
# Created by Genus(TM) Synthesis Solution on 11/19/2018 14:07:01
#
# This file can only be run in Innovus Common UI mode.
#
#####################################################################


# Design Import
###########################################################
## Reading FlowKit settings file
source ../prINNO/INNO/permut_sel_aio.flowkit_settings.tcl

source ../prINNO/INNO/permut_sel_aio.invs_init.tcl

# Reading metrics file
######################
read_metric -id current ../prINNO/INNO/permut_sel_aio.metrics.json 

## Reading Attributes file
source ../prINNO/INNO/permut_sel_aio.attrs.tcl


# Mode Setup
###########################################################
source ../prINNO/INNO/permut_sel_aio.mode

# Reading write_name_mapping file
#################################
if {[is_attribute -obj_type port original_name] && [is_attribute -obj_type pin original_name] && [is_attribute -obj_type pin is_phase_inverted]} {
  source ../prINNO/INNO/permut_sel_aio.wnm_attrs.tcl
}

eval_enc { set edi_pe::pegConsiderMacroLayersUnblocked 1 }
eval_enc { set edi_pe::pegPreRouteWireWidthBasedDensityCalModel 1 }
