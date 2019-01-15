module pat_gen_int(/*AUTOARG*/
   // Outputs
   int_x_zone, int_y_zone, int_actv_x_pos, int_actv_y_pos,
   int_cal_trig, int_work_trig, int_work, int_scrl_mode,
   // Inputs
   clk, rst_n, sync_pat_gen_en, sync_pat_gen_en_ack,
   sync_pat_gen_int_tmg, sync_pat_gen_auto_scrl_en, pat_gen_tot_wd,
   pat_gen_tot_ht, pat_gen_actv_wd, pat_gen_actv_ht, pat_gen_hs_wd,
   pat_gen_vs_wd, pat_gen_hbp_wd, pat_gen_vbp_wd,
   pat_gen_frms_per_pat, pat_gen_slt_num, pat_gen_slt_pat_num
   );

// PARAMETERS
parameter HT_SIZE = 12;
parameter WD_SIZE = 12;
localparam PG_IDLE = 2'b00;
localparam PG_INIT = 2'b01;
localparam PG_CAL  = 2'b10;
localparam PG_WORK = 2'b11;
localparam VRT_IDLE = 3'b000;
localparam VRT_INIT = 3'b001;
localparam VRT_VS   = 3'b010;
localparam VRT_VBP  = 3'b011;
localparam VRT_ACTV = 3'b100;
localparam VRT_VFP  = 3'b101;
localparam HOR_IDLE = 3'b000;
localparam HOR_HS   = 3'b001;
localparam HOR_HBP  = 3'b010;
localparam HOR_ACTV = 3'b011;
localparam HOR_HFP  = 3'b100;
// INPUTS
input                        clk;
input                        rst_n;
input                        sync_pat_gen_en;
input                        sync_pat_gen_en_ack;
input                        sync_pat_gen_int_tmg;
input                        sync_pat_gen_auto_scrl_en;
input  [WD_SIZE-1:0]         pat_gen_tot_wd;
input  [HT_SIZE-1:0]         pat_gen_tot_ht;
input  [WD_SIZE-1:0]         pat_gen_actv_wd;
input  [HT_SIZE-1:0]         pat_gen_actv_ht;
input  [7:0]                 pat_gen_hs_wd;
input  [7:0]                 pat_gen_vs_wd;
input  [7:0]                 pat_gen_hbp_wd;
input  [7:0]                 pat_gen_vbp_wd;
//input                        pat_gen_vs_dis;
//input                        pat_gen_hs_dis;
input  [7:0]                 pat_gen_frms_per_pat;
input  [3:0]                 pat_gen_slt_num;
input  [3:0]                 pat_gen_slt_pat_num[15:0];
// OUTPUTS
//output [WD_SIZE-1:0]         int_x_pos;
//output [HT_SIZE-1:0]         int_y_pos;
output [1:0]                 int_x_zone;
output [1:0]                 int_y_zone;
output [WD_SIZE-1:0]         int_actv_x_pos;
output [HT_SIZE-1:0]         int_actv_y_pos;
output                       int_cal_trig;
output                       int_work_trig;
output                       int_work;
output [3:0]                 int_scrl_mode;
// REGS
reg    [1:0]                 curr_st;
reg    [1:0]                 next_st;
reg    [2:0]                 curr_vrt;
reg    [2:0]                 next_vrt;
reg    [2:0]                 curr_hor;
reg    [2:0]                 next_hor;
reg    [4:0]                 cal_cnt;
//reg                          cal_ovr;
reg    [WD_SIZE-1:0]         x[3:0];
reg    [HT_SIZE-1:0]         y[3:0];
reg    [WD_SIZE-1:0]         pat_gen_hfp_wd;
reg    [HT_SIZE-1:0]         pat_gen_vfp_wd;
reg                          scrl_en_d;
reg                          seq_trig;
reg                          slt_trig;
reg    [3:0]                 slt_cnt;
reg    [8:0]                 frm_cnt;
reg    [HT_SIZE-1:0]         int_y_pos;
reg    [HT_SIZE-1:0]         int_actv_y_pos;
reg    [1:0]                 int_y_zone;
reg    [WD_SIZE-1:0]         int_x_pos;
reg    [WD_SIZE-1:0]         int_actv_x_pos;
reg    [1:0]                 int_x_zone;
// WIRES
wire                         int_pat_gen_en;
wire                         init_ovr;
wire                         int_cal_trig;
wire                         int_work_trig;
wire                         int_work;
wire                         cal_ovr;
wire   [3:0]                 int_scrl_mode;
wire                         vs_ovr;
wire                         vbp_ovr;
wire                         vrt_actv_ovr;
wire                         vfp_ovr;
wire                         frm_trig;
wire                         init_frm_trig;
wire                         scrl_en_rising_edge;
wire                         scrl_en_falling_edge;
wire                         init_scrl_trig;
wire                         hs_ovr;
wire                         hbp_ovr;
wire                         hor_actv_ovr;
wire                         hfp_ovr;
wire                         hor_actv_trig;

