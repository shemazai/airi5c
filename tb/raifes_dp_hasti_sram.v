`include "raifes_hasti_constants.vh"

module vscale_dp_hasti_sram(
                            input                          hclk,
                            input                          hresetn,
                            input [`HASTI_ADDR_WIDTH-1:0]  p0_haddr,
                            input                          p0_hwrite,
                            input [`HASTI_SIZE_WIDTH-1:0]  p0_hsize,
                            input [`HASTI_BURST_WIDTH-1:0] p0_hburst,
                            input                          p0_hmastlock,
                            input [`HASTI_PROT_WIDTH-1:0]  p0_hprot,
                            input [`HASTI_TRANS_WIDTH-1:0] p0_htrans,
                            input [`HASTI_BUS_WIDTH-1:0]   p0_hwdata,
                            output [`HASTI_BUS_WIDTH-1:0]  p0_hrdata,
                            output                         p0_hready,
                            output                         p0_hresp,
                            input [`HASTI_ADDR_WIDTH-1:0]  p1_haddr,
                            input                          p1_hwrite,
                            input [`HASTI_SIZE_WIDTH-1:0]  p1_hsize,
                            input [`HASTI_BURST_WIDTH-1:0] p1_hburst,
                            input                          p1_hmastlock,
                            input [`HASTI_PROT_WIDTH-1:0]  p1_hprot,
                            input [`HASTI_TRANS_WIDTH-1:0] p1_htrans,
                            input [`HASTI_BUS_WIDTH-1:0]   p1_hwdata,
                            output [`HASTI_BUS_WIDTH-1:0]  p1_hrdata,
                            output                         p1_hready,
                            output                         p1_hresp
                            );

   parameter nwords = 65536;


   reg [`HASTI_BUS_WIDTH-1:0]                              mem [nwords-1:0];

   // p0

   // flops
   reg [`HASTI_ADDR_WIDTH-1:0]                             p0_addr_r;
   wire [`HASTI_ADDR_WIDTH-1:0]                            p0_word_addr = p0_addr_r >> 2;


   reg [`HASTI_SIZE_WIDTH-1:0]                             p0_size_r;

   reg [1:0]                                               p0_state;
   reg [1:0]						   p0_next_state;

   reg [`HASTI_BUS_WIDTH-1:0]				   p0_rdata;

   wire [`HASTI_BUS_NBYTES-1:0]                            p0_wmask_lut = (p0_size_r == 0) ? `HASTI_BUS_NBYTES'h1 : (p0_size_r == 1) ? `HASTI_BUS_NBYTES'h3 : `HASTI_BUS_NBYTES'hf;
   wire [`HASTI_BUS_NBYTES-1:0]                            p0_wmask_shift = p0_wmask_lut << p0_addr_r[1:0];
   wire [`HASTI_BUS_WIDTH-1:0]                             p0_wmask = {{8{p0_wmask_shift[3]}},{8{p0_wmask_shift[2]}},{8{p0_wmask_shift[1]}},{8{p0_wmask_shift[0]}}};


//   wire [`HASTI_ADDR_WIDTH-1:0]                            p0_raddr = p0_haddr >> 2;
//   wire                                                    p0_ren = (p0_htrans == `HASTI_TRANS_NONSEQ && !p0_hwrite);
//   reg                                                     p0_bypass;
//   reg [`HASTI_ADDR_WIDTH-1:0]                             p0_reg_raddr;

   assign p0_hrdata = p0_rdata;
   assign p0_hready = 1'b1;
   assign p0_hresp = `HASTI_RESP_OKAY;


	always @(posedge hclk) begin
		if(!hresetn) begin
			p0_state <= 2'b00;
			p0_addr_r <= `HASTI_ADDR_WIDTH'h0;
			p0_size_r <= `HASTI_SIZE_WIDTH'h2;
		end else begin
			p0_state <= p0_next_state;
			p0_addr_r <= p0_haddr;			// read addr every cycle (but maybe don't use it.)
			p0_size_r <= p0_hsize;
			if(p0_state == 2'b10)
				mem[p0_word_addr] <= (mem[p0_word_addr] & ~p0_wmask) | (p0_hwdata & p0_wmask);//  p0_hwdata;	// write on next clock if in WRITE state.
		end
	end

	always @* begin
		p0_next_state = 2'b00;		// default: goto IDLE.
		p0_rdata = `HASTI_BUS_WIDTH'h0;	// when read is inactive, output 0.

		case(p0_state)
		2'b00	:	begin									// IDLE - ADDR CYCLE
					p0_next_state = (p0_htrans != `HASTI_TRANS_NONSEQ) ? 2'b00 :
							p0_hwrite ? 2'b10 : 2'b01;			
				end
		2'b01	:	begin									// READ - DATA CYLCE
					p0_next_state = (p0_htrans != `HASTI_TRANS_NONSEQ) ? 2'b00 :	// if last Read/Write, go back to IDLE.
							p0_hwrite ? 2'b10 : 2'b01;

					p0_rdata = mem[p0_word_addr];					// read data from sampled addr.
				end
		2'b10	:	begin									// WRITE - DATA CYCLE
					p0_next_state = (p0_htrans != `HASTI_TRANS_NONSEQ) ? 2'b00 :	// if last Read/Write, go back to IDLE.
							p0_hwrite ? 2'b10 : 2'b01;
					p0_rdata = mem[p0_word_addr];		
				end
		2'b11	:	begin
				end
		default : 	begin end
		endcase
	end
	



/*   always @(posedge hclk) begin
      p0_reg_raddr <= p0_raddr;					// read read-addr each cycle
      if (!hresetn) begin
         p0_state <= s_w1;
         p0_wvalid <= 1'b0;
         p0_bypass <= 1'b0;
         p0_waddr <= 0;
         p0_wdata <= 0;
         p0_reg_raddr <= 0;
      end else begin
	 p0_word_waddr_r <= p0_word_waddr;
	 p0_wvalid_r <= p0_wvalid;
         if (p0_state == s_w2) begin				// if we received an address last cycle..
            p0_wdata <= p0_hwdata;				// we clock in the data word
            p0_state <= s_w1;					// and reset our state..
         end
         if (p0_htrans == `HASTI_TRANS_NONSEQ) begin
            if (p0_hwrite) begin
               p0_waddr <= p0_haddr;
               p0_wsize <= p0_hsize;
               p0_wvalid <= 1'b1;
               p0_state <= s_w2;
            end else begin
               p0_bypass <= p0_wvalid && p0_word_waddr == p0_raddr;
	       p0_wvalid <= 1'b0;
            end

          // if (p0_htrans == `HASTI_TRANS_NONSEQ)
            if (p0_wvalid_r) begin
               mem[p0_word_waddr_r] <= (mem[p0_word_waddr_r] & ~p0_wmask) | (p0_wdata & p0_wmask);
            end
	end

      end*/
