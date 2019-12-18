#-----------------------------------------------------------------------------------------------------------
#--------------------------------------- GENUS synthesize file ---------------------------------------------
#-----------------------------------------------------------------------------------------------------------
set DESIGN_PATH { /Projekte/155365_RF300/user/schaal/pre_digital3/modules/ }

set DESIGN_FILES { eeprom_ctrl/eeprom_ctrl.vhd spi_block/spi_block.vhd test_controller/test_controller.vhd \ 
moby_pkg/moby_pkg.vhd clk_res_gated/clk_res_gated.vhd crc16_4_mobyi_ed/crc16_4_mobyi_ed.vhd crc32_gen2/crc32_gen2.vhd \
decoder_gen2_spitunnel/decoder_gen2_spitunnel.vhd decoder_write_test/decoder_write_test.vhd filt_form_fpga/filt_form_fpga.vhd \
filt_form_gen2/filt_form_gen2.vhd gen_mux/gen_mux.vhd logic/logic.vhd nandtree/nandtree.vhd spi_block/spi_block.vhd \
test_controller/test_controller.vhd load_tester/load_tester.vhd nandtree/nandtree.vhd digitalteil/digitalteil.vhd}

set SPARE_CELLS { spare/spare.v }
set LIB_PATH { /sw/ims_db/lib/L035/l035v0v6dc/.lib/synthesis/ /sw/ims_db/lib/L035/l035v0v6dc/.lib/layout/ }
set LIB_FILE L035dc_18_c4.lib
set LEF_FILE L035dc.lef
set CAP_FILE L035dc.cap

set RESULT_DIR {results}
set REPORT_DIR {reports}
set TOP_CELL_NAME DIGITALTEIL

set_db / .information_level 8
 
#-----------------------------------------------------------------------------------------------------------
#-------------------------------- Set tech library path, files and options ---------------------------------
#-----------------------------------------------------------------------------------------------------------
set_db / .init_lib_search_path $LIB_PATH
set_db / .library $LIB_FILE
set_db / .lef_library $LEF_FILE
set_db / .cap_table_file $CAP_FILE 

set_db / .interconnect_mode ple
set_db / .operating_conditions c4
set_db [get_db active_operating_conditions] .voltage 1.62
set_db [get_db active_operating_conditions] .temperatur 150
set_db [get_db active_operating_conditions] .process 1
set_db [get_db active_operating_conditions] .tree_type worst_case_tree

set_db / .max_cpus_per_server 8
set_db / .use_tiehilo_for_const duplicate
set_db / .remove_assigns true
set_db / .auto_ungroup none


set_db / .syn_generic_effort high
set_db / .syn_map_effort high
set_db / .syn_opt_effort high

#Enables the most aggressive area-mode optimization, might degrade timing.
#set_db / .dp_analytical_opt extreme

#Enables analytical optimizations, which reduces area without degradaded timing.
set_db / .dp_analytical_opt standard

#enables interative optimization
set_db / .ultra_global_mapping true

#-----------------------------------------------------------------------------------------------------------
#---------------------------- Set design library search path and design files ------------------------------
#-----------------------------------------------------------------------------------------------------------
set_db / .hdl_language vhdl
set_db / .init_hdl_search_path $DESIGN_PATH 
read_hdl $DESIGN_FILES

set_db / .hdl_language v2001
set_db / .init_hdl_search_path $DESIGN_PATH 
read_hdl $SPARE_CELLS

set_db / .hdl_track_filename_row_col true
set_db / .hdl_preserve_unused_registers false

#-----------------------------------------------------------------------------------------------------------
#----------------------------------------------- Clock Gating ----------------------------------------------
#-----------------------------------------------------------------------------------------------------------
set_dont_use TLATX3 false

set_db / .lp_insert_clock_gating true
set_db / .lp_clock_gating_prefix ClkGate
set_db / .lp_clock_gating_exceptions_aware true

#-----------------------------------------------------------------------------------------------------------
#------------------------------------------------ Elaboration ----------------------------------------------
#-----------------------------------------------------------------------------------------------------------
elaborate
write_hdl -generic > ./${RESULT_DIR}/elaborated_${TOP_CELL_NAME}.v

#More Clock Gating settings after elaboration
set_db [get_db designs] .lp_clock_gating_cell [vfind / -lib_cell  "TLATX3"]
set_db [get_db designs] .lp_clock_gating_style latch
set_db [get_db designs] .lp_clock_gating_control_point precontrol
set_db [vfind / -hinst I_TEST_CONTROLLER] .lp_clock_gating_exclude true
set_db [vfind / -hinst I_NANDTREE] .lp_clock_gating_exclude true

