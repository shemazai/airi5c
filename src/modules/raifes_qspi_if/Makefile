topmodule = raifes_qspi_if
bench = worklib.raifes_qspi_if_tb:v

topdir = .
simdir = ./simIUS

## Simulation testbench and files
TBFILES =\
${topdir}/raifes_qspi_if_tb.v \
${topdir}/CY14V101QS_official/cy14v101xs_ncvlog.vp

HDLFILES =\
${topdir}/raifes_qspi_if.v \
$(TBFILES)

## Simulator command
HDLCOM = irun
SDFCOM = ncsdfc

## General Compiler options
ALLHDLCOMOPTS +=\
+incdir+../CY14V101QS_official/ -incdir ../../..

# Module HDL compiler options
MODHDLCOMOPTS =\
-access +rc \
-covoverwrite \
$(ALLHDLCOMOPTS)

sim:
	cd $(simdir); \
	$(HDLCOM) $(MODHDLCOMOPTS) \
	$(foreach hdlfile,$(HDLFILES),../$(hdlfile))

new: compile elaborate

compile:
	cd $(simdir); \
	ncvlog -work worklib -incdir ../CY14V101QS_official/ \
	$(DCLIB) \
	$(foreach hdlfile,$(HDLFILES),../$(hdlfile))

elaborate:
	cd $(simdir); \
	ncelab -work worklib -lib_binding $(bench)


check:
	cd $(simdir); \
	$(HDLCOM) $(ALLHDLCOMOPTS) -elaborate \
	-v $(DCLIB) $(IOLIB) \
	$(foreach hdlfile,$(HDLFILES),../$(hdlfile))


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
