`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:Thomas
// 
// Create Date: 12.07.2019 09:50:36
// Design Name: 
// Module Name: raifes_top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module raifes_top_tb();
        wire					            per_en;		// enable periphery in general
		wire	[`HASTI_ADDR_WIDTH-1:0]		per_haddr;
		wire					            per_hwrite;
		wire	[`HASTI_SIZE_WIDTH-1:0]		per_hsize;
		wire	[`HASTI_BURST_WIDTH-1:0]	per_hburst;
		wire					            per_hmastlock;
		wire	[`HASTI_TRANS_WIDTH-1:0]	per_htrans;
		wire	[`HASTI_BUS_WIDTH-1:0]		per_hwdata;		
		wire	[`HASTI_BUS_WIDTH-1:0]		per_hrdata;
		wire					            per_hready;
		wire	[`HASTI_RESP_WIDTH-1:0]		per_hresp;
		assign per_hresp = 1'b0;
assign per_hready = 1'b1;

        reg	CLK, RESET;
//        integer	testcase;
//        integer i;
//        reg	[31:0]	theword;
        reg	tck;
        reg	tms;
        reg	tdi;
        wire	tdo;
        wire [3:0] dm_state;
        
//           reg clk_bram;
    raifes_top cpu(
        .clk(CLK),
        .reset(RESET),
        
        .tck(tck),
        .tdi(tdi),
        .tdo(tdo),
        .tms(tms),
        
        .dm_state(dm_state),
        
        .per_en(per_en),
        .per_haddr(per_haddr),
        .per_hwrite(per_hwrite),
        .per_hrdata(per_hrdata),
        .per_hwdata(per_hwdata),
        .per_hsize(per_hsize),
        .per_hburst(per_hburst),
        .per_hmastlock(per_hmastlock),
        .per_htrans(per_htrans),
        .per_hready(per_hready),
        .per_hresp(per_hresp)      
        
    );
    
    crypto_module theCryptoModule(
        .clk(CLK),
		.per_en(per_en),
		.per_haddr(per_haddr),
		.per_hwrite(per_hwrite),
		.per_hsize(per_hsize),
		.per_hburst(per_hburst),
		.per_hmastlock(per_hmastlock),
		.per_htrans(per_htrans),
		.per_hwdata(per_hwdata),
		.per_hrdata(per_hrdata)   
);

    UART_module theUARTModule(
        .clk(CLK),
		.per_en(per_en),
		.per_haddr(per_haddr),
		.per_hwrite(per_hwrite),
		.per_hsize(per_hsize),
		.per_hburst(per_hburst),
		.per_hmastlock(per_hmastlock),
		.per_htrans(per_htrans),
		.per_hwdata(per_hwdata),
		.per_hrdata(per_hrdata)   
);
    
////                      //
//// **PRINCE Cipher**    //
////                      //
//reg [31:0] PRINCE_ctrl,PRINCE_in0,PRINCE_in1,PRINCE_key0,PRINCE_key1,PRINCE_key2,PRINCE_key3;
//wire PRINCE_reset,PRINCE_enable,PRINCE_finish,PRINCE_enc_ndec;
//wire [63:0] PRINCE_plain_in,PRINCE_cipher_out;
//wire [127:0] PRINCE_key_in;
//assign PRINCE_plain_in = {PRINCE_in1,PRINCE_in0};
////assign PRINCE_cipher_out = {PRINCE_out1,PRINCE_out0};
//assign PRINCE_key_in = {PRINCE_key3,PRINCE_key2,PRINCE_key1,PRINCE_key0};
////assign PRINCE_finish = PRINCE_ctrl[0];
//assign PRINCE_enable = PRINCE_ctrl[1];
//assign PRINCE_reset = PRINCE_ctrl[2];
//assign PRINCE_enc_ndec = PRINCE_ctrl[3];

//prince_top thePRINCEcipher(
//    .clk(CLK),
//    .reset(PRINCE_reset),
//    .enable(PRINCE_enable),
//    .finish(PRINCE_finish),
//    .enc_ndec(PRINCE_enc_ndec),
//    .plain_in(PRINCE_plain_in),         //64Bit
//    .cipher_out(PRINCE_cipher_out),     //64Bit
//    .key_in(PRINCE_key_in)              //128Bit
//);
    

