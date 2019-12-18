`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2019 13:03:57
// Design Name: 
// Module Name: matrix_mul
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


module matrix_mul(
    input [63:0] state_in,
    output [63:0] state_out
    );
        
assign state_out[63] = state_in[59]^	state_in[55]^	state_in[51];	
assign state_out[62] = state_in[62]^	state_in[54]^	state_in[50];	
assign state_out[61] = state_in[61]^	state_in[57]^	state_in[49];	
assign state_out[60] = state_in[60]^	state_in[56]^	state_in[52];	
assign state_out[59] = state_in[63]^	state_in[59]^	state_in[55];	
assign state_out[58] = state_in[58]^	state_in[54]^	state_in[50];	
assign state_out[57] = state_in[61]^	state_in[53]^	state_in[49];	
assign state_out[56] = state_in[60]^	state_in[56]^	state_in[48];	
assign state_out[55] = state_in[63]^	state_in[59]^	state_in[51];	
assign state_out[54] = state_in[62]^	state_in[58]^	state_in[54];	
assign state_out[53] = state_in[57]^	state_in[53]^	state_in[49];	
assign state_out[52] = state_in[60]^	state_in[52]^	state_in[48];	
assign state_out[51] = state_in[63]^	state_in[55]^	state_in[51];	
assign state_out[50] = state_in[62]^	state_in[58]^	state_in[50];	
assign state_out[49] = state_in[61]^	state_in[57]^	state_in[53];	
assign state_out[48] = state_in[56]^	state_in[52]^	state_in[48];	
assign state_out[47] = state_in[47]^	state_in[43]^	state_in[39];	
assign state_out[46] = state_in[42]^	state_in[38]^	state_in[34];	
assign state_out[45] = state_in[45]^	state_in[37]^	state_in[33];	
assign state_out[44] = state_in[44]^	state_in[40]^	state_in[32];	
assign state_out[43] = state_in[47]^	state_in[43]^	state_in[35];	
assign state_out[42] = state_in[46]^	state_in[42]^	state_in[38];	
assign state_out[41] = state_in[41]^	state_in[37]^	state_in[33];	
assign state_out[40] = state_in[44]^	state_in[36]^	state_in[32];	
assign state_out[39] = state_in[47]^	state_in[39]^	state_in[35];	
assign state_out[38] = state_in[46]^	state_in[42]^	state_in[34];	
assign state_out[37] = state_in[45]^	state_in[41]^	state_in[37];	
assign state_out[36] = state_in[40]^	state_in[36]^	state_in[32];	
assign state_out[35] = state_in[43]^	state_in[39]^	state_in[35];	
assign state_out[34] = state_in[46]^	state_in[38]^	state_in[34];	
assign state_out[33] = state_in[45]^	state_in[41]^	state_in[33];	
assign state_out[32] = state_in[44]^	state_in[40]^	state_in[36];	
assign state_out[31] = state_in[31]^	state_in[27]^	state_in[23];	
assign state_out[30] = state_in[26]^	state_in[22]^	state_in[18];	
assign state_out[29] = state_in[29]^	state_in[21]^	state_in[17];	
assign state_out[28] = state_in[28]^	state_in[24]^	state_in[16];	
assign state_out[27] = state_in[31]^	state_in[27]^	state_in[19];	
assign state_out[26] = state_in[30]^	state_in[26]^	state_in[22];	
assign state_out[25] = state_in[25]^	state_in[21]^	state_in[17];	
assign state_out[24] = state_in[28]^	state_in[20]^	state_in[16];	
assign state_out[23] = state_in[31]^	state_in[23]^	state_in[19];	
assign state_out[22] = state_in[30]^	state_in[26]^	state_in[18];	
assign state_out[21] = state_in[29]^	state_in[25]^	state_in[21];	
assign state_out[20] = state_in[24]^	state_in[20]^	state_in[16];	
assign state_out[19] = state_in[27]^	state_in[23]^	state_in[19];	
assign state_out[18] = state_in[30]^	state_in[22]^	state_in[18];	
assign state_out[17] = state_in[29]^	state_in[25]^	state_in[17];	
assign state_out[16] = state_in[28]^	state_in[24]^	state_in[20];	
assign state_out[15] = state_in[11]^	state_in[7]^	state_in[3];	
assign state_out[14] = state_in[14]^	state_in[6]^	state_in[2];	
assign state_out[13] = state_in[13]^	state_in[9]^	state_in[1];	
assign state_out[12] = state_in[12]^	state_in[8]^	state_in[4];	
assign state_out[11] = state_in[15]^	state_in[11]^	state_in[7];	
assign state_out[10] = state_in[10]^	state_in[6]^	state_in[2];	
assign state_out[9] = state_in[13]^	state_in[5]^	state_in[1];	
assign state_out[8] = state_in[12]^	state_in[8]^	state_in[0];	
assign state_out[7] = state_in[15]^	state_in[11]^	state_in[3];	
assign state_out[6] = state_in[14]^	state_in[10]^	state_in[6];	
assign state_out[5] = state_in[9]^	state_in[5]^	state_in[1];	
assign state_out[4] = state_in[12]^	state_in[4]^	state_in[0];	
assign state_out[3] = state_in[15]^	state_in[7]^	state_in[3];	
assign state_out[2] = state_in[14]^	state_in[10]^	state_in[2];	
assign state_out[1] = state_in[13]^	state_in[9]^	state_in[5];	
assign state_out[0] = state_in[8]^	state_in[4]^	state_in[0];			
    
endmodule
