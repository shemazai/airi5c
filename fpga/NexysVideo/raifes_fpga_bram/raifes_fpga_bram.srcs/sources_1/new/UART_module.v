`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2019 10:30:58
// Design Name: 
// Module Name: UART_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`include "raifes_platform_constants.vh"
`include "raifes_hasti_constants.vh"

module UART_module(
input                               clk,
input								per_en,		// Peripherie Enable
input	[`HASTI_ADDR_WIDTH-1:0]		per_haddr,		// Adresse (*gesamte* 32-Bit Adresse, ggf. nur wenige Bits relevant)
input								per_hwrite,		// Write (von Core in Gerät) Enable
input	[`HASTI_SIZE_WIDTH-1:0]		per_hsize,		// Breite der Transaktion (es sind auch Byte- oder Halfword-Zugriffe möglich)
input	[`HASTI_BURST_WIDTH-1:0]	per_hburst,		// Burst-Modi, siehe AHB-Lite. Ggf. nicht implementiert! TODO
input								per_hmastlock, // TODO
input	[`HASTI_TRANS_WIDTH-1:0]	per_htrans,		// TODO
input	[`HASTI_BUS_WIDTH-1:0]		per_hwdata,		// Daten Core->Peripherie
output reg	[`HASTI_BUS_WIDTH-1:0]	per_hrdata,		// Daten Peripherie->Core
output                              uart_tx
//output 							per_hready,		// Ready, bzw. ~busy. Wenn dieses Bit LOW ist, wartet der Core...
//output 	[`HASTI_RESP_WIDTH-1:0]	per_hresp		// Error reporting. TODO    
    );
   
    
    
reg [9:0] UART_reg; // Bits:(10=uart_ready,not in the UART_reg) 9=uart_reset, 8=send_strobe, 7-0=data_byte
wire [7:0] uart_byte_in;
wire uart_send_strobe,uart_ready,uart_reset;
assign uart_send_strobe = UART_reg[8];
assign uart_reset = UART_reg[9];
assign uart_byte_in = UART_reg[7:0];


always @(posedge clk)
begin
    case(per_haddr)
    `UART_reg: begin
                    if(per_hwrite) UART_reg <= per_hwdata[9:0];
                    else   per_hrdata <= {21'h0,uart_ready,UART_reg}; 
                end
    
    default: begin per_hrdata <= 32'hZ; end
    endcase
end





raifes_uart theUART(
    .reset(uart_reset),
    .clk(clk),
    .sdata(uart_byte_in),
    .send_strobe(uart_send_strobe),
    .ready(uart_ready),
    .UART_TX(uart_tx)
);
endmodule
