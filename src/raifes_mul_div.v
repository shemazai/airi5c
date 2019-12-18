`include "raifes_hasti_constants.vh"

module raifes_mul_div (
	input				reset,
	input				clk,
	
	input				pcpi_valid,
	input		[`XPR_LEN-1:0]	pcpi_insn,
	input		[`XPR_LEN-1:0]	pcpi_rs1,
	input		[`XPR_LEN-1:0]	pcpi_rs2,
	output	reg			pcpi_wr,
	output	reg	[`XPR_LEN-1:0]	pcpi_rd,
	output	reg			pcpi_wait,
	output	reg			pcpi_ready
);


reg	[`XPR_LEN-1:0]	insn_r;	
reg	[`XPR_LEN-1:0]	rs1_r, rs2_r;

// input hold registers

always @(posedge clk) begin
	if(reset) begin
		insn_r <= `XPR_LEN'h0;
		rs1_r <= `XPR_LEN'h0;
		rs2_r <= `XPR_LEN'h0;
	end else begin
		if(pcpi_valid) begin
			insn_r <= pcpi_insn;
			rs1_r <= pcpi_rs1;
			rs2_r <= pcpi_rs2;
		end
	end
end

// insn decoding

wire	[6:0]	funct7; assign funct7 = insn_r[31:25];
wire	[2:0]	funct3; assign funct3 = insn_r[14:12];
wire	[6:0]	opcode; assign opcode = insn_r[6:0];

wire	mul_div_funct;
assign mul_div_funct = (funct7 == 7'h1) && (opcode == 7'h33);

wire	inst_mul, inst_mulh, inst_mulhsu, inst_mulhu;

assign inst_mul 	= mul_div_funct && (funct3 == 3'h0);
assign inst_mulh 	= mul_div_funct && (funct3 == 3'h1);
assign inst_mulhsu 	= mul_div_funct && (funct3 == 3'h2);
assign inst_mulhu 	= mul_div_funct && (funct3 == 3'h3);

wire	inst_div, inst_divu;

assign inst_div 	= mul_div_funct && (funct3 == 3'h4);
assign inst_divu 	= mul_div_funct && (funct3 == 3'h5);

wire	inst_rem, inst_remu;

assign inst_rem 	= mul_div_funct && (funct3 == 3'h6);
assign inst_remu 	= mul_div_funct && (funct3 == 3'h7);

wire	inst_invalid;
assign inst_invalid = ~(inst_mul ||
			inst_mulh ||
			inst_mulhsu ||
			inst_mulhu ||
			inst_div ||
			inst_divu ||
			inst_rem ||
			inst_remu);



reg	[3:0]	state, next_state;

`define	STATE_RESET 0
`define STATE_IDLE 1
`define	STATE_DECODE 2
`define	STATE_MUL 3
`define	STATE_DIV 4
`define	STATE_REM 5
`define	STATE_INVALID 13
`define STATE_FINISH 14
`define	STATE_ERROR 15


always @(posedge clk) begin
	if(reset) begin
		state <= `STATE_RESET;
	end else begin
		state <= next_state;
	end
end

/* TODO: INSERT REAL IMPLEMENTATION ! */
/* ================================== */

`define STATE_MUL_IDLE 1
`define STATE_MUL_STAGE1 2
`define STATE_MUL_STAGE2 3
`define STATE_MUL_STAGE3 4
`define STATE_MUL_STAGE4 5
`define STATE_MUL_STAGE5 6
`define STATE_MUL_FINISHED 7

wire	signed [`XPR_LEN-1:0] rs1_r_signed; assign rs1_r_signed = rs1_r;
wire	signed [`XPR_LEN-1:0] rs2_r_signed; assign rs2_r_signed = rs2_r;

reg	signed [(2*`XPR_LEN)-1:0]	result_mul;
reg	[`XPR_LEN-1:0]			mul_opa, mul_opb, mul_opa_r, mul_opb_r;
reg					mul_sign, mul_sign_r;
reg	[(2*`XPR_LEN)-1:0]		pp, pp_r;



reg	[3:0]	mul_state, next_mul_state;
reg		mul_finished;

always @(posedge clk) begin 
	if(reset) begin
		mul_state <= `STATE_MUL_IDLE;
		mul_opa_r <= 0;
		mul_opb_r <= 0;
		mul_sign_r <= 0;
		pp_r <= 0;
	end else begin
		mul_state <= next_mul_state;
		pp_r <= pp;
		if(mul_state == `STATE_MUL_STAGE1) begin
			mul_opa_r <= mul_opa;
			mul_opb_r <= mul_opb;
			mul_sign_r <= mul_sign;
		end
	end
end

/*always @(*) begin
	mul_finished = 1'b0;
	result_mul = 64'hdeadbeefdeadbeef;
	case(mul_state)
		`STATE_MUL_IDLE : next_mul_state = ((state == `STATE_DECODE) && (inst_mul || inst_mulh || inst_mulhsu || inst_mulhu)) ? `STATE_MUL_STAGE1 : `STATE_MUL_IDLE;
		`STATE_MUL_STAGE1 : begin			
			next_mul_state = `STATE_MUL_FINISHED;
			result_mul = (inst_mul || inst_mulh) ?	({{32{rs1_r_signed[31]}},rs1_r_signed} * {{32{rs2_r_signed[31]}},rs2_r_signed}) : 
				     (inst_mulhsu) ? (({{32{rs1_r_signed[31]}},rs1_r_signed})[15:0] * {32'h0,rs2_r}) :
				     (inst_mulhu) ? (({32'h0,rs1_r})[15:0] * {32'h0,rs2_r}) : -1;
				end
		`STATE_MUL_FINISHED : begin
			mul_finished = 1'b1;
			next_mul_state = `STATE_MUL_IDLE;
			result_mul = pp + ((inst_mul || inst_mulh) ?	({{32{rs1_r_signed[31]}},rs1_r_signed}[31:16] * {{32{rs2_r_signed[31]}},rs2_r_signed}) : 
				     (inst_mulhsu) ? ({{32{rs1_r_signed[31]}},rs1_r_signed}[31:16] * {32'h0,rs2_r}) :
				     (inst_mulhu) ? ({32'h0,rs1_r}[31:16] * {32'h0,rs2_r}) : -1) << 16;
				end
	endcase
end*/

always @(*) begin
	next_mul_state = `STATE_MUL_IDLE;
	mul_finished = 1'b0;
	result_mul = 64'hdeadbeefdeadbeef;
	mul_sign = 1'b0;
	pp = 0;
	mul_opa = 0;
	mul_opb = 0;
	case(mul_state)
		`STATE_MUL_IDLE : next_mul_state = ((state == `STATE_DECODE) && (inst_mul || inst_mulh || inst_mulhsu || inst_mulhu)) ? `STATE_MUL_STAGE1 : `STATE_MUL_IDLE;
		`STATE_MUL_STAGE1 : begin			
					next_mul_state = `STATE_MUL_STAGE2;
					if(inst_mul || inst_mulh) begin
						mul_sign = rs1_r[31] ^ rs2_r[31];
						mul_opa = rs1_r[31] ? ((rs1_r ^ {`XPR_LEN{1'b1}}) + 1) : rs1_r;
						mul_opb = rs2_r[31] ? ((rs2_r ^ {`XPR_LEN{1'b1}}) + 1) : rs2_r;
				  	end else if(inst_mulhsu) begin
						mul_sign = rs1_r[31];
						mul_opa = rs1_r[31] ? ((rs1_r ^ {`XPR_LEN{1'b1}}) + 1) : rs1_r;
						mul_opb = rs2_r;
					end else if(inst_mulhu) begin
						mul_sign = 1'b0;
						mul_opa = rs1_r;
						mul_opb = rs2_r;
					end
				end
		`STATE_MUL_STAGE2 : begin
					next_mul_state = `STATE_MUL_STAGE3;
					pp = mul_opa_r[15:0] * mul_opb_r[15:0];
				end
		`STATE_MUL_STAGE3 : begin
					next_mul_state = `STATE_MUL_STAGE4;
					pp = pp_r + ((mul_opa_r[15:0] * mul_opb_r[31:16]) << 16);
				end
		`STATE_MUL_STAGE4 : begin
					next_mul_state = `STATE_MUL_STAGE5;
					pp = pp_r + ((mul_opa_r[31:16] * mul_opb_r[15:0]) << 16);
				end
		`STATE_MUL_STAGE5 : begin
					next_mul_state = `STATE_MUL_FINISHED;
					pp = pp_r + ((mul_opa_r[31:16] * mul_opb_r[31:16]) << 32);
				end
		`STATE_MUL_FINISHED : begin
			mul_finished = 1'b1;
			next_mul_state = `STATE_MUL_IDLE;
			result_mul = mul_sign_r ? (pp_r ^ {`XPR_LEN*2{1'b1}}) + 1 : pp_r;
			end
	endcase
end



// ==

`define STATE_DIV_IDLE 1
`define STATE_DIV_STAGE1 2
`define STATE_DIV_STAGE2 3
`define STATE_DIV_FINISHED 4

reg	[3:0]	div_state, next_div_state;
reg		div_finished;
reg	[`XPR_LEN-1:0]	result_div;
reg	[`XPR_LEN-1:0]	divider_r, divider;
reg	[`XPR_LEN-1:0]	divisor_r, divisor;
reg	[`XPR_LEN-1:0]	sub_r, sub;
reg			div_sign_r, div_sign;

always @(posedge clk) begin
	if(reset) begin
		div_state <= `STATE_DIV_IDLE;
		divider_r <= 0;
		divisor_r <= 0;
		sub_r <= 0;
		div_sign_r <= 0;
	end else begin
		div_state <= next_div_state;
		divider_r <= divider;
		divisor_r <= divisor;
		sub_r <= sub;
		div_sign_r <= div_sign;
	end
end

always @(*) begin
	next_div_state = `STATE_DIV_IDLE;
	div_sign = 0;
	div_finished = 0;
	result_div = 0;
	divider = 0;
	divisor = 0;
	sub = 0;
	case(div_state)
		`STATE_DIV_IDLE : begin
					next_div_state = ((state == `STATE_DECODE) && (inst_div || inst_divu || inst_rem || inst_remu)) ? `STATE_DIV_STAGE1 : `STATE_DIV_IDLE;

				  end
		`STATE_DIV_STAGE1 : begin
					next_div_state = `STATE_DIV_STAGE2;
					if(inst_div || inst_rem) begin				
						divisor = rs1_r[31] ? ({32{1'b1}} ^ rs1_r) + 1 : rs1_r;
						sub = rs2_r[31] ? ({32{1'b1}} ^ rs2_r) + 1 : rs2_r;
						div_sign = rs1_r[31] ^ rs2_r[31];
					end else begin
						divisor = rs1_r;
						sub = rs2_r;
						div_sign = 1'b0;
					end
				    end
		`STATE_DIV_STAGE2 : begin
					sub = sub_r;
					if(divisor_r >= sub) begin
						next_div_state = `STATE_DIV_STAGE2;
						divisor = divisor_r - sub_r;
						divider = divider_r + 1;
					end else begin
						next_div_state = `STATE_DIV_FINISHED;
						divisor = divisor_r;
						divider = divider_r;
					end
				end
		`STATE_DIV_FINISHED : begin
				div_finished = 1'b1;
				next_div_state = `STATE_DIV_IDLE;
				result_div = (inst_div || inst_divu) ? (div_sign_r ? ({32{1'b1}} ^ divider_r) + 1 : divider_r) :
					     (inst_rem || inst_remu) ? (div_sign_r ? ({32{1'b1}} ^ divisor_r) + 1 : divisor_r) : -1;
				end
	endcase
end


/* ================================== */


reg	[`XPR_LEN-1:0]	result_r;


always @(posedge clk) begin
	if(reset) begin
		result_r <= `XPR_LEN'hdeadbeef;
	end else begin
		case(state)
			`STATE_MUL	:	if(mul_finished) result_r <= inst_mul ? result_mul[31:0] :
							    (inst_mulh || inst_mulhu || inst_mulhsu) ? result_mul[63:32] : -1;
			`STATE_DIV	:	result_r <= result_div;
			`STATE_REM	:	result_r <= result_div;
			default		:	result_r <= result_r;
		endcase
	end
end


always @(*) begin
	next_state = `STATE_ERROR;
	pcpi_wr = 1'b0;
	pcpi_rd = `XPR_LEN'hdeadbeef;
	pcpi_wait = 1'b0;
	pcpi_ready = 1'b0;

	case(state) 
		`STATE_RESET	:	next_state = `STATE_IDLE;	// rfu
		`STATE_IDLE	:	begin
						next_state = pcpi_valid ? `STATE_DECODE : `STATE_IDLE;
					end
		`STATE_DECODE	:	begin
						next_state = inst_invalid ? `STATE_IDLE : 
							(inst_mul || inst_mulh || inst_mulhsu || inst_mulhu) ? `STATE_MUL : 
							(inst_div || inst_divu) ? `STATE_DIV :
							(inst_rem || inst_remu) ? `STATE_REM : `STATE_IDLE;
					end
		`STATE_MUL	:	begin
						pcpi_wait = 1'b1;
						next_state = mul_finished ? `STATE_FINISH : `STATE_MUL;
						//next_state = `STATE_FINISH;
					end
		`STATE_DIV	:	begin
						pcpi_wait = 1'b1;
						next_state = div_finished ? `STATE_FINISH : `STATE_DIV;
					end
		`STATE_REM	:	begin
						pcpi_wait = 1'b1;
						next_state = div_finished ? `STATE_FINISH : `STATE_DIV;
					end
		`STATE_FINISH	:	begin
						pcpi_ready = 1'b1;
						pcpi_wr = 1'b1;
						pcpi_rd = result_r;
						next_state = `STATE_IDLE;
					end

	endcase
end


endmodule 
