`include "../src/raifes_ctrl_constants.vh"
`include "../src/raifes_csr_addr_map.vh"
`include "../src/raifes_hasti_constants.vh"
`include "../src/raifes_alu_ops.vh"
`include "../src/rv32_opcodes.vh"
`include "../src/raifes_platform_constants.vh"
`include "../src/raifes_hasti_constants.vh"

module raifes_top_tb();

reg	CLK, RESET;
integer	testcase;
integer i;
reg	[31:0]	theword;
reg	tck;
reg	tms;
reg	tdi;
wire	tdo;
wire [3:0] dm_state;


wire	IRAM_IO0, IRAM_IO1, IRAM_IO2, IRAM_IO3;
wire	IRAM_IO0_Out, IRAM_IO0_En;
wire	IRAM_IO1_Out, IRAM_IO1_En;
wire	IRAM_IO2_Out, IRAM_IO2_En;
wire	IRAM_IO3_Out, IRAM_IO3_En;

wire	IRAM_nHSB_Out;
wire	IRAM_SCK, IRAM_nCS, IRAM_nHSB;

buf (weak1, weak0) inhsb_buf (IRAM_nHSB, 1'b1);

assign	IRAM_IO0 = IRAM_IO0_En ? IRAM_IO0_Out : 1'bZ;
assign	IRAM_IO1 = IRAM_IO1_En ? IRAM_IO1_Out : 1'bZ;
assign	IRAM_IO2 = IRAM_IO2_En ? IRAM_IO2_Out : 1'bZ;
assign	IRAM_IO3 = IRAM_IO3_En ? IRAM_IO3_Out : 1'bZ;
buf (weak1, weak0) iio3_buf (IRAM_IO3, 1'b1);

wire	[`DMI_ADDR_WIDTH-1:0]	dmi_addr;
wire	[`DMI_WIDTH-1:0]	dmi_wdata;
wire	[`DMI_WIDTH-1:0]	dmi_rdata;
wire				dmi_en;
wire				dmi_wen;
wire				dmi_error;
wire				dmi_dm_busy;
wire	[3:0]			debug_state;

wire	[7:0]	GPIO_D, GPIO_EN;
reg	[7:0]	GPIO_I;



raifes_dtm	dtm(
		.tck(tck),
		.tms(tms),
		.tdi(tdi),
		.tdo(tdo),		
		.dmi_addr(dmi_addr),
		.dmi_en(dmi_en),
		.dmi_error(dmi_error),
		.dmi_wen(dmi_wen),
		.dmi_wdata(dmi_wdata),
		.dmi_rdata(dmi_rdata),
		.dmi_dm_busy(dmi_dm_busy),
		.debug_state(debug_state)
		);


raifes_top_asic_qspi DUT(
	.clk(CLK),
	.reset(RESET),

	.dm_state(dm_state),

	.iIRAM_IO0_In(IRAM_IO0),
	.oIRAM_IO0_Out(IRAM_IO0_Out),
	.oIRAM_IO0_En(IRAM_IO0_En),

	.iIRAM_IO1_In(IRAM_IO1),
	.oIRAM_IO1_Out(IRAM_IO1_Out),
	.oIRAM_IO1_En(IRAM_IO1_En),

	.iIRAM_IO2_In(IRAM_IO2),
	.oIRAM_IO2_Out(IRAM_IO2_Out),
	.oIRAM_IO2_En(IRAM_IO2_En),

	.iIRAM_IO3_In(IRAM_IO3),
	.oIRAM_IO3_Out(IRAM_IO3_Out),
	.oIRAM_IO3_En(IRAM_IO3_En),

	.oIRAM_SCK(IRAM_SCK),
	.oIRAM_nCS(IRAM_nCS),
	.iIRAM_nHSB(IRAM_nHSB),

	.oGPIO_D(GPIO_D),
	.oGPIO_EN(GPIO_EN),
	.iGPIO_I(GPIO_I),
	
	.dmi_addr(dmi_addr),
	.dmi_en(dmi_en),
	.dmi_error(dmi_error),
	.dmi_wen(dmi_wen),
	.dmi_wdata(dmi_wdata),
	.dmi_rdata(dmi_rdata),
	.dmi_dm_busy(dmi_dm_busy)
);

