`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2019 10:59:31
// Design Name: Xueqi Li
// Module Name: raifes_cop_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module raifes_cop_top(

//
// Clock and reset interface

input  wire             g_clk           , // Global clock
input  wire             g_resetn        , // Synchronous active low reset.

//
// Status Interface
`ifdef FORMAL
output wire [31:0]      cop_random      , // The most recent random sample
output wire             cop_rand_sample , // cop_random valid when this high.

`VTX_REGISTER_PORTS_OUT(cprs_snoop)
`endif

//
// CPU / COP Interface
input  wire             cpu_insn_req    , // Instruction request
output                  cop_insn_ack    , // Instruction request acknowledge
input  wire [31:0]      cpu_insn_enc    , // Encoded instruction data
input  wire [31:0]      cpu_rs1         , // RS1 source data
input  wire [31:0]      cpu_rs2         , // RS2 source data

output                  cop_wen         , // COP write enable
output      [ 4:0]      cop_waddr       , // COP destination register address
output      [31:0]      cop_wdata       , // COP write data
output      [ 2:0]      cop_result      , // COP execution result
output                  cop_insn_rsp    , // COP instruction finished
input  wire             cpu_insn_ack     // Instruction finish acknowledge

/*
//
// Memory Interface
output wire             cop_mem_cen     , // Chip enable
output wire             cop_mem_wen     , // write enable
output wire [31:0]      cop_mem_addr    , // Read/write address (word aligned)
output wire [31:0]      cop_mem_wdata   , // Memory write data
input  wire [31:0]      cop_mem_rdata   , // Memory read data
output wire [ 3:0]      cop_mem_ben     , // Write Byte enable
input  wire             cop_mem_stall   , // Stall
input  wire             cop_mem_error     // Error
*/
);

