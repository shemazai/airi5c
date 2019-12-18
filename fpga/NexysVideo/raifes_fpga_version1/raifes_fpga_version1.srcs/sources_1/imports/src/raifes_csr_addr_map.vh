//
// raifes_csr_addr_map.vh
//
// Module	:	-
// Description	:	Constants for CSR file.
//
// History	:
//

`define CSR_ADDR_WIDTH     12
`define CSR_COUNTER_WIDTH  64

// ====================================
// ==    User Trap Setup	      =
// ====================================

`define	CSR_ADDR_USTATUS	12'h000		// User status register
`define	CSR_ADDR_UIE		12'h004		// User interrupt-enable register
`define	CSR_ADDR_UTVEC		12'h005		// User trap handler base address

// ====================================
// ==    User Trap Handling	      =	
// ====================================

`define CSR_ADDR_USCRATCH	12'h040		// Scratch register for user trap handlers
`define	CSR_ADDR_UEPC		12'h041		// User exception program counter
`define	CSR_ADDR_UCAUSE		12'h042		// User trap cause
`define	CSR_ADDR_UTVAL		12'h043		// User bad address or instruction
`define	CSR_ADDR_UIP		12'h044		// User interrupt pending

// ====================================
// ==    User Floating-Point CSRs     =	
// ====================================

`define	CSR_ADDR_FFLAGS		12'h001		// Floating-Point Accrued Exceptions
`define	CSR_ADDR_FRM		12'h002		// Floating-Point Dynamic Rounding Mode
`define	CSR_ADDR_FCSR		12'h003		// Floating-Point Control and Status Register (frm + fflags)

// ====================================
// ==    User Counter/Timers          =
// ====================================

`define CSR_ADDR_CYCLE     	12'hC00		// Cycle counter for RDCYCLE instruction
`define CSR_ADDR_TIME      	12'hC01		// Timer for RDTIME instruction
`define CSR_ADDR_INSTRET   	12'hC02		// Instructions-retired counter for RDINSTRET instruction

`define CSR_ADDR_HPMCOUNTER3	12'hC03		// Performance-monitoring counter
`define CSR_ADDR_HPMCOUNTER4	12'hC04
`define CSR_ADDR_HPMCOUNTER5	12'hC05
`define CSR_ADDR_HPMCOUNTER6	12'hC06
`define CSR_ADDR_HPMCOUNTER7	12'hC07
`define CSR_ADDR_HPMCOUNTER8	12'hC08
`define CSR_ADDR_HPMCOUNTER9	12'hC09
`define CSR_ADDR_HPMCOUNTER10	12'hC0A
`define CSR_ADDR_HPMCOUNTER11	12'hC0B
`define CSR_ADDR_HPMCOUNTER12	12'hC0C
`define CSR_ADDR_HPMCOUNTER13	12'hC0D
`define CSR_ADDR_HPMCOUNTER14	12'hC0E
`define CSR_ADDR_HPMCOUNTER15	12'hC0F
`define CSR_ADDR_HPMCOUNTER16	12'hC10
`define CSR_ADDR_HPMCOUNTER17	12'hC11
`define CSR_ADDR_HPMCOUNTER18	12'hC12
`define CSR_ADDR_HPMCOUNTER19	12'hC13
`define CSR_ADDR_HPMCOUNTER20	12'hC14
`define CSR_ADDR_HPMCOUNTER21	12'hC15
`define CSR_ADDR_HPMCOUNTER22	12'hC16
`define CSR_ADDR_HPMCOUNTER23	12'hC17
`define CSR_ADDR_HPMCOUNTER24	12'hC18
`define CSR_ADDR_HPMCOUNTER25	12'hC19
`define CSR_ADDR_HPMCOUNTER26	12'hC1A
`define CSR_ADDR_HPMCOUNTER27	12'hC1B
`define CSR_ADDR_HPMCOUNTER28	12'hC1C
`define CSR_ADDR_HPMCOUNTER29	12'hC1D
`define CSR_ADDR_HPMCOUNTER30	12'hC1E
`define CSR_ADDR_HPMCOUNTER31	12'hC1F

`define CSR_ADDR_CYCLEH    	12'hC80 	// Upper 32 bits of CSR_ADDR_CYCLE, RV32I only.
`define CSR_ADDR_TIMEH     	12'hC81 	// Upper 32 bits of CSR_ADDR_TIME, RV32I only
`define CSR_ADDR_INSTRETH  	12'hC82 	// Upper 32 bits of CSR_ADDR_INSTRET, RV32I only.