/*AUTOINPUT*/
/*AUTOOUTPUT*/
/*AUTOREG*/
/*AUTOWIRE*/

//--========================MODULE SOURCE CODE==========================--

//--=========================================--
// GENERATOR FSM:
// generate internal pattern
//
//--=========================================--
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		curr_st <= #`DLY PG_IDLE;
	else
		curr_st <= #`DLY next_st;
end

always @(*) begin
	next_st = curr_st;
	case (curr_st)
		PG_IDLE: begin
			if (int_pat_gen_en == 1'b1)
				next_st = PG_INIT;
		end
		PG_INIT: begin
			// get registers
			if (init_ovr == 1'b1)
				next_st = PG_CAL;
		end
		PG_CAL: begin
			// get results from config registers
			if (cal_ovr == 1'b1)
				next_st = PG_WORK;
		end
		PG_WORK: begin
			if (int_pat_gen_en == 1'b0)
				next_st = PG_IDLE;
		end
	endcase

	if (int_pat_gen_en == 1'b0)
		next_st = PG_IDLE;
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		curr_vrt <= #`DLY VRT_IDLE;
	else
		curr_vrt <= #`DLY next_vrt;
end

always @(*) begin
	next_vrt = curr_vrt;
	case (curr_vrt)
		VRT_IDLE: begin
			if (int_work_trig == 1'b1)
				//next_vrt = VRT_INIT;
				next_vrt = VRT_VS;
		end
		//VRT_INIT: 
		//	next_vrt = VRT_VS;
		VRT_VS: begin
			if (vs_ovr == 1'b1) begin
				if (pat_gen_vbp_wd > 0)
					next_vrt = VRT_VBP;
				else
					next_vrt = VRT_ACTV;
			end
		end
		VRT_VBP: begin
			if (vbp_ovr == 1'b1)
				next_vrt = VRT_ACTV;
		end
		VRT_ACTV: begin
			if (vrt_actv_ovr == 1'b1) begin
				if (pat_gen_vfp_wd > 0)
					next_vrt = VRT_VFP;
				else // if (hfp_ovr == 1'b1)
					next_vrt = VRT_VS;
			end
		end
		VRT_VFP: begin
			if (vfp_ovr == 1'b1) begin
				if (hfp_ovr == 1'b1)
					next_vrt = VRT_VS;
			end
		end
		default:
			next_vrt = VRT_IDLE;
	endcase
	if (int_pat_gen_en == 1'b0)
		next_vrt = VRT_IDLE;
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		curr_hor <= #`DLY HOR_IDLE;
	else
		curr_hor <= #`DLY next_hor;
end

always @(*) begin
	next_hor = curr_hor;
	case (curr_hor)
		HOR_IDLE: begin
			if (frm_trig == 1'b1)
				next_hor = HOR_HS;
		end
		HOR_HS: begin
			if (hs_ovr == 1'b1) begin
				if (pat_gen_hbp_wd > 0)
					next_hor = HOR_HBP;
				else
					next_hor = HOR_ACTV;
			end
		end
		HOR_HBP: begin
			if (hbp_ovr == 1'b1)
				next_hor = HOR_ACTV;
		end
		HOR_ACTV: begin
			if (hor_actv_ovr == 1'b1) begin
				if (pat_gen_hfp_wd > 0)
					next_hor = HOR_HFP;
				else
					next_hor = HOR_HS;
			end
		end
		HOR_HFP: begin
			if (hfp_ovr == 1'b1)
				next_hor = HOR_HS;
		end
		default:
			next_hor = HOR_IDLE;
	endcase
	if (int_pat_gen_en == 1'b0)
		next_hor = HOR_IDLE;
end

//--=========================================--
// MAIN CONTROL:
// 
//
//--=========================================--
assign int_pat_gen_en = (sync_pat_gen_en == 1'b1) && (sync_pat_gen_int_tmg == 1'b1);
assign init_ovr = sync_pat_gen_en_ack;
assign int_cal_trig  = (curr_st == PG_INIT) && (next_st == PG_CAL);
assign int_work_trig = (curr_st == PG_CAL ) && (next_st == PG_WORK);
assign int_work = (curr_st == PG_WORK);
assign cal_ovr = (cal_cnt == 5'd31);

// note: mostly it's the time used for scaling-constant calculation
// to simplify the code (still or auto-scroll mode judgement), just wait same time for all the cases.
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		cal_cnt <= #`DLY 5'd0;
	end
	else begin
		if (int_cal_trig == 1'b1)begin
			cal_cnt <= #`DLY 5'd0;
		end
		else if (curr_st == PG_CAL) begin
			if (cal_cnt == 5'd31) begin
				cal_cnt <= #`DLY 5'd0;
			end
			else begin
				cal_cnt <= #`DLY cal_cnt + 1'b1;
			end
		end
	end
end

// set initial parameters
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		x[0] <= #`DLY {WD_SIZE{1'b0}};
		x[1] <= #`DLY {WD_SIZE{1'b0}};
		x[2] <= #`DLY {WD_SIZE{1'b0}};
		x[3] <= #`DLY {WD_SIZE{1'b0}};
		pat_gen_hfp_wd <= #`DLY {WD_SIZE{1'b0}};
	end
	else if (curr_st == PG_CAL) begin
		if (cal_cnt == 5'd0) begin
			x[0] <= #`DLY pat_gen_hs_wd - 1'b1;
			x[1] <= #`DLY pat_gen_hs_wd + pat_gen_hbp_wd;
			x[2] <= #`DLY pat_gen_hs_wd + pat_gen_hbp_wd;
			x[3] <= #`DLY pat_gen_tot_wd - 1'b1;
			pat_gen_hfp_wd <= #`DLY pat_gen_tot_wd - pat_gen_actv_wd;
		end
		else if (cal_cnt == 5'd1) begin
			x[1] <= #`DLY x[1] - 1'b1;
			x[2] <= #`DLY x[2] + pat_gen_actv_wd;
			pat_gen_hfp_wd <= #`DLY pat_gen_hfp_wd - pat_gen_hbp_wd;
		end
		else if (cal_cnt == 5'd2) begin
			x[2] <= #`DLY x[2] - 1'b1;
			pat_gen_hfp_wd <= #`DLY pat_gen_hfp_wd - pat_gen_hs_wd;
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		y[0] <= #`DLY {HT_SIZE{1'b0}};
		y[1] <= #`DLY {HT_SIZE{1'b0}};
		y[2] <= #`DLY {HT_SIZE{1'b0}};
		y[3] <= #`DLY {HT_SIZE{1'b0}};
		pat_gen_vfp_wd <= #`DLY {HT_SIZE{1'b0}};
	end
	else if (curr_st == PG_CAL) begin
		if (cal_cnt == 5'd0) begin
			y[0] <= #`DLY pat_gen_vs_wd - 1'b1;
			y[1] <= #`DLY pat_gen_vs_wd + pat_gen_vbp_wd;
			y[2] <= #`DLY pat_gen_vs_wd + pat_gen_vbp_wd;
			y[3] <= #`DLY pat_gen_tot_ht - 1'b1;
			pat_gen_vfp_wd <= #`DLY pat_gen_tot_ht - pat_gen_actv_ht;
		end
		else if (cal_cnt == 5'd1) begin
			y[1] <= #`DLY y[1] - 1'b1;
			y[2] <= #`DLY y[2] + pat_gen_actv_ht;
			pat_gen_vfp_wd <= #`DLY pat_gen_vfp_wd - pat_gen_vbp_wd;
		end
		else if (cal_cnt == 5'd2) begin
			y[2] <= #`DLY y[2] - 1'b1;
			pat_gen_vfp_wd <= #`DLY pat_gen_vfp_wd - pat_gen_vs_wd;
		end
	end
end

//--=========================================--
// VERTICAL CONTROL:
// 
//
//--=========================================--
// slot control
assign int_scrl_mode = pat_gen_slt_pat_num[slt_cnt];
// frame vertical control
assign vs_ovr  = ((int_y_pos == y[0]) && (hfp_ovr == 1'b1));
assign vbp_ovr = ((int_y_pos == y[1]) && (hfp_ovr == 1'b1));
assign vrt_actv_ovr = ((int_y_pos == y[2]) && (hfp_ovr == 1'b1));
assign vfp_ovr = ((int_y_pos == y[3]) && (hfp_ovr == 1'b1));
//assign frm_trig = ((curr_vrt == VRT_INIT) || (curr_vrt == VRT_VFP) || (curr_vrt == VRT_ACTV)) && (next_vrt == VRT_VS);
assign frm_trig = ((curr_vrt == VRT_IDLE) || (curr_vrt == VRT_VFP) || (curr_vrt == VRT_ACTV)) && (next_vrt == VRT_VS);

assign init_frm_trig = (curr_vrt == VRT_IDLE) && (next_vrt == VRT_VS);
assign scrl_en_rising_edge = sync_pat_gen_auto_scrl_en & (~scrl_en_d);
assign scrl_en_falling_edge = (~sync_pat_gen_auto_scrl_en) & scrl_en_d;
assign init_scrl_trig = scrl_en_rising_edge || scrl_en_falling_edge || init_frm_trig;

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		scrl_en_d <= #`DLY 1'b0;
	end
	else
		scrl_en_d <= #`DLY sync_pat_gen_auto_scrl_en;
end

always @(*) begin
	if (sync_pat_gen_auto_scrl_en == 1'b1) begin
		slt_trig = (frm_trig == 1'b1) && ((frm_cnt + 1'b1) == {pat_gen_frms_per_pat, 1'b0});
		seq_trig = (slt_trig == 1'b1) && (slt_cnt == pat_gen_slt_num);
	end
	else begin
		slt_trig = frm_trig;
		seq_trig = frm_trig;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		slt_cnt <= #`DLY 4'd0;
		frm_cnt <= #`DLY 9'd0;
	end
	else begin
		if (init_scrl_trig == 1'b1) begin
			slt_cnt <= #`DLY 4'd0;
			frm_cnt <= #`DLY 9'd0;
		end
		else begin
			case ({seq_trig, slt_trig, frm_trig}) 
				3'b001: begin
					frm_cnt <= #`DLY frm_cnt + 1'b1;
				end
				3'b011: begin
					frm_cnt <= #`DLY 9'd0;
					slt_cnt <= #`DLY slt_cnt + 1'b1;
				end
				3'b111: begin
					frm_cnt <= #`DLY 9'd0;
					slt_cnt <= #`DLY 4'd0;
				end
			endcase 
		end		
	end
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		int_y_pos <= #`DLY {HT_SIZE{1'b0}};
	//else if ((curr_st == PG_IDLE) && (int_pat_gen_en == 1'b1)) 
	//	int_y_pos <= #`DLY {HT_SIZE{1'b0}};
	else if (curr_st == PG_WORK) begin
		if (frm_trig == 1'b1)
			int_y_pos <= #`DLY {HT_SIZE{1'b0}};
		else if (vfp_ovr == 1'b1) //((curr_vrt == VRT_ACTV) && (next_vrt == VRT_VFP))
			int_y_pos <= #`DLY {HT_SIZE{1'b0}};
		else if (hfp_ovr == 1'b1)
			int_y_pos <= #`DLY int_y_pos + 1'b1;
	end
	else
		int_y_pos <= #`DLY {HT_SIZE{1'b0}};
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		int_actv_y_pos <= #`DLY {HT_SIZE{1'b0}};
	//else if ((curr_st == PG_IDLE) && (int_pat_gen_en == 1'b1))
	//	int_actv_y_pos <= #`DLY {HT_SIZE{1'b0}};
	//else if (curr_st == PG_WORK) begin
	else if (curr_vrt == VRT_ACTV) begin
		//if (frm_trig == 1'b1)
		//	int_actv_y_pos <= #`DLY {HT_SIZE{1'b0}};
		//else if ((curr_vrt == VRT_ACTV) && (next_vrt == VRT_VFP))
		//	int_actv_y_pos <= #`DLY {HT_SIZE{1'b0}};
		//else if ((curr_vrt == VRT_ACTV) && (hfp_ovr == 1'b1))
		//	int_actv_y_pos <= #`DLY int_actv_y_pos + 1'b1;
		//
		if (next_vrt == VRT_VFP)
			int_actv_y_pos <= #`DLY {HT_SIZE{1'b0}};
		else if (hfp_ovr == 1'b1)
			int_actv_y_pos <= #`DLY int_actv_y_pos + 1'b1;
	end
	else
		int_actv_y_pos <= #`DLY {HT_SIZE{1'b0}};
end

always @(*) begin
	case (curr_vrt)
		VRT_VS:   int_y_zone = 2'b00;
		VRT_VBP:  int_y_zone = 2'b01;
		VRT_ACTV: int_y_zone = 2'b10;
		VRT_VFP:  int_y_zone = 2'b11;
		default:  int_y_zone = 2'b00;
	endcase
end

//--=========================================--
// HORIZONTAL CONTROL:
// 
//
//--=========================================--
assign hs_ovr  = (int_x_pos == x[0]);
assign hbp_ovr = (int_x_pos == x[1]);
assign hor_actv_ovr = (int_x_pos == x[2]);
assign hfp_ovr = (int_x_pos == x[3]);
assign hor_actv_trig = (curr_hor == HOR_HBP) && (next_hor == HOR_ACTV);

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		int_x_pos <= #`DLY {WD_SIZE{1'b0}};
	//else if (int_pat_gen_en == 1'b1) begin
	//else if ((curr_st == PG_IDLE) && (int_pat_gen_en == 1'b1))
	//	int_x_pos <= #`DLY {WD_SIZE{1'b0}};
	else if (curr_st == PG_WORK) begin
		if (frm_trig == 1'b1)
			int_x_pos <= #`DLY {WD_SIZE{1'b0}};
		else if (hfp_ovr == 1'b1)
			int_x_pos <= #`DLY {WD_SIZE{1'b0}};
		else
			int_x_pos <= #`DLY int_x_pos + 1'b1;
	end
	else
		int_x_pos <= #`DLY {WD_SIZE{1'b0}};
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		int_actv_x_pos <= #`DLY {WD_SIZE{1'b0}};
	//else if ((curr_st == PG_IDLE) && (int_pat_gen_en == 1'b1))
	//	int_actv_x_pos <= #`DLY {WD_SIZE{1'b0}};
	//else if (curr_st == PG_WORK) begin
	//else if (int_pat_gen_en == 1'b1) begin
	else if (curr_hor == HOR_ACTV) begin
		//if (hor_actv_trig == 1'b1)
		//	int_actv_x_pos <= #`DLY {WD_SIZE{1'b0}};
		//else if ((curr_hor == HOR_ACTV) && (next_hor == HOR_HFP))
		//	int_actv_x_pos <= #`DLY {WD_SIZE{1'b0}};
		//else if (curr_hor == HOR_ACTV)
		//	int_actv_x_pos <= #`DLY int_actv_x_pos + 1'b1;

		if (next_hor == HOR_HFP)
			int_actv_x_pos <= #`DLY {WD_SIZE{1'b0}};
		else
			int_actv_x_pos <= #`DLY int_actv_x_pos + 1'b1;
	end
	else
		int_actv_x_pos <= #`DLY {WD_SIZE{1'b0}};
end

always @(*) begin
	case (curr_hor)
		HOR_HS:   int_x_zone = 2'b00;
		HOR_HBP:  int_x_zone = 2'b01;
		HOR_ACTV: int_x_zone = 2'b10;
		HOR_HFP:  int_x_zone = 2'b11;
		default:  int_x_zone = 2'b00;
	endcase
end

endmodule
