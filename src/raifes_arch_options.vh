// Define architectural options 
// to include / exclude from the design

// ISA Extension "E" - reduced instruction set
// ===========================================
//
// This option enables the E extension, which reduces the number
// of GPRs to 16 and removes the rdcycle[h], rdtime[h] and rdinstret[h] 
// instructions and CSR registers.

// Default = undefined (full "I" instruction set)

`undef ISA_EXT_E
//`define ISA_EXT_E
