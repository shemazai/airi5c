// AHB-Lite nach QSPI-Interface für 
// Cypress CY14V101QS-Flash-Baustein.
//
// - unterstützt byte / half-word / word-zugriff (verwendet dafür burst-reads/-writes)
// - unterstützt hardcoded Startup-Sequenz, um Baustein zu konfigurieren

`timescale 1ns / 1ps
`include "raifes_hasti_constants.vh"

// QSPI memory interface 

`define QSPI_IDLE 0
`define QSPI_START 1
`define QSPI_CLOCK 2
`define QSPI_SHIFT 4
`define QSPI_PAUSE 5
`define QSPI_END 8
`define QSPI_RESTART 3

`define CMD_READ 4'b0000
`define CMD_READH 4'b0001
`define CMD_READW 4'b0010
// write byte
`define CMD_WRITE 4'b0100
// write halfword
`define CMD_WRITEH 4'b0101
// write word
`define CMD_WRITEW 4'b0110

`define CMD_WREN 4'b1000
`define CMD_QPIEN 4'b1001
`define CMD_WRCR 4'b1010

`define OPCODE_WREN 8'b00000110
`define OPCODE_READ 8'b00000011
`define OPCODE_WRITE 8'b00000010
`define OPCODE_WRCR 8'b10000111
`define OPCODE_QPIEN 8'b00111000

`define MODE_SPI 2'b00
`define MODE_DPI 2'b01
`define MODE_QPI 2'b10

`define FSM_RESET 0
`define FSM_STARTUP 1
`define FSM_IDLE 2
`define FSM_FETCHFIRST 7
`define FSM_READ 3
`define FSM_WRITE 4
`define FSM_WAITFINISH 5
`define FSM_FINISH 6

