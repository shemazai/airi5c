// 
//	raifes_dtm - raifes Debug Transport Module (JTAG)
//
//	this module holds a JTAG TAP and the registers and logic to interface 
//	to the Debug Module Interface (DMI) bus.

`include "raifes_dmi_constants.vh"

// standard TAP states
`define TEST_LOGIC_RESET 4'b0000
`define RUN_TEST_IDLE 4'b0001
`define SELECT_DR_SCAN 4'b0010
`define SELECT_IR_SCAN 4'b0011
`define CAPTURE_DR 4'b0100
`define CAPTURE_IR 4'b0101
`define SHIFT_DR 4'b0110
`define SHIFT_IR 4'b0111
`define EXIT1_DR 4'b1000
`define EXIT1_IR 4'b1001
`define PAUSE_DR 4'b1010
`define PAUSE_IR 4'b1011
`define EXIT2_DR 4'b1100
`define EXIT2_IR 4'b1101
`define UPDATE_DR 4'b1110
`define UPDATE_IR	4'b1111

`define DR_LEN	32
`define IR_LEN	5

// Addresses of DR registers
`define IR_ADDR_BYPASS0		`IR_LEN'h0
`define IR_ADDR_IDCODE		`IR_LEN'h1
`define IR_ADDR_DTM			`IR_LEN'h10
`define IR_ADDR_DMI			`IR_LEN'h11
`define IR_ADDR_RES12		`IR_LEN'h12
`define IR_ADDR_RES13		`IR_LEN'h13
`define IR_ADDR_RES14		`IR_LEN'h14
`define IR_ADDR_RES15		`IR_LEN'h15
`define IR_ADDR_RES16		`IR_LEN'h16
`define IR_ADDR_RES17		`IR_LEN'h17
`define IR_ADDR_BYPASS1f	`IR_LEN'h1f

// chip specific
`define IR_ADDR_ADCCTRL		`IR_LEN'h18
`define IR_ADDR_ADCDATA		`IR_LEN'h19
`define IR_ADDR_PUFCTRL		`IR_LEN'h1a
`define IR_ADDR_SCAN		`IR_LEN'h1b

`define ADCCTRL_INITVALUE	16'hdead
`define PUFCTRL_INITVALUE	32'hdeadbeef


module raifes_dtm(			
			input					tck,				
			input					tms,
			input					tdi,
			output				tdo,

			output	reg	[`DMI_ADDR_WIDTH-1:0]	dmi_addr,
			output	reg	[`DMI_WIDTH-1:0]	dmi_wdata,
			input		[`DMI_WIDTH-1:0]	dmi_rdata,
			output	reg				dmi_en,
			output	reg				dmi_wen,
			input					dmi_error,
			input					dmi_dm_busy,

			output	reg	[15:0]			adc_ctrl,
			input		[15:0]			adc_data,
			output	reg	[31:0]			puf_ctrl,

			output	[3:0]		debug_state

);

reg	[3:0]	state;
reg	[3:0]	next_state;

reg	[`IR_LEN-1:0]	IR;
reg	[`IR_LEN-1:0]	IR_shift;
reg	[`DR_LEN-1:0]	IDCODE;
reg	[`DR_LEN-1:0]	DTM;
reg	[40:0]		DMI;		// 7 bit DMI address + 33:0 as stated by spec 0.13
reg	[15:0]	ADCCTRL;
reg	[15:0]	ADCDATA;
reg	[31:0]	PUFCTRL;

