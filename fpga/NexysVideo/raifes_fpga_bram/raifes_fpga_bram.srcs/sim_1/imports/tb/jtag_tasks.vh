task jtag_tap_reset;
begin
	tdi <= 1'b0;
	tms <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b0;
end
endtask

task jtag_dmi_write;
input [5:0] addr;
input [31:0] data;
input [1:0] command;

output reg[31:0] result;

begin
	// DEBUG if(command == 2'h2) $display("dmi: write to %h : %h",addr, data);
	// goto Shift-IR state
	tdi <= 1'b0;
	tms <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	// Shift in address of DMI register (LSB to MSB)
	tms <= 1'b0;
	tdi <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b1;
	tdi <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	// goto Update-IR state
	tdi <= 1'b0;
	tms <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	// goto Shift-DR state
	tdi <= 1'b0;
	tms <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	// shift in DMI address (0x10), data (0x80000000) and write command (0x2)
	tms <= 1'b0;
	tdi <= command[0]; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= command[1]; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;

	tdi <= data[0]; #(5*`CLK_PERIOD) result[0] <= tdo; tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[1]; #(5*`CLK_PERIOD) result[1] <= tdo; tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[2]; #(5*`CLK_PERIOD) result[2] <= tdo; tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[3]; #(5*`CLK_PERIOD) result[3] <= tdo; tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;

	tdi <= data[4]; #(5*`CLK_PERIOD) result[4] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[5]; #(5*`CLK_PERIOD) result[5] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[6]; #(5*`CLK_PERIOD) result[6] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[7]; #(5*`CLK_PERIOD) result[7] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;

	tdi <= data[8]; #(5*`CLK_PERIOD) result[8] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[9]; #(5*`CLK_PERIOD) result[9] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[10]; #(5*`CLK_PERIOD) result[10] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[11]; #(5*`CLK_PERIOD) result[11] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;

	tdi <= data[12]; #(5*`CLK_PERIOD) result[12] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[13]; #(5*`CLK_PERIOD) result[13] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[14]; #(5*`CLK_PERIOD) result[14] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[15]; #(5*`CLK_PERIOD) result[15] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;

	tdi <= data[16]; #(5*`CLK_PERIOD) result[16] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[17]; #(5*`CLK_PERIOD) result[17] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[18]; #(5*`CLK_PERIOD) result[18] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[19]; #(5*`CLK_PERIOD) result[19] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;

	tdi <= data[20]; #(5*`CLK_PERIOD) result[20] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[21]; #(5*`CLK_PERIOD) result[21] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[22]; #(5*`CLK_PERIOD) result[22] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[23]; #(5*`CLK_PERIOD) result[23] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;

	tdi <= data[24]; #(5*`CLK_PERIOD) result[24] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[25]; #(5*`CLK_PERIOD) result[25] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[26]; #(5*`CLK_PERIOD) result[26] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[27]; #(5*`CLK_PERIOD) result[27] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;

	tdi <= data[28]; #(5*`CLK_PERIOD) result[28] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[29]; #(5*`CLK_PERIOD) result[29] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[30]; #(5*`CLK_PERIOD) result[30] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= data[31]; #(5*`CLK_PERIOD) result[31] <= tdo;  tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;

	tdi <= addr[0]; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= addr[1]; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= addr[2]; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= addr[3]; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= addr[4]; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tdi <= addr[5]; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b1;
	tdi <= 1'b0; #(10*`CLK_PERIOD) tck <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b0;
	// goto Update-DR state
	tdi <= 1'b0;
	tms <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b0;
	// goto RUN_TEST_IDLE state
	tms <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(10*`CLK_PERIOD) tck <= 1'b0;
end
endtask

task jtag_wait8;
begin
	tms <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
	tms <= 1'b0; #(5*`CLK_PERIOD) tck <= 1'b1; #(5*`CLK_PERIOD) tck <= 1'b0;
end
endtask

task jtag_dmi_read;
input [5:0] addr;
output reg [31:0] result;

begin
	jtag_dmi_write(addr,32'h0,2'h1,result);	// dummy write to copy data to DMI
	jtag_dmi_write(addr,32'h0,2'h1,result);	// dummy write to retrieve output
	// DEBUG $display("dmi: read from %h : %h",addr, result);
end
endtask

task jtag_write_mem;
input [31:0] maddr;
input [31:0] mwdata;
output reg [31:0] result;
begin
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	// stay and wait ...
	jtag_wait8;

	// sw s1, s0(0) - 0000 0000 1001 0100 0010 0000 0010 0011 - 00942023
	// addi s0, s0, 4 - 0000 0000 0100 0100 0000 0100 0001 0011 - 00440413

	jtag_dmi_write(6'h20,32'h00942023,2'h2,result);
	jtag_dmi_write(6'h21,32'h00440413,2'h2,result);
	jtag_dmi_write(6'h04,maddr,2'h2,result);	// data0
	jtag_dmi_write(6'h17,32'h00231008,2'h2,result);	// command
	jtag_dmi_write(6'h04,mwdata,2'h2,result);	// data0
	jtag_dmi_write(6'h17,32'h00271009,2'h2,result);	// command
end
endtask

task jtag_read_mem;
input [31:0] maddr;
output reg [31:0] result;
begin
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	// stay and wait ...
	jtag_wait8;

	// lw s0, 0(s0) - 0000 0000 0000 0100 0010 0100 0000 0011 - 00042403
	// ebreak - 0000 0000 0001 0000 0000 0000 0111 0011 - 00100073

	jtag_dmi_write(6'h20,32'h00042403,2'h2,result);
	jtag_dmi_write(6'h21,32'h00100073,2'h2,result);
	jtag_dmi_write(6'h04,maddr,2'h2,result);	// data0
	jtag_dmi_read(6'h04,result);
	jtag_dmi_write(6'h17,32'h00271008,2'h2,result);	// command (write s0, postexec)
	jtag_dmi_write(6'h17,32'h00221008,2'h2,result);	// command (read s0)
	jtag_dmi_read(6'h04,result);
end
endtask



task jtag_write_mem_burst;
input [31:0] maddr;
input [31:0] mwdata;
output reg [31:0] result;
begin
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	// stay and wait ...
	jtag_wait8;

	// sw s1, s0(0) - 0000 0000 1001 0100 0010 0000 0010 0011 - 00942023
	// addi s0, s0, 4 - 0000 0000 0100 0100 0000 0100 0001 0011 - 00440413

	jtag_dmi_write(6'h20,32'h00942023,2'h2,result);
	jtag_dmi_write(6'h21,32'h00440413,2'h2,result);
	jtag_dmi_write(6'h04,maddr,2'h2,result);	// data0
	jtag_dmi_write(6'h17,32'h00231008,2'h2,result);	// command
	jtag_dmi_write(6'h04,mwdata,2'h2,result);	// data0
	jtag_dmi_write(6'h17,32'h00271009,2'h2,result);	// command
end

endtask

