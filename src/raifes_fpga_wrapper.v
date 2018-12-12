`timescale 1ns / 1ps
`include "raifes_hasti_constants.vh"
`include "raifes_platform_constants.vh"


module raifes_fpga_wrapper(
		
	 // uncomment the appropriate line for your board
	 //input nRESET,			// RESET is active low on the Genesys board!	 	
	 input RESET,		   // RESET is active high on the Arty Z7 board!

    // on-board clkgen interface
	 // !! despite the name, we currently use the 100 MHz clock source on Genesys boards !!	 
	 // on Arty Z7 boards, only the CLK200P port is used, so the ..N port is commented out.
	 
	 input CLK200P,
    // input CLK200N,
     
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

	 // LCD display control lines
	 // see the datasheet of the LCD controller.	
	 
	 // on the Z7 board, there is no LCD display.
	 //output	LCD_RS,	// Read/Write Strobe
	 //output	LCD_RW,	// Read/~Write
	 //output	LCD_E,	// Enable
	 //inout	[7:0] LCD_DB	// 8 Bit Data.
	 
	 output UART_TX,

	 // LEDs used for hardware debugging
	 // we forward some signals from the depths of the 
	 // softcore to LEDs for debugging purposes sometimes.

	 output	debug_led1,
	 output	debug_led2,
	 output	debug_led3,
	 output	debug_led4,
	 output	debug_led5,
	 output	debug_led6,
	 output	debug_led7,
	 output	debug_led8

    );

//	Main clock buffer for differential input clock

// On the Genesys board a differential clock source is provided, which requires this 
// differential clock buffer
// IBUFGDS theclockbuffer (.O(CLK), .I(CLK200P), .IB(CLK200N));

// On the Arty Z7 board, a single ended clock source (50MHz) is provided, which 
// requires this single ended clock buffer

IBUFG theclockbuffer (.O(CLK), .I(CLK200P));	// again: CLK200P actually is a 50MHz single ended clock input on the Z7.

// generate active high reset

// On the Genesys board, the Reset button is low active, so we have to invert the signal
//wire RESET; assign RESET = ~nRESET;

// On the Z7 board, the signal is already high active.


//
// === Clock generation ===
//

// On the Genesys board, we need to derive a lower speed clock from the 
// 200MHz/100MHz clock sources on the board. We do this with a "digital clock management" 
// module provided in the Virtex FPGAs, which are essentially PLLs/DLLs with programmable 
// dividers. 
// For the Z7 board, skip this section.

// clock generator, used as prescaler to 
// generate a 25MHz system clock from the main clock
DCM dcm_adv_clk_main (

// OUTPUTs
    .CLKDV        (dcm_clk),
    .CLKFX        (),
    .CLKFX180     (),
    .CLK0         (CLK0_BUF),
    .CLK2X        (),
    .CLK2X180     (),
    .CLK90        (),
    .CLK180       (),
    .CLK270       (),
    .LOCKED       (dcm_locked),
    .PSDONE       (),
    .STATUS       (),

// INPUTs
    .CLKFB        (CLKFB_IN),
    .CLKIN        (CLK),
    .PSEN         (1'b0),
    .PSINCDEC     (1'b0),
    .DSSEN        (1'b0),
    .PSCLK        (1'b0),
    .RST          (RESET)
);

BUFG CLK0_BUFG_INST (
    .I(CLK0_BUF),
    .O(CLKFB_IN)
);

defparam dcm_adv_clk_main.CLK_FEEDBACK          = "1X";
defparam dcm_adv_clk_main.CLKDV_DIVIDE          = 16.0;
defparam dcm_adv_clk_main.CLKFX_DIVIDE          = 1;
defparam dcm_adv_clk_main.CLKFX_MULTIPLY        = 4;
defparam dcm_adv_clk_main.CLKIN_DIVIDE_BY_2     = "TRUE";
defparam dcm_adv_clk_main.CLKIN_PERIOD          = 10.000;
defparam dcm_adv_clk_main.CLKOUT_PHASE_SHIFT    = "NONE";
defparam dcm_adv_clk_main.DESKEW_ADJUST         = "SYSTEM_SYNCHRONOUS";
defparam dcm_adv_clk_main.DFS_FREQUENCY_MODE    = "HIGH";
defparam dcm_adv_clk_main.DLL_FREQUENCY_MODE    = "HIGH";
defparam dcm_adv_clk_main.DUTY_CYCLE_CORRECTION = "TRUE";
defparam dcm_adv_clk_main.FACTORY_JF            = 16'h8080;
defparam dcm_adv_clk_main.PHASE_SHIFT           = 0;
defparam dcm_adv_clk_main.STARTUP_WAIT          = "FALSE";



// start of clock tree for the design

// On Genesys boards, this is connected to the output of the DCM.
BUFG  buf_sys_clock  (.O(CLKout), .I(dcm_clk));

// On Z7 boards, we just connect the design to the main clock buffer.


// == Debug signals and facilities ==

// six bits are forwarded from the depths of the 
// core to signal different states...
wire [3:0] dm_state;

// a low-frequency toggle signal is derived 
// from the system clock an connected to an 
// LED.

reg [31:0] blinker;
always @(posedge CLKout or posedge RESET) begin
	if(RESET) begin
		blinker <= 32'h0;
	end else begin
		blinker <= blinker + 32'h1;
	end
end

// debug LEDs

assign debug_led1 = dm_state[0]; // postexecreq
assign debug_led2 = dm_state[1]; // check_pb0 
assign debug_led3 = dm_state[2]; // check_pb1
assign debug_led4 = dm_state[3]; // halted
assign debug_led5 = 1'b0;
assign debug_led6 = 1'b0;
assign debug_led7 = blinker[21];
assign debug_led8 = RESET;

// sample the TCK signal with the system clock 
// to synchronize clock domains.
// requires TCK << System clock, which is usually 
// the case.

reg	TCK_r;
always @(posedge CLKout) begin
	if(RESET) begin
		TCK_r <= 1'b0;
	end else begin
		TCK_r <= TCK;
	end
end


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
wire	[`HASTI_ADDR_WIDTH-1:0]		per_haddr;		// Adresse (*gesamte* 32-Bit Adresse, ggf. nur wenige Bits relevant)
wire										per_hwrite;		// Write (von Core in Gerät) Enable
wire	[`HASTI_SIZE_WIDTH-1:0]		per_hsize;		// Breite der Transaktion (es sind auch Byte- oder Halfword-Zugriffe möglich)
wire	[`HASTI_BURST_WIDTH-1:0]	per_hburst;		// Burst-Modi, siehe AHB-Lite. Ggf. nicht implementiert! TODO
wire										per_hmastlock; // TODO
wire	[`HASTI_TRANS_WIDTH-1:0]	per_htrans;		// TODO
wire	[`HASTI_BUS_WIDTH-1:0]		per_hwdata;		// Daten Core->Peripherie
reg	[`HASTI_BUS_WIDTH-1:0]		per_hrdata;		// Daten Peripherie->Core
reg										per_hready;		// Ready, bzw. ~busy. Wenn dieses Bit LOW ist, wartet der Core...
reg	[`HASTI_RESP_WIDTH-1:0]		per_hresp;		// Error reporting. TODO
	

