module sbox_inv(
    input [3:0] Sbox_in,
    output reg [3:0] Sbox_out
);
    always @(*)
    begin
                case(Sbox_in)
                8'h0: Sbox_out <= 8'hB;
                8'h1: Sbox_out <= 8'h7;
                8'h2: Sbox_out <= 8'h3;
                8'h3: Sbox_out <= 8'h2;
                8'h4: Sbox_out <= 8'hF;
                8'h5: Sbox_out <= 8'hD;
                8'h6: Sbox_out <= 8'h8;
                8'h7: Sbox_out <= 8'h9;
                8'h8: Sbox_out <= 8'hA;
                8'h9: Sbox_out <= 8'h6;
                8'hA: Sbox_out <= 8'h4;
                8'hB: Sbox_out <= 8'h0;
                8'hC: Sbox_out <= 8'h5;
                8'hD: Sbox_out <= 8'hE;
                8'hE: Sbox_out <= 8'hC;
                8'hF: Sbox_out <= 8'h1;
            endcase
     end
endmodule