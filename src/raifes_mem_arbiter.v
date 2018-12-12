`include "raifes_hasti_constants.vh"
`include "raifes_platform_constants.vh"

module raifes_mem_arbiter(
	input	reset,
	input	clk,

	output	reg	[`HASTI_ADDR_WIDTH-1:0]  mem_haddr,
        output	reg			 mem_hwrite,			// 
        output	reg	[`HASTI_SIZE_WIDTH-1:0]  mem_hsize,
	output	reg	[`HASTI_BURST_WIDTH-1:0] mem_hburst,
        output	reg		   	 mem_hmastlock,
        output	reg	[`HASTI_PROT_WIDTH-1:0]  mem_hprot,
        output	reg	[`HASTI_TRANS_WIDTH-1:0] mem_htrans,
        output	reg	[`HASTI_BUS_WIDTH-1:0]   mem_hwdata,			// 
        input	[`HASTI_BUS_WIDTH-1:0]   mem_hrdata,
        input 			   	 mem_hready,
        input	[`HASTI_RESP_WIDTH-1:0]  mem_hresp,

        input	[`HASTI_BUS_WIDTH-1:0]   per_hrdata,			// peripheral response
        input 			   	 per_hready,
        input	[`HASTI_RESP_WIDTH-1:0]  per_hresp,

	input	[`HASTI_ADDR_WIDTH-1:0]  imem_haddr,
        input				imem_hwrite,			// unused, as imem is read-only (typically)
        input	[`HASTI_SIZE_WIDTH-1:0]  imem_hsize,
	input	[`HASTI_BURST_WIDTH-1:0] imem_hburst,
        input 			   	imem_hmastlock,
        input	[`HASTI_PROT_WIDTH-1:0]  imem_hprot,
        input	[`HASTI_TRANS_WIDTH-1:0] imem_htrans,
        input	[`HASTI_BUS_WIDTH-1:0]   imem_hwdata,			// unused, as imem is read-only (typically)
        output	reg	[`HASTI_BUS_WIDTH-1:0]    imem_hrdata,
        output 	reg			   	imem_hready,
        output	reg	[`HASTI_RESP_WIDTH-1:0]   imem_hresp,

	input	[`HASTI_ADDR_WIDTH-1:0]  dmem_haddr,
        input				dmem_hwrite,			// unused, as imem is read-only (typically)
        input	[`HASTI_SIZE_WIDTH-1:0]  dmem_hsize,
	input	[`HASTI_BURST_WIDTH-1:0] dmem_hburst,
        input 			   	dmem_hmastlock,
        input	[`HASTI_PROT_WIDTH-1:0]  dmem_hprot,
        input	[`HASTI_TRANS_WIDTH-1:0] dmem_htrans,
        input	[`HASTI_BUS_WIDTH-1:0]   dmem_hwdata,			// unused, as imem is read-only (typically)
        output	reg	[`HASTI_BUS_WIDTH-1:0]    dmem_hrdata,
        output 	reg			   	dmem_hready,
        output	reg	[`HASTI_RESP_WIDTH-1:0]   dmem_hresp);


`define RESET 4'hf
`define IDLE 4'h0
`define IMEM_START 4'h1
`define IMEM_WAITMEM 4'h2
`define DMEM_START 4'h3
`define DMEM_WAITMEM 4'h4
`define DMEM_WDATA 4'h5
`define IMEM_WDATA 4'h6

reg [3:0]	state, next_state;

reg [31:0]	pending_imem_addr;
reg [31:0]	pending_imem_wdata;
reg 		pending_imem_write;
reg [2:0]	pending_imem_size;
reg		pending_imem;
reg		got_dmem_htrans;

reg [31:0]	pending_dmem_addr;
reg [31:0]	pending_dmem_wdata;
reg 		pending_dmem_write;
reg [2:0]	pending_dmem_size;
reg		pending_dmem;
reg		got_imem_htrans;


wire	[`HASTI_BUS_WIDTH-1:0]	memory_response; assign memory_response = pending_dmem_addr[30] ? per_hrdata : mem_hrdata;
wire	[`HASTI_RESP_WIDTH-1:0]	memory_hresp; assign memory_hresp = pending_dmem_addr[30] ? per_hresp : mem_hresp;
wire	memory_ready; assign memory_ready = ((pending_dmem_addr[30] && per_hready) || (~pending_dmem_addr[30] && mem_hready)); 	// mux ready from relevant source


// if there is a dmem access, the pending 
// imem access will be performed afterwards.
// Thus we need to remember the pending imem request..

