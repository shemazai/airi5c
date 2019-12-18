// Define architectural options 
// to include / exclude from the design

// ISA Extension "E" - reduced instruction set
// ===========================================
//
// This option enables the E extension, which reduces the number
// of GPRs to 16 and removes the rdcycle[h], rdtime[h] and rdinstret[h] 
// instructions and CSR registers.

// Default = undefined (full register set)

`undef ISA_EXT_E
//`define ISA_EXT_E

// ISA Extension "M" - hardware MUL/DIV/REM
// ========================================
//
// This option enables the M extension, which adds a 5 cycle 
// hardware multiplier and a sequential divider/remainder unit.
// The unit is added to the PCPI-Corprocessor-Interface if 
// enabled.
// CoreMark speedup ca. +80%, Gate Count ~ 8kGates

// `undef ISA_EXT_M
`define ISA_EXT_M


// Branch Address calculation
// ==========================
// The calcualation of branch target adresses can 
// be performed in parallel to the ALU operation (faster)
// or after the branch decision has been made (less area).
//
// default = leave optimization to the synthesis

//`define PC_MUX_FAST
`undef PC_MUX_FAST



