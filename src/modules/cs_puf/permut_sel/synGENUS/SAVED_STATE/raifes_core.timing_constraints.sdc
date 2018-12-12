# ####################################################################

#  Created by Genus(TM) Synthesis Solution 16.21-s018_1 on Mon Oct 15 14:56:24 +0200 2018

# ####################################################################

set sdc_version 1.7

set_units -capacitance 1000.0fF
set_units -time 1000.0ps

# Set the current design
current_design raifes_core

create_clock -name "SYSCLK" -add -period 66.0 -waveform {0.0 33.0} [get_ports clk]
set_load -pin_load 1.1 [get_ports sdo]
set_load -pin_load 1.1 [get_ports {imem_haddr[31]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[30]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[29]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[28]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[27]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[26]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[25]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[24]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[23]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[22]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[21]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[20]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[19]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[18]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[17]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[16]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[15]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[14]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[13]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[12]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[11]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[10]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[9]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[8]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[7]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[6]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[5]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[4]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[3]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[2]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[1]}]
set_load -pin_load 1.1 [get_ports {imem_haddr[0]}]
set_load -pin_load 1.1 [get_ports imem_hwrite]
set_load -pin_load 1.1 [get_ports {imem_hsize[2]}]
set_load -pin_load 1.1 [get_ports {imem_hsize[1]}]
set_load -pin_load 1.1 [get_ports {imem_hsize[0]}]
set_load -pin_load 1.1 [get_ports {imem_hburst[2]}]
set_load -pin_load 1.1 [get_ports {imem_hburst[1]}]
set_load -pin_load 1.1 [get_ports {imem_hburst[0]}]
set_load -pin_load 1.1 [get_ports imem_hmastlock]
set_load -pin_load 1.1 [get_ports {imem_hprot[3]}]
set_load -pin_load 1.1 [get_ports {imem_hprot[2]}]
set_load -pin_load 1.1 [get_ports {imem_hprot[1]}]
set_load -pin_load 1.1 [get_ports {imem_hprot[0]}]
set_load -pin_load 1.1 [get_ports {imem_htrans[1]}]
set_load -pin_load 1.1 [get_ports {imem_htrans[0]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[31]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[30]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[29]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[28]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[27]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[26]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[25]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[24]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[23]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[22]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[21]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[20]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[19]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[18]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[17]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[16]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[15]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[14]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[13]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[12]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[11]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[10]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[9]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[8]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[7]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[6]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[5]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[4]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[3]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[2]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[1]}]
set_load -pin_load 1.1 [get_ports {imem_hwdata[0]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[31]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[30]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[29]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[28]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[27]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[26]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[25]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[24]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[23]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[22]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[21]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[20]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[19]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[18]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[17]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[16]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[15]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[14]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[13]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[12]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[11]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[10]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[9]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[8]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[7]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[6]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[5]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[4]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[3]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[2]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[1]}]
set_load -pin_load 1.1 [get_ports {dmem_haddr[0]}]
set_load -pin_load 1.1 [get_ports dmem_hwrite]
set_load -pin_load 1.1 [get_ports {dmem_hsize[2]}]
set_load -pin_load 1.1 [get_ports {dmem_hsize[1]}]
set_load -pin_load 1.1 [get_ports {dmem_hsize[0]}]
set_load -pin_load 1.1 [get_ports {dmem_hburst[2]}]
set_load -pin_load 1.1 [get_ports {dmem_hburst[1]}]
set_load -pin_load 1.1 [get_ports {dmem_hburst[0]}]
set_load -pin_load 1.1 [get_ports dmem_hmastlock]
set_load -pin_load 1.1 [get_ports {dmem_hprot[3]}]
set_load -pin_load 1.1 [get_ports {dmem_hprot[2]}]
set_load -pin_load 1.1 [get_ports {dmem_hprot[1]}]
set_load -pin_load 1.1 [get_ports {dmem_hprot[0]}]
set_load -pin_load 1.1 [get_ports {dmem_htrans[1]}]
set_load -pin_load 1.1 [get_ports {dmem_htrans[0]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[31]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[30]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[29]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[28]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[27]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[26]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[25]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[24]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[23]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[22]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[21]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[20]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[19]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[18]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[17]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[16]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[15]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[14]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[13]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[12]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[11]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[10]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[9]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[8]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[7]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[6]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[5]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[4]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[3]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[2]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[1]}]
set_load -pin_load 1.1 [get_ports {dmem_hwdata[0]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[31]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[30]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[29]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[28]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[27]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[26]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[25]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[24]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[23]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[22]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[21]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[20]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[19]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[18]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[17]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[16]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[15]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[14]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[13]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[12]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[11]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[10]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[9]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[8]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[7]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[6]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[5]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[4]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[3]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[2]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[1]}]
set_load -pin_load 1.1 [get_ports {dmi_rdata[0]}]
set_load -pin_load 1.1 [get_ports dmi_error]
set_load -pin_load 1.1 [get_ports dmi_dm_busy]
set_load -pin_load 1.1 [get_ports {dm_state[3]}]
set_load -pin_load 1.1 [get_ports {dm_state[2]}]
set_load -pin_load 1.1 [get_ports {dm_state[1]}]
set_load -pin_load 1.1 [get_ports {dm_state[0]}]
group_path -name cg_enable_group_SYSCLK -through [list \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST1/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST2/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST3/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST4/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST5/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST6/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST7/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST8/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST9/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST14/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST15/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST16/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST17/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST18/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST19/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST20/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST21/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST22/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST23/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST24/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST25/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST26/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST27/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST28/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST29/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST30/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST31/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST32/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST33/enable]  \
  [get_pins pipeline/ctrl/ClkGate_RC_CG_HIER_INST35/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST36/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST37/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST38/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST39/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST40/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST41/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST42/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST43/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST44/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST45/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST46/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST47/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST48/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST49/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST50/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST51/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST52/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST53/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST54/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST55/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST56/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST57/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST58/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST59/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST60/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST61/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST62/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST63/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST64/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST65/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST66/enable]  \
  [get_pins pipeline/ClkGate_RC_CG_HIER_INST10/enable]  \
  [get_pins pipeline/ClkGate_RC_CG_HIER_INST12/enable]  \
  [get_pins pipeline/ClkGate_RC_CG_HIER_INST13/enable]  \
  [get_pins ClkGate_RC_CG_HIER_INST0/enable]  \
  [get_pins ClkGate_RC_CG_HIER_INST0/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST1/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST2/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST3/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST4/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST5/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST6/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST7/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST8/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST9/enable]  \
  [get_pins pipeline/ClkGate_RC_CG_HIER_INST10/enable]  \
  [get_pins pipeline/ClkGate_RC_CG_HIER_INST12/enable]  \
  [get_pins pipeline/ClkGate_RC_CG_HIER_INST13/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST14/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST15/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST16/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST17/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST18/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST19/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST20/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST21/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST22/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST23/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST24/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST25/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST26/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST27/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST28/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST29/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST30/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST31/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST32/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST33/enable]  \
  [get_pins pipeline/ctrl/ClkGate_RC_CG_HIER_INST35/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST36/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST37/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST38/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST39/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST40/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST41/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST42/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST43/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST44/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST45/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST46/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST47/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST48/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST49/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST50/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST51/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST52/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST53/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST54/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST55/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST56/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST57/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST58/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST59/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST60/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST61/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST62/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST63/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST64/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST65/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST66/enable]  \
  [get_pins ClkGate_RC_CG_HIER_INST0/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST1/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST2/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST3/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST4/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST5/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST6/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST7/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST8/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST9/enable]  \
  [get_pins pipeline/ClkGate_RC_CG_HIER_INST10/enable]  \
  [get_pins pipeline/ClkGate_RC_CG_HIER_INST12/enable]  \
  [get_pins pipeline/ClkGate_RC_CG_HIER_INST13/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST14/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST15/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST16/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST17/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST18/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST19/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST20/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST21/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST22/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST23/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST24/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST25/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST26/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST27/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST28/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST29/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST30/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST31/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST32/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST33/enable]  \
  [get_pins pipeline/ctrl/ClkGate_RC_CG_HIER_INST35/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST36/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST37/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST38/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST39/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST40/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST41/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST42/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST43/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST44/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST45/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST46/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST47/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST48/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST49/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST50/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST51/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST52/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST53/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST54/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST55/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST56/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST57/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST58/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST59/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST60/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST61/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST62/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST63/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST64/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST65/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST66/enable]  \
  [get_pins pipeline/ClkGate_RC_CG_DECLONE_HIER_INST/enable]  \
  [get_pins ClkGate_RC_CG_HIER_INST0/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST1/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST2/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST3/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST4/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST5/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST6/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST7/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST8/enable]  \
  [get_pins debug_module/ClkGate_RC_CG_HIER_INST9/enable]  \
  [get_pins pipeline/ClkGate_RC_CG_HIER_INST10/enable]  \
  [get_pins pipeline/ClkGate_RC_CG_HIER_INST12/enable]  \
  [get_pins pipeline/ClkGate_RC_CG_HIER_INST13/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST14/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST15/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST16/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST17/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST18/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST19/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST20/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST21/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST22/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST23/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST24/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST25/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST26/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST27/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST28/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST29/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST30/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST31/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST32/enable]  \
  [get_pins pipeline/csr/ClkGate_RC_CG_HIER_INST33/enable]  \
  [get_pins pipeline/ctrl/ClkGate_RC_CG_HIER_INST35/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST36/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST37/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST38/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST39/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST40/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST41/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST42/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST43/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST44/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST45/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST46/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST47/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST48/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST49/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST50/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST51/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST52/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST53/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST54/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST55/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST56/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST57/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST58/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST59/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST60/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST61/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST62/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST63/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST64/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST65/enable]  \
  [get_pins pipeline/regfile/ClkGate_RC_CG_HIER_INST66/enable]  \
  [get_pins pipeline/ClkGate_RC_CG_DECLONE_HIER_INST/enable] ]
