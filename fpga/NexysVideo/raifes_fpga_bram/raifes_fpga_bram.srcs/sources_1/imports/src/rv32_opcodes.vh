// Width-related constants
`define INST_WIDTH     32	// o.k., V2.2, Instruction word is 32 Bits
`define REG_ADDR_WIDTH  5	// o.k., V2.2, There are 32 general purpose registers (GPR) x0 - x31
`define XPR_LEN        32	// o.k., V2.2, Instruction word is 32 Bits TODO : what is XPR in contrast to INST_WIDTH?
`define DOUBLE_XPR_LEN 64	// o.k., V2.2, but do we need this? TODO
`define LOG2_XPR_LEN    5	// o.k., V2.2, Instruction word is 32 Bits = 2^5
`define SHAMT_WIDTH     5	// o.k., V2.2, Bits [24:20] of Inst

`define RV_NOP `INST_WIDTH'b0010011	// o.k., V2.2, == ADDI x0 + 0 -> x0 (does nothing)	

// Opcodes

`define RV32_LOAD     7'b0000011	// o.k., V2.2
`define RV32_STORE    7'b0100011	// o.k., V2.2
//`define RV32_MADD     7'b1000011	// 05.02.18, ASt - removed, we don't need Floating Point support right now.
`define RV32_BRANCH   7'b1100011	// o.k., V2.2

//`define RV32_LOAD_FP  7'b0000111	// 05.02.18, ASt - removed, we don't need Floating Point support right now.
//`define RV32_STORE_FP 7'b0100111	// 05.02.18, ASt - removed, we don't need Floating Point support right now. 
//`define RV32_MSUB     7'b1000111	// 05.02.18, ASt - removed, we don't need Floating Point support right now.
`define RV32_JALR     7'b1100111	// o.k., V2.2

//`define RV32_CUSTOM_0 7'b0001011	// 05.02.18, ASt - removed, we don't need Custom Instructions right now
//`define RV32_CUSTOM_1 7'b0101011	// 05.02.18, ASt - removed, we don't need Custom Instructions right now
//`define RV32_NMSUB    7'b1001011	// 05.02.18, ASt - removed, we don't need Floating Point support right now.
// 7'b1101011 is reserved

`define RV32_MISC_MEM 7'b0001111	// o.k., V2.2 - FENCE / FENCE.I
//`define RV32_AMO      7'b0101111	// 05.02.18, ASt - removed, we don't need Atomic Operations support right now.
//`define RV32_NMADD    7'b1001111	// 05.02.18, ASt - removed, we don't need Floating Point support right now.
`define RV32_JAL      7'b1101111	// o.k., V2.2

`define RV32_OP_IMM   7'b0010011	// o.k., V2.2, REG/IMM ALU operations 
`define RV32_OP       7'b0110011	// o.k., V2.2, REG/REG ALU operations
//`define RV32_OP_FP    7'b1010011	// 05.02.18, ASt - removed, we don't need Floating Point support right now.
`define RV32_SYSTEM   7'b1110011	// o.k., V2.2 -> ECALL, EBREAK, CSR (RW/RS/RC/RWI/RSI/RCI)

`define RV32_AUIPC    7'b0010111	// o.k., V2.2
`define RV32_LUI      7'b0110111	// o.k., V2.2
// 7'b1010111 is reserved
// 7'b1110111 is reserved

// 7'b0011011 is RV64-specific
// 7'b0111011 is RV64-specific
//`define RV32_CUSTOM_2 7'b1011011	// 05.02.18, ASt - removed, we don't need Custom Instructions right now
//`define RV32_CUSTOM_3 7'b1111011	// 05.02.18, ASt - removed, we don't need Custom Instructions right now

// Arithmetic FUNCT3 encodings

`define RV32_FUNCT3_ADD_SUB 0	// o.k., V2.2
`define RV32_FUNCT3_SLL     1	// o.k., V2.2
`define RV32_FUNCT3_SLT     2	// o.k., V2.2
`define RV32_FUNCT3_SLTU    3	// o.k., V2.2
`define RV32_FUNCT3_XOR     4	// o.k., V2.2
`define RV32_FUNCT3_SRA_SRL 5	// o.k., V2.2
`define RV32_FUNCT3_OR      6	// o.k., V2.2
`define RV32_FUNCT3_AND     7	// o.k., V2.2

// Branch FUNCT3 encodings

`define RV32_FUNCT3_BEQ  0	// o.k., V2.2
`define RV32_FUNCT3_BNE  1	// o.k., V2.2
`define RV32_FUNCT3_BLT  4	// o.k., V2.2
`define RV32_FUNCT3_BGE  5	// o.k., V2.2
`define RV32_FUNCT3_BLTU 6	// o.k., V2.2
`define RV32_FUNCT3_BGEU 7	// o.k., V2.2

// MISC-MEM FUNCT3 encodings
`define RV32_FUNCT3_FENCE   0	// o.k., V2.2
`define RV32_FUNCT3_FENCE_I 1	// o.k., V2.2

// SYSTEM FUNCT3 encodings

`define RV32_FUNCT3_PRIV   0	// o.k., V2.2 - ECALL and EBREAK
`define RV32_FUNCT3_CSRRW  1	// o.k., V2.2
`define RV32_FUNCT3_CSRRS  2	// o.k., V2.2
`define RV32_FUNCT3_CSRRC  3	// o.k., V2.2
`define RV32_FUNCT3_CSRRWI 5	// o.k., V2.2
`define RV32_FUNCT3_CSRRSI 6	// o.k., V2.2
`define RV32_FUNCT3_CSRRCI 7	// o.k., V2.2

// PRIV FUNCT12 encodings

`define RV32_FUNCT12_ECALL  12'b000000000000	// o.k., V2.2
`define RV32_FUNCT12_EBREAK 12'b000000000001	// o.k., V2.2
`define RV32_FUNCT12_MRET   12'b001100000010	
`define RV32_FUNCT12_DRET   12'b011110110010	// 05.03.18, ASt: added dret command to return from debug mode
`define RV32_FUNCT12_WFI    12'b000100000101  

// RV32M encodings
`define RV32_FUNCT7_MUL_DIV 7'd1	

`define RV32_FUNCT3_MUL    3'd0	
`define RV32_FUNCT3_MULH   3'd1	
`define RV32_FUNCT3_MULHSU 3'd2	
`define RV32_FUNCT3_MULHU  3'd3	
`define RV32_FUNCT3_DIV    3'd4	
`define RV32_FUNCT3_DIVU   3'd5	
`define RV32_FUNCT3_REM    3'd6	
`define RV32_FUNCT3_REMU   3'd7	
