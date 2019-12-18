`include "raifes_platform_constants.vh"

module raifes_debug_rom (
	input			reset,
	input			clk,
	input			postexec_req,
	input			resume_req,
	output			halted,
	output			resume_ack,
	input	[`XPR_LEN-1:0]	rom_addra,
	output	[`XPR_LEN-1:0]	rom_rdataa,
	input	[`XPR_LEN-1:0]	progbuf0,
	input	[`XPR_LEN-1:0]	progbuf1,
	input	[`XPR_LEN-1:0]	rom_addrb,
	input			rom_writeb,
	input	[`XPR_LEN-1:0]	rom_wdatab,
	output	[`XPR_LEN-1:0]	rom_rdatab
);


// status register
// [unused[31:3] | postexec_req | halted | resume_ack]
reg	[`XPR_LEN-1:0]	status;
assign	halted = status[1];
assign	resume_ack =status[0];

// hardware stack register
// used to save one register when entering debug mode
// and restoring the register when leaving debug.
reg	[`XPR_LEN-1:0]	hwstack;

wire	[`XPR_LEN-1:0]	dm_debugrom [81:0];	// debug ROM has 256 lines 
assign	dm_debugrom[0] = `XPR_LEN'h14802023;	// 0001 0101 1100 0000 0010 0000 0010 0011, 14802023, sw s28, 0x140(x0) -- push s0 to debug mem space 0x140
assign	dm_debugrom[1] = `XPR_LEN'h14402E03;	// 0001 0100 0100 0000 0010 1110 0000 0011, 14402E03, lw s28, 0x144(x0) -- read hart0_status from @0x144

assign	dm_debugrom[2] = `XPR_LEN'h008E7E13;	// 0000 0000 0001 1110 0111 1110 0001 0011, 001E7E13, andi s28, 0x08 -- determine if resume is requested
assign	dm_debugrom[3] = `XPR_LEN'h01C01E63;	// 0000 0001 1100 0000 0001 1110 0110 0011, 0101E63, bne s28, x0, d28(pc)
assign	dm_debugrom[4] = `XPR_LEN'h14402E03;	// lw s28, 0x144(x0) -- read hart0_status again.
assign	dm_debugrom[5] = `XPR_LEN'h002E6E13;	// 0000 0000 0010 1110 0110 1110 0001 0011, 002E6E13, ori s28, 0x02 -- set halted_flag
assign	dm_debugrom[6] = `XPR_LEN'h15C02223;	// 0001 0101 1100 0000 0010 0010 0010 0011, 15C02223, sw s28, 0x144(x0) -- and store status
assign	dm_debugrom[7] = `XPR_LEN'h004E7E13;	// 0000 0000 0100 1110 0111 1110 0001 0011, 004E7E13, andi s28, 0x04 -- check for exec

assign	dm_debugrom[8] = `XPR_LEN'h01C01A63;    // 0000 0001 1100 0000 0001 1010 0110 0011, 01C01A63, bne s28, x0, 20(pc)
assign	dm_debugrom[9] = `XPR_LEN'hFE1FF06F;	// 1111 1110 0001 1111 1111 0000 0110 1111, FE1FF06F, j x0, -20 -- jump back to rw s0, 36(x0) ...
assign  dm_debugrom[10] = `XPR_LEN'h14002403;	// 0001 0100 0000 0000 0010 1110 0000 0011, 14002403, lw s28, 0x140(x0) -- pop s0 from "stack"
assign	dm_debugrom[11] = `XPR_LEN'h14002223;	// 0001 0100 0000 0000 0010 0010 0010 0011, 14002223, sw x0, 0x144(x0) -- clear all status flags
assign	dm_debugrom[12] = `XPR_LEN'h7b200073;	// DRET
assign	dm_debugrom[13] = `XPR_LEN'h14002423;	// 0001 0100 0000 0000 0010 0100 0010 0011, 14002423, sw x0, 0x148(x0) -- clear postexec request 

assign	dm_debugrom[14] = progbuf0;		// first progbuf line, the debugger writes this to execute arbitrary commands
assign	dm_debugrom[15] = progbuf1;		// second progbuf line, the debugger writes this to execute arbitrary commands

assign  dm_debugrom[16] = `XPR_LEN'h00100073;  // 0000 0000 0001 0000 0000 0000 0111 0011, 00100073, EBREAK	implicit ebreak at end of progbuf.

genvar i_gv;
for(i_gv = 17; i_gv < 80; i_gv = i_gv+1) begin
	assign	dm_debugrom[i_gv] = `XPR_LEN'h0;
end

assign	dm_debugrom[80] = hwstack;

assign	dm_debugrom[81] = {status[`XPR_LEN-1:4],resume_req&~status[0],status[2:0]};  //ToBo 12.9. resume_req&~status[0] auf seperates Bit ausgelagert(nicht im status register). So kann der Prozessor resume_ack auslesen.



assign rom_rdataa = dm_debugrom[rom_addra[9:0] >> 2];
assign rom_rdatab = dm_debugrom[rom_addrb[9:0] >> 2];


always @(posedge clk) begin
	if(reset) begin	
		hwstack <= `XPR_LEN'h0;
		status <= `XPR_LEN'h0;
		status[0] <= 1'b1;
	end else begin
			if(rom_writeb && (rom_addrb == `ADDR_HART0_STATUS))
				status[1:0] <= (rom_wdatab == 0) ? {rom_wdatab[1],1'b1} : {rom_wdatab[1],rom_wdatab[0]};  //ToBo 16.9. haltflag wasnt cleared  {status[1],1'b1} : {rom_wdatab[1],rom_wdatab[0]};
			else if(~resume_req) status[0] <= 1'b0;
			
			if(rom_writeb && (rom_addrb == `ADDR_HART0_STACK)) hwstack <= rom_wdatab;

			if(rom_writeb && (rom_addrb == `ADDR_HART0_POSTEXEC)) status[2] <= 1'b0;
			else if(postexec_req) status[2] <= 1'b1;
	end	

end

endmodule
