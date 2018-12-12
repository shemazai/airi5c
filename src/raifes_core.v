//
// raifes_core
//
// RISC-V core including debug module, debug ROM and AHB-lite typ memory interface
//
// History: 
// 10.12.18 - beautified and updated comments (ASt)
//
// Notes:
// The core uses seperated instruction and data memory busses with an AHB-Lite 
// compatible interface (only basic AHB-Lite transfers are supported). Sometimes, 
// the two busses are combined into a single bus using an arbiter on the upper 
// hierachy level, because in order to load programs into the core via the debug 
// module, the core has to be able to write into instruction memory - which can 
// not be done using the "imem" bus.
//

// definitions for the AHB-Lite type memory interface (called HASTI here for historic reasons)
`include "raifes_hasti_constants.vh"

// constants from the control state machine, width of memory access, types of jump targets etc.
`include "raifes_ctrl_constants.vh"

// address map for the control and status register file (CSR) as defined in the 
// RISC-V ISA. These include basic status information, timers, cycle counters, 
// interrupt handling etc. and are separate from the general purpose register file (GPR)
`include "raifes_csr_addr_map.vh"

// mostly the memory map for the core, i.e. the address of the debug ROM and some special 
// places for the debug mode, the start address for the core, the address space for peripherals
// etc.
`include "raifes_platform_constants.vh"

// debug module interface (DMI) definitions
`include "raifes_dmi_constants.vh"

// RISC-V opcodes 
`include "rv32_opcodes.vh"