`define CSR_ADDR_HPMCOUNTER3H	12'hC83		// Upper 32 bits of CSR_ADDR_HPMCOUNTER3, RV32I only
`define CSR_ADDR_HPMCOUNTER4H	12'hC84
`define CSR_ADDR_HPMCOUNTER5H	12'hC85
`define CSR_ADDR_HPMCOUNTER6H	12'hC86
`define CSR_ADDR_HPMCOUNTER7H	12'hC87
`define CSR_ADDR_HPMCOUNTER8H	12'hC88
`define CSR_ADDR_HPMCOUNTER9H	12'hC89
`define CSR_ADDR_HPMCOUNTER10H	12'hC8A
`define CSR_ADDR_HPMCOUNTER11H	12'hC8B
`define CSR_ADDR_HPMCOUNTER12H	12'hC8C
`define CSR_ADDR_HPMCOUNTER13H	12'hC8D
`define CSR_ADDR_HPMCOUNTER14H	12'hC8E
`define CSR_ADDR_HPMCOUNTER15H	12'hC8F
`define CSR_ADDR_HPMCOUNTER16H	12'hC90
`define CSR_ADDR_HPMCOUNTER17H	12'hC91
`define CSR_ADDR_HPMCOUNTER18H	12'hC92
`define CSR_ADDR_HPMCOUNTER19H	12'hC93
`define CSR_ADDR_HPMCOUNTER20H	12'hC94
`define CSR_ADDR_HPMCOUNTER21H	12'hC95
`define CSR_ADDR_HPMCOUNTER22H	12'hC96
`define CSR_ADDR_HPMCOUNTER23H	12'hC97
`define CSR_ADDR_HPMCOUNTER24H	12'hC98
`define CSR_ADDR_HPMCOUNTER25H	12'hC99
`define CSR_ADDR_HPMCOUNTER26H	12'hC9A
`define CSR_ADDR_HPMCOUNTER27H	12'hC9B
`define CSR_ADDR_HPMCOUNTER28H	12'hC9C
`define CSR_ADDR_HPMCOUNTER29H	12'hC9D
`define CSR_ADDR_HPMCOUNTER30H	12'hC9E
`define CSR_ADDR_HPMCOUNTER31H	12'hC9F

// ====================================
// ==    Supervisor Trap Setup        =
// ====================================


`define CSR_ADDR_SSTATUS	12'h100		// Supervisor status register		
`define CSR_ADDR_SEDELEG	12'h102		// Supervisor exception delegation register
`define	CSR_ADDR_SIDELEG	12'h103		// Supervisor interrupt delegation register
`define	CSR_ADDR_SIE		12'h104		// Supervisor interrupt-enable register
`define	CSR_ADDR_STVEC		12'h105		// Supervisor trap handler base address
`define	CSR_ADDR_SCOUNTEREN	12'h106		// Supervisor counter enable

// ====================================
// ==    Supervisor Trap Handling     =
// ====================================

`define CSR_ADDR_SSCRATCH	12'h140		// Scratch register for supervisor trap handlers
`define	CSR_ADDR_SEPC		12'h141		// Supervisor exception program counter
`define	CSR_ADDR_SCAUSE		12'h142		// Supervisor trap cause
`define	CSR_ADDR_STVAL		12'h143		// Supervisor bad address or instruction
`define	CSR_ADDR_SIP		12'h144		// Supervisor interrupt pending

// =================================================
// ==    Supervisor Protection and Translation     =
// =================================================

