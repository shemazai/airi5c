`include "raifes_ctrl_constants.vh"
`include "raifes_alu_ops.vh"
`include "rv32_opcodes.vh"
`include "raifes_csr_addr_map.vh"
`include "raifes_platform_constants.vh"

module raifes_pipeline(
                       input 			    clk,			// system clock
		       input [`N_EXT_INTS-1:0] 	    ext_interrupts, 		// external interrupts
		       input		  	    debug_haltreq,		// external debug halt request (interrupt)
                       input 			    reset,			// system reset
                       input 			    imem_wait,			// Instruction memory is busy if imem_wait == 1
                       output [`XPR_LEN-1:0] 	    imem_addr,			// Instruction Memory Address
                       input [`XPR_LEN-1:0] 	    imem_rdata,			// Instruction Memory Data
                       input 			    imem_badmem_e,		// Instruction Memory error signal
		       output			    imem_stall,			// stall IF forwarded to memory
                       input 			    dmem_wait,			// Data Memory is busy if dmem_wait == 1
                       output 			    dmem_en,			// Data Memory enable (for Read+Write)
                       output 			    dmem_wen,			// Data Memory Write Enable
                       output [`MEM_TYPE_WIDTH-1:0] dmem_size,			// Data Memory access width (byte, word, dword)
                       output [`XPR_LEN-1:0] 	    dmem_addr,			// Data Memory address
                       output [`XPR_LEN-1:0] 	    dmem_wdata_delayed,		// TODO: not sure..
                       input [`XPR_LEN-1:0] 	    dmem_rdata,			// Word read from data memory
                       input 			    dmem_badmem_e,		// Data memory error signal			

		       input [`REG_ADDR_WIDTH-1:0]  dm_wara,			// debug module register access - write/read address
		       input [`XPR_LEN-1:0]	    dm_wd,			// debug module register access - write data
		       input 			    dm_wen,			// debug module register access - write enable
		       output [`XPR_LEN-1:0]	    dm_rd,			// debug module register access - read data
		       
		       output			    dm_illegal_csr_access,
   	               input [`CSR_ADDR_WIDTH-1:0]  dm_csr_addr,		// CSR address
   		       input [`CSR_CMD_WIDTH-1:0]   dm_csr_cmd,			// CSR command (0 == IDLE)
		       input [`XPR_LEN-1:0]	    dm_csr_wdata,		// data to be written to CSR		
                       output [`XPR_LEN-1:0]	    dm_csr_rdata		// data read from CSR 			
							  

                       );

   // differentiate between byte/halfword/word wide writes to memory

   function [`XPR_LEN-1:0] store_data;
      input [`XPR_LEN-1:0]                          addr;
      input [`XPR_LEN-1:0]                          data;
      input [`MEM_TYPE_WIDTH-1:0]                   mem_type;
      begin
         case (mem_type)
           `MEM_TYPE_SB : store_data = {4{data[7:0]}};
           `MEM_TYPE_SH : store_data = {2{data[15:0]}};
           default : store_data = data;
         endcase // case (mem_type)
      end
   endfunction // case

   // differentiate between byte/halfword/word wide reads from memory, unsigned or signed

   function [`XPR_LEN-1:0] load_data;
      input [`XPR_LEN-1:0]                      addr;
      input [`XPR_LEN-1:0]                      data;
      input [`MEM_TYPE_WIDTH-1:0]               mem_type;
      reg [`XPR_LEN-1:0]                        shifted_data;
      reg [`XPR_LEN-1:0]                        b_extend;
      reg [`XPR_LEN-1:0]                        h_extend;
      begin
         shifted_data = data >> {addr[1:0],3'b0};
         b_extend = {{24{shifted_data[7]}},8'b0};
         h_extend = {{16{shifted_data[15]}},16'b0};
         case (mem_type)
           `MEM_TYPE_LB : load_data = (shifted_data & `XPR_LEN'hff) | b_extend;
           `MEM_TYPE_LH : load_data = (shifted_data & `XPR_LEN'hffff) | h_extend;
           `MEM_TYPE_LBU : load_data = (shifted_data & `XPR_LEN'hff);
           `MEM_TYPE_LHU : load_data = (shifted_data & `XPR_LEN'hffff);
           default : load_data = shifted_data;
         endcase // case (mem_type)
      end
   endfunction // case

   wire [`PC_SRC_SEL_WIDTH-1:0]                 PC_src_sel;				// control signal for PC multiplexer (e.g. on branches PC comes from ALU output)
   wire [`XPR_LEN-1:0]                          PC_PIF;					// TODO: This holds the branch target, but why is it called *P* IF?


   reg [`XPR_LEN-1:0]                           PC_IF;					// this is the PC of the instruction currently in IF stage

   wire                                         kill_IF;				// TODO: figure out exact kill/stall mechanism
   wire                                         stall_IF;
   assign imem_stall = stall_IF;


   reg [`XPR_LEN-1:0]                           PC_DX;					// this is the PC of the instruction currently in DX stage
   reg [`INST_WIDTH-1:0]                        inst_DX;				// this is the instruction word currently in DX stage

   wire                                         kill_DX;
   wire                                         stall_DX;
   wire [`IMM_TYPE_WIDTH-1:0]                   imm_type;				// Immediate type TODO: figure out which types to differentiate
   wire [`XPR_LEN-1:0]                          imm;					// Immediate value retrieved from instruction word
   wire [`SRC_A_SEL_WIDTH-1:0]                  src_a_sel;				// ALU A input source select (register, immediate, something from WB stage...)
   wire [`SRC_B_SEL_WIDTH-1:0]                  src_b_sel;				// ALU B input source select
   wire [`REG_ADDR_WIDTH-1:0]                   rs1_addr;				// source register 1 (rs1) addr (0 - 31)
   wire [`XPR_LEN-1:0]                          rs1_data;				// data from source register 1
   wire [`XPR_LEN-1:0]                          rs1_data_bypassed;			// TODO: figure out exact bypass mechanism first.
   wire [`REG_ADDR_WIDTH-1:0]                   rs2_addr;				// source register 2 (rs2) addr
   wire [`XPR_LEN-1:0]                          rs2_data;				// source register 2 data
   wire [`XPR_LEN-1:0]                          rs2_data_bypassed;			// TODO: figure out exact bypass mechanism first.
   wire [`ALU_OP_WIDTH-1:0]                     alu_op;					// ALU operation
   wire [`XPR_LEN-1:0]                          alu_src_a;				// ALU input A (selected by src_a_sel)
   wire [`XPR_LEN-1:0]                          alu_src_b;				// ALU input B (selected by src_b_sel)
   wire [`XPR_LEN-1:0]                          alu_out;				// ALU output
   wire                                         cmp_true;				// (parallel) branch condition evaluation result.
   wire                                         bypass_rs1;				// controls if rs1 is bypassed
   wire                                         bypass_rs2;				// controls if rs2 is bypassed
   wire [`MEM_TYPE_WIDTH-1:0]                   dmem_type;				// TODO: ??

   reg [`XPR_LEN-1:0]                           PC_WB;					// PC of the instruction currently in WB stage
   reg [`XPR_LEN-1:0]                           alu_out_WB;				// register for holding the ALU output in WB stage
   reg [`XPR_LEN-1:0]                           csr_rdata_WB;				// register for holding the data read from CSR in WB stage
   reg [`XPR_LEN-1:0]                           store_data_WB;				// TODO: figure out exact use of pipeline registers first.

   wire                                         kill_WB;
   wire                                         stall_WB;
   reg [`XPR_LEN-1:0]                           bypass_data_WB;
   wire [`XPR_LEN-1:0]                          load_data_WB;
   reg [`XPR_LEN-1:0]                           wb_data_WB;
   wire [`REG_ADDR_WIDTH-1:0]                   reg_to_wr_WB;
   wire                                         wr_reg_WB;
   wire [`WB_SRC_SEL_WIDTH-1:0]                 wb_src_sel_WB;
   reg [`MEM_TYPE_WIDTH-1:0]                    dmem_type_WB;

   // CSR management
   wire [`CSR_ADDR_WIDTH-1:0]                   csr_addr;				// CSR address
   wire [`CSR_CMD_WIDTH-1:0]                    csr_cmd;				// CSR command (0 == IDLE)
   wire                                         csr_imm_sel;				// TODO: figure out exact meaning
   wire [`PRV_WIDTH-1:0]                        prv;					// privilege level (00 == USER, 01 == SUPERVISOR, 10 == RESERVED, 11 == MACHINE)
   wire                                         illegal_csr_access;			// return value from CSR if illegal access occured
   wire 					interrupt_pending;
   wire 					interrupt_taken;	
   wire [`XPR_LEN-1:0]                          csr_wdata;				// Data to write into CSR registers
   wire [`XPR_LEN-1:0]                          csr_rdata;				// Data from CSR registers
   wire                                         retire_WB;				
   wire                                         exception_WB;
   wire [`MCAUSE_WIDTH-1:0]                     exception_code_WB;
   wire [`XPR_LEN-1:0]                          handler_PC;
   wire                                         eret;
   wire                                         dret;
   wire [`XPR_LEN-1:0]                          epc;
   wire [`XPR_LEN-1:0]                          dpc;   


   reg	[`XPR_LEN-1:0]				dmem_addr_r;			// dmem address latch

   // Debug Module access to CSR file

/*   wire [`CSR_ADDR_WIDTH-1:0]			dm_csr_addr;				
   wire [`CSR_CMD_WIDTH-1:0]		 	dm_csr_cmd;
   wire [`XPR_LEN-1:0]				dm_csr_rdata;
   wire [`XPR_LEN-1:0]				dm_csr_wdata;*/

// DEBUG

   raifes_ctrl ctrl(
                    .clk(clk),							// system clock
                    .reset(reset),						// system reset
                    .inst_DX(inst_DX),						// instruction word currently in DX stage
                    .imem_wait(imem_wait),					
                    .imem_badmem_e(imem_badmem_e),
                    .dmem_wait(dmem_wait),
                    .dmem_badmem_e(dmem_badmem_e),
                    .cmp_true(cmp_true),
                    .PC_src_sel(PC_src_sel),
                    .imm_type(imm_type),
                    .src_a_sel(src_a_sel),
                    .src_b_sel(src_b_sel),
                    .bypass_rs1(bypass_rs1),
                    .bypass_rs2(bypass_rs2),
                    .alu_op(alu_op),
                    .dmem_en(dmem_en),
                    .dmem_wen(dmem_wen),
                    .dmem_size(dmem_size),
                    .dmem_type(dmem_type),
                    .wr_reg_WB(wr_reg_WB),
                    .reg_to_wr_WB(reg_to_wr_WB),
                    .wb_src_sel_WB(wb_src_sel_WB),
                    .stall_IF(stall_IF),
                    .kill_IF(kill_IF),
                    .stall_DX(stall_DX),
                    .kill_DX(kill_DX),
                    .stall_WB(stall_WB),
                    .kill_WB(kill_WB),
                    .exception_WB(exception_WB),
                    .exception_code_WB(exception_code_WB),
                    .retire_WB(retire_WB),
                    .csr_cmd(csr_cmd),
                    .csr_imm_sel(csr_imm_sel),
                    .illegal_csr_access(illegal_csr_access),
		    .interrupt_pending(interrupt_pending),
		    .interrupt_taken(interrupt_taken),
                    .prv(prv),
                    .eret(eret),
                    .dret(dret)
                    );


   raifes_PC_mux PCmux(
                       .PC_src_sel(PC_src_sel),
                       .inst_DX(inst_DX),
                       .rs1_data(rs1_data_bypassed),
                       .PC_IF(PC_IF),
                       .PC_DX(PC_DX),
                       .handler_PC(handler_PC),
                       .epc(epc),
                       .dpc(dpc),
                       .PC_PIF(PC_PIF)
                       );

   assign imem_addr = PC_PIF;

   always @(posedge clk) begin
      if (reset) begin
         PC_IF <= `START_ADDRESS;		// start address
      end else if (~stall_IF) begin
         PC_IF <= PC_PIF;
      end
   end

   always @(posedge clk) begin
      if (reset) begin
         PC_DX <= `START_ADDRESS;
         inst_DX <= `RV_NOP;			// inject NOPs into DX during reset
      end else if (~stall_DX) begin
         if (kill_IF) begin
	    PC_DX <= PC_PIF;			// if IF is killed, forward the next IF to DX. DX doesnt do anything (NOP), but it then 
					 	// already holds the address of the next instruction. If an interrupt persists, this will be 
						// taken as the return address.
            inst_DX <= `RV_NOP;			// if IF is replaying / killed, insert NOPs
         end else begin
            PC_DX <= PC_IF;			// if IF is working, copy PC from IF stage to DX stage
            inst_DX <= imem_rdata;		// .. and copy real instruction to DX stage for execution.
         end
      end
   end // always @ (posedge hclk)

   assign rs1_addr = inst_DX[19:15];
   assign rs2_addr = inst_DX[24:20];

   raifes_regfile regfile(
                          .clk(clk),
                          .ra1(rs1_addr),
                          .rd1(rs1_data),
                          .ra2(rs2_addr),
                          .rd2(rs2_data),
                          .wen(wr_reg_WB),
                          .wa(reg_to_wr_WB),
                          .wd(wb_data_WB),
			  .dm_wara(dm_wara),
			  .dm_rd(dm_rd),
			  .dm_wd(dm_wd),
			  .dm_wen(dm_wen)
                          );

   raifes_imm_gen imm_gen(
                          .inst(inst_DX),
                          .imm_type(imm_type),
                          .imm(imm)
                          );

   raifes_src_a_mux src_a_mux(
                              .src_a_sel(src_a_sel),
                              .PC_DX(PC_DX),
                              .rs1_data(rs1_data_bypassed),
                              .alu_src_a(alu_src_a)
                              );

   raifes_src_b_mux src_b_mux(
                              .src_b_sel(src_b_sel),
                              .imm(imm),
                              .rs2_data(rs2_data_bypassed),
                              .alu_src_b(alu_src_b)
                              );

   assign rs1_data_bypassed = bypass_rs1 ? bypass_data_WB : rs1_data;
   assign rs2_data_bypassed = bypass_rs2 ? bypass_data_WB : rs2_data;

   raifes_alu alu(
                  .op(alu_op),
                  .in1(alu_src_a),
                  .in2(alu_src_b),
                  .out(alu_out)
                  );

   assign cmp_true = alu_out[0];

//   assign dmem_addr = alu_out;

//   always @* begin
   always @(dmem_en) begin	// changed to force latch instantiation (otherwise synth complains about use before assignment)
	if(dmem_en) begin
		dmem_addr_r = alu_out;
	end else begin
		dmem_addr_r = dmem_addr_r;
	end
   end

//   assign dmem_addr = alu_out;
   assign dmem_addr = dmem_addr_r;

   always @(posedge clk) begin
      if (reset) begin
         PC_WB <= 0;
         store_data_WB <= 0;
         alu_out_WB <= 0;
      end else if (~stall_WB) begin
         PC_WB <= PC_DX;
         store_data_WB <= rs2_data_bypassed;
         alu_out_WB <= alu_out;
         csr_rdata_WB <= csr_rdata;
         dmem_type_WB <= dmem_type;
      end
   end


   always @(*) begin
      case (wb_src_sel_WB)
        `WB_SRC_CSR : bypass_data_WB = csr_rdata_WB;
        default : bypass_data_WB = alu_out_WB;
      endcase // case (wb_src_sel_WB)
   end

   assign load_data_WB = load_data(alu_out_WB,dmem_rdata,dmem_type_WB);

   always @(*) begin
      case (wb_src_sel_WB)
        `WB_SRC_ALU : wb_data_WB = bypass_data_WB;
        `WB_SRC_MEM : wb_data_WB = load_data_WB;
        `WB_SRC_CSR : wb_data_WB = bypass_data_WB;
        default : wb_data_WB = bypass_data_WB;
      endcase
   end


   assign dmem_wdata_delayed = store_data(alu_out_WB,store_data_WB,dmem_type_WB);


   // CSR

   assign csr_addr = inst_DX[31:20];
   assign csr_wdata = (csr_imm_sel) ? inst_DX[19:15] : rs1_data_bypassed;

   raifes_csr_file csr(
                       .clk(clk),
		       .ext_interrupts(ext_interrupts),
		       .debug_haltreq(debug_haltreq),			// TODO: TIE THIS TO PRIMARY INPUT!
                       .reset(reset),
                       .addr(csr_addr),
                       .cmd(csr_cmd),
                       .wdata(csr_wdata),
                       .prv(prv),
                       .illegal_access(illegal_csr_access),
		       .illegal_access_debug(dm_illegal_csr_access),
                       .rdata(csr_rdata),
                       .retire(retire_WB),
                       .exception(exception_WB),
                       .exception_code(exception_code_WB),
                       .exception_load_addr(alu_out_WB),
                       .exception_PC(interrupt_taken ? PC_DX : PC_WB),	// after an exception, the WB stage holds the return address in the next cycle. 
									// but in case of an interrupt, IF/DX are instantly killed and the address will not 
									// propagate to PC_WB. So better get the PC of the instruction which was interrupted.
                       .epc(epc),
                       .dpc(dpc),
                       .eret(eret),
                       .dret(dret),
                       .handler_PC(handler_PC),
		       .interrupt_pending(interrupt_pending),
		       .interrupt_taken(interrupt_taken),

		       .dm_csr_addr(dm_csr_addr),
		       .dm_csr_cmd(dm_csr_cmd),
		       .dm_csr_rdata(dm_csr_rdata),
		       .dm_csr_wdata(dm_csr_wdata)

                       );

endmodule // raifes_pipeline
