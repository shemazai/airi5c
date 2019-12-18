`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2019 17:10:04
// Design Name: 
// Module Name: 2XOR
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

module XOR3(
    input [63:0] in1,in2,in3,
    output [63:0] out,out_middle
    
    );
    
    assign out_middle = in1 ^ in2;
    assign out = out_middle ^ in3;
endmodule
