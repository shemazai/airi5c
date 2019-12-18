//
// raifes_core
//
// RISC-V core including debug module, debug ROM and AHB-lite typ memory interface
//
// History: 
// 22.08.19 - moved debug rom to its own module
//	    - removed legacy hacks and twirks
//	    - added more comments
//	    - fixed error in debug ROM code (wrong register stored to hw stack now fixed)
// 10.12.18 - beautified and updated comments (ASt)
//
// Notes:
// The core uses seperate instruction and data memory busses with an AHB-Lite 
// compatible interface (only basic AHB-Lite transfers are supported). Sometimes, 
// the two busses are combined into a single bus using an arbiter on the upper 
// hierachy level, because in order to load programs into the core via the debug 
// module, the core has to be able to write into instruction memory - which can 
// not be done using the "imem" bus.
//

`include "raifes_arch_options.vh"

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
                   output [`HASTI_ADDR_WIDTH-1:0]  imem_haddr,			// I-Memory address
                   output 			   imem_hwrite,			// currently unused, as imem bus is read-only
                   output [`HASTI_SIZE_WIDTH-1:0]  imem_hsize,			// width of memory access (1, 2 or 4 for byte, halfword and word access respectively)
                   output [`HASTI_BURST_WIDTH-1:0] imem_hburst,			// burst mode (TODO: not implemented yet)
                   output 			   imem_hmastlock,		// "master lock" (TODO: not implemented yet)
                   output [`HASTI_PROT_WIDTH-1:0]  imem_hprot,			// TODO: add description
                   output [`HASTI_TRANS_WIDTH-1:0] imem_htrans,			// transaction mode.!= 0 if transaction is active. TODO: add details
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
		 // to an external Debug Transport Module (DTM), which 
		 // in our case is a JTAG-TAP.
		 // 
		 // The DTM uses the DMI to access registers in the DM,
		 // thereby performing debug operations.
		 // 
	  	 // There can be other types of DTMs on the DMI bus, for example 
		 // one could use an RS232 transceiver for debugging, the interface 
		 // to the debug module would still be the same DMI.

		 input [`DMI_ADDR_WIDTH-1:0]	   dmi_addr,			 // DM register address
		 input			   	   dmi_en,			 // DM (read/write) enable
		 output [`DMI_WIDTH-1:0]	   dmi_rdata,		 	 // Data read from DM to the DTM
		 input [`DMI_WIDTH-1:0]	   	   dmi_wdata,		 	 // Data from the DTM to the DM
		 input			   	   dmi_wen,		 	 // DM write enable (always together with dmi_en)
		 output			   	   dmi_error,			 // DM error signaling, should be 1'b0 if no error occured
		 // DM busy signaling, if the DM needs more time, it can set 
		 // this flag. Usually, the DM is clocked much faster (system clock)
		 // than the DTM (external JTAG clock), so this is never required.
		 output			   	   dmi_dm_busy
                );

   wire 					   ndmreset;		// non-debug-module reset, resets everything besides the DM.
   assign 					   ndmreset = reset;	// TODO: for now, this is equal to the system reset.
 
   // System bus signals (to core) translated from the AHB-Lite signals
   wire                                            imem_wait_mem;	// stall pipeline, memory is not yet ready
   wire [`HASTI_ADDR_WIDTH-1:0]                    imem_addr;		// imem address
   wire [`HASTI_BUS_WIDTH-1:0]                     imem_rdata;	
   wire                                            imem_badmem_e;	// TODO: unused. Signals access fault
   wire						   imem_stall;

   wire                                            dmem_wait_mem;
   wire                                            dmem_en;
   wire                                            dmem_wen;
   
   // writes to dmem can target some address in the debug space or a 
   // regular d-memory address. The external write enable is only 
   // assigned when the target address within the "normal" memory 
   // space (see raifes_platform_constants.vh for memory mapping)
   wire						   dmem_wen_extern;	
   wire [`HASTI_SIZE_WIDTH-1:0]                    dmem_size;
   wire [`HASTI_ADDR_WIDTH-1:0]                    dmem_addr;
   wire [`HASTI_BUS_WIDTH-1:0]                     dmem_wdata_delayed;
   wire [`HASTI_BUS_WIDTH-1:0]                     dmem_rdata_hasti;
   reg [`HASTI_BUS_WIDTH-1:0]                      dmem_rdata;

   wire                                            dmem_badmem_e;
	

   // register file access from debug module
   // the debug module can read/write registers in the 
   // general purpose register (GPR) file and in the 
   // control and status register (CSR) file directly using
   // a separate port.

   wire [`DMI_WIDTH-1:0]			dm_regfile_rd;
   wire [`DMI_WIDTH-1:0]			dm_regfile_wd;
   wire 					dm_regfile_wen;
   wire [`REG_ADDR_WIDTH-1:0]			dm_regfile_wara;

   wire [`CSR_ADDR_WIDTH-1:0]			dm_csr_addr;
   wire [`CSR_CMD_WIDTH-1:0]			dm_csr_cmd;
   wire [`XPR_LEN-1:0]				dm_csr_rdata;
   wire [`XPR_LEN-1:0]				dm_csr_wdata;

   // run control for individual harts
   // the debug module controls individual cores/harts 
   // using a set of request / status indiction lines.
   // within the debug module, there are mechanisms to 
   // select the group of targeted cores. On this hierarchy level, 
   // a set of control lines needs to be provided for each hart.
   //
   // the current implementation is single-core, so only one set 
   // of control lines is provided.

   wire						dm_hart0_haltreq;	// requests the hart to halt and enter debug loop
   wire						dm_hart0_resumereq;	// requests the hart to resume opertion at last PC
   wire						dm_hart0_resumeack;	// acknowledges the hart has resumed.
	
   wire [`XPR_LEN-1:0]				dm_hart0_progbuf0;	// two-instruction-program-buffer that can be filled
   wire [`XPR_LEN-1:0]				dm_hart0_progbuf1;	// by the debugger with arbitrary commands. 
									// thereby the main pipeline is used to execute functions
									// like memory access in debug mode.

   wire						dm_hart0_postexecreq;	// requests the hart to execute the programm buffer.
	
   wire						dm_hart0_halted;	// signals the hart has sucessfully entered debug loop


   reg [`XPR_LEN-1:0]				imem_rdata_muxed;
   reg [`XPR_LEN-1:0]				dmem_rdata_muxed;
	
// ============================================================================================================================

// bus translation between pipeline-internal signals 
// and AHB-Lite compatible naming / encoding.

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
					.dm_state_out()					
				);

// ============================================================================================================================

// =============================================================
// = Memory mapped debug registers, Debug-ROM + Program Buffer =
// =============================================================

reg	[`HASTI_ADDR_WIDTH-1:0]                 dmem_addr_r;	// addr hold register
reg						dmem_wen_r;	// write enable hold register

