#-----------------------------------------------------------------------------------------------------------
#--------------------------------------- GENUS synthesize file ---------------------------------------------
#-----------------------------------------------------------------------------------------------------------
set DESIGN_PATH { /Abteilungen/ISS/ISS-ALL/unix/cad/RISCV/local/riscv-flavor/trunk/flavor/src/modules/raifes_dtm/src}

set DESIGN_FILES { raifes_dtm.v }

set LIB_PATH /sw/ims_db/lib/L035/l035v0v6dc/.lib/layout/
set LEF_FILE L035dc.lef

set RESULT_DIR {results}
set REPORT_DIR {reports}
set TOP_CELL_NAME raifes_dtm

set_db / .information_level 8
 
#-----------------------------------------------------------------------------------------------------------
#-------------------------------- Set tech library path, files and options ---------------------------------
#-----------------------------------------------------------------------------------------------------------
read_mmmc ./MMMC.tcl
read_physical -lef /sw/ims_db/lib/L035/l035v0v6dc/.lib/layout/L035dc.lef

set_db / .max_cpus_per_server 8
set_db / .use_tiehilo_for_const duplicate
set_db / .remove_assigns true
set_db / .auto_ungroup none


set_db / .syn_generic_effort high
set_db / .syn_map_effort high
set_db / .syn_opt_effort high

#Enables the most aggressive area-mode optimization, might degrade timing.
set_db / .dp_analytical_opt extreme

#Enables analytical optimizations, which reduces area without degradaded timing.
set_db / .dp_analytical_opt standard

set_db / .ultra_global_mapping true

#-----------------------------------------------------------------------------------------------------------
#---------------------------- Set design library search path and design files ------------------------------
#-----------------------------------------------------------------------------------------------------------
set_db / .hdl_language v2001
set_db / .init_hdl_search_path $DESIGN_PATH 
read_hdl $DESIGN_FILES

#set_db / .hdl_language v2001
#set_db / .init_hdl_search_path $DESIGN_PATH 
#read_hdl $SPARE_CELLS

set_db / .hdl_track_filename_row_col true
set_db / .hdl_preserve_unused_registers true

#-----------------------------------------------------------------------------------------------------------
#------------------------------------------------ Elaboration ----------------------------------------------
#-----------------------------------------------------------------------------------------------------------
elaborate
write_hdl -generic > ./${RESULT_DIR}/elaborated_${TOP_CELL_NAME}.v

set_dont_use TLATX3 false


#-----------------------------------------------------------------------------------------------------------
#------------------------------------------------ Synthesize -----------------------------------------------
#-----------------------------------------------------------------------------------------------------------
init_design 

syn_generic
write_hdl -generic > ./${RESULT_DIR}/${TOP_CELL_NAME}.generic

syn_map 
write_hdl > ./${RESULT_DIR}/${TOP_CELL_NAME}.mapped

#	connect_scan_chains 

syn_opt -incremental

write_hdl > ./${RESULT_DIR}/${TOP_CELL_NAME}.v

#	write_scandef > ./${RESULT_DIR}/${TOP_CELL_NAME}_scan.def

check_design -all $TOP_CELL_NAME > ./$REPORT_DIR/check/$TOP_CELL_NAME.all

# For Power Analysis
set_db / .lp_power_unit uW
write_design -basename ./SAVED_STATE/${TOP_CELL_NAME}

report_clocks > ./${REPORT_DIR}/${TOP_CELL_NAME}.clocks
report_timing -max_paths 50 -nworst 50 > ./${REPORT_DIR}/${TOP_CELL_NAME}.timing
report_timing -lint -verbose   > ./${REPORT_DIR}/${TOP_CELL_NAME}.timing_lint
report_qor > ./${REPORT_DIR}/${TOP_CELL_NAME}.qor
report_area > ./${REPORT_DIR}/${TOP_CELL_NAME}.area
report_gates > ./${REPORT_DIR}/${TOP_CELL_NAME}.gates
report_clock_gating -detail > ./${REPORT_DIR}/${TOP_CELL_NAME}.gating_detail
report_clock_gating > ./${REPORT_DIR}/${TOP_CELL_NAME}.gating

	report dft_violations > ./${REPORT_DIR}/${TOP_CELL_NAME}.violations
	report dft_registers > ./${REPORT_DIR}/${TOP_CELL_NAME}.registers
	report dft_chains > ./${REPORT_DIR}/${TOP_CELL_NAME}.chains


write_sdf > ./${RESULT_DIR}/${TOP_CELL_NAME}.sdf
write_sdc  -view slow_ss > ./${RESULT_DIR}/${TOP_CELL_NAME}.sdc 

set_analysis_view -setup { slow_ss } -hold  { fast_ff }
write_design -basename ../prINNO/INNO/${TOP_CELL_NAME} -innovus

report_messages > ./${REPORT_DIR}/${TOP_CELL_NAME}.messages
exit






