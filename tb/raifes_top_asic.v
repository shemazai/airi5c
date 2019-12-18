`include "raifes_ctrl_constants.vh"
`include "raifes_csr_addr_map.vh"
`include "raifes_hasti_constants.vh"
`include "raifes_dmi_constants.vh"
`include "raifes_platform_constants.vh"

module raifes_top_asic(
		input   clk,
		input   reset,

		// scan chain interface for core

		input	sdi,
		output	sdo,
		input	sen,	

		// connections to dual-port sram

            output [`HASTI_ADDR_WIDTH-1:0]  imem_haddr,
            output                          imem_hwrite,
            output [`HASTI_SIZE_WIDTH-1:0]  imem_hsize,
            output [`HASTI_BURST_WIDTH-1:0] imem_hburst,
            output                          imem_hmastlock,
            output [`HASTI_PROT_WIDTH-1:0]  imem_hprot,
            output [`HASTI_TRANS_WIDTH-1:0] imem_htrans,
            output [`HASTI_BUS_WIDTH-1:0]   imem_hwdata,
            input [`HASTI_BUS_WIDTH-1:0]  imem_hrdata,
            input                         imem_hready,
            input                         imem_hresp,
            output [`HASTI_ADDR_WIDTH-1:0]  dmem_haddr,
            output                          dmem_hwrite,
            output [`HASTI_SIZE_WIDTH-1:0]  dmem_hsize,
            output [`HASTI_BURST_WIDTH-1:0] dmem_hburst,
            output                          dmem_hmastlock,
            output [`HASTI_PROT_WIDTH-1:0]  dmem_hprot,
            output [`HASTI_TRANS_WIDTH-1:0] dmem_htrans,
            output [`HASTI_BUS_WIDTH-1:0]   dmem_hwdata,
            input [`HASTI_BUS_WIDTH-1:0]  dmem_hrdata,
            input                         dmem_hready,
            input                         dmem_hresp,
	
		// Connection to Debug Transfer Module (JTAG-TAP)
		input		[`DMI_ADDR_WIDTH-1:0]	dmi_addr,
		input		[`DMI_WIDTH-1:0]	dmi_wdata,
		output		[`DMI_WIDTH-1:0]	dmi_rdata,
		input					dmi_en,
		input					dmi_wen,
		output					dmi_error,
		output					dmi_dm_busy,

		// -- Chip specific -- 
		// GPIOs
		output	[7:0]	oGPIO_D,
		output	[7:0]	oGPIO_EN,
		input	[7:0]	iGPIO_I,

		// -- Post-Synthesis debug port --
		output	reg	[7:0]	debug_out

);

   
// Daten-Bus- und Peripherie-Bus-Multiplexer
// ========================================
//
	

   wire	[`HASTI_BUS_WIDTH-1:0]			   per_hrdata;
   wire	[`HASTI_RESP_WIDTH-1:0]			   per_hresp;
   wire						   per_hready;

   reg [`HASTI_ADDR_WIDTH-1:0]               	   dmem_haddr_r;
   always @(posedge clk) begin
	if(reset) begin
		dmem_haddr_r <= `HASTI_ADDR_WIDTH'hdeadbeef;
	end else begin
		dmem_haddr_r <= dmem_haddr;
	end
   end

   wire [`HASTI_BUS_WIDTH-1:0]			   muxed_hrdata;
   assign muxed_hrdata = |(dmem_haddr_r & `PER_MASK) ? per_hrdata : dmem_hrdata;

   wire	[`HASTI_RESP_WIDTH-1:0]			   muxed_hresp;
   assign muxed_hresp = |(dmem_haddr_r & `PER_MASK) ? per_hresp : dmem_hresp;

   wire						   muxed_hready;
   assign muxed_hready = |(dmem_haddr_r & `PER_MASK) ? per_hready : dmem_hready;


	raifes_gpio gpio(
		.reset(reset),
		.clk(clk),

		.gpio_d(oGPIO_D),
		.gpio_en(oGPIO_EN),
		.gpio_i(iGPIO_I),

		.haddr(dmem_haddr),
		.hwrite(dmem_hwrite),
		.hsize(dmem_hsize),
		.hburst(dmem_hburst),
		.hmastlock(dmem_hmastlock),
		.hprot(dmem_hprot),
		.htrans(dmem_htrans),
		.hwdata(dmem_hwdata),
		.hrdata(per_hrdata),
		.hready(per_hready),
		.hresp(per_hresp)
	);

	
	// DMI Bus
	// =======
	//
	// Das Debug Module Interface (DMI) bildet die 
	// Verbindung des Transportmoduls (DTM), in diesem 
	// Fall ein JTAG-TAP, mit dem Debug Modul (DM)
	//
	
	raifes_core raifes(
		.reset(reset),
		.clk(clk),

		.ext_interrupts(`N_EXT_INTS'h0),
					
		.imem_haddr(imem_haddr),
		.imem_hwrite(imem_hwrite),
		.imem_hsize(imem_hsize),
		.imem_hburst(imem_hburst),
		.imem_hmastlock(imem_hmastlock),
		.imem_hprot(imem_hprot),
		.imem_htrans(imem_htrans),
		.imem_hwdata(imem_hwdata),
		.imem_hrdata(imem_hrdata),
		.imem_hready(imem_hready),
		.imem_hresp(imem_hresp),
					 
		.dmem_haddr(dmem_haddr),
		.dmem_hwrite(dmem_hwrite),
		.dmem_hsize(dmem_hsize),
		.dmem_hburst(dmem_hburst),
		.dmem_hmastlock(dmem_hmastlock),
		.dmem_hprot(dmem_hprot),
		.dmem_htrans(dmem_htrans),
		.dmem_hwdata(dmem_hwdata),
		.dmem_hrdata(muxed_hrdata),
		.dmem_hready(muxed_hready), 
		.dmem_hresp(muxed_hresp),
		
		.dmi_addr(dmi_addr),
		.dmi_en(dmi_en),
		.dmi_error(dmi_error),
		.dmi_wen(dmi_wen),
		.dmi_wdata(dmi_wdata),
		.dmi_rdata(dmi_rdata),
		.dmi_dm_busy(dmi_dm_busy)
	); 


reg [31:0] debug_addr;
reg	   debug_hwrite;

always @(posedge clk) begin
	debug_addr <= dmem_haddr;
	debug_hwrite <= dmem_hwrite;
	if((debug_addr == 32'h80001000) && (debug_hwrite))
	begin
		debug_out <= dmem_hwdata[7:0];

	end
	if((debug_addr == 32'hc0000000) && (debug_hwrite))
	begin
		$write("%c",dmem_hwdata[7:0]);

	end
end





endmodule // raifes_sim_top