set_clock_gating_check -setup 0.0 
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports sdo]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[31]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[30]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[29]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[28]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[27]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[26]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[25]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[24]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[23]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[22]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[21]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[20]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[19]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[18]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[17]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[16]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[15]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[14]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[13]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[12]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[11]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[10]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[9]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[8]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[7]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[6]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[5]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[4]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[3]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[2]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[1]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_haddr[0]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports imem_hwrite]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hsize[2]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hsize[1]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hsize[0]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hburst[2]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hburst[1]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hburst[0]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports imem_hmastlock]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hprot[3]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hprot[2]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hprot[1]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hprot[0]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_htrans[1]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_htrans[0]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[31]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[30]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[29]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[28]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[27]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[26]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[25]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[24]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[23]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[22]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[21]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[20]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[19]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[18]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[17]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[16]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[15]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {imem_hwdata[14]}]
set_max_transition 2.75 [current_design]
set_max_capacitance 2.5 [current_design]
set_input_transition 2.5 [get_ports reset]
set_driving_cell -lib_cell BF -library L035dc -pin "O" [get_ports clk]
set_input_transition 2.5 [get_ports sdi]
set_input_transition 2.5 [get_ports sen]
set_input_transition 2.5 [get_ports {ext_interrupts[23]}]
set_input_transition 2.5 [get_ports {ext_interrupts[22]}]
set_input_transition 2.5 [get_ports {ext_interrupts[21]}]
set_input_transition 2.5 [get_ports {ext_interrupts[20]}]
set_input_transition 2.5 [get_ports {ext_interrupts[19]}]
set_input_transition 2.5 [get_ports {ext_interrupts[18]}]
set_input_transition 2.5 [get_ports {ext_interrupts[17]}]
set_input_transition 2.5 [get_ports {ext_interrupts[16]}]
set_input_transition 2.5 [get_ports {ext_interrupts[15]}]
set_input_transition 2.5 [get_ports {ext_interrupts[14]}]
set_input_transition 2.5 [get_ports {ext_interrupts[13]}]
set_input_transition 2.5 [get_ports {ext_interrupts[12]}]
set_input_transition 2.5 [get_ports {ext_interrupts[11]}]
set_input_transition 2.5 [get_ports {ext_interrupts[10]}]
set_input_transition 2.5 [get_ports {ext_interrupts[9]}]
set_input_transition 2.5 [get_ports {ext_interrupts[8]}]
set_input_transition 2.5 [get_ports {ext_interrupts[7]}]
set_input_transition 2.5 [get_ports {ext_interrupts[6]}]
set_input_transition 2.5 [get_ports {ext_interrupts[5]}]
set_input_transition 2.5 [get_ports {ext_interrupts[4]}]
set_input_transition 2.5 [get_ports {ext_interrupts[3]}]
set_input_transition 2.5 [get_ports {ext_interrupts[2]}]
set_input_transition 2.5 [get_ports {ext_interrupts[1]}]
set_input_transition 2.5 [get_ports {ext_interrupts[0]}]
set_input_transition 2.5 [get_ports {imem_hrdata[31]}]
set_input_transition 2.5 [get_ports {imem_hrdata[30]}]
set_input_transition 2.5 [get_ports {imem_hrdata[29]}]
set_input_transition 2.5 [get_ports {imem_hrdata[28]}]
set_input_transition 2.5 [get_ports {imem_hrdata[27]}]
set_input_transition 2.5 [get_ports {imem_hrdata[26]}]
set_input_transition 2.5 [get_ports {imem_hrdata[25]}]
set_input_transition 2.5 [get_ports {imem_hrdata[24]}]
set_input_transition 2.5 [get_ports {imem_hrdata[23]}]
set_input_transition 2.5 [get_ports {imem_hrdata[22]}]
set_input_transition 2.5 [get_ports {imem_hrdata[21]}]
set_input_transition 2.5 [get_ports {imem_hrdata[20]}]
set_input_transition 2.5 [get_ports {imem_hrdata[19]}]
set_input_transition 2.5 [get_ports {imem_hrdata[18]}]
set_input_transition 2.5 [get_ports {imem_hrdata[17]}]
set_input_transition 2.5 [get_ports {imem_hrdata[16]}]
set_input_transition 2.5 [get_ports {imem_hrdata[15]}]
set_input_transition 2.5 [get_ports {imem_hrdata[14]}]
set_input_transition 2.5 [get_ports {imem_hrdata[13]}]
set_input_transition 2.5 [get_ports {imem_hrdata[12]}]
set_input_transition 2.5 [get_ports {imem_hrdata[11]}]
set_input_transition 2.5 [get_ports {imem_hrdata[10]}]
set_input_transition 2.5 [get_ports {imem_hrdata[9]}]
set_input_transition 2.5 [get_ports {imem_hrdata[8]}]
set_input_transition 2.5 [get_ports {imem_hrdata[7]}]
set_input_transition 2.5 [get_ports {imem_hrdata[6]}]
set_input_transition 2.5 [get_ports {imem_hrdata[5]}]
set_input_transition 2.5 [get_ports {imem_hrdata[4]}]
set_input_transition 2.5 [get_ports {imem_hrdata[3]}]
set_input_transition 2.5 [get_ports {imem_hrdata[2]}]
set_input_transition 2.5 [get_ports {imem_hrdata[1]}]
set_input_transition 2.5 [get_ports {imem_hrdata[0]}]
set_input_transition 2.5 [get_ports imem_hready]
set_input_transition 2.5 [get_ports {imem_hresp[0]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[31]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[30]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[29]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[28]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[27]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[26]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[25]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[24]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[23]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[22]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[21]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[20]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[19]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[18]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[17]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[16]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[15]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[14]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[13]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[12]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[11]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[10]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[9]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[8]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[7]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[6]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[5]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[4]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[3]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[2]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[1]}]
set_input_transition 2.5 [get_ports {dmem_hrdata[0]}]
set_input_transition 2.5 [get_ports dmem_hready]
set_input_transition 2.5 [get_ports {dmem_hresp[0]}]
set_input_transition 2.5 [get_ports {dmi_addr[6]}]
set_input_transition 2.5 [get_ports {dmi_addr[5]}]
set_input_transition 2.5 [get_ports {dmi_addr[4]}]
set_input_transition 2.5 [get_ports {dmi_addr[3]}]
set_input_transition 2.5 [get_ports {dmi_addr[2]}]
set_input_transition 2.5 [get_ports {dmi_addr[1]}]
set_input_transition 2.5 [get_ports {dmi_addr[0]}]
set_input_transition 2.5 [get_ports dmi_en]
set_input_transition 2.5 [get_ports {dmi_wdata[31]}]
set_input_transition 2.5 [get_ports {dmi_wdata[30]}]
set_input_transition 2.5 [get_ports {dmi_wdata[29]}]
set_input_transition 2.5 [get_ports {dmi_wdata[28]}]
set_input_transition 2.5 [get_ports {dmi_wdata[27]}]
set_input_transition 2.5 [get_ports {dmi_wdata[26]}]
set_input_transition 2.5 [get_ports {dmi_wdata[25]}]
set_input_transition 2.5 [get_ports {dmi_wdata[24]}]
set_input_transition 2.5 [get_ports {dmi_wdata[23]}]
set_input_transition 2.5 [get_ports {dmi_wdata[22]}]
set_input_transition 2.5 [get_ports {dmi_wdata[21]}]
set_input_transition 2.5 [get_ports {dmi_wdata[20]}]
set_input_transition 2.5 [get_ports {dmi_wdata[19]}]
set_input_transition 2.5 [get_ports {dmi_wdata[18]}]
set_input_transition 2.5 [get_ports {dmi_wdata[17]}]
set_input_transition 2.5 [get_ports {dmi_wdata[16]}]
set_input_transition 2.5 [get_ports {dmi_wdata[15]}]
set_input_transition 2.5 [get_ports {dmi_wdata[14]}]
set_input_transition 2.5 [get_ports {dmi_wdata[13]}]
set_input_transition 2.5 [get_ports {dmi_wdata[12]}]
set_input_transition 2.5 [get_ports {dmi_wdata[11]}]
set_input_transition 2.5 [get_ports {dmi_wdata[10]}]
set_input_transition 2.5 [get_ports {dmi_wdata[9]}]
set_input_transition 2.5 [get_ports {dmi_wdata[8]}]
set_input_transition 2.5 [get_ports {dmi_wdata[7]}]
set_input_transition 2.5 [get_ports {dmi_wdata[6]}]
set_input_transition 2.5 [get_ports {dmi_wdata[5]}]
set_input_transition 2.5 [get_ports {dmi_wdata[4]}]
set_input_transition 2.5 [get_ports {dmi_wdata[3]}]
set_input_transition 2.5 [get_ports {dmi_wdata[2]}]
set_input_transition 2.5 [get_ports {dmi_wdata[1]}]
set_input_transition 2.5 [get_ports {dmi_wdata[0]}]
set_input_transition 2.5 [get_ports dmi_wen]
set_ideal_network [get_ports reset]
set_dont_use [get_lib_cells DEL20]
set_dont_use [get_lib_cells DEL10]
set_dont_use [get_lib_cells DEL3RC]
set_dont_use [get_lib_cells DEL_10NS_RC]
set_dont_use [get_lib_cells DEL_20NS_RC]
set_dont_use [get_lib_cells DEL_30NS_RC]
set_dont_use [get_lib_cells DEL_50NS_RC]
set_dont_use [get_lib_cells SCHMTT]
set_dont_use [get_lib_cells SCHMTTE]
set_dont_use [get_lib_cells SCHMTT25]
set_dont_use [get_lib_cells SCHMTT25E]
set_dont_use [get_lib_cells SCHMTT50]
set_dont_use [get_lib_cells SCHMTT50E]
set_dont_use false [get_lib_cells TLATX3]
set_clock_uncertainty -setup 5.0 [get_clocks SYSCLK]
set_clock_uncertainty -hold 1.0 [get_clocks SYSCLK]
