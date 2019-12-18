`timescale 1ns / 1ps  

`define IDLE  5'b00001
`define INIT  5'b00010
`define INIT2 5'b00100
`define SHIFT 5'b01000
`define DONE  5'b10000

//
//Cipher KTANTAN32 (32-bit Block / 80-Bit Key)
//expects 
//
//
//
//
//
//
//
//
module ktantan32(
    input clk,reset,d_recv,d_rdy,enc_ndec,
    input [31:0] Din,
    input [79:0] key_input,
    output reg [31:0] Dout,
    output reg finish
    );
    

    reg [4:0] next_state,state ;      
    reg [79:0] key;
    reg enable,load,enable_count,reset_count;
    wire [18:0] din19,dout19; //dout19;
    wire [12:0] din13,dout13; //dout13;
    
    wire irregular_bit,done;
    wire [1:0] key_bits,feedback;
    wire [7:0] roundcounter;
    
    assign din13 =Din[31:19] ;
    assign din19 =Din[18:0] ;
    
    always @(posedge clk)
    begin
        if(d_rdy) key <= key_input;
        else begin end
    end
    
    always @(posedge clk)
    begin
        if(reset)  state <= `IDLE;
        else begin
            state <= next_state;
        end
    end 
    
    always @(*)
    begin
        case(state)
            `IDLE : begin 
						if(d_rdy && (!d_recv)) next_state <= `INIT;
						else next_state <= `IDLE;
					end
            `INIT :  next_state <= `INIT2;
            `INIT2:  next_state <= `SHIFT;

            `SHIFT: begin
                        if(done)    next_state <= `DONE;
                        else        next_state <= `SHIFT;
                    end
            `DONE : begin
                        if(d_recv && (!d_rdy))  next_state <= `IDLE;
                        else                    next_state <= `DONE;
                        
                   end 
            
           default: next_state <= `IDLE;
        endcase
    end
    
    always @(posedge clk)
    begin
        case(state)
            `IDLE:   begin
                    enable <= 0;
                    finish <= 0;
                    load <= 1;
                    reset_count <= 1;
                    enable_count <= 0;
                    end
                        
            `INIT:   begin
                    load <= 0;
                    reset_count <= 0;
                    enable_count <= 1;
                    end
                    
            `INIT2:  begin
                    enable <= 1;
                    end
                    
            `SHIFT: begin
                         Dout <= {32{done}}&{dout13,dout19};                        
                    end
             `DONE:  begin
                    enable <= 0;
                    finish <= 1;
                    enable_count <=0;
                    end
                  
        endcase
    end
    
    
    lfsr_count lfsr_count1(
                 .clk(clk),     
                 .reset(reset_count), 
                 .irregular_bit(irregular_bit), 
                 .done(done), 
                 .count_out(roundcounter),
                 .enable(enable_count),
                 .enc_ndec(enc_ndec)
                 );
                 
    lfsr19 L2(
                .clk(clk), 
                .Din(din19), 
                .Dout(dout19), 
                .feedback_in(feedback[1]), 
                .feedback_out(feedback[0]), 
                .key_bit_b(key_bits[1]), 
                .enable(enable),
                .enc_ndec(enc_ndec),
                .load(load)
                );
                
    lfsr13 L1(
                .clk(clk), 
                .irregular_bit(irregular_bit), 
                .Din(din13), 
                .Dout(dout13), 
                .feedback_in(feedback[0]),
                .feedback_out(feedback[1]), 
                .key_bit_a(key_bits[0]), 
                .enable(enable),
                .enc_ndec(enc_ndec),
                .load(load)
                 );
    
    get_key_bits get_key_bits1(
                .roundcounter(roundcounter), 
                .key(key), 
                .key_bits(key_bits)
                );
//    initial
//    begin
//        key = 80'h0123456789ABCDEF0123;
//        state = `IDLE;
//        next_state = `IDLE;
//    end
endmodule

module get_key_bits(   //[1] = k_b  [0] = k_a
    input [7:0] roundcounter,
    input [79:0] key,
    input enc_ndec,
    output [1:0] key_bits
    );

        wire [4:0] key_temp16;
        wire [1:0] key_temp4, key_select4_1, nkey_select4_1;
        wire [3:0] key_select16_1;
        
        assign key_select16_1 = roundcounter[7:4];
        assign key_select4_1 = roundcounter[1:0];
        assign nkey_select4_1 = ~key_select4_1; 
        
        
        mux_16_1 mux1(.x(key[79:64]), .select(key_select16_1), .y(key_temp16[4]));
        mux_16_1 mux2(.x(key[63:48]), .select(key_select16_1), .y(key_temp16[3]));
        mux_16_1 mux3(.x(key[47:32]), .select(key_select16_1), .y(key_temp16[2]));
        mux_16_1 mux4(.x(key[31:16]), .select(key_select16_1), .y(key_temp16[1]));
        mux_16_1 mux5(.x(key[15:0]), .select(key_select16_1), .y(key_temp16[0]));
        
        mux_4_1 mux6(.x(key_temp16[4:1]), .select(key_select4_1), .y(key_temp4[0]));
        mux_4_1 mux7(.x(key_temp16[3:0]), .select(nkey_select4_1), .y(key_temp4[1]));
        
        assign key_bits[0] =  ((!roundcounter[3]) && (!roundcounter[2]) && key_temp16[0]) ^ ((roundcounter[2] || roundcounter[3]) && key_temp4[0]);
        assign key_bits[1] =  ((!roundcounter[3]) && (roundcounter[2]) && key_temp16[4]) ^(((!roundcounter[2]) || roundcounter[3]) && key_temp4[1]);