reg VDD;
wire	IRAM_INT;
buf (weak0, weak1) imem_int_buf (IRAM_INT, 1'b1);
buf (weak0, weak1) imem_wp_buf (IRAM_IO2, 1'b1);

`include  "CY14V101QS_official/config.v"
`include  "CY14V101QS_official/params.v"


		cy14v101xs IMEM( 
			.IO3_PIN(IRAM_IO3),
			.SCE_PIN(IRAM_nCS),
			.SO_PIN(IRAM_IO1),
			.WP_PIN(IRAM_IO2),
			.HSB_PIN(IRAM_nHSB),
			.SI_PIN(IRAM_IO0),
			.SCK_PIN(IRAM_SCK),
			.VCC(VDD));
`define CLK_PERIOD 1

always begin
	#5
	CLK <= ~CLK;
end

reg [31:0] result;

reg [31:0] memimg[256000000-1:0];

`include "jtag_tasks.vh"

initial begin
	VDD <= 1'b0;
	CLK <= 1'b0;
	RESET <= 1'b0;
	#53; 
	VDD <= 1'b1; CLK <= 1'b0; RESET <= 1'b1; GPIO_I = 8'b10101010;
	RESET <= 1'b1;
//	$monitor("addr: ", DUT.dmi_addr, " wen: ", DUT.dmi_wen, " en: ", DUT.dmi_en, " rdata: %h", DUT.dmi_rdata, " wdata: %h", DUT.dmi_wdata);
	#53 RESET <= 1'b1;
	tms <= 1'b0; tdi <= 1'b0; tck <= 1'b0;
//	$readmemh("./memfiles/rv32ui-p-addi.mem",DUT.myRAM.mem);		
	$write("wait for NVRAM..");
	#2000000;
	$shm_open("output.shm");
	$shm_probe("AC");
	RESET <= 1'b1;
	#100;
	RESET <= 1'b0;
	// JTAG TAP reset
	jtag_tap_reset;
	// send halt request
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	// stay and wait ...
	jtag_wait8;
	// read debug status
	jtag_dmi_read(5'h12,result);
	// send resume request
	jtag_dmi_write(5'h10,32'h40000000,2'h2,result);
	// send halt request

	// read program into buffer
	$readmemh("./memfiles/rv32ui-p-sw.mem",memimg);

	// write to QSPI-Flash via JTAG
	for (i = 0; i < 1023; i = i + 1) begin
		jtag_write_mem(32'h80000000 + i*4,memimg[i],result);
	end
	$write("finished loading program into memory, now run it ...");
	#1000 RESET <= 1'b1;
	#100 RESET <= 1'b0;
	#300000;
	$finish();
/*
// ===================================
// == Test Program - "RISCV_Test"    =
// ===================================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$display("reading mem file RISC_Test.mem ..		");	
	$display("");
	$readmemh("./memfiles/RISC_Test.mem",DUT.myRAM.mem);
	//$monitor("tohost: %c",DUT.myRAM.mem[49153], " i-addr:%h", DUT.imem_haddr," d-addr:%h", DUT.myRAM.ADDRA, " d-data:%h", DUT.myRAM.DIA, " write:%b", DUT.writea);	
	//$monitor("%c\n",DUT.myRAM.mem[49153]);

	#50 RESET <= 1'b0;
	#1800000
	$display("\n\n");
	#2
//	$display("%h",DUT.myRAM.mem[3092]);
//	$finish();

// =====================
// == ISA test - SB    =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-sb.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-sb.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#40000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2


// =====================
// == ISA test - SW    =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-sw.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-sw.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#20000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - LW    =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-lw.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-lw.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2



// ====================
// == 1 - ISA test - ADDI  =
// ====================
	testcase = 1;
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-add.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-addi.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2
	
// ====================
// == 2- ISA test - ADD  =
// ====================
	testcase = 2;
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-add.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-add.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// ====================
// == 3 - ISA test - ANDI =
// ====================
	testcase = 3;
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-andi.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-andi.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// ====================
// == 4 - ISA test - AND  =
// ====================
	testcase = 4;
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-and.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-and.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#20000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// ======================
// == 5 - ISA test - AUIPC  =
// ======================
	testcase = 5;	
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-auipc.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-auipc.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// ====================
// == ISA test - BEQ  =
// ====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-beq.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-beq.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// ====================
// == ISA test - BGE  =
// ====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-bge.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-bgeu.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// ====================
// == ISA test - BLT  =
// ====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-blt.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-blt.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - BLTU  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-bltu.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-bltu.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2


// =====================
// == ISA test - BNE  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-bne.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-bne.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// ========================
// == ISA test - FENCE_I  =
// ========================
	testcase = 11;
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-fence_i.mem ..	");	
	$readmemh("./memfiles/rv32ui-p-fence_i.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#20000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - JAL   =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-jal.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-jal.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - JALR  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-jalr.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-jalr.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - LB    =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-lb.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-lb.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - LBU  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-lbu.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-lbu.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - LH    =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-lh.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-lh.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - LHU   =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-lhu.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-lhu.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - LUI   =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-lui.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-lui.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - ORI   =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-ori.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-ori.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2


// =====================
// == ISA test - OR  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-or.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-or.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#20000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2


// =====================
// == ISA test - SH  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-sh.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-sh.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - SIMPLE  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-simple.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-simple.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - SLLI  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-slli.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-slli.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - SLL  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-sll.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-sll.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#20000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - SLTI  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-slti.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-slti.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - SLTIU  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-sltiu.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-sltiu.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - SLT   =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-slt.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-slt.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - SLTU  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-sltu.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-sltu.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - SRAI  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-srai.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-srai.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - SRA   =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-sra.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-sra.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#20000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - SRLI  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-srli.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-srli.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - SRL   =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-srl.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-srl.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#20000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - SUB   =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-sub.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-sub.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - XORI  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-xori.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-xori.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#10000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2

// =====================
// == ISA test - XOR  =
// =====================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$write("reading mem file rv32ui-p-xor.mem ..		");	
	$readmemh("./memfiles/rv32ui-p-xor.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	#20000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	else $strobe("ERROR.\n");
	#2







// =============================================================================================
// == Dhrystone benchmark								       =
// =============================================================================================
	RESET <= 1'b1;
	CLK <= 1'b0;
	$strobe("reading mem file benchmark.mem ..		");	
	$readmemh("./memfiles/benchmark.mem",DUT.myRAM.mem);
	#50 RESET <= 1'b0;
	$monitor("Start/Stop-Flag, mem[4262] = %h @ %d, toHost = %h",DUT.myRAM.mem[4262],$time,DUT.myRAM.mem[1024]);	
	#6600000
//	DUT.myRAM.mem[1040] = 32'h13371337;
//	DUT.myRAM.mem[1041] = 32'h13371337;
	#300000
	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
	#2
	$strobe("Begin Time\t: %h",DUT.myRAM.mem[4261]);
	$strobe("End Time\t: %h",DUT.myRAM.mem[4258]);
	$strobe("Usertime\t: %h",DUT.myRAM.mem[4259]);
	$strobe("out: %h %h %h %h %h %h %h %h",DUT.myRAM.mem[39360],DUT.myRAM.mem[39361],DUT.myRAM.mem[39362],DUT.myRAM.mem[39363],DUT.myRAM.mem[39364],DUT.myRAM.mem[39365],DUT.myRAM.mem[39366],DUT.myRAM.mem[39367]);
	$strobe("");
	#4 for(i = 0; i <= 63; i = i + 1) begin
//		theword = DUT.myRAM.mem[6832+i];
		theword = DUT.myRAM.mem[39606+i];
		$write("%c",(theword & 16'hff));
		$write("%c",((theword >> 8) & 16'hff));
		$write("%c",((theword >> 16) & 16'hff));
		$write("%c",((theword >> 24) & 16'hff));
	end
	#4 $strobe("");
	$strobe("Best DMIPS/MHz (15.02.18, ASt) = (1.000.000cyc / 597cyc) / 1757 = 0,953 DMIPS/MHz");
	#1 $finish();
	$shm_close();
*/
end
endmodule // raifes_sim_top