// Common constants & definitions
`include "raifes_cop_common.vh"


//
// Glue logic wires
//

wire          id_exception    ; // Illegal instruction exception.

wire [ 6:0]   id_class        ; // Instruction class.
wire [15:0]   id_subclass     ; // Instruction subclass.

wire          id_cprs_init    ; // xc.init instruction executing.
wire          cprs_init_done  ; // xc.init instruction finished.

wire [ 2:0]   id_pw           ; // Instruction pack width.
wire [ 3:0]   id_crs1         ; // Instruction source register 1
wire [ 3:0]   id_crs2         ; // Instruction source register 2
wire [ 3:0]   id_crs3         ; // Instruction source register 3
wire [ 3:0]   id_crd          ; // Instruction destination register  
wire [ 3:0]   id_crd1         ; // MP Instruction destination register 1
wire [ 3:0]   id_crd2         ; // MP Instruction destination register 2
wire [ 4:0]   id_rd           ; // GPR destination register
wire [ 4:0]   id_rs1          ; // GPR source register
wire [31:0]   id_imm          ; // Decoded immediate.
wire          id_wb_h         ; // Halfword index (load/store)
wire          id_wb_b         ; // Byte index (load/store)

wire          crs1_ren   = 1'b1   ; // CPR Port 1 read enable
wire [ 3:0]   crs1_addr  = malu_rdm_in_rs ? id_crd1 : id_crs1; // CPR Port 1

wire          crs2_ren   = 1'b1   ; // CPR Port 2 read enable
wire [ 3:0]   crs2_addr  = malu_rdm_in_rs ? id_crd2 : id_crs2; // CPR Port 2

wire          crs3_ren   = 1'b1   ; // CPR Port 2 read enable
wire [ 3:0]   crs3_addr  = malu_rdm_in_rs ? id_crs1 : id_crs3; // CPR Port 2

wire [31:0]   crs1_rdata      ; // CPR Port 1 read data
wire [31:0]   crs2_rdata      ; // CPR Port 1 read data
wire [31:0]   crs3_rdata      ; // CPR Port 3 read data

wire [ 3:0]   crd_wen         ; // CPR Port 4 write enable
wire [ 3:0]   crd_addr        ; // CPR Port 4 address
wire [31:0]   crd_wdata       ; // CPR Port 4 write data

wire          insn_valid;
wire          fu_done;


wire          palu_ivalid      ; // Valid instruction input
wire          palu_idone       ; // Instruction complete
wire [ 3:0]   palu_cpr_rd_ben  ; // Writeback byte enable
wire [31:0]   palu_cpr_rd_wdata; // Writeback data


wire          rng_ivalid       ; // Valid instruction input
wire          rng_idone        ; // Instruction complete
wire [ 3:0]   rng_cpr_rd_ben   ; // Writeback byte enable
wire [31:0]   rng_cpr_rd_wdata ; // Writeback data

wire          mem_ivalid       ; // Valid instruction input
wire          mem_idone        ; // Instruction complete
wire          mem_is_store     ; // Instruction is a store / nload
wire          mem_addr_error   ; // Memory address exception
wire          mem_bus_error    ; // Memory bus exception
wire [ 3:0]   mem_cpr_rd_ben   ; // Writeback byte enable
wire [31:0]   mem_cpr_rd_wdata ; // Writeback data

wire          malu_rdm_in_rs   ; // Source destination registers in rs1/rs2
wire          malu_ivalid      ; // Valid instruction input
wire          malu_idone       ; // Instruction complete
wire [ 3:0]   malu_cpr_rd_ben  ; // Writeback byte enable
wire [31:0]   malu_cpr_rd_wdata; // Writeback data

wire          perm_ivalid      ; // Valid instruction input
wire          perm_idone       ; // Instruction complete
wire [ 3:0]   perm_cpr_rd_ben  ; // Writeback byte enable
wire [31:0]   perm_cpr_rd_wdata; // Writeback data

//  Send instructions to FU based on the decoded id_class.
//

assign palu_ivalid = 
    insn_valid  && (
    id_class[RAIFES_COP_ICLASS_PACKED_ARITH] ||
    id_class[RAIFES_COP_ICLASS_MOVE        ] ||
    id_class[RAIFES_COP_ICLASS_BITWISE     ] );

assign malu_ivalid  = insn_valid && id_class[RAIFES_COP_ICLASS_MP];

assign mem_ivalid   = insn_valid && id_class[RAIFES_COP_ICLASS_LOADSTORE];

assign rng_ivalid   = insn_valid && id_class[RAIFES_COP_ICLASS_RANDOM];
assign perm_ivalid  = insn_valid && id_class[RAIFES_COP_ICLASS_PERMUTE];

//
// CPR Writeback data selection

assign crd_wen   = palu_cpr_rd_ben | rng_cpr_rd_ben | mem_cpr_rd_ben | malu_cpr_rd_ben | perm_cpr_rd_ben;
assign crd_addr  = !malu_ivalid ? id_crd :!malu_idone ? id_crd1 : id_crd2;
assign crd_wdata = palu_cpr_rd_wdata | mem_cpr_rd_wdata | malu_cpr_rd_wdata | rng_cpr_rd_wdata | perm_cpr_rd_wdata;

//
// GPR Writeback data and instruction result selection
//
//  Control writeback data for the GPRs, and the result of each
//  instruction.
//

wire        n_cop_wen   ; // COP write enable
wire [ 4:0] n_cop_waddr ; // COP destination register address
wire [31:0] n_cop_wdata ; // COP write data
wire [ 2:0] n_cop_result; // COP execution result



assign n_cop_waddr = id_rd;


assign n_cop_wen   = (id_class[RAIFES_COP_ICLASS_MOVE] && id_subclass[RAIFES_COP_SCLASS_XCR2GPR] )||
                   (id_class[RAIFES_COP_ICLASS_RANDOM] && id_subclass[RAIFES_COP_SCLASS_RTEST] ) ||
                   (id_class[RAIFES_COP_ICLASS_MP] && (id_subclass[RAIFES_COP_SCLASS_MEQU] || id_subclass[RAIFES_COP_SCLASS_MLTE] || id_subclass[RAIFES_COP_SCLASS_MGTE] ) );

assign n_cop_wdata = id_class[RAIFES_COP_ICLASS_MOVE  ] ? palu_cpr_rd_wdata : 
                     id_class[RAIFES_COP_ICLASS_RANDOM] ? rng_cpr_rd_wdata  : malu_cpr_rd_wdata ;
//
//  and/or the result of the instruction together. Note
//  SCARV_COP_INSN_SUCCESS == 0
assign n_cop_result = id_exception ?  RAIFES_COP_INSN_BAD_INS : RAIFES_COP_INSN_SUCCESS ;
/*assign n_cop_result= 
    id_exception ?  RAIFES_COP_INSN_BAD_INS : (
    RAIFES_COP_INSN_BAD_LAD |
    RAIFES_COP_INSN_LD_ERR  |
    RAIFES_COP_INSN_BAD_SAD |
    RAIFES_COP_INSN_ST_ERR  | RAIFES_COP_INSN_SUCCESS );
 */   
wire [31:0] u_insn_enc;
wire [31:0] u_rs1;
wire [31:0] u_rs2;

assign cop_wen    = n_cop_wen   ; // COP write enable
assign cop_waddr  = n_cop_waddr ; // COP destination register address
assign cop_wdata  = n_cop_wdata ; // COP write data
assign cop_result = n_cop_result; // COP execution result
assign u_insn_enc = cpu_insn_enc;
assign u_rs1      = cpu_rs1     ;
assign u_rs2      = cpu_rs2     ;


/*    assign  fu_done         = 
        mem_idone || palu_idone || malu_idone ||
        rng_idone || aes_idone  || sha3_idone ||
        id_exception || cprs_init_done || perm_idone; */
assign  fu_done  = mem_idone || palu_idone || malu_idone || id_exception || cprs_init_done || rng_idone || perm_idone ;

assign  insn_valid  = cpu_insn_req;

assign  cop_insn_rsp = insn_valid && fu_done;
assign  cop_insn_ack = cop_insn_rsp;


// END PIPELINE PROGRESSION CONTROL
//


raifes_cop_idecode cop_idecode (
.id_encoded  (u_insn_enc  ), // Encoding 32-bit instruction
.id_exception(id_exception), // Illegal instruction exception.
.id_class    (id_class    ), // Instruction class.
.id_subclass (id_subclass ), // Instruction subclass.
.id_pw       (id_pw       ), // Instruction pack width.
.id_cprs_init(id_cprs_init), // xc.init executing.
.id_crs1     (id_crs1     ), // Instruction source register 1
.id_crs2     (id_crs2     ), // Instruction source register 2
.id_crs3     (id_crs3     ), // Instruction source register 3
.id_crd      (id_crd      ), // Instruction destination register
.id_crd1     (id_crd1     ), // MP Instruction destination register 1
.id_crd2     (id_crd2     ), // MP Instruction destination register 2
.id_rd       (id_rd       ), // GPR destination register
.id_rs1      (id_rs1      ), // GPR source register
.id_imm      (id_imm      ), // Decoded immediate.
.id_wb_h     (id_wb_h     ),
.id_wb_b     (id_wb_b     )
);




raifes_cop_cprs cop_cprs(
.g_clk     (g_clk     ), // Global clock
.g_resetn  (g_resetn  ), // Synchronous active low reset.
`ifdef FORMAL
`VTX_REGISTER_PORTS_RAISE(cprs_snoop)
`endif
.cprs_init (id_cprs_init), // Initialise back to zero.
.cprs_init_done (cprs_init_done), // Initialise back to zero.
.crs1_ren  (crs1_ren  ), // Port 1 read enable
.crs1_addr (crs1_addr ), // Port 1 address
.crs1_rdata(crs1_rdata), // Port 1 read data
.crs2_ren  (crs2_ren  ), // Port 2 read enable
.crs2_addr (crs2_addr ), // Port 2 address
.crs2_rdata(crs2_rdata), // Port 2 read data
.crs3_ren  (crs3_ren  ), // Port 3 read enable
.crs3_addr (crs3_addr ), // Port 3 address
.crs3_rdata(crs3_rdata), // Port 3 read data
.crd_wen   (crd_wen   ), // Port 4 write enable
.crd_addr  (crd_addr  ), // Port 4 address
.crd_wdata (crd_wdata )  // Port 4 write data
);
    
  //