`define STARTUP_SEQ_LENGTH 4

module raifes_qspi_if(
		
	input	iReset,	input	iClk,     	
	input	iEnable,

	// Memory interfaces - Instructions

	input	iIRAM_IO0_In,
	output	reg	oIRAM_IO0_Out,
	output	reg	oIRAM_IO0_En,

	input	iIRAM_IO1_In,
	output	reg	oIRAM_IO1_Out,
	output	reg	oIRAM_IO1_En,

	input	iIRAM_IO2_In,
	output	reg	oIRAM_IO2_Out,
	output	reg	oIRAM_IO2_En,

	input	iIRAM_IO3_In,
	output	reg	oIRAM_IO3_Out,
	output	reg	oIRAM_IO3_En,

	output	reg	oIRAM_SCK,
	output	reg	oIRAM_nCS,
	input		iIRAM_nHSB,

        input	[`HASTI_ADDR_WIDTH-1:0]  imem_haddr,
        input				imem_hwrite,			// unused, as imem is read-only (typically)
        input	[`HASTI_SIZE_WIDTH-1:0]  imem_hsize,
	input	[`HASTI_BURST_WIDTH-1:0] imem_hburst,
        input 			   	imem_hmastlock,
        input	[`HASTI_PROT_WIDTH-1:0]  imem_hprot,
        input	[`HASTI_TRANS_WIDTH-1:0] imem_htrans,
        input	[`HASTI_BUS_WIDTH-1:0]   imem_hwdata,			// unused, as imem is read-only (typically)
        output	reg	[`HASTI_BUS_WIDTH-1:0]    imem_hrdata,
        output 				   	imem_hready,
        output	reg	[`HASTI_RESP_WIDTH-1:0]   imem_hresp
);

// IRAM section

reg		spi_en; 
reg		spi_finished;
reg	[1:0]	spi_mode; 	// 00 - SPI, 01 - DPI, 10 - QPI
reg	[3:0]	spi_cmd_type;	
reg	[23:0]	spi_addr;
reg	[31:0]	spi_wdata;
//reg	[31:0]	spi_rdata;

reg	[3:0]	spi_state, spi_next_state;

always @(posedge iClk) begin
	if(iReset) begin
		spi_state <= `QSPI_IDLE;
	end else begin
		spi_state <= spi_next_state;
	end
end

reg	[6:0]	cyclecnt;
reg	[63:0]	shiftreg;

wire		write_operation; assign write_operation = (spi_cmd_type == `CMD_WREN) || (spi_cmd_type == `CMD_WRITE) || (spi_cmd_type == `CMD_WRCR)
								|| (spi_cmd_type == `CMD_WRITEH) || (spi_cmd_type == `CMD_WRITEW);

wire	[7:0]	opcode; assign opcode = ((spi_cmd_type == `CMD_READ) || (spi_cmd_type == `CMD_READH) || (spi_cmd_type == `CMD_READW)) ? `OPCODE_READ : 
					((spi_cmd_type == `CMD_WRITE) || (spi_cmd_type == `CMD_WRITEH) || (spi_cmd_type == `CMD_WRITEW)) ? `OPCODE_WRITE : 
					(spi_cmd_type == `CMD_WRCR) ? `OPCODE_WRCR : 
					(spi_cmd_type == `CMD_QPIEN) ? `OPCODE_QPIEN : 
					(spi_cmd_type == `CMD_WREN) ? `OPCODE_WREN : 8'h0;				

wire	[23:0]	addr; assign addr = spi_addr;
wire	[31:0]	wdata; assign wdata = 	write_operation ? spi_wdata : 31'h0;


always @(posedge iClk) begin
	if(iReset) begin
		shiftreg <= 64'hdeadbeefdeadbeef;
		cyclecnt <= 7'h0;
		imem_hrdata <= 32'hdeadbeef;
	end else begin
		if((spi_state == `QSPI_IDLE) || (spi_state == `QSPI_RESTART)) begin
			shiftreg <= {opcode,addr,wdata};
		end else if(spi_state == `QSPI_START) begin 
			shiftreg <= {opcode,addr,wdata};
			cyclecnt <= (spi_cmd_type == `CMD_WRITE) ? 40 : 
				    (spi_cmd_type == `CMD_WRITEH) ? 48 :
				    (spi_cmd_type == `CMD_WRITEW) ? 64 :
				    (spi_cmd_type == `CMD_READ) ? 44 : 
				    (spi_cmd_type == `CMD_READH) ? 52 : 
				    (spi_cmd_type == `CMD_READW) ? 68 : 
				    (spi_cmd_type == `CMD_WRCR) ? 16 : 
				    (spi_cmd_type == `CMD_WREN) ? 8 :
				    (spi_cmd_type == `CMD_QPIEN) ? 8 : 0;
		end else if(spi_state == `QSPI_SHIFT) begin
			if(spi_mode == `MODE_QPI) shiftreg <= {shiftreg[59:0],iIRAM_IO3_In,iIRAM_IO2_In,iIRAM_IO1_In,iIRAM_IO0_In};
			else shiftreg <= {shiftreg[62:0],iIRAM_IO1_In};
			if(cyclecnt >= 0) begin
				if(spi_mode == `MODE_QPI)
					cyclecnt <= cyclecnt - 4;
				else
					cyclecnt <= cyclecnt - 1;
			end
		end else if(spi_state == `QSPI_END) begin
			if(~write_operation) begin 
				imem_hrdata <= {shiftreg[7:0],shiftreg[15:8],shiftreg[23:16],shiftreg[31:24]};
/*				spi_rdata[7:0] <= shiftreg[31:24];
				spi_rdata[15:8] <= ((spi_cmd_type == `CMD_READH) || (spi_cmd_type == `CMD_READW)) ? shiftreg[23:16] : 8'h0;
				spi_rdata[31:16] <= ((spi_cmd_type == `CMD_READH) || (spi_cmd_type == `CMD_READW)) ? shiftreg[15:0] : 16'h0;*/
			end
		end
	end
end

wire enable_condition; assign enable_condition = ((spi_cmd_type == `CMD_READ) && (cyclecnt > 12)) ||
						 ((spi_cmd_type == `CMD_READH) && (cyclecnt > 20)) ||
						 ((spi_cmd_type == `CMD_READW) && (cyclecnt > 36)) || 
						 write_operation;	

reg IRAM_IO0_Out_reg, IRAM_IO0_En_reg;
reg IRAM_IO1_Out_reg, IRAM_IO1_En_reg;
reg IRAM_IO2_Out_reg, IRAM_IO2_En_reg;
reg IRAM_IO3_Out_reg, IRAM_IO3_En_reg;
reg IRAM_nCS_reg, IRAM_SCK_reg;