#-----------------------------------------------------------------------------------------------------------
#--------------------------------------------- Timing Constrains -------------------------------------------
#-----------------------------------------------------------------------------------------------------------
source timing_constraints.tcl

#-----------------------------------------------------------------------------------------------------------
#---------------------------------------------------- DFT --------------------------------------------------
#-----------------------------------------------------------------------------------------------------------

	set_db / .dft_scan_style muxed_scan
	
	set_db [vfind / -hinst I_SPARE_0] .preserve size_ok
	set_db [vfind / -hinst I_SPARE_1] .preserve size_ok
	set_db [vfind / -hinst I_SPARE_2] .preserve size_ok
	set_db [vfind / -hinst I_SPARE_3] .preserve size_ok
	set_db / .ignore_preserve_in_tiecell_insertion true

	define_test_mode -name TST_NANDTREE -active low [vfind / -hpin "test_sel_o[1]"]
	define_test_mode -name TST_TRISTATE -active low [vfind / -hpin "test_sel_o[2]"]
	define_test_mode -name RFU1 -active low [vfind / -hpin "test_sel_o[3]"]
	define_test_mode -name RFU2 -active low [vfind / -hpin "test_sel_o[4]"]
	define_test_mode -name TST_CLK -active low [vfind / -hpin "test_sel_o[5]"]
	define_test_mode -name TST_ATPG -active high [vfind / -hpin "test_sel_o[6]"]
	define_test_mode -name RFU3 -active low [vfind / -hpin "test_sel_o[7]"]
	define_test_mode -name RFU4 -active low [vfind / -hpin "test_sel_o[8]"]
	define_test_mode -name RFU5 -active low [vfind / -hpin "test_sel_o[9]"]
	define_test_mode -name RFU6 -active low [vfind / -hpin "test_sel_o[10]"]
	define_test_mode -name RFU7 -active low [vfind / -hpin "test_sel_o[11]"]
	define_test_mode -name RFU8 -active low [vfind / -hpin "test_sel_o[12]"]
	define_test_mode -name RFU9 -active low [vfind / -hpin "test_sel_o[13]"]
	define_test_mode -name RFU10 -active low [vfind / -hpin "test_sel_o[14]"]
	define_test_mode -name RFU11 -active low [vfind / -hpin "test_sel_o[15]"]	
	
	define_test_mode -name RESET -active high [vfind / -port  "reset_n_i"] 
	define_test_mode -name TST_EN -active high [vfind / -hpin "tif_reset_n_i"] 

	define_shift_enable -name scan_en_i -active high -default [vfind / -port "test_in_i[4]"]
	define_test_clock -name SCAN_CLK -domain SCAN_CLK_DOMAIN -fall 100 -divide_fall 100 -period 1000000 [vfind / -port "test_in_i[5]"]
	
	define_scan_preserved_segment -name spare_scan_0 -sdi hpin:DIGITALTEIL/I_LOGIC/I_SPARE_0/si -sdo hpin:DIGITALTEIL/I_LOGIC/I_SPARE_0/so -analyze 
	define_scan_preserved_segment -name spare_scan_1 -sdi hpin:DIGITALTEIL/I_LOGIC/I_SPARE_1/si -sdo hpin:DIGITALTEIL/I_LOGIC/I_SPARE_1/so -analyze 
	define_scan_preserved_segment -name spare_scan_2 -sdi hpin:DIGITALTEIL/I_LOGIC/I_SPARE_2/si -sdo hpin:DIGITALTEIL/I_LOGIC/I_SPARE_2/so -analyze 
	define_scan_preserved_segment -name spare_scan_3 -sdi hpin:DIGITALTEIL/I_LOGIC/I_SPARE_3/si -sdo hpin:DIGITALTEIL/I_LOGIC/I_SPARE_3/so -analyze

	define_scan_chain -name scan_chain_core_0 -domain SCAN_CLK_DOMAIN  -sdi [vfind / -port "test_in_i[0]"] -sdo [vfind / -port "test_out_o[0]"] -shared_output -terminal_lockup edge_sensitive -shift_enable scan_en_i
	define_scan_chain -name scan_chain_core_1 -domain SCAN_CLK_DOMAIN  -sdi [vfind / -port "test_in_i[1]"] -sdo [vfind / -port "test_out_o[1]"] -shared_output -terminal_lockup edge_sensitive -shift_enable scan_en_i
	define_scan_chain -name scan_chain_core_2 -domain SCAN_CLK_DOMAIN  -sdi [vfind / -port "test_in_i[2]"] -sdo [vfind / -port "test_out_o[2]"] -shared_output -terminal_lockup edge_sensitive -shift_enable scan_en_i
	define_scan_chain -name scan_chain_core_3 -domain SCAN_CLK_DOMAIN  -sdi [vfind / -port "test_in_i[3]"] -sdo [vfind / -port "test_out_o[3]"] -shared_output -terminal_lockup edge_sensitive -shift_enable scan_en_i

	set_db [vfind / -hinst I_TEST_CONTROLLER] .dft_dont_scan true
	set_db [vfind / -hinst I_CLK_RES] .dft_dont_scan true

	set_db / .dft_identify_top_level_test_clocks false
	set_db / .dft_identify_test_signals  false
	set_db [get_db designs] .dft_mix_clock_edges_in_scan_chains true
	set_db / .dft_prefix DFT_

	set_db [get_db designs] .lp_clock_gating_test_signal scan_en_i
	check_dft_rules -max_print_violations 30
	#fix_dft_violations -clock -test_control scan_en_i

