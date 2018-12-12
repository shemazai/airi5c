######################################################################

# Created by Genus(TM) Synthesis Solution 17.22-s017_1 on Sat Oct 20 10:53:39 CEST 2018

# This file contains the RC script for design:permut_sel

######################################################################

if {! [is_attribute wlec_internal_to_write_lec_db_for_invocation -obj_type root]} {define_attribute -obj_type root -category lec -data_type string -help_string {Capture internal write_lec variables.} wlec_internal_to_write_lec_db_for_invocation}
if {! [is_attribute wlec_internal_to_write_lec_db_for_label -obj_type root]} {define_attribute -obj_type root -category lec -data_type string -help_string {Capture internal write_lec variables.} wlec_internal_to_write_lec_db_for_label}
if {! [is_attribute wlec_internal_to_write_lec_label_data -obj_type root]} {define_attribute -obj_type root -category lec -data_type string -help_string {Capture internal write_lec variables.} wlec_internal_to_write_lec_label_data}
set_db -quiet information_level 8
set_db -quiet design_mode_process 480.0
set_db -quiet phys_assume_met_fill 0.0
set_db -quiet map_placed_for_hum false
set_db -quiet phys_use_invs_extraction true
set_db -quiet phys_route_time_out 120.0
set_db -quiet capacitance_per_unit_length_mmmc {}
set_db -quiet resistance_per_unit_length_mmmc {}
set_db -quiet lp_power_unit uW
set_db -quiet runtime_by_stage {{PBS_Generic-Start 0 24 0.0 11.0} {to_generic 1 25 1 12} {first_condense 1 27 2 15} {PBS_Generic_Opt-Post 3 27 3.605881 14.605881} {{PBS_Generic-Postgen HBO Optimizations} 0 28 0.0 14.605881} {PBS_TechMap-Start 0 28 0.0 14.605881} {{PBS_TechMap-Premap HBO Optimizations} 0 28 0.0 14.605881} {second_condense 0 28 0 16} {reify 1 29 2 18} {global_incr_map 1 30 0 19} {{PBS_Techmap-Global Mapping} 2 30 2.1546330000000005 16.760514} {{PBS_TechMap-Datapath Postmap Operations} 0 30 1.0 17.760514} {{PBS_TechMap-Postmap HBO Optimizations} 0 30 0.0 17.760514} {{PBS_TechMap-Postmap Clock Gating} 0 30 0.0 17.760514} {{PBS_TechMap-Postmap Cleanup} 0 30 0.0 17.760514} {PBS_Techmap-Post_MBCI 0 30 0.0 17.760514} {incr_opt 1 32 1 21} }
set_db -quiet tinfo_tstamp_file .rs_stanitzk.tstamp
set_db -quiet metric_enable true
set_db -quiet use_area_from_lef true
set_db -quiet use_tiehilo_for_const duplicate
set_db -quiet remove_assigns true
set_db -quiet auto_ungroup none
set_db -quiet syn_generic_effort high
set_db -quiet ultra_global_mapping true
set_db -quiet hdl_track_filename_row_col true
set_db -quiet hdl_unconnected_marking_done true
set_db -quiet flow_metrics_snapshot_uuid a821f9c3-94a5-4359-96a5-b65f85adb51f
set_db -quiet read_qrc_tech_file_rc_corner true
if {[vfind design:permut_sel -mode slow_ss] eq ""} {
 create_mode -name slow_ss -design design:permut_sel 
}
set_db -quiet compensative_dpul_driver 0
set_db -quiet phys_use_segment_parasitics true
set_db -quiet probabilistic_extraction true
set_db -quiet ple_correlation_factors {1.9000 2.0000}
set_db -quiet maximum_interval_of_vias inf
set_db -quiet ple_mode global
set_db -quiet lib_cell:slow_ss_lib/L035dc/TLATX3 .avoid false
set_db -quiet operating_condition:slow_ss_lib/L035dc/slow_ss .tree_type worst_case_tree
set_db -quiet operating_condition:slow_ss_lib/L035dc/typical .tree_type balanced_tree
set_db -quiet operating_condition:slow_ss_lib/L035dc/fast_ff .tree_type best_case_tree
set_db -quiet operating_condition:slow_ss_lib/L035dc/_nominal_ .tree_type balanced_tree
# BEGIN MSV SECTION
# END MSV SECTION
define_clock -name SYSCLK -mode mode:permut_sel/slow_ss -domain SYSTEM -period 66000.0 -divide_period 1 -rise 0 -divide_rise 1 -fall 1 -divide_fall 2 -design design:permut_sel port:permut_sel/clk
set_db -quiet clock:permut_sel/slow_ss/SYSCLK .clock_setup_uncertainty {5000.0 5000.0}
set_db -quiet clock:permut_sel/slow_ss/SYSCLK .clock_hold_uncertainty {1000.0 1000.0}
define_cost_group -design design:permut_sel -name SYSCLK
external_delay -accumulate -input {0.0 no_value 0.0 no_value} -clock clock:permut_sel/slow_ss/SYSCLK -name create_clock_delay_SYSTEM_SYSCLK_R_0 port:permut_sel/clk
set_db -quiet external_delay:permut_sel/slow_ss/create_clock_delay_SYSTEM_SYSCLK_R_0 .clock_network_latency_included true
external_delay -accumulate -input {no_value 0.0 no_value 0.0} -clock clock:permut_sel/slow_ss/SYSCLK -edge_fall -name create_clock_delay_SYSTEM_SYSCLK_F_0 port:permut_sel/clk
set_db -quiet external_delay:permut_sel/slow_ss/create_clock_delay_SYSTEM_SYSCLK_F_0 .clock_network_latency_included true
path_group -paths [specify_paths -mode mode:permut_sel/slow_ss -to clock:permut_sel/slow_ss/SYSCLK]  -name SYSCLK -group cost_group:permut_sel/SYSCLK -user_priority -1047552
# BEGIN DFT SECTION
set_db -quiet dft_scan_style muxed_scan
set_db -quiet dft_scanbit_waveform_analysis false
# END DFT SECTION
set_db -quiet design:permut_sel .max_transition 2750.0
set_db -quiet design:permut_sel .max_capacitance 2500.0
set_db -quiet design:permut_sel .max_transition_by_mode {{mode:permut_sel/slow_ss 2750.0}}
set_db -quiet design:permut_sel .max_capacitance_by_mode {{mode:permut_sel/slow_ss 2500.0}}
set_db -quiet design:permut_sel .qos_by_stage {{to_generic {wns -11111111} {tns -111111111} {vep -111111111} {area 67415} {cell_count 540} {utilization  0.00} {runtime 1 25 1 12} }{first_condense {wns -11111111} {tns -111111111} {vep -111111111} {area 61379} {cell_count 595} {utilization  0.00} {runtime 1 27 2 15} }{second_condense {wns -11111111} {tns -111111111} {vep -111111111} {area 61379} {cell_count 595} {utilization  0.00} {runtime 0 28 0 16} }{reify {wns 44333} {tns 0} {vep 0} {area 66756} {cell_count 348} {utilization  0.00} {runtime 1 29 2 18} }{global_incr_map {wns 43418} {tns 0} {vep 0} {area 64988} {cell_count 348} {utilization  0.00} {runtime 1 30 0 19} }{incr_opt {wns 214748365} {tns 0} {vep 0} {area 64037} {cell_count 329} {utilization  0.00} {runtime 1 32 1 21} }}
set_db -quiet design:permut_sel .seq_mbci_coverage 0.0
set_db -quiet design:permut_sel .hdl_filelist {{default -v2001 {SYNTHESIS} {/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v} { /Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src} {}}}
set_db -quiet design:permut_sel .hdl_user_name permut_sel
set_db -quiet design:permut_sel .verification_directory fv/permut_sel
set_db -quiet design:permut_sel .lp_clock_gating_max_flops inf
set_db -quiet design:permut_sel .seq_reason_deleted {{{c_reg[0][0]} {{constant 0}}} {{c_reg[0][1]} {{constant 0}}} {{c_reg[0][2]} {{constant 0}}} {{c_reg[1][1]} {{constant 0}}} {{c_reg[1][2]} {{constant 0}}} {{c_reg[2][2]} {{constant 0}}} {{c_reg[3][2]} {{constant 0}}}}
set_db -quiet design:permut_sel .arch_filename /Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v
set_db -quiet design:permut_sel .entity_filename /Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v
set_db -quiet {port:permut_sel/sel[15]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[15]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[15]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[15]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[15]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[15]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[15]} .original_name {sel[15]}
set_db -quiet {port:permut_sel/sel[14]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[14]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[14]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[14]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[14]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[14]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[14]} .original_name {sel[14]}
set_db -quiet {port:permut_sel/sel[13]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[13]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[13]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[13]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[13]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[13]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[13]} .original_name {sel[13]}
set_db -quiet {port:permut_sel/sel[12]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[12]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[12]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[12]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[12]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[12]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[12]} .original_name {sel[12]}
set_db -quiet {port:permut_sel/sel[11]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[11]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[11]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[11]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[11]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[11]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[11]} .original_name {sel[11]}
set_db -quiet {port:permut_sel/sel[10]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[10]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[10]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[10]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[10]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[10]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[10]} .original_name {sel[10]}
set_db -quiet {port:permut_sel/sel[9]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[9]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[9]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[9]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[9]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[9]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[9]} .original_name {sel[9]}
set_db -quiet {port:permut_sel/sel[8]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[8]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[8]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[8]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[8]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[8]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[8]} .original_name {sel[8]}
set_db -quiet {port:permut_sel/sel[7]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[7]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[7]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[7]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[7]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[7]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[7]} .original_name {sel[7]}
set_db -quiet {port:permut_sel/sel[6]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[6]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[6]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[6]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[6]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[6]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[6]} .original_name {sel[6]}
set_db -quiet {port:permut_sel/sel[5]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[5]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[5]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[5]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[5]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[5]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[5]} .original_name {sel[5]}
set_db -quiet {port:permut_sel/sel[4]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[4]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[4]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[4]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[4]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[4]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[4]} .original_name {sel[4]}
set_db -quiet {port:permut_sel/sel[3]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[3]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[3]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[3]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[3]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[3]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[3]} .original_name {sel[3]}
set_db -quiet {port:permut_sel/sel[2]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[2]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[2]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[2]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[2]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[2]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[2]} .original_name {sel[2]}
set_db -quiet {port:permut_sel/sel[1]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[1]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[1]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[1]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[1]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[1]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[1]} .original_name {sel[1]}
set_db -quiet {port:permut_sel/sel[0]} .input_slew_max_rise 2500.0
set_db -quiet {port:permut_sel/sel[0]} .input_slew_max_fall 2500.0
set_db -quiet {port:permut_sel/sel[0]} .input_slew_min_rise 2500.0
set_db -quiet {port:permut_sel/sel[0]} .input_slew_min_fall 2500.0
set_db -quiet {port:permut_sel/sel[0]} .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet {port:permut_sel/sel[0]} .min_transition no_value
set_db -quiet {port:permut_sel/sel[0]} .original_name {sel[0]}
set_db -quiet port:permut_sel/clk .driver_pin_rise_min lib_pin:slow_ss_lib/L035dc/BF/O
set_db -quiet port:permut_sel/clk .driver_pin_fall_min lib_pin:slow_ss_lib/L035dc/BF/O
set_db -quiet port:permut_sel/clk .driver_pin_rise_max lib_pin:slow_ss_lib/L035dc/BF/O
set_db -quiet port:permut_sel/clk .driver_pin_fall_max lib_pin:slow_ss_lib/L035dc/BF/O
set_db -quiet port:permut_sel/clk .external_driver_by_mode {{mode:permut_sel/slow_ss {lib_pin:slow_ss_lib/L035dc/BF/O lib_pin:slow_ss_lib/L035dc/BF/O lib_pin:slow_ss_lib/L035dc/BF/O lib_pin:slow_ss_lib/L035dc/BF/O}}}
set_db -quiet port:permut_sel/clk .min_transition no_value
set_db -quiet port:permut_sel/clk .original_name clk
set_db -quiet port:permut_sel/resn .input_slew_max_rise 2500.0
set_db -quiet port:permut_sel/resn .input_slew_max_fall 2500.0
set_db -quiet port:permut_sel/resn .input_slew_min_rise 2500.0
set_db -quiet port:permut_sel/resn .input_slew_min_fall 2500.0
set_db -quiet port:permut_sel/resn .fixed_slew_by_mode {{mode:permut_sel/slow_ss {2500.0 2500.0 2500.0 2500.0}}}
set_db -quiet port:permut_sel/resn .min_transition no_value
set_db -quiet port:permut_sel/resn .original_name resn
set_db -quiet port:permut_sel/ready .external_pin_cap_min 1100.0
set_db -quiet port:permut_sel/ready .external_capacitance_max {1100.0 1100.0}
set_db -quiet port:permut_sel/ready .external_capacitance_min 1100.0
set_db -quiet port:permut_sel/ready .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet port:permut_sel/ready .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet port:permut_sel/ready .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet port:permut_sel/ready .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet port:permut_sel/ready .min_transition no_value
set_db -quiet port:permut_sel/ready .original_name ready
set_db -quiet port:permut_sel/ready .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[23]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[23]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[23]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[23]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[23]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[23]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[23]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[23]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[23]} .original_name {sel_out[23]}
set_db -quiet {port:permut_sel/sel_out[23]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[22]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[22]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[22]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[22]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[22]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[22]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[22]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[22]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[22]} .original_name {sel_out[22]}
set_db -quiet {port:permut_sel/sel_out[22]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[21]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[21]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[21]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[21]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[21]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[21]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[21]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[21]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[21]} .original_name {sel_out[21]}
set_db -quiet {port:permut_sel/sel_out[21]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[20]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[20]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[20]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[20]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[20]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[20]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[20]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[20]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[20]} .original_name {sel_out[20]}
set_db -quiet {port:permut_sel/sel_out[20]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[19]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[19]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[19]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[19]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[19]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[19]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[19]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[19]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[19]} .original_name {sel_out[19]}
set_db -quiet {port:permut_sel/sel_out[19]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[18]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[18]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[18]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[18]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[18]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[18]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[18]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[18]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[18]} .original_name {sel_out[18]}
set_db -quiet {port:permut_sel/sel_out[18]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[17]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[17]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[17]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[17]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[17]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[17]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[17]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[17]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[17]} .original_name {sel_out[17]}
set_db -quiet {port:permut_sel/sel_out[17]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[16]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[16]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[16]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[16]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[16]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[16]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[16]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[16]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[16]} .original_name {sel_out[16]}
set_db -quiet {port:permut_sel/sel_out[16]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[15]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[15]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[15]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[15]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[15]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[15]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[15]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[15]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[15]} .original_name {sel_out[15]}
set_db -quiet {port:permut_sel/sel_out[15]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[14]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[14]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[14]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[14]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[14]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[14]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[14]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[14]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[14]} .original_name {sel_out[14]}
set_db -quiet {port:permut_sel/sel_out[14]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[13]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[13]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[13]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[13]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[13]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[13]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[13]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[13]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[13]} .original_name {sel_out[13]}
set_db -quiet {port:permut_sel/sel_out[13]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[12]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[12]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[12]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[12]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[12]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[12]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[12]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[12]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[12]} .original_name {sel_out[12]}
set_db -quiet {port:permut_sel/sel_out[12]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[11]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[11]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[11]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[11]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[11]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[11]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[11]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[11]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[11]} .original_name {sel_out[11]}
set_db -quiet {port:permut_sel/sel_out[11]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[10]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[10]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[10]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[10]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[10]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[10]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[10]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[10]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[10]} .original_name {sel_out[10]}
set_db -quiet {port:permut_sel/sel_out[10]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[9]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[9]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[9]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[9]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[9]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[9]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[9]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[9]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[9]} .original_name {sel_out[9]}
set_db -quiet {port:permut_sel/sel_out[9]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[8]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[8]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[8]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[8]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[8]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[8]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[8]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[8]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[8]} .original_name {sel_out[8]}
set_db -quiet {port:permut_sel/sel_out[8]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[7]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[7]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[7]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[7]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[7]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[7]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[7]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[7]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[7]} .original_name {sel_out[7]}
set_db -quiet {port:permut_sel/sel_out[7]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[6]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[6]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[6]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[6]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[6]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[6]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[6]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[6]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[6]} .original_name {sel_out[6]}
set_db -quiet {port:permut_sel/sel_out[6]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[5]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[5]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[5]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[5]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[5]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[5]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[5]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[5]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[5]} .original_name {sel_out[5]}
set_db -quiet {port:permut_sel/sel_out[5]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[4]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[4]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[4]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[4]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[4]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[4]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[4]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[4]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[4]} .original_name {sel_out[4]}
set_db -quiet {port:permut_sel/sel_out[4]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[3]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[3]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[3]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[3]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[3]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[3]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[3]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[3]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[3]} .original_name {sel_out[3]}
set_db -quiet {port:permut_sel/sel_out[3]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[2]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[2]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[2]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[2]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[2]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[2]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[2]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[2]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[2]} .original_name {sel_out[2]}
set_db -quiet {port:permut_sel/sel_out[2]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[1]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[1]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[1]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[1]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[1]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[1]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[1]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[1]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[1]} .original_name {sel_out[1]}
set_db -quiet {port:permut_sel/sel_out[1]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[0]} .external_pin_cap_min 1100.0
set_db -quiet {port:permut_sel/sel_out[0]} .external_capacitance_max {1100.0 1100.0}
set_db -quiet {port:permut_sel/sel_out[0]} .external_capacitance_min 1100.0
set_db -quiet {port:permut_sel/sel_out[0]} .external_pin_cap_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[0]} .external_capacitance_min_by_mode {{mode:permut_sel/slow_ss 1100.0}}
set_db -quiet {port:permut_sel/sel_out[0]} .external_pin_cap_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[0]} .external_capacitance_max_by_mode {{mode:permut_sel/slow_ss {1100.0 1100.0}}}
set_db -quiet {port:permut_sel/sel_out[0]} .min_transition no_value
set_db -quiet {port:permut_sel/sel_out[0]} .original_name {sel_out[0]}
set_db -quiet {port:permut_sel/sel_out[0]} .external_pin_cap {1100.0 1100.0}
set_db -quiet {inst:permut_sel/swp_cnt_reg[15]} .original_name {{swp_cnt[15]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[15]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[15]} .single_bit_orig_name {swp_cnt[15]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[15]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[15]/Q} .original_name {swp_cnt[15]/q}
set_db -quiet {inst:permut_sel/array_reg[5][1]} .original_name {{array[5][1]}}
set_db -quiet {inst:permut_sel/array_reg[5][1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[5][1]} .single_bit_orig_name {array[5][1]}
set_db -quiet {inst:permut_sel/array_reg[5][1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[5][1]/Q} .original_name {array[5][1]/q}
set_db -quiet {inst:permut_sel/array_reg[5][0]} .original_name {{array[5][0]}}
set_db -quiet {inst:permut_sel/array_reg[5][0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[5][0]} .single_bit_orig_name {array[5][0]}
set_db -quiet {inst:permut_sel/array_reg[5][0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[5][0]/Q} .original_name {array[5][0]/q}
set_db -quiet {inst:permut_sel/array_reg[5][2]} .original_name {{array[5][2]}}
set_db -quiet {inst:permut_sel/array_reg[5][2]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[5][2]} .single_bit_orig_name {array[5][2]}
set_db -quiet {inst:permut_sel/array_reg[5][2]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[5][2]/Q} .original_name {array[5][2]/q}
set_db -quiet {inst:permut_sel/array_reg[1][2]} .original_name {{array[1][2]}}
set_db -quiet {inst:permut_sel/array_reg[1][2]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[1][2]} .single_bit_orig_name {array[1][2]}
set_db -quiet {inst:permut_sel/array_reg[1][2]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[1][2]/Q} .original_name {array[1][2]/q}
set_db -quiet {inst:permut_sel/array_reg[2][0]} .original_name {{array[2][0]}}
set_db -quiet {inst:permut_sel/array_reg[2][0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[2][0]} .single_bit_orig_name {array[2][0]}
set_db -quiet {inst:permut_sel/array_reg[2][0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[2][0]/Q} .original_name {array[2][0]/q}
set_db -quiet {inst:permut_sel/array_reg[2][2]} .original_name {{array[2][2]}}
set_db -quiet {inst:permut_sel/array_reg[2][2]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[2][2]} .single_bit_orig_name {array[2][2]}
set_db -quiet {inst:permut_sel/array_reg[2][2]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[2][2]/Q} .original_name {array[2][2]/q}
set_db -quiet {inst:permut_sel/array_reg[4][0]} .original_name {{array[4][0]}}
set_db -quiet {inst:permut_sel/array_reg[4][0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[4][0]} .single_bit_orig_name {array[4][0]}
set_db -quiet {inst:permut_sel/array_reg[4][0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[4][0]/Q} .original_name {array[4][0]/q}
set_db -quiet {inst:permut_sel/array_reg[4][1]} .original_name {{array[4][1]}}
set_db -quiet {inst:permut_sel/array_reg[4][1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[4][1]} .single_bit_orig_name {array[4][1]}
set_db -quiet {inst:permut_sel/array_reg[4][1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[4][1]/Q} .original_name {array[4][1]/q}
set_db -quiet {inst:permut_sel/array_reg[6][0]} .original_name {{array[6][0]}}
set_db -quiet {inst:permut_sel/array_reg[6][0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[6][0]} .single_bit_orig_name {array[6][0]}
set_db -quiet {inst:permut_sel/array_reg[6][0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[6][0]/Q} .original_name {array[6][0]/q}
set_db -quiet {inst:permut_sel/array_reg[1][1]} .original_name {{array[1][1]}}
set_db -quiet {inst:permut_sel/array_reg[1][1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[1][1]} .single_bit_orig_name {array[1][1]}
set_db -quiet {inst:permut_sel/array_reg[1][1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[1][1]/Q} .original_name {array[1][1]/q}
set_db -quiet {inst:permut_sel/c_reg[7][0]} .original_name {{c[7][0]}}
set_db -quiet {inst:permut_sel/c_reg[7][0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[7][0]} .single_bit_orig_name {c[7][0]}
set_db -quiet {inst:permut_sel/c_reg[7][0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[7][0]/Q} .original_name {c[7][0]/q}
set_db -quiet {inst:permut_sel/c_reg[7][2]} .original_name {{c[7][2]}}
set_db -quiet {inst:permut_sel/c_reg[7][2]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[7][2]} .single_bit_orig_name {c[7][2]}
set_db -quiet {inst:permut_sel/c_reg[7][2]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[7][2]/Q} .original_name {c[7][2]/q}
set_db -quiet {inst:permut_sel/c_reg[7][1]} .original_name {{c[7][1]}}
set_db -quiet {inst:permut_sel/c_reg[7][1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[7][1]} .single_bit_orig_name {c[7][1]}
set_db -quiet {inst:permut_sel/c_reg[7][1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[7][1]/Q} .original_name {c[7][1]/q}
set_db -quiet {inst:permut_sel/array_reg[2][1]} .original_name {{array[2][1]}}
set_db -quiet {inst:permut_sel/array_reg[2][1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[2][1]} .single_bit_orig_name {array[2][1]}
set_db -quiet {inst:permut_sel/array_reg[2][1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[2][1]/Q} .original_name {array[2][1]/q}
set_db -quiet {inst:permut_sel/array_reg[4][2]} .original_name {{array[4][2]}}
set_db -quiet {inst:permut_sel/array_reg[4][2]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[4][2]} .single_bit_orig_name {array[4][2]}
set_db -quiet {inst:permut_sel/array_reg[4][2]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[4][2]/Q} .original_name {array[4][2]/q}
set_db -quiet {inst:permut_sel/array_reg[6][1]} .original_name {{array[6][1]}}
set_db -quiet {inst:permut_sel/array_reg[6][1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[6][1]} .single_bit_orig_name {array[6][1]}
set_db -quiet {inst:permut_sel/array_reg[6][1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[6][1]/Q} .original_name {array[6][1]/q}
set_db -quiet {inst:permut_sel/array_reg[1][0]} .original_name {{array[1][0]}}
set_db -quiet {inst:permut_sel/array_reg[1][0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[1][0]} .single_bit_orig_name {array[1][0]}
set_db -quiet {inst:permut_sel/array_reg[1][0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[1][0]/Q} .original_name {array[1][0]/q}
set_db -quiet {inst:permut_sel/array_reg[6][2]} .original_name {{array[6][2]}}
set_db -quiet {inst:permut_sel/array_reg[6][2]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[6][2]} .single_bit_orig_name {array[6][2]}
set_db -quiet {inst:permut_sel/array_reg[6][2]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[6][2]/Q} .original_name {array[6][2]/q}
set_db -quiet {inst:permut_sel/array_reg[3][2]} .original_name {{array[3][2]}}
set_db -quiet {inst:permut_sel/array_reg[3][2]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[3][2]} .single_bit_orig_name {array[3][2]}
set_db -quiet {inst:permut_sel/array_reg[3][2]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[3][2]/Q} .original_name {array[3][2]/q}
set_db -quiet {inst:permut_sel/array_reg[3][1]} .original_name {{array[3][1]}}
set_db -quiet {inst:permut_sel/array_reg[3][1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[3][1]} .single_bit_orig_name {array[3][1]}
set_db -quiet {inst:permut_sel/array_reg[3][1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[3][1]/Q} .original_name {array[3][1]/q}
set_db -quiet {inst:permut_sel/array_reg[3][0]} .original_name {{array[3][0]}}
set_db -quiet {inst:permut_sel/array_reg[3][0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[3][0]} .single_bit_orig_name {array[3][0]}
set_db -quiet {inst:permut_sel/array_reg[3][0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[3][0]/Q} .original_name {array[3][0]/q}
set_db -quiet {inst:permut_sel/swp_cnt_reg[14]} .original_name {{swp_cnt[14]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[14]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[14]} .single_bit_orig_name {swp_cnt[14]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[14]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[14]/Q} .original_name {swp_cnt[14]/q}
set_db -quiet {inst:permut_sel/c_reg[3][1]} .original_name {{c[3][1]}}
set_db -quiet {inst:permut_sel/c_reg[3][1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[3][1]} .single_bit_orig_name {c[3][1]}
set_db -quiet {inst:permut_sel/c_reg[3][1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[3][1]/Q} .original_name {c[3][1]/q}
set_db -quiet {inst:permut_sel/c_reg[3][0]} .original_name {{c[3][0]}}
set_db -quiet {inst:permut_sel/c_reg[3][0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[3][0]} .single_bit_orig_name {c[3][0]}
set_db -quiet {inst:permut_sel/c_reg[3][0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[3][0]/Q} .original_name {c[3][0]/q}
set_db -quiet {inst:permut_sel/c_reg[1][0]} .original_name {{c[1][0]}}
set_db -quiet {inst:permut_sel/c_reg[1][0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[1][0]} .single_bit_orig_name {c[1][0]}
set_db -quiet {inst:permut_sel/c_reg[1][0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[1][0]/Q} .original_name {c[1][0]/q}
set_db -quiet {inst:permut_sel/c_reg[5][1]} .original_name {{c[5][1]}}
set_db -quiet {inst:permut_sel/c_reg[5][1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[5][1]} .single_bit_orig_name {c[5][1]}
set_db -quiet {inst:permut_sel/c_reg[5][1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[5][1]/Q} .original_name {c[5][1]/q}
set_db -quiet {inst:permut_sel/c_reg[5][2]} .original_name {{c[5][2]}}
set_db -quiet {inst:permut_sel/c_reg[5][2]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[5][2]} .single_bit_orig_name {c[5][2]}
set_db -quiet {inst:permut_sel/c_reg[5][2]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[5][2]/Q} .original_name {c[5][2]/q}
set_db -quiet {inst:permut_sel/c_reg[5][0]} .original_name {{c[5][0]}}
set_db -quiet {inst:permut_sel/c_reg[5][0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[5][0]} .single_bit_orig_name {c[5][0]}
set_db -quiet {inst:permut_sel/c_reg[5][0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[5][0]/Q} .original_name {c[5][0]/q}
set_db -quiet {inst:permut_sel/array_reg[0][1]} .original_name {{array[0][1]}}
set_db -quiet {inst:permut_sel/array_reg[0][1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[0][1]} .single_bit_orig_name {array[0][1]}
set_db -quiet {inst:permut_sel/array_reg[0][1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[0][1]/Q} .original_name {array[0][1]/q}
set_db -quiet {inst:permut_sel/i_reg[3]} .original_name {{i[3]}}
set_db -quiet {inst:permut_sel/i_reg[3]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/i_reg[3]} .single_bit_orig_name {i[3]}
set_db -quiet {inst:permut_sel/i_reg[3]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/i_reg[3]/Q} .original_name {i[3]/q}
set_db -quiet {inst:permut_sel/array_reg[0][2]} .original_name {{array[0][2]}}
set_db -quiet {inst:permut_sel/array_reg[0][2]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[0][2]} .single_bit_orig_name {array[0][2]}
set_db -quiet {inst:permut_sel/array_reg[0][2]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[0][2]/Q} .original_name {array[0][2]/q}
set_db -quiet {inst:permut_sel/array_reg[0][0]} .original_name {{array[0][0]}}
set_db -quiet {inst:permut_sel/array_reg[0][0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[0][0]} .single_bit_orig_name {array[0][0]}
set_db -quiet {inst:permut_sel/array_reg[0][0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[0][0]/Q} .original_name {array[0][0]/q}
set_db -quiet {inst:permut_sel/i_reg[1]} .original_name {{i[1]}}
set_db -quiet {inst:permut_sel/i_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/i_reg[1]} .single_bit_orig_name {i[1]}
set_db -quiet {inst:permut_sel/i_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/i_reg[1]/Q} .original_name {i[1]/q}
set_db -quiet {inst:permut_sel/i_reg[2]} .original_name {{i[2]}}
set_db -quiet {inst:permut_sel/i_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/i_reg[2]} .single_bit_orig_name {i[2]}
set_db -quiet {inst:permut_sel/i_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/i_reg[2]/Q} .original_name {i[2]/q}
set_db -quiet {inst:permut_sel/array_reg[7][0]} .original_name {{array[7][0]}}
set_db -quiet {inst:permut_sel/array_reg[7][0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[7][0]} .single_bit_orig_name {array[7][0]}
set_db -quiet {inst:permut_sel/array_reg[7][0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[7][0]/Q} .original_name {array[7][0]/q}
set_db -quiet {inst:permut_sel/array_reg[7][1]} .original_name {{array[7][1]}}
set_db -quiet {inst:permut_sel/array_reg[7][1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[7][1]} .single_bit_orig_name {array[7][1]}
set_db -quiet {inst:permut_sel/array_reg[7][1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[7][1]/Q} .original_name {array[7][1]/q}
set_db -quiet {inst:permut_sel/array_reg[7][2]} .original_name {{array[7][2]}}
set_db -quiet {inst:permut_sel/array_reg[7][2]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/array_reg[7][2]} .single_bit_orig_name {array[7][2]}
set_db -quiet {inst:permut_sel/array_reg[7][2]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/array_reg[7][2]/Q} .original_name {array[7][2]/q}
set_db -quiet {inst:permut_sel/c_reg[6][0]} .original_name {{c[6][0]}}
set_db -quiet {inst:permut_sel/c_reg[6][0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[6][0]} .single_bit_orig_name {c[6][0]}
set_db -quiet {inst:permut_sel/c_reg[6][0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[6][0]/Q} .original_name {c[6][0]/q}
set_db -quiet {inst:permut_sel/c_reg[2][1]} .original_name {{c[2][1]}}
set_db -quiet {inst:permut_sel/c_reg[2][1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[2][1]} .single_bit_orig_name {c[2][1]}
set_db -quiet {inst:permut_sel/c_reg[2][1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[2][1]/Q} .original_name {c[2][1]/q}
set_db -quiet {inst:permut_sel/c_reg[4][0]} .original_name {{c[4][0]}}
set_db -quiet {inst:permut_sel/c_reg[4][0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[4][0]} .single_bit_orig_name {c[4][0]}
set_db -quiet {inst:permut_sel/c_reg[4][0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[4][0]/Q} .original_name {c[4][0]/q}
set_db -quiet {inst:permut_sel/c_reg[4][2]} .original_name {{c[4][2]}}
set_db -quiet {inst:permut_sel/c_reg[4][2]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[4][2]} .single_bit_orig_name {c[4][2]}
set_db -quiet {inst:permut_sel/c_reg[4][2]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[4][2]/Q} .original_name {c[4][2]/q}
set_db -quiet {inst:permut_sel/c_reg[4][1]} .original_name {{c[4][1]}}
set_db -quiet {inst:permut_sel/c_reg[4][1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[4][1]} .single_bit_orig_name {c[4][1]}
set_db -quiet {inst:permut_sel/c_reg[4][1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[4][1]/Q} .original_name {c[4][1]/q}
set_db -quiet {inst:permut_sel/swp_cnt_reg[8]} .original_name {{swp_cnt[8]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[8]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[8]} .single_bit_orig_name {swp_cnt[8]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[8]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[8]/Q} .original_name {swp_cnt[8]/q}
set_db -quiet {inst:permut_sel/swp_cnt_reg[5]} .original_name {{swp_cnt[5]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[5]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[5]} .single_bit_orig_name {swp_cnt[5]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[5]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[5]/Q} .original_name {swp_cnt[5]/q}
set_db -quiet {inst:permut_sel/swp_cnt_reg[11]} .original_name {{swp_cnt[11]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[11]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[11]} .single_bit_orig_name {swp_cnt[11]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[11]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[11]/Q} .original_name {swp_cnt[11]/q}
set_db -quiet {inst:permut_sel/swp_cnt_reg[13]} .original_name {{swp_cnt[13]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[13]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[13]} .single_bit_orig_name {swp_cnt[13]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[13]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[13]/Q} .original_name {swp_cnt[13]/q}
set_db -quiet {inst:permut_sel/i_reg[0]} .original_name {{i[0]}}
set_db -quiet {inst:permut_sel/i_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/i_reg[0]} .single_bit_orig_name {i[0]}
set_db -quiet {inst:permut_sel/i_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/i_reg[0]/Q} .original_name {i[0]/q}
set_db -quiet {inst:permut_sel/c_reg[6][1]} .original_name {{c[6][1]}}
set_db -quiet {inst:permut_sel/c_reg[6][1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[6][1]} .single_bit_orig_name {c[6][1]}
set_db -quiet {inst:permut_sel/c_reg[6][1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[6][1]/Q} .original_name {c[6][1]/q}
set_db -quiet {inst:permut_sel/c_reg[6][2]} .original_name {{c[6][2]}}
set_db -quiet {inst:permut_sel/c_reg[6][2]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[6][2]} .single_bit_orig_name {c[6][2]}
set_db -quiet {inst:permut_sel/c_reg[6][2]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[6][2]/Q} .original_name {c[6][2]/q}
set_db -quiet {inst:permut_sel/c_reg[2][0]} .original_name {{c[2][0]}}
set_db -quiet {inst:permut_sel/c_reg[2][0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/c_reg[2][0]} .single_bit_orig_name {c[2][0]}
set_db -quiet {inst:permut_sel/c_reg[2][0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/c_reg[2][0]/Q} .original_name {c[2][0]/q}
set_db -quiet {inst:permut_sel/swp_cnt_reg[1]} .original_name {{swp_cnt[1]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[1]} .single_bit_orig_name {swp_cnt[1]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[1]/Q} .original_name {swp_cnt[1]/q}
set_db -quiet {inst:permut_sel/swp_cnt_reg[0]} .original_name {{swp_cnt[0]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[0]} .single_bit_orig_name {swp_cnt[0]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[0]/Q} .original_name {swp_cnt[0]/q}
set_db -quiet {inst:permut_sel/swp_cnt_reg[2]} .original_name {{swp_cnt[2]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[2]} .single_bit_orig_name {swp_cnt[2]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[2]/Q} .original_name {swp_cnt[2]/q}
set_db -quiet {inst:permut_sel/swp_cnt_reg[3]} .original_name {{swp_cnt[3]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[3]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[3]} .single_bit_orig_name {swp_cnt[3]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[3]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[3]/Q} .original_name {swp_cnt[3]/q}
set_db -quiet {inst:permut_sel/swp_cnt_reg[12]} .original_name {{swp_cnt[12]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[12]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[12]} .single_bit_orig_name {swp_cnt[12]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[12]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[12]/Q} .original_name {swp_cnt[12]/q}
set_db -quiet {inst:permut_sel/swp_cnt_reg[4]} .original_name {{swp_cnt[4]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[4]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[4]} .single_bit_orig_name {swp_cnt[4]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[4]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[4]/Q} .original_name {swp_cnt[4]/q}
set_db -quiet {inst:permut_sel/swp_cnt_reg[6]} .original_name {{swp_cnt[6]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[6]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[6]} .single_bit_orig_name {swp_cnt[6]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[6]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[6]/Q} .original_name {swp_cnt[6]/q}
set_db -quiet {inst:permut_sel/swp_cnt_reg[7]} .original_name {{swp_cnt[7]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[7]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[7]} .single_bit_orig_name {swp_cnt[7]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[7]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[7]/Q} .original_name {swp_cnt[7]/q}
set_db -quiet {inst:permut_sel/swp_cnt_reg[9]} .original_name {{swp_cnt[9]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[9]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[9]} .single_bit_orig_name {swp_cnt[9]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[9]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[9]/Q} .original_name {swp_cnt[9]/q}
set_db -quiet {inst:permut_sel/swp_cnt_reg[10]} .original_name {{swp_cnt[10]}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[10]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/swp_cnt_reg[10]} .single_bit_orig_name {swp_cnt[10]}
set_db -quiet {inst:permut_sel/swp_cnt_reg[10]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/swp_cnt_reg[10]/Q} .original_name {swp_cnt[10]/q}
set_db -quiet inst:permut_sel/ready_reg .original_name ready
set_db -quiet inst:permut_sel/ready_reg .orig_hdl_instantiated false
set_db -quiet inst:permut_sel/ready_reg .single_bit_orig_name ready
set_db -quiet inst:permut_sel/ready_reg .gint_phase_inversion false
set_db -quiet pin:permut_sel/ready_reg/Q .original_name ready/q
set_db -quiet {inst:permut_sel/sel_out_reg[7]} .original_name {{sel_out[7]}}
set_db -quiet {inst:permut_sel/sel_out_reg[7]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[7]} .single_bit_orig_name {sel_out[7]}
set_db -quiet {inst:permut_sel/sel_out_reg[7]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[7]/Q} .original_name {sel_out[7]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[4]} .original_name {{sel_out[4]}}
set_db -quiet {inst:permut_sel/sel_out_reg[4]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[4]} .single_bit_orig_name {sel_out[4]}
set_db -quiet {inst:permut_sel/sel_out_reg[4]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[4]/Q} .original_name {sel_out[4]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[3]} .original_name {{sel_out[3]}}
set_db -quiet {inst:permut_sel/sel_out_reg[3]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[3]} .single_bit_orig_name {sel_out[3]}
set_db -quiet {inst:permut_sel/sel_out_reg[3]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[3]/Q} .original_name {sel_out[3]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[2]} .original_name {{sel_out[2]}}
set_db -quiet {inst:permut_sel/sel_out_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[2]} .single_bit_orig_name {sel_out[2]}
set_db -quiet {inst:permut_sel/sel_out_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[2]/Q} .original_name {sel_out[2]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[1]} .original_name {{sel_out[1]}}
set_db -quiet {inst:permut_sel/sel_out_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[1]} .single_bit_orig_name {sel_out[1]}
set_db -quiet {inst:permut_sel/sel_out_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[1]/Q} .original_name {sel_out[1]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[11]} .original_name {{sel_out[11]}}
set_db -quiet {inst:permut_sel/sel_out_reg[11]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[11]} .single_bit_orig_name {sel_out[11]}
set_db -quiet {inst:permut_sel/sel_out_reg[11]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[11]/Q} .original_name {sel_out[11]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[15]} .original_name {{sel_out[15]}}
set_db -quiet {inst:permut_sel/sel_out_reg[15]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[15]} .single_bit_orig_name {sel_out[15]}
set_db -quiet {inst:permut_sel/sel_out_reg[15]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[15]/Q} .original_name {sel_out[15]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[19]} .original_name {{sel_out[19]}}
set_db -quiet {inst:permut_sel/sel_out_reg[19]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[19]} .single_bit_orig_name {sel_out[19]}
set_db -quiet {inst:permut_sel/sel_out_reg[19]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[19]/Q} .original_name {sel_out[19]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[16]} .original_name {{sel_out[16]}}
set_db -quiet {inst:permut_sel/sel_out_reg[16]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[16]} .single_bit_orig_name {sel_out[16]}
set_db -quiet {inst:permut_sel/sel_out_reg[16]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[16]/Q} .original_name {sel_out[16]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[6]} .original_name {{sel_out[6]}}
set_db -quiet {inst:permut_sel/sel_out_reg[6]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[6]} .single_bit_orig_name {sel_out[6]}
set_db -quiet {inst:permut_sel/sel_out_reg[6]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[6]/Q} .original_name {sel_out[6]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[8]} .original_name {{sel_out[8]}}
set_db -quiet {inst:permut_sel/sel_out_reg[8]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[8]} .single_bit_orig_name {sel_out[8]}
set_db -quiet {inst:permut_sel/sel_out_reg[8]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[8]/Q} .original_name {sel_out[8]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[0]} .original_name {{sel_out[0]}}
set_db -quiet {inst:permut_sel/sel_out_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[0]} .single_bit_orig_name {sel_out[0]}
set_db -quiet {inst:permut_sel/sel_out_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[0]/Q} .original_name {sel_out[0]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[10]} .original_name {{sel_out[10]}}
set_db -quiet {inst:permut_sel/sel_out_reg[10]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[10]} .single_bit_orig_name {sel_out[10]}
set_db -quiet {inst:permut_sel/sel_out_reg[10]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[10]/Q} .original_name {sel_out[10]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[12]} .original_name {{sel_out[12]}}
set_db -quiet {inst:permut_sel/sel_out_reg[12]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[12]} .single_bit_orig_name {sel_out[12]}
set_db -quiet {inst:permut_sel/sel_out_reg[12]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[12]/Q} .original_name {sel_out[12]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[13]} .original_name {{sel_out[13]}}
set_db -quiet {inst:permut_sel/sel_out_reg[13]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[13]} .single_bit_orig_name {sel_out[13]}
set_db -quiet {inst:permut_sel/sel_out_reg[13]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[13]/Q} .original_name {sel_out[13]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[14]} .original_name {{sel_out[14]}}
set_db -quiet {inst:permut_sel/sel_out_reg[14]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[14]} .single_bit_orig_name {sel_out[14]}
set_db -quiet {inst:permut_sel/sel_out_reg[14]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[14]/Q} .original_name {sel_out[14]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[9]} .original_name {{sel_out[9]}}
set_db -quiet {inst:permut_sel/sel_out_reg[9]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[9]} .single_bit_orig_name {sel_out[9]}
set_db -quiet {inst:permut_sel/sel_out_reg[9]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[9]/Q} .original_name {sel_out[9]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[17]} .original_name {{sel_out[17]}}
set_db -quiet {inst:permut_sel/sel_out_reg[17]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[17]} .single_bit_orig_name {sel_out[17]}
set_db -quiet {inst:permut_sel/sel_out_reg[17]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[17]/Q} .original_name {sel_out[17]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[18]} .original_name {{sel_out[18]}}
set_db -quiet {inst:permut_sel/sel_out_reg[18]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[18]} .single_bit_orig_name {sel_out[18]}
set_db -quiet {inst:permut_sel/sel_out_reg[18]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[18]/Q} .original_name {sel_out[18]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[21]} .original_name {{sel_out[21]}}
set_db -quiet {inst:permut_sel/sel_out_reg[21]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[21]} .single_bit_orig_name {sel_out[21]}
set_db -quiet {inst:permut_sel/sel_out_reg[21]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[21]/Q} .original_name {sel_out[21]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[22]} .original_name {{sel_out[22]}}
set_db -quiet {inst:permut_sel/sel_out_reg[22]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[22]} .single_bit_orig_name {sel_out[22]}
set_db -quiet {inst:permut_sel/sel_out_reg[22]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[22]/Q} .original_name {sel_out[22]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[23]} .original_name {{sel_out[23]}}
set_db -quiet {inst:permut_sel/sel_out_reg[23]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[23]} .single_bit_orig_name {sel_out[23]}
set_db -quiet {inst:permut_sel/sel_out_reg[23]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[23]/Q} .original_name {sel_out[23]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[20]} .original_name {{sel_out[20]}}
set_db -quiet {inst:permut_sel/sel_out_reg[20]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[20]} .single_bit_orig_name {sel_out[20]}
set_db -quiet {inst:permut_sel/sel_out_reg[20]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[20]/Q} .original_name {sel_out[20]/q}
set_db -quiet {inst:permut_sel/sel_out_reg[5]} .original_name {{sel_out[5]}}
set_db -quiet {inst:permut_sel/sel_out_reg[5]} .orig_hdl_instantiated false
set_db -quiet {inst:permut_sel/sel_out_reg[5]} .single_bit_orig_name {sel_out[5]}
set_db -quiet {inst:permut_sel/sel_out_reg[5]} .gint_phase_inversion false
set_db -quiet {pin:permut_sel/sel_out_reg[5]/Q} .original_name {sel_out[5]/q}
# BEGIN PMBIST SECTION
# END PMBIST SECTION
# BEGIN PHYSICAL ANNOTATION SECTION
# END PHYSICAL ANNOTATION SECTION
set_db -quiet {inst:permut_sel/swp_cnt_reg[15]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet {inst:permut_sel/array_reg[5][1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 23}}
set_db -quiet {inst:permut_sel/array_reg[5][0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 23}}
set_db -quiet {inst:permut_sel/array_reg[5][2]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 23}}
set_db -quiet {inst:permut_sel/array_reg[1][2]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 25}}
set_db -quiet {inst:permut_sel/array_reg[2][0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 25}}
set_db -quiet {inst:permut_sel/array_reg[2][2]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 25}}
set_db -quiet {inst:permut_sel/array_reg[4][0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 47 17}}
set_db -quiet {inst:permut_sel/array_reg[4][1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 47 17}}
set_db -quiet {inst:permut_sel/array_reg[6][0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 23}}
set_db -quiet {inst:permut_sel/array_reg[1][1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 25}}
set_db -quiet {inst:permut_sel/c_reg[7][0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet {inst:permut_sel/c_reg[7][2]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet {inst:permut_sel/c_reg[7][1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet {inst:permut_sel/array_reg[2][1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 25}}
set_db -quiet {inst:permut_sel/array_reg[4][2]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 47 17}}
set_db -quiet {inst:permut_sel/array_reg[6][1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 23}}
set_db -quiet {inst:permut_sel/array_reg[1][0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 25}}
set_db -quiet {inst:permut_sel/array_reg[6][2]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 23}}
set_db -quiet {inst:permut_sel/array_reg[3][2]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 25}}
set_db -quiet {inst:permut_sel/array_reg[3][1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 25}}
set_db -quiet {inst:permut_sel/array_reg[3][0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 25}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[14]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet inst:permut_sel/g7636 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7635 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7637 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet {inst:permut_sel/c_reg[3][1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet {inst:permut_sel/c_reg[3][0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet inst:permut_sel/g7620__8780 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7664__4296 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7641__3772 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7665__1474 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7640__4547 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7666__9682 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7667__2683 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7668__1309 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7663__6877 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7670__2900 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7671__2391 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7672__7675 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7673__7118 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7669__8757 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7639__1786 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7662__5953 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet {inst:permut_sel/c_reg[1][0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet inst:permut_sel/g7642__5703 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7643__7114 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet {inst:permut_sel/c_reg[5][1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet {inst:permut_sel/c_reg[5][2]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet {inst:permut_sel/c_reg[5][0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet {inst:permut_sel/array_reg[0][1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 25}}
set_db -quiet inst:permut_sel/g7638__5266 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet {inst:permut_sel/i_reg[3]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 36}}
set_db -quiet {inst:permut_sel/array_reg[0][2]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 25}}
set_db -quiet {inst:permut_sel/array_reg[0][0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 25}}
set_db -quiet {inst:permut_sel/i_reg[1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 36}}
set_db -quiet {inst:permut_sel/i_reg[2]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 47 17}}
set_db -quiet inst:permut_sel/g7708__2250 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7710__6083 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7709__2703 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7695__5795 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet {inst:permut_sel/array_reg[7][0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet {inst:permut_sel/array_reg[7][1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet {inst:permut_sel/array_reg[7][2]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet inst:permut_sel/g7707__1840 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7697__5019 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7698__1857 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7699__9906 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7700__8780 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7704__4296 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7705__3772 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7706__1474 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7696__4547 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7716 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7721__2683 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7722__1309 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet {inst:permut_sel/c_reg[6][0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet inst:permut_sel/g7719__6877 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet {inst:permut_sel/c_reg[2][1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet {inst:permut_sel/c_reg[4][0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet {inst:permut_sel/c_reg[4][2]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet {inst:permut_sel/c_reg[4][1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet inst:permut_sel/g7712__2900 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[8]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[5]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[11]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[13]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet {inst:permut_sel/i_reg[0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 47 17}}
set_db -quiet inst:permut_sel/g7703__2391 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7702__7675 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7701__7118 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet {inst:permut_sel/c_reg[6][1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet {inst:permut_sel/c_reg[6][2]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet {inst:permut_sel/c_reg[2][0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 16}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[2]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[3]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[12]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[4]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[6]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[7]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[9]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet {inst:permut_sel/swp_cnt_reg[10]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet inst:permut_sel/g7717__8757 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7718__1786 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7750__5953 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7723__7114 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7753__5266 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7724__2250 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/ready_reg .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 18}}
set_db -quiet inst:permut_sel/g7761__6083 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7757__2703 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7762__5795 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7756__1840 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet {inst:permut_sel/sel_out_reg[7]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[4]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[3]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[2]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[1]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[11]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7768 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet {inst:permut_sel/sel_out_reg[15]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[19]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7760__5019 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7755__1857 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7754__9906 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7759__8780 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7758__4296 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7764__3772 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet {inst:permut_sel/sel_out_reg[16]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[6]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[8]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[0]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[10]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[12]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[13]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[14]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[9]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[17]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[18]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[21]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[22]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[23]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[20]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet {inst:permut_sel/sel_out_reg[5]} .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7766__4547 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7767__9682 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7769 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7771__1309 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7770__6877 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7772__2900 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7773__2391 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7775 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7776__7675 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7777__7118 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7782 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7783__1786 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7785__5703 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7786__7114 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7788__2250 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7789__6083 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7796__5795 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7791__7344 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7792__1840 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7797__5019 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7793__1857 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7794__9906 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7799 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7802 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7803 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7800__4296 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7804__3772 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7801__1474 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7805__4547 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7806__9682 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7808__2683 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7807__1309 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7809__6877 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7810__2900 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7811__2391 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7812 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7821__7675 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7816__7118 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7818__8757 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7819__1786 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7817__5953 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7822__7114 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7824 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7814__5266 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7815__2250 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7820__6083 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7825__2703 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7826__5795 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7834__7344 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7827__5019 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7829__1857 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7828__9906 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7830 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7835__8780 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7832__4296 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7833__3772 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7836__1474 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7838 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7841 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7843 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7842 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7837 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7840__4547 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7844__9682 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7853__2683 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7846__1309 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7845__6877 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7839__2391 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7847__7675 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7850__7118 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7849__8757 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7848__1786 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7852__5953 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7855__5703 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7860__7114 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7859__5266 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7858__2250 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7861__6083 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7856__2703 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7854__5795 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7857__7344 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7862__1840 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7865__5019 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7863__9906 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7870__8780 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7871__4296 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7872__3772 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7874__1474 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7866__4547 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7867__9682 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7873__2683 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7869__1309 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7868__6877 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7881__7675 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7878 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7877__7118 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7882__8757 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7886__1786 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7885__5953 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7887__5703 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7890__7114 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7883__5266 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7880__6083 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7884__2703 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7888__5795 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7889__7344 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7898 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7891 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7900__1840 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7892__5019 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7897 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7901__1857 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7899__9906 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7893__8780 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7894__4296 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7902__3772 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7896__1474 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7903__4547 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7895__9682 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g7904 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7931 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7909 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7905 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7908 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7936 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7927 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7911 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7922 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet inst:permut_sel/g7955 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet inst:permut_sel/g7950 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet inst:permut_sel/g7929 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7916 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7915 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7951 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet inst:permut_sel/g7921 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet inst:permut_sel/g7920 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet inst:permut_sel/g7949 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet inst:permut_sel/g7923 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 47 17}}
set_db -quiet inst:permut_sel/g7953 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet inst:permut_sel/g7961 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 47 17}}
set_db -quiet inst:permut_sel/g7959 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 25}}
set_db -quiet inst:permut_sel/g7957 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 25}}
set_db -quiet inst:permut_sel/g7925 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7932 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7918 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7952 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet inst:permut_sel/g7910 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7914 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7906 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7958 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet inst:permut_sel/g7926 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7913 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7956 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet inst:permut_sel/g7928 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7917 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7912 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 18}}
set_db -quiet inst:permut_sel/g7934 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7907 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7919 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 1}}
set_db -quiet inst:permut_sel/g7960 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 42}}
set_db -quiet inst:permut_sel/g7954 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 19 25}}
set_db -quiet inst:permut_sel/g2 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g8049 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g8050 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
set_db -quiet inst:permut_sel/g8051 .file_row_col {{/Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/cs_puf/permut_sel/src/permut_sel.v 62 49}}
# there is no file_row_col attribute information available
set_db -quiet source_verbose true
#############################################################
#####   FLOW WRITE   ########################################
##
## Written by Genus(TM) Synthesis Solution version 17.22-s017_1
## Written on 10:53:40 20-Oct 2018
#############################################################
#####   Flow Definitions   ##################################

#############################################################
#####   Step Definitions   ##################################


#############################################################
#####   Attribute Definitions   #############################

if {[is_attribute flow_edit_wildcard_end_steps -obj_type root]} {set_db flow_edit_wildcard_end_steps {}}
if {[is_attribute flow_edit_wildcard_start_steps -obj_type root]} {set_db flow_edit_wildcard_start_steps {}}
if {[is_attribute flow_footer_tcl -obj_type root]} {set_db flow_footer_tcl {}}
if {[is_attribute flow_header_tcl -obj_type root]} {set_db flow_header_tcl {}}
if {[is_attribute flow_metadata -obj_type root]} {set_db flow_metadata {}}
if {[is_attribute flow_step_begin_tcl -obj_type root]} {set_db flow_step_begin_tcl {}}
if {[is_attribute flow_step_check_tcl -obj_type root]} {set_db flow_step_check_tcl {}}
if {[is_attribute flow_step_end_tcl -obj_type root]} {set_db flow_step_end_tcl {}}
if {[is_attribute flow_step_order -obj_type root]} {set_db flow_step_order {}}
if {[is_attribute flow_summary_tcl -obj_type root]} {set_db flow_summary_tcl {}}
if {[is_attribute flow_template_feature_definition -obj_type root]} {set_db flow_template_feature_definition {}}
if {[is_attribute flow_template_type -obj_type root]} {set_db flow_template_type {}}
if {[is_attribute flow_template_version -obj_type root]} {set_db flow_template_version {}}
if {[is_attribute flow_user_templates -obj_type root]} {set_db flow_user_templates {}}


#############################################################
#####   Flow History   ######################################

if {[is_attribute flow_branch -obj_type root]} {set_db flow_branch {}}
if {[is_attribute flow_caller_data -obj_type root]} {set_db flow_caller_data {}}
if {[is_attribute flow_current -obj_type root]} {set_db flow_current {}}
if {[is_attribute flow_hier_path -obj_type root]} {set_db flow_hier_path {}}
if {[is_attribute flow_database_directory -obj_type root]} {set_db flow_database_directory dbs}
if {[is_attribute flow_exit_when_done -obj_type root]} {set_db flow_exit_when_done false}
if {[is_attribute flow_history -obj_type root]} {set_db flow_history {}}
if {[is_attribute flow_log_directory -obj_type root]} {set_db flow_log_directory logs}
if {[is_attribute flow_mail_on_error -obj_type root]} {set_db flow_mail_on_error false}
if {[is_attribute flow_mail_to -obj_type root]} {set_db flow_mail_to {}}
if {[is_attribute flow_metrics_file -obj_type root]} {set_db flow_metrics_file {}}
if {[is_attribute flow_metrics_snapshot_parent_uuid -obj_type root]} {set_db flow_metrics_snapshot_parent_uuid {}}
if {[is_attribute flow_metrics_snapshot_uuid -obj_type root]} {set_db flow_metrics_snapshot_uuid a821f9c3-94a5-4359-96a5-b65f85adb51f}
if {[is_attribute flow_overwrite_database -obj_type root]} {set_db flow_overwrite_database false}
if {[is_attribute flow_report_directory -obj_type root]} {set_db flow_report_directory reports}
if {[is_attribute flow_run_tag -obj_type root]} {set_db flow_run_tag {}}
if {[is_attribute flow_schedule -obj_type root]} {set_db flow_schedule {}}
if {[is_attribute flow_script -obj_type root]} {set_db flow_script {}}
if {[is_attribute flow_starting_db -obj_type root]} {set_db flow_starting_db {}}
if {[is_attribute flow_status_file -obj_type root]} {set_db flow_status_file {}}
if {[is_attribute flow_step_canonical_current -obj_type root]} {set_db flow_step_canonical_current {}}
if {[is_attribute flow_step_current -obj_type root]} {set_db flow_step_current {}}
if {[is_attribute flow_step_last -obj_type root]} {set_db flow_step_last {}}
if {[is_attribute flow_step_last_msg -obj_type root]} {set_db flow_step_last_msg {}}
if {[is_attribute flow_step_last_status -obj_type root]} {set_db flow_step_last_status not_run}
if {[is_attribute flow_step_next -obj_type root]} {set_db flow_step_next {}}
if {[is_attribute flow_working_directory -obj_type root]} {set_db flow_working_directory .}

#############################################################
#####   User Defined Attributes   ###########################

