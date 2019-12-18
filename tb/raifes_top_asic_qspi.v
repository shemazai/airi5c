`include "raifes_ctrl_constants.vh"
`include "raifes_csr_addr_map.vh"
`include "raifes_hasti_constants.vh"
`include "raifes_dmi_constants.vh"
`include "raifes_platform_constants.vh"

module raifes_top_asic_qspi(
		input   clk,
		input	clkQSPI,	// ASt, added 29.07.19
		input   reset,

		// scan chain interface for core

		input	sdi,
		output	sdo,
		input	sen,	
		
		// Connections to QSPI-Flash devices
		input iIRAM_IO0_In,
		output oIRAM_IO0_Out,
		output oIRAM_IO0_En,
		input iIRAM_IO1_In,
		output oIRAM_IO1_Out,
		output oIRAM_IO1_En,
		input iIRAM_IO2_In,
		output oIRAM_IO2_Out,
		output oIRAM_IO2_En,
		input iIRAM_IO3_In,
		output oIRAM_IO3_Out,
		output oIRAM_IO3_En,
		output oIRAM_SCK,
		output oIRAM_nCS,
		input iIRAM_nHSB,

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

	// Gemeinsamer-Memory-Bus (TODO: in zukünftigen Designs trennen und Arbiter vermeiden)
	// ================
	//

   wire [`HASTI_ADDR_WIDTH-1:0]                    mem_haddr;
   wire                                            mem_hwrite;
   wire [`HASTI_SIZE_WIDTH-1:0]                    mem_hsize;
   wire [`HASTI_BURST_WIDTH-1:0]                   mem_hburst;
   wire                                            mem_hmastlock;
   wire [`HASTI_PROT_WIDTH-1:0]                    mem_hprot;
   wire [`HASTI_TRANS_WIDTH-1:0]                   mem_htrans;
   wire [`HASTI_BUS_WIDTH-1:0]                     mem_hwdata;
   wire [`HASTI_BUS_WIDTH-1:0]                     mem_hrdata;
   wire                                            mem_hready;
   wire [`HASTI_RESP_WIDTH-1:0]                    mem_hresp;


	// Instruktions-Bus
	// ================
	//

   wire [`HASTI_ADDR_WIDTH-1:0]                    imem_haddr;
   wire                                            imem_hwrite;
   wire [`HASTI_SIZE_WIDTH-1:0]                    imem_hsize;
   wire [`HASTI_BURST_WIDTH-1:0]                   imem_hburst;
   wire                                            imem_hmastlock;
   wire [`HASTI_PROT_WIDTH-1:0]                    imem_hprot;
   wire [`HASTI_TRANS_WIDTH-1:0]                   imem_htrans;
   wire [`HASTI_BUS_WIDTH-1:0]                     imem_hwdata;
   wire [`HASTI_BUS_WIDTH-1:0]                     imem_hrdata;
   wire                                            imem_hready;
   wire [`HASTI_RESP_WIDTH-1:0]                    imem_hresp;

   
	// Daten-Bus und Peripherie-Bus-Multiplexer
	// ========================================
	//
	
   reg [`HASTI_ADDR_WIDTH-1:0]               	   dmem_haddr_r;

   wire [`HASTI_ADDR_WIDTH-1:0]               	   dmem_haddr;
   wire                                            dmem_hwrite;
   wire [`HASTI_SIZE_WIDTH-1:0]                    dmem_hsize;
   wire [`HASTI_BURST_WIDTH-1:0]                   dmem_hburst;
   wire                                            dmem_hmastlock;
   wire [`HASTI_PROT_WIDTH-1:0]                    dmem_hprot;
   wire [`HASTI_TRANS_WIDTH-1:0]                   dmem_htrans;
   wire [`HASTI_BUS_WIDTH-1:0]                     dmem_hwdata;
   wire	[`HASTI_BUS_WIDTH-1:0]			   dmem_hrdata;
   wire	[`HASTI_RESP_WIDTH-1:0]			   dmem_hresp;
   wire						   dmem_hready;

   wire	[`HASTI_BUS_WIDTH-1:0]			   per_hrdata;
   wire	[`HASTI_RESP_WIDTH-1:0]			   per_hresp;
   wire						   per_hready;


   raifes_qspi_if memory_if(
				.iReset(reset), 
				.iClkQSPI(clkQSPI),// ASt, added 26.07.19
				.iClk(clk),
				.iEnable(1'b1), // TODO

				.iIRAM_IO0_In(iIRAM_IO0_In),
				.oIRAM_IO0_Out(oIRAM_IO0_Out),
				.oIRAM_IO0_En(oIRAM_IO0_En),

				.iIRAM_IO1_In(iIRAM_IO1_In),
				.oIRAM_IO1_Out(oIRAM_IO1_Out),
				.oIRAM_IO1_En(oIRAM_IO1_En),

				.iIRAM_IO2_In(iIRAM_IO2_In),
				.oIRAM_IO2_Out(oIRAM_IO2_Out),
				.oIRAM_IO2_En(oIRAM_IO2_En),

				.iIRAM_IO3_In(iIRAM_IO3_In),
				.oIRAM_IO3_Out(oIRAM_IO3_Out),
				.oIRAM_IO3_En(oIRAM_IO3_En),

				.oIRAM_SCK(oIRAM_SCK),
				.oIRAM_nCS(oIRAM_nCS),
				.iIRAM_nHSB(iIRAM_nHSB),


				.imem_haddr(mem_haddr),
				.imem_hwrite(mem_hwrite),
				.imem_hsize(mem_hsize),
				.imem_hburst(mem_hburst),
				.imem_hmastlock(mem_hmastlock),
				.imem_hprot(mem_hprot),
				.imem_htrans(mem_htrans),
				.imem_hwdata(mem_hwdata),
				.imem_hrdata(mem_hrdata),
				.imem_hready(mem_hready),
				.imem_hresp(mem_hresp)
		);

	raifes_mem_arbiter memory_arbiter(
				.reset(reset),
				.clk(clk),

				.mem_haddr(mem_haddr),
				.mem_hwrite(mem_hwrite),
				.mem_hsize(mem_hsize),
				.mem_hmastlock(mem_hmastlock),
				.mem_hprot(mem_hprot),
				.mem_htrans(mem_htrans),
				.mem_hwdata(mem_hwdata),
				.mem_hrdata(mem_hrdata),
				.mem_hready(mem_hready),
				.mem_hresp(mem_hresp),
				
				.per_hrdata(per_hrdata),
				.per_hready(per_hready),
				.per_hresp(per_hresp),

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
				.dmem_hrdata(dmem_hrdata),
				.dmem_hready(dmem_hready),
				.dmem_hresp(dmem_hresp)
			);


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
			.dmem_hrdata(dmem_hrdata),
			.dmem_hready(dmem_hready), 
			.dmem_hresp(dmem_hresp),
			
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


