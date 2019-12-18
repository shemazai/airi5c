`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//  
// Create Date: 02.09.2019 10:35:37
// Design Name: 
// Module Name: PRINCE_roundbased_top
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
`include "PRINCE_constants.vh"

module PRINCE_roundbased_top(
    input clk,reset,enable,enc_ndec,
    input [63:0] plain_in,
    input [127:0] key_in,
    output reg [63:0] cipher_out,
    output reg finish
    );
    
    reg [5:0] state,next_state;
    reg inv,mid,white,start;    //control wires (inv: for inverted rounds  mid: middle round   start: for distinguishing start/end whitening key
                                //white: control input of XOR (cipher_state during whitening and RC_key_add)                                
    reg [63:0] cipher_state,round_constant;
    wire [63:0] mul_in,sbox_in,sbox_inv_in,shift_in,shift_inv_in;       //strange naming of wires caused by multiplexing wires to different purposes
    wire [63:0] mul_out,sbox_out,sbox_inv_out,shift_out,shift_inv_out;  // e.g. shift_inv_in is inverted shift input aswell the new cipher_state during non-inverted rounds
    wire [63:0] xor_in1,xor_in2,xor_in3,xor_out,xor_out_middle;
    
    //Key dividing and Whitening-Key generation
    wire [63:0] k0_enc,k_0_enc,k1_enc,k0_dec,k_0_dec,k1_dec,k0,k_0,k1;
    assign k0_enc = key_in[127:64];
    assign k1_enc = key_in[63:0];
    assign k_0_enc = {k0_enc[63],k0_enc[63:2],(k0_enc[1]^k0_enc[63])}; //key extending (k0>>>1)xor(k0>>63) just one xor necassary?
    
    assign k0_dec = k_0_enc;
    assign k1_dec = k1_enc ^ (64'hc0ac29b7c97c50dd);
    assign k_0_dec = k0_enc;
    
    assign k0 = enc_ndec ? k0_enc:k0_dec;               //
    assign k_0 = enc_ndec ? k_0_enc:k_0_dec;            // 3 64-Bit Keys
    assign k1 = enc_ndec ? k1_enc:k1_dec;               //
    
    always @(posedge clk)
    begin
        if(reset) begin 
                    state <= `IDLE;
                    //cipher_out <= 64'h0;
                  end
        else state <= next_state;
    end
    
    always @(*)
    begin
        case(state)
            `IDLE:              begin
                                    if(enable) next_state <=`key_white_start;
                                    else next_state <= `IDLE;
                                end                                   
            `key_white_start:   next_state <= `RC_key_add_start;                            
            `RC_key_add_start:  next_state <= `round_step1;
            `round_step1:       next_state <= `round_step2;                                                                     
            `round_step2:       next_state <= `round_step3;                                           
            `round_step3:       next_state <= `round_step4;                                               
            `round_step4:       next_state <= `round_step5;
            `round_step5:       next_state <= `middle;
            `middle:            next_state <= `round_step6;
            `round_step6:       next_state <= `round_step7;           
            `round_step7:       next_state <= `round_step8;
            `round_step8:       next_state <= `round_step9;
            `round_step9:       next_state <= `round_step10;
            `round_step10:      next_state <= `RC_key_add_end;
            `RC_key_add_end:    next_state <= `key_white_end;
            `key_white_end:     next_state <= `IDLE;                                                                                                
            default:            next_state <= `IDLE;
        endcase
    end
    
    always @(posedge clk)
    begin
        case(state)
            `IDLE:              begin
                                    cipher_state <= plain_in;
                                    finish <= 1'b1;
                                    inv <= 0;
                                    mid <= 0;
                                    white <= 1;
                                    start <= 1;
                                end
            `key_white_start:   begin
                                    finish <= 1'b0;
                                    white <= 0;
                                    start <= 0;
                                    inv <= 1;
                                    round_constant <= `RC0;
                                    cipher_state <= xor_out_middle;
                                end                              
            `RC_key_add_start:  begin
                                    inv <= 0;
                                    cipher_state <= xor_out;
                                    round_constant <= `RC1;
                                    
                                end  
            `round_step1:       begin
                                    round_constant <= `RC2;
                                    cipher_state <= shift_inv_in;
                                end                                                                    
            `round_step2:       begin
                                    round_constant <= `RC3;
                                    cipher_state <= shift_inv_in;
                                end                                            
            `round_step3:       begin
                                    round_constant <= `RC4;
                                    cipher_state <= shift_inv_in;
                                end                                                
            `round_step4:       begin
                                    round_constant <= `RC5;
                                    cipher_state <= shift_inv_in;
                                end 
            `round_step5:       begin
                                    mid <= 1;   
                                    cipher_state <= shift_inv_in;
                                end 
            `middle:            begin
                                    inv <= 1;
                                    mid <= 0;
                                    round_constant <= `RC6;
                                    cipher_state <= sbox_inv_out;
                                    
                                end
            `round_step6:       begin
                                    round_constant <= `RC7;
                                    cipher_state <= sbox_inv_out;
                                end            
            `round_step7:       begin
                                    round_constant <= `RC8;
                                    cipher_state <= sbox_inv_out;
                                end
            `round_step8:       begin
                                    round_constant <= `RC9;
                                    cipher_state <= sbox_inv_out;
                                end
            `round_step9:       begin
                                    round_constant <= `RC10;
                                    cipher_state <= sbox_inv_out;
                                end
            `round_step10:      begin
                                    cipher_state <= sbox_inv_out;
                                    round_constant <= `RC11;
                                end
            `RC_key_add_end:    begin
                                    white <= 1;
                                    cipher_state <= xor_out;
                                end  
            `key_white_end:     begin
                                    cipher_out <= xor_out_middle;
                                    finish <= 1'b1; 
                                end                  
        endcase
        
    end
    
assign shift_inv_in     = xor_out;
assign mul_in           = mid ? sbox_out : (inv ? shift_inv_out:sbox_out);
assign sbox_in          = cipher_state;
assign sbox_inv_in      = mul_out; 
assign shift_in         = mul_out;
assign xor_in1          = (inv||white) ? cipher_state:shift_out;
assign xor_in2          = white ? (start ? k0:k_0):k1;  
assign xor_in3          = round_constant;
// assign cipher_state: if(mid) =sbox_inv_out elseif(inv) =Sbox_inv_out else shift_inv_in 


    
    matrix_mul MUL1(
        .state_in(mul_in),
        .state_out(mul_out)
    );
    shift_rotate shift_rotate1(
        .in(shift_in),
        .out(shift_out)
    );
    shift_rotate_inv shift_rotate_inv1(
        .in(shift_inv_in),
        .out(shift_inv_out)
    );
generate
genvar i;
    for(i=0;i<=60;i=i+4) begin: gen1
    sbox sbox1 (
        .Sbox_in(sbox_in [i+3:i]),
        .Sbox_out(sbox_out [i+3:i])
    );
end
endgenerate

generate
genvar j;
    for(i=0;i<=60;i=i+4) begin: gen2
    sbox_inv sbox_inv1 (
        .Sbox_in(sbox_inv_in [i+3:i]),
        .Sbox_out(sbox_inv_out [i+3:i])
    );
end
endgenerate 

XOR3 XOR3(
    .in1(xor_in1),
    .in2(xor_in2),
    .in3(xor_in3),
    .out_middle(xor_out_middle),
    .out(xor_out)
);
   

endmodule




//    always @(posedge clk)
//    begin
//        case(state)
//            `IDLE:              begin
//                                    cipher_state <= plain_in;
//                                end
//            `key_white_start:   begin
//                                    cipher_state <= cipher_state ^ k0;
//                                end                              
//            `RC_key_add_start:  begin
//                                    cipher_state <= cipher_state ^ k1 ^ `RC0;
//                                end  
//            `round_step1:       begin
//                                    sbox_in = cipher_state;
//                                    mul_in = sbox_out;
//                                    shift_in = mul_out;
//                                    cipher_state <= shift_out ^ k1 ^ `RC1;
//                                end                                                                    
//            `round_step2:       begin
//                                    sbox_in = cipher_state;
//                                    mul_in = sbox_out;
//                                    shift_in = mul_out;
//                                    cipher_state <= shift_out ^ k1 ^ `RC2;
//                                end                                            
//            `round_step3:       begin
//                                    sbox_in = cipher_state;
//                                    mul_in = sbox_out;
//                                    shift_in = mul_out;
//                                    cipher_state <= shift_out ^ k1 ^ `RC3;
//                                end                                                
//            `round_step4:       begin
//                                    sbox_in = cipher_state;
//                                    mul_in = sbox_out;
//                                    shift_in = mul_out;
//                                    cipher_state <= shift_out ^ k1 ^ `RC4;
//                                end 
//            `round_step5:       begin
//                                    sbox_in = cipher_state;
//                                    mul_in = sbox_out;
//                                    shift_in = mul_out;
//                                    cipher_state <= shift_out ^ k1 ^ `RC5;
//                                end 
//            `sbox_middle:       next_state <= `mul_middle;
//            `mul_middle:        next_state <= `sbox_inv_middle;
//            `sbox_inv_middle:   next_state <= `round_step6;
//            `round_step6:       begin
//                                    shift_in = cipher_state ^ k1 ^ `RC6;
//                                    mul_in = shift_out;
//                                    sbox_inv_in = mul_out;
//                                    cipher_state <= sbox_inv_out;
//                                end            
//            `round_step7:       begin
//                                    shift_in = cipher_state ^ k1 ^ `RC7;
//                                    mul_in = shift_out;
//                                    sbox_inv_in = mul_out;
//                                    cipher_state <= sbox_inv_out;
//                                end
//            `round_step8:       begin
//                                    shift_in = cipher_state ^ k1 ^ `RC8;
//                                    mul_in = shift_out;
//                                    sbox_inv_in = mul_out;
//                                    cipher_state <= sbox_inv_out;
//                                end
//            `round_step9:       begin
//                                    shift_in = cipher_state ^ k1 ^ `RC9;
//                                    mul_in = shift_out;
//                                    sbox_inv_in = mul_out;
//                                    cipher_state <= sbox_inv_out;
//                                end
//            `round_step10:      begin
//                                    shift_in = cipher_state ^ k1 ^ `RC10;
//                                    mul_in = shift_out;
//                                    sbox_inv_in = mul_out;
//                                    cipher_state <= sbox_inv_out;
//                                end
//            `RC_key_add_end:    cipher_state <= cipher_state ^ k1 ^ `RC11;  
//            `key_white_end:     cipher_out <= cipher_state ^ k_0;                     
//        endcase
//    end
