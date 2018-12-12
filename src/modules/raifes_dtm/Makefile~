# RISC-V core

topmodule = raifes_core
bench = worklib.raifes_top_tb:v

topdir = .
simdir = ./simIUS
srcdir = ./tb
covdir = ./coverage
syndir = ./synGENUS
prdir  = ./prINNO
atpgdir = ./dftET

# L035
libdir = /sw/ims_db/lib/L035/l035v0v5dc/.lib/

# XH018 D_CELLS_HD
#libdir = /sw/lx_sw/lxcad/pdks/XFab/xh18/XKIT/xh018/diglibs/D_CELLS_HD/v3_0/

# Standard Cell Library

# L035
DCLIB = ${libdir}/verilog/L035dc.v

# XH018 D_CELLS_HD
#DCLIB = "${libdir}verilog/v3_0_0/D_CELLS_HD.v"
 
#DCLIB2 = "${libdir}verilog/v3_0_0/VLG_PRIMITIVES.v"

## Simulation testbench and files
TBFILES =\
${topdir}/tb/raifes_top_tb.v \
${topdir}/tb/raifes_top.v \
${topdir}/tb/raifes_dp_hasti_sram.v \
${topdir}/tb/RAMB36_model.v

## Simulation testbench for virtual prototyping
TBFILES_VPI =\
${topdir}/tb/raifes_top_tb_vpi.v \
${topdir}/tb/raifes_top.v \
${topdir}/tb/raifes_dp_hasti_sram.v \
${topdir}/tb/RAMB36_model.v \
${topdir}/tb/jtag_vpi-master/jtag_vpi-master/jtag_vpi.v


## Synthesis files
HDLFILES =\
${topdir}/src/raifes_alu.v \
${topdir}/src/raifes_csr_file.v \
${topdir}/src/raifes_ctrl.v \
${topdir}/src/raifes_hasti_bridge.v \
${topdir}/src/raifes_sync_to_hasti_bridge.v \
${topdir}/src/raifes_imm_gen.v \
${topdir}/src/raifes_PC_mux.v \
${topdir}/src/raifes_pipeline.v \
${topdir}/src/raifes_regfile.v \
${topdir}/src/raifes_src_a_mux.v \
${topdir}/src/raifes_src_b_mux.v \
${topdir}/src/raifes_core.v \
${topdir}/src/raifes_debug_module.v \
${topdir}/src/raifes_dtm.v \
$(TBFILES) $(SINCNL)

## VPI files
HDLFILES_VPI =\
${topdir}/src/raifes_alu.v \
${topdir}/src/raifes_csr_file.v \
${topdir}/src/raifes_ctrl.v \
${topdir}/src/raifes_hasti_bridge.v \
${topdir}/src/raifes_sync_to_hasti_bridge.v \
${topdir}/src/raifes_imm_gen.v \
${topdir}/src/raifes_PC_mux.v \
${topdir}/src/raifes_pipeline.v \
${topdir}/src/raifes_regfile.v \
${topdir}/src/raifes_src_a_mux.v \
${topdir}/src/raifes_src_b_mux.v \
${topdir}/src/raifes_core.v \
${topdir}/src/raifes_debug_module.v \
${topdir}/src/raifes_dtm.v \
$(TBFILES_VPI) $(SINCNL)


## Postsynthesis simulation.
POSTSYN_HDLFILES =\
$(syndir)/results/$(topmodule).v \
$(topdir)/tb/raifes_top_tb_postsyn.v \
${topdir}/tb/raifes_top.v \
${topdir}/src/raifes_dtm.v \
${topdir}/tb/RAMB36_model.v

## ATPG simulation files 
ATPG_HDLFILES =\
$(syndir)/results/$(topmodule).v \
${topdir}/dftET/testresults/verilog/VER.FULLSCAN.mainsim.v

## Post-PR simulation.
POSTPR_HDLFILES =\
$(prdir)/results/$(topmodule).v \
$(topdir)/tb/raifes_top_tb_postsyn.v \
${topdir}/tb/raifes_top.v \
${topdir}/src/raifes_dtm.v \
${topdir}/tb/RAMB36_model.v

## Simulator command
HDLCOM = irun
SDFCOM = ncsdfc

## General Compiler options
ALLHDLCOMOPTS +=\
-assert \
+nctimescale+1ns/1ps \
-incdir ../src/ \

# Module HDL compiler options
MODHDLCOMOPTS =\
-access +rc \
-covoverwrite \
$(ALLHDLCOMOPTS)
 
## Postsynthesis SDF file
POSTSYN_SDFFILE =\
$(syndir)/results/$(topmodule).sdf

## Postlayout SDF file
POSTPR_SDFFILE =\
$(prdir)/results/$(topmodule).sdf

#-define POSTLAYOUT_SIM \
#-define POSTPR_SIM  \
#-define SYN \


POSTSYN_MODHDLCOMOPTS =\
$(ALLHDLCOMOPTS)\
-input @"database -open simout_postsyn -shm; probe -create raifes_top_tb -depth all -all -shm -database simout_postsyn;run" \
-logfile logfile_postsyn.log \
-ncelabargs "-sdf_cmd_file raifes_core.sdf_cmd -sdf_verbose" \
+maxdelays \
-access +rwc

# -input @"database -open simout_atpg -shm; probe -create raifes_core_inst -depth all -all -shm -database simout_atpg;run" \

