`include "raifes_hasti_constants.vh"

module raifes_sync_to_hasti_bridge(
			input									  clk,
			input									  reset,
                           output reg [`HASTI_ADDR_WIDTH-1:0]  dev_haddr,
                           output reg                         dev_hwrite,
                           output reg [`HASTI_SIZE_WIDTH-1:0]  dev_hsize,
                           output [`HASTI_BURST_WIDTH-1:0] dev_hburst,
                           output                          dev_hmastlock,
                           output [`HASTI_PROT_WIDTH-1:0]  dev_hprot,
                           output [`HASTI_TRANS_WIDTH-1:0] dev_htrans,
                           output [`HASTI_BUS_WIDTH-1:0]   dev_hwdata,
                           input [`HASTI_BUS_WIDTH-1:0]    dev_hrdata,
                           input                           dev_hready,
                           input [`HASTI_RESP_WIDTH-1:0]   dev_hresp,
				
                           input [`HASTI_ADDR_WIDTH-1:0]   core_haddr,
                           input                           core_hwrite,
                           input [`HASTI_SIZE_WIDTH-1:0]   core_hsize,
                           input [`HASTI_BURST_WIDTH-1:0]   core_hburst,
			               input			   core_hmastlock,
			               input [`HASTI_PROT_WIDTH-1:0]   core_hprot,
			               input [`HASTI_TRANS_WIDTH-1:0]  core_htrans,
                           input [`HASTI_BUS_WIDTH-1:0]    core_hwdata,
                           output [`HASTI_BUS_WIDTH-1:0]   core_hrdata,
                           output 	                   core_hready,
                           output [`HASTI_RESP_WIDTH-1:0]  core_hresp
                           );


   //assign haddr = core_mem_addr;
   //assign hwrite = core_mem_en && core_mem_wen;
   //assign hsize = core_mem_size;
   assign dev_hburst = `HASTI_BURST_SINGLE;
   assign dev_hmastlock = `HASTI_MASTER_NO_LOCK;
   assign dev_hprot = `HASTI_NO_PROT;
   assign dev_htrans = core_htrans;
   assign dev_hwdata = core_hwdata;
   //assign core_mem_rdata = hrdata;
   //assign core_mem_wait = ~hready;

	
   assign core_hresp = dev_hresp;//`HASTI_RESP_ERROR;

`define	PHASE_ADDR	1'b0
`define	PHASE_DATA	1'b1

	reg	current_phase;
	reg	next_phase;
	reg	[`HASTI_ADDR_WIDTH-1:0]	core_haddr_r;		
	reg	[`HASTI_SIZE_WIDTH-1:0] core_hsize_r;
	//reg	[`HASTI_BUS_WIDTH-1:0]	core_hrdata_r;
	assign core_hrdata = dev_hrdata;//core_hrdata_r;
	
	assign core_hready = (current_phase == `PHASE_DATA) ? 1'b0 : 1'b1;  

	always @(posedge clk) begin
		if(reset) begin 
			current_phase <= `PHASE_ADDR;
			core_haddr_r <= `HASTI_ADDR_WIDTH'h0;
			core_hsize_r <= `HASTI_SIZE_WIDTH'h2;
		end else begin
			current_phase <= next_phase;
			core_haddr_r <= core_haddr;			// store addr each cycle if required for write.
			core_hsize_r <= core_hsize;
		end
	end

	always @(*) begin
//		next_phase = (current_phase == `PHASE_DATA) ? `PHASE_ADDR : 
//							core_hwrite ? `PHASE_DATA : `PHASE_ADDR;
		next_phase = core_hwrite ? `PHASE_DATA : `PHASE_ADDR;

		dev_haddr = (current_phase == `PHASE_DATA) ? core_haddr_r : core_haddr;
		dev_hsize = (current_phase == `PHASE_DATA) ? core_hsize_r : core_hsize;

		dev_hwrite = (current_phase == `PHASE_DATA) ? 1'b1 : 1'b0;	// are we (still) writing?

		//core_mem_rdata_r = hrdata;
	end

endmodule // raifes_hasti_bridge