`define	CSR_ADDR_SATP		12'h180		// Supervisor address translation and protection

// ======================================
// ==    Machine Information Registers  =
// ======================================

`define CSR_ADDR_MVENDORID	12'hF11		// Vendor ID
`define	CSR_ADDR_MARCHID	12'hF12		// Architecture ID
`define	CSR_ADDR_MIMPID		12'hF13		// Implementation ID
`define CSR_ADDR_MHARTID	12'hF14		// Hardware thread ID

// ======================================
// ==    Machine Trap Setup	        =
// ======================================

`define CSR_ADDR_MSTATUS	12'h300		// Machine status register
`define	CSR_ADDR_MISA		12'h301		// ISA and extensions			   p.17, Table 3.2
`define CSR_ADDR_MEDELEG	12'h302		// Machine exception delegation register
`define	CSR_ADDR_MIDELEG	12'h303		// Machine interrupt delegation register
`define CSR_ADDR_MIE       	12'h304		// Machine interrupt-enable register
`define CSR_ADDR_MTVEC		12'h305		// Machine trap-handler base address
`define CSR_ADDR_MCOUNTEREN	12'h306		// Machine counter enable

// ======================================
// ==    Machine Trap Handling	        =
// ======================================

`define CSR_ADDR_MSCRATCH  	12'h340		// Scratch register for machine trap handlers
`define CSR_ADDR_MEPC      	12'h341		// Machine exception program counter
`define CSR_ADDR_MCAUSE 	12'h342		// Machine trap cause
`define CSR_ADDR_MTVAL		12'h343		// Machine bad address or instruction
`define CSR_ADDR_MIP       	12'h344		// Machine interrupt pending

// =============================================
// ==    Machine Protection and Translation    =
// =============================================

`define CSR_ADDR_PMPCFG0	12'h3A0		// Physical memory protection configuration
`define CSR_ADDR_PMPCFG1	12'h3A1		// Physical memory protection configuration, RV32 only
`define CSR_ADDR_PMPCFG2	12'h3A2		// Physical memory protection configuration
`define CSR_ADDR_PMPCFG3	12'h3A3		// Physical memory protection configuration, RV32 only

`define CSR_ADDR_PMPADDR0	12'h3B0		// Physical memory protection address register
`define CSR_ADDR_PMPADDR1	12'h3B1
`define CSR_ADDR_PMPADDR2	12'h3B2
`define CSR_ADDR_PMPADDR3	12'h3B3
`define CSR_ADDR_PMPADDR4	12'h3B4
`define CSR_ADDR_PMPADDR5	12'h3B5
`define CSR_ADDR_PMPADDR6	12'h3B6
`define CSR_ADDR_PMPADDR7	12'h3B7
`define CSR_ADDR_PMPADDR8	12'h3B8
`define CSR_ADDR_PMPADDR9	12'h3B9
`define CSR_ADDR_PMPADDR10	12'h3BA
`define CSR_ADDR_PMPADDR11	12'h3BB
`define CSR_ADDR_PMPADDR12	12'h3BC
`define CSR_ADDR_PMPADDR13	12'h3BD
`define CSR_ADDR_PMPADDR14	12'h3BE
`define CSR_ADDR_PMPADDR15	12'h3BF

// =============================================
// ==    Machine Counter / Timer	       =
// =============================================

`define CSR_ADDR_MCYCLE		12'hB00		// Machine cycle counter
`define CSR_ADDR_MINSTRET	12'hB02		// Machine instructions-retired counter

`define CSR_ADDR_MHPMCOUNTER3	12'hB03		// Machine performance-monitoring counter
`define CSR_ADDR_MHPMCOUNTER4	12'hB04
`define CSR_ADDR_MHPMCOUNTER5	12'hB05
`define CSR_ADDR_MHPMCOUNTER6	12'hB06
`define CSR_ADDR_MHPMCOUNTER7	12'hB07
`define CSR_ADDR_MHPMCOUNTER8	12'hB08
`define CSR_ADDR_MHPMCOUNTER9	12'hB09
`define CSR_ADDR_MHPMCOUNTER10	12'hB0A
`define CSR_ADDR_MHPMCOUNTER11	12'hB0B
`define CSR_ADDR_MHPMCOUNTER12	12'hB0C
`define CSR_ADDR_MHPMCOUNTER13	12'hB0D
`define CSR_ADDR_MHPMCOUNTER14	12'hB0E
`define CSR_ADDR_MHPMCOUNTER15	12'hB0F
`define CSR_ADDR_MHPMCOUNTER16	12'hB10
`define CSR_ADDR_MHPMCOUNTER17	12'hB11
`define CSR_ADDR_MHPMCOUNTER18	12'hB12
`define CSR_ADDR_MHPMCOUNTER19	12'hB13
`define CSR_ADDR_MHPMCOUNTER20	12'hB14
`define CSR_ADDR_MHPMCOUNTER21	12'hB15
`define CSR_ADDR_MHPMCOUNTER22	12'hB16
`define CSR_ADDR_MHPMCOUNTER23	12'hB17
`define CSR_ADDR_MHPMCOUNTER24	12'hB18
`define CSR_ADDR_MHPMCOUNTER25	12'hB19
`define CSR_ADDR_MHPMCOUNTER26	12'hB1A
`define CSR_ADDR_MHPMCOUNTER27	12'hB1B
`define CSR_ADDR_MHPMCOUNTER28	12'hB1C
`define CSR_ADDR_MHPMCOUNTER29	12'hB1D
`define CSR_ADDR_MHPMCOUNTER30	12'hB1E
`define CSR_ADDR_MHPMCOUNTER31	12'hB1F		// Machine performance monitoring counter

