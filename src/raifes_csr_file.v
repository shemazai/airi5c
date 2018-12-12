`include "rv32_opcodes.vh"						// include OPCODE definitions
`include "raifes_csr_addr_map.vh"					// include address definitions for CSR registers
`include "raifes_ctrl_constants.vh"
`include "raifes_platform_constants.vh"
`include "raifes_arch_options.vh"

module raifes_csr_file(
                       input 			    clk,		// system clock
		       input			    debug_haltreq,	// external debugger halt request
		       input [`N_EXT_INTS-1:0] 	    ext_interrupts, 	// external interrupt sources
                       input 			    reset,		// system reset
                       input [`CSR_ADDR_WIDTH-1:0]  addr,		// ctrl sets this address of the CSR register which is used in r/w operation
                       input [`CSR_CMD_WIDTH-1:0]   cmd,		// command can be IDLE, READ, WRITE or others, see raifes_csr_addr_map.vh
                       input [`XPR_LEN-1:0] 	    wdata,		// data to be written into CSR register
                       output wire [`PRV_WIDTH-1:0] prv,		// privilege level, see raifes_csr_addr_map.vh, e.g. MACHINE / USER / SUPERVISORill	
                       output 			    illegal_access,	// signals access to undefined CSR registers or registers not accessible in current priv mode
		       output			    illegal_access_debug, // in debug mode only undefined CSR registers or write attempts to read-only regs are reported
                       output reg [`XPR_LEN-1:0]    rdata,		// data read from CSR register
                       input 			    retire,		// TODO
                       input 			    exception,		// Exception received (in EXEC/WB, or both? TODO)
                       input [`MCAUSE_WIDTH-1:0]    exception_code,	// the part of MCAUSE describing the exception
                       input 			    eret,		// MRET/URET or SRET in EXEC stage. We only implement MRET for M->U returns
                       input 			    dret,		
                       input [`XPR_LEN-1:0] 	    exception_load_addr,// TODO
                       input [`XPR_LEN-1:0] 	    exception_PC,	// PC of the instruction causing the exception (TODO: or the instruction after?)
                       output [`XPR_LEN-1:0] 	    handler_PC,		// The handler address set by MTVEC/STVEC/UTVEC and the defined mode. We only support one handler. 
                       output [`XPR_LEN-1:0] 	    epc,		// PC causing the exception (if exception) or pointer to instruction after (if interrupt)
                       output [`XPR_LEN-1:0] 	    dpc,		// PC causing the exception (if exception) or pointer to instruction after (if interrupt)
		       output 			    interrupt_pending,	// at least one interrupt is pending (but may be masked)
		       output reg 		    interrupt_taken,	// at least unmasked interrupt is pending and will be serviced now.

   	               input [`CSR_ADDR_WIDTH-1:0]  dm_csr_addr,		// CSR address
   		       input [`CSR_CMD_WIDTH-1:0]   dm_csr_cmd,			// CSR command (0 == IDLE)
		       input [`XPR_LEN-1:0]	    dm_csr_wdata,		// data to be written to CSR		
                       output reg [`XPR_LEN-1:0]    dm_csr_rdata		// data read from CSR 		

                       );

   // User Counter/Timer
`ifndef ISA_EXT_E
   reg [`CSR_COUNTER_WIDTH-1:0]                     cycle_full;		// Cycle counter, counts cycles since reset
   reg [`CSR_COUNTER_WIDTH-1:0]                     time_full;		// Wall-clock counter, should count cycles of a clock crystal.. TODO
   reg [`CSR_COUNTER_WIDTH-1:0]                     instret_full;	
`endif

//   reg [5:0]                                        priv_stack;		// The privilege stack storing info on previous priv mode on priv mode changes
   reg[1:0]					    mode;		// holds current operating mode
   reg						    dmode;		// debug mode is handled with separate bit

   reg [7:0]                                        priv_stack;		// 09.02.18, ASt: changed to reflect the V1.10 spec
   reg [`XPR_LEN-1:0]                               mtvec;		// Machine Trap Vector, sets jump target for traps in Machine privilege mode
   reg [`XPR_LEN-1:0] 				    mie;		// interrupt enable in machine mode.
   reg                                              mtip;
   reg                                              msip;
   reg [`XPR_LEN-1:0]                               mscratch;
   reg [`XPR_LEN-1:0]                               mepc;
   reg [`XPR_LEN-1:0]                               dpc_r;		
   assign dpc = dpc_r;
   reg [`XPR_LEN-1:0]                               dcsr;		// TODO: handle dcsr
   reg [`XPR_LEN-1:0]                               dscratch0;		// TODO: handle dscratch
   reg [`MCAUSE_WIDTH-1:0]                          mecode;
   reg                                              mint;
   reg [`XPR_LEN-1:0]                               mbadaddr;

   reg [`XPR_LEN-1:0]				    satp;


   wire                                             ie;

   wire [`XPR_LEN-1:0]                              mstatus;
   wire [`XPR_LEN-1:0]                              mip;
   wire [`XPR_LEN-1:0]                              mcause;
   

   wire                                             system_en;
   wire						    debug_en;
   wire                                             system_wen;
   wire						    debug_wen;
   wire                                             wen_internal;
   wire						    wen_internal_debug; 			// handle write requests from debug port separately
   wire                                             illegal_region;
   wire						    illegal_region_debug;
   reg                                              defined;
   reg						    defined_debug;
   reg [`XPR_LEN-1:0]                               wdata_internal;
   wire                                             uinterrupt;
   wire                                             minterrupt;
   wire						    dinterrupt;			// external Debug interrupt. Causing the hart to enter park loop.
   reg [`MCAUSE_WIDTH-1:0]                          interrupt_code;

   wire                                             code_imem;


   // MISA - set info on supported ISA
   wire [`XPR_LEN-1:0]				    misa;			// MISA stores information on supported ISA and ISA-Extensions
   assign misa = ({2'b01,`XPR_LEN-2'b0}) | `MISA_ENC_I | `MISA_ENC_U;		// current implementation supports RV32IU

   // MVENDORID - sets JEDEC manufacturer ID for the core
   wire [`XPR_LEN-1:0]				    mvendorid;
   assign mvendorid = `XPR_LEN'b0;

   // MARCHID - encodes base microarchitecture
   wire [`XPR_LEN-1:0]				    marchid;
   assign marchid = {1'b1,`XPR_LEN-1'h1};					// MSB must be 1 for commercial implementations, remaining bits must be differnt from 0. This is '1'

   // MIMPID - set Implementation ID
   wire [`XPR_LEN-1:0]                              mimpid;			// MIMPID stores unique ID for the Implementation
   assign mimpid = 32'h8000;							// set MSB to 1 for first version, following hint in spec, p.19.

   // MHARTID - hardware thread ID
   wire [`XPR_LEN-1:0]                              mhartid;			// MHARTID stores the ID of the individual hardware thread in a multi-core/multi-thread system
   assign mhartid = 0;								// single core / single thread implementation, so this is 0. Is checked by some of the test
									 	// programs supplied with riscv-tools, so better leave it like this.


   // trap handler vector calculation
   assign handler_PC = (dinterrupt || (exception_code == `MCAUSE_BREAKPOINT)) ? `DEBUG_ADDRESS : mtvec; 

   // fields of the MSTATUS register
   // assign prv = priv_stack[2:1];						// TODO: prv = WPRI,SIE - maybe the field ordering was different in previous specs, this is wierd.
   assign prv = mode;

   //assign ie = priv_stack[0];							// interrupt enable in User mode, refers to field "UIE" of MSTATUS.
   assign ie = priv_stack[prv];							// 09.02.18, ASt: now points to MIE, as we don't support User Mode Interrupts and in U-mode, 
										

   // CSR CMD decoding
/* assign system_en = cmd[2];							// All commands beside IDLE are encoded >= 4
   assign system_wen = cmd[1] || cmd[0];					// All non-IDLE commands other than 4 (READ) change some data and are hence WRITE-types, set write-enable.
   assign wen_internal = system_wen;						// the write might also come from some debug controller, so leave this to differentiate.*/

   assign system_en = cmd[2];
   assign debug_en = dm_csr_cmd[2];					
   assign system_wen = cmd[1] || cmd[0];
   assign debug_wen = dm_csr_cmd[1] || dm_csr_cmd[0]; 
   assign wen_internal = system_wen;
   assign wen_internal_debug = dm_csr_cmd[1] || dm_csr_cmd[0];

   // detect illegal access to CSR registers.
   // standard read-only CSR registers have MSBits == 11, a write attempt is illegal 
   // Bits 9:8 encode the priv level of the register address. 00 = U, 01 = S, 10 = reserved, 11 = M.
   // TODO: DEBUG access to illegal registers is not handled but merely ignored, maybe this is not spec compliant.
   assign illegal_region = (system_wen && (addr[11:10] == 2'b11))		
     || (system_en && addr[9:8] > prv);

   assign illegal_region_debug = (debug_wen && (dm_csr_addr[11:10] == 2'b11));	// write attempt to read-only registers is still illegal, but we don't care for privileges in debug mode 	

   assign illegal_access = illegal_region || (system_en && !defined);		// either illegal region, or not implemented / undefined. TODO: check, if we should return something, 
										// when not implemented..

   assign illegal_access_debug = illegal_region_debug || (debug_en && !defined_debug);

   // Calculate register content for bitwise SET/CLEAR commands
   always @(*) begin
      wdata_internal = |dm_csr_cmd ? dm_csr_wdata : wdata;			// default case = write full input word to register. Debug port has priority
      if (debug_wen) begin 
			case(dm_csr_cmd)
			`CSR_SET : wdata_internal = (dm_csr_rdata | dm_csr_wdata);
			`CSR_CLEAR : wdata_internal = (dm_csr_rdata & ~dm_csr_wdata);
			default : wdata_internal = dm_csr_wdata;
			endcase
      end else if (system_wen) begin
         case (cmd)								// special cases.. logical OR should blend Debug CMD over idle internal cmd
           `CSR_SET : wdata_internal = (rdata | wdata);				// SET
           `CSR_CLEAR : wdata_internal = (rdata & ~wdata);			// CLEAR
           default : wdata_internal = wdata;					// TODO: redundant? Initial statement set wdata_internal even if system_wen is unset...
         endcase // case (cmd)
      end
   end // always @ begin


	wire	wen_internal_or_debug; assign wen_internal_or_debug = wen_internal | wen_internal_debug;
	wire	[`CSR_ADDR_WIDTH-1:0]	addr_muxed; assign addr_muxed = wen_internal_debug ? dm_csr_addr : addr;

// =====================================================================
// = Interrupt handling                                                =
// =====================================================================


   assign uinterrupt = 1'b0;							// TODO: ?? don't allow user-mode interrupts? makes sense, but check meaning.
   assign minterrupt = |(mie & mip);						// signal machine interrupt if Interrupt Enalbed and Interrupt Pending
   assign dinterrupt = (debug_haltreq && !dmode);					// external debugger signals haltreq to redirect hart into park loop (and we are not already in dmode)
   assign interrupt_pending = |mip || dinterrupt;				// if any interrupt is pending .. 

   // signal taken interrupts to control
   always @(*) begin
      interrupt_code = `ICODE_TIMER;						// TODO: why? 
      case (prv)
        `PRV_U : interrupt_taken = (ie && uinterrupt) || minterrupt || dinterrupt;		// in User-mode, User-Interrupts and Machine-Interrupts are taken, M-Ints always!
        `PRV_M : interrupt_taken = (ie && minterrupt) || dinterrupt;		// in Machine mode, only Machine-Interrupts are taken, if enabled
        default : interrupt_taken = 1'b1;					
      endcase // case (prv)
   end


// ===================================================
// == Handle MSTATUS priv stack on priv mode changes =
// ===================================================

	always @(posedge clk) begin 
		if(reset) begin 
			dcsr <= 32'h40000000;	// TODO. stimmt aber sollte nicht hardcoded sein.
		end else begin 
			if(dinterrupt) begin 
				dcsr[2:0] <= mode;
				dcsr[8:6] <= 3'h3;	// cause = debug module halt request
			end else if (exception) begin
				if(exception_code == `MCAUSE_BREAKPOINT) begin 
					dcsr[2:0] <= mode;
					dcsr[8:6] <= 3'h2;	// TODO: this is for "trigger module caused breakpoint exception".
				end
			end else if (wen_internal_or_debug && (addr_muxed == `CSR_ADDR_DCSR)) begin 
				dcsr <= wdata_internal;
			end
		end
	end


   always @(posedge clk) begin						
      if (reset) begin
         //priv_stack <= 6'b000110;
 	mode <= `PRV_M;								// 09.02.18, ASt: always start in M-mode.
 	dmode <= 1'b0;								// 06.03.18, ASt: debug mode is disabled by default.
         priv_stack <= 8'b00000000;						// 09.02.18, ASt: start with all interrupts disabled.
      end else if (wen_internal_or_debug && (addr_muxed == `CSR_ADDR_MSTATUS)) begin		// if data is written to the MSTATUS register...
         priv_stack <= wdata_internal[7:0];					// 09.02.18, ASt: changed to new priv_stack size
      end else if (interrupt_taken) begin 
			 priv_stack <= {priv_stack[3:0],4'b0000};
			 if(dinterrupt) begin				
				dmode <= 1'b1;
			 end
			 else begin
				mode <= `PRV_M;
				dmode <= 1'b0;
			 end
		end else if (exception) begin						// if a trap is taken (ECALL etc.)...
         priv_stack <= {priv_stack[3:0],4'b0000};
			if(exception_code == `MCAUSE_BREAKPOINT) begin				// .. it can be a breakpoint, which ..
				dmode <= 1'b1;							// .. and enters debug mode.
			end else begin
				mode <= `PRV_M;							// .. it can only be a change to M-Mode, since there is only U/M-mode
				dmode <= 1'b0;
			end
      end else if (eret) begin							// if we return from a trap ..
         priv_stack <= {4'b0000,priv_stack[7:4]};				// .. we restore the saved information and set the stack entry to default value.
			mode <= `PRV_U;							// the only allowed xRET is MRET, which returns to UMODE
			dmode <= 1'b0;
      end else if (dret) begin
         priv_stack <= {4'b0000,priv_stack[7:4]};				
			mode <= dcsr[2:0];							
			dmode <= 1'b0; 
      end	
   end // always @ (posedge clk)

   assign epc = mepc;								// store Machine Exception PC as the one to use... TODO

   // this implementation has SD, VM, MPRV, XS, and FS set to 0
   //assign mstatus = {26'b0, priv_stack};					// TODO: only implements the priv_stack part of th MSTATUS. 
   assign mstatus = {24'b0, priv_stack};					// 09.02.18, ASt: changed to V1.10


   // signal pending interrupts based on the external sources and contents of MIP
   always @(posedge clk) begin
      if (reset) begin
         mtip <= 0;
         msip <= 0;
      end else begin
			if (wen_internal_or_debug && (addr_muxed == `CSR_ADDR_MIP)) begin
            mtip <= wdata_internal[7];
            msip <= wdata_internal[3];
			end
      end // else: !if(reset)
   end // always @ (posedge clk)
	
   assign mip = {ext_interrupts,mtip,3'b0,msip,3'b0};

   // implements writes to MIE, TODO: combine with cases below?, We currently only implement a single global interrupt/mask
   always @(posedge clk) begin
      if (reset) begin
         mie <= 0;
      end else if (wen_internal_or_debug && addr_muxed == `CSR_ADDR_MIE) begin
			mie <= wdata_internal;
      end
   end // always @ (posedge clk)

   // set MPEC and current mode in exception/interrupt/write situations
   always @(posedge clk) begin
      if (reset) begin
        mepc <= `XPR_LEN'h0;
      end else begin
      if (interrupt_taken & ~dinterrupt)
		begin
			mepc <= (exception_PC & {{30{1'b1}},2'b0}) + `XPR_LEN'h4;	// on an interrupt, the MEPC points to the instruction following the INT		
		end
      if (exception)
        mepc <= exception_PC & {{30{1'b1}},2'b0};			// on an exception, the MEPC points to the causing instruction
      if (wen_internal_or_debug && (addr_muxed == `CSR_ADDR_MEPC))
        mepc <= wdata_internal & {{30{1'b1}},2'b0};
      end
   end
	
	// handle changes to DPC in various situations
	always @(posedge clk) begin
		if(reset) begin
			dpc_r <= `XPR_LEN'h0;
		end else begin
			if(interrupt_taken & dinterrupt) begin
				dpc_r <= (exception_PC & {{30{1'b1}},2'b0});
			end else 
			if (wen_internal_or_debug && (addr_muxed == `CSR_ADDR_DPC)) begin
				dpc_r <= wdata_internal;
			end
		end
	end
	

   // set mecode (part of MCAUSE) on interrupts, exceptions and writes
   always @(posedge clk) begin
      if (reset) begin
         mecode <= 0;
         mint <= 0;
      end else if (wen_internal_or_debug && (addr_muxed == `CSR_ADDR_MCAUSE)) begin
         mecode <= wdata_internal[3:0];
         mint <= wdata_internal[31];
      end else begin
         if (interrupt_taken) begin
            mecode <= interrupt_code;
            mint <= 1'b1;
         end else if (exception) begin
            mecode <= exception_code;
            mint <= 1'b0;
         end
      end // else: !if(reset)
   end // always @ (posedge clk)
   assign mcause = {mint,27'b0,mecode};

   assign code_imem = (exception_code == `MCAUSE_INST_ADDR_MISALIGNED)	// signals memory related exceptions
     || (exception_code == `MCAUSE_INST_ADDR_MISALIGNED);

   // set mbadaddr (now MTVAL?) on exceptions and writes
   always @(posedge clk) begin
      if (reset) begin
        mbadaddr <= `XPR_LEN'h0;					
      end else begin
      if (exception)
        mbadaddr <= (code_imem) ? exception_PC : exception_load_addr;
      if ((wen_internal_or_debug && addr_muxed == `CSR_ADDR_MTVAL))
        mbadaddr <= wdata_internal;
      end
   end

   // Read multiplexer / addr-decoder for CSR register reads, sets "defined = 0" on unknown addresses.
   always @(*) begin
      case (addr)
	`ifndef ISA_EXT_E        
	`CSR_ADDR_CYCLE     : begin rdata = cycle_full[0+:`XPR_LEN]; defined = 1'b1; end		// TODO: check. CYCLEH should be upper 32 bits of CYCLE
        `CSR_ADDR_CYCLEH    : begin rdata = cycle_full[`XPR_LEN+:`XPR_LEN]; defined = 1'b1; end
	`endif
	`CSR_ADDR_DCSR	    : begin rdata = dcsr; defined = 1'b1; end
	`CSR_ADDR_DPC	    : begin rdata = dpc_r; defined = 1'b1; end
	`CSR_ADDR_DSCRATCH0 : begin rdata = dscratch0; defined = 1'b1; end
	
	`ifndef ISA_EXT_E
        `CSR_ADDR_INSTRET   : begin rdata = instret_full[0+:`XPR_LEN]; defined = 1'b1; end
        `CSR_ADDR_INSTRETH  : begin rdata = instret_full[`XPR_LEN+:`XPR_LEN]; defined = 1'b1; end
	`endif

	`CSR_ADDR_MARCHID   : begin rdata = marchid; defined = 1'b1; end
        `CSR_ADDR_MCAUSE    : begin rdata = mcause; defined = 1'b1; end

	`ifndef ISA_EXT_E
        `CSR_ADDR_MCYCLE     : begin rdata = cycle_full[0+:`XPR_LEN]; defined = 1'b1; end		// TODO: check. CYCLEH should be upper 32 bits of CYCLE
	`endif

        `CSR_ADDR_MEPC      : begin rdata = mepc; defined = 1'b1; end 
        `CSR_ADDR_MIE       : begin rdata = mie; defined = 1'b1; end
        `CSR_ADDR_MIP       : begin rdata = mip; defined = 1'b1; end
	
	`ifndef ISA_EXT_E
        `CSR_ADDR_MINSTRET   : begin rdata = instret_full[0+:`XPR_LEN]; defined = 1'b1; end
	`endif

	`CSR_ADDR_MISA	    : begin rdata = misa; defined = 1'b1; end
        `CSR_ADDR_MIMPID    : begin rdata = mimpid; defined = 1'b1; end
        `CSR_ADDR_MHARTID   : begin rdata = mhartid; defined = 1'b1; end
        `CSR_ADDR_MSCRATCH  : begin rdata = mscratch; defined = 1'b1; end
        `CSR_ADDR_MSTATUS   : begin rdata = mstatus; defined = 1'b1; end
        `CSR_ADDR_MTVAL	    : begin rdata = mbadaddr; defined = 1'b1; end // TODO!
        `CSR_ADDR_MTVEC     : begin rdata = mtvec; defined = 1'b1; end
	`CSR_ADDR_MVENDORID : begin rdata = mvendorid; defined = 1'b1; end
	`CSR_ADDR_PMPCFG0   : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPCFG1   : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPCFG2   : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPCFG3   : begin rdata = `XPR_LEN'h0; defined = 1'b1; end	
	`CSR_ADDR_PMPADDR0  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPADDR1  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPADDR2  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPADDR3  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPADDR4  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPADDR5  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPADDR6  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPADDR7  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPADDR8  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPADDR9  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPADDR10  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPADDR11  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPADDR12  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPADDR13  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPADDR14  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_PMPADDR15  : begin rdata = `XPR_LEN'h0; defined = 1'b1; end
	`CSR_ADDR_SATP	    : begin rdata = satp; defined = 1'b1; end

	`ifndef ISA_EXT_E
        `CSR_ADDR_TIME      : begin rdata = time_full[0+:`XPR_LEN]; defined = 1'b1; end
        `CSR_ADDR_TIMEH     : begin rdata = time_full[`XPR_LEN+:`XPR_LEN]; defined = 1'b1; end
	`endif
        default : begin rdata = 0; defined = 1'b0; end
      endcase // case (addr)
   end // always @ (*)


   // Read multiplexer / addr-decoder for CSR register reads from debug, sets "defined_debug = 0" on unknown addresses.
   always @(*) begin
      case (dm_csr_addr)
	`ifndef ISA_EXT_E
        `CSR_ADDR_CYCLE     : begin dm_csr_rdata = cycle_full[0+:`XPR_LEN]; defined_debug = 1'b1; end		// TODO: check. CYCLEH should be upper 32 bits of CYCLE
        `CSR_ADDR_CYCLEH    : begin dm_csr_rdata = cycle_full[`XPR_LEN+:`XPR_LEN]; defined_debug = 1'b1; end
	`endif
	
	`CSR_ADDR_DCSR	    : begin dm_csr_rdata = dcsr; defined_debug = 1'b1; end
	`CSR_ADDR_DPC	    : begin dm_csr_rdata = dpc_r; defined_debug = 1'b1; end
	`CSR_ADDR_DSCRATCH0 : begin dm_csr_rdata = dscratch0; defined_debug = 1'b1; end

	`ifndef ISA_EXT_E
        `CSR_ADDR_INSTRET   : begin dm_csr_rdata = instret_full[0+:`XPR_LEN]; defined_debug = 1'b1; end
        `CSR_ADDR_INSTRETH  : begin dm_csr_rdata = instret_full[`XPR_LEN+:`XPR_LEN]; defined_debug = 1'b1; end
	`endif
	
	`CSR_ADDR_MARCHID   : begin dm_csr_rdata = marchid; defined_debug = 1'b1; end
        `CSR_ADDR_MCAUSE    : begin dm_csr_rdata = mcause; defined_debug = 1'b1; end

	`ifndef ISA_EXT_E
        `CSR_ADDR_MCYCLE     : begin dm_csr_rdata = cycle_full[0+:`XPR_LEN]; defined_debug = 1'b1; end		// TODO: check. CYCLEH should be upper 32 bits of CYCLE
	`endif

        `CSR_ADDR_MEPC      : begin dm_csr_rdata = mepc; defined_debug = 1'b1; end 
        `CSR_ADDR_MIE       : begin dm_csr_rdata = mie; defined_debug = 1'b1; end
        `CSR_ADDR_MIP       : begin dm_csr_rdata = mip; defined_debug = 1'b1; end

	`ifndef ISA_EXT_E
        `CSR_ADDR_MINSTRET   : begin dm_csr_rdata = instret_full[0+:`XPR_LEN]; defined_debug = 1'b1; end
	`endif
	
	`CSR_ADDR_MISA	    : begin dm_csr_rdata = misa; defined_debug = 1'b1; end
        `CSR_ADDR_MIMPID    : begin dm_csr_rdata = mimpid; defined_debug = 1'b1; end
        `CSR_ADDR_MHARTID   : begin dm_csr_rdata = mhartid; defined_debug = 1'b1; end
        `CSR_ADDR_MSCRATCH  : begin dm_csr_rdata = mscratch; defined_debug = 1'b1; end
        `CSR_ADDR_MSTATUS   : begin dm_csr_rdata = mstatus; defined_debug = 1'b1; end
        `CSR_ADDR_MTVAL	    : begin dm_csr_rdata = mbadaddr; defined_debug = 1'b1; end // TODO!
        `CSR_ADDR_MTVEC     : begin dm_csr_rdata = mtvec; defined_debug = 1'b1; end
	`CSR_ADDR_MVENDORID : begin dm_csr_rdata = mvendorid; defined_debug = 1'b1; end
	`CSR_ADDR_PMPCFG0   : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPCFG1   : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPCFG2   : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPCFG3   : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end	
	`CSR_ADDR_PMPADDR0  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPADDR1  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPADDR2  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPADDR3  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPADDR4  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPADDR5  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPADDR6  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPADDR7  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPADDR8  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPADDR9  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPADDR10  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPADDR11  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPADDR12  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPADDR13  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPADDR14  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_PMPADDR15  : begin dm_csr_rdata = `XPR_LEN'h0; defined_debug = 1'b1; end
	`CSR_ADDR_SATP	    : begin dm_csr_rdata = satp; defined_debug = 1'b1; end

	`ifndef ISA_EXT_E	
        `CSR_ADDR_TIME      : begin dm_csr_rdata = time_full[0+:`XPR_LEN]; defined_debug = 1'b1; end
        `CSR_ADDR_TIMEH     : begin dm_csr_rdata = time_full[`XPR_LEN+:`XPR_LEN]; defined_debug = 1'b1; end
	`endif	
        default : begin dm_csr_rdata = 0; defined_debug = 1'b0; end
      endcase // case (addr)
   end // always @ (*)

`ifndef ISA_EXT_E
	// Handle writes to INSTRET / MINSTRET
	always @(posedge clk) begin
		if(reset) begin
			instret_full <= 0;
		end else begin 
			if(wen_internal_or_debug) begin
				if((addr_muxed == `CSR_ADDR_INSTRET) || (addr_muxed == `CSR_ADDR_MINSTRET)) begin
					instret_full[0+:`XPR_LEN] <= wdata_internal;
				end else 
				if(addr_muxed == `CSR_ADDR_INSTRETH) begin 
					instret_full[`XPR_LEN+:`XPR_LEN] <= wdata_internal;
				end
			end
			else begin 
				if(retire) begin
					instret_full <= instret_full + 1;
				end
			end
		end
	end

	// Handle writes to TIME
	always @(posedge clk) begin
		if(reset) begin
			time_full <= 0;
		end else begin 
			if(wen_internal_or_debug) begin				
				if(addr_muxed == `CSR_ADDR_TIME) begin
					time_full[0+:`XPR_LEN] <= wdata_internal;
				end else 
				if(addr_muxed == `CSR_ADDR_TIMEH) begin 
					time_full[`XPR_LEN+:`XPR_LEN] <= wdata_internal;
				end
			end else begin 
				time_full <= time_full;// time_full + 1;
			end
		end		
	end

	// Handle writes to CYCLE / MCYCLE
	always @(posedge clk) begin
		if(reset) begin
			cycle_full <= 0;
		end else begin 
			if(wen_internal_or_debug) begin
				if((addr_muxed == `CSR_ADDR_CYCLE) || (addr_muxed == `CSR_ADDR_MCYCLE)) begin
					cycle_full[0+:`XPR_LEN] <= wdata_internal;
				end else 
				if(addr_muxed == `CSR_ADDR_CYCLEH) begin 
					cycle_full[`XPR_LEN+:`XPR_LEN] <= wdata_internal;
				end
			end else begin 
				cycle_full <= cycle_full + 1;
			end
		end		
	end
`endif	
	
   // handle Write access to CSR registers and internal counters
   always @(posedge clk) begin
      if (reset) begin         
         mtvec <= 'h80000000;
         mscratch <= 0;
      end else begin         
			if (wen_internal_or_debug) begin							// Write-access to registers
            case (addr_muxed)              
				  `CSR_ADDR_DSCRATCH0 : dscratch0 <= wdata_internal;
              // mcpuid is read-only
              // mimpid is read-only
              // mhartid is read-only
              // mstatus handled separately
              `CSR_ADDR_MTVEC     : mtvec <= wdata_internal & {{30{1'b1}},2'b0};
              // mie handled separately
              `CSR_ADDR_MSCRATCH  : mscratch <= wdata_internal;
              // mepc handled separately
              // mcause handled separately
              // mbadaddr handled separately
              // mip handled separately
				  `CSR_ADDR_SATP	  : satp <= wdata_internal;
              default : ;
            endcase // case (addr)
         end // if (wen_internal)
      end // else: !if(reset)
   end // always @ (posedge clk)



endmodule // raifes_csr_file
