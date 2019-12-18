`include "../src/raifes_ctrl_constants.vh"
`include "../src/raifes_csr_addr_map.vh"
`include "../src/raifes_hasti_constants.vh"
`include "../src/raifes_alu_ops.vh"
`include "../src/rv32_opcodes.vh"
`include "../src/raifes_platform_constants.vh"
`include "../src/raifes_hasti_constants.vh"
`include "../src/modules/raifes_dtm/src/raifes_dmi_constants.vh"

`timescale 1ns/1ns

module raifes_top_tb();

reg	CLK, CLKQSPI, RESET;
integer	testcase;
integer i;

reg	tck;
reg	tms;
reg	tdi;
wire	tdo;


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


// ==========================================================
// ==		Core + Dual-Port-SRAM type memory	    =
// ==========================================================

wire	[`HASTI_ADDR_WIDTH-1:0]		imem_haddr;
wire					imem_hwrite;
wire	[`HASTI_SIZE_WIDTH-1:0]		imem_hsize;
wire	[`HASTI_BURST_WIDTH-1:0]	imem_hburst;
wire					imem_hmastlock;
wire	[`HASTI_PROT_WIDTH-1:0]		imem_hprot;
wire	[`HASTI_TRANS_WIDTH-1:0]	imem_htrans;
wire	[`HASTI_BUS_WIDTH-1:0]		imem_hwdata;
wire	[`HASTI_BUS_WIDTH-1:0]		imem_hrdata;
wire					imem_hready;
wire					imem_hresp;