// instance: raifes_cop_palu
//
//  Combinatorial Packed arithmetic and shift module.
//
// notes:
//  - INS expects crd value to be in palu_rs3
//
raifes_cop_palu cop_palu (
.g_clk            (g_clk           ), // Global clock
.g_resetn         (g_resetn        ), // Synchronous active low reset.
.palu_ivalid      (palu_ivalid      ), // Valid instruction input
.palu_idone       (palu_idone       ), // Instruction complete
.gpr_rs1          (u_rs1            ), // GPR rs1
.palu_rs1         (crs1_rdata       ), // Source register 1
.palu_rs2         (crs2_rdata       ), // Source register 2
.palu_rs3         (crs3_rdata       ), // Source register 3
.id_imm           (id_imm           ), // Source immedate
.id_pw            (id_pw            ), // Pack width
.id_class         (id_class         ), // Instruction class
.id_subclass      (id_subclass      ), // Instruction subclass
.palu_cpr_rd_ben  (palu_cpr_rd_ben  ), // Writeback byte enable
.palu_cpr_rd_wdata(palu_cpr_rd_wdata)  // Writeback data
);

 
//
//  Load/store memory access module.
//
raifes_cop_mem cop_mem (
.g_clk           (g_clk           ), // Global clock
.g_resetn        (g_resetn        ), // Synchronous active low reset.
.mem_ivalid      (mem_ivalid      ), // Valid instruction input
.mem_idone       (mem_idone       ), // Instruction complete
.mem_is_store    (mem_is_store    ), // Is the instruction a store?
.mem_addr_error  (mem_addr_error  ), // Memory address exception
.mem_bus_error   (mem_bus_error   ), // Memory bus exception
.gpr_rs1         (u_rs1           ), // GPR Source register 1
.gpr_rs2         (u_rs2           ), // GPR Source register 2
.cpr_rs1         (crs1_rdata      ), // XCR Source register 2
.cpr_rs2         (crs2_rdata      ), // XCR Source register 3
.cpr_rs3         (crs3_rdata      ), // XCR Source register 3
.id_wb_h         (id_wb_h         ), // Halfword index (load/store)
.id_wb_b         (id_wb_b         ), // Byte index (load/store)
.id_imm          (id_imm          ), // Source immedate
.id_subclass     (id_subclass     ), // Instruction subclass
.mem_cpr_rd_ben  (mem_cpr_rd_ben  ), // Writeback byte enable
.mem_cpr_rd_wdata(mem_cpr_rd_wdata) // Writeback data
);
 

