`include "raifes_hasti_constants.vh"
`include "raifes_ctrl_constants.vh"
`include "raifes_csr_addr_map.vh"
`include "raifes_platform_constants.vh"
`include "raifes_dmi_constants.vh"
`include "rv32_opcodes.vh"

module raifes_debug_module(
			input				reset,
			input				clk,

			// ================================
			// = Debug Module Interface (DMI) =
			// ================================
			//
			// Interface to the JTAG-TAP or other means of transport (e.g. serial)
			//
			input												dmi_en,				// enable (for read or write)
			input				[`DMI_ADDR_WIDTH-1:0]	dmi_addr,			// addr of target register within Debug Module (DM)
			output	reg	[`DMI_WIDTH-1:0]			dmi_rdata,			// data from DM to JTAG-TAP
			output											dmi_error,			// error signalin from DM to JTAG-TAP
			input				[`DMI_WIDTH-1:0]			dmi_wdata,			// data from JTAG-TAP to DM
			input												dmi_wen,				// write enable
			output	reg									dmi_dm_busy,		// busy signaling from DM to JTAG-TAP

			// ===================================
			// = Processor register access ports =
			// ===================================
			//
			// interface to general purpose (gpr) register file
			output	reg									dm_regfile_wen,	// write enable
			output	reg	[`REG_ADDR_WIDTH-1:0]	dm_regfile_wara,	// write/read register address
			output	reg	[`XPR_LEN-1:0]				dm_regfile_wd,		// write data
			input				[`XPR_LEN-1:0]				dm_regfile_rd,		// read data

			// interface to control and state register (csr) file
			input												dm_illegal_csr_access,	// illegal access (not existing, prohibited etc.) signaling
			output	reg	[`CSR_ADDR_WIDTH-1:0]	dm_csr_addr,				// register addr (see csr_addr_map header file)
			output	reg	[`CSR_CMD_WIDTH-1:0]		dm_csr_cmd,					// command (100 = read, 101 = write, others are bit-set / -unset
			output	reg	[`XPR_LEN-1:0]				dm_csr_wdata,				// data from DM to CSR
			input				[`XPR_LEN-1:0]				dm_csr_rdata,				// data from CSR to DM

			// ===============
			// = Run control =
			// ===============
			
			// run control signals for individual harts
			output											dm_hart0_haltreq,			// halt request interrupt to core
			output											dm_hart0_resumereq,		// resume request to core (memory mapped)
			input											dm_hart0_halted,			// core signals it has been halted (memory mapped)

			output		reg									dm_hart0_postexecreq,	// request execution of the program buffer
			input											dm_hart0_resumeack,		// hart0 acknoledges it is about to resume...

			// single instruction debug program buffer output
			output		[`XPR_LEN-1:0]					dm_hart0_progbuf0,			// memory mapped into debug ROM
			output		[`XPR_LEN-1:0]					dm_hart0_progbuf1,
																							
			// TODO: implement POSTEXEC signal!
			
			// =================
			// = Debug signals =
			// =================
			
			output			[3:0]							dm_state_out				// 4-bit output for debug purposed (e.g. drive LEDs)			
         );
			
// DMI error signaling
assign dmi_error = 1'b0; // TODO: we don't signal errors right now.

wire	hart0_halted; assign hart0_halted = dm_hart0_halted;

// =====================
// = DM core registers =
// =====================

// DATA0, TODO: address
reg	[`DMI_WIDTH-1:0]	data0;								// parameter hold register / result hold register
// COMMAND,TODO: address
reg	[`DMI_WIDTH-1:0]	command;								// command hold register using data0 as argument / result
// AUTHDATA, TODO: address
reg	[`XPR_LEN-1:0]		authdata;							// DMI support authorization of acces. This holds the key submitted 
// PROGBUF0, TODO: address																		// by the user? TODO
reg	[`XPR_LEN-1:0]		progbuf0;							// single command program buffer.
assign	dm_hart0_progbuf0 = progbuf0;
reg	[`XPR_LEN-1:0]		progbuf1;
assign	dm_hart0_progbuf1 = progbuf1;
// Abstract Control and Status (abstractcs, 0x16)
wire	[4:0]			progbufsize;		assign progbufsize = 5'h2;		// TODO: make this scalable (parameter), not hardcoded.
reg					busy;															// assigned way below.
reg	[2:0]			cmderr;														// error code hold register
wire	[4:0]			datacount;			assign datacount = 5'h1;		// only single DATA0. TODO: we should support scratch registers, modify this afterwards!

wire	[`XPR_LEN-1:0]		abstractcs;		assign abstractcs = {3'h0,progbufsize,11'h0,busy,1'h0,cmderr,3'h0,datacount};