// Core section
// ============
//


reg	[3:0]	reset_delay;
wire	reset_delayed; assign reset_delayed = (reset_delay == 4'hF) ? 1'b0 : 1'b1;
always @(posedge CLKout or posedge RESET) begin
	if(RESET) begin
		reset_delay <= 4'h0;
	end else begin 
		if(~(reset_delay == 4'hF)) reset_delay <= reset_delay + 4'h1;
	end
end

// this is the RISC-V core including the BlockRAM for instructions and data.
// TODO: parameters for various options like RAM size, hardware multiplier etc..
raifes_top thecore (
		// System-Reset und Clock
		.reset(reset_delayed),
		.clk(CLKout), 

		// JTAG-Interface
		.tck(TCK_r), 		// TCK, synchronized to system CLK
		.tms(TMS), 
		.tdi(TDI), 
		.tdo(TDO), 

		// Ein paar Debug-Leitungen, um Signale aus 
		// dem Core auf LEDs legen zu können.. Debug only.
		//.dm_state(dm_state),
		.dm_state(dm_state),

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
);


// Periphery section
// =================
//
// Adresses 0x80000000 - 0xFFFFFFFF go to this bus (instead of 0x00000000 - 0x7FFFFFFF, 
// which are e.g. part of the debug ROM and handlede inside the core).											 


// Multiplexer Bus
// ---------------
//
// we use multiplexers to connect the different peripherals to 
// the system bus when they are active. 
// Each periphery device has a set of hrdata, hready and hresp lines
// which are then forwarded to the bus if the addresses match.
// Each periphery device has an individual enable controled by 
// the address decoder (which might only do partial address decoding, 
// to allow a full range of addresses for each device)

// on Z7 there is no LCD, we still do the decoding for consistency of the 
// system bus. Should be removed by optimization.

reg enable_LCD;	
wire	[`HASTI_BUS_WIDTH-1:0]	hrdata_LCD;	
wire									hready_LCD;
wire	[`HASTI_RESP_WIDTH-1:0]	hresp_LCD;

always @(*) begin
	enable_LCD = 1'b0;
	case(per_haddr)
		`PER_ADDR_LCD	:	begin
									per_hrdata = hrdata_LCD;									
									per_hready = hready_LCD;
									per_hresp = hresp_LCD;
									enable_LCD = per_en;
								end
		default : per_hrdata = `HASTI_BUS_WIDTH'hdeadbeef;
	endcase
end

// Periphery instances 
// -------------------

// 
//	LCD controller
//
// The LCD "controller" is just a register with its bits 
// connected to the RS,RW,E and DB<7:0> lines of the on-board
// LCD-controller chip. So this can serve as a template for 
// peiphery devices...

// on Z7 board there is no LCD display.
/*LCD	theLCD (		
   .reset(RESET),
	.clk(CLKout),
	
	// connections to the system bus
	.per_en(enable_LCD),
	.per_haddr(per_haddr),
	.per_hwrite(per_hwrite),
	.per_hsize(per_hsize),
	.per_hburst(per_hburst),
	.per_hmastlock(per_hmastlock),
	.per_htrans(per_htrans),
	.per_hwdata(per_hwdata),
	.per_hrdata(hrdata_LCD),
	.per_hready(hready_LCD),
	.per_hresp(hresp_LCD),
	
	// connections to FPGA pins
	.LCD_RS(LCD_RS),
	.LCD_RW(LCD_RW),
	.LCD_E(LCD_E),
	.LCD_DB(LCD_DB)
);*/

raifes_uart theUART(
    .reset(RESET),
    .clk(CLKout),
    .sdata(per_hwdata),
    .send_strobe(enable_LCD & per_hwrite),
    .ready(),
    .UART_TX(UART_TX)
    );
endmodule