wire	[`HASTI_ADDR_WIDTH-1:0]		dmem_haddr;
wire					dmem_hwrite;
wire	[`HASTI_SIZE_WIDTH-1:0]		dmem_hsize;
wire	[`HASTI_BURST_WIDTH-1:0]	dmem_hburst;
wire					dmem_hmastlock;
wire	[`HASTI_PROT_WIDTH-1:0]		dmem_hprot;
wire	[`HASTI_TRANS_WIDTH-1:0]	dmem_htrans;
wire	[`HASTI_BUS_WIDTH-1:0]		dmem_hwdata;
wire	[`HASTI_BUS_WIDTH-1:0]		dmem_hrdata;
wire					dmem_hready;
wire					dmem_hresp;

raifes_dp_hasti_sram SRAM(
			.hclk(CLK),
			.hresetn(~RESET),

			.p0_haddr({16'h0,dmem_haddr[15:0]}),
			.p0_hwrite(dmem_hwrite),
			.p0_hsize(dmem_hsize),
			.p0_hburst(dmem_hburst),
			.p0_hmastlock(dmem_hmastlock),
			.p0_hprot(dmem_hprot),
			.p0_htrans(dmem_htrans),
			.p0_hwdata(dmem_hwdata),
			.p0_hrdata(dmem_hrdata),
			.p0_hready(dmem_hready),
			.p0_hresp(dmem_hresp),

			.p1_haddr({16'h0,imem_haddr[15:0]}),
			.p1_hwrite(imem_hwrite),
			.p1_hsize(imem_hsize),
			.p1_hburst(imem_hburst),
			.p1_hmastlock(imem_hmastlock),
			.p1_hprot(imem_hprot),
			.p1_htrans(imem_htrans),
			.p1_hwdata(imem_hwdata),
			.p1_hrdata(imem_hrdata),
			.p1_hready(imem_hready),
			.p1_hresp(imem_hresp)
);

raifes_top_asic DUT(
	.clk(CLK),
	.reset(RESET),

	.imem_haddr(imem_haddr),
	.imem_hwrite(imem_hwrite),
	.imem_hsize(imem_hsize),
	.imem_hburst(imem_hburst),
	.imem_hmastlock(imem_hmastlock),
	.imem_hprot(imem_hprot),
	.imem_htrans(imem_htrans),
	.imem_hwdata(imem_hwdata),
	.imem_hrdata(imem_hrdata),
	.imem_hready(imem_hready),
	.imem_hresp(imem_hresp),

	.dmem_haddr(dmem_haddr),
	.dmem_hwrite(dmem_hwrite),
	.dmem_hsize(dmem_hsize),
	.dmem_hburst(dmem_hburst),
	.dmem_hmastlock(dmem_hmastlock),
	.dmem_hprot(dmem_hprot),
	.dmem_htrans(dmem_htrans),
	.dmem_hwdata(dmem_hwdata),
	.dmem_hrdata(dmem_hrdata),
	.dmem_hready(dmem_hready),
	.dmem_hresp(dmem_hresp),

	.oGPIO_D(GPIO_D),
	.oGPIO_EN(GPIO_EN),
	.iGPIO_I(GPIO_I),
	
	.dmi_addr(dmi_addr),
	.dmi_en(dmi_en),
	.dmi_error(dmi_error),
	.dmi_wen(dmi_wen),
	.dmi_wdata(dmi_wdata),
	.dmi_rdata(dmi_rdata),
	.dmi_dm_busy(dmi_dm_busy),
	
	.sdi(1'b0),
	.sen(1'b0)
);


// ==========================================================
// ==		Core + QSPI-Flash			    =
// ==========================================================
/*

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


raifes_top_asic_qspi DUT(
	.clk(CLK),
	.clkQSPI(CLKQSPI),	// ASt, added 29.07.19
	.reset(RESET),

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
	.dmi_dm_busy(dmi_dm_busy),
	
	.sdi(1'b0),
	.sen(1'b0)
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

*/

`define CLK_PERIOD 128

always begin
	#64
	CLK <= ~CLK;
end

`define CLKQSPI_PERIOD 1

always begin
	#64
	CLKQSPI <= ~CLKQSPI;
end


reg [31:0] result;

reg [31:0] memimg[256000000-1:0];

reg [31:0] errorcount;


`include "jtag_tasks.vh"

task run_test_program;
input reg[7:0]	testnum;
input reg[255*8:1]	filename;
input reg[15:0]	length;
output reg[31:0] result;
begin
	testcase = testnum;	// marker variable so we can trace the results in simvision more easily.
	$write("read mem file for testcase ", testnum);
	// read program into buffer
	$readmemh(filename,memimg);

	// write to QSPI-Flash via JTAG
	for (i = 0; i < length; i = i + 1) begin
		if((i*100/length)%10 == 0) begin
			$write("progress: ",(i*100/length));
		end
		jtag_write_mem(32'h80000000 + i*4,memimg[i],result);
	end

	$write(" o.k., running..");
	//$monitor("tohost: %h",DUT.debug_out);

	#(10*`CLK_PERIOD) RESET <= 1'b1;
	#(3*`CLK_PERIOD) RESET <= 1'b0;
	#(5000*`CLK_PERIOD);

	if(DUT.debug_out == 1)begin
		result = 0;
		 $write("success.\n");
	end
	else begin
		$write("error.\n");
		result = 1;
	end
end
endtask

task run_test_program_break;
input reg[7:0]	testnum;
input reg[255*8:1]	filename;
input reg[15:0]	length;
output reg[31:0] result;
begin
	testcase = testnum;	// marker variable so we can trace the results in simvision more easily.
	$write("read mem file for testcase ", testnum);
	// read program into buffer
	$readmemh(filename,memimg);

	// write to QSPI-Flash via JTAG
	for (i = 0; i < length; i = i + 1) begin
		jtag_write_mem(32'h80000000 + i*4,memimg[i],result);
	end

	$write(" o.k., running..");
	$monitor("tohost: %h",DUT.debug_out);
	#1000 RESET <= 1'b1;
	#(3*`CLK_PERIOD) RESET <= 1'b0;
	#(10*`CLK_PERIOD);
	$write("JTAG TAP: send halt request.\n");
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	#(5000*`CLK_PERIOD);
	// abstract command to access register
	// dcsr for hart0 stepmode
	// 0000 0000 0000 0000 1111 0000 0000 0100
	jtag_dmi_write(5'h04,32'h0000f004,2'h2,result);	
	// write word to dcsr
	// 0000 0000 0010 0011 0000 0111 1011 0000
	jtag_dmi_write(5'h17,32'h002307b0,2'h2,result);
	// resume
	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	#(5000*`CLK_PERIOD);
	$write("JTAG TAP: send halt request.\n");
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	#(5000*`CLK_PERIOD);
	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	#(5000*`CLK_PERIOD);
	// abstract command to access register
	// dcsr for hart0 stepmode
	// 0000 0000 0000 0000 1111 0000 0000 0100
	jtag_dmi_write(5'h04,32'h0000f000,2'h2,result);	
	// write word to dcsr
	// 0000 0000 0010 0011 0000 0111 1011 0000
	jtag_dmi_write(5'h17,32'h002307b0,2'h2,result);
	// resume
	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	#(5000*`CLK_PERIOD);
	if(DUT.debug_out == 1)begin
		result = 0;
		 $write("success.\n");
	end
	else begin
		$write("error.\n");
		result = 1;
	end
end
endtask

initial begin
	$write("==================================\n");
	$write("==== FLAVOR TESTBENCH STARTET ====\n");
	$write("==================================\n");
	//$shm_open("output.shm");
	//$shm_probe("AC");
	
	//VDD <= 1'b0;
	CLK <= 1'b0;CLKQSPI <= 1'b0; RESET <= 1'b0;
	#(56*`CLK_PERIOD); 
	//VDD <= 1'b1; 
	CLK <= 1'b0; RESET <= 1'b1; GPIO_I = 8'b10101010;
	RESET <= 1'b1;
	#53 RESET <= 1'b1;
	tms <= 1'b0; tdi <= 1'b0; tck <= 1'b0;
	$write("waiting for NVRAM startup..\n");
	#2000000;
	$write("disabling RESET..\n");
	RESET <= 1'b1; #103 RESET <= 1'b0;
	$write("JTAG TAP: reset..\n");
	// JTAG TAP reset
	jtag_tap_reset;
	// send halt request	
	$write("JTAG TAP: send halt request.\n");
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	// stay and wait ...
	$write("JTAG TAP: wait some cycles.\n");
	jtag_wait8;
	// read debug status
	$write("JTAG TAP: Read status of debug module..\n");
	jtag_dmi_read(5'h12,result);
	// send resume request
	$write("JTAG TAP: Request resume..\n");
/*	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume*/
	#2000;
/*	$write("JTAG TAP: send halt request.\n");
	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
// GPIO-Test
	$write("===============\n");	
	$write("== GPIO test ==\n");
	$write("===============\n");
	$write("GPIO: set EN = HIGH for all pins\n");
	// GPIO_EN alle auf HIGH
	jtag_write_mem(32'hc0000004,32'hffffffff,result);
	// GPIO-Zustand lesen
	$write("GPIO: read state of inputs\n");
	jtag_read_mem(32'hc0000000,result);
	if(result == 32'haaaaaaaa) $write("success.\n");
	else begin 
		$write("error.\n");
	end
*/
// === nächsten Abschnitt unkommentieren, um ein Programm in den Speicher zu laden und auszuführen
	$write("===================== \n");
	$write("= Instruction Tests = \n");
	$write("===================== \n");

errorcount <= 0;
/*
// ========================
// == 255 - DM Test: Halt during Program =
// ========================
$write("Coremark : ");
run_test_program(255,"./memfiles/Raifes_Demo.mem",4700,result);
if(result != 0) errorcount = errorcount + 1;
*/

/*
// ========================
// == 0 - ISA test - MUL =
// ========================
$write("MUL   : ");
run_test_program(200,"./memfiles/benchmark.mem",16,result);
if(result != 0) errorcount = errorcount + 1;
*/

// ==============================
// == 1 - ISA test - ECALL/MRET =
// ==============================
$write("ECALL  : ");
run_test_program_break(1,"./memfiles/ecall.mem",262,result);
if(result != 0) errorcount = errorcount + 1;

// halt
#(100*`CLK_PERIOD) jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
// resume
#(100*`CLK_PERIOD) jtag_dmi_write(5'h10,32'h40000000,2'h2,result);
// halt
#(100*`CLK_PERIOD) jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
// resume
#(100*`CLK_PERIOD) jtag_dmi_write(5'h10,32'h40000000,2'h2,result);


$finish();

// ========================
// == 1 - ISA test - ADDI =
// ========================
$write("ADDI   : ");
run_test_program(1,"./memfiles/rv32ui-p-addi.mem",262,result);
if(result != 0) errorcount = errorcount + 1;

$finish();

// ====================
// == 2- ISA test - ADD  =
// ====================
$write("ADD    : ");
run_test_program(2,"./memfiles/rv32ui-p-add.mem",407,result);

if(result != 0) errorcount = errorcount + 1;

// ====================
// == 3 - ISA test - ANDI =
// ====================
$write("ANDI   : ");
run_test_program(3,"./memfiles/rv32ui-p-andi.mem",214,result);

if(result != 0) errorcount = errorcount + 1;

// ====================
// == 4 - ISA test - AND  =
// ====================
$write("AND    : ");
run_test_program(4,"./memfiles/rv32ui-p-and.mem",386,result);

if(result != 0) errorcount = errorcount + 1;

// ======================
// == 5 - ISA test - AUIPC  =
// ======================
$write("AUIPC  : ");
run_test_program(5,"./memfiles/rv32ui-p-auipc.mem",128,result);

if(result != 0) errorcount = errorcount + 1;

// ====================
// == 6 - ISA test - BEQ  =
// ====================
$write("BEQ    : ");
run_test_program(6,"./memfiles/rv32ui-p-beq.mem",256,result);

if(result != 0) errorcount = errorcount + 1;

// ====================
// == 7 - ISA test - BGE  =
// ====================
$write("BGE    : ");
run_test_program(7,"./memfiles/rv32ui-p-bge.mem",300,result);

if(result != 0) errorcount = errorcount + 1;

// ====================
// == 8 - ISA test - BLT  =
// ====================
$write("BLT    : ");
run_test_program(8,"./memfiles/rv32ui-p-blt.mem",280,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 9 - ISA test - BLTU  =
// =====================
$write("BLTU   : ");
run_test_program(9,"./memfiles/rv32ui-p-bltu.mem",274,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 10 - ISA test - BNE  =
// =====================
$write("BNE    : ");
run_test_program(10,"./memfiles/rv32ui-p-bne.mem",258,result);

if(result != 0) errorcount = errorcount + 1;

// ========================
// == 11 - ISA test - FENCE_I  =
// ========================
$write("FENCE_I: ");
run_test_program(11,"./memfiles/rv32ui-p-fence_i.mem",2060,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 12 - ISA test - JAL   =
// =====================
$write("JAL    : ");
run_test_program(12,"./memfiles/rv32ui-p-jal.mem",100,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 13 - ISA test - JALR  =
// =====================
$write("JALR   : ");
run_test_program(13,"./memfiles/rv32ui-p-jalr.mem",130,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 14 - ISA test - LB    =
// =====================
$write("LB     : ");
run_test_program(14,"./memfiles/rv32ui-p-lb.mem",2060,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 15 - ISA test - LBU  =
// =====================
$write("LBU    : ");
run_test_program(15,"./memfiles/rv32ui-p-lbu.mem",2060,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 16 - ISA test - LH    =
// =====================
$write("LH     : ");
run_test_program(16,"./memfiles/rv32ui-p-lh.mem",2060,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 17 - ISA test - LHU   =
// =====================
$write("LHU    : ");
run_test_program(17,"./memfiles/rv32ui-p-lhu.mem",2060,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 18 - ISA test - LUI   =
// =====================
$write("LUI    : ");
run_test_program(18,"./memfiles/rv32ui-p-lui.mem",100,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 19 - ISA test - LW   =
// =====================
$write("LW     : ");
run_test_program(19,"./memfiles/rv32ui-p-lw.mem",2060,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 20 - ISA test - OR  =
// =====================
$write("OR     : ");
run_test_program(20,"./memfiles/rv32ui-p-or.mem",390,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 21 - ISA test - ORI   =
// =====================
$write("ORI    : ");
run_test_program(21,"./memfiles/rv32ui-p-ori.mem",200,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 22 - ISA test - SB   =
// =====================
$write("SB     : ");
run_test_program(22,"./memfiles/rv32ui-p-sb.mem",2060,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 23 - ISA test - SH  =
// =====================
$write("SH     : ");
run_test_program(23,"./memfiles/rv32ui-p-sh.mem",2060,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 24 - ISA test - SLLI  =
// =====================
$write("SLLI   : ");
run_test_program(24,"./memfiles/rv32ui-p-slli.mem",243,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 25 - ISA test - SLL  =
// =====================
$write("SLL    : ");
run_test_program(25,"./memfiles/rv32ui-p-sll.mem",420,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 26 - ISA test - SLTI  =
// =====================
$write("SLTI   : ");
run_test_program(26,"./memfiles/rv32ui-p-slti.mem",244,result);

if(result != 0) errorcount = errorcount + 1;


// =====================
// == 27 - ISA test - SLTIU  =
// =====================
$write("SLTIU  : ");
run_test_program(27,"./memfiles/rv32ui-p-sltiu.mem",244,result);

if(result != 0) errorcount = errorcount + 1;


// =====================
// == 28 - ISA test - SLT  =
// =====================
$write("SLT    : ");
run_test_program(28,"./memfiles/rv32ui-p-slt.mem",386,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 29 - ISA test - SLTU  =
// =====================
$write("SLTU   : ");
run_test_program(29,"./memfiles/rv32ui-p-sltu.mem",386,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 30 - ISA test - SRAI  =
// =====================
$write("SRAI   : ");
run_test_program(30,"./memfiles/rv32ui-p-srai.mem",258,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 31 - ISA test - SRA  =
// =====================
$write("SRA    : ");
run_test_program(31,"./memfiles/rv32ui-p-sra.mem",434,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 32 - ISA test - SRLI  =
// =====================
$write("SRLI   : ");
run_test_program(32,"./memfiles/rv32ui-p-srli.mem",242,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 33 - ISA test - SRL  =
// =====================
$write("SRL    : ");
run_test_program(33,"./memfiles/rv32ui-p-srl.mem",434,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 34 - ISA test - SUB  =
// =====================
$write("SUB    : ");
run_test_program(34,"./memfiles/rv32ui-p-sub.mem",386,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 35 - ISA test - XORI  =
// =====================
$write("XORI   : ");
run_test_program(35,"./memfiles/rv32ui-p-xori.mem",195,result);

if(result != 0) errorcount = errorcount + 1;

// =====================
// == 36 - ISA test - XOR  =
// =====================
$write("XOR    : ");
run_test_program(36,"./memfiles/rv32ui-p-xor.mem",386,result);

if(result != 0) errorcount = errorcount + 1;

$write("\n\n Instruction Tests completed with errorcount = ",errorcount);
$write("\n\n");

$finish();


// ========================
// == 255 - DM Test: Halt during Program =
// ========================
$write("Coremark : ");
run_test_program(255,"./memfiles/Raifes_Demo.mem",4700,result);
if(result != 0) errorcount = errorcount + 1;


end
endmodule // raifes_sim_top
