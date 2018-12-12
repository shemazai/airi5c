`timescale 1ns / 1ps
`include "raifes_hasti_constants.vh"
`include "raifes_platform_constants.vh"


// QSPI memory interface 


module raifes_qspi_if(
		
	input	iReset,	input	iClk,     	
	input	iEnable,

	// Memory interfaces - Instructions

	input	iIRAM_IO0_In,
	output	reg	oIRAM_IO0_Out,
	output	reg	oIRAM_IO0_En,

	input	iIRAM_IO1_In,
	output	reg	oIRAM_IO1_Out,
	output	reg	oIRAM_IO1_En,

	input	iIRAM_IO2_In,
	output	reg	oIRAM_IO2_Out,
	output	reg	oIRAM_IO2_En,

	input	iIRAM_IO3_In,
	output	reg	oIRAM_IO3_Out,
	output	reg	oIRAM_IO3_En,

	output	reg	oIRAM_SCK,
	output	reg	oIRAM_nCS,
	output	reg	oIRAM_nHSB,


	// Memory interfaces - Data

	input	iDRAM_IO0_In,
	output	reg	oDRAM_IO0_Out,
	output	reg	oDRAM_IO0_En,

	input	iDRAM_IO1_In,
	output	reg	oDRAM_IO1_Out,
	output	reg	oDRAM_IO1_En,

	input	iDRAM_IO2_In,
	output	reg	oDRAM_IO2_Out,
	output	reg	oDRAM_IO2_En,

	input	iDRAM_IO3_In,
	output	reg	oDRAM_IO3_Out,
	output	reg	oDRAM_IO3_En,

	output	reg	oDRAM_SCK,
	output	reg	oDRAM_nCS,
	output	reg	oDRAM_nHSB,

        input	[`HASTI_ADDR_WIDTH-1:0]  imem_haddr,
        input				imem_hwrite,			// unused, as imem is read-only (typically)
        input	[`HASTI_SIZE_WIDTH-1:0]  imem_hsize,
	input	[`HASTI_BURST_WIDTH-1:0] imem_hburst,
        input 			   	imem_hmastlock,
        input	[`HASTI_PROT_WIDTH-1:0]  imem_hprot,
        input	[`HASTI_TRANS_WIDTH-1:0] imem_htrans,
        input	[`HASTI_BUS_WIDTH-1:0]   imem_hwdata,			// unused, as imem is read-only (typically)
        output	reg	[`HASTI_BUS_WIDTH-1:0]    imem_hrdata,
        output 	reg			   	imem_hready,
        output	reg	[`HASTI_RESP_WIDTH-1:0]   imem_hresp,

        input	[`HASTI_ADDR_WIDTH-1:0]  dmem_haddr,
        input 			   	dmem_hwrite,
        input	[`HASTI_SIZE_WIDTH-1:0]  dmem_hsize,
        input	[`HASTI_BURST_WIDTH-1:0] dmem_hburst,
        input 			   	dmem_hmastlock,
        input	[`HASTI_PROT_WIDTH-1:0]  dmem_hprot,
        input	[`HASTI_TRANS_WIDTH-1:0] dmem_htrans,
        input	[`HASTI_BUS_WIDTH-1:0]   dmem_hwdata,
        output	reg	[`HASTI_BUS_WIDTH-1:0]    dmem_hrdata,
        output 	reg			  	dmem_hready,
        output reg	[`HASTI_RESP_WIDTH-1:0]   dmem_hresp
);

// IRAM section

reg	[3:0]	state_im, next_state_im;

always @(posedge iClk) begin
	if(iReset) begin
		state_im <= `QSPI_IDLE;
	end else begin
		state_im <= next_state_im;
	end
end

reg	[`HASTI_ADDR_WIDTH-1:0]	imem_haddr_r;
always @(posedge iClk) begin
	if(iReset) begin
		imem_haddr_r <= `HASTI_ADDR_WIDTH'h0;
	end else begin
		if(state == `QSPI_IDLE)	imem_haddr_r <= imem_haddr;
	end
end

wire	imem_addr_changed; assign imem_addr_changed = |(imem_haddr ^ imem_haddr_r);


reg	[4:0]	cyclecnt_im;
reg	[31:0]	shiftreg_im;
reg	[23:0]	addr_im;

always @(posedge iClk) begin
	if(iReset) begin
		shiftreg_im <= 32'h03000000;	// read from addr 0x00
		cyclecnt_im <= 5'h0;
	end else begin
		if(state_im == `QSPI_START) begin 
			shiftreg_im <= {`8h03,addr_im};	
			cyclecnt_im <= 31;
		end else if(state_im == `QSPI_CLOCK) begin
			shiftreg_im <= {shiftreg_im[30:0],iIRAM_IO0_In};		// TODO!
			if(cyclecnt_im >= 0) cyclecnt_im <= cyclecnt_im - 1;
		end
	end
end

always @(*) begin 
	next_state_im = `QSPI_IDLE;
	oIRAM_IO0_Out = 1'b0;
	oIRAM_IO0_En = 1'b0;
	oIRAM_IO1_Out = 1'b0;
	oIRAM_IO1_En = 1'b0;
	oIRAM_IO2_Out = 1'b0;
	oIRAM_IO2_En = 1'b0;
	oIRAM_IO3_Out = 1'b0;
	oIRAM_IO3_En = 1'b0;
	oIRAM_SCK = 1'b0;
	oIRAM_nCS = 1'b1;
	oIRAM_nHSB = 1'b1;

	imem_hready = 1'b0;
	imem_hresp = `HASTI_RESP_WIDTH'h0;

	case (state) 
		`QSPI_IDLE 	:	begin 
						next_state_im = imem_addr_changed ? `QSPI_START : `QSPI_IDLE;
						imem_hready = 1'b1;
					end
		`QSPI_START	:	begin
						next_state_im = `QSPI_CLOCK;
						oIRAM_nCS = 1'b0;
					end
		`QSPI_CLOCK	:	begin	
						next_state_im = `QSPI_SHIFT;
						oIRAM_nCS = 1'b0;
					end
		`QSPI_SHIFT	:	begin
						next_state_im = (cyclecnt_im == 0) ? `QSPI_END : `QSPI_CLOCK;
						oIRAM_nCS = 1'b0;
					end
		`QSPI_END	:	begin
						next_state_im = `QSPI_IDLE;					
					end
	endcase

end

endmodule
