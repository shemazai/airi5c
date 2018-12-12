`timescale 1ns / 1ps
`include "raifes_hasti_constants.vh"
`include "raifes_platform_constants.vh"


module raifes_asic_wrapper(
		
	input	inRESET,	input	iCLK20M,     	// 20 MHz main system clock
	input	iCLK32K768,	// 32.768 kHz wall clock
	
	// JTAG-Interface
	input iTDI,
	output oTDO,
	input iTMS,
	input iTCK,

	// Memory interfaces - Instructions

	input	iIRAM_IO0_In,
	output	oIRAM_IO0_Out,
	output	oIRAM_IO0_En,

	input	iIRAM_IO1_In,
	output	oIRAM_IO1_Out,
	output	oIRAM_IO1_En,

	input	iIRAM_IO2_In,
	output	oIRAM_IO2_Out,
	output	oIRAM_IO2_En,

	input	iIRAM_IO3_In,
	output	oIRAM_IO3_Out,
	output	oIRAM_IO3_En,

	output	oIRAM_SCK,
	output	oIRAM_nCS,
	output	oIRAM_nHSB,


	// Memory interfaces - Data

	input	iDRAM_IO0_In,
	output	oDRAM_IO0_Out,
	output	oDRAM_IO0_En,

	input	iDRAM_IO1_In,
	output	oDRAM_IO1_Out,
	output	oDRAM_IO1_En,

	input	iDRAM_IO2_In,
	output	oDRAM_IO2_Out,
	output	oDRAM_IO2_En,

	input	iDRAM_IO3_In,
	output	oDRAM_IO3_Out,
	output	oDRAM_IO3_En,

	output	oDRAM_SCK,
	output	oDRAM_nCS,
	output	oDRAM_nHSB,

	// External Interrupts

	input	[`N_EXT_INT-1:0]	iInterrupts,

	// UART

	output UART_TX,
	input UART_RX,
	// GPIO

	output	[7:0]	oGPIO_En,
	output	[7:0]	oGPIO_Out,
	input	[7:0]	iGPIO_In,
	
	// ADC

	output	oADC_Reset,
	output	oADC_Conv,
	input	iADC_Valid,
	input	[15:0]	iADC_Data,
	output	[15:0]	oADC_ConfWord

	// Trim words and chip configuration
	
	output	[31:0]	oChipConfWord

);


// Core section
// ============
//

wire	[`DMI_ADDR_WIDTH-1:0]	dmi_addr;
wire	[`DMI_WIDTH-1:0]	dmi_wdata;
wire	[`DMI_WIDTH-1:0]	dmi_rdata;
wire				dmi_en;
wire				dmi_error;
wire				dmi_wen;
wire				dmi_dm_busy;


raifes_core raifes(
	.reset(reset),
	.clk(clk),
	.ext_interrupts(iInterrupts),
						
	.imem_haddr(imem_haddr_core),
	.imem_hwrite(imem_hwrite_core),
	.imem_hsize(imem_hsize_core),
	.imem_hburst(imem_hburst_core),
	.imem_hmastlock(imem_hmastlock_core),
	.imem_hprot(imem_hprot_core),
	.imem_htrans(imem_htrans_core),
	.imem_hwdata(imem_hwdata_core),
	.imem_hrdata(imem_hrdata_core),
	.imem_hready(1'b1), // imem_hready),
	.imem_hresp(1'b0), // imem_hresp),
						 
	.dmem_haddr(dmem_haddr_core),
	.dmem_hwrite(dmem_hwrite_core),
	.dmem_hsize(dmem_hsize_core),
	.dmem_hburst(dmem_hburst_core),
	.dmem_hmastlock(dmem_hmastlock_core),
	.dmem_hprot(dmem_hprot_core),
	.dmem_htrans(dmem_htrans_core),
	.dmem_hwdata(dmem_hwdata_core),
	.dmem_hrdata(dmem_hrdata_core), // hrdata_muxed), // dmem_hrdata
	.dmem_hready(dmem_hready_core), 
	.dmem_hresp(1'b0), // dmem_hresp), TODO
			
	.dmi_addr(dmi_addr),
	.dmi_en(dmi_en),
	.dmi_error(dmi_error),
	.dmi_wen(dmi_wen),
	.dmi_wdata(dmi_wdata),
	.dmi_rdata(dmi_rdata),
	.dmi_dm_busy(dmi_dm_busy),
	.dm_state(dm_state)); 



raifes_dtm	dtm(
		.tck(iTCK),
		.tms(iTMS),
		.tdi(iTDI),
		.tdo(oTDO),		
		.dmi_addr(dmi_addr),
		.dmi_en(dmi_en),
		.dmi_error(dmi_error),
		.dmi_wen(dmi_wen),
		.dmi_wdata(dmi_wdata),
		.dmi_rdata(dmi_rdata),
		.dmi_dm_busy(dmi_dm_busy),
		.debug_state(debug_state)
		);



// Periphery section
// =================
//
// Adresses 0x80000000 - 0xFFFFFFFF go to this bus (instead of 0x00000000 - 0x7FFFFFFF, 
// which are e.g. part of the debug ROM and handlede inside the core).											 


// Multiplexer Bus
// ---------------


raifes_uart theUART(
    .reset(RESET),
    .clk(CLKout),
    .sdata(per_hwdata),
    .send_strobe(enable_LCD & per_hwrite),
    .ready(),
    .UART_TX(UART_TX)
    );
endmodule