always @(posedge iClk) begin 
	if(iReset) begin 
		oIRAM_IO0_Out <= 1'b0;
		oIRAM_IO0_En <= 1'b0;
		oIRAM_IO1_Out <= 1'b0;
		oIRAM_IO1_En <= 1'b0;
		oIRAM_IO2_Out <= 1'b0;
		oIRAM_IO2_En <= 1'b0;
		oIRAM_IO3_Out <= 1'b0;
		oIRAM_IO3_En <= 1'b0;
		oIRAM_SCK <= 1'b0;
		oIRAM_nCS <= 1'b1;
	end else begin
		oIRAM_IO0_Out <= IRAM_IO0_Out_reg;
		oIRAM_IO0_En <= IRAM_IO0_En_reg;
		oIRAM_IO1_Out <= IRAM_IO1_Out_reg;
		oIRAM_IO1_En <= IRAM_IO1_En_reg;
		oIRAM_IO2_Out <= IRAM_IO2_Out_reg;
		oIRAM_IO2_En <= IRAM_IO2_En_reg;
		oIRAM_IO3_Out <= IRAM_IO3_Out_reg;
		oIRAM_IO3_En <= IRAM_IO3_En_reg;
		oIRAM_SCK <= IRAM_SCK_reg;
		oIRAM_nCS <= IRAM_nCS_reg;
	end
end

always @(*) begin 
	spi_next_state = `QSPI_IDLE;
	IRAM_IO0_Out_reg = 1'b0;
	IRAM_IO0_En_reg = 1'b0;
	IRAM_IO1_Out_reg = 1'b0;
	IRAM_IO1_En_reg = 1'b0;
	IRAM_IO2_Out_reg = 1'b0;
	IRAM_IO2_En_reg = 1'b0;
	IRAM_IO3_Out_reg = 1'b0;
	IRAM_IO3_En_reg = 1'b0;
	IRAM_SCK_reg = 1'b0;
	IRAM_nCS_reg = 1'b1;

	imem_hresp = `HASTI_RESP_WIDTH'h0;
	spi_finished = 1'b0;

	case (spi_state) 
		`QSPI_IDLE 	:	begin 
						spi_next_state = spi_en ? `QSPI_START : `QSPI_IDLE;
					end // TODO: RESTART
		`QSPI_RESTART	:	begin
						spi_next_state = `QSPI_START;
					end
		`QSPI_START	:	begin
						spi_next_state = spi_en ? `QSPI_RESTART : `QSPI_CLOCK;
						IRAM_nCS_reg = 1'b0;
						if(spi_mode == `MODE_QPI) begin
							IRAM_IO3_Out_reg = shiftreg[63];
							IRAM_IO2_Out_reg = shiftreg[62];
							IRAM_IO1_Out_reg = shiftreg[61];
							IRAM_IO0_Out_reg = shiftreg[60];
							IRAM_IO3_En_reg = 1'b1;
							IRAM_IO2_En_reg = 1'b1;
							IRAM_IO1_En_reg = 1'b1;
							IRAM_IO0_En_reg = 1'b1;
						end else begin
							IRAM_IO0_Out_reg = opcode[7];						
							IRAM_IO0_En_reg = 1'b1;
						end
					end
		`QSPI_CLOCK	:	begin	
						spi_next_state =  spi_en ? `QSPI_RESTART : ((cyclecnt == 0) ? `QSPI_END : `QSPI_PAUSE);
						IRAM_nCS_reg = 1'b0;
						if(spi_mode == `MODE_QPI) begin
							IRAM_IO3_Out_reg = shiftreg[63];
							IRAM_IO2_Out_reg = shiftreg[62];
							IRAM_IO1_Out_reg = shiftreg[61];
							IRAM_IO0_Out_reg = shiftreg[60];
							IRAM_IO3_En_reg = enable_condition ? 1'b1 : 1'b0;
							IRAM_IO2_En_reg = enable_condition ? 1'b1 : 1'b0;
							IRAM_IO1_En_reg = enable_condition ? 1'b1 : 1'b0;
							IRAM_IO0_En_reg = enable_condition ? 1'b1 : 1'b0;
						end else begin
							IRAM_IO0_Out_reg = shiftreg[63];						
							IRAM_IO0_En_reg = 1'b1;
						end
						IRAM_SCK_reg = 1'b0;
					end
		`QSPI_PAUSE	:	begin	
						spi_next_state =  spi_en ? `QSPI_RESTART : `QSPI_SHIFT;
						IRAM_nCS_reg = 1'b0;
						if(spi_mode == `MODE_QPI) begin
							IRAM_IO3_Out_reg = shiftreg[63];
							IRAM_IO2_Out_reg = shiftreg[62];
							IRAM_IO1_Out_reg = shiftreg[61];
							IRAM_IO0_Out_reg = shiftreg[60];
							IRAM_IO3_En_reg = enable_condition ? 1'b1 : 1'b0;
							IRAM_IO2_En_reg = enable_condition ? 1'b1 : 1'b0;
							IRAM_IO1_En_reg = enable_condition ? 1'b1 : 1'b0;
							IRAM_IO0_En_reg = enable_condition ? 1'b1 : 1'b0;
						end else begin
							IRAM_IO0_Out_reg = shiftreg[63];						
							IRAM_IO0_En_reg = 1'b1;
						end
						IRAM_SCK_reg = 1'b1;
					end
		`QSPI_SHIFT	:	begin
						spi_next_state =  spi_en ? `QSPI_RESTART : `QSPI_CLOCK;
						if(spi_mode == `MODE_QPI) begin
							IRAM_IO3_Out_reg = shiftreg[63];
							IRAM_IO2_Out_reg = shiftreg[62];
							IRAM_IO1_Out_reg = shiftreg[61];
							IRAM_IO0_Out_reg = shiftreg[60];
							IRAM_IO3_En_reg = enable_condition ? 1'b1 : 1'b0;
							IRAM_IO2_En_reg = enable_condition ? 1'b1 : 1'b0;
							IRAM_IO1_En_reg = enable_condition ? 1'b1 : 1'b0;
							IRAM_IO0_En_reg = enable_condition ? 1'b1 : 1'b0;
						end else begin
							IRAM_IO0_Out_reg = shiftreg[63];						
							IRAM_IO0_En_reg = 1'b1;
						end						
						IRAM_nCS_reg = 1'b0;
						IRAM_SCK_reg = 1'b0;
					end
		`QSPI_END	:	begin
						spi_next_state =  spi_en ? `QSPI_RESTART : `QSPI_IDLE;		
						spi_finished = 1'b1;		
					end
	endcase
end


// 
// 4 x 62 Bit ROM mit der Startup-Sequenz, um 
// den QSPI-Baustein in den korrekten Modus zu bringen.
// (das meiste wird wegoptimiert, da ungenutzt.)
// 
wire [1:0] startup_spi_mode[`STARTUP_SEQ_LENGTH-1:0];
assign startup_spi_mode[0] = `MODE_SPI;
assign startup_spi_mode[1] = `MODE_SPI;
assign startup_spi_mode[2] = `MODE_SPI;
assign startup_spi_mode[3] = `MODE_QPI;

