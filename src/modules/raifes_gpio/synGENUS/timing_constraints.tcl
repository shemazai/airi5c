#-----------------------------------------------------------------------------------------------------------
#-------------------------------------- CLK Settings in pico seconds ----------------------------------------
#-----------------------------------------------------------------------------------------------------------
set CLK_SYSTEM tck
#set CLK_TST_INTERFACE clk
set CLK_SPEED_MHz 15.0

set MAX_TRANSITIONS 2.75
set INPUT_TRANSITIONS 2.5
set CLK_TRANSITIONS 2.5
set MAX_NET_CAP_LOAD 2.5
set CLK_SETUP_UNCERT 5
set CLK_HOLD_UNCERT 1

set OUTPUT_PORT_LOAD 1.1

#-----------------------------------------------------------------------------------------------------------
#-------------------------------------------- Timing Constraints -------------------------------------------
#-----------------------------------------------------------------------------------------------------------
set PERIOD_IN_ns [expr "int(1 / ($CLK_SPEED_MHz) * 1000)"]

set_units -capacitance pF -time ns

create_clock -period $PERIOD_IN_ns -domain SYSTEM -name SYSCLK [get_ports $CLK_SYSTEM]
#create_clock -period 66 -domain TSTCTRL -name TSTCLK [get_ports $CLK_TST_INTERFACE]

#create_generated_clock -name INT_CLK_6M78 -edges {1 3 5}		-source [get_ports clk_13m56_i]   [get_pins I_LOGIC/I_CLK_RES/CLK6M78]
#create_generated_clock -name INT_CLK_3M39 -edges {1 3 9}    	-source [get_ports clk_13m56_i]   [get_pins I_LOGIC/I_CLK_RES/CLK3M39] 
#create_generated_clock -name INT_CLK_1M695 -edges {1 3 17}    -source [get_ports clk_13m56_i]   [get_pins I_LOGIC/I_CLK_RES/CLK1M695] 

set_load $OUTPUT_PORT_LOAD -pin_load [all_outputs]
set_driving_cell -lib_cell BF [all_inputs]
set_max_transition $MAX_TRANSITIONS [current_design]
#set_clock_transition $CLK_TRANSITIONS SYSCLK
set_input_transition $INPUT_TRANSITIONS [all_inputs -no_clock]
set_max_capacitance $MAX_NET_CAP_LOAD [current_design]

set_clock_uncertainty -setup $CLK_SETUP_UNCERT SYSCLK
set_clock_uncertainty -hold $CLK_HOLD_UNCERT SYSCLK

set_clock_uncertainty -setup $CLK_SETUP_UNCERT TSTCLK
set_clock_uncertainty -hold $CLK_HOLD_UNCERT TSTCLK

#set_ideal_network [get_ports tif_reset_n_i]
set_ideal_network [get_ports reset]

#set_false_path -from TSTCLK -to SYSCLK
#set_false_path -from SYSCLK -to TSTCLK

set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports tdo]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports tdi]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports tms]


set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[31]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[30]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[29]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[28]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[27]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[26]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[25]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[24]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[23]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[22]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[21]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[20]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[19]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[18]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[17]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[16]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[15]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[14]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[13]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[12]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[11]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[10]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[9]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[8]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[7]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[6]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[5]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[4]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[3]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[2]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[1]}]
set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_rdata[0]}]

set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_error}]

set_input_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_dm_busy}]


set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_addr[6]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_addr[5]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_addr[4]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_addr[3]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_addr[2]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_addr[1]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_addr[0]}]

set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[31]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[30]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[29]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[28]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[27]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[26]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[25]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[24]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[23]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[22]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[21]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[20]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[19]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[18]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[17]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[16]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[15]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[14]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[13]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[12]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[11]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[10]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[9]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[8]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[7]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[6]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[5]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[4]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[3]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[2]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[1]}]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports {dmi_wdata[0]}]

set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports dmi_wen]
set_output_delay -clock [get_clocks SYSCLK] -add_delay -max 10.0 [get_ports dmi_en]