#-----------------------------------------------------------------------------------------------------------
#------------------------------------------------ Synthesize -----------------------------------------------
#-----------------------------------------------------------------------------------------------------------
syn_generic
write_hdl -generic > ./${RESULT_DIR}/${TOP_CELL_NAME}.generic

syn_map 
write_hdl > ./${RESULT_DIR}/${TOP_CELL_NAME}.mapped

	connect_scan_chains 

syn_opt -incremental

write_hdl > ./${RESULT_DIR}/${TOP_CELL_NAME}.v

	write_scandef > ./${RESULT_DIR}/${TOP_CELL_NAME}_scan.def

check_design -all $TOP_CELL_NAME > ./$REPORT_DIR/check/$TOP_CELL_NAME.all

# For Power Analysis
set_db / .lp_power_unit mW
set_db [vfind / -clock "TSTCLK"] .lp_default_toggle_percentage 0

report_clocks > ./${REPORT_DIR}/${TOP_CELL_NAME}.clocks
report_timing -max_paths 50 -nworst 50 > ./${REPORT_DIR}/${TOP_CELL_NAME}.timing
report_timing -lint -verbose   > ./${REPORT_DIR}/${TOP_CELL_NAME}.timing_lint
report_qor > ./${REPORT_DIR}/${TOP_CELL_NAME}.qor
report_messages > ./${REPORT_DIR}/${TOP_CELL_NAME}.messages
report_area > ./${REPORT_DIR}/${TOP_CELL_NAME}.area
report_gates > ./${REPORT_DIR}/${TOP_CELL_NAME}.gates
report_power -hier -depth 2 -verbose > ./${REPORT_DIR}/${TOP_CELL_NAME}.power
report_power -verbose > ./${REPORT_DIR}/${TOP_CELL_NAME}.powerall
report_clock_gating -detail > ./${REPORT_DIR}/${TOP_CELL_NAME}.gating_detail
report_clock_gating > ./${REPORT_DIR}/${TOP_CELL_NAME}.gating

	report dft_violations > ./${REPORT_DIR}/${TOP_CELL_NAME}.violations
	report dft_registers > ./${REPORT_DIR}/${TOP_CELL_NAME}.registers
	report dft_chains > ./${REPORT_DIR}/${TOP_CELL_NAME}.chains

write_sdf > ./${RESULT_DIR}/${TOP_CELL_NAME}.sdf
write_sdc  > ./${RESULT_DIR}/${TOP_CELL_NAME}.sdc

# For Innovus 
set_max_capacitance $MAX_NET_CAP_LOAD_PR
set_max_transition $MAX_TRANSITIONS_PR
set_clock_uncertainty -setup $CLK_SETUP_UNCERT_PR SYSCLK
set_clock_uncertainty -hold $CLK_HOLD_UNCERT_PR SYSCLK
set_clock_uncertainty -setup $CLK_SETUP_UNCERT_PR TSTCLK
set_clock_uncertainty -hold $CLK_HOLD_UNCERT_PR TSTCLK

write_design -basename ../prINNO/INNO/${TOP_CELL_NAME} -innovus

exit
	

		








