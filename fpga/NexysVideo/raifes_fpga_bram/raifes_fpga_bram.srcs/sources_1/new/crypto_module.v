`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2019 11:23:03
// Design Name: 
// Module Name: crypto_module
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

module crypto_module(
input                               clk,
input								per_en,		// Peripherie Enable
input	[`HASTI_ADDR_WIDTH-1:0]		per_haddr,		// Adresse (*gesamte* 32-Bit Adresse, ggf. nur wenige Bits relevant)
input								per_hwrite,		// Write (von Core in Gerät) Enable
input	[`HASTI_SIZE_WIDTH-1:0]		per_hsize,		// Breite der Transaktion (es sind auch Byte- oder Halfword-Zugriffe möglich)
input	[`HASTI_BURST_WIDTH-1:0]	per_hburst,		// Burst-Modi, siehe AHB-Lite. Ggf. nicht implementiert! TODO
input								per_hmastlock, // TODO
input	[`HASTI_TRANS_WIDTH-1:0]	per_htrans,		// TODO
input	[`HASTI_BUS_WIDTH-1:0]		per_hwdata,		// Daten Core->Peripherie
output reg	[`HASTI_BUS_WIDTH-1:0]	per_hrdata		// Daten Peripherie->Core
//output 							per_hready,		// Ready, bzw. ~busy. Wenn dieses Bit LOW ist, wartet der Core...
//output 	[`HASTI_RESP_WIDTH-1:0]	per_hresp		// Error reporting. TODO    
    );
    
//*********PRINCE REG/WIRE declarations***********\\
reg [`HASTI_ADDR_WIDTH-1:0] PRINCE_ctrl,PRINCE_in0,PRINCE_in1,PRINCE_key0,PRINCE_key1,PRINCE_key2,PRINCE_key3;
wire [`HASTI_ADDR_WIDTH-1:0] PRINCE_out0,PRINCE_out1;
wire PRINCE_finish,PRINCE_reset,PRINCE_enable,PRINCE_enc_ndec;
assign PRINCE_reset = PRINCE_ctrl[2];
assign PRINCE_enable = PRINCE_ctrl[1];
assign PRINCE_enc_ndec = PRINCE_ctrl[3];


//***********KTANTAN REG/WIRE declarations******\\
reg [`HASTI_ADDR_WIDTH-1:0] KTANTAN_in,KTANTAN_ctrl,KTANTAN_key0,KTANTAN_key1,KTANTAN_key2;
wire[`HASTI_ADDR_WIDTH-1:0] KTANTAN_out;
wire [80:0] KTANTAN_key;
wire KTANTAN_finish,KTANTAN_data_recv,KTANTAN_data_rdy,KTANTAN_reset,KTANTAN_enc_ndec;
//assign KTANTAN_data_recv = KTANTAN_ctrl[2];
//assign KTANTAN_data_rdy = KTANTAN_ctrl[3];
//assign KTANTAN_enc_ndec = KTANTAN_ctrl[4];
//assign KTANTAN_reset = KTANTAN_ctrl[1];
assign KTANTAN_key = {KTANTAN_key2[15:0],KTANTAN_key1,KTANTAN_key0};


always @(posedge clk)
begin
    case(per_haddr)
        `PRINCE_in0:begin
                        if(per_hwrite) PRINCE_in0 <= per_hwdata;
                        else  per_hrdata <= PRINCE_in0;
                    end
        `PRINCE_in1:begin
                        if(per_hwrite) PRINCE_in1 <= per_hwdata;
                        else per_hrdata <= PRINCE_in1;        
                    end
        `PRINCE_out0:   begin
                        if(per_hwrite) begin end
                        else per_hrdata <= PRINCE_out0;        
                        end
        `PRINCE_out1:   begin
                         if(per_hwrite) begin end
                        else per_hrdata <= PRINCE_out1;                   
                        end
        `PRINCE_key0:   begin
                        if(per_hwrite) PRINCE_key0 <= per_hwdata;
                        else per_hrdata <= PRINCE_key0;        
                        end
        `PRINCE_key1:   begin
                        if(per_hwrite) PRINCE_key1 <= per_hwdata;
                        else per_hrdata <= PRINCE_key1;        
                        end
        `PRINCE_key2:   begin
                        if(per_hwrite) PRINCE_key2 <= per_hwdata;
                        else per_hrdata <= PRINCE_key2;        
                        end
        `PRINCE_key3:   begin
                        if(per_hwrite) PRINCE_key3 <= per_hwdata;
                        else per_hrdata <= PRINCE_key3;        
                        end
        `PRINCE_ctrl:   begin
                        if(per_hwrite) PRINCE_ctrl <= per_hwdata;
                        else per_hrdata <= {PRINCE_ctrl[31:1],PRINCE_finish};        
                        end
                        
        `KTANTAN32_in:  begin
                        if(per_hwrite) KTANTAN_in <= per_hwdata;
                        else per_hrdata <= KTANTAN_in;
                        end
        `KTANTAN32_out: begin
                        if(per_hwrite) begin end
                        else per_hrdata <= KTANTAN_out;
                        end
        `KTANTAN32_key0:begin
                        if(per_hwrite) KTANTAN_key0 <= per_hwdata;
                        else per_hrdata <= KTANTAN_key0;        
                        end                        
        `KTANTAN32_key1:begin
                        if(per_hwrite) KTANTAN_key1 <= per_hwdata;
                        else per_hrdata <= KTANTAN_key1;        
                        end                       
        `KTANTAN32_key2:begin
                        if(per_hwrite) KTANTAN_key2[15:0] <= per_hwdata[15:0];
                        else per_hrdata <= {16'b0,KTANTAN_key2};        
                        end
        `KTANTAN32_ctrl:begin
                        if(per_hwrite) KTANTAN_ctrl <= per_hwdata;
                        else per_hrdata <= {KTANTAN_ctrl[31:1],KTANTAN_finish};        
                        end
         
    default: begin per_hrdata <= 32'hZ; end
    endcase
end 
    
    
PRINCE_roundbased_top Prince_cipher(
    .clk(clk),
    .reset(PRINCE_reset),
    .enable(PRINCE_enable),
    .enc_ndec(PRINCE_enc_ndec),        
    .plain_in({PRINCE_in1,PRINCE_in0}),       //64-Bit Input
    .key_in({PRINCE_key3,PRINCE_key2,PRINCE_key1,PRINCE_key0}),     //128-Bit Input
    .cipher_out({PRINCE_out1,PRINCE_out0}),     //64-Bit Input
    .finish(PRINCE_finish)
);
    
ktantan32 KTANTAN32_cipher(
    .clk(clk),
    .reset(KTANTAN_ctrl[1]),//KTANTAN_reset),
    .d_recv(KTANTAN_ctrl[2]),//KTANTAN_data_recv),
    .d_rdy(KTANTAN_ctrl[3]),//KTANTAN_data_rdy),
    .enc_ndec(KTANTAN_ctrl[4]),//KTANTAN_enc_ndec),
    .key_input(KTANTAN_key),
    .Din(KTANTAN_in),
    .Dout(KTANTAN_out),
    .finish(KTANTAN_finish)
    );    
    
endmodule
