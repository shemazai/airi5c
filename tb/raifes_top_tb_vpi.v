`include "../src/raifes_ctrl_constants.vh"
`include "../src/raifes_csr_addr_map.vh"
`include "../src/raifes_hasti_constants.vh"
`include "../src/raifes_alu_ops.vh"
`include "../src/rv32_opcodes.vh"
`include "../src/raifes_platform_constants.vh"
`include "../src/raifes_hasti_constants.vh"

module vscale_top_tb();

reg	CLK, RESET, init_done;
wire	tck;
wire	tms;
wire	tdi;
wire	tdo;
wire [5:0] dm_state;
wire [31:0] per_hwdata;
wire [31:0] per_haddr;
wire per_hwrite;

jtag_vpi glue(
	.tms(tms),
	.tck(tck),
	.tdi(tdi),
	.tdo(tdo),
	.enable(1'b1),
	.init_done(init_done));

flavor_top DUT(
	.clk(CLK),
	.reset(RESET),
	.tdi(tdi),
	.tck(tck),
	.tms(tms),
	.tdo(tdo),
	.dm_state(dm_state),
	.per_hwdata(per_hwdata),
	.per_haddr(per_haddr),
	.per_hwrite(per_hwrite),
	.per_hrdata(`HASTI_BUS_WIDTH'h0),
	.per_hready(1'b1),
	.per_hresp(`HASTI_RESP_WIDTH'h0)
);

always begin
	#20
	CLK <= ~CLK;
end

always @(posedge CLK) begin
	if(per_hwrite)
		$write("write to dmem_addr: %h, data: %h\r\n",per_haddr, per_hwdata);
end

initial begin
	//$shm_open("output.shm");
	//$shm_probe("AC");
	//$monitor("reset = %h, init_done = %h, dm_state = %b, tms = %h, tck = %h, tdi = %h, tdo = %h",RESET, init_done, dm_state, tms, tck, tdi, tdo);	
	//$monitor("pc = %h, haltreq = %h, resumereq = %h, dmem_hwrite=%h, exec=%h", DUT.vscale.imem_addr,DUT.vscale.dm_hart0_haltreq, DUT.vscale.dm_hart0_resumereq,DUT.vscale.dmem_wen, DUT.vscale.hart0_postexecreq_r);
	CLK <= 1'b0;
	RESET <= 1'b1;
	init_done <= 1'b1;
	#30
	RESET <= 1'b0;
	#10000000;
end

endmodule // vscale_sim_top
