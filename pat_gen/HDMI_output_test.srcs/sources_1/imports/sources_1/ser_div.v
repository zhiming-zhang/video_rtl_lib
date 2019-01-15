
module ser_div (/*AUTOARG*/
   // Outputs
   quotient, div_done,
   // Inputs
   clk, rst_n, cal_trig, dividend, divisor
   );

// PARAMETERS
parameter DIV_M = 16;           // Size of dividend
parameter DIV_N = 8;            // Size of divisor
parameter DIV_R = 0;            // Size of remainder
parameter DIV_S = 0;            // Skip leading zeros
parameter DIV_C = 5;            // 2^DIV_C-1 >= (DIV_M+DIV_R-DIV_S-1)
// INPUTS
input                             clk;
input                             rst_n;
input                             cal_trig;
input  [DIV_M-1:0]                dividend;
input  [DIV_N-1:0]                divisor;
// OUTPUTS
output [DIV_M+DIV_R-DIV_S-1:0]    quotient;
output                            div_done;
// REGS
reg                               div_done;
reg    [DIV_M+DIV_R-1:0]          grand_dividend;
reg    [DIV_M+DIV_N+DIV_R-2:0]    grand_divisor;
reg    [DIV_M+DIV_R-DIV_S-1:0]    quotient;
reg    [DIV_C-1:0]                div_cnt;
// WIRES
wire   [DIV_M+DIV_N+DIV_R-1:0]    subtract_node; // Subtract node has extra "sign" bit
wire   [DIV_M+DIV_R-1:0]          quotient_node; // Shifted version of quotient
wire   [DIV_M+DIV_N+DIV_R-2:0]    divisor_node;  // Shifted version of grand divisor

/*AUTOINPUT*/
/*AUTOOUTPUT*/
/*AUTOREG*/
/*AUTOWIRE*/

//--========================MODULE SOURCE CODE==========================--
//
// DIV_M = Bit width of the dividend
// DIV_N = Bit width of the divisor
// DIV_R = Remainder bits desired
// DIV_S = Skipped quotient bits
//     [ DIV_M bits     ][    DIV_R bits]
//     [ DIV_S bits ][    quotient_o]
//
assign subtract_node = {1'b0, grand_dividend} - {1'b0, grand_divisor};
assign quotient_node = 
  {quotient[DIV_M+DIV_R-DIV_S-2:0], ~subtract_node[DIV_M+DIV_N+DIV_R-1]};
assign divisor_node  = {1'b0, grand_divisor[DIV_M+DIV_N+DIV_R-2:1]};

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		grand_dividend <= #`DLY 'd0;
		grand_divisor <= #`DLY 'd0;
		div_cnt <= #`DLY 'd0;
		quotient <= #`DLY 'd0;
		div_done <= #`DLY 1'b0;
	end
	else if (cal_trig == 1'b1) begin 
		grand_dividend <= #`DLY dividend << DIV_R;
		grand_divisor  <= #`DLY divisor << (DIV_N+DIV_R-DIV_S-1);
		div_cnt <= #`DLY 'd0;
		quotient <= #`DLY 'd0;
		div_done <= #`DLY 1'b0;
	end
	else if (div_done == 1'b0) begin
		if (div_cnt == DIV_M+DIV_R-DIV_S-1) begin
			quotient <= #`DLY quotient_node;
			div_done <= #`DLY 1;
		end
		else begin 
			if (~subtract_node[DIV_M+DIV_N+DIV_R-1]) 
				grand_dividend <= #`DLY subtract_node;
			quotient <= #`DLY quotient_node;
			grand_divisor <= #`DLY divisor_node;
			div_cnt <= #`DLY div_cnt + 1;
		end
	end
end

endmodule
