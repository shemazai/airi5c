module shift_rotate_inv(
        input [63:0] in,
        output [63:0] out
);
   
assign out = {in[63:60],in[11:8],in[23:20],in[35:32],in[47:44],in[59:56],in[7:4],in[19:16],in[31:28],in[43:40],in[55:52],in[3:0],in[15:12],in[27:24],in[39:36],in[51:48]};
    
endmodule