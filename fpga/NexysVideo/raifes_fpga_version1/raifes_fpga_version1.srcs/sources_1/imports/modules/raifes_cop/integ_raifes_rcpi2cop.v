`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2019 10:59:31
// Design Name: Xueqi Li
// Module Name: integ_raifes_rcpi2cop
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

`define RV32_XCRYPTO    7'b0101011

module integ_raifes_rcpi2cop (

// System Signals
input clk,reset,

// Raifes Co-Processor Interface (RCPI)
input          rcpi_valid    ,
input  [31:0]  rcpi_insn     ,
input  [31:0]  rcpi_rs1      ,
input  [31:0]  rcpi_rs2      ,
output         rcpi_wr       ,
output [31:0]  rcpi_rd       ,
output  [4:0]  rcpi_wadd     ,
output         rcpi_wait     ,
output         rcpi_ready    , 

// XCrypto Co-Processor Interface
output         cpu_insn_req  , // Instruction request
input          cop_insn_ack  , // Instruction request acknowledge
output  [31:0] cpu_insn_enc  , // Encoded instruction data
output  [31:0] cpu_rs1       , // RS1 source data
output  [31:0] cpu_rs2       , // RS2 source data
input          cop_wen       , // COP write enable
input  [ 4:0]  cop_waddr     , // COP destination register address
input  [31:0]  cop_wdata     , // COP write data
input  [ 2:0]  cop_result    , // COP execution result
input          cop_insn_rsp  , // COP instruction finished
output         cpu_insn_ack    // Instruction finish acknowledge

);

//
// Raifes -> COP
//

assign cpu_insn_req  = rcpi_valid;
assign cpu_insn_enc  = rcpi_insn;
assign cpu_rs1       = rcpi_rs1;
assign cpu_rs2       = rcpi_rs2;

//
// Constant / un-used signals
//
assign cpu_insn_ack  = 1'b1; // CPU accepts all responses immediately.

//
//
// COP -> Raifes
//
//  RCPI does not allow COP to specify a writeback register. The writeback
//  register address is automatically decoded by the Raifes. By design
//  all writeback register addresses in the XCrypto ISE align with the
//  standard RISC-V destination register fields.
//
 reg       r_rcpi_wait;
 reg [31:0]r_rcpi_rd;
 reg [7:0] state;
  
 assign   rcpi_wr =  cop_wen;
 assign   rcpi_rd =  r_rcpi_rd;
 assign   rcpi_wadd = cop_waddr;

 wire   xcrypto_inst; assign xcrypto_inst = (rcpi_insn[6:0] == `RV32_XCRYPTO);
always @(posedge clk or negedge reset) 
  begin
       if (reset)
          begin
              r_rcpi_rd <= 32'hdeadbeef;
              state <= 1'b0;
          end
       else begin
            case (state)
             0:  begin 
                    if (rcpi_valid && xcrypto_inst)
                     begin  
                        r_rcpi_rd <= cop_wdata;               
                        state <= 1'b1;
                     end
                    else begin 
                          state <= 1'b0;
                        end
                 end
              1:  begin 
                    state <= 1'b0;
                  end
           
          endcase
        end
   end
    
assign rcpi_wait = rcpi_valid && (state == 0) && xcrypto_inst;
assign rcpi_ready = (state == 1);

endmodule
