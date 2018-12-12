# ####################################################################

#  Created by Genus(TM) Synthesis Solution 17.22-s017_1 on Mon Nov 19 14:07:01 CET 2018

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000.0fF
set_units -time 1000.0ps

# Set the current design
current_design permut_sel_aio

create_clock -name "SYSCLK" -period 66.0 -waveform {0.0 33.0} [get_ports clk]
set_load -pin_load 1.1 [get_ports ready]
set_load -pin_load 1.1 [get_ports init]
set_load -pin_load 1.1 [get_ports amp_enable]
set_load -pin_load 1.1 [get_ports {cout[7]}]
set_load -pin_load 1.1 [get_ports {cout[6]}]
set_load -pin_load 1.1 [get_ports {cout[5]}]
set_load -pin_load 1.1 [get_ports {cout[4]}]
set_load -pin_load 1.1 [get_ports {cout[3]}]
set_load -pin_load 1.1 [get_ports {cout[2]}]
set_load -pin_load 1.1 [get_ports {cout[1]}]
set_load -pin_load 1.1 [get_ports {cout[0]}]
set_clock_gating_check -setup 0.0 
set_max_transition 2.75 [current_design]
set_max_capacitance 2.5 [current_design]
set_driving_cell -lib_cell BF -library L035dc -pin "O" [get_ports clk]
set_input_transition 2.5 [get_ports resn]
set_input_transition 2.5 [get_ports en]
set_input_transition 2.5 [get_ports {sel[15]}]
set_input_transition 2.5 [get_ports {sel[14]}]
set_input_transition 2.5 [get_ports {sel[13]}]
set_input_transition 2.5 [get_ports {sel[12]}]
set_input_transition 2.5 [get_ports {sel[11]}]
set_input_transition 2.5 [get_ports {sel[10]}]
set_input_transition 2.5 [get_ports {sel[9]}]
set_input_transition 2.5 [get_ports {sel[8]}]
set_input_transition 2.5 [get_ports {sel[7]}]
set_input_transition 2.5 [get_ports {sel[6]}]
set_input_transition 2.5 [get_ports {sel[5]}]
set_input_transition 2.5 [get_ports {sel[4]}]
set_input_transition 2.5 [get_ports {sel[3]}]
set_input_transition 2.5 [get_ports {sel[2]}]
set_input_transition 2.5 [get_ports {sel[1]}]
set_input_transition 2.5 [get_ports {sel[0]}]
set_dont_use [get_lib_cells L035dc/DEL20]
set_dont_use [get_lib_cells L035dc/DEL10]
set_dont_use [get_lib_cells L035dc/DEL3RC]
set_dont_use [get_lib_cells L035dc/DEL_10NS_RC]
set_dont_use [get_lib_cells L035dc/DEL_20NS_RC]
set_dont_use [get_lib_cells L035dc/DEL_30NS_RC]
set_dont_use [get_lib_cells L035dc/DEL_50NS_RC]
set_dont_use [get_lib_cells L035dc/SCHMTT]
set_dont_use [get_lib_cells L035dc/SCHMTTE]
set_dont_use [get_lib_cells L035dc/SCHMTT25]
set_dont_use [get_lib_cells L035dc/SCHMTT25E]
set_dont_use [get_lib_cells L035dc/SCHMTT50]
set_dont_use [get_lib_cells L035dc/SCHMTT50E]
set_dont_use [get_lib_cells L035dc/TLATX3]
set_clock_uncertainty -setup 5.0 [get_clocks SYSCLK]
set_clock_uncertainty -hold 1.0 [get_clocks SYSCLK]