// hartinfo register (hartinfo, 0x12)
wire	[`XPR_LEN-1:0]		hartinfo;		assign hartinfo = {8'h0,4'h0,3'h0,1'b1,4'h1,12'h43}; //`XPR_LEN'h0;		// TODO: we should support scratch registers, modify this afterwards!

// halt summary register (haltsum, 0x13)
wire	[`XPR_LEN-1:0]		halsum;			assign halsum = {30'h0,hart0_halted};	// shows table of halt-state of multiple harts. if there are more than one...

// Fields of the dmcontrol register

reg	[`DMI_WIDTH-1:0]	dmcontrol;

wire				haltreq;		assign haltreq = dmcontrol[31];				// halt request for selected harts
wire				resumereq;		assign resumereq = dmcontrol[30];			// resume request for selected harts
wire				hartreset;		assign hartreset = dmcontrol[29];			// reset request for selected harts
wire				ackhavereset;	assign ackhavereset = dmcontrol[28];		// acknolege of "havereset" for selected harts
wire				hasel;			assign hasel = dmcontrol[26];					// hart selection mode (0 = single, 1 = multiple selected)
wire	[9:0]		hartsel;			assign hartsel = dmcontrol[25:16];			// index of selected hart
wire				ndmreset;		assign ndmreset = dmcontrol[1];				// reset system excluding debug module
wire				dmactive;		assign dmactive = dmcontrol[0];				// reset for debug module

wire	[`DMI_WIDTH-1:0]	dmcontrol_read; assign dmcontrol_read = {2'b00,1'b0,1'b0,1'b0,1'b0,ndmreset,dmactive};

assign	dm_hart0_haltreq = haltreq;	// TODO: right now only single haltreq in singlecore implementation...
assign  dm_hart0_resumereq = resumereq; // TODO: only single resumereq in singlecore implementation...

// Fields of the dmstatus register

reg	[2:0]			dmerr;

wire				impebreak;		assign impebreak = 1'b1;							// implicit EBREAK instruction at end of program buffer

reg				anyhavereset;
wire				allhavereset;		assign allhavereset = anyhavereset;			// only one HART -> "all" = "any"

//reg				anyresumeack;
wire				anyresumeack;		assign anyresumeack = dm_hart0_resumeack; 					// TODO: we need to acknoledge resumes, or the debugger will go wild.
wire				allresumeack;		assign allresumeack = anyresumeack;

wire				anynonexistent;		assign anynonexistent = |hartsel;		// only hart 0 exists, so if hartsel is > 0, raise flag.
wire				allnonexistent;		assign allnonexistent = anynonexistent;

reg				anyunavail;
wire				allunavail;		assign allunavail = anyunavail;

reg				anyrunning;
wire				allrunning;		assign allrunning = anyrunning;

reg				anyhalted;
wire				allhalted;		assign allhalted = anyhalted;

reg				authenticated;
reg				authbusy;
wire				devtreevalid;		assign devtreevalid = 1'b0;		// devtreeaddr0 holds information not relevant to devtree.
wire	[3:0]			version;		assign version = 4'h2;

wire	[`DMI_WIDTH-1:0]	dmstatus;
assign dmstatus = {5'b0,dmerr,
		   1'b0,impebreak,2'b00,allhavereset,anyhavereset,allresumeack,anyresumeack,
		   allnonexistent,anynonexistent,allunavail,anyunavail,allrunning,anyrunning,allhalted,anyhalted,
	           authenticated,authbusy,1'b0,devtreevalid,version};


reg	[`DMI_WIDTH-1:0]	abstractauto;		// Abstract Command Autoexec (0x18)

// -------------------



reg	[3:0]	dm_state;
reg	[3:0]	dm_state_next;




//	=============================================
//      ==    DMI state machine                     =
//      ==                                         =
//      == This handles the parallel DMI bus        =
//      =============================================

reg	[3:0]	dmi_state;
reg	[3:0]	dmi_state_next;

reg	[`DMI_ADDR_WIDTH-1:0]	dmi_addr_r;
reg	[`DMI_WIDTH-1:0]	rdata_r;
reg	[`DMI_WIDTH-1:0]	wdata_r;
reg	dmi_wen_r;

//	Signals for the Debug Module state machine
wire	dm_command_received;
assign	dm_command_received = (dmi_state == `DMI_STATE_WRITE) && (dmi_addr_r == `DMI_ADDR_COMMAND);

wire	dm_autoexec;
assign dm_autoexec =    ((dmi_state == `DMI_STATE_WRITE) || (dmi_state == `DMI_STATE_READ)) && 
								(((dmi_addr_r == `DMI_ADDR_DATA0) && (abstractauto[0] == 1'b1)) ||
								 ((dmi_addr_r == `DMI_ADDR_PROGBUF0) && (abstractauto[16] == 1'b1)) ||
								 ((dmi_addr_r == `DMI_ADDR_PROGBUF1) && (abstractauto[17] == 1'b1)));

// sample inputs from TCK clock domain

/*reg	[`DMI_ADDR_WIDTH-1:0]	dmi_addr_sync;
reg	[`DMI_WIDTH-1:0]			dmi_wdata_sync;
reg									dmi_en_sync;
reg									dmi_wen_sync;
*/
/*always @(posedge clk)
begin
	if(reset) begin
		dmi_addr_sync <= `DMI_ADDR_WIDTH'h0;
		dmi_wdata_sync <= `DMI_WIDTH'h0;
		dmi_en_sync <= 1'b0;
		dmi_wen_sync <= 1'b0;
	end else begin
		dmi_addr_sync <= dmi_addr;
		dmi_wdata_sync <= dmi_wdata;
		dmi_en_sync <= dmi_en;
		dmi_wen_sync <= dmi_wen;
	end
end*/


//	state changes, sequential

reg	dmi_en_sync1;
reg	dmi_en_sync2;


always @(posedge clk)
begin
	if(reset) begin
		dmi_state <= `DMI_STATE_IDLE;
		dmi_addr_r <= `DMI_ADDR_WIDTH'h0;
		dmi_en_sync1 <= 1'b0;
		dmi_en_sync2 <= 1'b0;
		dmi_wen_r <= 1'b0;
		dmi_dm_busy <= 1'b0;
	end // if(reset)
	else begin		
		dmi_en_sync1 <= dmi_en;
		dmi_en_sync2 <= dmi_en_sync1;		
		dmi_state <= dmi_state_next;
		if(dmi_en_sync1) begin
			dmi_addr_r <= dmi_addr;//_sync;
			wdata_r <= dmi_wdata;//_sync;
			dmi_wen_r <= dmi_wen;//_sync;
		end
		dmi_dm_busy <= 1'b0;	// TODO! BUSY STATES ARE CURRENTLY NOT HANDLED
	end // else begin
end // always @(posedge


// general combinational part
always @*
begin
	dmi_state_next	= `DMI_STATE_IDLE;
	case (dmi_state) 
		`DMI_STATE_IDLE	: begin dmi_state_next = ~dmi_en_sync2 ? `DMI_STATE_IDLE : 
							dmi_wen_r ? `DMI_STATE_WRITE : `DMI_STATE_READ;
				end
		`DMI_STATE_READ	 : begin dmi_state_next = `DMI_STATE_WAITEND; end
		`DMI_STATE_WRITE   : begin dmi_state_next = `DMI_STATE_WAITEND; end				
		`DMI_STATE_WAITEND : begin dmi_state_next = ~dmi_en_sync2 ? `DMI_STATE_IDLE : 
							`DMI_STATE_WAITEND;
				end
	endcase
end

always @(posedge clk) begin
	if(dmi_state == `DMI_STATE_READ) dmi_rdata <= rdata_r;
end

// address decoder and data output mux
always @*
begin
	rdata_r = 32'hdeaddead;//dmi_addr_r;
	case(dmi_addr_r)
		`DMI_ADDR_ABSTRACTAUTO	:	begin rdata_r = abstractauto; end		// abstractauto is not implemented
		`DMI_ADDR_ABSTRACTCS		:	begin rdata_r = abstractcs; end
		`DMI_ADDR_COMMAND			:	begin rdata_r = command; end
		`DMI_ADDR_DATA0			:	begin rdata_r = data0; end
		`DMI_ADDR_DEVTREEADDR0	:	begin rdata_r = `XPR_LEN'h1337; end // devtreeaddr0 is not implemented, devtreevalid is 0
		`DMI_ADDR_DMCONTROL		:	begin rdata_r = dmcontrol_read; end		// 10 
		`DMI_ADDR_DMSTATUS		:	begin rdata_r = dmstatus; end // 11
		`DMI_ADDR_HAWINDOW		:	begin rdata_r = `XPR_LEN'hdeadbeef; end		// hawindow is not implemented
		`DMI_ADDR_HAWINDOWSEL	:	begin rdata_r = `XPR_LEN'hdeadbabe; end		// hawindowsel is not implemented.
		`DMI_ADDR_PROGBUF0		:	begin rdata_r = progbuf0; end			// TODO: set cmderr flag if accessed during abstract command*/
		`DMI_ADDR_PROGBUF1		:	begin	rdata_r = progbuf1; end
		`DMI_ADDR_HARTINFO		:	begin rdata_r = hartinfo; end // {8'h0,4'h0,3'h0,1'b1,4'h1,12'h43};	end// TODO: data0 shadow		
	endcase
end

//	=============================================
// ==    Debug Module state machine            =
// ==                                          =
// == This handles the parallel DMI bus        =
// =============================================

wire	[7:0]	dm_command;
assign dm_command = command[31:24];

wire	[2:0]	dm_size;
assign	dm_size = command[22:20];

wire	dm_size_invalid;		// we are 32 bit system. signal error on 64 bit accessess.
assign dm_size_invalid = dm_size[2] | dm_size[0];	// 32 bit is 3'b010

wire		dm_postexec;
assign	dm_postexec = command[18];

wire		dm_transfer;
assign	dm_transfer = command[17];

wire		dm_write;
assign	dm_write = command[16];


wire		dm_regfile_access; assign dm_regfile_access = command[12];		// virtual address of GPRs start at 0x1000
wire		dm_csr_access;		assign dm_csr_access = ~command[12];			// virtual address of CSRs start at 0x0000

wire	[15:0]	dm_regno;
assign	dm_regno = command[15:0];

reg	[3:0]	errorcode;

always @(posedge clk)
begin
	if(reset) begin
		dm_state <= `DM_STATE_IDLE;
	end
	else
	begin
		dm_state <= dm_state_next;
	end
end

always @*
begin
	dm_state_next = `DM_STATE_IDLE;
	dm_regfile_wara = `REG_ADDR_WIDTH'd0; // misa
	dm_regfile_wen = 1'b0;
	dm_regfile_wd = `XPR_LEN'h0;
	busy = 1'b1;

	// signals to csr file
	dm_csr_addr = `CSR_ADDR_WIDTH'd834; // misa
	dm_csr_cmd = `CSR_CMD_WIDTH'h4;
	dm_csr_wdata = `XPR_LEN'h0;
	
	dm_hart0_postexecreq = 1'b0;
	
	errorcode = 3'h0;	

	case(dm_state)
	`DM_STATE_IDLE		:	begin
					busy = 1'b0;
					dm_csr_cmd = `CSR_IDLE;
					dm_state_next = (dm_command_received | dm_autoexec) ? `DM_STATE_DECODE : `DM_STATE_IDLE;					
	end
	`DM_STATE_DECODE	:	begin
						case(dm_command)
						`DM_CMD_ACCESSREG	:	dm_state_next = ~dm_transfer ? 			// check for dummy command, no transfer means 
												(dm_postexec ? `DM_STATE_POSTEXEC :			//  .. either only exec progbuf, 
													       `DM_STATE_IDLE) :					//  .. or do nothing.
												dm_size_invalid ? `DM_STATE_ERROR_NOTSUPP :			// if we want a transfer, check for valid size (32 Bit)
												(dm_write ? `DM_STATE_ACCESSREG_W :			//  .. if valid, goto Read or Write depending on the flag.
													    `DM_STATE_ACCESSREG_R);
						default			:	dm_state_next = `DM_STATE_IDLE; 	// other cmds not implemented!
						endcase	
	end
	`DM_STATE_ACCESSREG_R 	: 	begin		// read gpr
					dm_state_next = dm_postexec ? `DM_STATE_POSTEXEC : `DM_STATE_IDLE;				
					dm_regfile_wara = dm_regno[4:0];	// GPRs are mapped to 0x1000 - 0x101f
					dm_regfile_wen = 1'b0;
					dm_regfile_wd = data0;			
					dm_csr_addr = dm_regno[11:0];
					dm_csr_cmd = `CSR_READ;		
			      end
	`DM_STATE_ACCESSREG_W 	:	begin		// write gpr
					dm_state_next = dm_postexec ? `DM_STATE_POSTEXEC : `DM_STATE_IDLE;
					dm_regfile_wara = dm_regno[4:0]; // GPRs are mapped to 0x1000 - 0x101f
					dm_regfile_wen = dm_regno[12] ? 1'b1 : 1'b0;
					dm_regfile_wd = data0;
					dm_csr_addr = dm_regno[11:0];
					dm_csr_cmd = dm_regno[12] ? `CSR_IDLE : `CSR_WRITE;
					dm_csr_wdata = data0;
			      end
	`DM_STATE_POSTEXEC	:	begin		// run program buffer once
					dm_hart0_postexecreq = 1'b1;
					dm_state_next = `DM_STATE_IDLE;
					dm_csr_cmd = `CSR_IDLE;					
					end
	`DM_STATE_ERROR_BUSY		:	begin
					errorcode = 3'h1;
					dm_state_next = `DM_STATE_IDLE;
					dm_csr_cmd = `CSR_IDLE;
					end
   `DM_STATE_ERROR_NOTSUPP	: begin
					errorcode = 3'h2;
					dm_state_next = `DM_STATE_IDLE;
					dm_csr_cmd = `CSR_IDLE;
					end
	`DM_STATE_ERROR_EXCEPT : begin
					errorcode = 3'h3;
					dm_state_next = `DM_STATE_IDLE;
					dm_csr_cmd = `CSR_IDLE;
					end
	`DM_STATE_ERROR_HALTRESUME : begin
					errorcode = 3'h4;
					dm_state_next = `DM_STATE_IDLE;
					dm_csr_cmd = `CSR_IDLE;
					end
	`DM_STATE_ERROR_OTHER : begin
					errorcode = 3'h7;
					dm_state_next = `DM_STATE_IDLE;
					dm_csr_cmd = `CSR_IDLE;
					end
	endcase
end

// write Debug Module registers in various situations
reg	had_postexec;

always @(posedge clk)
begin
	if(reset) begin
		// fields of dmstatus
		dmerr <= 3'h0;
		anyhavereset <= 1'b0;//1'b1; DEBUG!
		//anyresumeack <= 1'b0;
		anyunavail <= 1'b0;
		anyrunning <= 1'b1;
		anyhalted <= 1'b0;
		authenticated <= 1'b1;
		authbusy <= 1'b0;
		// abstractcs fields
		cmderr <= 3'b000;	
		// dmcontrol
		dmcontrol <= `XPR_LEN'h0000;
		// data0
		data0 <= `XPR_LEN'hbabebabe;
		// command
		command <= `XPR_LEN'h0000;
		// progbuf0
		progbuf0 <= `XPR_LEN'h13;						// init Progbuf with NOP.
		progbuf1 <= `XPR_LEN'h13;
		// abstractauto
		abstractauto <= `XPR_LEN'h0;
		had_postexec <= 1'b0;
	end
	else begin
		anyhalted <= hart0_halted;
		anyrunning <= ~hart0_halted;

/*		if(~(dmi_state == `DMI_STATE_WRITE) && dm_hart0_resumeack) 
			dmcontrol[30] <= 1'b0;						// clear resumereq bit when resume is acknoledged. ASt, 30.07.19*/
	
		if(~(dmi_state == `DMI_STATE_WRITE) && dm_hart0_halted) 
			dmcontrol[31] <= 1'b0;						// clear halt bit when core is/has just been halted, ASt, 30.07.19
	
	
		if(dmi_state == `DMI_STATE_WRITE) begin					// write due to DMI bus write access
			case (dmi_addr_r) 
				`DMI_ADDR_DATA0		: data0 <= wdata_r;
				`DMI_ADDR_DMCONTROL	: dmcontrol <= wdata_r;
				`DMI_ADDR_DMSTATUS	: dmerr <= 3'h0;		// clear dmerr = bits 26:24
				`DMI_ADDR_COMMAND		: command <= wdata_r;
				`DMI_ADDR_ABSTRACTCS	: cmderr <= 3'b000;		// clear busy is the only write operation allowed to abstractcs
				`DMI_ADDR_PROGBUF0	: progbuf0 <= wdata_r;
				`DMI_ADDR_PROGBUF1	: progbuf1 <= wdata_r;
				`DMI_ADDR_ABSTRACTAUTO : abstractauto <= wdata_r;
			endcase
		end
		else if(dm_state == `DM_STATE_ACCESSREG_R) begin 			
			data0 <= dm_regfile_access ? dm_regfile_rd : dm_csr_rdata;
		end
		else if(dm_state >= `DM_STATE_ERROR_BUSY) begin 				// signal error as soon as we enter error state. Hold flag until cleared.
			cmderr <= errorcode;
		end
		else if(dm_state == `DM_STATE_POSTEXEC) begin
			had_postexec <= 1'b1;
		end
		else if(dm_state == `DM_STATE_ACCESSREG_W) begin
			had_postexec <= 1'b0;
		end
	end
end

assign dm_state_out = {1'b0,abstractauto[1:0],had_postexec};


endmodule // raifes_debug_module