ATPG_MODHDLCOMOPTS =\
$(ALLHDLCOMOPTS)\
-input @"run" \
+TESTFILE1=../dftET/testresults/verilog/VER.FULLSCAN.data.logic.ex1.ts1.verilog



POSTPR_MODHDLCOMOPTS =\
$(ALLHDLCOMOPTS)\
-ncelabargs "-sdf_cmd_file raifes_core.sdf_cmd"
#-define POSTPR_SIM \
#-gui \
#-logfile logfile_postpr.log \
#-input @"run" \
#-input @"dumptcf -end" \
#-ncsimargs "-input restore_postpr.tcl" \
#-input @"dumptcf -internal -overwrite -scope tbTagTop.DUT -output pr.tcf" \
#-input @"run" \
#-input @"dumptcf -end" \
-logfile logfile_postpr.log
POSTPR_MODHDLCOMOPTS_MIN =\
$(ALLHDLCOMOPTS)\
-ncelabargs "-sdf_cmd_file raifes_core.sdf_cmd_min"
POSTPR_MODHDLCOMOPTS_MAX =\
$(ALLHDLCOMOPTS)\
-ncelabargs "-sdf_cmd_file raifes_core.sdf_cmd_max"

sim:
	cd $(simdir); \
	$(HDLCOM) $(MODHDLCOMOPTS) \
    	-linedebug -v $(DCLIB) ${IOLIB} -input simsetup.tcl \
	$(foreach hdlfile,$(HDLFILES),../$(hdlfile))

sim_vpi:
	cd $(simdir); \
	$(HDLCOM) -64bit -profile -q +access+r \
	-loadvpi ../tb/jtag_vpi-master/jtag_vpi-master/jtag_vpi:register_check_for_command,register_send_result_to_server,setup_endofcompile_callbacks,setup_finish_callbacks +jtag_vpi_enable=1 \
	$(MODHDLCOMOPTS) \
    	-v $(DCLIB) ${IOLIB} \
	$(foreach hdlfile,$(HDLFILES_VPI),../$(hdlfile))

new: compile elaborate

compile:
	cd $(simdir); \
	ncvlog -incdir ../src \
	$(DCLIB) \
	$(foreach hdlfile,$(HDLFILES),../$(hdlfile))

elaborate:
	cd $(simdir); \
	ncelab -work worklib -lib_binding $(bench)

simSyn:
	cd $(simdir); \
	$(SDFCOM) -Update -Output ./$(topmodule).sdf.X ../$(POSTSYN_SDFFILE) && \
	$(HDLCOM) $(POSTSYN_MODHDLCOMOPTS) -v ${DCLIB} -v ${DCLIB2} \
	$(foreach hdlfile,$(POSTSYN_HDLFILES),../$(hdlfile)) -end

simATPG:
	cd $(simdir); \
	$(SDFCOM) -Update -Output ./$(topmodule).sdf.X ../$(POSTSYN_SDFFILE) && \
	$(HDLCOM) $(ATPG_MODHDLCOMOPTS) -v ${DCLIB} -v ${DCLIB2} \
	$(foreach hdlfile,$(ATPG_HDLFILES),../$(hdlfile)) -end


simPR:
	cd $(simdir); \
	$(SDFCOM) -Update -Output ./$(topmodule).sdf.X ../$(POSTPR_SDFFILE) && \
	$(HDLCOM) $(POSTPR_MODHDLCOMOPTS) \
	-v $(DCLIB) \
	$(foreach hdlfile,$(POSTPR_HDLFILES),../$(hdlfile))

simPRall: simPRmin simPRmax

simPRmax:
	cd $(simdir); \
	$(SDFCOM) -Update -Output ./$(topmodule).sdf.X ../$(POSTPR_SDFFILE) && \
	$(HDLCOM) $(POSTPR_MODHDLCOMOPTS_MAX) \
	-v $(DCLIB) \
	$(foreach hdlfile,$(POSTPR_HDLFILES),../$(hdlfile))
simPRmin:
	cd $(simdir); \
	$(SDFCOM) -Update -Output ./$(topmodule).sdf.X ../$(POSTPR_SDFFILE) && \
	$(HDLCOM) $(POSTPR_MODHDLCOMOPTS_MIN) \
	-v $(DCLIB) \
	$(foreach hdlfile,$(POSTPR_HDLFILES),../$(hdlfile))

check:
	cd $(simdir); \
	$(HDLCOM) $(ALLHDLCOMOPTS) -elaborate \
	-v $(DCLIB) $(IOLIB) \
	$(foreach hdlfile,$(HDLFILES),../$(hdlfile))

syn:
	cd $(syndir); \
	genus -file synthesize_single_run_mmmc.tcl

pr:
	cd $(prdir); \
	innovus -win -init pr_easy.tcl -wait 10

atpg:
	cd $(atpgdir); \
	et -tcl atpg.tcl

clean:
	rm $(topdir)/*.log \
	rm $(simdir)/*.key \
	rm $(simdir)/*.log \
	rm $(simdir)/*.X \
	rm -rf $(simdir)/*.shm \
	rm -rf $(simdir)/INCA_libs \
	rm -rf $(simdir)/cov_work \
	rm -rf $(simdir)/coverage/* \
	rm -rf $(simdir)/reports/* \
	rm -rf $(syndir)/*.cmd* \
	rm -rf $(syndir)/*.log* \
	rm -rf $(prdir)/*.cmd* \
	rm -rf $(prdir)/*.log* \
	rm -rf $(atpgdir)/*.log* \
	rm -rf $(atpgdir)/*.cmd*