endmodule 


module lfsr13(
    input [12:0] Din,
    input enc_ndec,feedback_in,key_bit_a,irregular_bit,enable,load,   //from the other lfsr
    input clk,
    output feedback_out, //to the other lfsr
    output reg [12:0] Dout

    );
    
    wire feedback_dec;                              
    assign feedback_dec = feedback_in ^ Dout[8] ^ (Dout[9] && Dout[6]) ^ (Dout[4] && irregular_bit) ^ key_bit_a; 
    assign feedback_out = (enc_ndec==1'b1) ? (Dout[12] ^ Dout[7] ^ (Dout[8] && Dout[5]) ^ (Dout[3] && irregular_bit) ^ key_bit_a) : Dout[0];
    
    always @(posedge clk)
    begin
        if(enable)
        begin
       
            if(enc_ndec)
            begin
                Dout <= {Dout[11:0],feedback_in};
            end
            else
            begin
                Dout <= {feedback_dec,Dout[12:1]};
            end
         
        end
        if(load)
        begin
            Dout <= Din;    
        end
    end
endmodule


module lfsr19(
    input [18:0] Din,
    input enc_ndec,feedback_in,key_bit_b,enable,load,   //from the other lfsr
    input clk,
    output feedback_out, //to the other lfsr
    output reg [18:0] Dout
    
    );  
     wire feedback_dec;                             
     assign feedback_dec = feedback_in ^ Dout[8] ^ (Dout[13] && Dout[11]) ^ (Dout[9] && Dout[4])^ key_bit_b;
     assign feedback_out = (enc_ndec==1'b1) ? (Dout[18] ^ Dout[7] ^ (Dout[12] && Dout[10]) ^ (Dout[8] && Dout[3])^ key_bit_b) : Dout[0];
    
    always @(posedge clk)
    begin
        if(enable & (!load))
        begin
        //Dout <= {Dout[17:0],feedback_in};
        
            if(enc_ndec)
            begin
                Dout <= {Dout[17:0],feedback_in};
            end
            else
            begin
                Dout <={feedback_dec,Dout[18:1]};
            end
        
                
        end
        if(load & (!enable)) 
        begin
            Dout <= Din;    
        end
    end
endmodule


module lfsr_count(
    input clk,reset,enable,enc_ndec,
    output irregular_bit,
    output done,
    output [7:0] count_out
    );
    
    reg [7:0] count;
    wire feedback;
                                                   
    assign feedback = (enc_ndec==1) ? (count[7]^count[6]^count[4]^count[2]) : (count[7]^count[4]^count[2]^count[0]) ;
    assign irregular_bit = (enc_ndec==1) ? count[7] : count[0];
    assign count_out = (enc_ndec==1) ? count[7:0]:{count[0],count[1],count[2],count[3],count[4],count[5],count[6],count[7]};
    assign done = &count;
    
    
    always @(posedge clk)
    begin
        if(enable && (!reset))
        begin
            count <= {count[6:0],feedback};
        end
        
        if(reset)
        begin 
            count <= 8'hFF;          
        end
    end
endmodule


module mux_16_1(
    input [15:0] x,
    input [3:0] select,
    output reg y
    );
    
    always @(*)
    begin
        case (select)
            4'd0: y = x[4'd0];
            4'd1: y = x[4'd1];
            4'd2: y = x[4'd2];
            4'd3: y = x[4'd3];
            4'd4: y = x[4'd4];
            4'd5: y = x[4'd5];
            4'd6: y = x[4'd6];
            4'd7: y = x[4'd7];
            4'd8: y = x[4'd8];
            4'd9: y = x[4'd9];
            4'd10: y = x[4'd10];
            4'd11: y = x[4'd11];
            4'd12: y = x[4'd12];
            4'd13: y = x[4'd13];
            4'd14: y = x[4'd14];
            4'd15: y = x[4'd15];
        endcase
     end
endmodule
    

module mux_4_1(
    input [3:0] x,
    input [1:0] select,
    output reg y
);
    
always @(*)
begin
    case(select)
        2'd0: y = x[2'd0];    
        2'd1: y = x[2'd1];
        2'd2: y = x[2'd2];
        2'd3: y = x[2'd3];
    endcase
end
endmodule