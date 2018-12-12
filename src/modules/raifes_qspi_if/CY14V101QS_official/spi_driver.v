// +FHDR -----------------------------------------------------------------------
// Copyright 2016, Cypress Semiconductor Corporation
// Cypress Confidential Proprietary
// This code is provided as is without warranty or guarantee of any kind as its accuracy, 
// completeness, operability, fitness for particular purpose, or any other warranty.
// -----------------------------------------------------------------------------
// FILE NAME:  spi_driver.v
// TYPE:       The tasks for generating the testvectors for 1-Mbit Quad SPI nvSRAM 
//             with RTC verilog model
// -----------------------------------------------------------------------------
// Release History
// Revision 1.0  08/02/2016 - Initial test vectors
//
// -----------------------------------------------------------------------------
// DESCRIPTION:  This is part of behavioral model for 1Mbit Quad SPI nvSRAM with RTC.
// -----------------------------------------------------------------------------

`define  ADDR_BITS 17
`define  DATA_BITS 8

reg spi_sck;
wire spi_sck_in;
reg tb_clock_reg;
wire tb_clock;
reg spi_default_clock;
real qspi_clock_period;
reg si_in;
reg so_in;
reg wp_in;
reg io3_in;
reg cs_in;
reg [7:0] last_read_byte;
reg [7:0] xip;
reg xip_mode;
reg hsb_in;
reg [4:0] spi_clock_select;
reg spi_current_mode;

//These values are driven by a zero delay tasks
reg set_wp_val;
reg set_io3_val;
reg clock_active;

assign spi_sck_in = (clock_active) ? spi_sck : spi_default_clock;

initial
begin
    spi_clock_select = 5'b01000;
    spi_current_mode = MODE0;
    `ifdef SPI_MODE3
        spi_default_clock = 1'b1;
        spi_current_mode = MODE3;
    `else
        //default: MODE0
        spi_default_clock = 1'b0;
        spi_current_mode = MODE0;
    `endif
    `ifdef CLOCK_108MHZ
        spi_clock_select = 5'b10000;
    `endif
    `ifdef CLOCK_40MHZ
        spi_clock_select = 5'b01000;
    `endif
    `ifdef CLOCK_20MHZ
        spi_clock_select = 5'b00100;
    `endif
    `ifdef CLOCK_10MHZ
        spi_clock_select = 5'b00010;
    `endif
    `ifdef CLOCK_1MHZ
        spi_clock_select = 5'b00001;
    `endif

    set_spi_clock_period(spi_clock_select);

    spi_sck = 1'b0;
    tb_clock_reg = 1'b0;
    cs_in = 1'b1;
    set_wp_val = 1'b1;
    set_io3_val = 1'b1;
    wp_in = 1'b1;
    io3_in = 1'b1;
    si_in = 1'bz;
    so_in = 1'bz;
    hsb_in = 1'bz;
    xip = 8'h0;
    xip_mode = 1'b0;
    clock_active = 1'b0;
end

task set_spi_clock_period;
input [4:0] freq;
begin
    case(freq)
    5'b10000:
                begin
                $display("clock is 108MHz");
                //qspi_clock_period = 9.248;
                qspi_clock_period = 10;
                end
    5'b01000:
                begin
                $display("clock is 40MHz");
                qspi_clock_period = 25;
                end
    5'b00100:
                begin
                $display("clock is 20MHz");
                qspi_clock_period = 50;
                end
    5'b00010:
                begin
                $display("clock is 10MHz");
                qspi_clock_period = 100;
                end
    5'b00001:
                begin
                $display("clock is 1MHz");
                qspi_clock_period = 1000;
                end
        default:
                begin
                $display("default clock is 40MHz");
                qspi_clock_period = 25;
                end
    endcase
end
endtask

task change_spi_clock;
input [7:0] freq;
begin
    case(freq)
        CLOCK_1MHZ   :spi_clock_select = 5'b00001;
        CLOCK_10MHZ  :spi_clock_select = 5'b00010;
        CLOCK_20MHZ  :spi_clock_select = 5'b00100;
        CLOCK_40MHZ  :spi_clock_select = 5'b01000;
        CLOCK_108MHZ :spi_clock_select = 5'b10000;
        default:      spi_clock_select = 5'b01000;
    endcase
    set_spi_clock_period(spi_clock_select);
end
endtask

always tb_clock_reg        =  #(qspi_clock_period/4) ~tb_clock_reg;
assign  #0.1 tb_clock      = tb_clock_reg;

always @(posedge tb_clock_reg)
begin
   spi_sck <= ~spi_sck;
end



function [`DATA_BITS-1:0] get_data;
input [7:0] pattern;
input [`ADDR_BITS-1:0] addr;
input [`DATA_BITS-1:0] first_data;
input [31:0] nwrite;
begin
    case(pattern)
        PATTERN_DATA_EQ_ADDR  : get_data = addr[7:0] + nwrite;
        PATTERN_DATA_EQ_ADDRB : get_data = ~ (addr[7:0] + nwrite);
        PATTERN_DATA_EQ_ALL0  : get_data = 8'h0;
        PATTERN_DATA_EQ_ALL1  : get_data = 8'hFF;
        PATTERN_DATA_EQ_AA    : get_data = 8'hAA;
        PATTERN_DATA_EQ_55    : get_data = 8'h55;
        PATTERN_DATA_EQ_A5    : get_data = 8'hA5;
        PATTERN_DATA_EQ_5A    : get_data = 8'h5A;
        PATTERN_DATA_INCR     : get_data = first_data + nwrite;
        PATTERN_CHECKERB      : get_data = (nwrite%2) ? ~first_data : first_data;
    endcase
end
endfunction