/*         if (p0_state == s_w2) begin
            p0_wdata <= p0_hwdata;
            p0_state <= s_w1;
         end
         if (p0_htrans == `HASTI_TRANS_NONSEQ) begin
            if (p0_hwrite) begin
               p0_waddr <= p0_haddr;
               p0_wsize <= p0_hsize;
               p0_wvalid <= 1'b1;
               if (p0_wvalid) begin
                  mem[p0_word_waddr] <= (mem[p0_word_waddr] & ~p0_wmask) | (p0_wdata & p0_wmask);
//                  mem[p0_word_waddr] <= (mem[p0_word_waddr] & ~p0_wmask) | (p0_hwdata & p0_wmask);
               end
               p0_state <= s_w2;
            end else begin
               p0_bypass <= p0_wvalid && p0_word_waddr == p0_raddr;
            end
         end // if (p0_htrans == `HASTI_TRANS_NONSEQ)
      end*/
//   end

/*   wire [`HASTI_BUS_WIDTH-1:0] p0_rdata = (p0_reg_raddr == 1040 || p0_reg_raddr == 1041) ? `HASTI_BUS_WIDTH'h13371337 : mem[p0_reg_raddr];
   wire [`HASTI_BUS_WIDTH-1:0] p0_rmask = {32{p0_bypass}} & p0_wmask;
   assign p0_hrdata = (p0_wdata & p0_rmask) | (p0_rdata & ~p0_rmask);
   assign p0_hready = 1'b1;
   assign p0_hresp = `HASTI_RESP_OKAY;*/



   // p1

   wire [`HASTI_ADDR_WIDTH-1:0] p1_raddr = p1_haddr >> 2;
   wire                         p1_ren = (p1_htrans == `HASTI_TRANS_NONSEQ && !p1_hwrite);
   reg                          p1_bypass;
   reg [`HASTI_ADDR_WIDTH-1:0]  p1_reg_raddr;

   always @(posedge hclk) begin
      p1_reg_raddr <= p1_raddr;
      if (!hresetn) begin
         p1_bypass <= 0;
      end else begin
         if (p1_htrans == `HASTI_TRANS_NONSEQ) begin
            if (p1_hwrite) begin
            end else begin
//               p1_bypass <= p0_wvalid && p0_word_waddr == p1_raddr;
               p1_bypass <= (p0_state == 2'b10) && (p0_word_addr == p1_raddr);
            end
         end // if (p1_htrans == `HASTI_TRANS_NONSEQ)
      end
   end

   wire [`HASTI_BUS_WIDTH-1:0] p1_rdata = mem[p1_reg_raddr];
   wire [`HASTI_BUS_WIDTH-1:0] p1_rmask = {32{p1_bypass}};// & p0_wmask;
   assign p1_hrdata = (p0_hwdata & p1_rmask) | (p1_rdata & ~p1_rmask);
   assign p1_hready = 1'b1;
   assign p1_hresp = `HASTI_RESP_OKAY;

   integer i = 0;

//   initial begin
//	$strobe("reading mem file ..");	
//	$readmemh("./memfiles/rv32ui-p-add.mem",mem);
//$readmemh("imem_data.hex",mem);
//	$readmemh("rvp-add.hex",mem, 0, 16000);
	/*for(i = 0; i < (nwords-1); i = i + 1) begin
		$strobe("%h", mem[i]);
	end*/
//	$strobe("done.");
//   end

endmodule // vscale_dp_hasti_sram

