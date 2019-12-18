// 
//	raifes_gpio
//
`include "raifes_hasti_constants.vh"

`define GPIO_BASE_ADDR	32'hC0000008

module raifes_gpio(
		// system clk and reset
		input			reset,
		input			clk,

		// gpio in/outputs
		output	reg	[7:0]	gpio_d,
		output	reg	[7:0]	gpio_en,
		input		[7:0]	gpio_i,

		// system bus 
	        input	[`HASTI_ADDR_WIDTH-1:0]  haddr,
        	input				hwrite,			// unused, as imem is read-only (typically)
	        input	[`HASTI_SIZE_WIDTH-1:0]  hsize,
		input	[`HASTI_BURST_WIDTH-1:0] hburst,
	        input 			   	hmastlock,
	        input	[`HASTI_PROT_WIDTH-1:0]  hprot,
	        input	[`HASTI_TRANS_WIDTH-1:0] htrans,
	        input	[`HASTI_BUS_WIDTH-1:0]   hwdata,			// unused, as imem is read-only (typically)
	        output	[`HASTI_BUS_WIDTH-1:0]    hrdata,
	        output 	reg			   	hready,
	        output	reg	[`HASTI_RESP_WIDTH-1:0]   hresp
);


`define GPIO_IDLE 0
`define GPIO_READ_D 1
`define GPIO_READ_EN 2
`define GPIO_WRITE_D 3
`define GPIO_WRITE_EN 4

always @(posedge clk) begin
		if(haddr == `GPIO_BASE_ADDR) begin
			gpio_d <= hwdata[7:0];
		end else
		if(haddr == (`GPIO_BASE_ADDR+4)) begin
			gpio_en <= hwdata[7:0];
		end
end

assign hrdata = gpio_i;

endmodule