`define CSR_ADDR_MCYCLEH	12'hB80		// Upper 32 bits of CSR_ADDR_MCYCLE, RV32I only
`define CSR_ADDR_MINSTRETH	12'hB82		// Upper 32 bits of CSR_ADDR_MINSTRET, RV32I only

`define CSR_ADDR_MHPMCOUNTER3H	12'hB83		// Upper 32 bits of CSR_ADDR_MHPMCOUNTER3, RV32I only
`define CSR_ADDR_MHPMCOUNTER4H	12'hB84
`define CSR_ADDR_MHPMCOUNTER5H	12'hB85
`define CSR_ADDR_MHPMCOUNTER6H	12'hB86
`define CSR_ADDR_MHPMCOUNTER7H	12'hB87
`define CSR_ADDR_MHPMCOUNTER8H	12'hB88
`define CSR_ADDR_MHPMCOUNTER9H	12'hB89
`define CSR_ADDR_MHPMCOUNTER10H	12'hB8A
`define CSR_ADDR_MHPMCOUNTER11H	12'hB8B
`define CSR_ADDR_MHPMCOUNTER12H	12'hB8C
`define CSR_ADDR_MHPMCOUNTER13H	12'hB8D
`define CSR_ADDR_MHPMCOUNTER14H	12'hB8E
`define CSR_ADDR_MHPMCOUNTER15H	12'hB8F
`define CSR_ADDR_MHPMCOUNTER16H	12'hB90
`define CSR_ADDR_MHPMCOUNTER17H	12'hB91
`define CSR_ADDR_MHPMCOUNTER18H	12'hB92
`define CSR_ADDR_MHPMCOUNTER19H	12'hB93
`define CSR_ADDR_MHPMCOUNTER20H	12'hB94
`define CSR_ADDR_MHPMCOUNTER21H	12'hB95
`define CSR_ADDR_MHPMCOUNTER22H	12'hB96
`define CSR_ADDR_MHPMCOUNTER23H	12'hB97
`define CSR_ADDR_MHPMCOUNTER24H	12'hB98
`define CSR_ADDR_MHPMCOUNTER25H	12'hB99
`define CSR_ADDR_MHPMCOUNTER26H	12'hB9A
`define CSR_ADDR_MHPMCOUNTER27H	12'hB9B
`define CSR_ADDR_MHPMCOUNTER28H	12'hB9C
`define CSR_ADDR_MHPMCOUNTER29H	12'hB9D
`define CSR_ADDR_MHPMCOUNTER30H	12'hB9E
`define CSR_ADDR_MHPMCOUNTER31H	12'hB9F

// =============================================
// ==    Machine Counter Setup		       =
// =============================================

`define CSR_ADDR_MHPMEVENT3	12'h323		// Machine performance-monitoring event selector
`define CSR_ADDR_MHPMEVENT4	12'h324
`define CSR_ADDR_MHPMEVENT5	12'h325
`define CSR_ADDR_MHPMEVENT6	12'h326
`define CSR_ADDR_MHPMEVENT7	12'h327
`define CSR_ADDR_MHPMEVENT8	12'h328
`define CSR_ADDR_MHPMEVENT9	12'h329
`define CSR_ADDR_MHPMEVENT10	12'h32A
`define CSR_ADDR_MHPMEVENT11	12'h32B
`define CSR_ADDR_MHPMEVENT12	12'h32C
`define CSR_ADDR_MHPMEVENT13	12'h32D
`define CSR_ADDR_MHPMEVENT14	12'h32E
`define CSR_ADDR_MHPMEVENT15	12'h32F
`define CSR_ADDR_MHPMEVENT16	12'h330
`define CSR_ADDR_MHPMEVENT17	12'h331
`define CSR_ADDR_MHPMEVENT18	12'h332
`define CSR_ADDR_MHPMEVENT19	12'h333
`define CSR_ADDR_MHPMEVENT20	12'h334
`define CSR_ADDR_MHPMEVENT21	12'h335
`define CSR_ADDR_MHPMEVENT22	12'h336
`define CSR_ADDR_MHPMEVENT23	12'h337
`define CSR_ADDR_MHPMEVENT24	12'h338
`define CSR_ADDR_MHPMEVENT25	12'h339
`define CSR_ADDR_MHPMEVENT26	12'h33A
`define CSR_ADDR_MHPMEVENT27	12'h33B
`define CSR_ADDR_MHPMEVENT28	12'h33C
`define CSR_ADDR_MHPMEVENT29	12'h33D
`define CSR_ADDR_MHPMEVENT30	12'h33E
`define CSR_ADDR_MHPMEVENT31	12'h33F

