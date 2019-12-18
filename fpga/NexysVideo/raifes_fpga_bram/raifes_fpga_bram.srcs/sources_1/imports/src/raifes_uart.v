`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:16:15 07/10/2018 
// Design Name: 
// Module Name:    raifes_uart 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//8DataBit and 2 StopBits worked for me (strangely the Terminal tool recognizes 2 stop bits, instead of 1)
//////////////////////////////////////////////////////////////////////////////////
module raifes_uart(
    input reset,
    input clk,
    input [7:0] sdata,
    input send_strobe,
    output ready,
    output UART_TX
    );

`define	CNT_MAX	16'h0A2B		// = hex(round(50MHz / 9600 Hz)-1)
								//0xA2B is for 25MHz and 9600Baud

reg	[15:0]	bitTimer;													// keep track of bit time
wire	bitDone;	assign bitDone = (bitTimer == 0) ? 1'b1 : 1'b0;	// signal bit time reached
`define	BIT_INDEX_MAX	10   //14.8. ToBo Bit_INDEX_MAX increased for sending one more bit 
reg	[3:0]		bitIndex;	 // added one more bit to Index register
reg				txBit;
reg	[10:0]		txData;

`define	STATE_READY	2'b00
`define	STATE_LOAD	2'b01
`define	STATE_SEND	2'b10
`define	STATE_ERROR	2'b11

reg	[1:0]	state;
reg	[1:0] next_state;


// state changes
always @(posedge clk) begin
	if(reset) begin
		state <= `STATE_READY;
	end else begin
		state <= next_state;	
	end
end

always @(*) begin
	next_state = `STATE_ERROR;
	case(state) 
		`STATE_READY	: 	next_state = send_strobe ? `STATE_LOAD : `STATE_READY;
		`STATE_LOAD		: 	next_state = `STATE_SEND;
		`STATE_SEND		:	next_state = bitDone ? ((bitIndex == `BIT_INDEX_MAX) ? `STATE_READY : `STATE_LOAD) : `STATE_SEND;
		`STATE_ERROR	:	next_state = `STATE_READY;
		
	endcase
end

// bit timing
always @(posedge clk) begin
	if(state == `STATE_READY) begin
		bitTimer <= `CNT_MAX;
	end else begin
		if(bitDone) begin
			bitTimer <= `CNT_MAX;
		end else begin 
			bitTimer <= bitTimer - 1;
		end		
	end
end

// bit sequencing
always @(posedge clk) begin
	if(state == `STATE_READY) begin
		bitIndex <= 0;
	end else begin
		if(state == `STATE_LOAD) bitIndex <= bitIndex + 1;
	end
end

// data latch 
always @(posedge clk) begin
	if(send_strobe) txData <= {1'b1,sdata,2'b0};
end

// txbit
always @(posedge clk) begin
	if(state == `STATE_READY) begin
		txBit <= 1'b1;
	end else begin
		txBit <= txData[bitIndex];
	end
end

assign UART_TX = txBit;
assign ready = (state == `STATE_READY) ? 1'b1 : 1'b0;

endmodule
