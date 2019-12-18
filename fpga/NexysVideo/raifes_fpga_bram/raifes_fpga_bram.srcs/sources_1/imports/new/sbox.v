`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2019 10:43:57
// Design Name: 
// Module Name: sbox
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


module sbox(
    input [3:0] Sbox_in,
    output reg [3:0] Sbox_out
);
    always @(*)
    begin
                case(Sbox_in)
                8'h0: Sbox_out <= 8'hB;
                8'h1: Sbox_out <= 8'hF;
                8'h2: Sbox_out <= 8'h3;
                8'h3: Sbox_out <= 8'h2;
                8'h4: Sbox_out <= 8'hA;
                8'h5: Sbox_out <= 8'hC;
                8'h6: Sbox_out <= 8'h9;
                8'h7: Sbox_out <= 8'h1;
                8'h8: Sbox_out <= 8'h6;
                8'h9: Sbox_out <= 8'h7;
                8'hA: Sbox_out <= 8'h8;
                8'hB: Sbox_out <= 8'h0;
                8'hC: Sbox_out <= 8'hE;
                8'hD: Sbox_out <= 8'h5;
                8'hE: Sbox_out <= 8'hD;
                8'hF: Sbox_out <= 8'h4;
            endcase
     end
endmodule
