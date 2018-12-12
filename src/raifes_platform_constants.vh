`define N_EXT_INTS 24

`define ADDR_DEBUG_ROM 		1'b0
`define ADDR_IMEM		1'b1
`define ADDR_HART0_STATUS	`XPR_LEN'h00000144
`define ADDR_HART0_STACK	`XPR_LEN'h00000140
`define ADDR_HART0_POSTEXEC `XPR_LEN'h00000148


// Periphery Adress mappings

// 0x81000000 - 0x81ffffff

`define START_ADDRESS `XPR_LEN'h80000000
`define DEBUG_ADDRESS `XPR_LEN'h00000000

`define PER_ADDR_LCD	`HASTI_BUS_WIDTH'h81000000		// LCD Display control register and lines
`define PER_ADDR_HDMI	`HASTI_BUS_WIDTH'h81000004		// Chromtel HDMI chip control register / I2C interface
