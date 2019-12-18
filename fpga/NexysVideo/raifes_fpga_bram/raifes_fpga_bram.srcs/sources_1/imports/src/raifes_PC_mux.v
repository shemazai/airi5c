`include "raifes_ctrl_constants.vh"
`include "rv32_opcodes.vh"
`include "raifes_arch_options.vh"

// ASt, 08/19
// originally, calculation of next PC (PC_PIF) starts with finalized
// branch decision in ALU stage. It is way faster to calculate
// possible branch targets in parallel and multiplex the chosen 
// address to the PC_PIF, as soon as the ALU decides. 
// 
// UNdefine PC_MUX_FAST for slow implementation using a single adder
// define PC_MUX_FAST for parallel branch target calculation (default).

// Update: maybe the synthesis can do this automagically when the target speed is high enough.
// TODO: check, and remove if already done by synthesis.

module raifes_PC_mux(
                     input [`PC_SRC_SEL_WIDTH-1:0] PC_src_sel,
                     input [`INST_WIDTH-1:0]       inst_DX,
                     input [`XPR_LEN-1:0]          rs1_data_bypassed,
		     input [`XPR_LEN-1:0]	   rs1_data,
		     input			   bypass_rs1,
                     input [`XPR_LEN-1:0]          PC_IF,
                     input [`XPR_LEN-1:0]          PC_DX,
                     input [`XPR_LEN-1:0]          handler_PC,
                     input [`XPR_LEN-1:0]          dpc,                     
		     input [`XPR_LEN-1:0]          epc,
                     output [`XPR_LEN-1:0]         PC_PIF
                     );

   wire [`XPR_LEN-1:0]                             imm_b = { {20{inst_DX[31]}}, inst_DX[7], inst_DX[30:25], inst_DX[11:8], 1'b0 };
   wire [`XPR_LEN-1:0]                             jal_offset = { {12{inst_DX[31]}}, inst_DX[19:12], inst_DX[20], inst_DX[30:25], inst_DX[24:21], 1'b0 };
   wire [`XPR_LEN-1:0]                             jalr_offset = { {21{inst_DX[31]}}, inst_DX[30:21], 1'b0 };

   reg [`XPR_LEN-1:0]                              base;
   reg [`XPR_LEN-1:0]                              offset;

`ifndef PC_MUX_FAST

// slow implementation

   always @(*) begin
      case (PC_src_sel)
        `PC_JAL_TARGET : begin
           base = PC_DX;
           offset = jal_offset;
        end
        `PC_JALR_TARGET : begin	
           base = bypass_rs1 ? rs1_data_bypassed : rs1_data;
           offset = jalr_offset;
        end
        `PC_BRANCH_TARGET : begin
           base = PC_DX;
           offset = imm_b;
        end
        `PC_REPLAY : begin
           base = PC_IF;
           offset = `XPR_LEN'h0;
        end
        `PC_HANDLER : begin
           base = handler_PC;
           offset = `XPR_LEN'h0;
        end
        `PC_EPC : begin
           base = epc;
           offset = `XPR_LEN'h0;
        end
        `PC_DPC : begin
           base = dpc;
           offset = `XPR_LEN'h0;
        end
        default : begin
           base = PC_IF;
           offset = `XPR_LEN'h4;
        end
      endcase // case (PC_src_sel)
   end // always @ (*)


   assign PC_PIF = base + offset;

`else

// explicitly parallel implementation

   reg [`XPR_LEN-1:0] jal_target, jalr_target, jalr_target_bypassed, branch_target, default_target;
   reg [`XPR_LEN-1:0] PC_PIF_r;
   assign PC_PIF = PC_PIF_r;

   always @(PC_DX or jal_offset) begin jal_target = PC_DX + jal_offset; end
   always @(rs1_data or jalr_offset) begin jalr_target = rs1_data + jalr_offset; end
   always @(rs1_data_bypassed or jalr_offset) begin jalr_target_bypassed = rs1_data_bypassed + jalr_offset; end
   always @(PC_DX or imm_b) begin branch_target = PC_DX + imm_b; end
   always @(PC_IF) begin default_target = PC_IF + `XPR_LEN'h4; end

   always @(PC_src_sel or jal_target or jalr_target or jalr_target_bypassed or branch_target or default_target) begin
	case (PC_src_sel)
		`PC_JAL_TARGET : PC_PIF_r = jal_target;
		`PC_JALR_TARGET : PC_PIF_r = bypass_rs1 ? jalr_target_bypassed : jalr_target;
		`PC_BRANCH_TARGET : PC_PIF_r = branch_target;
		`PC_REPLAY : PC_PIF_r = PC_IF;
		`PC_HANDLER : PC_PIF_r = handler_PC;
		`PC_EPC : PC_PIF_r = epc;
		`PC_DPC : PC_PIF_r = dpc;
		default : PC_PIF_r = default_target;
	endcase
   end


`endif

endmodule // raifes_PC_mux