task spi_reset;
begin
    $display("SPI RESET OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,RESET_OPCODE);
    drive_cs(1'b1);
end
endtask

task dpi_reset;
begin
    $display("DPI RESET OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,RESET_OPCODE);
    drive_cs(1'b1);
end
endtask

task qpi_reset;
begin
        $display("QPI RESET OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,RESET_OPCODE);
    drive_cs(1'b1);
end
endtask

task spi_rsten;
begin
        $display("SPI RESEN OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,RSTEN_OPCODE);
    drive_cs(1'b1);
end
endtask

task dpi_rsten;
begin
    $display("DPI RESEN OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,RSTEN_OPCODE);
    drive_cs(1'b1);
end
endtask

task qpi_rsten;
begin
        $display("QPI RESEN OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,RSTEN_OPCODE);
    drive_cs(1'b1);
end
endtask

task spi_wrsr;
input [7:0] data_in;
begin
        $display("SPI WRSR OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,WRSR_OPCODE);
    do_drive(SPI,8,data_in);
    drive_cs(1'b1);
end
endtask

task dpi_wrsr;
input [7:0] data_in;
begin
        $display("DPI WRSR OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,WRSR_OPCODE);
    do_drive(DPI,8,data_in);
    drive_cs(1'b1);
end
endtask

task qpi_wrsr;
input [7:0] data_in;
begin
        $display("QPI WRSR OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,WRSR_OPCODE);
    do_drive(QPI,8,data_in);
    drive_cs(1'b1);
end
endtask

task spi_rdsr;
input [7:0] exp_data;
begin
        $display("SPI RDSR OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,RDSR_OPCODE);
    do_sample(SPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task dpi_rdsr;
input [7:0] exp_data;
begin
        $display("DPI RDSR OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,RDSR_OPCODE);
    do_sample(DPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task qpi_rdsr;
input [7:0] exp_data;
begin
        $display("QPI RDSR OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,RDSR_OPCODE);
    do_sample(QPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task spi_rdcr;
input [7:0] exp_data;
begin
        $display("SPI RDCR OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,RDCR_OPCODE);
    do_sample(SPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task dpi_rdcr;
input [7:0] exp_data;
begin
        $display("DPI RDCR OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,RDCR_OPCODE);
    do_sample(DPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task qpi_rdcr;
input [7:0] exp_data;
begin
        $display("QPI RDSR OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,RDCR_OPCODE);
    do_sample(QPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask


task spi_dpien;
begin
        $display("SPI mode - DPIEN OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,DPIEN_OPCODE);
    drive_cs(1'b1);
end
endtask

task qpi_dpien;
begin
        $display("QPI mode - DPIEN OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,DPIEN_OPCODE);
    drive_cs(1'b1);
end
endtask

task spi_qpien;
begin
        $display("SPI mode - QPIEN OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,QPIEN_OPCODE);
    drive_cs(1'b1);
end
endtask

task dpi_qpien;
begin
        $display("DPI mode - QPIEN OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,QPIEN_OPCODE);
    drive_cs(1'b1);
end
endtask


task spi_wren;
begin
        $display("SPI WREN OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,WREN_OPCODE);
    drive_cs(1'b1);
end
endtask

task spi_wrdi;
begin
        $display("SPI WRDI OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,WRDI_OPCODE);
    drive_cs(1'b1);
end
endtask

task dpi_wren;
begin
        $display("DPI WREN OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,WREN_OPCODE);
    drive_cs(1'b1);
end
endtask

task dpi_wrdi;
begin
        $display("DPI WRDI OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,WRDI_OPCODE);
    drive_cs(1'b1);
end
endtask

task qpi_wren;
begin
        $display("QPI WREN OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,WREN_OPCODE);
    drive_cs(1'b1);
end
endtask

task qpi_wrdi;
begin
        $display("QPI WRDI OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,WRDI_OPCODE);
    drive_cs(1'b1);
end
endtask

task spi_wrsn;
input [7:0] data_pattern;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("SPI WRSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,WRSN_OPCODE);
    for(i=0;i<8;i=i+1)
        begin
        pdata = get_data(data_pattern,17'h0,8'h0,i);
        do_drive(SPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task spi_rdsn;
input [7:0] data_pattern;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("SPI RDSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,RDSN_OPCODE);
    for(i=0;i<8;i=i+1)
        begin
        pdata = get_data(data_pattern,17'h0,8'h0,i);
        do_sample(SPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task spi_fast_rdsn;
input [7:0] data_pattern;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("SPI FAST RDSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,FAST_RDSN_OPCODE);
    do_drive(SPI,8,8'h0);
    for(i=0;i<8;i=i+1)
        begin
        pdata = get_data(data_pattern,17'h0,8'h0,i);
        do_sample(SPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask


task spi_wrsn_n;
input [7:0] data_pattern;
input [7:0] start_data_in;
input [31:0] nwrites;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("SPI WRSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,WRSN_OPCODE);
    for(i=0;i<nwrites;i=i+1)
        begin
        pdata = get_data(data_pattern,start_data_in,start_data_in,i);
        do_drive(SPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task spi_rdsn_n;
input [7:0] data_pattern;
input [7:0] start_data_in;
input [31:0] nbytes;
reg [`DATA_BITS-1:0] pdata;
reg [7:0] sn_addr;
begin
        $display("SPI RDSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,RDSN_OPCODE);
    for(i=0;i<nbytes;i=i+1)
        begin
        sn_addr = i%8;
        pdata = get_data(data_pattern,start_data_in,sn_addr,sn_addr);
        do_sample(SPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task spi_fast_rdsn_n;
input [7:0] data_pattern;
input [7:0] start_data_in;
input [31:0] nbytes;
reg [`DATA_BITS-1:0] pdata;
reg [7:0] sn_addr;
begin
        $display("SPI FAST RDSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,FAST_RDSN_OPCODE);
    do_drive(SPI,8,8'h0);
    for(i=0;i<nbytes;i=i+1)
        begin
        sn_addr = i%8;
        pdata = get_data(data_pattern,start_data_in,sn_addr,sn_addr);
        do_sample(SPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task dpi_wrsn;
input [7:0] data_pattern;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("DPI WRSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,WRSN_OPCODE);
    for(i=0;i<8;i=i+1)
        begin
        pdata = get_data(data_pattern,17'h0,8'h0,i);
        do_drive(DPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task dpi_rdsn;
input [7:0] data_pattern;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("DPI RDSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,RDSN_OPCODE);
    for(i=0;i<8;i=i+1)
        begin
        pdata = get_data(data_pattern,17'h0,8'h0,i);
        do_sample(DPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task dpi_fast_rdsn;
input [7:0] data_pattern;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("DPI FAST RDSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,FAST_RDSN_OPCODE);
    do_drive(DPI,8,8'h0);
    for(i=0;i<8;i=i+1)
        begin
        pdata = get_data(data_pattern,17'h0,8'h0,i);
        do_sample(DPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask



task dpi_wrsn_n;
input [7:0] data_pattern;
input [7:0] start_data_in;
input [31:0] nwrites;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("DPI WRSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,WRSN_OPCODE);
    for(i=0;i<nwrites;i=i+1)
        begin
        pdata = get_data(data_pattern,start_data_in,start_data_in,i);
        do_drive(DPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task dpi_rdsn_n;
input [7:0] data_pattern;
input [7:0] start_data_in;
input [31:0] nbytes;
reg [`DATA_BITS-1:0] pdata;
reg [7:0] sn_addr;
begin
        $display("DPI RDSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,RDSN_OPCODE);
    for(i=0;i<nbytes;i=i+1)
        begin
        sn_addr = i%8;
        pdata = get_data(data_pattern,start_data_in,sn_addr,sn_addr);
        do_sample(DPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task dpi_fast_rdsn_n;
input [7:0] data_pattern;
input [7:0] start_data_in;
input [31:0] nbytes;
reg [`DATA_BITS-1:0] pdata;
reg [7:0] sn_addr;
begin
        $display("DPI FAST RDSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,FAST_RDSN_OPCODE);
    do_drive(DPI,8,8'h0);
    for(i=0;i<nbytes;i=i+1)
        begin
        sn_addr = i%8;
        pdata = get_data(data_pattern,start_data_in,sn_addr,sn_addr);
        do_sample(DPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask


task qpi_wrsn;
input [7:0] data_pattern;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("QPI WRSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,WRSN_OPCODE);
    for(i=0;i<8;i=i+1)
        begin
        pdata = get_data(data_pattern,17'h0,8'h0,i);
        do_drive(QPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task qpi_rdsn;
input [7:0] data_pattern;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("QPI RDSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,RDSN_OPCODE);
    for(i=0;i<8;i=i+1)
        begin
        pdata = get_data(data_pattern,17'h0,8'h0,i);
        do_sample(QPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task qpi_fast_rdsn;
input [7:0] data_pattern;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("QPI FAST RDSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,FAST_RDSN_OPCODE);
    do_drive(QPI,8,8'h0);
    for(i=0;i<8;i=i+1)
        begin
        pdata = get_data(data_pattern,17'h0,8'h0,i);
        do_sample(QPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask


task qpi_wrsn_n;
input [7:0] data_pattern;
input [7:0] start_data_in;
input [31:0] nwrites;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("QPI WRSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,WRSN_OPCODE);
    for(i=0;i<nwrites;i=i+1)
        begin
        pdata = get_data(data_pattern,start_data_in,start_data_in,i);
        do_drive(QPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task qpi_rdsn_n;
input [7:0] data_pattern;
input [7:0] start_data_in;
input [31:0] nbytes;
reg [`DATA_BITS-1:0] pdata;
reg [7:0] sn_addr;
begin
        $display("QPI RDSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,RDSN_OPCODE);
    for(i=0;i<nbytes;i=i+1)
        begin
        sn_addr = i%8;
        pdata = get_data(data_pattern,start_data_in,sn_addr,sn_addr);
        do_sample(QPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task qpi_fast_rdsn_n;
input [7:0] data_pattern;
input [7:0] start_data_in;
input [31:0] nbytes;
reg [`DATA_BITS-1:0] pdata;
reg [7:0] sn_addr;
begin
        $display("QPI FAST RDSN OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,FAST_RDSN_OPCODE);
    do_drive(QPI,8,8'h0);
    for(i=0;i<nbytes;i=i+1)
        begin
        sn_addr = i%8;
        pdata = get_data(data_pattern,start_data_in,sn_addr,sn_addr);
        do_sample(QPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task spi_drive_byte;
input [7:0] opcode_in;
begin
    drive_cs(1'b0);
    do_drive(SPI,8,opcode_in);
    drive_cs(1'b1);
end
endtask


task spi_write;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] data_in;
begin
        $display("SPI WRITE OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,WRITE_OPCODE);
    do_drive(SPI,8,{7'h0,addr_in[16]});
    do_drive(SPI,8,addr_in[15:8]);
    do_drive(SPI,8,addr_in[7:0]);
    do_drive(SPI,8,data_in[7:0]);
    drive_cs(1'b1);
end
endtask

task spi_write_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] start_data_in;
input [7:0] data_pattern;
input [31:0] nwrites;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("SPI WRITE OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,WRITE_OPCODE);
    do_drive(SPI,8,{7'h0,addr_in[16]});
    do_drive(SPI,8,addr_in[15:8]);
    do_drive(SPI,8,addr_in[7:0]);
    for(i=0;i<nwrites;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,start_data_in,i);
        do_drive(SPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task spi_diw;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] data_in;
begin
        $display("DIW OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,DIW_OPCODE);
    do_drive(SPI,8,{7'h0,addr_in[16]});
    do_drive(SPI,8,addr_in[15:8]);
    do_drive(SPI,8,addr_in[7:0]);
    do_drive(DPI,8,data_in[7:0]);
    drive_cs(1'b1);
end
endtask

task spi_diw_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] start_data_in;
input [7:0] data_pattern;
input [31:0] nwrites;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("DIW OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,DIW_OPCODE);
    do_drive(SPI,8,{7'h0,addr_in[16]});
    do_drive(SPI,8,addr_in[15:8]);
    do_drive(SPI,8,addr_in[7:0]);
    for(i=0;i<nwrites;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,start_data_in,i);
        do_drive(DPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task spi_diow;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] data_in;
begin
        $display("DIOW OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,DIOW_OPCODE);
    do_drive(DPI,8,{7'h0,addr_in[16]});
    do_drive(DPI,8,addr_in[15:8]);
    do_drive(DPI,8,addr_in[7:0]);
    do_drive(DPI,8,data_in[7:0]);
    drive_cs(1'b1);
end
endtask

task spi_diow_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] start_data_in;
input [7:0] data_pattern;
input [31:0] nwrites;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("DIOW OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,DIOW_OPCODE);
    do_drive(DPI,8,{7'h0,addr_in[16]});
    do_drive(DPI,8,addr_in[15:8]);
    do_drive(DPI,8,addr_in[7:0]);
    for(i=0;i<nwrites;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,start_data_in,i);
        do_drive(DPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task spi_qiw;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] data_in;
begin
        $display("QIW OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,QIW_OPCODE);
    do_drive(SPI,8,{7'h0,addr_in[16]});
    do_drive(SPI,8,addr_in[15:8]);
    do_drive(SPI,8,addr_in[7:0]);
    do_drive(QPI,8,data_in[7:0]);
    drive_cs(1'b1);
end
endtask

task spi_qiw_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] start_data_in;
input [7:0] data_pattern;
input [31:0] nwrites;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("QIW OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,QIW_OPCODE);
    do_drive(SPI,8,{7'h0,addr_in[16]});
    do_drive(SPI,8,addr_in[15:8]);
    do_drive(SPI,8,addr_in[7:0]);
    for(i=0;i<nwrites;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,start_data_in,i);
        do_drive(QPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task spi_qiow;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] data_in;
begin
        $display("QIOW OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,QIOW_OPCODE);
    do_drive(QPI,8,{7'h0,addr_in[16]});
    do_drive(QPI,8,addr_in[15:8]);
    do_drive(QPI,8,addr_in[7:0]);
    do_drive(QPI,8,data_in[7:0]);
    drive_cs(1'b1);
end
endtask

task spi_qiow_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] start_data_in;
input [7:0] data_pattern;
input [31:0] nwrites;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("QIOW OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,QIOW_OPCODE);
    do_drive(QPI,8,{7'h0,addr_in[16]});
    do_drive(QPI,8,addr_in[15:8]);
    do_drive(QPI,8,addr_in[7:0]);
    for(i=0;i<nwrites;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,start_data_in,i);
        do_drive(QPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task spi_read;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_data;
begin
        $display("SPI READ OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,READ_OPCODE);
    do_drive(SPI,8,{7'h0,addr_in[16]});
    do_drive(SPI,8,addr_in[15:8]);
    do_drive(SPI,8,addr_in[7:0]);
    do_sample(SPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task spi_read_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("SPI READ OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,READ_OPCODE);
    do_drive(SPI,8,{7'h0,addr_in[16]});
    do_drive(SPI,8,addr_in[15:8]);
    do_drive(SPI,8,addr_in[7:0]);
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(SPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task set_xip;
input [7:0] xip_in;
begin
    xip = xip_in;
end
endtask

task validate_xip;
begin
    if(xip[7:4] == XIP_ENTER)
        begin
        xip_mode = 1;
        end
    else
        begin
        xip_mode = 0;
        end
end
endtask

task spi_fast_read;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_data;
begin
        $display("SPI FAST READ OPCODE sent");
    drive_cs(1'b0);
    //Drive OPCODE only when not in XIP mode
    if(xip_mode == 0)
        begin
        do_drive(SPI,8,FAST_READ_OPCODE);
        end
    do_drive(SPI,8,{7'h0,addr_in[16]});
    do_drive(SPI,8,addr_in[15:8]);
    do_drive(SPI,8,addr_in[7:0]);
   //Mode Byte
    do_drive(SPI,8,xip);
    validate_xip;
    do_sample(SPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task spi_fast_read_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("SPI FAST READ OPCODE sent");
    drive_cs(1'b0);
    //Drive opcode only when not in XIP mode
    if(xip_mode == 0)
        begin
        do_drive(SPI,8,FAST_READ_OPCODE);
        end
    do_drive(SPI,8,{7'h0,addr_in[16]});
    do_drive(SPI,8,addr_in[15:8]);
    do_drive(SPI,8,addr_in[7:0]);
   //Mode Byte
    do_drive(SPI,8,xip);
    validate_xip;
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(SPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task dpi_write;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] data_in;
begin
        $display("DPI WRITE OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,WRITE_OPCODE);
    do_drive(DPI,8,{7'h0,addr_in[16]});
    do_drive(DPI,8,addr_in[15:8]);
    do_drive(DPI,8,addr_in[7:0]);
    do_drive(DPI,8,data_in[7:0]);
    drive_cs(1'b1);
end
endtask

task dpi_write_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] start_data;
input [7:0] data_pattern;
input [31:0] nwrites;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("DPI WRITE OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,WRITE_OPCODE);
    do_drive(DPI,8,{7'h0,addr_in[16]});
    do_drive(DPI,8,addr_in[15:8]);
    do_drive(DPI,8,addr_in[7:0]);
    for(i=0;i<nwrites;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,start_data,i);
        do_drive(DPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task dpi_read;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_data;
begin
        $display("DPI READ OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,READ_OPCODE);
    do_drive(DPI,8,{7'h0,addr_in[16]});
    do_drive(DPI,8,addr_in[15:8]);
    do_drive(DPI,8,addr_in[7:0]);
    do_drive(DPI,2,2'b00);//Dummy Cycle
    do_sample(DPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task dpi_read_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("DPI READ OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,READ_OPCODE);
    do_drive(DPI,8,{7'h0,addr_in[16]});
    do_drive(DPI,8,addr_in[15:8]);
    do_drive(DPI,8,addr_in[7:0]);
    do_drive(DPI,2,2'b00);//Dummy Cycle
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(DPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task dpi_fast_read;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_data;
begin
        $display("DPI FAST READ OPCODE sent");
    drive_cs(1'b0);
   //No opcode when in XIP mode
    if(xip_mode == 1'b0)
        begin
        do_drive(DPI,8,FAST_READ_OPCODE);
        end
    do_drive(DPI,8,{7'h0,addr_in[16]});
    do_drive(DPI,8,addr_in[15:8]);
    do_drive(DPI,8,addr_in[7:0]);
   //Mode Byte
    do_drive(DPI,8,xip);
    validate_xip;
    do_sample(DPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task dpi_fast_read_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("DPI FAST READ OPCODE sent");
    drive_cs(1'b0);
    //No opcode when in XIP mode
    if(xip_mode == 1'b0)
        begin
        do_drive(DPI,8,FAST_READ_OPCODE);
        end
    do_drive(DPI,8,{7'h0,addr_in[16]});
    do_drive(DPI,8,addr_in[15:8]);
    do_drive(DPI,8,addr_in[7:0]);
    //Mode Byte
    do_drive(DPI,8,xip);
    validate_xip;
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(DPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task spi_dor;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_data;
begin
        $display("SPI DOR OPCODE sent");
    drive_cs(1'b0);
    //no opcode when in XIP mode
    if(xip_mode == 1'b0)
        begin
        do_drive(SPI,8,DOR_OPCODE);
        end
    do_drive(SPI,8,{7'h0,addr_in[16]});
    do_drive(SPI,8,addr_in[15:8]);
    do_drive(SPI,8,addr_in[7:0]);
    //Mode Byte
    do_drive(SPI,8,xip);
    validate_xip;
    do_sample(DPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task spi_dor_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("SPI DOR OPCODE sent");
    drive_cs(1'b0);
   //No opcode when in XIP mode
    if(xip_mode == 1'b0)
        begin
        do_drive(SPI,8,DOR_OPCODE);
        end
    do_drive(SPI,8,{7'h0,addr_in[16]});
    do_drive(SPI,8,addr_in[15:8]);
    do_drive(SPI,8,addr_in[7:0]);
    do_drive(SPI,8,xip);//Mode Byte
    validate_xip;
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(DPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task spi_dior;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_data;
begin
        $display("SPI DIOR OPCODE sent");
    drive_cs(1'b0);
   //No opcode when in XIP mode
    if(xip_mode == 1'b0)
        begin
        do_drive(SPI,8,DIOR_OPCODE);
        end
    do_drive(DPI,8,{7'h0,addr_in[16]});
    do_drive(DPI,8,addr_in[15:8]);
    do_drive(DPI,8,addr_in[7:0]);
    //Mode Byte
    do_drive(DPI,8,xip);
    validate_xip;
    do_sample(DPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task spi_dior_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("SPI DIOR OPCODE sent");
    drive_cs(1'b0);
   //No opcode when in XIP mode
    if(xip_mode == 1'b0)
        begin
        do_drive(SPI,8,DIOR_OPCODE);
        end
    do_drive(DPI,8,{7'h0,addr_in[16]});
    do_drive(DPI,8,addr_in[15:8]);
    do_drive(DPI,8,addr_in[7:0]);
    do_drive(DPI,8,xip);//Mode Byte
    validate_xip;
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(DPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task spi_qior;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_data;
begin
        $display("SPI QIOR OPCODE sent");
    drive_cs(1'b0);
   //No opcode when in XIP mode
    if(xip_mode == 1'b0)
        begin
        do_drive(SPI,8,QIOR_OPCODE);
        end
    do_drive(QPI,8,{7'h0,addr_in[16]});
    do_drive(QPI,8,addr_in[15:8]);
    do_drive(QPI,8,addr_in[7:0]);
    //Mode byte
    do_drive(QPI,8,xip);
    validate_xip;
    do_sample(QPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task spi_qior_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("SPI QIOR OPCODE sent");
    drive_cs(1'b0);
   //No opcode when in XIP mode
    if(xip_mode == 1'b0)
        begin
        do_drive(SPI,8,QIOR_OPCODE);
        end
    do_drive(QPI,8,{7'h0,addr_in[16]});
    do_drive(QPI,8,addr_in[15:8]);
    do_drive(QPI,8,addr_in[7:0]);
    do_drive(QPI,8,xip);//Mode Byte
    validate_xip;
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(QPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task spi_qor;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_data;
begin
        $display("SPI QOR OPCODE sent");
    drive_cs(1'b0);
   //No opcode when in XIP mode
    if(xip_mode == 1'b0)
        begin
        do_drive(SPI,8,QOR_OPCODE);
        end
    do_drive(SPI,8,{7'h0,addr_in[16]});
    do_drive(SPI,8,addr_in[15:8]);
    do_drive(SPI,8,addr_in[7:0]);
    //Mode Byte
    do_drive(SPI,8,xip);
    validate_xip;
    do_sample(QPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task spi_qor_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("SPI QOR OPCODE sent");
    drive_cs(1'b0);
   //No opcode when in XIP mode
    if(xip_mode == 1'b0)
        begin
        do_drive(SPI,8,QOR_OPCODE);
        end
    do_drive(SPI,8,{7'h0,addr_in[16]});
    do_drive(SPI,8,addr_in[15:8]);
    do_drive(SPI,8,addr_in[7:0]);
    do_drive(SPI,8,xip);//Mode Byte
    validate_xip;
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(QPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task qpi_write;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] data_in;
begin
        $display("QPI WRITE OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,WRITE_OPCODE);
    do_drive(QPI,8,{7'h0,addr_in[16]});
    do_drive(QPI,8,addr_in[15:8]);
    do_drive(QPI,8,addr_in[7:0]);
    do_drive(QPI,8,data_in[7:0]);
    drive_cs(1'b1);
end
endtask

task qpi_write_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] start_data;
input [7:0] data_pattern;
input [31:0] nwrites;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("QPI WRITE OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,WRITE_OPCODE);
    do_drive(QPI,8,{7'h0,addr_in[16]});
    do_drive(QPI,8,addr_in[15:8]);
    do_drive(QPI,8,addr_in[7:0]);
    for(i=0;i<nwrites;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,start_data,i);
        do_drive(QPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task qpi_read;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_data;
begin
        $display("QPI READ OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,READ_OPCODE);
    do_drive(QPI,8,{7'h0,addr_in[16]});
    do_drive(QPI,8,addr_in[15:8]);
    do_drive(QPI,8,addr_in[7:0]);
    do_drive(QPI,4,4'b00);//Dummy Cycle
    do_sample(QPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task qpi_read_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("QPI READ OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,READ_OPCODE);
    do_drive(QPI,8,{7'h0,addr_in[16]});
    do_drive(QPI,8,addr_in[15:8]);
    do_drive(QPI,8,addr_in[7:0]);
    do_drive(QPI,4,4'b00);//Dummy Cycle
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(QPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task qpi_fast_read;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_data;
begin
        $display("QPI FAST READ OPCODE sent");
    drive_cs(1'b0);
   //No opcode when in XIP mode
    if(xip_mode == 1'b0)
        begin
        do_drive(QPI,8,FAST_READ_OPCODE);
        end
    do_drive(QPI,8,{7'h0,addr_in[16]});
    do_drive(QPI,8,addr_in[15:8]);
    do_drive(QPI,8,addr_in[7:0]);
    do_drive(QPI,8,xip);//Mode Byte
    validate_xip;
    do_sample(QPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task qpi_fast_read_n;
input [`ADDR_BITS-1:0] addr_in;
input [`DATA_BITS-1:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [`DATA_BITS-1:0] pdata;
begin
        $display("QPI FAST READ OPCODE sent");
    drive_cs(1'b0);
   //No opcode when in XIP mode
    if(xip_mode == 1'b0)
        begin
        do_drive(QPI,8,FAST_READ_OPCODE);
        end
    do_drive(QPI,8,{7'h0,addr_in[16]});
    do_drive(QPI,8,addr_in[15:8]);
    do_drive(QPI,8,addr_in[7:0]);
    do_drive(QPI,8,xip);//Mode Byte
    validate_xip;
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(QPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task spi_wrcr;
input [7:0] data;
begin
        $display("SPI WRCR OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,WRCR_OPCODE);
    do_drive(SPI,8,data);
    drive_cs(1'b1);
end
endtask

task dpi_wrcr;
input [7:0] data;
begin
        $display("DPI WRCR OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,WRCR_OPCODE);
    do_drive(DPI,8,data);
    drive_cs(1'b1);
end
endtask

task qpi_wrcr;
input [7:0] data;
begin
        $display("QPI WRCR OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,WRCR_OPCODE);
    do_drive(QPI,8,data);
    drive_cs(1'b1);
end
endtask


task dpi_spien;
begin
        $display("DPI SPIEN OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,SPIEN_OPCODE);
    drive_cs(1'b1);
end
endtask

task qpi_spien;
begin
    drive_cs(1'b0);
    do_drive(QPI,8,SPIEN_OPCODE);
    drive_cs(1'b1);
end
endtask

task spi_store;
begin
        $display("SPI STORE OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,STORE_OPCODE);
    drive_cs(1'b1);
end
endtask

task dpi_store;
begin
        $display("DPI STORE OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,STORE_OPCODE);
    drive_cs(1'b1);
end
endtask

task qpi_store;
begin
        $display("QPI STORE OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,STORE_OPCODE);
    drive_cs(1'b1);
end
endtask

task spi_recall;
begin
        $display("SPI RECALL OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,RECALL_OPCODE);
    drive_cs(1'b1);
end
endtask

task dpi_recall;
begin
        $display("DPI RECALL OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,RECALL_OPCODE);
    drive_cs(1'b1);
end
endtask

task qpi_recall;
begin
        $display("QPI RECALL OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,RECALL_OPCODE);
    drive_cs(1'b1);
end
endtask

task spi_asen;
begin
        $display("SPI Autostore Enable OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,ASENB_OPCODE);
    drive_cs(1'b1);
end
endtask

task dpi_asen;
begin
        $display("DPI Autostore Enable OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,ASENB_OPCODE);
    drive_cs(1'b1);
end
endtask

task qpi_asen;
begin
        $display("QPI Autostore Enable OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,ASENB_OPCODE);
    drive_cs(1'b1);
end
endtask

task spi_asdi;
begin
        $display("SPI Autostore Disable OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,ASDISB_OPCODE);
    drive_cs(1'b1);
end
endtask

task dpi_asdi;
begin
        $display("DPI Autostore Disable OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,ASDISB_OPCODE);
    drive_cs(1'b1);
end
endtask

task qpi_asdi;
begin
        $display("QPI Autostore Disable OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,ASDISB_OPCODE);
    drive_cs(1'b1);
end
endtask

task spi_sleep;
begin
        $display("SPI Sleep OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,SLEEP_OPCODE);
    drive_cs(1'b1);
end
endtask

task dpi_sleep;
begin
        $display("DPI Sleep OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,SLEEP_OPCODE);
    drive_cs(1'b1);
end
endtask

task qpi_sleep;
begin
        $display("QPI Sleep OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,SLEEP_OPCODE);
    drive_cs(1'b1);
end
endtask

task spi_exit_sleep;
begin
        $display("SPI Exit Sleep OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,EXSLP_OPCODE);
    drive_cs(1'b1);
end
endtask

task dpi_exit_sleep;
begin
        $display("DPI Exit Sleep OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,EXSLP_OPCODE);
    drive_cs(1'b1);
end
endtask

task qpi_exit_sleep;
begin
        $display("QPI Exit Sleep OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,EXSLP_OPCODE);
    drive_cs(1'b1);
end
endtask

task spi_hibernate;
begin
        $display("SPI Hibernate OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,HIBERNATE_OPCODE);
    drive_cs(1'b1);
end
endtask

task dpi_hibernate;
begin
        $display("DPI Hibernate OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,HIBERNATE_OPCODE);
    drive_cs(1'b1);
end
endtask

task qpi_hibernate;
begin
        $display("QPI Hibernate OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,HIBERNATE_OPCODE);
    drive_cs(1'b1);
end
endtask

task wake;
begin
    drive_cs(1'b0);
   #5;
    drive_cs(1'b1);
end
endtask

task qpi_default_recovery;
    begin
    drive_cs(1'b0);
    do_drive(QPI,8,8'hFF);
    do_drive(QPI,8,8'hFF);
    do_drive(QPI,8,8'hFF);
    do_drive(QPI,8,8'hFF);
    drive_cs(1'b1);
    end
endtask

task dpi_default_recovery;
    begin
    drive_cs(1'b0);
    do_drive(DPI,8,8'hFF);
    do_drive(DPI,8,8'hFF);
    drive_cs(1'b1);
    end
endtask

task spi_default_recovery;
    begin
    drive_cs(1'b0);
    do_drive(SPI,8,8'hFF);
    drive_cs(1'b1);
    end
endtask

task spi_wrrtc;
input [7:0] addr_in;
input [7:0] data_in;
begin
        $display("SPI WRRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,WRRTC_OPCODE);
    do_drive(SPI,8,addr_in[7:0]);
    do_drive(SPI,8,data_in[7:0]);
    drive_cs(1'b1);
end
endtask

task spi_wrrtc_n;
input [7:0] addr_in;
input [7:0] start_data_in;
input [7:0] data_pattern;
input [31:0] nwrites;
reg [31:0] i;
reg [7:0] pdata;
begin
        $display("SPI WRRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,WRRTC_OPCODE);
    do_drive(SPI,8,addr_in[7:0]);
    for(i=0;i<nwrites;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,start_data_in,i);
        do_drive(SPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task spi_rdrtc;
input [7:0] addr_in;
input [7:0] exp_data;
begin
    
        $display("SPI RDRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,RDRTC_OPCODE);
    do_drive(SPI,8,addr_in[7:0]);
    do_sample(SPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task spi_rdrtc_n;
input [7:0] addr_in;
input [7:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [7:0] pdata;
begin
        $display("SPI RDRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,RDRTC_OPCODE);
    do_drive(SPI,8,addr_in[7:0]);
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(SPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask


task spi_fast_rdrtc;
input [7:0] addr_in;
input [7:0] exp_data;
begin
        $display("SPI FAST RDRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,FAST_RDRTC_OPCODE);
    do_drive(SPI,8,addr_in[7:0]);
   //Dummy Byte
    do_drive(SPI,8,8'h0);
    do_sample(SPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task spi_fast_rdrtc_n;
input [7:0] addr_in;
input [7:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [7:0] pdata;
begin
        $display("SPI FAST RDRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(SPI,8,FAST_RDRTC_OPCODE);
    do_drive(SPI,8,addr_in[7:0]);
   //Dummy Byte
    do_drive(SPI,8,8'h0);
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(SPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task dpi_wrrtc;
input [7:0] addr_in;
input [7:0] data_in;
begin
        $display("DPI WRRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,WRRTC_OPCODE);
    do_drive(DPI,8,addr_in[7:0]);
    do_drive(DPI,8,data_in[7:0]);
    drive_cs(1'b1);
end
endtask

task dpi_wrrtc_n;
input [7:0] addr_in;
input [7:0] start_data_in;
input [7:0] data_pattern;
input [31:0] nwrites;
reg [31:0] i;
reg [7:0] pdata;
begin
        $display("DPI WRRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,WRRTC_OPCODE);
    do_drive(DPI,8,addr_in[7:0]);
    for(i=0;i<nwrites;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,start_data_in,i);
        do_drive(DPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task dpi_rdrtc;
input [7:0] addr_in;
input [7:0] exp_data;
begin
        $display("DPI RDRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,RDRTC_OPCODE);
    do_drive(DPI,8,addr_in[7:0]);
    do_sample(DPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task dpi_rdrtc_n;
input [7:0] addr_in;
input [7:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [7:0] pdata;
begin
        $display("DPI RDRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,RDRTC_OPCODE);
    do_drive(DPI,8,addr_in[7:0]);
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(DPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask


task dpi_fast_rdrtc;
input [7:0] addr_in;
input [7:0] exp_data;
begin
        $display("DPI FAST RDRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,FAST_RDRTC_OPCODE);
    do_drive(DPI,8,addr_in[7:0]);
   //Dummy Byte
    do_drive(DPI,8,8'h0);
    do_sample(DPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task dpi_fast_rdrtc_n;
input [7:0] addr_in;
input [7:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [7:0] pdata;
begin
        $display("DPI FAST RDRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(DPI,8,FAST_RDRTC_OPCODE);
    do_drive(DPI,8,addr_in[7:0]);
   //Dummy Byte
    do_drive(DPI,8,8'h0);
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(DPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask


task qpi_wrrtc;
input [7:0] addr_in;
input [7:0] data_in;
begin
        $display("QPI WRRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,WRRTC_OPCODE);
    do_drive(QPI,8,addr_in[7:0]);
    do_drive(QPI,8,data_in[7:0]);
    drive_cs(1'b1);
end
endtask

task qpi_wrrtc_n;
input [7:0] addr_in;
input [7:0] start_data_in;
input [7:0] data_pattern;
input [31:0] nwrites;
reg [31:0] i;
reg [7:0] pdata;
begin
        $display("QPI WRRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,WRRTC_OPCODE);
    do_drive(QPI,8,addr_in[7:0]);
    for(i=0;i<nwrites;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,start_data_in,i);
        do_drive(QPI,8,pdata);
        end
    drive_cs(1'b1);
end
endtask

task qpi_rdrtc;
input [7:0] addr_in;
input [7:0] exp_data;
begin
        $display("QPI RDRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,RDRTC_OPCODE);
    do_drive(QPI,8,addr_in[7:0]);
    do_sample(QPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task qpi_rdrtc_n;
input [7:0] addr_in;
input [7:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [7:0] pdata;
begin
        $display("QPI RDRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,RDRTC_OPCODE);
    do_drive(QPI,8,addr_in[7:0]);
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(QPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask


task qpi_fast_rdrtc;
input [7:0] addr_in;
input [7:0] exp_data;
begin
        $display("QPI FAST RDRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,FAST_RDRTC_OPCODE);
    do_drive(QPI,8,addr_in[7:0]);
        //Dummy Byte
    do_drive(QPI,8,8'h0);
    do_sample(QPI,8,exp_data[7:0],COMPARE);
    drive_cs(1'b1);
end
endtask

task qpi_fast_rdrtc_n;
input [7:0] addr_in;
input [7:0] exp_start_data;
input [7:0] data_pattern;
input [31:0] nreads;
reg [31:0] i;
reg [7:0] pdata;
begin
        $display("QPI FAST RDRTC OPCODE sent");
    drive_cs(1'b0);
    do_drive(QPI,8,FAST_RDRTC_OPCODE);
    do_drive(QPI,8,addr_in[7:0]);
        //Dummy Byte
    do_drive(QPI,8,8'h0);
    for(i=0;i<nreads;i=i+1)
        begin
        pdata = get_data(data_pattern,addr_in,exp_start_data,i);
        do_sample(QPI,8,pdata,COMPARE);
        end
    drive_cs(1'b1);
end
endtask

task spi_rdid;
begin
        $display("SPI RDID");
    drive_cs(1'b0);
    do_drive(SPI,8,RDID_OPCODE);
    do_sample(SPI,8,DEV_ID_BYTE3,COMPARE);
    do_sample(SPI,8,DEV_ID_BYTE2,COMPARE);
    do_sample(SPI,8,DEV_ID_BYTE1,COMPARE);
    do_sample(SPI,8,DEV_ID_BYTE0,COMPARE);
    drive_cs(1'b1);
end
endtask

task spi_rdid_n;
input [7:0] nbytes;
integer n;
begin
        $display("SPI RDID");
    drive_cs(1'b0);
    do_drive(SPI,8,RDID_OPCODE);
    for(n=0;n<=nbytes-1;n=n+1)
        begin
      case((n-1)%4)
            0:do_sample(SPI,8,DEV_ID_BYTE3,COMPARE);
            1:do_sample(SPI,8,DEV_ID_BYTE2,COMPARE);
            2:do_sample(SPI,8,DEV_ID_BYTE1,COMPARE);
            3:do_sample(SPI,8,DEV_ID_BYTE0,COMPARE);
        endcase
        end
    drive_cs(1'b1);
end
endtask

task spi_fast_rdid;
begin
        $display("SPI FAST RDID");
    drive_cs(1'b0);
    do_drive(SPI,8,FAST_RDID_OPCODE);
   //Dummy Byte
    do_drive(SPI,8,8'h0);
    do_sample(SPI,8,DEV_ID_BYTE3,COMPARE);
    do_sample(SPI,8,DEV_ID_BYTE2,COMPARE);
    do_sample(SPI,8,DEV_ID_BYTE1,COMPARE);
    do_sample(SPI,8,DEV_ID_BYTE0,COMPARE);
    drive_cs(1'b1);
end
endtask

task spi_fast_rdid_n;
input [7:0] nbytes;
integer n;
begin
        $display("SPI FAST RDID");
    drive_cs(1'b0);
    do_drive(SPI,8,FAST_RDID_OPCODE);
   //Dummy Byte
    do_drive(SPI,8,8'h0);
    for(n=0;n<=nbytes-1;n=n+1)
        begin
      case((n-1)%4)
            0:do_sample(SPI,8,DEV_ID_BYTE3,COMPARE);
            1:do_sample(SPI,8,DEV_ID_BYTE2,COMPARE);
            2:do_sample(SPI,8,DEV_ID_BYTE1,COMPARE);
            3:do_sample(SPI,8,DEV_ID_BYTE0,COMPARE);
        endcase
        end
    drive_cs(1'b1);
end
endtask

task dpi_rdid;
begin
        $display("DPI RDID");

    drive_cs(1'b0);
    do_drive(DPI,8,RDID_OPCODE);
    do_sample(DPI,8,DEV_ID_BYTE3,COMPARE);
    do_sample(DPI,8,DEV_ID_BYTE2,COMPARE);
    do_sample(DPI,8,DEV_ID_BYTE1,COMPARE);
    do_sample(DPI,8,DEV_ID_BYTE0,COMPARE);
    drive_cs(1'b1);
end
endtask

task dpi_rdid_n;
input [7:0] nbytes;
integer n;
begin
        $display("SPI RDID");
    drive_cs(1'b0);
    do_drive(DPI,8,RDID_OPCODE);
    for(n=0;n<=nbytes-1;n=n+1)
        begin
      case((n-1)%4)
            0:do_sample(DPI,8,DEV_ID_BYTE3,COMPARE);
            1:do_sample(DPI,8,DEV_ID_BYTE2,COMPARE);
            2:do_sample(DPI,8,DEV_ID_BYTE1,COMPARE);
            3:do_sample(DPI,8,DEV_ID_BYTE0,COMPARE);
        endcase
        end
    drive_cs(1'b1);
end
endtask

task dpi_fast_rdid;
begin
        $display("DPI FAST RDID");
    drive_cs(1'b0);
    do_drive(DPI,8,FAST_RDID_OPCODE);
   //Dummy Byte
    do_drive(DPI,8,8'h0);
    do_sample(DPI,8,DEV_ID_BYTE3,COMPARE);
    do_sample(DPI,8,DEV_ID_BYTE2,COMPARE);
    do_sample(DPI,8,DEV_ID_BYTE1,COMPARE);
    do_sample(DPI,8,DEV_ID_BYTE0,COMPARE);
    drive_cs(1'b1);
end
endtask


task dpi_fast_rdid_n;
input [7:0] nbytes;
integer n;
begin
        $display("DPI FAST RDID");
    drive_cs(1'b0);
    do_drive(DPI,8,FAST_RDID_OPCODE);
   //Dummy Byte
    do_drive(DPI,8,8'h0);
    for(n=0;n<=nbytes-1;n=n+1)
        begin
      case((n-1)%4)
            0:do_sample(DPI,8,DEV_ID_BYTE3,COMPARE);
            1:do_sample(DPI,8,DEV_ID_BYTE2,COMPARE);
            2:do_sample(DPI,8,DEV_ID_BYTE1,COMPARE);
            3:do_sample(DPI,8,DEV_ID_BYTE0,COMPARE);
        endcase
        end
    drive_cs(1'b1);
end
endtask

task qpi_rdid;
begin
        $display("QPI RDID");
    drive_cs(1'b0);
    do_drive(QPI,8,RDID_OPCODE);
    do_sample(QPI,8,DEV_ID_BYTE3,COMPARE);
    do_sample(QPI,8,DEV_ID_BYTE2,COMPARE);
    do_sample(QPI,8,DEV_ID_BYTE1,COMPARE);
    do_sample(QPI,8,DEV_ID_BYTE0,COMPARE);
    drive_cs(1'b1);
end
endtask

task qpi_rdid_n;
input [7:0] nbytes;
integer n;
begin
        $display("QPI RDID");
    drive_cs(1'b0);
    do_drive(QPI,8,RDID_OPCODE);
    for(n=0;n<=nbytes-1;n=n+1)
        begin
      case((n-1)%4)
            0:do_sample(QPI,8,DEV_ID_BYTE3,COMPARE);
            1:do_sample(QPI,8,DEV_ID_BYTE2,COMPARE);
            2:do_sample(QPI,8,DEV_ID_BYTE1,COMPARE);
            3:do_sample(QPI,8,DEV_ID_BYTE0,COMPARE);
        endcase
        end
    drive_cs(1'b1);
end
endtask

task qpi_fast_rdid;
begin
        $display("QPI FAST RDID");
    drive_cs(1'b0);
    do_drive(QPI,8,FAST_RDID_OPCODE);
   //Dummy Byte
    do_drive(QPI,8,8'h0);
    do_sample(QPI,8,DEV_ID_BYTE3,COMPARE);
    do_sample(QPI,8,DEV_ID_BYTE2,COMPARE);
    do_sample(QPI,8,DEV_ID_BYTE1,COMPARE);
    do_sample(QPI,8,DEV_ID_BYTE0,COMPARE);
    drive_cs(1'b1);
end
endtask

task qpi_fast_rdid_n;
input [7:0] nbytes;
integer n;
begin
        $display("QPI FAST RDID");
    drive_cs(1'b0);
    do_drive(QPI,8,FAST_RDID_OPCODE);
   //Dummy Byte
    do_drive(QPI,8,8'hFF);
    for(n=0;n<=nbytes-1;n=n+1)
        begin
      case((n-1)%4)
            0:do_sample(QPI,8,DEV_ID_BYTE3,COMPARE);
            1:do_sample(QPI,8,DEV_ID_BYTE2,COMPARE);
            2:do_sample(QPI,8,DEV_ID_BYTE1,COMPARE);
            3:do_sample(QPI,8,DEV_ID_BYTE0,COMPARE);
        endcase
        end
    drive_cs(1'b1);
end
endtask

task drive_cs;
input cs_val;
begin
    if(cs_val == 1'b0)
        begin
        if(spi_current_mode == MODE3)
            begin
            //assertion
            @ (posedge spi_sck);
            wp_in   = set_wp_val;
            @ (negedge tb_clock);
            si_in = 1'b1;
            //WP setup with respect to CS
         @ (posedge tb_clock);
            cs_in = cs_val;
         //Active clock
         clock_active = 1;
            @ (negedge tb_clock);
            end
        else
            begin
            //assertion
            @ (posedge spi_sck);
         @ (negedge tb_clock);
            @ (posedge tb_clock);
            //WP setup with respect to CS
            wp_in   = set_wp_val;
            @ (negedge spi_sck);
            si_in = 1'b1;
            @ (negedge tb_clock);
            cs_in = cs_val;
         //Active the clock
         clock_active = 1;
            end
        end
    else
        begin
        if(spi_current_mode == MODE3)
            begin
            if(spi_clock_select == 5'b10000)
                //108MHz = 9.25
                begin
                @ (negedge spi_sck);
                clock_active = 0;
                //deassertion
                @ (negedge tb_clock);
                cs_in   = cs_val;
                wp_in = set_wp_val;
                io3_in = set_io3_val;
                
                end
            else
                //40MHz and lower
                begin
                //deassertion
                //Deassert CS immediately for 40MHz clock
                cs_in   = cs_val;
                //Deactive the clock
                clock_active = 0;
                wp_in = set_wp_val;
                io3_in = set_io3_val;
                end
            end
        else
            begin
            //deassertion
            @ (negedge spi_sck);
            wp_in = set_wp_val;
            @ (posedge tb_clock);
         //Deactive the clock
         clock_active = 0;
            @ (negedge tb_clock);
            cs_in   = cs_val;
            wp_in = set_wp_val;
            io3_in = set_io3_val;
            end
        end
end
endtask


task drive_wp;
input val_in;
begin
    set_wp_val = val_in;//zero time task
end
endtask

task drive_io3;
input val_in;
begin
    set_io3_val = val_in;
end
endtask


task do_drive;
input [7:0] mode;
input [7:0] nbits;
input [7:0] data;
integer i;
begin
    if(mode == SPI)
        begin
        //MSB First
        for(i=nbits;i>0;i=i-1)
        begin
            @ (posedge tb_clock);
                si_in   = data[i-1];
                io3_in = set_io3_val;
                wp_in   = set_wp_val;
            @ (posedge tb_clock);
                si_in   = ~(data[i-1]);
                io3_in = set_io3_val;
                wp_in   = set_wp_val;
            end
    end
    else if(mode == DPI)
        begin
        //MSB First
        //IO0 = SI
        //IO1 = SO
        for(i=nbits;i>0;i=i-2)
            begin
            @ (posedge tb_clock);
                so_in   = data[i-1];
                si_in   = data[i-2];
                io3_in = set_io3_val;
                wp_in   = set_wp_val;
            @ (posedge tb_clock);
                so_in   = 1'bz;
                si_in   = 1'bz;
                io3_in = set_io3_val;
                wp_in   = set_wp_val;
            end           
        end
    else if(mode == QPI)
        begin
        //MSB First
        //IO0 = SI
        //IO1 = SO
        //IO2 = WP
        //IO3 = IO3
        for(i=nbits;i>0;i=i-4)
            begin
            @ (posedge tb_clock);
                io3_in  = data[i-1];
                wp_in    = data[i-2];
                so_in    = data[i-3];
                si_in    = data[i-4];
            @ (posedge tb_clock);
                io3_in = 1'bz;
                wp_in   = 1'bz;
                so_in   = 1'bz;
                si_in   = 1'bz;
            end
         //WP,IO3 float after CS deassertion
         drive_wp(1'bz);
         drive_io3(1'bz);
        end
end
endtask


task do_sample;
input [7:0] mode;
input [7:0] nbits;
input [7:0] edata;
input do_comparison;
integer i;
reg [7:0] rdata;
begin
   rdata = 8'h0;
    if(mode == SPI)
        begin
        for(i=nbits-1;i>=0;i=i-1)
            begin
            @ (negedge tb_clock);
            so_in = 1'bz;
         @ (posedge tb_clock);
            io3_in = set_io3_val;
            wp_in   = set_wp_val;
            @ (negedge tb_clock);
            so_in = 1'bz;
            rdata[i] = SO;
         @ (posedge tb_clock);
            io3_in = set_io3_val;
            wp_in   = set_wp_val;
            end
         last_read_byte = rdata;
        
                if(rdata !== edata && do_comparison == COMPARE)
            begin
            $display("ERROR: SPI COMPARE MISMATCH. expected data=%x, actual data=%x at time %d",edata,rdata,$time);
            end
                else
                begin
                   $display("Read data - %02h",rdata); 
                end
                end
    else if(mode == DPI)
        begin
        for(i=nbits-1;i>=0;i=i-2)
            begin
            @ (negedge tb_clock);
         si_in = 1'bz;
            so_in = 1'bz;
         @ (posedge tb_clock);
            io3_in = set_io3_val;
            wp_in   = set_wp_val;
            @ (negedge tb_clock);
            rdata[i]   = SO;
            rdata[i-1] = SI;
         @ (posedge tb_clock);
            io3_in = set_io3_val;
            wp_in   = set_wp_val;
            end
        last_read_byte = rdata;
        if(rdata !== edata && do_comparison == COMPARE)
            begin
            $display("ERROR: DPI COMPARE MISMATCH. expected data=%x, actual data=%x at time %d",edata,rdata,$time);
            end
                else
                begin
                   $display("%02h",rdata); 
                end
                end
    else if(mode == QPI)
        begin
        for(i=nbits-1;i>=0;i=i-4)
            begin
            @ (negedge tb_clock);
            //Need for QOR mode
            wp_in = 1'bz;
            io3_in = 1'bz;
            si_in = 1'bz;
            so_in = 1'bz;
            @ (negedge tb_clock);
            rdata[i]   = IO3;
            rdata[i-1] = WP;
            rdata[i-2] = SO;
            rdata[i-3] = SI;
            end
        last_read_byte = rdata;
        if(rdata !== edata && do_comparison == COMPARE)
            begin
            $display("ERROR: QPI COMPARE MISMATCH. expected data=%x, actual data=%x at time %d",edata,rdata,$time);
            end
                else
                begin
                   $display("%02h",rdata); 
                end
                end
end
endtask

task wait_n;
input [63:0] ncycles;
reg [63:0] loop_cnt;
begin
    for(loop_cnt=0;loop_cnt<ncycles;loop_cnt=loop_cnt+1)
        begin
        @(posedge tb_clock);
        @(posedge tb_clock);
        end
end
endtask

task spi_rtc_powerdown;
begin
end
endtask

task spi_power_down;
begin
end
endtask

task spi_power_up;
begin
end
endtask

task reset_tb_parameters;
begin
   //Reset Testbench Parameters
   xip = 8'h0;
    xip_mode = 1'b0;
end
endtask

task poll_hsb;
input hsb_val;
begin
end
endtask

task check_hsb;
input hsb_val;
begin
    if(HSB !== hsb_val)
        begin
        $display("SPI COMPARISON ERROR: HSB doesn't match expected value at time %d, Actual:%b, Expected:%b",$time,HSB,hsb_val);
        end
    else
        begin
        $display("SPI INFO: HSB matches expected value at time %d, value = %b",$time,hsb_val);
        end
end
endtask

task poll_wip;
input wip_val;
begin
end
endtask

task spi_check_wip;
input wip_val;
reg wip_rdsr;
begin
    drive_cs(1'b0);
    do_drive(SPI,8,RDSR_OPCODE);
    do_sample(SPI,8,8'h00,IGNORE);
    drive_cs(1'b1);
    wip_rdsr = last_read_byte[0];
    if(wip_val !== wip_rdsr)
        begin
        $display("SPI COMPARISON ERROR: WIP in Status Register doesn't match expected value. Actual=%b, Expected=%b at time %d",wip_rdsr,wip_val,$time);
        end
end
endtask

task dpi_check_wip;
input wip_val;
reg wip_rdsr;
begin
    drive_cs(1'b0);
    do_drive(DPI,8,RDSR_OPCODE);
    do_sample(DPI,8,8'h00,IGNORE);
    drive_cs(1'b1);
    wip_rdsr = last_read_byte[0];
    if(wip_val !== wip_rdsr)
        begin
        $display("DPI COMPARISON ERROR: WIP in Status Register doesn't match expected value. Actual=%b, Expected=%b at time:%d",wip_rdsr,wip_val,$time);
        end
end
endtask

task qpi_check_wip;
input wip_val;
reg wip_rdsr;
begin
    drive_cs(1'b0);
    do_drive(QPI,8,RDSR_OPCODE);
    do_sample(QPI,8,8'h00,IGNORE);
    drive_cs(1'b1);
    wip_rdsr = last_read_byte[0];
    if(wip_val !== wip_rdsr)
        begin
        $display("QPI COMPARISON ERROR: WIP in Status Register doesn't match expected value. Actual=%b, Expected=%b at time:%d",wip_rdsr,wip_val,$time);
        end
end
endtask

task drive_hsb;
input hsb_val;
begin
    hsb_in = hsb_val;
end
endtask

task spi_switch_mode;
input mode_val;
begin
    if(mode_val == MODE0)
        begin
        spi_default_clock = 1'b0;
        spi_current_mode = MODE0;
        end
    else
        begin
        spi_default_clock = 1'b1;
        spi_current_mode = MODE3;
        end
end
endtask

task do_hardstore;
  begin
  drive_hsb(1'b0);
  #TPHSB;
  drive_hsb(1'bz);
  wait_n(30);
  #TSTORE;
  end
endtask

task do_softstore;
    begin
    spi_wren;
    spi_store;
    #100;
    #TSTORE;
    end
endtask

task do_autostore;
    begin
       vcc_reg = 0;
       #TSTORE;
       vcc_reg = 1;
    end
endtask

task do_spi_hibernate;
    begin
    spi_hibernate;
    #TSOFT;
    #THIBEN;
    wait_n(500);
    wake;
    #TWAKE;
    end
endtask

