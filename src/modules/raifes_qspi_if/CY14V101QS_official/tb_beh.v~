// +FHDR -----------------------------------------------------------------------
// Copyright 2016, Cypress Semiconductor Corporation
// Cypress Confidential Proprietary
// This code is provided as is without warranty or guarantee of any kind as its accuracy, 
// completeness, operability, fitness for particular purpose, or any other warranty.
// -----------------------------------------------------------------------------
// FILE NAME:  tb_beh.v
// TYPE:       Testbench for 1-Mbit Quad SPI nvSRAM with RTC verilog model
// -----------------------------------------------------------------------------
// Release History
// Revision 1.0  08/02/2016 - Initial test bench
//
// -----------------------------------------------------------------------------
// DESCRIPTION:  This is part of behavioral model for 1Mbit Quad SPI nvSRAM with RTC.
// -----------------------------------------------------------------------------

`timescale 1 ns / 1 ns
module tb_beh;

reg vcc_reg;
reg clk_xtal;

// Global integers that can be used in other testbenches
integer i;

wire  SCK, SCE, SI, SO, WP, IO3, HSB, RTC_CLK, VCC;
		
//TOP LEVEL INCLUDE
`include  "config.v"
`include  "params.v"
buf (weak0, weak1) (HSB, 1'b1);
////////////////////////////////////////////////
//INSTANSIATE THE MODEL 
////////////////////////////////////////////////
`ifdef PKG_16SOIC
cy14v101xs i_nvsram (.IO3_PIN(IO3), .SCE_PIN(SCE), .SO_PIN(SO), .WP_PIN(WP), .HSB_PIN(HSB), .SI_PIN(SI), .SCK_PIN(SCK), .VCC(VCC) );
`endif

`ifdef PKG_16SOIC_RTC
cy14v101xs i_nvsram (.IO3_PIN(IO3), .SCE_PIN(SCE), .SO_PIN(SO), .WP_PIN(WP), .INT_PIN(INT_SIG), .HSB_PIN(HSB), .SI_PIN(SI), .SCK_PIN(SCK), .RTC_CLK(RTC_CLK), .VCC(VCC));
`endif

////////////////////////////////////////////////
`include "spi_driver.v"

assign  SCK     = spi_sck_in;
assign  SCE     = cs_in;
assign  SI      = si_in;
assign  SO      = so_in;
assign  WP      = wp_in;
assign  IO3     = io3_in;
assign  HSB     = hsb_in;
assign  VCC     = vcc_reg;
assign  RTC_CLK = clk_xtal;

initial 
begin
	$shm_open("output.shm");
	$shm_probe("AC");
        vcc_reg = 1;
	clk_xtal = 0;
        vcc_reg = 0;
        #10;
        vcc_reg = 1;
	$monitor("SCE: ", SCE, " SO: ", SO, " SI: ", SI, " HSB: ", HSB, " SCK: ", SCK, "WP: ", WP, "IO3: ", IO3, "VCC: ", VCC);
        #TFA;
           `include  "test_cases.v"	        
        $stop;

end


// define clk_xtal clock
initial
begin
    forever
    begin
        #(XTAL_PERIOD*0.5)  clk_xtal = !clk_xtal;
    end
end
				
endmodule //tb_beh
