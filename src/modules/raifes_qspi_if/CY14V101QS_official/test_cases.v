// +FHDR -----------------------------------------------------------------------
// Copyright 2016, Cypress Semiconductor Corporation
// Cypress Confidential Proprietary
// This code is provided as is without warranty or guarantee of any kind as its accuracy, 
// completeness, operability, fitness for particular purpose, or any other warranty.
// -----------------------------------------------------------------------------
// FILE NAME:  test_cases.v
// TYPE:       This contains the test cases for CY14V101XS behavioral model
// -----------------------------------------------------------------------------
// Release History
// Revision 1.0  08/02/2016 - Initial version
//
// -----------------------------------------------------------------------------
// DESCRIPTION:  This is part of behavioral model for 1Mbit Quad SPI nvSRAM with RTC.
// -----------------------------------------------------------------------------

  //SPI -> QPI
  spi_wren;
  spi_write(17'h1C53A,8'hC5);
  spi_read(17'h1C53A,8'hC5);
  spi_wren;

  spi_wrcr(8'h42);//Enable Quad bit
  spi_qpien;

  qpi_wrdi;
  qpi_wren;
  qpi_write(17'h1C53A,8'hC4);
  qpi_write(17'h1FFFF,8'h5B);
  qpi_read(17'h1C53A,8'hC4);
  qpi_read(17'h1FFFF,8'h5B);
  qpi_write(17'h03AC5,8'h3A);
  qpi_read(17'h03AC5,8'h3A);
  wait_n(10);
  qpi_wrdi;
  qpi_write(17'h1C53A,8'h3A);
  qpi_read(17'h1C53A,8'hC4);
  
  //Burst Write/Reads
  qpi_wren;
  qpi_write_n(17'h0,17'h0,PATTERN_DATA_EQ_ADDR,16);
  qpi_read_n(17'h0,17'h0,PATTERN_DATA_EQ_ADDR,16);  
  
  qpi_fast_rdid;
  
  qpi_spien;
  drive_wp(1'b1);
  drive_io3(1'b1);  
  //QPI -> SPI
  spi_wren;
  spi_wrcr(8'h40);//Disable Quad bit

  spi_wren;
  spi_write(17'h1C53A,8'h3A);
  spi_write(17'h1FFFF,8'hA3);
  spi_wrdi;
  spi_read(17'h1C53A,8'h3A);
  spi_read(17'h1FFFF,8'hA3);

`ifdef PKG_16SOIC_RTC
  spi_wren;
  spi_wrrtc(0, 'h02);
  spi_wren;
  spi_wrrtc(8, 'h00);
  spi_wren;
  spi_wrrtc(9, 'h20);  
  spi_wren;
  spi_wrrtc(0, 'h00);
  
  #200_500_000;
  spi_rdrtc(9, 'h21);
`endif
  
  spi_wren;
  spi_store;
  #TSTORE;
  
  spi_wren;
  spi_write(17'h1C53A,8'h30);
  spi_read(17'h1C53A,8'h30);
  spi_recall;
  #TRECALL;
  spi_read(17'h1C53A,8'h3A);
 
  spi_wren;
  spi_write(17'h1C53A,8'h30);
  do_hardstore;
  
  spi_wren;
  spi_write(17'h1C53A,8'h30);
  do_hardstore;
 
  spi_dpien;
  dpi_rdid;
  dpi_sleep;
  dpi_read(17'h1C53A,8'hzz);
  dpi_exit_sleep;
  dpi_read(17'h1C53A,8'h30);

`ifdef PKG_16SOIC_RTC
  dpi_fast_rdrtc(9, 'h21);
`endif
  
  dpi_hibernate;
  #TSTORE; 
  dpi_read(17'h1C53A,8'hzz);
  #TWAKE;
  dpi_read(17'h1C53A,8'h30);
 
  dpi_wren;
  dpi_write(17'h1C53A,8'h35);
  dpi_asdi;
  #TSOFT;
  vcc_reg = 0;
  #TSTORE;
  #TFA;
  vcc_reg = 1;
  #TFA;
  spi_read(17'h1C53A,8'h30);
  
  spi_dpien;
  dpi_read(17'h1C53A,8'h30);
  dpi_hibernate;
  #TSTORE; 
  vcc_reg = 0;
  #1_000_000;
  vcc_reg = 1;
  #TWAKE;
  spi_read(17'h1C53A,8'h30);
  
  change_spi_clock(CLOCK_108MHZ);
  
  spi_fast_read(17'h1C53A,8'h30);
  spi_dor(17'h1C53A,8'h30);
  spi_dior(17'h1C53A,8'h30);  
  
  spi_wren;  
  spi_diw(17'h1C53A,8'h33);
  spi_dior(17'h1C53A,8'h33);

  spi_wren;  
  spi_diow(17'h1C53A,8'h35);
  spi_dor(17'h1C53A,8'h35);  

  drive_wp(1'b1);  
  spi_wren;  
  spi_wrcr(8'h42);//Enable Quad bit
  spi_rdcr(8'h42);//Read CR register
  
  spi_wren;    
  spi_qiw(17'h1C53A,8'h37);    
  spi_qior(17'h1C53A,8'h37);

  spi_wren;    
  spi_qiow(17'h1C53A,8'h39);    
  spi_qor(17'h1C53A,8'h39);

  spi_qpien;
  qpi_wren;
  qpi_write(17'h00000,8'hAA);
  qpi_read(17'h00000,8'hAA);  
  qpi_wren;  
  qpi_wrsr('h1C);
  qpi_wren;
  qpi_write(17'h00000,8'hBB); 
  
  qpi_dpien;
  drive_wp(1'b1);
  drive_io3(1'b1);   
  //QPI -> DPI
  dpi_wren;
  dpi_wrcr(8'h40);//Disable Quad bit
  dpi_rdcr(8'h40);//Disable Quad bit
  
  dpi_read(17'h00000,8'hAA);    
  dpi_wren;  
  dpi_wrsr('h9C);  
  dpi_rdsr('h9C);
  drive_wp(1'b0);
  dpi_wren; 
  dpi_wrsr('h00);
  dpi_rdsr('h9C);  
  drive_wp(1'b1);
  dpi_wren;  
  dpi_wrsr('h00);
  dpi_wren;    
  dpi_wrsr('h00);  
  dpi_rdsr('h00);  
  dpi_wren;  
  dpi_rdsr('h02);
  dpi_rsten;
  dpi_reset;
  #TRESET;
  spi_rdsr('h00);

  // XIP
  spi_wren;
  spi_wrcr(8'h42);
  spi_qpien;
  qpi_wren;
  qpi_write_n(17'h0,8'h0,PATTERN_DATA_EQ_ADDR,32);
  qpi_fast_read_n (17'h0,8'h0,PATTERN_DATA_EQ_ADDR,32);
  
  //Enter XIP
  set_xip(8'hA0);
  qpi_fast_read(17'h5,8'h5);
  //TB will stop sending opcode
  qpi_fast_read(17'h6,8'h6);
  qpi_fast_read(17'h7,8'h7);
  //These instructions will be ignored
  qpi_wrdi;
  qpi_spien;
  qpi_wren;
  qpi_wrcr(8'h42);
  qpi_spien;
  qpi_rsten;
  qpi_reset;
  #TRESET;
  qpi_fast_read(17'hF,8'hF);
  //Exit XIP
  set_xip(8'h50);
  qpi_fast_read(17'hA,8'hA);
  //TB will start sending opcode
  qpi_fast_read(17'hB,8'hB);
  qpi_fast_read(17'hC,8'hC);
  //XIP in Burst Mode
  qpi_write_n(17'h0,8'h0,PATTERN_DATA_EQ_ADDRB,32);
  set_xip(8'hAA);
  qpi_fast_read_n (17'h0,8'h0,PATTERN_DATA_EQ_ADDRB,16);
  //No opcode for this read
  qpi_fast_read_n (17'hF,8'h0,PATTERN_DATA_EQ_ADDRB,16);
  qpi_fast_read_n (17'h0,8'h0,PATTERN_DATA_EQ_ADDRB,16);
  qpi_fast_read(17'h0,8'hFF);
  qpi_fast_read(17'hF,8'hF0);
  //These instructions will be ignored
  qpi_asen;
  qpi_asdi;
  qpi_store;
  qpi_recall;
  qpi_rsten;
  qpi_reset;
  #TRESET;
  set_xip(8'h5A);
  qpi_fast_read_n (17'h0,8'h0,PATTERN_DATA_EQ_ADDRB,16);
  //TB Starts sending opcode
  qpi_fast_read_n (17'hF,8'h0,PATTERN_DATA_EQ_ADDRB,16);
  qpi_fast_read(17'h0,8'hFF);
  qpi_fast_read(17'hF,8'hF0);
  qpi_rsten;
  qpi_reset;
  #TRESET;