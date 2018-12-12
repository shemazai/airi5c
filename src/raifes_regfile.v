`include "rv32_opcodes.vh"
`include "raifes_arch_options.vh"

module raifes_regfile(
		      // regular operation port
                      input                       clk,
                      input [`REG_ADDR_WIDTH-1:0] ra1,
                      output [`XPR_LEN-1:0]       rd1,
                      input [`REG_ADDR_WIDTH-1:0] ra2,
                      output [`XPR_LEN-1:0]       rd2,
                      input                       wen,
                      input [`REG_ADDR_WIDTH-1:0] wa,
                      input [`XPR_LEN-1:0]        wd,

		      // debug module port			
		      input [`REG_ADDR_WIDTH-1:0] dm_wara,	// 20.02.18, ASt: added debug module
		      input [`XPR_LEN-1:0]	  dm_wd,
		      input			  dm_wen,
		      output [`XPR_LEN-1:0]	  dm_rd

                      );

	`ifndef ISA_EXT_E
	   reg [`XPR_LEN-1:0]                             data [31:0];	// full 32 x 32 bit registers
	`else
	   reg [`XPR_LEN-1:0]				  data [15:0];	// reduces 16 x 32 bit registers
	`endif

   assign rd1 = |ra1 ? data[ra1] : 0;			// data[0] is unused and will be removed by synthesis.
   assign rd2 = |ra2 ? data[ra2] : 0;
   assign dm_rd = |dm_wara ? data[dm_wara] : 0;		// 20.02.18, ASt: added debug module 		

   always @(posedge clk) begin
	if(dm_wen) begin 
		data[dm_wara] <= dm_wd;					
	end
	else
	if(wen) begin
		data[wa] <= wd; 					
	end  
   end
	
endmodule // raifes_regfile