// =============================================
// ==    Debug/Trace Registers		       =
// =============================================

`define CSR_ADDR_TSELECT	12'h7A0		// Debug/Trace trigger register select
`define CSR_ADDR_TDATA1		12'h7A1		// First Debug/Trace trigger data register
`define CSR_ADDR_TDATA2		12'h7A2		// Second Debug/Trace trigger data register
`define CSR_ADDR_TDATA3		12'h7A3		// Third Debug/Trace trigger data register

// =============================================
// ==    Debug Mode Registers		       =
// =============================================

`define CSR_ADDR_DCSR		12'h7B0		// Debug control and status register
`define CSR_ADDR_DPC		12'h7B1		// Debug PC
`define CSR_ADDR_DSCRATCH0	12'h7B2		// Debug scratch register

// ===========================================================================================
// ===========================================================================================

// ======================================================
// ==    Encoding of extensions in CSR_ADDR_MISA        =
// ======================================================

`define	MISA_ENC_A	26'b00000000000000000000000001	// Atomic extension
`define	MISA_ENC_B	26'b00000000000000000000000010	// Tentatively reserved for Bit operations extension
`define	MISA_ENC_C	26'b00000000000000000000000100	// Compressed extension
`define	MISA_ENC_D	26'b00000000000000000000001000	// Double-precision floating-point extension
`define	MISA_ENC_E	26'b00000000000000000000010000	// RV32E base ISA
`define	MISA_ENC_F	26'b00000000000000000000100000	// Single-precision floating-point extension
`define	MISA_ENC_G	26'b00000000000000000001000000	// Additional standard extensions present
`define	MISA_ENC_H	26'b00000000000000000010000000	// Reserved
`define	MISA_ENC_I	26'b00000000000000000100000000	// RV32I/ 64I/ 128I base ISA
`define	MISA_ENC_J	26'b00000000000000001000000000	// Tentatively reserved for Dynamically Translated Languages extension
`define	MISA_ENC_K	26'b00000000000000010000000000	// Reserved
`define	MISA_ENC_L	26'b00000000000000100000000000	// Tentatively reserved for Decimal Floating-Point extension
`define	MISA_ENC_M	26'b00000000000001000000000000	// Integer Multiply/Divide extension
`define	MISA_ENC_N	26'b00000000000010000000000000	// User-level interrupts supported
`define	MISA_ENC_O	26'b00000000000100000000000000	// Reserved
`define	MISA_ENC_P	26'b00000000001000000000000000	// Tentatively reserved for Packed-SIMD extension
`define	MISA_ENC_Q	26'b00000000010000000000000000	// Quad-precision floating-point extension
`define	MISA_ENC_R	26'b00000000100000000000000000	// Reserved
`define	MISA_ENC_S	26'b00000001000000000000000000	// Supervisor mode implemented
`define	MISA_ENC_T	26'b00000010000000000000000000	// Tentativel reserved for Transactional Memory extension
`define	MISA_ENC_U	26'b00000100000000000000000000	// User mode implemented
`define	MISA_ENC_V	26'b00001000000000000000000000	// Tentatively reserved for Vector extension
`define	MISA_ENC_W	26'b00010000000000000000000000	// Reserved
`define	MISA_ENC_X	26'b00100000000000000000000000	// Non-standard extensions present
`define	MISA_ENC_Y	26'b01000000000000000000000000	// Reserved
`define	MISA_ENC_Z	26'b10000000000000000000000000	// Reserved

// ======================================================
// ==    MCAUSE values after trap		        =
// ======================================================
`define MCAUSE_WIDTH			4

