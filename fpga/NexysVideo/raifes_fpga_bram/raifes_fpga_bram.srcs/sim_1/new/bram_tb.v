`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2019 13:43:30
// Design Name: 
// Module Name: bram_tb
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


module bram_tb();

reg clk;
reg [3:0] wea,web;
wire [31:0] rdata_a,rdata_b;
reg  [31:0] addr_a,addr_b,wdata_a,wdata_b;


blk_mem_gen_0 bram01 (
  .clka(clk),    // input wire clka
  .wea(wea),      // input wire [3 : 0] wea
  .addra(addr_a),  // input wire [31 : 0] addra
  .dina(wdata_a),    // input wire [31 : 0] dina
  .douta(rdata_a),  // output wire [31 : 0] douta
 
  .clkb(clk),    // input wire clkb
  .web(web),      // input wire [3 : 0] web
  .addrb(addr_b),  // input wire [31 : 0] addrb
  .dinb(wdata_b),    // input wire [31 : 0] dinb
  .doutb(rdata_b)  // output wire [31 : 0] doutb
);

initial begin
    clk <=0;wea <= 0;web<=0;addr_a<=0;addr_b<=0;wdata_a<=0;wdata_b<=0;
    #55 wea <= 4'hF;
        addr_a<=32'h4;
        wdata_a<=32'hCAFEBABE;
    #100 wea <= 4'hF;
        addr_a<=32'h8;
        wdata_a<=32'hCAFEBABE;
    
    #100 wea <= 4'hF;
        addr_a<=32'hC;
        wdata_a<=32'hDEADBEEF;
    #100 wea <= 4'h0;
        addr_a <= 0;
    
    #500 web <= 4'h0;
        addr_b<=32'h4;

    #100 web <= 4'h0;
        addr_b<=32'h8;

    
    #100 web <= 4'h0;
        addr_b<=32'hC;

end

always begin
    #5 clk <= ~clk;
end

endmodule