//  Multi-precision arithmetic and shift module.
//
raifes_cop_malu cop_malu (
.g_clk            (g_clk           ), // Global clock
.g_resetn         (g_resetn        ), // Synchronous active low reset.
.malu_ivalid      (malu_ivalid      ), // Valid instruction input
.malu_idone       (malu_idone       ), // Instruction complete
.malu_rdm_in_rs   (malu_rdm_in_rs   ),
.gpr_rs1          (u_rs1            ),
.malu_rs1         (crs1_rdata       ), // Source register 1
.malu_rs2         (crs2_rdata       ), // Source register 2
.malu_rs3         (crs3_rdata       ), // Source register 3
.id_imm           (id_imm           ), // Source immedate
.id_subclass      (id_subclass      ), // Instruction subclass
.malu_cpr_rd_ben  (malu_cpr_rd_ben  ), // Writeback byte enable
.malu_cpr_rd_wdata(malu_cpr_rd_wdata)  // Writeback data
);

//  Bit level permutation instructions.
//
raifes_cop_permute cop_permute (
.perm_ivalid      (perm_ivalid      ), // Valid instruction input
.perm_idone       (perm_idone       ), // Instruction complete
.perm_rs1         (crs1_rdata       ), // Source register 1
.perm_rs3         (crs3_rdata       ), // Source register 3 / rd
.id_imm           (id_imm           ), // Source immedate
.id_subclass      (id_subclass      ), // Instruction subclass
.perm_cpr_rd_ben  (perm_cpr_rd_ben  ), // Writeback byte enable
.perm_cpr_rd_wdata(perm_cpr_rd_wdata)  // Writeback data
);

//
// Random number generator
//
raifes_cop_rng cop_rng(
.g_clk           (g_clk           ), // Global clock
.g_resetn        (g_resetn        ), // Synchronous active low reset.
.rng_ivalid      (rng_ivalid      ), // Valid instruction input
.rng_idone       (rng_idone       ), // Instruction complete
`ifdef FORMAL
.cop_random      (cop_random      ), // Latest random sample value
.cop_rand_sample (cop_rand_sample ), // random sample value valid
`endif
.rng_rs1         (crs1_rdata      ), // Source register 1
.id_imm          (id_imm          ), // Source immedate
.id_subclass     (id_subclass     ), // Instruction subclass
.rng_cpr_rd_ben  (rng_cpr_rd_ben  ), // Writeback byte enable
.rng_cpr_rd_wdata(rng_cpr_rd_wdata) // Writeback data
);

endmodule