module raifes_core(

		   input			   reset,			// synchronous reset, 1 = reset, 0 = running
                   input 			   clk,				// main clock, positive edge logic

		   input [`N_EXT_INTS-1:0] 	   ext_interrupts,		// external interrupt sources, active high 

		  // AHB-Lite style system busses

                   // instruction memory bus	  
                   output [`HASTI_ADDR_WIDTH-1:0]  imem_haddr,			// memory address
                   output 			   imem_hwrite,			// unused, as imem bus is read-only
                   output [`HASTI_SIZE_WIDTH-1:0]  imem_hsize,			// width of memory access (1, 2 or 4 for byte, halfword and word access respectively)
                   output [`HASTI_BURST_WIDTH-1:0] imem_hburst,			// burst mode (TODO: not implemented yet)
                   output 			   imem_hmastlock,		// "master lock" (TODO: not implemented yet)
                   output [`HASTI_PROT_WIDTH-1:0]  imem_hprot,			// TODO: add description
                   output [`HASTI_TRANS_WIDTH-1:0] imem_htrans,			// TODO: add description
                   output [`HASTI_BUS_WIDTH-1:0]   imem_hwdata,			// unused, as imem bus is read-only
                   input [`HASTI_BUS_WIDTH-1:0]    imem_hrdata,			// read data from instruction memory
                   input 			   imem_hready,			// busy/ready signaling (1 - ready, 0 - busy)
                   input [`HASTI_RESP_WIDTH-1:0]   imem_hresp,			// error code / response from memory

                   // data memory bus
                   output [`HASTI_ADDR_WIDTH-1:0]  dmem_haddr,
                   output 			   dmem_hwrite,
                   output [`HASTI_SIZE_WIDTH-1:0]  dmem_hsize,
                   output [`HASTI_BURST_WIDTH-1:0] dmem_hburst,
                   output 			   dmem_hmastlock,
                   output [`HASTI_PROT_WIDTH-1:0]  dmem_hprot,
                   output [`HASTI_TRANS_WIDTH-1:0] dmem_htrans,
                   output [`HASTI_BUS_WIDTH-1:0]   dmem_hwdata,			// data to be written into memory
                   input [`HASTI_BUS_WIDTH-1:0]    dmem_hrdata,
                   input 			   dmem_hready,
                   input [`HASTI_RESP_WIDTH-1:0]   dmem_hresp,


		 // Debug Module Interface (DMI) bus. 
		 // 
		 // This connects the Debug Module (DM) included in this core
		 // with an external Debug Transport Module (DTM), which 
		 // in our case is a JTAG-TAP.
		 // 
		 // The DTM uses the DMI to access registers in the DM,
		 // thereby performing debug operations.
		 // 
	  	 // There can be other types of DTMs on the DMI bus, for example 
		 // one could use an RS232 transceiver for debugging, the interface 
		 // to the debug module would still be the same DMI.

		 // DM register address
		 input [`DMI_ADDR_WIDTH-1:0]	   dmi_addr,
		 // DM (read/write) enable
		 input			   	   dmi_en,
		 // Data read from DM to the DTM
		 output [`DMI_WIDTH-1:0]	   dmi_rdata,
		 // Data from the DTM to the DM
		 input [`DMI_WIDTH-1:0]	   	   dmi_wdata,
	 	 // DM write enable (always together with dmi_en)
		 input			   	   dmi_wen,
		 // DM error signaling, should be 1'b0 if no error occured
		 output			   	   dmi_error,
		 // DM busy signaling, if the DM needs more time, it can set 
		 // this flag. Usually, the DM is clocked much faster (system clock)
		 // than the DTM (external JTAG clock), so this is never required.
		 output			   	   dmi_dm_busy,

		 // Debug Signals for core debugging. These are connected to some 
		 // internal signals of the core for debugging in simulation or on an 
		 // FPGA pin. Often this are the 4 bits of the current FSM state of 
		 // the debug module. CAUTION: IMPLEMENTATION / MEANING MIGHT CHANGE FREQUENTLY
		 output		[3:0]	dm_state
                );

   wire 					   ndmreset;		// non-debug-module reset, resets everything besides the DM.
   assign 					   ndmreset = reset;	// TODO: for now, this is equal to the system reset.
 
   // System bus signals translated from the AHB-Lite signals
   wire                                            imem_wait_mem;
   wire [`HASTI_ADDR_WIDTH-1:0]                    imem_addr;
   wire [`HASTI_BUS_WIDTH-1:0]                     imem_rdata;	
   wire                                            imem_badmem_e;
   wire						   imem_stall;

   wire                                            dmem_wait_mem;
   wire                                            dmem_en;
   wire                                            dmem_wen;
   
   // dmem_wen can target some register in the debug module or a 
   // regular memory address. The external write enable is only 
   // assigned when the target address within the "normal" memory 
   // space (see raifes_platform_constants.vh)
   wire						   dmem_wen_extern;	
   wire [`HASTI_SIZE_WIDTH-1:0]                    dmem_size;
   wire [`HASTI_ADDR_WIDTH-1:0]                    dmem_addr;
   wire [`HASTI_BUS_WIDTH-1:0]                     dmem_wdata_delayed;
   wire [`HASTI_BUS_WIDTH-1:0]                     dmem_rdata_hasti;
   reg [`HASTI_BUS_WIDTH-1:0]                      dmem_rdata;

   wire                                            dmem_badmem_e;
	

   wire [`DMI_WIDTH-1:0]			dm_regfile_rd;
   wire [`DMI_WIDTH-1:0]			dm_regfile_wd;
   wire 					dm_regfile_wen;
   wire [`REG_ADDR_WIDTH-1:0]			dm_regfile_wara;

   wire [`CSR_ADDR_WIDTH-1:0]			dm_csr_addr;
   wire [`CSR_CMD_WIDTH-1:0]			dm_csr_cmd;
   wire [`XPR_LEN-1:0]				dm_csr_rdata;
   wire [`XPR_LEN-1:0]				dm_csr_wdata;

   wire						dm_hart0_haltreq;
   wire						dm_hart0_resumereq;
	
   wire [`XPR_LEN-1:0]				dm_hart0_progbuf0;
   wire [`XPR_LEN-1:0]				dm_hart0_progbuf1;
	
   wire						dm_hart0_halted;	


   reg [`XPR_LEN-1:0]				imem_rdata_muxed;
   reg [`XPR_LEN-1:0]				dmem_rdata_muxed;
	
	wire	[3:0]	dm_debug;

   raifes_hasti_bridge imem_bridge(
 				  .clk(clk),
				  .reset(reset),
                                   .haddr(imem_haddr),
                                   .hwrite(imem_hwrite),
                                   .hsize(imem_hsize),
                                   .hburst(imem_hburst),
                                   .hmastlock(imem_hmastlock),
                                   .hprot(imem_hprot),
                                   .htrans(imem_htrans),
                                   .hwdata(imem_hwdata),
                                   .hrdata(imem_hrdata),
                                   .hready(imem_hready),
                                   .hresp(imem_hresp),
                                   .core_mem_en(~imem_stall),
                                   .core_mem_wen(1'b0),
                                   .core_mem_size(`HASTI_SIZE_WORD),
                                   .core_mem_addr(imem_addr),
                                   .core_mem_wdata_delayed(32'b0),
                                   .core_mem_rdata(imem_rdata),
                                   .core_mem_wait(imem_wait_mem),
                                   .core_badmem_e(imem_badmem_e)
                                   );
											  
   raifes_hasti_bridge dmem_bridge(
				  .clk(clk),
				  .reset(reset),
                                   .haddr(dmem_haddr),
                                   .hwrite(dmem_hwrite),
                                   .hsize(dmem_hsize),
                                   .hburst(dmem_hburst),
                                   .hmastlock(dmem_hmastlock),
                                   .hprot(dmem_hprot),
                                   .htrans(dmem_htrans),
                                   .hwdata(dmem_hwdata),
                                   .hrdata(dmem_hrdata),
                                   .hready(dmem_hready),
                                   .hresp(dmem_hresp),
                                   .core_mem_en(dmem_en),
                                   .core_mem_wen(dmem_wen_extern),
                                   .core_mem_size(dmem_size),
                                   .core_mem_addr(dmem_addr),
                                   .core_mem_wdata_delayed(dmem_wdata_delayed),
                                   .core_mem_rdata(dmem_rdata_hasti),
                                   .core_mem_wait(dmem_wait_mem),
                                   .core_badmem_e(dmem_badmem_e)
                                   );


	raifes_debug_module debug_module(	
					.reset(reset),
					.clk(clk),

					.dmi_addr(dmi_addr),
					.dmi_en(dmi_en),
					.dmi_error(dmi_error),
					.dmi_rdata(dmi_rdata),
					.dmi_wdata(dmi_wdata),
					.dmi_wen(dmi_wen),
					.dmi_dm_busy(dmi_dm_busy),

					.dm_regfile_wen(dm_regfile_wen),
					.dm_regfile_wara(dm_regfile_wara),
					.dm_regfile_rd(dm_regfile_rd),
					.dm_regfile_wd(dm_regfile_wd),
					
					.dm_hart0_haltreq(dm_hart0_haltreq),
					.dm_hart0_resumereq(dm_hart0_resumereq),
					.dm_hart0_halted(dm_hart0_halted),
					.dm_hart0_postexecreq(dm_hart0_postexecreq),
					.dm_hart0_resumeack(dm_hart0_resumeack),
					
					.dm_hart0_progbuf0(dm_hart0_progbuf0),
					.dm_hart0_progbuf1(dm_hart0_progbuf1),

					.dm_illegal_csr_access(dm_illegal_csr_access),
				 	.dm_csr_addr(dm_csr_addr),
					.dm_csr_cmd(dm_csr_cmd),
					.dm_csr_rdata(dm_csr_rdata),
					.dm_csr_wdata(dm_csr_wdata),
					.dm_state_out(dm_debug)					

				);
				
					

// ===========================================
// = Memory mapped debug registers           =
// ===========================================

// to allow access to debug information in debug mode using regular instructions, 
// a single debug_status register is memory mapped into dmem space.

reg	[`HASTI_ADDR_WIDTH-1:0]                 dmem_addr_r;					// addr hold register

reg	[1:0]					hart0_status_r;					// currently only single bit (Bit 0)
reg						hart0_postexecreq_r;
wire	[`XPR_LEN-1:0]				hart0_status;

assign dm_hart0_halted = hart0_status_r[0];
assign dm_hart0_resumeack = dm_hart0_resumereq;	// TODO: simple. doesn't really reflect if the hart has resumed, so better use --> //hart0_status_r[1];



assign hart0_status = {29'h0,hart0_postexecreq_r,dm_hart0_halted,dm_hart0_resumereq};

reg	[`XPR_LEN-1:0]				hart0_stack;

reg	dmem_wen_r;
//reg	dmem_en_r;

always @(posedge clk) begin
	if(ndmreset) begin
		dmem_addr_r <= 0;
		dmem_wen_r <= 0;
//		dmem_en_r <= 0;
	end else begin
		dmem_addr_r <= dmem_addr;								// sample addr
		dmem_wen_r <= dmem_wen;
//		dmem_en_r <= dmem_en;
	end
end

assign	dmem_wen_extern = (dmem_wen & dmem_addr[`HASTI_ADDR_WIDTH-1]);

always @(posedge clk) // or posedge ndmreset
begin
	if(ndmreset) begin 
		hart0_status_r <= 1'b00;
		hart0_stack <= `XPR_LEN'h0;
		hart0_postexecreq_r <= 1'b0;
	end else begin
		if(dm_hart0_postexecreq) begin
			hart0_postexecreq_r <= 1'b1;
		end else begin
			if(dmem_wen_r && (dmem_addr_r == `ADDR_HART0_POSTEXEC)) hart0_postexecreq_r <= 1'b0;
		end

		if(dmem_wen_r) begin
			case(dmem_addr_r)
				`ADDR_HART0_STATUS : hart0_status_r <= {dmem_wdata_delayed[0],dmem_wdata_delayed[1]};	// TODO: twisted, WHY? this has some meaning!
				`ADDR_HART0_STACK  : hart0_stack <= dmem_wdata_delayed;
			endcase
		end		
	end
end


// ===========================================
// = Debug-ROM + Debug Program Buffer        =
// ===========================================

wire	[`XPR_LEN-1:0]	dm_debugrom [16:0];	// debug ROM has 256 lines 
assign	dm_debugrom[0] = `XPR_LEN'h14802023;	// 0001 0100 1000 0000 0010 0000 0010 0011, 14802023, sw s0, 0x140(x0) -- push s0 to debug mem space 0x140
assign	dm_debugrom[1] = `XPR_LEN'h14402E03;	// 0001 0100 0100 0000 0010 1110 0000 0011, 14402E03, lw s28, 0x144(x0) -- read hart0_status from @0x144

assign	dm_debugrom[2] = `XPR_LEN'h001E7E13;	// 0000 0000 0001 1110 0111 1110 0001 0011, 001E7E13, andi s28, 0x01 -- determine if resume is requested
assign	dm_debugrom[3] = `XPR_LEN'h01C01E63;	// 0000 0001 1100 0000 0001 1110 0110 0011, 0101E63, bne s28, x0, d28(pc)
assign	dm_debugrom[4] = `XPR_LEN'h14402E03;	// lw s28, 0x144(x0) -- read hart0_status again.
assign	dm_debugrom[5] = `XPR_LEN'h002E6E13;	// 0000 0000 0010 1110 0110 1110 0001 0011, 002E6E13, ori s28, 0x02 -- set halted_flag
assign	dm_debugrom[6] = `XPR_LEN'h15C02223;	// 0001 0101 1100 0000 0010 0010 0010 0011, 15C02223, sw s28, 0x144(x0) -- and store status
assign	dm_debugrom[7] = `XPR_LEN'h004E7E13;	// 0000 0000 0100 1110 0111 1110 0001 0011, 004E7E13, andi s28, 0x04 -- check for exec

assign	dm_debugrom[8] = `XPR_LEN'h01C01A63;    // 0000 0001 1100 0000 0001 1010 0110 0011, 01C01A63, bne s28, x0, 20(pc)
assign	dm_debugrom[9] = `XPR_LEN'hFE1FF06F;	// 1111 1110 0001 1111 1111 0000 0110 1111, FE1FF06F, j x0, -20 -- jump back to rw s0, 36(x0) ...
assign  dm_debugrom[10] = `XPR_LEN'h14402403;	// 0001 0100 0000 0000 0010 0100 0000 0011, 14402403, lw s0, 0x140(x0) -- pop s0 from "stack"
assign	dm_debugrom[11] = `XPR_LEN'h14002223;	// 0001 0100 0000 0000 0010 0010 0010 0011, 14002223, sw x0, 0x144(x0) -- clear all status flags
assign	dm_debugrom[12] = `XPR_LEN'h7b200073;	// DRET
assign	dm_debugrom[13] = `XPR_LEN'h14002423;	// 0001 0100 0000 0000 0010 0100 0010 0011, 14002423, sw x0, 0x148(x0) -- clear postexec request 

assign	dm_debugrom[14] = dm_hart0_progbuf0;	// first progbuf line, the debugger writes this to execute arbitrary commands
assign	dm_debugrom[15] = dm_hart0_progbuf1;	// second progbuf line, the debugger writes this to execute arbitrary commands

assign  dm_debugrom[16] = `XPR_LEN'h00100073;  // 0000 0000 0001 0000 0000 0000 0111 0011, 00100073, EBREAK	implicit ebreak at end of progbuf.

// Stack = 0x...40		Address used to access the one-line stack, which holds interrupt enable information for different priviledge levels
// Status = 0x...44	        Address used to signal status of the hard (running, halted)
// Poesexec = 0x...48		Address used to clear the posexecreq flag



// Memory Access to Debug ROM
// ==========================

// AHB-Lite provide the data in the clock cycle after the address has been 
// sampled. To mimic this behaviour, the multiplexer samples the address and 
// provides output data based on the address present in the hold register.

reg [`HASTI_ADDR_WIDTH-1:0]                    imem_addr_r;					// addr hold register

always @(posedge clk) begin
	if(ndmreset) begin 
		imem_addr_r <= 32'h00000000;
	end else begin
		imem_addr_r <= imem_addr;							// sample addr from core
	end
end

// Instruction address decoder for debug ROM
wire	[`XPR_LEN-1:0]	imem_rdata_debug; assign imem_rdata_debug = dm_debugrom[imem_addr_r[9:0] >> 2];

// Instruction MUX between debug ROM and regular memory
always @* begin
	case(imem_addr_r[`HASTI_ADDR_WIDTH-1])
	`ADDR_DEBUG_ROM 	: imem_rdata_muxed = imem_rdata_debug;
	`ADDR_IMEM		: imem_rdata_muxed = imem_rdata;
	default 		: imem_rdata_muxed = `XPR_LEN'h0;
	endcase
end

wire imem_wait_muxed; assign	imem_wait_muxed =  (imem_addr_r[`HASTI_ADDR_WIDTH-1] == `ADDR_DEBUG_ROM) ? 1'b0 : imem_wait_mem;

// Data Address decoder for debug ROM
wire [`XPR_LEN-1:0]	dmem_rdata_debug; assign dmem_rdata_debug = dm_debugrom[dmem_addr_r[9:0] >> 2];

// Data MUX between debug ROM and regular memory (and special places within debug rom)
always @* begin
	case(dmem_addr_r[`HASTI_ADDR_WIDTH-1])
		`ADDR_DEBUG_ROM 	 : begin 
						dmem_rdata = (dmem_addr_r == `ADDR_HART0_STATUS) ? hart0_status :	// either status..
							     (dmem_addr_r == `ADDR_HART0_STACK) ? hart0_stack : 	// .. or stack ..
							     dmem_rdata_debug;						// .. or some other debug addr.
					   end
		`ADDR_IMEM		 : dmem_rdata = dmem_rdata_hasti;
		default			 : dmem_rdata = `XPR_LEN'hbabebabe;
	endcase
end

wire dmem_wait_muxed; assign	dmem_wait_muxed =  (dmem_addr_r[`HASTI_ADDR_WIDTH-1] == `ADDR_DEBUG_ROM) ? 1'b0 : dmem_wait_mem;

// ===================================================
// = Core Pipeline				     =
// ===================================================
//
// The pipeline module includes the computational core. 
// It consists of IF/DE, EX, WB stages, control logic, 
// general purpose register file, control/status register 
// file and exception handling.



   raifes_pipeline pipeline(
		.clk(clk),
		.ext_interrupts(ext_interrupts),			// External interrrupt sources, active high
		.debug_haltreq(dm_hart0_haltreq),			// haltreq is a special interrupt which 
									// causes a jump into debug ROM on the next 
									// cycle.
		.reset(ndmreset),

		// Instruction memory interface to 
		// IF stage
		.imem_wait(imem_wait_muxed),
               	.imem_addr(imem_addr),
               	.imem_rdata(imem_rdata_muxed),
	        .imem_stall(imem_stall),
               	.imem_badmem_e(1'b0),

		// Data memory interface from/to 
		// WB stage
               .dmem_wait(dmem_wait_muxed),
               .dmem_en(dmem_en),
               .dmem_wen(dmem_wen),
               .dmem_size(dmem_size),
               .dmem_addr(dmem_addr),
               .dmem_wdata_delayed(dmem_wdata_delayed),
               .dmem_rdata(dmem_rdata),
               .dmem_badmem_e(1'b0),					// TODO! detect and signal memory failures
									// handler already exists in the control logic

		// Debug Module Register File Access
		// The Debug Module (DM) can access the 
		// register file via a separate port. 
		// It has priority over core accesses to 
		// the regfile.
		.dm_wen(dm_regfile_wen),				// write enable, active high
		.dm_wara(dm_regfile_wara),				// write/read address
		.dm_rd(dm_regfile_rd),					// data regfile -> DM
		.dm_wd(dm_regfile_wd),					// data DM -> regfile


		// Debug Module CSR access
		.dm_csr_cmd(dm_csr_cmd),				// command. read = 0, write = >0, TODO: genauer aufschlüsseln
		.dm_csr_addr(dm_csr_addr),				// register address
		.dm_csr_rdata(dm_csr_rdata),				// data CSR -> DM
		.dm_csr_wdata(dm_csr_wdata),				// data DM -> CSR
		.dm_illegal_csr_access(dm_illegal_csr_access)		// signal illegal address to DM
									// This is actually used by debuggers to differentiate 
									// e.g. between 32/64 Bit implementations

);


assign dm_state = 4'h0;

endmodule // raifes_core

