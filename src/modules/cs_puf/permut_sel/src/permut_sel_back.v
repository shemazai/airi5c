//Verilog HDL for "CS_PUF", "permut" "functional"
`define ARRAY_SIZE 8


module permut_sel_aio (
	input clk,
        input resn,
	input en,

	input [15:0] sel, 

	output reg ready,
	output reg init,
	output reg amp_enable,
	output [7:0] cout
);
reg[3:0] i, n;
reg[15:0] swp_cnt;
reg[2:0] c[0:7];
reg[2:0] array[0:7];

always @ (posedge clk) begin
        if (!resn || !en) begin
                array[0]<=3'h0;
		array[1]<=3'h1;
		array[2]<=3'h2;
		array[3]<=3'h3;
		array[4]<=3'h4;
		array[5]<=3'h5;
		array[6]<=3'h6;
		array[7]<=3'h7;
		c[0]<=3'h0;
		c[1]<=3'h0;
		c[2]<=3'h0;
		c[3]<=3'h0;
		c[4]<=3'h0;
		c[5]<=3'h0;
		c[6]<=3'h0;
		c[7]<=3'h0;	
//                $display(array[0]);
//		$display(array[1]);
		swp_cnt<=0;
		i<=0;
//		n<=8;
		ready<=1'b0;	
        end

        else if(en) begin
	if(swp_cnt<sel && swp_cnt<40319) begin
                if (i<`ARRAY_SIZE) begin
                        if (c[i]<i) begin
//			 $display (swp_cnt,"=",array[0], array[1], array[2], array [3], array[4], array[5], array[6], array[7]);
//                                if (i%2==0) begin
                                if (i[0] == 1'b0) begin
                                        array[0] <= array[i];
					array[i] <= array[0];
                                end
                                else begin
                                        array[c[i]] <= array[i];
					array[i] <= array[c[i]];
                                end
                                c[i]<=c[i]+1;
                                i<=0;
                                swp_cnt<=swp_cnt+1;
                        end
                        else begin
                                c[i]<=0;
                                i<=i+1;
                        end
                end
	end
	else begin
	ready<=1'b1;
	$display (swp_cnt,"=",array[0], array[1], array[2], array [3], array[4], array[5], array[6], array[7]);
	end
	end
end

`define IDLE 0
`define RUNNING 1
`define LASTC 2
`define FINISH 4

reg [7:0] state, next_state;
reg [7:0] cout_r;
reg [7:0] stepcount;
reg [2:0] next_cout;

assign 	cout = cout_r;

always @(posedge clk, negedge resn) begin
	if(~resn) begin
		state <= `IDLE;
		stepcount <= 8'h0;
		cout_r <= 8'h0;
	end 
	else begin
		state <= next_state;
		if(state == `RUNNING) begin
			stepcount <= stepcount + 1'b1;
			cout_r <= cout_r | (1'b1 << next_cout);
		end		
	end
end

always @(*) begin 
	next_cout = 0;
	init = 0;
	amp_enable = 0;
	case(state)
		`IDLE :	begin
				next_state = ready ? `RUNNING : `IDLE;		
				init = 1'b1;
			end
		`RUNNING : begin 
				next_state = (stepcount == 7) ? `LASTC : `RUNNING;
				init = 1'b0;
				next_cout = array[stepcount];
			   end
		`LASTC : begin 
				next_state = `FINISH;
			end
		`FINISH : begin 
				next_state = en ? `FINISH : `IDLE;
				amp_enable = 1'b1;			
			end	

	endcase
end
endmodule