//reg [31:0] per_out;
//wire uart_tx;

//assign per_hrdata = {24'h0,per_out};
//reg [31:0] UART_reg; // Bits: 9=uart_reset, 8=send_strobe, 7-0=data_byte
//wire [7:0] uart_byte_in;
//wire uart_send_strobe,uart_ready,uart_reset;
//assign uart_send_strobe = UART_reg[8];
//assign uart_reset = UART_reg[9];
//assign uart_byte_in = UART_reg[7:0];

//always @(posedge CLK)
//begin
//    if(per_en)
//    begin
//        case(per_haddr)
//            32'hC0000000:   begin
//                                if(per_hwrite) LED <= per_hwdata;
//                                else per_out <= SW;
//                            end
//            32'hC0000004: begin
//                               if(per_hwrite) UART_reg <= per_hwdata;
//                               else per_out <= {{31{1'b0}},uart_ready};
//                          end
//            32'hC0010000:   begin
//                                if(per_hwrite) PRINCE_in0 <= per_hwdata;
//                                else per_out <= PRINCE_in0;
//                            end
//            32'hC0010004:   begin
//                                if(per_hwrite) PRINCE_in1 <= per_hwdata;
//                                else per_out <= PRINCE_in1;                                
//                            end
//            32'hC0010008:   begin
//                                if(!per_hwrite) per_out <= PRINCE_cipher_out[31:0];                                
//                            end                            
//            32'hC001000C:   begin
//                                if(!per_hwrite) per_out <= PRINCE_cipher_out[63:32];                                
//                            end                           
//            32'hC0010010:   begin
//                                if(per_hwrite) PRINCE_key0 <= per_hwdata;
//                                else per_out <= PRINCE_key0;                                
//                            end                            
//            32'hC0010014:   begin
//                                if(per_hwrite) PRINCE_key1 <= per_hwdata;
//                                else per_out <= PRINCE_key1;                                
//                            end                            
//            32'hC0010018:   begin
//                                if(per_hwrite) PRINCE_key2 <= per_hwdata;
//                                else per_out <= PRINCE_key2;                                
//                            end                           
//            32'hC001001C:   begin
//                                if(per_hwrite) PRINCE_key3 <= per_hwdata;
//                                else per_out <= PRINCE_key3;                                
//                            end
//            32'hC0010020:   begin
//                                if(per_hwrite) begin
//                                                PRINCE_ctrl[31:4] <= 28'h0;
//                                                PRINCE_ctrl[3:1] <= per_hwdata[3:1];
//                                               end
//                                else per_out <= {28'h0,PRINCE_ctrl[3:1],PRINCE_finish};                                
//                            end 
//            default: begin per_out <= 1'b1; end       
//        endcase
//    end
//end

//    raifes_uart theUART(
//    .reset(uart_reset),
//    .clk(CLK),
//    .sdata(uart_byte_in),
//    .send_strobe(uart_send_strobe),
//    .ready(uart_ready),
//    .UART_TX(uart_tx)
//);


always begin
	#50
	CLK <= ~CLK;
end

//initial
//begin
//    CLK = 0;
//    RESET = 1;
//    #100 RESET = 0;
//end


reg [31:0] result;
//reg [31:0] memimg[256000000-1:0];
//reg [31:0] errorcount;
`define CLK_PERIOD 50
`include "jtag_tasks.vh"



                    //Initial Block für stepmode test mit BRAMInit Programm
initial begin
	$write("==================================\n");
	$write("==== FLAVOR TESTBENCH STARTET ====\n");
	$write("==================================\n");
	CLK <= 1'b0;RESET <= 1'b0;
	#(56*`CLK_PERIOD); 
	RESET <= 1'b1;
