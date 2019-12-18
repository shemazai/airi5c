//
// raifes_alu
//
// simple ALU implementation
//
// History: 
// 10.12.18 - beautified and updated comments (ASt)
//
// Notes:
// The description of the ALU function doesn't include any optimization, 
// the optimization takes place in the synthesis tool.
// 
// MULtiplication is not handled here, but decoded to use a specialised 
// hardware multiplier block with multiple cycle latency. 

// include definition of ALU function names
`include "raifes_alu_ops.vh"

// include definition of RISC-V opcodes, required for `XPR_LEN
`include "rv32_opcodes.vh"

module raifes_alu(
                  input [`ALU_OP_WIDTH-1:0] op,		// operation to be performed
                  input [`XPR_LEN-1:0]      in1,	// A input
                  input [`XPR_LEN-1:0]      in2,	// B input
                  output reg [`XPR_LEN-1:0] out		// result
                  );

   wire [`SHAMT_WIDTH-1:0]                  shamt;	// shift amount. This is a field in the second operand
   assign shamt = in2[`SHAMT_WIDTH-1:0];

   always @(*) begin
      case (op)
        `ALU_OP_ADD : out = in1 + in2;					// (signed) add
        `ALU_OP_SLL : out = in1 << shamt;				// bitwise shift left by shamt bits
        `ALU_OP_XOR : out = in1 ^ in2;					// bitwise XOR
        `ALU_OP_OR : out = in1 | in2;					// bitwise OR
        `ALU_OP_AND : out = in1 & in2;					// bitwise AND
        `ALU_OP_SRL : out = in1 >> shamt;				// bitwise shift right by shamt bits
        `ALU_OP_SEQ : out = {31'b0, in1 == in2};			// compare EQUAL, extend to 32 bits with zeroes
        `ALU_OP_SNE : out = {31'b0, in1 != in2};			// compare NOT EQUAL, extend to 32 bits with zeroes
        `ALU_OP_SUB : out = in1 - in2;					// (signed) sub
        `ALU_OP_SRA : out = $signed(in1) >>> shamt;			// shift right, but preserve sign bit
        `ALU_OP_SLT : out = {31'b0, $signed(in1) < $signed(in2)};	// (signed) compare LESS THAN 
        `ALU_OP_SGE : out = {31'b0, $signed(in1) >= $signed(in2)};	// (signed) compare GREATER OR EQUAL
        `ALU_OP_SLTU : out = {31'b0, in1 < in2};			// unsigned compare less, extend to 32 bits with zeroes
        `ALU_OP_SGEU : out = {31'b0, in1 >= in2};			// unsigned compare greater or equal, extend to 32 bits with zeroes
        default : out = 0;						// should never be reached. TODO: check with assert, if this is ever encountered.
      endcase // case op
   end

endmodule // raifes_alu
