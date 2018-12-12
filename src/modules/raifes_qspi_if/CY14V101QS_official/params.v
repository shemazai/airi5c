// +FHDR -----------------------------------------------------------------------
// Copyright 2016, Cypress Semiconductor Corporation
// Cypress Confidential Proprietary
// This code is provided as is without warranty or guarantee of any kind as its accuracy, 
// completeness, operability, fitness for particular purpose, or any other warranty.
// -----------------------------------------------------------------------------
// FILE NAME:  params.v
// TYPE:       This contains different parameter for test bench
// -----------------------------------------------------------------------------
// Release History
// Revision 1.0  08/02/2016 - Initial version
//
// -----------------------------------------------------------------------------
// DESCRIPTION:  This is part of behavioral model for 1Mbit Quad SPI nvSRAM with RTC.
// -----------------------------------------------------------------------------

//QSPI OPCODES
parameter SLEEP_OPCODE 	     = 8'hB9;
parameter WREN_OPCODE        = 8'h06;
parameter WRDI_OPCODE        = 8'h04;
parameter RDID_OPCODE        = 8'h9F;
parameter FAST_RDID_OPCODE   = 8'h9E;
parameter RDSN_OPCODE        = 8'hC3;
parameter FAST_RDSN_OPCODE   = 8'hC9;
parameter WRSN_OPCODE        = 8'hC2;
parameter RDSR_OPCODE        = 8'h05;
parameter FAST_RDSR_OPCODE   = 8'h05;
parameter WRSR_OPCODE        = 8'h01;
parameter READ_OPCODE        = 8'h03;
parameter FAST_READ_OPCODE   = 8'h0B;
parameter WRITE_OPCODE       = 8'h02;
parameter RDRTC_OPCODE       = 8'h56;
parameter FAST_RDRTC_OPCODE  = 8'h57;
parameter WRRTC_OPCODE       = 8'h55;
parameter STORE_OPCODE       = 8'h8C;
parameter RECALL_OPCODE      = 8'h8D;
parameter ASENB_OPCODE       = 8'h8E;
parameter ASDISB_OPCODE      = 8'h8F;

//QSPI NEW OPCODES
parameter DPIEN_OPCODE       = 8'h37;
parameter QPIEN_OPCODE       = 8'h38;
parameter SPIEN_OPCODE       = 8'hFF;
parameter DOR_OPCODE         = 8'h3B;
parameter QOR_OPCODE         = 8'h6B;
parameter DIOR_OPCODE        = 8'hBB;
parameter QIOR_OPCODE        = 8'hEB;
parameter DIW_OPCODE         = 8'hA2;
parameter QIW_OPCODE         = 8'h32;
parameter DIOW_OPCODE        = 8'hA1;
parameter QIOW_OPCODE        = 8'hD2;
parameter RESET_OPCODE       = 8'h99;
parameter RSTEN_OPCODE       = 8'h66;
parameter HIBERNATE_OPCODE   = 8'hBA;
parameter EXSLP_OPCODE       = 8'hAB;
parameter WRCR_OPCODE        = 8'h87;
parameter RDCR_OPCODE        = 8'h35;

//RTC PARAM
parameter  WRITE_ENABLE      = 2;    // bit "1" of the flags register
parameter MODE0 = 1'b0;
parameter MODE3 = 1'b1;

// timing params
parameter TSTORE	= 8000000;		//8ms
parameter TRECALL	= 600000;		//600us
parameter TWAKE  	= 20000000;		//20ms
parameter THIBEN        = 8000000;             //8ms
parameter TSTANDBY 	= 10000;		//10us
parameter TSOFT         = 500000;               //500us
parameter TRESET        = 500000;               //500us
parameter TFA           = 20000000;             //20ms
parameter TPHSB         = 15;                   //15ns

parameter PATTERN_DATA_EQ_ADDR   = 8'h0;
parameter PATTERN_DATA_EQ_ADDRB  = 8'h1;
parameter PATTERN_DATA_EQ_ALL0   = 8'h2;
parameter PATTERN_DATA_EQ_ALL1   = 8'h3;
parameter PATTERN_DATA_EQ_AA     = 8'h4;
parameter PATTERN_DATA_EQ_55     = 8'h5;
parameter PATTERN_DATA_EQ_A5     = 8'h6;
parameter PATTERN_DATA_EQ_5A     = 8'h7;
parameter PATTERN_DATA_INCR      = 8'h8;
parameter PATTERN_CHECKERB       = 8'h9;

parameter SPI = 4'h0;
parameter DPI = 4'h1;
parameter QPI = 4'h2;
parameter COMPARE = 1'b1;
parameter IGNORE  = 1'b0;

parameter CLOCK_1MHZ   = 8'h0;
parameter CLOCK_10MHZ  = 8'h1;
parameter CLOCK_20MHZ  = 8'h2;
parameter CLOCK_40MHZ  = 8'h3;
parameter CLOCK_108MHZ = 8'h4;

parameter XIP_ENTER = 4'hA;

parameter DEV_ID_BYTE3 = 8'h06;
parameter DEV_ID_BYTE2 = 8'h81;
parameter DEV_ID_BYTE1 = 8'h00;
parameter DEV_ID_BYTE0 = 8'h01;

// Note : Divider = 1 corresponds to 1 sec of simulation time equal to 1 sec of RTC time.
//      : Divider = 5 corresponds to 200ms of simulation time equal to 1 sec of RTC time.
//      : Divider = 100 corresponds to 10ms of simulation time equal to 1 sec of RTC time.
//      : Don't set too high RTC clock. Divider of 100 is verified beyond which model may not work.  
parameter XTAL_PERIOD = 30517.57825 / 5;

  