always @(posedge clk) begin
	if(reset) begin
		state <= `RESET;
		pending_dmem <= 1'b0;
		pending_imem <= 1'b0;
		got_dmem_htrans <= 1'b0;
		got_imem_htrans <= 1'b0;
	end else begin
		if(|dmem_htrans) begin
			pending_dmem_addr <= dmem_haddr;
			pending_dmem_write <= dmem_hwrite;
			pending_dmem_size <= dmem_hsize;
			pending_dmem <= 1'b1 && dmem_haddr[31];
			got_dmem_htrans <= 1'b1;
		end else got_dmem_htrans <= 1'b0;
		if(|imem_htrans) begin
			pending_imem_addr <= imem_haddr;
			pending_imem_write <= imem_hwrite;
			pending_imem_size <= imem_hsize;
			pending_imem <= 1'b1 && imem_haddr[31];
			got_imem_htrans <= 1'b1;
		end else got_imem_htrans <= 1'b0;
		if(state == `DMEM_WAITMEM) begin
			if(mem_hready) begin
				dmem_hrdata <= memory_response; // mem_hrdata;
				dmem_hresp <= memory_hresp; //mem_hresp;
				pending_dmem <= 1'b0;
			end		
		end
		if(state == `IMEM_WAITMEM) begin
			if(mem_hready) begin
				imem_hrdata <= mem_hrdata;
				imem_hresp <= mem_hresp;
				pending_imem <= 1'b0;
			end		
		end

		/*if(state == `IMEM_WDATA) pending_imem_wdata <= imem_hwdata;
		if(state == `DMEM_WDATA) pending_dmem_wdata <= dmem_hwdata;*/
		if(got_imem_htrans) pending_imem_wdata <= imem_hwdata;
		if(got_dmem_htrans) pending_dmem_wdata <= dmem_hwdata;

		state <= next_state;
	end
end



always @(*) begin
	imem_hready = 1'b0;
	dmem_hready = 1'b0;
	mem_haddr = 0;
	mem_hwrite = 0;
	mem_hsize = 0;
	mem_hburst = 0;
	mem_hmastlock = 1'h0;
	mem_hprot = 4'h0;
	mem_htrans = 2'h0;
	mem_hwdata = 0;

	case (state) 
	`RESET  :	begin	
				next_state = `IMEM_START;
			end
	`IDLE 	:	begin	
				imem_hready = 1'b1;
				dmem_hready = 1'b1;
				if(|dmem_htrans && dmem_haddr[31]) begin
					next_state = dmem_hwrite ? `DMEM_WDATA : `DMEM_START;
				end else 
				if(|imem_htrans && imem_haddr[31]) begin
					next_state = imem_hwrite ? `IMEM_WDATA : `IMEM_START;
				end else next_state = `IDLE;
			end
	`IMEM_WDATA : begin 
				next_state = `IMEM_START;
			end
	`IMEM_START :	begin		
				next_state = (|imem_htrans && imem_haddr[31]) ? `IMEM_START : `IMEM_WAITMEM;
				mem_haddr = pending_imem_addr;
				mem_hwrite = pending_imem_write;
				mem_hsize = pending_imem_size;
				mem_hburst = 0;
				mem_hmastlock = 0;
				mem_hprot = 0;
				mem_htrans = 2'b11;
				mem_hwdata = pending_imem_wdata;	
			end
	`IMEM_WAITMEM : begin 
				mem_haddr = pending_imem_addr;
				mem_hwrite = pending_imem_write;
				mem_hsize = pending_imem_size;
				mem_hburst = 0;
				mem_hmastlock = 0;
				mem_hprot = 0;
				mem_htrans = 2'b00;
				mem_hwdata = pending_imem_wdata;	

				next_state = (|imem_htrans && imem_haddr[31]) ? `IMEM_START : (mem_hready ? (pending_dmem ? `DMEM_START : `IDLE ) : `IMEM_WAITMEM);
			end
	`DMEM_WDATA : begin 
				next_state = `DMEM_START;
		end
	`DMEM_START :	begin
				next_state = (|dmem_htrans && dmem_haddr[31]) ? `DMEM_START : `DMEM_WAITMEM;
				mem_haddr = pending_dmem_addr;
				mem_hwrite = pending_dmem_write;
				mem_hsize = pending_dmem_size;
				mem_hburst = 0;
				mem_hmastlock = 0;
				mem_hprot = 0;
				mem_htrans = 2'b11;
				mem_hwdata = pending_dmem_wdata;	
			end
	`DMEM_WAITMEM :	begin
				mem_haddr = pending_dmem_addr;
				mem_hwrite = pending_dmem_write;
				mem_hsize = pending_dmem_size;
				mem_hburst = 0;
				mem_hmastlock = 0;
				mem_hprot = 0;
				mem_htrans = 2'b00;
				mem_hwdata = pending_dmem_wdata;	
				// next_state = (|dmem_htrans && dmem_haddr[31]) ? `DMEM_START : (mem_hready ? (pending_imem ? `IMEM_START : `IDLE ) : `DMEM_WAITMEM);	// after dmem finishes, there is always an imem request pending
				next_state = (|dmem_htrans && dmem_haddr[31]) ? `DMEM_START : (memory_ready ? (pending_imem ? `IMEM_START : `IDLE ) : `DMEM_WAITMEM);	// after dmem finishes, there is always an imem request pending
			end



	endcase
end

endmodule 
