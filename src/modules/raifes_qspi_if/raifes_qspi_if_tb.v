`timescale 1ns / 1ps
`include "../raifes_hasti_constants.vh"
// QSPI memory interface 


module raifes_qspi_if_tb();

reg	VDD, Reset, Clk, Enable;

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

wire	DRAM_IO0, DRAM_IO1, DRAM_IO2, DRAM_IO3;
wire	DRAM_IO0_In, DRAM_IO0_Out, DRAM_IO0_En;
wire	DRAM_IO1_In, DRAM_IO1_Out, DRAM_IO1_En;
wire	DRAM_IO2_In, DRAM_IO2_Out, DRAM_IO2_En;
wire	DRAM_IO3_In, DRAM_IO3_Out, DRAM_IO3_En;
wire	DRAM_nHSB_Out;
wire	DRAM_SCK, DRAM_nCS, DRAM_nHSB;

buf (weak1, weak0) dnhsb_buf (DRAM_nHSB, 1'b1);

assign	DRAM_IO0 = DRAM_IO0_En ? DRAM_IO0_Out : 1'bz;
assign	DRAM_IO1 = DRAM_IO1_En ? DRAM_IO1_Out : 1'bz;
assign	DRAM_IO2 = DRAM_IO2_En ? DRAM_IO2_Out : 1'bz;
assign	DRAM_IO3 = DRAM_IO3_En ? DRAM_IO3_Out : 1'bz;

assign	DRAM_IO0_In = DRAM_IO0;
assign	DRAM_IO1_In = DRAM_IO1;
assign	DRAM_IO2_In = DRAM_IO2;
assign	DRAM_IO3_In = DRAM_IO3;



reg	[`HASTI_ADDR_WIDTH-1:0]	imem_haddr, dmem_haddr;
reg	imem_hwrite, dmem_hwrite;
reg	[`HASTI_SIZE_WIDTH-1:0]	imem_hsize, dmem_hsize;
reg	[`HASTI_BURST_WIDTH-1:0] imem_hburst, dmem_hburst;
reg	imem_hmastlock, dmem_hmastlock;
reg	[`HASTI_PROT_WIDTH-1:0]	imem_hprot, dmem_hprot;
reg	[`HASTI_BUS_WIDTH-1:0]	imem_hwdata, dmem_hwdata;
wire	[`HASTI_BUS_WIDTH-1:0]	imem_hrdata, dmem_hrdata;
wire	imem_hready, dmem_hready;
wire	[`HASTI_RESP_WIDTH-1:0]	imem_hresp, dmem_hresp;		
reg	[`HASTI_TRANS_WIDTH-1:0] imem_htrans, dmem_htrans;

	raifes_qspi_if DUT(
		.iReset(Reset),
		.iClk(Clk),
		.iEnable(Enable),
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

		.imem_haddr(imem_haddr),
		.imem_hwrite(imem_hwrite),
		.imem_hsize(imem_hsize),
		.imem_hburst(imem_hburst),
		.imem_hmastlock(imem_hmastlock),
		.imem_hprot(imem_hprot),
		.imem_hwdata(imem_hwdata),
		.imem_hrdata(imem_hrdata),
		.imem_hready(imem_hready),
		.imem_hresp(imem_hresp),
		.imem_htrans(imem_htrans)
);

wire	IRAM_INT;
buf (weak0, weak1) imem_int_buf (IRAM_INT, 1'b1);
buf (weak0, weak1) imem_wp_buf (IRAM_IO2, 1'b1);


`include  "config.v"
`include  "params.v"


		cy14v101xs IMEM( 
			.IO3_PIN(IRAM_IO3),
			.SCE_PIN(IRAM_nCS),
			.SO_PIN(IRAM_IO1),
			.WP_PIN(IRAM_IO2),
			.HSB_PIN(IRAM_nHSB),
			.SI_PIN(IRAM_IO0),
			.SCK_PIN(IRAM_SCK),
			.VCC(VDD));

`define CLK_PER 1000

always begin
	#(`CLK_PER/2)
	Clk = ~Clk;	
end

initial begin
		$shm_open("simout.shm");
		$shm_probe("AC");

		VDD = 1'b1; Clk = 1'b1; Reset = 1'b1; Enable = 1'b1;
		imem_haddr = 32'h0; imem_hwrite = 1'b0; imem_hsize = 2; imem_hburst = 0; imem_hmastlock = 0; imem_hprot = 0; imem_hwdata = 32'h0; imem_htrans = 2'b00; 
		#(1300 * `CLK_PER);
		$write("main testbench started");
		#(12 * `CLK_PER);
		Reset = 0;
		#(12 * `CLK_PER);
		#(100 * `CLK_PER);
		imem_haddr = 32'h00000008; imem_htrans = 2'b01;
		#(1 * `CLK_PER);
		imem_haddr = 32'h00000008; imem_htrans = 2'b00;
		#(100 * `CLK_PER);
		@(negedge Clk) imem_haddr = 32'h00000008; imem_htrans = 2'b01; imem_hwdata = 32'hcafebabe; imem_hwrite = 1'b1;
		#(1 * `CLK_PER);
		@(negedge Clk) imem_haddr = 32'h00000008; imem_htrans = 2'b00; imem_hwdata = 32'hcafebabe; imem_hwrite = 1'b0;		
		#(100 * `CLK_PER);
		imem_haddr = 32'h00000008; imem_htrans = 2'b01;
		#(1 * `CLK_PER);
		imem_haddr = 32'h00000008; imem_htrans = 2'b00;
		#(100 * `CLK_PER);
		imem_haddr = 32'h00000009; imem_htrans = 2'b01;
		#(1 * `CLK_PER);
		imem_haddr = 32'h00000009; imem_htrans = 2'b00;
		#(100 * `CLK_PER);
		imem_haddr = 32'h0000000a; imem_htrans = 2'b01;
		#(1 * `CLK_PER);
		imem_haddr = 32'h0000000a; imem_htrans = 2'b00;
		#(100 * `CLK_PER);
		imem_haddr = 32'h0000000b; imem_htrans = 2'b01;
		#(1 * `CLK_PER);
		imem_haddr = 32'h0000000b; imem_htrans = 2'b00;
		#(100 * `CLK_PER);
		$finish();
end


endmodule