always @(posedge clk) begin
	if(ndmreset) begin
		dmem_addr_r <= 0;
		dmem_wen_r <= 0;
	end else begin
		dmem_addr_r <= dmem_addr;			// sample addr
		dmem_wen_r <= dmem_wen;
	end
end

assign	dmem_wen_extern = (dmem_wen & dmem_addr[`HASTI_ADDR_WIDTH-1]);


// ===========================================
// = Debug-ROM + Debug Program Buffer        =
// ===========================================

reg [`HASTI_ADDR_WIDTH-1:0]                    imem_addr_r;					// addr hold register

wire	[`XPR_LEN-1:0]	imem_rdata_debug; 
wire	[`XPR_LEN-1:0]	dmem_rdata_debug;

raifes_debug_rom debug_rom(
	.reset(ndmreset),
	.clk(clk),
	.postexec_req(dm_hart0_postexecreq),
	.resume_req(dm_hart0_resumereq),
	.halted(dm_hart0_halted),
	.resume_ack(dm_hart0_resumeack),
	.rom_addra(imem_addr_r),
	.rom_rdataa(imem_rdata_debug),
	.progbuf0(dm_hart0_progbuf0),
	.progbuf1(dm_hart0_progbuf1),
	.rom_addrb(dmem_addr_r),
	.rom_writeb(dmem_wen_r),
	.rom_rdatab(dmem_rdata_debug),
	.rom_wdatab(dmem_wdata_delayed)
);

// Memory Access to Debug ROM
// ==========================

// AHB-Lite provide the data in the clock cycle after the address has been 
// sampled. To mimic this behaviour, the multiplexer samples the address and 
// muxes output from debug rom or real memory based on the address stored in the hold register.

always @(posedge clk) begin
	if(ndmreset) begin 
		imem_addr_r <= 32'h00000000;
	end else begin
		imem_addr_r <= imem_addr;							// sample addr from core
	end
end

// Instruction MUX between debug ROM and regular memory
always @* begin
	case(imem_addr_r[`HASTI_ADDR_WIDTH-1])
		`ADDR_DEBUG_ROM 	: imem_rdata_muxed = imem_rdata_debug;
		`ADDR_IMEM		: imem_rdata_muxed = imem_rdata;
		default 		: imem_rdata_muxed = `XPR_LEN'hdeadbeef;
	endcase
end

wire imem_wait_muxed; assign	imem_wait_muxed =  (imem_addr_r[`HASTI_ADDR_WIDTH-1] == `ADDR_DEBUG_ROM) ? 1'b0 : imem_wait_mem;


// Data MUX between debug ROM and regular memory (and special places within debug rom)
always @* begin
	case(dmem_addr_r[`HASTI_ADDR_WIDTH-1])
		`ADDR_DEBUG_ROM 	 : dmem_rdata = dmem_rdata_debug;
		`ADDR_IMEM		 : dmem_rdata = dmem_rdata_hasti;
		default			 : dmem_rdata = `XPR_LEN'hbabebabe;
	endcase
end

wire dmem_wait_muxed; assign	dmem_wait_muxed =  (dmem_addr_r[`HASTI_ADDR_WIDTH-1] == `ADDR_DEBUG_ROM) ? 1'b0 : dmem_wait_mem;


// ===================================================
// = Coprocessors				     =
// ===================================================

wire				pcpi_valid;
wire	[`XPR_LEN-1:0]		pcpi_insn;
wire	[`XPR_LEN-1:0]		pcpi_rs1;
wire	[`XPR_LEN-1:0]		pcpi_rs2;
wire				pcpi_wr;			// unused - assumes to always write a result. 
wire	[`XPR_LEN-1:0] 		pcpi_rd;
wire        			pcpi_wait;			// unused
wire         			pcpi_ready;


// =====================================
// = M-Extension (Hardware MUL/DIV/REM =
// =====================================

`ifdef ISA_EXT_M
wire				pcpi_wr_mul_div;
wire	[`XPR_LEN-1:0]		pcpi_rd_mul_div;
wire				pcpi_wait_mul_div;
wire				pcpi_ready_mul_div;

raifes_mul_div	mul_div(
			.reset(ndmreset),
			.clk(clk),
		
			.pcpi_valid(pcpi_valid),
			.pcpi_insn(pcpi_insn),
			.pcpi_rs1(pcpi_rs1),
			.pcpi_rs2(pcpi_rs2),
			.pcpi_wr(pcpi_wr_mul_div),
			.pcpi_rd(pcpi_rd_mul_div),
			.pcpi_wait(pcpi_wait_mul_div),
			.pcpi_ready(pcpi_ready_mul_div)
);
`endif

// =====================================
// = XCRYPTO-Extension 		       =
// =====================================

`ifdef ISA_EXT_XCRYPTO  

wire                pcpi_wr_cop;
wire [31:0]         pcpi_rd_cop;
wire                pcpi_wait_cop;
wire                pcpi_ready_cop;

wire                                       cop_insn_ack;
wire                                       cpu_insn_req;
wire [31:0]                                cpu_rs1;
wire [31:0]                                cpu_rs2;
wire                                       cop_wen;
wire [4:0]                                 cop_waddr;
wire [31:0]                                cop_wdata;
wire [2:0]                                 cop_result;
wire                                       cop_insn_rsp;
wire                                       cpu_insn_ack;
wire [31:0]                                cpu_insn_enc;


integ_raifes_rcpi2cop rcpi(
           .clk             (clk),
           .reset           (reset),
         // Raifes Co-Processor Interface (RCPI)
           .rcpi_valid     (pcpi_valid),
           .rcpi_insn      (pcpi_insn),
           .rcpi_rs1       (pcpi_rs1),
           .rcpi_rs2       (pcpi_rs2),
           .rcpi_wr        (pcpi_wr_cop),
           .rcpi_rd        (pcpi_rd_cop),
           .rcpi_wait      (pcpi_wait_cop),
           .rcpi_ready     (pcpi_ready_cop),               
                // XCrypto Co-Processor Interface
           .cpu_insn_req   (cpu_insn_req), // Instruction request
           .cop_insn_ack   (cop_insn_ack), // Instruction request acknowledge
           .cpu_insn_enc   (cpu_insn_enc), // Encoded instruction data
           .cpu_rs1        (cpu_rs1), // RS1 source data
           .cpu_rs2        (cpu_rs2), // RS2 source data

           .cop_wen        (cop_wen), // COP write enable
           .cop_waddr      (cop_waddr), // COP destination register address
           .cop_wdata      (cop_wdata), // COP write data
           .cop_result     (cop_result), // COP execution result
           .cop_insn_rsp   (cop_insn_rsp), // COP instruction finished
           .cpu_insn_ack   (cpu_insn_ack)    // Instruction finish acknowledge

            );
 
raifes_cop_top  cop(
.g_clk        (clk        ) , // Global clock
.g_resetn     (reset      ) , // Synchronous active low reset.
//.g_clk_req    (g_clk_req  ) , 
.cpu_insn_req (cpu_insn_req ) , // Instruction request
.cop_insn_ack (cop_insn_ack ) , // Instruction request acknowledge
.cpu_insn_enc (cpu_insn_enc ) , // Encoded instruction data
.cpu_rs1      (cpu_rs1      ) , // RS1 source data
.cpu_rs2      (cpu_rs2      ) , // RS2 source data
.cop_wen      (cop_wen      ) , // COP write enable
.cop_waddr    (cop_waddr    ) , // COP destination register address
.cop_wdata    (cop_wdata    ) ,// COP write data
.cop_result   (cop_result   ) , // COP execution result
.cop_insn_rsp (cop_insn_rsp ) , // COP instruction finished
.cpu_insn_ack (cpu_insn_ack ) // Instruction finish acknowledge
);   
`endif 

// Multiplex the various coprocessor results here

assign	pcpi_wr = 
`ifdef ISA_EXT_M
pcpi_ready_mul_div ? pcpi_wr_mul_div : 
`endif
`ifdef ISA_EXT_XCRYPTO
pcpi_wr_cop ? pcpi_wr_cop : 
`endif 1'b0;

assign	pcpi_rd = 
`ifdef ISA_EXT_M 
pcpi_ready_mul_div ? pcpi_rd_mul_div : 
`endif
`ifdef ISA_EXT_XCRYPTO
pcpi_ready_cop ? pcpi_rd_cop : 
`endif 32'hdeadbeef;

assign	pcpi_wait = 1'b0
`ifdef ISA_EXT_M 
| pcpi_wait_mul_div 
`endif
`ifdef ISA_EXT_XCRYPTO
| pcpi_wait_cop
`endif;

assign	pcpi_ready =  1'b0
`ifdef ISA_EXT_M
| pcpi_ready_mul_div 
`endif
`ifdef ISA_EXT_XCRYPTO
| pcpi_ready_cop
`endif;


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

		.dm_illegal_csr_access(dm_illegal_csr_access),		// signal illegal address to DM
									// This is actually used by debuggers to differentiate 
									// e.g. between 32/64 Bit implementations

		// PCPI coprocessor interface

		.pcpi_valid(pcpi_valid),
		.pcpi_insn(pcpi_insn),
		.pcpi_rs1(pcpi_rs1),
		.pcpi_rs2(pcpi_rs2),
		.pcpi_wr(pcpi_wr),			// unused - assumes to always write a result. 
		.pcpi_rd(pcpi_rd),
		.pcpi_wait(pcpi_wait),			// unused
		.pcpi_ready(pcpi_ready)

);


endmodule // raifes_core