`define MCAUSE_SOFTWARE_INT_U		0
`define	MCAUSE_SOFTWARE_INT_S		1
`define	MCAUSE_SOFTWARE_INT_RESERVED	2
`define	MCAUSE_SOFTWARE_INT_M		3

`define MCAUSE_TIMER_INT_U		4
`define MCAUSE_TIMER_INT_S		5
`define	MCAUSE_TIMER_INT_RESERVED	6
`define	MCAUSE_TIMER_INT_M		7

`define	MCAUSE_EXT_INT_U		8
`define	MCAUSE_EXT_INT_S		9
`define MCAUSE_EXT_INT_RESERVED		10
`define	MCAUSE_EXT_INT_M		11

`define	MCAUSE_INT_RESERVED		12

`define MCAUSE_INST_ADDR_MISALIGNED		0
`define	MCAUSE_INST_ACCESS_FAULT		1
`define	MCAUSE_ILLEGAL_INST			2
`define	MCAUSE_BREAKPOINT			3
`define MCAUSE_LOAD_ADDR_MISALIGNED		4
`define MCAUSE_LOAD_ACCESS_FAULT		5
`define	MCAUSE_STORE_AMO_ADDR_MISALIGNED	6
`define MCAUSE_STORE_AMO_ACCESS_FAULT		7
`define	MCAUSE_ECALL_FROM_U			8
`define	MCAUSE_ECALL_FROM_S			9
`define MCAUSE_RESERVED_10			10
`define MCAUSE_ECALL_FROM_M			11
`define MCAUSE_INST_PAGE_FAULT			12
`define MCAUSE_LOAD_PAGE_FAULT			13
`define MCAUSE_RESERVED_14			14
`define MCAUSE_STORE_AMO_PAGE_FAULT		15
`define	MCAUSE_RESERVED_16			16

/* `define CSR_ADDR_MCPUID    12'hF00
`define CSR_ADDR_MIP       12'h344
`define CSR_ADDR_MTIMECMP  12'h321
`define CSR_ADDR_MTIME     12'h701
`define CSR_ADDR_MTIMEH    12'h741
`define CSR_ADDR_MBADADDR  12'h343
`define CSR_ADDR_MIP       12'h344
`define CSR_ADDR_CYCLEW    12'h900
`define CSR_ADDR_TIMEW     12'h901
`define CSR_ADDR_INSTRETW  12'h902
`define CSR_ADDR_CYCLEHW   12'h980
`define CSR_ADDR_TIMEHW    12'h981
`define CSR_ADDR_INSTRETHW 12'h982*/

`define CSR_CMD_WIDTH 3
`define CSR_IDLE      0
`define CSR_READ      4
`define CSR_WRITE     5
`define CSR_SET       6
`define CSR_CLEAR     7

/*`define ECODE_WIDTH                      4
`define ECODE_INST_ADDR_MISALIGNED       0
`define ECODE_INST_ADDR_FAULT            1
`define ECODE_ILLEGAL_INST               2
`define ECODE_BREAKPOINT                 3
`define ECODE_LOAD_ADDR_MISALIGNED       4
`define ECODE_LOAD_ACCESS_FAULT          5
`define ECODE_STORE_AMO_ADDR_MISALIGNED  6
`define ECODE_STORE_AMO_ACCESS_FAULT     7
`define ECODE_ECALL_FROM_U               8
`define ECODE_ECALL_FROM_S               9
`define ECODE_ECALL_FROM_H              10
`define ECODE_ECALL_FROM_M              11*/

`define ICODE_SOFTWARE 0
`define ICODE_TIMER    1

`define PRV_WIDTH     2
`define PRV_U         0
`define PRV_S         1
`define PRV_H         2
`define PRV_M         3
