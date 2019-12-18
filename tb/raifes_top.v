`include "raifes_ctrl_constants.vh"
`include "raifes_csr_addr_map.vh"
`include "raifes_hasti_constants.vh"
`include "raifes_dmi_constants.vh"
`include "raifes_platform_constants.vh"


////////////////////////////////////////////////////////////////////////////////
// Company: Fraunhofer IMS
// Engineer: A. Stanitzki
//
// Create Date: 08.06.2018
// Design Name: raifes
// Module Name: raifes_top
// Target Device: <target device>
// Tool versions: <tool_versions>
// Description:
//    <Description here>
// Dependencies:
//    <Dependencies here>
// Revision:
//    <Code_revision_information>
// Additional Comments:
//    <Additional_comments>
////////////////////////////////////////////////////////////////////////////////			

module raifes_top(
		input                   clk,
		input                   reset,
		
		input						tck,
		input						tms,
		input						tdi,
		output					tdo,
		
		output	[3:0]				dm_state,

		// System bus port for periphery
		output					per_en,			// enable periphery in general
		output	[`HASTI_ADDR_WIDTH-1:0]		per_haddr,
		output					per_hwrite,
		output	[`HASTI_SIZE_WIDTH-1:0]		per_hsize,
		output	[`HASTI_BURST_WIDTH-1:0]	per_hburst,
		output					per_hmastlock,
		output	[`HASTI_TRANS_WIDTH-1:0]	per_htrans,
		output	[`HASTI_BUS_WIDTH-1:0]		per_hwdata,		
		input	[`HASTI_BUS_WIDTH-1:0]		per_hrdata,
		input					per_hready,
		input	[`HASTI_RESP_WIDTH-1:0]		per_hresp
);


	// Bei Bedarf hier das invertierte Reset-Signal
   /*wire                                            resetn;
   assign resetn = ~reset;*/

	// Instruktions-Bus
	// ================
	//
	// Aktuell führen Daten- und Instruktions-Bus zum gleichen 
	// (internen) BlockRAM.

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

   wire [`HASTI_ADDR_WIDTH-1:0]                    imem_haddr_core;
   wire                                            imem_hwrite_core;
   wire [`HASTI_SIZE_WIDTH-1:0]                    imem_hsize_core;
   wire [`HASTI_BURST_WIDTH-1:0]                   imem_hburst_core;
   wire                                            imem_hmastlock_core;
   wire [`HASTI_PROT_WIDTH-1:0]                    imem_hprot_core;
   wire [`HASTI_TRANS_WIDTH-1:0]                   imem_htrans_core;
   wire [`HASTI_BUS_WIDTH-1:0]                     imem_hwdata_core;
   wire [`HASTI_BUS_WIDTH-1:0]                     imem_hrdata_core;
   wire                                            imem_hready_core;
   wire [`HASTI_RESP_WIDTH-1:0]                    imem_hresp_core;


   
	// Daten-Bus und Peripherie-Bus-Multiplexer
	// ========================================
	//
	// Aktuell führen Daten- und Instruktions-Bus zum gleichen 
	// (internen) BlockRAM.
	
	wire [`HASTI_ADDR_WIDTH-1:0]               dmem_haddr;
   wire                                            dmem_hwrite;
   wire [`HASTI_SIZE_WIDTH-1:0]                    dmem_hsize;
   wire [`HASTI_BURST_WIDTH-1:0]                   dmem_hburst;
   wire                                            dmem_hmastlock;
   wire [`HASTI_PROT_WIDTH-1:0]                    dmem_hprot;
   wire [`HASTI_TRANS_WIDTH-1:0]                   dmem_htrans;
   wire [`HASTI_BUS_WIDTH-1:0]                     dmem_hwdata;
   wire [`HASTI_BUS_WIDTH-1:0]                     dmem_hrdata;
   wire                                            dmem_hready;
   wire [`HASTI_RESP_WIDTH-1:0]                    dmem_hresp;

   wire [`HASTI_ADDR_WIDTH-1:0]               dmem_haddr_core;
   wire                                            dmem_hwrite_core;
   wire [`HASTI_SIZE_WIDTH-1:0]                    dmem_hsize_core;
   wire [`HASTI_BURST_WIDTH-1:0]                   dmem_hburst_core;
   wire                                            dmem_hmastlock_core;
   wire [`HASTI_PROT_WIDTH-1:0]                    dmem_hprot_core;
   wire [`HASTI_TRANS_WIDTH-1:0]                   dmem_htrans_core;
   wire [`HASTI_BUS_WIDTH-1:0]                     dmem_hwdata_core;
   wire [`HASTI_BUS_WIDTH-1:0]                     dmem_hrdata_core;
   wire                                            dmem_hready_core;
   wire [`HASTI_RESP_WIDTH-1:0]                    dmem_hresp_core;
	
	
	// die Signale vom Core zum DBUS werden einfach zu den 
	// Peripherie-Geräten durchgeschleift..
	assign	per_haddr = dmem_haddr;
	assign	per_hwrite = dmem_hwrite;
	assign	per_hsize = dmem_hsize;
	assign	per_hburst = dmem_hburst;
	assign	per_hmastlock = dmem_hmastlock;
	//assign	per_hprot = dmem_hprot; TODO: unused, include in top I/O ?
	assign	per_htrans = dmem_htrans;
	assign	per_hwdata = dmem_hwdata;

	// .. beim Rückweg hängt entweder das Blockram am DBUS, 
	// oder eines der Peripheriegeräte, abhängig von der Adresse.
	
	wire	[`HASTI_BUS_WIDTH-1:0]	blockram_hrdata;
	wire	[`HASTI_BUS_WIDTH-1:0]	periphery_hrdata;
	
	wire									blockram_hready;
	wire									periphery_hready;

	wire	[`HASTI_RESP_WIDTH-1:0]	blockram_hresp;
	wire	[`HASTI_RESP_WIDTH-1:0]	periphery_hresp;
	
	
	wire	[`HASTI_BUS_WIDTH-1:0]	hrdata_muxed;
	wire									hready_muxed;
	wire	[`HASTI_RESP_WIDTH-1:0]	hresp_muxed;
	
	// Adress-Dekoder
	assign	per_en		 = (dmem_haddr[31:24] == 8'h81) ? 1'b1 : 1'b0;	// set periphery enable and let periphery handle the rest of decoding.
//	assign	hrdata_muxed = (dmem_haddr[31:24] == 8'h81) ? periphery_hrdata : blockram_hrdata;	// Periphery ist an Addr. 0x81000000 - 0x81ffffffff
//	assign	hready_muxed = (dmem_haddr[31:24] == 8'h81) ? periphery_hready : blockram_hready;
//	assign	hresp_muxed	 = (dmem_haddr[31:24] == 8'h81) ? periphery_hresp : blockram_hresp;
	
	// DMI Bus
	// =======
	//
	// Das Debug Module Interface (DMI) bildet die 
	// Verbindung des Transportmoduls (DTM), in diesem 
	// Fall ein JTAG-TAP, mit dem Debug Modul (DM)
	//
	
   wire [`DMI_ADDR_WIDTH-1:0]								dmi_addr;
   wire [`DMI_WIDTH-1:0]									dmi_wdata;
   wire	[`DMI_WIDTH-1:0]									dmi_rdata;
   wire															dmi_en;
   wire															dmi_error;
   wire															dmi_wen;
   wire															dmi_dm_busy;

	raifes_core raifes(
						.reset(reset),
						 .clk(clk),
						.ext_interrupts(`N_EXT_INTS'h0),
						
						 .imem_haddr(imem_haddr_core),
						 .imem_hwrite(imem_hwrite_core),
						 .imem_hsize(imem_hsize_core),
						 .imem_hburst(imem_hburst_core),
						 .imem_hmastlock(imem_hmastlock_core),
						 .imem_hprot(imem_hprot_core),
						 .imem_htrans(imem_htrans_core),
						 .imem_hwdata(imem_hwdata_core),
						 .imem_hrdata(imem_hrdata_core),
						 .imem_hready(1'b1), // imem_hready),
						 .imem_hresp(1'b0), // imem_hresp),
						 
						 .dmem_haddr(dmem_haddr_core),
						 .dmem_hwrite(dmem_hwrite_core),
						 .dmem_hsize(dmem_hsize_core),
						 .dmem_hburst(dmem_hburst_core),
						 .dmem_hmastlock(dmem_hmastlock_core),
						 .dmem_hprot(dmem_hprot_core),
						 .dmem_htrans(dmem_htrans_core),
						 .dmem_hwdata(dmem_hwdata_core),
						 .dmem_hrdata(dmem_hrdata_core), // hrdata_muxed), // dmem_hrdata
						 .dmem_hready(dmem_hready_core), 
						 .dmem_hresp(1'b0), // dmem_hresp), TODO
			
			.dmi_addr(dmi_addr),
			.dmi_en(dmi_en),
			.dmi_error(dmi_error),
			.dmi_wen(dmi_wen),
			.dmi_wdata(dmi_wdata),
			.dmi_rdata(dmi_rdata),
			.dmi_dm_busy(dmi_dm_busy),
			.dm_state(dm_state)
						 ); 



raifes_dtm	dtm(
		.tck(tck),
		.tms(tms),
		.tdi(tdi),
		.tdo(tdo),		
		.dmi_addr(dmi_addr),
		.dmi_en(dmi_en),
		.dmi_error(dmi_error),
		.dmi_wen(dmi_wen),
		.dmi_wdata(dmi_wdata),
		.dmi_rdata(dmi_rdata),
		.dmi_dm_busy(dmi_dm_busy),
		.debug_state(debug_state)
		);

raifes_sync_to_hasti_bridge imem_bridge(
				   .clk(clk),
		 		   .reset(reset),
                                   .dev_haddr(imem_haddr),
                                   .dev_hwrite(imem_hwrite),
                                   .dev_hsize(imem_hsize),
                                   .dev_hburst(imem_hburst),
                                   .dev_hmastlock(imem_hmastlock),
                                   .dev_hprot(imem_hprot),
                                   .dev_htrans(imem_htrans),
                                   .dev_hwdata(imem_hwdata),
                                   .dev_hrdata(imem_hrdata),
                                   .dev_hready(1'b1),
                                   .dev_hresp(1'b0),

                                   .core_haddr(imem_haddr_core),
                                   .core_hwrite(imem_hwrite_core),
                                   .core_hsize(imem_hsize_core),
                                   .core_hburst(imem_hburst_core),
                                   .core_hmastlock(imem_hmastlock_core),
                                   .core_hprot(imem_hprot_core),
                                   .core_htrans(imem_htrans_core),
                                   .core_hwdata(imem_hwdata_core),
                                   .core_hrdata(imem_hrdata_core),
                                   .core_hready(imem_hready_core),
                                   .core_hresp(imem_hresp_core)
                                   );

raifes_sync_to_hasti_bridge dmem_bridge(
				   .clk(clk),
		 		   .reset(reset),
                                   .dev_haddr(dmem_haddr),
                                   .dev_hwrite(dmem_hwrite),
                                   .dev_hsize(dmem_hsize),
                                   .dev_hburst(dmem_hburst),
                                   .dev_hmastlock(dmem_hmastlock),
                                   .dev_hprot(dmem_hprot),
                                   .dev_htrans(dmem_htrans),
                                   .dev_hwdata(dmem_hwdata),
                                   .dev_hrdata(dmem_hrdata),
                                   .dev_hready(1'b1),
                                   .dev_hresp(1'b0),

                                   .core_haddr(dmem_haddr_core),
                                   .core_hwrite(dmem_hwrite_core),
                                   .core_hsize(dmem_hsize_core),
                                   .core_hburst(dmem_hburst_core),
                                   .core_hmastlock(dmem_hmastlock_core),
                                   .core_hprot(dmem_hprot_core),
                                   .core_htrans(dmem_htrans_core),
                                   .core_hwdata(dmem_hwdata_core),
                                   .core_hrdata(dmem_hrdata_core),
                                   .core_hready(dmem_hready_core),
                                   .core_hresp(dmem_hresp_core)
                                   );									 
									 
wire	[3:0]	writea; assign writea = ~dmem_hwrite ? 4'b0000 :
					per_en ? 4'b0000 :					
					(dmem_hsize == 2) ? 4'b1111 :
					(dmem_hsize == 1) ? (4'b0011 << dmem_haddr[1:0]) :
					(dmem_hsize == 0) ? (4'b0001 << dmem_haddr[1:0]) :
					4'b0000;

wire	[3:0]	writeb; assign writeb = ~imem_hwrite ? 4'b0000 : 
					per_en ? 4'b0000 : 
					(imem_hsize == 2) ? 4'b1111 :
					(imem_hsize == 1) ? (4'b0011  << imem_haddr[1:0]) :
					(imem_hsize == 0) ? (4'b0001  << imem_haddr[1:0]) :
					4'b0000;

wire	[`HASTI_BUS_WIDTH-1:0]	dmem_shifted_wdata;

assign dmem_shifted_wdata = (dmem_hwdata << {dmem_haddr[1:0],3'b00});

wire	[`HASTI_BUS_WIDTH-1:0]	imem_shifted_wdata;

assign imem_shifted_wdata = (imem_hwdata << {imem_haddr[1:0],3'b00});


RAMB36 myRAM
//RAMB36_model myRAM
	(
	.DIA(dmem_shifted_wdata),		// Data In
	.DIPA(4'h0),			// Parity In
	.ADDRA(dmem_haddr[17:2]<<5),	// Addr In (16 Bit!)
	.WEA(writea),			// byte-wise write enable
	.ENA(1'b1),
	.REGCEA(1'b0),				// no registered output
	.SSRA(1'b0),				// no output reset to default value
	
	.DOA(dmem_hrdata),
	.CLKA(clk),
	
	.DIB(imem_shifted_wdata),
	.DIPB(4'h0),
	.ADDRB(imem_haddr[17:2]<<5),
	.WEB(writeb),
	.ENB(1'b1),
	.REGCEB(1'b0),
	.SSRB(1'b0),
	.DOB(imem_hrdata),
		
	.CLKB(clk)
);

defparam myRAM.INIT_00 = 64'hdeadbeefcafebabe;
defparam myRAM.READ_WIDTH_A = 36;
defparam myRAM.READ_WIDTH_B = 36;
defparam myRAM.WRITE_WIDTH_A = 36;
defparam myRAM.WRITE_WIDTH_B = 36;


endmodule // raifes_sim_top