always @(state, tms) begin
	next_state = `TEST_LOGIC_RESET;
	case(state)
		`TEST_LOGIC_RESET	:	begin next_state = (tms == 1'b1) ? `TEST_LOGIC_RESET : `RUN_TEST_IDLE; end
		`RUN_TEST_IDLE		:	begin next_state = (tms == 1'b1) ? `SELECT_DR_SCAN : `RUN_TEST_IDLE; end
		`SELECT_DR_SCAN	:	begin next_state = (tms == 1'b1) ? `SELECT_IR_SCAN : `CAPTURE_DR; end
		`SELECT_IR_SCAN	:	begin next_state = (tms == 1'b1) ? `TEST_LOGIC_RESET : `CAPTURE_IR; end
		`CAPTURE_DR		:	begin next_state = (tms == 1'b1) ? `EXIT1_DR : `SHIFT_DR; end
		`CAPTURE_IR		:	begin next_state = (tms == 1'b1) ? `EXIT1_IR : `SHIFT_IR; end
		`SHIFT_DR		:	begin next_state = (tms == 1'b1) ? `EXIT1_DR : `SHIFT_DR; end
		`SHIFT_IR		:	begin next_state = (tms == 1'b1) ? `EXIT1_IR : `SHIFT_IR; end
		`EXIT1_DR		:	begin next_state = (tms == 1'b1) ? `UPDATE_DR : `PAUSE_DR; end
		`EXIT1_IR		:	begin next_state = (tms == 1'b1) ? `UPDATE_IR : `PAUSE_IR; end
		`PAUSE_DR		:	begin next_state = (tms == 1'b1) ? `EXIT2_DR : `PAUSE_DR; end
		`PAUSE_IR		:	begin next_state = (tms == 1'b1) ? `EXIT2_IR : `PAUSE_IR; end
		`EXIT2_DR		:	begin next_state = (tms == 1'b1) ? `UPDATE_DR : `SHIFT_DR; end
		`EXIT2_IR		:	begin next_state = (tms == 1'b1) ? `UPDATE_IR : `SHIFT_IR; end
		`UPDATE_DR		:	begin next_state = (tms == 1'b1) ? `SELECT_DR_SCAN : `RUN_TEST_IDLE; end
		`UPDATE_IR		:	begin next_state = (tms == 1'b1) ? `SELECT_DR_SCAN : `RUN_TEST_IDLE; end
	endcase
end

// TAP state transitions
always @(posedge tck) begin
	state <= next_state;
end

// DMI interface register
always @(negedge tck) begin
	if((state == `UPDATE_DR) && (IR == `IR_ADDR_DMI)) begin
		dmi_addr <= DMI[40:34];			// addr is in upper part of DMI
		dmi_wdata <= DMI[33:2];			// data is in middle part of DMI
		dmi_en <= |DMI[1:0];
		dmi_wen <= DMI[1];
	end 
	else begin
		dmi_addr <= dmi_addr;			
		dmi_wdata <= dmi_wdata;			
		dmi_en <= 1'b0;//dmi_en;
		dmi_wen <= 1'b0;//dmi_wen;
	end
end

// -- Chip specific --

// ADC Ctrl Register
always @(negedge tck) begin
	if((state == `UPDATE_DR) && (IR == `IR_ADDR_ADCCTRL)) begin
		adc_ctrl <= ADCCTRL;
	end 
end

// PUF Ctrl Register
always @(negedge tck) begin
	if((state == `UPDATE_DR) && (IR == `IR_ADDR_PUFCTRL)) begin
		puf_ctrl <= PUFCTRL;
	end 
end



// IR shift register
always @(posedge tck) begin
	if (state == `CAPTURE_IR) begin	
		IR_shift <= `IR_ADDR_IDCODE;	
	end else if (state == `SHIFT_IR) begin 
		IR_shift <= {tdi,IR_shift[`IR_LEN-1:1]};
	end
end

// IR hold latch
always @(negedge tck) begin
	if (state == `TEST_LOGIC_RESET) begin
		IR <= `IR_ADDR_IDCODE;	
	end else if (state == `UPDATE_IR) begin
		IR <= IR_shift;
	end 
end

// IDCODE
always @(posedge tck) begin
	if (state == `SHIFT_DR) begin
		IDCODE[`DR_LEN-1:0] <= (IR == `IR_ADDR_IDCODE) ? {tdi,IDCODE[`DR_LEN-1:1]} : IDCODE;			
	end else if (state == `CAPTURE_DR) begin
		IDCODE <= (IR == `IR_ADDR_IDCODE) ? `DR_LEN'b00010000000000000001000000000001 : IDCODE;
	end
end

// DTM
always @(posedge tck) begin
	if (state == `SHIFT_DR) begin
		DTM <= (IR == `IR_ADDR_DTM) ? {tdi,DTM[`DR_LEN-1:1]} : DTM;					
	end else if (state == `CAPTURE_DR) begin
		DTM <= (IR == `IR_ADDR_DTM) ? {17'h0,3'h2,1'b0,1'b0,6'h7,4'h1} : DTM;
	end
end

// DMI
always @(posedge tck) begin
	if (state == `SHIFT_DR) begin
		DMI <= (IR == `IR_ADDR_DMI) ? {tdi,DMI[40:1]} : DMI;
	end else if (state == `CAPTURE_DR) begin
		DMI <= (IR == `IR_ADDR_DMI) ? {dmi_addr,dmi_rdata,dmi_error,dmi_error} : DMI;						
	end
end

// -- Chip specific -- 

// ADC control register
always @(posedge tck) begin
	if (state == `SHIFT_DR) begin
		ADCCTRL <= (IR == `IR_ADDR_ADCCTRL) ? {tdi,ADCCTRL[15:1]} : ADCCTRL;
	end else if (state == `CAPTURE_DR) begin
		ADCCTRL <= (IR == `IR_ADDR_ADCCTRL) ? `ADCCTRL_INITVALUE : ADCCTRL;						
	end
end

// ADC data (=result) register
always @(posedge tck) begin
	if (state == `SHIFT_DR) begin
		ADCDATA <= (IR == `IR_ADDR_ADCDATA) ? {tdi,ADCDATA[15:1]} : ADCDATA;
	end else if (state == `CAPTURE_DR) begin
		ADCDATA <= (IR == `IR_ADDR_ADCDATA) ? adc_data : ADCDATA;						
	end
end

// PUF control register
always @(posedge tck) begin
	if (state == `SHIFT_DR) begin
		PUFCTRL <= (IR == `IR_ADDR_PUFCTRL) ? {tdi,PUFCTRL[31:1]} : PUFCTRL;
	end else if (state == `CAPTURE_DR) begin
		PUFCTRL <= (IR == `IR_ADDR_PUFCTRL) ? `PUFCTRL_INITVALUE : PUFCTRL;						
	end
end



// TDO output mux
reg	tdo_from_register;

always @* begin
	tdo_from_register = tdi;
	case(IR)
		`IR_ADDR_IDCODE	:	tdo_from_register = IDCODE[0];
		`IR_ADDR_DTM		:	tdo_from_register = DTM[0];
		`IR_ADDR_DMI		:	tdo_from_register = DMI[0];
		`IR_ADDR_ADCCTRL	:	tdo_from_register = ADCCTRL[0];
		`IR_ADDR_PUFCTRL	:	tdo_from_register = PUFCTRL[0];
		`IR_ADDR_ADCDATA	:	tdo_from_register = ADCDATA[0];
	endcase
end

reg tdo_r;
wire tdo_wire;
assign tdo_wire = (state == `SHIFT_IR) ? IR_shift[0] : tdo_from_register;
assign tdo = tdo_r;

assign debug_state = state;

//always @(negedge tck) begin
always @(negedge tck) begin
		tdo_r <= tdo_wire;	
end

endmodule