wire [3:0] startup_cmd_type[`STARTUP_SEQ_LENGTH-1:0];
assign startup_cmd_type[0] = `CMD_WREN;
assign startup_cmd_type[1] = `CMD_WRCR;
assign startup_cmd_type[2] = `CMD_QPIEN;
assign startup_cmd_type[3] = `CMD_WREN;

wire [23:0] startup_addr[`STARTUP_SEQ_LENGTH-1:0];
assign startup_addr[0] = 24'h0;
assign startup_addr[1] = 24'h420000;
assign startup_addr[2] = 24'h0;
assign startup_addr[3] = 24'h0;

wire [31:0] startup_wdata[`STARTUP_SEQ_LENGTH-1:0];
assign startup_wdata[0] = 32'h0;
assign startup_wdata[1] = 32'h0;
assign startup_wdata[2] = 32'h0;
assign startup_wdata[3] = 32'h0;


reg [3:0] fsm_state, fsm_state_next;
reg [3:0] startup_cnt;
reg	  fetched_first;
reg [23:0] first_addr;

// IBUS top FSM, 
// start SPI transactions if read/write request come in or 
// do housekeeping at startup.

always @(posedge iClk) begin
	if(iReset) begin
		fsm_state <= `FSM_RESET;
		startup_cnt <= 0;
		fetched_first <= 0;
		first_addr <= 32'hdeadbeef;
	end else begin
		if(fsm_state == `FSM_STARTUP) begin 
			spi_mode <= startup_spi_mode[startup_cnt];
			spi_cmd_type <= startup_cmd_type[startup_cnt];
			spi_addr <= startup_addr[startup_cnt];
			spi_wdata <= startup_wdata[startup_cnt];
			startup_cnt <= startup_cnt + 1;
		end
		if(fsm_state == `FSM_FETCHFIRST) begin 
			spi_mode <= `MODE_QPI;
			spi_cmd_type <= `CMD_READW;
			spi_addr <= first_addr;
			spi_wdata <= 32'h0;
			fetched_first <= 1'b1;
		end
		if((fsm_state == `FSM_IDLE) || (fsm_state == `FSM_RESET)) begin
			first_addr <= imem_haddr[23:0];
		end
		if(|imem_htrans && ~(fsm_state == `FSM_STARTUP)) begin
			spi_mode <= `MODE_QPI;
			spi_cmd_type <= ~imem_hwrite ? 
					(imem_hsize == 2'b00) ? `CMD_READ : 
					(imem_hsize == 2'b01) ? `CMD_READH : 
					(imem_hsize == 2'b10) ? `CMD_READW : `CMD_READ : 
					(imem_hsize == 2'b00) ? `CMD_WRITE : 
					(imem_hsize == 2'b01) ? `CMD_WRITEH : 
					(imem_hsize == 2'b10) ? `CMD_WRITEW : `CMD_WRITE;
			spi_addr <= imem_haddr[23:0];
			spi_wdata[31:24] <= imem_hwdata[7:0];
			spi_wdata[23:16] <= imem_hwdata[15:8];
			spi_wdata[15:8] <= imem_hwdata[23:16];
			spi_wdata[7:0] <= imem_hwdata[31:24];
		end
		fsm_state <= fsm_state_next;
	end
end

wire	fsm_got_read_req; assign fsm_got_read_req = (|imem_htrans && ~imem_hwrite);
wire	fsm_got_write_req; assign fsm_got_write_req = (|imem_htrans && imem_hwrite);
reg	fsm_ready;

always @(*) begin
	fsm_state_next = `FSM_IDLE;	
	spi_en	= 1'b0;
	fsm_ready = 1'b0;
	case(fsm_state) 
		`FSM_RESET	:	fsm_state_next = `FSM_STARTUP;
		`FSM_STARTUP	:	begin 
						fsm_state_next = `FSM_WRITE;		
					end
		`FSM_IDLE	:	begin 
						fsm_state_next = fsm_got_read_req ? `FSM_READ : 
								 fsm_got_write_req ? `FSM_WRITE : `FSM_IDLE;
						fsm_ready = 1'b1;
					end
		`FSM_FETCHFIRST:	begin 
						fsm_state_next = `FSM_READ; // fsm_got_read_req ? `FSM_READ : 
								 // fsm_got_write_req ? `FSM_WRITE : `FSM_IDLE;
						fsm_ready = 1'b0;
					end
		`FSM_READ	:	begin
						fsm_state_next = fsm_got_read_req ? `FSM_READ : 
								 fsm_got_write_req ? `FSM_WRITE : `FSM_WAITFINISH;
						spi_en = 1'b1;
					end
		`FSM_WRITE	:	begin 
						if(startup_cnt == `STARTUP_SEQ_LENGTH) begin 
								 fsm_state_next = fsm_got_read_req ? `FSM_READ : 
								 fsm_got_write_req ? `FSM_WRITE : `FSM_WAITFINISH;
						end else fsm_state_next = `FSM_WAITFINISH;
						spi_en = 1'b1;
					end
		`FSM_WAITFINISH	:	begin 
						fsm_state_next = fsm_got_read_req ? `FSM_READ : 
								 fsm_got_write_req ? `FSM_WRITE : 
								 spi_finished ? `FSM_FINISH : `FSM_WAITFINISH;
					end
		`FSM_FINISH	:	fsm_state_next = (startup_cnt == `STARTUP_SEQ_LENGTH) ? (fetched_first ? `FSM_IDLE : `FSM_FETCHFIRST) : `FSM_STARTUP;
	endcase
end

assign	imem_hready = fsm_ready;

endmodule



