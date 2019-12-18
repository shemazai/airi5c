`timescale 1ns / 1ps
`include "raifes_hasti_constants.vh"
`include "raifes_platform_constants.vh"
`define SIMULATION
module raifes_fpga_wrapper(
		
	 // uncomment the appropriate line for your board
	 //input nRESET,			// RESET is active low on the Genesys board!	 	
	 input nRESET,		   // RESET is active high on the Arty Z7 board!

    // on-board clkgen interface
	 // !! despite the name, we currently use the 100 MHz clock source on Genesys boards !!	 
	 // on Arty Z7 boards, only the CLK200P port is used, so the ..N port is commented out.
	 
	 input clk_raw,

     
	 // JTAG interface
	 // this is the JTAG interface OF THE RISC-V SOFTCORE. It is NOT the JTAG port of 
	 // the FPGA. I couldn't find an easy solution to forward the FPGA JTAG signals to the 
	 // softcore, so we use GPIO pins for this interface. 
	 //
	 // In case of the Arty Z7 board, this is connected to pins of JA.
	 // In case of the Genesys board, this is connected to pins of JA (same, yes).

	 input TDI,			// data from jtag dongle to device
	 output TDO,	   // data from device to jtag dongle
	 input TMS,			// mode select from jtag dongle to device
	 input TCK,		   // clk from jtag dongle to device.
	 
     output [7:0] debug_out,
     
     output uart_tx,

    output reg [7:0] led,
    input [7:0] sw
    
    );
// generate active high reset 
// CPU-Reset on Nexys Video is low-active
assign RESET = ~nRESET;
//reg [7:0] uart_byte_in;
//reg uart_send_strobe;
//wire uart_ready;

//
// === Clock generation ===
//

// clock generator, used as prescaler to 
// generate a 25MHz system clock from the main clock
// Vivado Artix-7 IP-Core

  clk_wiz_0 clk_wiz0
   (
    // Clock out ports
    .clk_out1(CLKout),     // output clk_out1
    
   // Clock in ports
    .clk_in1(clk_raw));
    
    
// == Debug signals and facilities ==

// six bits are forwarded from the depths of the 
// core to signal different states...
wire [3:0] dm_state;


// System bus definition
// =====================
//
//	Der Systembus besteht im inneren des Core aus einem Instruction und einem 
// Data-Bus. Intern verzweigen diese bereits je nach Adresse auf Register im 
// Debug-Modul oder aber auf das integrierte Block-RAM. 
// Für die Peripheriegeräte wird der Daten-Bus nach außen geführt. Abhängig von 
// der Adresse wird ein Peripherie-Enable-Signal (per_en) gesetzt. Die Dekodierung 
// der Adresse innerhalb des Peripheriebereichs erfolgt dann hier, sodass stets nur 
// ein Peripherie-Modul den Bus nutzt.
//
// Der Bus ist kompatibel zu AHB-Lite, sollte daher auch mit IP von ARM & Co. 
// verwendet werden können, die Signale sind entsprechend benannt.

wire										per_en;			// Peripherie Enable
wire	[`HASTI_ADDR_WIDTH-1:0]		          per_haddr;		// Adresse (*gesamte* 32-Bit Adresse, ggf. nur wenige Bits relevant)
wire										per_hwrite;		// Write (von Core in Gerät) Enable
wire	[`HASTI_SIZE_WIDTH-1:0]		per_hsize;		// Breite der Transaktion (es sind auch Byte- oder Halfword-Zugriffe möglich)
wire	[`HASTI_BURST_WIDTH-1:0]	per_hburst;		// Burst-Modi, siehe AHB-Lite. Ggf. nicht implementiert! TODO
wire										per_hmastlock; // TODO
wire	[`HASTI_TRANS_WIDTH-1:0]	per_htrans;		// TODO
wire	[`HASTI_BUS_WIDTH-1:0]		per_hwdata;		// Daten Core->Peripherie
wire	[`HASTI_BUS_WIDTH-1:0]		per_hrdata;		// Daten Peripherie->Core
wire										per_hready;		// Ready, bzw. ~busy. Wenn dieses Bit LOW ist, wartet der Core...
wire	[`HASTI_RESP_WIDTH-1:0]		per_hresp;		// Error reporting. TOD=

assign per_hresp = 1'b0;
assign per_hready = 1'b1;

wire CLK;

`ifdef SIMULATION
    assign CLK = clk_raw;
`endif
`ifndef SIMULATION
    assign CLK = CLKout;
`endif


// Core section
// ============
//


// this is the RISC-V core including the BlockRAM for instructions and data.
// TODO: parameters for various options like RAM size, hardware multiplier etc..
raifes_top thecore (
		// System-Reset und Clock
		.reset(RESET),
		.clk(CLK), 

		// JTAG-Interface
		.tck(TCK), 		// TCK, synchronized to system CLK
		.tms(TMS), 
		.tdi(TDI), 
		.tdo(TDO), 

		// Ein paar Debug-Leitungen, um Signale aus 
		// dem Core auf LEDs legen zu können.. Debug only.
		//.dm_state(dm_state),
		.dm_state(dm_state),
		.debug_out(debug_out),

		// Peripherie-Bus
		// Hier können Dinge wie GPIOs, Timer, PICs und so angeschlossen werden.		
		.per_en(per_en),
		.per_haddr(per_haddr),
		.per_hwrite(per_hwrite),
		.per_hsize(per_hsize),
		.per_hburst(per_hburst),
		.per_hmastlock(per_hmastlock),
		.per_htrans(per_htrans),
		.per_hwdata(per_hwdata),
		.per_hrdata(per_hrdata),
		.per_hready(per_hready),
		.per_hresp(per_hresp)
	//	.int0(int0),
	//	.int1(1'b0)	
);



//// Periphery section
//// =================
////
//// Adresses 0x80000000 - 0xFFFFFFFF go to this bus and are decoded in each Periphery-component on it's own (instead of 0x00000000 - 0x7FFFFFFF, 
//// which are e.g. part of the debug ROM and handlede inside the core).											 
	


//crypto_module theCryptoModule(
//        .clk(CLKout),
//		.per_en(per_en),
//		.per_haddr(per_haddr),
//		.per_hwrite(per_hwrite),
//		.per_hsize(per_hsize),
//		.per_hburst(per_hburst),
//		.per_hmastlock(per_hmastlock),
//		.per_htrans(per_htrans),
//		.per_hwdata(per_hwdata),
//		.per_hrdata(per_hrdata)   
//);

UART_module theUARTModule(
        .clk(CLKout),
		.per_en(per_en),
		.per_haddr(per_haddr),
		.per_hwrite(per_hwrite),
		.per_hsize(per_hsize),
		.per_hburst(per_hburst),
		.per_hmastlock(per_hmastlock),
		.per_htrans(per_htrans),
		.per_hwdata(per_hwdata),
		.per_hrdata(per_hrdata),
		.uart_tx(uart_tx)   
);





endmodule