//	$monitor("addr: ", DUT.dmi_addr, " wen: ", DUT.dmi_wen, " en: ", DUT.dmi_en, " rdata: %h", DUT.dmi_rdata, " wdata: %h", DUT.dmi_wdata);
	#53 RESET <= 1'b1;
	
	tms <= 1'b0; tdi <= 1'b0; tck <= 1'b0;
	$write("waiting for NVRAM startup..\n");
	#2000000;
	$write("disabling RESET..\n");
	RESET <= 1'b1; #103 RESET <= 1'b0;
	$write("JTAG TAP: reset..\n");
	// JTAG TAP reset
	jtag_tap_reset;
	// send halt request	
	$write("JTAG TAP: send halt request.\n");
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	// stay and wait ...
	$write("JTAG TAP: wait some cycles.\n");
	jtag_wait8;
	// read debug status
	$write("JTAG TAP: Read status of debug module..\n");
	jtag_dmi_read(5'h12,result);
	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	// send resume request
	$write("JTAG TAP: Request resume..\n");
	jtag_dmi_write(6'h04,32'h40000004,2'h2,result);	// data0 (set stepmode bit...
	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	#2000;
	$write("JTAG TAP: send halt request.\n");
	jtag_dmi_write(6'h04,32'h40000000,2'h2,result);	// data0 (clear stepmode bit...
	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
    
    #500000
    RESET <= 1;
    #2000 RESET <= 0;
    	
    #500000
    	$write("JTAG TAP: send halt request.\n");
	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
    #2000000
    $write("JTAG TAP: Request resume..\n");
	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);	
	#100000
    jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	#100000
	jtag_dmi_write(5'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
	jtag_dmi_write(5'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
	jtag_dmi_write(5'h10,32'h00000000,2'h2,result); // .. and resume
	
	
	
			
	
	
	
	
	
	
	
	
	
		
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//	    #500000
//    $write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#100000;
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
	
	
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
//			   #500000
//    	$write("JTAG TAP: Request resume..\n");
//	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
//	#2000;
//	$write("JTAG TAP: send halt request.\n");
//	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
//	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
//	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);

	
	
	end



////reg [31:0] result;
////reg [31:0] memimg[256000000-1:0];
////reg [31:0] errorcount;
////`define CLK_PERIOD 50
////`include "jtag_tasks.vh"

////task run_test_program;
////input reg[7:0]	testnum;
////input reg[255*8:1]	filename;
////input reg[15:0]	length;
////output reg[31:0] result;
////begin
////	testcase = testnum;	// marker variable so we can trace the results in simvision more easily.
////	$write("read mem file for testcase ", testnum);
////	// read program into buffer
////	$readmemh(filename,memimg);

////	// write to QSPI-Flash via JTAG
////	for (i = 0; i < length; i = i + 1) begin
////		jtag_write_mem(32'h80000000 + i*4,memimg[i],result);
////	end

////	$write(" o.k., running..");
////	//$monitor("tohost: %h",DUT.debug_out);

////	#1000 RESET <= 1'b1;
////	#100 RESET <= 1'b0;
////	#5000000;

//////	if(cpu.debug_out == 1)begin
//////		result = 0;
//////		 $write("success.\n");
//////	end
//////	else begin
//////		$write("error.\n");
//////		result = 1;
//////	end
////end
////endtask

////task run_test_program_break;
////input reg[7:0]	testnum;
////input reg[255*8:1]	filename;
////input reg[15:0]	length;
////output reg[31:0] result;
////begin
////	testcase = testnum;	// marker variable so we can trace the results in simvision more easily.
////	$write("read mem file for testcase ", testnum);
////	// read program into buffer
////	$readmemh(filename,memimg);

////	// write to QSPI-Flash via JTAG
////	for (i = 0; i < length; i = i + 1) begin
////		jtag_write_mem(32'h80000000 + i*4,memimg[i],result);
////	end

////	$write(" o.k., running..");
////	//$monitor("tohost: %h",DUT.debug_out);
////	#1000 RESET <= 1'b1;
////	#100 RESET <= 1'b0;
////	#1000000;
////	$write("JTAG TAP: send halt request.\n");
////	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
////	#5000000;
////	// abstract command to access register
////	// dcsr for hart0 stepmode
////	// 0000 0000 0000 0000 1111 0000 0000 0100
////	jtag_dmi_write(5'h04,32'h0000f004,2'h2,result);	
////	// write word to dcsr
////	// 0000 0000 0010 0011 0000 0111 1011 0000
////	jtag_dmi_write(5'h17,32'h002307b0,2'h2,result);
////	// resume
////	$display("resume at:%0t\n",$time);
////	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
////	#5000000;
////	if(cpu.debug_out == 1)begin
////		result = 0;
////		 $write("success.\n");
////	end
////	else begin
////		$write("error.\n");
////		result = 1;
////	end
////end
////endtask

////initial begin
////	$write("==================================\n");
////	$write("==== FLAVOR TESTBENCH STARTET ====\n");
////	$write("==================================\n");
////	CLK <= 1'b0;RESET <= 1'b0;SW <= 8'hAA;
////	#(56*`CLK_PERIOD); 
////	CLK <= 1'b0; RESET <= 1'b1;
////	RESET <= 1'b1;
//////	$monitor("addr: ", DUT.dmi_addr, " wen: ", DUT.dmi_wen, " en: ", DUT.dmi_en, " rdata: %h", DUT.dmi_rdata, " wdata: %h", DUT.dmi_wdata);
////	#53 RESET <= 1'b1;
	
////	tms <= 1'b0; tdi <= 1'b0; tck <= 1'b0;
////	$write("waiting for NVRAM startup..\n");
////	#2000000;
////	$write("disabling RESET..\n");
////	RESET <= 1'b1; #103 RESET <= 1'b0;
////	$write("JTAG TAP: reset..\n");
////	// JTAG TAP reset
////	jtag_tap_reset;
////	// send halt request	
////	$write("JTAG TAP: send halt request.\n");
////	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
////	// stay and wait ...
////	$write("JTAG TAP: wait some cycles.\n");
////	jtag_wait8;
////	// read debug status
////	$write("JTAG TAP: Read status of debug module..\n");
////	jtag_dmi_read(5'h12,result);
////	// send resume request
////	$write("JTAG TAP: Request resume..\n");
////	jtag_dmi_write(6'h04,32'h00000004,2'h2,result);	// data0 (set stepmode bit...
////	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
////	jtag_dmi_write(5'h10,32'h40000000,2'h2,result); // .. and resume
////	#2000;
////	$write("JTAG TAP: send halt request.\n");
////	jtag_dmi_write(6'h04,32'h00000000,2'h2,result);	// data0 (clear stepmode bit...
////	jtag_dmi_write(6'h17,32'h002307b0,2'h2,result);	// command ... in dcsr)
////	jtag_dmi_write(5'h10,32'h80000000,2'h2,result);
    
    
////// === nächsten Abschnitt unkommentieren, um ein Programm in den Speicher zu laden und auszuführen
////	$write("===================== \n");
////	$write("= Instruction Tests = \n");
////	$write("===================== \n");

////errorcount <= 0;

////// ========================
////// == 1 - ISA test - ADDI =
////// ========================
////$write("ADDI   : ");
////run_test_program_break(1,"./memfiles/rv32ui-p-addi.mem",262,result);
////if(result != 0) errorcount = errorcount + 1;
////$finish();
	
////// ====================
////// == 2- ISA test - ADD  =
////// ====================
////$write("ADD    : ");
////run_test_program(2,"./memfiles/rv32ui-p-add.mem",407,result);

////if(result != 0) errorcount = errorcount + 1;

//////// ====================
//////// == 3 - ISA test - ANDI =
//////// ====================
//////$write("ANDI   : ");
//////run_test_program(3,"./memfiles/rv32ui-p-andi.mem",214,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// ====================
//////// == 4 - ISA test - AND  =
//////// ====================
//////$write("AND    : ");
//////run_test_program(4,"./memfiles/rv32ui-p-and.mem",386,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// ======================
//////// == 5 - ISA test - AUIPC  =
//////// ======================
//////$write("AUIPC  : ");
//////run_test_program(5,"./memfiles/rv32ui-p-auipc.mem",128,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// ====================
//////// == 6 - ISA test - BEQ  =
//////// ====================
//////$write("BEQ    : ");
//////run_test_program(6,"./memfiles/rv32ui-p-beq.mem",256,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// ====================
//////// == 7 - ISA test - BGE  =
//////// ====================
//////$write("BGE    : ");
//////run_test_program(7,"./memfiles/rv32ui-p-bge.mem",300,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// ====================
//////// == 8 - ISA test - BLT  =
//////// ====================
//////$write("BLT    : ");
//////run_test_program(8,"./memfiles/rv32ui-p-blt.mem",280,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 9 - ISA test - BLTU  =
//////// =====================
//////$write("BLTU   : ");
//////run_test_program(9,"./memfiles/rv32ui-p-bltu.mem",274,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 10 - ISA test - BNE  =
//////// =====================
//////$write("BNE    : ");
//////run_test_program(10,"./memfiles/rv32ui-p-bne.mem",258,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// ========================
//////// == 11 - ISA test - FENCE_I  =
//////// ========================
//////$write("FENCE_I: ");
//////run_test_program(11,"./memfiles/rv32ui-p-fence_i.mem",2060,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 12 - ISA test - JAL   =
//////// =====================
//////$write("JAL    : ");
//////run_test_program(12,"./memfiles/rv32ui-p-jal.mem",100,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 13 - ISA test - JALR  =
//////// =====================
//////$write("JALR   : ");
//////run_test_program(13,"./memfiles/rv32ui-p-jalr.mem",130,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 14 - ISA test - LB    =
//////// =====================
//////$write("LB     : ");
//////run_test_program(14,"./memfiles/rv32ui-p-lb.mem",2060,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 15 - ISA test - LBU  =
//////// =====================
//////$write("LBU    : ");
//////run_test_program(15,"./memfiles/rv32ui-p-lbu.mem",2060,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 16 - ISA test - LH    =
//////// =====================
//////$write("LH     : ");
//////run_test_program(16,"./memfiles/rv32ui-p-lh.mem",2060,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 17 - ISA test - LHU   =
//////// =====================
//////$write("LHU    : ");
//////run_test_program(17,"./memfiles/rv32ui-p-lhu.mem",2060,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 18 - ISA test - LUI   =
//////// =====================
//////$write("LUI    : ");
//////run_test_program(18,"./memfiles/rv32ui-p-lui.mem",100,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 19 - ISA test - LW   =
//////// =====================
//////$write("LW     : ");
//////run_test_program(19,"./memfiles/rv32ui-p-lw.mem",2060,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 20 - ISA test - OR  =
//////// =====================
//////$write("OR     : ");
//////run_test_program(20,"./memfiles/rv32ui-p-or.mem",390,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 21 - ISA test - ORI   =
//////// =====================
//////$write("ORI    : ");
//////run_test_program(21,"./memfiles/rv32ui-p-ori.mem",200,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 22 - ISA test - SB   =
//////// =====================
//////$write("SB     : ");
//////run_test_program(22,"./memfiles/rv32ui-p-sb.mem",2060,result);

//////if(result != 0) errorcount = errorcount + 1;


//////$write("\n\n Instruction Tests completed with errorcount = ",errorcount);
//////$write("\n\n");
//////$finish();
//////	$write("recording outputs..\n");
//////	$shm_open("output.shm");
//////	$shm_probe("AC");
//////// =====================
//////// == 23 - ISA test - SH  =
//////// =====================
//////$write("SH     : ");
//////run_test_program(23,"./memfiles/rv32ui-p-sh.mem",2060,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 24 - ISA test - SLLI  =
//////// =====================
//////$write("SLLI   : ");
//////run_test_program(24,"./memfiles/rv32ui-p-slli.mem",243,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 25 - ISA test - SLL  =
//////// =====================
//////$write("SLL    : ");
//////run_test_program(25,"./memfiles/rv32ui-p-sll.mem",420,result);

//////if(result != 0) errorcount = errorcount + 1;

//////// =====================
//////// == 26 - ISA test - SLTI  =
//////// =====================
//////$write("SLTI    : ");
//////run_test_program(26,"./memfiles/rv32ui-p-slti.mem",244,result);

//////if(result != 0) errorcount = errorcount + 1;

///////*
//////// =====================
//////// == ISA test - SLTIU  =
//////// =====================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$write("reading mem file rv32ui-p-sltiu.mem ..		");	
//////	$readmemh("./memfiles/rv32ui-p-sltiu.mem",DUT.myRAM.mem);
//////	#50 RESET <= 1'b0;
//////	#10000
//////	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
//////	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
//////	else $strobe("ERROR.\n");
//////	#2

//////// =====================
//////// == ISA test - SLT   =
//////// =====================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$write("reading mem file rv32ui-p-slt.mem ..		");	
//////	$readmemh("./memfiles/rv32ui-p-slt.mem",DUT.myRAM.mem);
//////	#50 RESET <= 1'b0;
//////	#10000
//////	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
//////	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
//////	else $strobe("ERROR.\n");
//////	#2

//////// =====================
//////// == ISA test - SLTU  =
//////// =====================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$write("reading mem file rv32ui-p-sltu.mem ..		");	
//////	$readmemh("./memfiles/rv32ui-p-sltu.mem",DUT.myRAM.mem);
//////	#50 RESET <= 1'b0;
//////	#10000
//////	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
//////	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
//////	else $strobe("ERROR.\n");
//////	#2

//////// =====================
//////// == ISA test - SRAI  =
//////// =====================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$write("reading mem file rv32ui-p-srai.mem ..		");	
//////	$readmemh("./memfiles/rv32ui-p-srai.mem",DUT.myRAM.mem);
//////	#50 RESET <= 1'b0;
//////	#10000
//////	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
//////	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
//////	else $strobe("ERROR.\n");
//////	#2

//////// =====================
//////// == ISA test - SRA   =
//////// =====================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$write("reading mem file rv32ui-p-sra.mem ..		");	
//////	$readmemh("./memfiles/rv32ui-p-sra.mem",DUT.myRAM.mem);
//////	#50 RESET <= 1'b0;
//////	#20000
//////	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
//////	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
//////	else $strobe("ERROR.\n");
//////	#2

//////// =====================
//////// == ISA test - SRLI  =
//////// =====================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$write("reading mem file rv32ui-p-srli.mem ..		");	
//////	$readmemh("./memfiles/rv32ui-p-srli.mem",DUT.myRAM.mem);
//////	#50 RESET <= 1'b0;
//////	#10000
//////	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
//////	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
//////	else $strobe("ERROR.\n");
//////	#2

//////// =====================
//////// == ISA test - SRL   =
//////// =====================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$write("reading mem file rv32ui-p-srl.mem ..		");	
//////	$readmemh("./memfiles/rv32ui-p-srl.mem",DUT.myRAM.mem);
//////	#50 RESET <= 1'b0;
//////	#20000
//////	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
//////	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
//////	else $strobe("ERROR.\n");
//////	#2

//////// =====================
//////// == ISA test - SUB   =
//////// =====================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$write("reading mem file rv32ui-p-sub.mem ..		");	
//////	$readmemh("./memfiles/rv32ui-p-sub.mem",DUT.myRAM.mem);
//////	#50 RESET <= 1'b0;
//////	#10000
//////	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
//////	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
//////	else $strobe("ERROR.\n");
//////	#2

//////// =====================
//////// == ISA test - XORI  =
//////// =====================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$write("reading mem file rv32ui-p-xori.mem ..		");	
//////	$readmemh("./memfiles/rv32ui-p-xori.mem",DUT.myRAM.mem);
//////	#50 RESET <= 1'b0;
//////	#10000
//////	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
//////	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
//////	else $strobe("ERROR.\n");
//////	#2

//////// =====================
//////// == ISA test - XOR  =
//////// =====================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$write("reading mem file rv32ui-p-xor.mem ..		");	
//////	$readmemh("./memfiles/rv32ui-p-xor.mem",DUT.myRAM.mem);
//////	#50 RESET <= 1'b0;
//////	#20000
//////	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
//////	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
//////	else $strobe("ERROR.\n");
//////	#2


//////// ===================================
//////// == Test Program - "RISCV_Test"    =
//////// ===================================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$display("reading mem file RISC_Test.mem ..		");	
//////	$display("");
//////	$readmemh("./memfiles/RISC_Test.mem",DUT.myRAM.mem);
//////	//$monitor("tohost: %c",DUT.myRAM.mem[49153], " i-addr:%h", DUT.imem_haddr," d-addr:%h", DUT.myRAM.ADDRA, " d-data:%h", DUT.myRAM.DIA, " write:%b", DUT.writea);	
//////	//$monitor("%c\n",DUT.myRAM.mem[49153]);

//////	#50 RESET <= 1'b0;
//////	#1800000
//////	$display("\n\n");
//////	#2
////////	$display("%h",DUT.myRAM.mem[3092]);
////////	$finish();

//////// =====================
//////// == ISA test - SB    =
//////// =====================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$write("reading mem file rv32ui-p-sb.mem ..		");	
//////	$readmemh("./memfiles/rv32ui-p-sb.mem",DUT.myRAM.mem);
//////	#50 RESET <= 1'b0;
//////	#40000
//////	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
//////	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
//////	else $strobe("ERROR.\n");
//////	#2


//////// =====================
//////// == ISA test - SW    =
//////// =====================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$write("reading mem file rv32ui-p-sw.mem ..		");	
//////	$readmemh("./memfiles/rv32ui-p-sw.mem",DUT.myRAM.mem);
//////	#50 RESET <= 1'b0;
//////	#20000
//////	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
//////	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
//////	else $strobe("ERROR.\n");
//////	#2

//////// =====================
//////// == ISA test - LW    =
//////// =====================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$write("reading mem file rv32ui-p-lw.mem ..		");	
//////	$readmemh("./memfiles/rv32ui-p-lw.mem",DUT.myRAM.mem);
//////	#50 RESET <= 1'b0;
//////	#10000
//////	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
//////	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
//////	else $strobe("ERROR.\n");
//////	#2


//////// =====================
//////// == ISA test - SIMPLE  =
//////// =====================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$write("reading mem file rv32ui-p-simple.mem ..		");	
//////	$readmemh("./memfiles/rv32ui-p-simple.mem",DUT.myRAM.mem);
//////	#50 RESET <= 1'b0;
//////	#10000
//////	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
//////	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
//////	else $strobe("ERROR.\n");
//////	#2




//////// =============================================================================================
//////// == Dhrystone benchmark								       =
//////// =============================================================================================
//////	RESET <= 1'b1;
//////	CLK <= 1'b0;
//////	$strobe("reading mem file benchmark.mem ..		");	
//////	$readmemh("./memfiles/benchmark.mem",DUT.myRAM.mem);
//////	#50 RESET <= 1'b0;
//////	$monitor("Start/Stop-Flag, mem[4262] = %h @ %d, toHost = %h",DUT.myRAM.mem[4262],$time,DUT.myRAM.mem[1024]);	
//////	#6600000
////////	DUT.myRAM.mem[1040] = 32'h13371337;
////////	DUT.myRAM.mem[1041] = 32'h13371337;
//////	#300000
//////	$write("GP at end: %h -- ",DUT.raifes.pipeline.regfile.data[3]);
//////	if(DUT.raifes.pipeline.regfile.data[3] == `XPR_LEN'h1) $strobe("succes.");
//////	#2
//////	$strobe("Begin Time\t: %h",DUT.myRAM.mem[4261]);
//////	$strobe("End Time\t: %h",DUT.myRAM.mem[4258]);
//////	$strobe("Usertime\t: %h",DUT.myRAM.mem[4259]);
//////	$strobe("out: %h %h %h %h %h %h %h %h",DUT.myRAM.mem[39360],DUT.myRAM.mem[39361],DUT.myRAM.mem[39362],DUT.myRAM.mem[39363],DUT.myRAM.mem[39364],DUT.myRAM.mem[39365],DUT.myRAM.mem[39366],DUT.myRAM.mem[39367]);
//////	$strobe("");
//////	#4 for(i = 0; i <= 63; i = i + 1) begin
////////		theword = DUT.myRAM.mem[6832+i];
//////		theword = DUT.myRAM.mem[39606+i];
//////		$write("%c",(theword & 16'hff));
//////		$write("%c",((theword >> 8) & 16'hff));
//////		$write("%c",((theword >> 16) & 16'hff));
//////		$write("%c",((theword >> 24) & 16'hff));
//////	end
//////	#4 $strobe("");
//////	$strobe("Best DMIPS/MHz (15.02.18, ASt) = (1.000.000cyc / 597cyc) / 1757 = 0,953 DMIPS/MHz");
//////	#1 $finish();
//////	$shm_close();
//////*/
//// end



endmodule
