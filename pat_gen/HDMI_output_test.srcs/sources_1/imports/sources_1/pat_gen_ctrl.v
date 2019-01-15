module pat_gen_ctrl(/*AUTOARG*/
   // Outputs
   pat_gen_data, pat_gen_data_vld, cal_trig, divisor_0, divisor_1,
   divisor_2, sync_pat_gen_en, sync_pat_gen_en_ack,
   sync_pat_gen_int_tmg, sync_pat_gen_auto_scrl_en, pat_gen_tot_wd,
   pat_gen_tot_ht, pat_gen_actv_wd, pat_gen_actv_ht, pat_gen_hs_wd,
   pat_gen_vs_wd, pat_gen_hbp_wd, pat_gen_vbp_wd,
   pat_gen_frms_per_pat, pat_gen_slt_num, pat_gen_slt_pat_num,
   // Inputs
   clk, rst_n, hs_pol, vs_pol, fnl_de_pol, fnl_de_en, actv_wd,
   actv_ht, lvds_data, ext_x_zone, ext_y_zone, ext_actv_x_pos,
   ext_actv_y_pos, ext_scrl_mode, ext_cal_trig, ext_work_trig,
   ext_work, int_x_zone, int_y_zone, int_actv_x_pos, int_actv_y_pos,
   int_scrl_mode, int_cal_trig, int_work_trig, int_work, quotient_0,
   quotient_1, quotient_2, sync_en, bist_en, pat_gen_en, map_sel,
   pat_gen_mode, pat_gen_col_bar_en, pat_gen_rvs_vcom_en,
   pat_gen_chkbd_sc, pat_gen_cus_col_en, pat_gen_18bit,
   pat_gen_ext_clk_src, pat_gen_int_tmg, pat_gen_rvs_col_en,
   pat_gen_auto_scrl_en, int_reg_data
   );

// PARAMETERS
parameter DSIZE = 28; 
parameter WD_SIZE = 12;
parameter HT_SIZE = 12;
parameter Q_SIZE = 16;
localparam MUL_SIZE_0 = (Q_SIZE + WD_SIZE);
localparam MUL_SIZE_1 = (Q_SIZE + HT_SIZE);
localparam SYNC_N = 5;
localparam PAT_0  = 5'b0_0000;
localparam PAT_1  = 5'b0_0001;
localparam PAT_2  = 5'b0_0010;
localparam PAT_3  = 5'b0_0011;
localparam PAT_4  = 5'b0_0100;
localparam PAT_5  = 5'b0_0101;
localparam PAT_6  = 5'b0_0110;
localparam PAT_7  = 5'b0_0111;
localparam PAT_8  = 5'b0_1000;
localparam PAT_9  = 5'b0_1001;
localparam PAT_10 = 5'b0_1010;
localparam PAT_11 = 5'b0_1011;
localparam PAT_12 = 5'b0_1100;
localparam PAT_13 = 5'b0_1101;
localparam PAT_14 = 5'b0_1110;
localparam PAT_15 = 5'b0_1111;
localparam PAT_16 = 5'b1_0000;
localparam PAT_17 = 5'b1_0001;
localparam PAT_18 = 5'b1_0010;
localparam X_HS   = 2'b00;
localparam X_HBP  = 2'b01;
localparam X_ACTV = 2'b10;
localparam X_HFP  = 2'b11;
localparam Y_VS   = 2'b00;
localparam Y_VBP  = 2'b01;
localparam Y_ACTV = 2'b10;
localparam Y_VFP  = 2'b11;
localparam BLANK_DATA = 24'd0;
localparam PIPE_D = 4;
// INPUTS
input                        clk;
input                        rst_n;
// from POL_DET
input                        hs_pol;
input                        vs_pol;
input                        fnl_de_pol;
input                        fnl_de_en;
input  [WD_SIZE-1:0]         actv_wd;
input  [HT_SIZE-1:0]         actv_ht;
input  [DSIZE-1:0]           lvds_data;
// from PAT_GEN_EXT
input  [1:0]                 ext_x_zone;
input  [1:0]                 ext_y_zone;
input  [WD_SIZE-1:0]         ext_actv_x_pos;
input  [HT_SIZE-1:0]         ext_actv_y_pos;
input  [3:0]                 ext_scrl_mode;
input                        ext_cal_trig;
input                        ext_work_trig;
input                        ext_work;
// from PAT_GEN_INT
input  [1:0]                 int_x_zone;
input  [1:0]                 int_y_zone;
input  [WD_SIZE-1:0]         int_actv_x_pos;
input  [HT_SIZE-1:0]         int_actv_y_pos;
input  [3:0]                 int_scrl_mode;
input                        int_cal_trig;
input                        int_work_trig;
input                        int_work;
// from div
input  [Q_SIZE-1:0]          quotient_0;
input  [Q_SIZE-1:0]          quotient_1;
input  [Q_SIZE-1:0]          quotient_2;
// from TX_CTRL
input                        sync_en;
input                        bist_en;
input                        pat_gen_en;
input                        map_sel;
input  [3:0]                 pat_gen_mode;
input                        pat_gen_col_bar_en;
input                        pat_gen_rvs_vcom_en;
input                        pat_gen_chkbd_sc;
input                        pat_gen_cus_col_en;
input                        pat_gen_18bit;
input                        pat_gen_ext_clk_src;
input                        pat_gen_int_tmg;
input                        pat_gen_rvs_col_en;
input                        pat_gen_auto_scrl_en;
input  [7:0]                 int_reg_data[24:0];
// OUTPUTS
output [DSIZE-1:0]           pat_gen_data;
output                       pat_gen_data_vld;
output                       cal_trig; 
output [WD_SIZE-1:0]         divisor_0;
output [HT_SIZE-1:0]         divisor_1;
output [WD_SIZE-1:0]         divisor_2;
output                       sync_pat_gen_en;
output                       sync_pat_gen_en_ack;
output                       sync_pat_gen_int_tmg;
output                       sync_pat_gen_auto_scrl_en;
output [WD_SIZE-1:0]         pat_gen_tot_wd;
output [HT_SIZE-1:0]         pat_gen_tot_ht;
output [WD_SIZE-1:0]         pat_gen_actv_wd;
output [HT_SIZE-1:0]         pat_gen_actv_ht;
output [7:0]                 pat_gen_hs_wd;
output [7:0]                 pat_gen_vs_wd;
output [7:0]                 pat_gen_hbp_wd;
output [7:0]                 pat_gen_vbp_wd;
output [7:0]                 pat_gen_frms_per_pat;
output [3:0]                 pat_gen_slt_num;
output [3:0]                 pat_gen_slt_pat_num[15:0];
// REGS
reg    [SYNC_N-1:0]          sync_pat_gen_en_d;
reg    [1:0]                 sync_sync_en_d;
reg    [1:0]                 sync_bist_en_d;
reg                          sync_map_sel;
reg    [3:0]                 sync_pat_gen_mode;
reg                          sync_pat_gen_col_bar_en;
reg                          sync_pat_gen_rvs_vcom_en;
reg                          sync_pat_gen_chkbd_sc;
reg                          sync_pat_gen_cus_col_en;
reg                          sync_pat_gen_18bit;
reg                          sync_pat_gen_ext_clk_src;
reg                          sync_pat_gen_int_tmg;
reg                          sync_pat_gen_rvs_col_en;
reg                          sync_pat_gen_auto_scrl_en;
reg    [7:0]                 sync_int_reg_data[24:0];
reg    [WD_SIZE-1:0]         divisor_0;
reg    [HT_SIZE-1:0]         divisor_1;
reg    [WD_SIZE-1:0]         divisor_2;
reg                          cal_trig;
reg                          pg_work_trig;
reg                          pg_work;
reg    [WD_SIZE-1:0]         pg_actv_wd;
reg    [HT_SIZE-1:0]         pg_actv_ht; 
reg    [3:0]                 scrl_mode;
reg    [4:0]                 fnl_pat_gen_mode;
reg    [23:0]                chkbd_col_0;
reg    [1:0]                 chkbd_chk_bit;
reg    [23:0]                pg_actv_data_0;
reg    [23:0]                pg_actv_data_6;
reg    [23:0]                pg_actv_data_7;
reg    [23:0]                pg_actv_data_8;
reg    [23:0]                pg_actv_data_9;
reg    [23:0]                pg_actv_data_10;
reg    [23:0]                pg_actv_data_11;
reg    [23:0]                pg_actv_data_12;
reg    [23:0]                pg_actv_data_13;
reg    [23:0]                pg_actv_data_15;
reg    [23:0]                pg_actv_data_16;
reg    [23:0]                vcom_col_0;
reg    [23:0]                vcom_col_1;
reg    [23:0]                vcom_col_2;
reg    [23:0]                vcom_col_3;
reg    [PIPE_D-1:0]          pg_actv_d;
reg    [23:0]                actv_data_d[PIPE_D-1:0];
reg    [DSIZE-1:0]           pat_gen_data;
reg    [DSIZE-1:0]           lvds_data_d[PIPE_D-1:0];
reg    [PIPE_D-1:0]          pg_work_d;
reg    [1:0]                 fnl_de_pol_d;
reg    [1:0]                 fnl_de_en_d;
reg                          hs_val;
reg                          vs_val;
reg                          de_val;
reg    [1:0]                 int_x_zone_d[PIPE_D-1:0];
reg    [1:0]                 int_y_zone_d[PIPE_D-1:0];
// WIRES
wire                         sync_pat_gen_en_rising_edge;
wire                         sync_pat_gen_en_ack;
wire                         sync_pat_gen_en;
wire                         sync_bist_en;
wire                         sync_sync_en;
wire   [7:0]                 pat_gen_cus_red;
wire   [7:0]                 pat_gen_cus_green;
wire   [7:0]                 pat_gen_cus_blue;
wire   [5:0]                 pat_gen_clk_div;
wire   [WD_SIZE-1:0]         pat_gen_tot_wd;
wire   [HT_SIZE-1:0]         pat_gen_tot_ht;
wire   [WD_SIZE-1:0]         pat_gen_actv_wd;
wire   [HT_SIZE-1:0]         pat_gen_actv_ht;
wire   [7:0]                 pat_gen_hs_wd;
wire   [7:0]                 pat_gen_vs_wd;
wire   [7:0]                 pat_gen_hbp_wd;
wire   [7:0]                 pat_gen_vbp_wd;
wire                         pat_gen_vs_dis;
wire                         pat_gen_hs_dis;
wire                         pat_gen_vs_pol;
wire                         pat_gen_hs_pol;
wire   [7:0]                 pat_gen_frms_per_pat;
wire   [3:0]                 pat_gen_slt_num;
wire   [3:0]                 pat_gen_slt1_pat_num[15:0];
wire   [23:0]                pg_actv_data[18:0];
wire                         pg_actv;
wire   [23:0]                chkbd_col_1;
wire   [MUL_SIZE_0-1:0]      tmp_hs_pg_actv_data;
wire   [7:0]                 hs_pg_actv_data;
wire   [MUL_SIZE_1-1:0]      tmp_vs_pg_actv_data;
wire   [7:0]                 vs_pg_actv_data;
wire   [23:0]                col_bar_col_0;
wire   [23:0]                col_bar_col_1;
wire   [23:0]                col_bar_col_2;
wire   [23:0]                col_bar_col_3;
wire   [23:0]                col_bar_col_4;
wire   [23:0]                col_bar_col_5;
wire   [23:0]                col_bar_col_6;
wire   [MUL_SIZE_0-1:0]      tmp_col_bar_idx;
wire   [2:0]                 col_bar_idx;
wire   [23:0]                actv_data;
wire                         fnl_pat_gen_18bit;
wire   [DSIZE-1:0]           fnl_lvds_data;
wire                         fnl_lvds_de;
wire                         fnl_lvds_vs;
wire                         fnl_lvds_hs;
wire                         pat_gen_data_vld;
wire   [23:0]                fnl_actv_data;
wire                         comb_pat_gen_en;
wire                         sync_fnl_de_pol;
wire                         sync_fnl_de_en;
// INTEGERS
integer                      i;

/*AUTOINPUT*/
/*AUTOOUTPUT*/
/*AUTOREG*/
/*AUTOWIRE*/

//--========================MODULE SOURCE CODE==========================--

assign sync_pat_gen_en_rising_edge = sync_pat_gen_en_d[1] & (~sync_pat_gen_en_d[3]);
// extend ack pulse 
assign sync_pat_gen_en_ack = | sync_pat_gen_en_d[SYNC_N-1:3];
assign sync_pat_gen_en = sync_pat_gen_en_d[1];
assign sync_bist_en = sync_bist_en_d[1];
assign sync_sync_en = sync_sync_en_d[1];

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		sync_pat_gen_en_d <= #`DLY {SYNC_N{1'b0}};
	end
	else begin
		sync_pat_gen_en_d[0] <= #`DLY pat_gen_en;
		for (i=1; i<SYNC_N; i=i+1) begin
			sync_pat_gen_en_d[i] <= #`DLY sync_pat_gen_en_d[i-1];
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		sync_sync_en_d <= #`DLY 2'd0;
		sync_bist_en_d <= #`DLY 2'd0;
	end
	else begin
		sync_sync_en_d <= #`DLY {sync_sync_en_d[0], sync_en};
		sync_bist_en_d <= #`DLY {sync_bist_en_d[0], bist_en};
	end
end

// note: if any setting pat_gen_en get new value
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		sync_map_sel <= #`DLY 1'b0;
		sync_pat_gen_mode <= #`DLY 4'd0;
		sync_pat_gen_col_bar_en <= #`DLY 1'b0;
		sync_pat_gen_rvs_vcom_en <= #`DLY 1'b0;
		sync_pat_gen_chkbd_sc <= #`DLY 1'b0;
		sync_pat_gen_cus_col_en <= #`DLY 1'b0;
		sync_pat_gen_18bit <= #`DLY 1'b0;
		sync_pat_gen_ext_clk_src <= #`DLY 1'b0;
        sync_pat_gen_int_tmg <= #`DLY 1'b0;
        sync_pat_gen_rvs_col_en <= #`DLY 1'b0;
        sync_pat_gen_auto_scrl_en <= #`DLY 1'b0;
		for (i=0; i<25; i=i+1) begin
			sync_int_reg_data[i] <= #`DLY 8'd0;
		end
	end
	// note: use 2 cycle rising edge
	else if (sync_pat_gen_en_rising_edge == 1'b1) begin
		sync_map_sel <= #`DLY map_sel;
		sync_pat_gen_mode <= #`DLY pat_gen_mode;
		sync_pat_gen_col_bar_en <= #`DLY pat_gen_col_bar_en;
		sync_pat_gen_rvs_vcom_en <= #`DLY pat_gen_rvs_vcom_en;
		sync_pat_gen_chkbd_sc <= #`DLY pat_gen_chkbd_sc;
		sync_pat_gen_cus_col_en <= #`DLY pat_gen_cus_col_en;
		sync_pat_gen_18bit <= #`DLY pat_gen_18bit;
		sync_pat_gen_ext_clk_src <= #`DLY pat_gen_ext_clk_src;
        sync_pat_gen_int_tmg <= #`DLY pat_gen_int_tmg;
        sync_pat_gen_rvs_col_en <= #`DLY pat_gen_rvs_col_en;
        sync_pat_gen_auto_scrl_en <= #`DLY pat_gen_auto_scrl_en;
		for (i=0; i<25; i=i+1) begin
			sync_int_reg_data[i] <= #`DLY int_reg_data[i];
		end
	end
end

//--=========================================--
// PARSER :
// get internal pattern generator's configuration
//
//--=========================================--
assign pat_gen_cus_red            = sync_int_reg_data[0];
assign pat_gen_cus_green          = sync_int_reg_data[1];
assign pat_gen_cus_blue           = sync_int_reg_data[2];
assign pat_gen_clk_div            = sync_int_reg_data[3][5:0];
assign pat_gen_tot_wd             = {sync_int_reg_data[5][3:0], sync_int_reg_data[4]};
assign pat_gen_tot_ht             = {sync_int_reg_data[6], sync_int_reg_data[5][7:4]};
assign pat_gen_actv_wd            = {sync_int_reg_data[8][3:0], sync_int_reg_data[7]};
assign pat_gen_actv_ht            = {sync_int_reg_data[9], sync_int_reg_data[8][7:4]};
assign pat_gen_hs_wd              = sync_int_reg_data[10];
assign pat_gen_vs_wd              = sync_int_reg_data[11];
assign pat_gen_hbp_wd             = sync_int_reg_data[12];
assign pat_gen_vbp_wd             = sync_int_reg_data[13];
assign pat_gen_vs_dis             = sync_int_reg_data[14][3];
assign pat_gen_hs_dis             = sync_int_reg_data[14][2];
assign pat_gen_vs_pol             = sync_int_reg_data[14][1];
assign pat_gen_hs_pol             = sync_int_reg_data[14][0];
assign pat_gen_frms_per_pat       = sync_int_reg_data[15];
assign pat_gen_slt_num            = sync_int_reg_data[16][3:0];
assign pat_gen_slt_pat_num[0]     = sync_int_reg_data[17][3:0];
assign pat_gen_slt_pat_num[1]     = sync_int_reg_data[17][7:4];
assign pat_gen_slt_pat_num[2]     = sync_int_reg_data[18][3:0];
assign pat_gen_slt_pat_num[3]     = sync_int_reg_data[18][7:4];
assign pat_gen_slt_pat_num[4]     = sync_int_reg_data[19][3:0];
assign pat_gen_slt_pat_num[5]     = sync_int_reg_data[19][7:4];
assign pat_gen_slt_pat_num[6]     = sync_int_reg_data[20][3:0];
assign pat_gen_slt_pat_num[7]     = sync_int_reg_data[20][7:4];
assign pat_gen_slt_pat_num[8]     = sync_int_reg_data[21][3:0];
assign pat_gen_slt_pat_num[9]     = sync_int_reg_data[21][7:4];
assign pat_gen_slt_pat_num[10]    = sync_int_reg_data[22][3:0];
assign pat_gen_slt_pat_num[11]    = sync_int_reg_data[22][7:4];
assign pat_gen_slt_pat_num[12]    = sync_int_reg_data[23][3:0];
assign pat_gen_slt_pat_num[13]    = sync_int_reg_data[23][7:4];
assign pat_gen_slt_pat_num[14]    = sync_int_reg_data[24][3:0];
assign pat_gen_slt_pat_num[15]    = sync_int_reg_data[24][7:4];

//--=========================================--
// INT/EXT ARBITER :
//
//
//--=========================================--
always @(*) begin
	if (sync_pat_gen_int_tmg == 1'b1) begin
		divisor_0     = pat_gen_actv_wd - 1'b1;
		divisor_1     = pat_gen_actv_ht - 1'b1;
		divisor_2     = pat_gen_actv_wd - 1'b1;
		cal_trig      = int_cal_trig;
		pg_work_trig  = int_work_trig;
		pg_work       = int_work;
		pg_actv_wd    = pat_gen_actv_wd;
		pg_actv_ht    = pat_gen_actv_ht;
		scrl_mode     = int_scrl_mode;
	end
	else begin
		divisor_0     = actv_wd - 1'b1;
		divisor_1     = actv_ht - 1'b1;
		divisor_2     = actv_wd - 1'b1;
		cal_trig      = ext_cal_trig;
		pg_work_trig  = ext_work_trig;
		pg_work       = ext_work;
		pg_actv_wd    = actv_wd;
		pg_actv_ht    = actv_ht;
		scrl_mode     = ext_scrl_mode;
	end
end


//--=========================================--
// GENERATOR :
//
//
//--=========================================--
assign pg_actv = (int_y_zone == Y_ACTV) && (int_x_zone == X_ACTV);

always @(*) begin
	if (sync_sync_en == 1'b1)
		fnl_pat_gen_mode = 5'd17;
	else if (sync_bist_en == 1'b1)
		fnl_pat_gen_mode = 5'd18;
	else begin
		if (sync_pat_gen_col_bar_en == 1'b1)
			fnl_pat_gen_mode = 5'd16;
		else if (sync_pat_gen_auto_scrl_en == 1'b1)
			fnl_pat_gen_mode = {1'b0, int_scrl_mode};
		else 
			fnl_pat_gen_mode = {1'b0, sync_pat_gen_mode};
	end
end

// pattern 0 checkboard
assign chkbd_col_1 = 24'h0;

always @(*) begin
	if ((fnl_pat_gen_mode == PAT_0) && (sync_pat_gen_cus_col_en == 1'b1))
		chkbd_col_0 = {pat_gen_cus_red, pat_gen_cus_green, pat_gen_cus_blue};
	else
		chkbd_col_0 = 24'hffffff;
end

always @(*) begin
	if ((fnl_pat_gen_mode == PAT_0) && (sync_pat_gen_chkbd_sc == 1'b1))
		chkbd_chk_bit = 2'd3;
	else
		chkbd_chk_bit = 2'd0;
end

assign pg_actv_data[0] = pg_actv_data_0;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		pg_actv_data_0 <= #`DLY 24'h0;
	end
	else if ((fnl_pat_gen_mode == PAT_0) && (pg_actv == 1'b1)) begin
		if ((int_actv_x_pos[chkbd_chk_bit] == 1'b0)
			&& (int_actv_y_pos[chkbd_chk_bit] == 1'b0))
			pg_actv_data_0 <= #`DLY chkbd_col_0;
		else
			pg_actv_data_0 <= #`DLY chkbd_col_1;
	end
end

// pattern 1 white/black
assign pg_actv_data[1] = 24'hffffff;

// pattern 2 black/white
assign pg_actv_data[2] = 24'h0;

// pattern 3 red/cyan
assign pg_actv_data[3] = 24'hff0000;

// pattern 4 green/magenta
assign pg_actv_data[4] = 24'h00ff00;

// pattern 5 blue/yellow
assign pg_actv_data[5] = 24'h0000ff;

// pattern 6 horizontally scaled black to white/white to black
assign tmp_hs_pg_actv_data = int_actv_x_pos * quotient_0; // quotient_0=255*(2^8)/(width-1);
assign hs_pg_actv_data = tmp_hs_pg_actv_data[MUL_SIZE_0-9:MUL_SIZE_0-16];

assign pg_actv_data[6] = pg_actv_data_6;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		pg_actv_data_6 <= #`DLY 24'h0;
	end
	else if ((fnl_pat_gen_mode == PAT_6) && (pg_actv == 1'b1)) begin
		pg_actv_data_6 <= #`DLY {hs_pg_actv_data, hs_pg_actv_data, hs_pg_actv_data};
	end
end

// pattern 7 horizontally scaled black to red/white to cyan
assign pg_actv_data[7] = pg_actv_data_7;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		pg_actv_data_7 <= #`DLY 24'hff0000;
	end
	else if ((fnl_pat_gen_mode == PAT_7) && (pg_actv == 1'b1)) begin
		pg_actv_data_7 <= #`DLY {hs_pg_actv_data, 16'd0};
	end
end

// pattern 8 horizontally scaled black to green/white to magenta
assign pg_actv_data[8] = pg_actv_data_8;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		pg_actv_data_8 <= #`DLY 24'h00;
	end
	else if ((fnl_pat_gen_mode == PAT_8) && (pg_actv == 1'b1)) begin
		pg_actv_data_8 <= #`DLY {8'd0, hs_pg_actv_data, 8'd0};
	end
end

// pattern 9 horizontally scaled black to blue/white to yellow
assign pg_actv_data[9] = pg_actv_data_9;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		pg_actv_data_9 <= #`DLY 24'h00ff00;
	end
	else if ((fnl_pat_gen_mode == PAT_9) && (pg_actv == 1'b1)) begin
		pg_actv_data_9 <= #`DLY {16'd0, hs_pg_actv_data};
	end
end

// pattern 10 vertically scaled black to white/white to black
assign tmp_vs_pg_actv_data = int_actv_y_pos * quotient_1; // quotient_1=255*(2^8)/(height-1);
assign vs_pg_actv_data = tmp_vs_pg_actv_data[MUL_SIZE_1-9:MUL_SIZE_1-16];

assign pg_actv_data[10] = pg_actv_data_10;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		pg_actv_data_10 <= #`DLY 24'h0;
	end
	else if ((fnl_pat_gen_mode == PAT_10) && (pg_actv == 1'b1)) begin
		pg_actv_data_10 <= #`DLY {vs_pg_actv_data, vs_pg_actv_data, vs_pg_actv_data};
	end
end

// pattern 11 vertically scaled black to red/white to cyan
assign pg_actv_data[11] = pg_actv_data_11;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		pg_actv_data_11 <= #`DLY 24'hff0000;
	end
	else if ((fnl_pat_gen_mode == PAT_11) && (pg_actv == 1'b1)) begin
		pg_actv_data_11 <= #`DLY {vs_pg_actv_data, 16'd0};
	end
end

// pattern 12 vertically scaled black to green/white to magenta
assign pg_actv_data[12] = pg_actv_data_12;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		pg_actv_data_12 <= #`DLY 24'h00ff00;
	end
	else if ((fnl_pat_gen_mode == PAT_12) && (pg_actv == 1'b1)) begin
		pg_actv_data_12 <= #`DLY {8'd0, vs_pg_actv_data, 8'd0};
	end
end

// pattern 13 vertically scaled black to blue/white to yellow
assign pg_actv_data[13] = pg_actv_data_13;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		pg_actv_data_13 <= #`DLY 24'h00ff00;
	end
	else if ((fnl_pat_gen_mode == PAT_13) && (pg_actv == 1'b1)) begin
		pg_actv_data_13 <= #`DLY {16'd0, vs_pg_actv_data};
	end
end

// pattern 14 custom color
assign pg_actv_data[14] = {pat_gen_cus_red, pat_gen_cus_green, pat_gen_cus_blue};

// pattern 15 VCOM
always @(*) begin
	if (sync_pat_gen_rvs_vcom_en == 1'b1) begin
		// RBCY
		vcom_col_0 = 24'hff0000;
		vcom_col_1 = 24'h0000ff;
		vcom_col_2 = 24'h00ffff;
		vcom_col_3 = 24'hffff00;
	end
	else begin
		// YCBR
		vcom_col_0 = 24'hffff00;
		vcom_col_1 = 24'h00ffff;
		vcom_col_2 = 24'h0000ff;
		vcom_col_3 = 24'hff0000;
	end
end

assign pg_actv_data[15] = pg_actv_data_15;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		pg_actv_data_15 <= #`DLY 24'h0;
	end
	else if ((fnl_pat_gen_mode == PAT_15) && (pg_actv == 1'b1)) begin
		if (int_actv_x_pos < pg_actv_wd[11:2])
			pg_actv_data_15 <= #`DLY vcom_col_0;
		else if (int_actv_x_pos < pg_actv_wd[11:1])
			pg_actv_data_15 <= #`DLY vcom_col_1;
		else if (int_actv_x_pos < (pg_actv_wd[11:1] + pg_actv_wd[11:2]))
			pg_actv_data_15 <= #`DLY vcom_col_2;
		else
			pg_actv_data_15 <= #`DLY vcom_col_3;
	end
end

// pattern 16 color bar
// gray, yellow, cyan, green, magenta, red, blue
assign col_bar_col_0 = 24'hc0c0c0;
assign col_bar_col_1 = 24'hc0c000;
assign col_bar_col_2 = 24'h00c0c0;
assign col_bar_col_3 = 24'h00c000;
assign col_bar_col_4 = 24'hc000c0;
assign col_bar_col_5 = 24'hc00000;
assign col_bar_col_6 = 24'h0000c0;

// quotient_2 = 7*(2^12)/(width-1)
assign tmp_col_bar_idx = int_actv_x_pos * quotient_2;
assign col_bar_idx = tmp_col_bar_idx[MUL_SIZE_0-10:MUL_SIZE_0-12];

assign pg_actv_data[16] = pg_actv_data_16;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		pg_actv_data_16 <= #`DLY 24'h0;
	end
	else if ((fnl_pat_gen_mode == PAT_16) && (pg_actv == 1'b1)) begin
		case (col_bar_idx)
			3'd0: pg_actv_data_16 <= #`DLY col_bar_col_0;
			3'd1: pg_actv_data_16 <= #`DLY col_bar_col_1;
			3'd2: pg_actv_data_16 <= #`DLY col_bar_col_2;
			3'd3: pg_actv_data_16 <= #`DLY col_bar_col_3;
			3'd4: pg_actv_data_16 <= #`DLY col_bar_col_4;
			3'd5: pg_actv_data_16 <= #`DLY col_bar_col_5;
			default: pg_actv_data_16 <= #`DLY col_bar_col_6;
		endcase
	end
end

// pattern 17 sync
assign pg_actv_data[17] = 24'h5555;

// pattern 18 bist
assign pg_actv_data[18] = 24'h0;

//--=========================================--
// INVERSE & 18bit & bit re-order post processing :
//
// 
//--=========================================--
assign actv_data = pg_actv_data[fnl_pat_gen_mode];

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		pg_actv_d <= #`DLY {PIPE_D{1'b0}};
	end
	else begin
		pg_actv_d[0] <= #`DLY pg_actv;
		for (i=1; i<PIPE_D; i=i+1)
			pg_actv_d[i] <= #`DLY pg_actv_d[i-1];
	end
end

// invert color
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		actv_data_d[0] <= #`DLY 24'd0;
	end
	else if (pg_actv_d[0] == 1'b1) begin
		if ((sync_pat_gen_rvs_col_en == 1'b1) && (fnl_pat_gen_mode <= 16))
			actv_data_d[0] <= #`DLY {8'd255-actv_data[23:16], 8'd255-actv_data[15:8], 8'd255-actv_data[7:0]};
		else
			actv_data_d[0] <= #`DLY actv_data;
	end
end

// 18-bit or 24-bit depth adjustment & data order
assign fnl_pat_gen_18bit = (fnl_pat_gen_mode <= 16) ? sync_pat_gen_18bit : 1'b0;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		actv_data_d[1] <= #`DLY 24'd0;
	end
	else if (pg_actv_d[1] == 1'b1) begin
		case ({fnl_pat_gen_18bit, sync_map_sel})
			2'b00: actv_data_d[1] <= #`DLY {actv_data_d[0][16], actv_data_d[0][17], actv_data_d[0][8], actv_data_d[0][9], actv_data_d[0][0], actv_data_d[0][1], 
				actv_data_d[0][4], actv_data_d[0][5], actv_data_d[0][6], actv_data_d[0][7], 
				actv_data_d[0][11], actv_data_d[0][12], actv_data_d[0][13], actv_data_d[0][14], actv_data_d[0][15], actv_data_d[0][2], actv_data_d[0][3], 
				actv_data_d[0][18], actv_data_d[0][19], actv_data_d[0][20], actv_data_d[0][21], actv_data_d[0][22], actv_data_d[0][23], actv_data_d[0][10]}; 
			2'b10: actv_data_d[1] <= #`DLY {actv_data_d[0][16], actv_data_d[0][17], actv_data_d[0][8], actv_data_d[0][9], actv_data_d[0][0], actv_data_d[0][1],
				actv_data_d[0][4], actv_data_d[0][5], 2'b00,  
				actv_data_d[0][11], actv_data_d[0][12], actv_data_d[0][13], 2'b00, actv_data_d[0][2], actv_data_d[0][3], 
				actv_data_d[0][18], actv_data_d[0][19], actv_data_d[0][20], actv_data_d[0][21], 2'b00, actv_data_d[0][10]};
			2'b01: actv_data_d[1] <= #`DLY {actv_data_d[0][22], actv_data_d[0][23], actv_data_d[0][14], actv_data_d[0][15], actv_data_d[0][6], actv_data_d[0][7],
				actv_data_d[0][2], actv_data_d[0][3], actv_data_d[0][4], actv_data_d[0][5],
				actv_data_d[0][9], actv_data_d[0][10], actv_data_d[0][11], actv_data_d[0][12], actv_data_d[0][13], actv_data_d[0][0], actv_data_d[0][1],
				actv_data_d[0][16], actv_data_d[0][17], actv_data_d[0][18], actv_data_d[0][19], actv_data_d[0][20], actv_data_d[0][21], actv_data_d[0][8]};
			2'b11: actv_data_d[1] <= #`DLY {6'd0, 
				actv_data_d[0][2], actv_data_d[0][3], actv_data_d[0][4], actv_data_d[0][5],
				actv_data_d[0][9], actv_data_d[0][10], actv_data_d[0][11], actv_data_d[0][12], actv_data_d[0][13], actv_data_d[0][0], actv_data_d[0][1],
				actv_data_d[0][16], actv_data_d[0][17], actv_data_d[0][18], actv_data_d[0][19], actv_data_d[0][20], actv_data_d[0][21], actv_data_d[0][8]};
		endcase
	end
end

//--=========================================--
// INT-TIMING/EXT-TIMING ARBITER :
//
//
//--=========================================--
assign fnl_lvds_data = lvds_data_d[PIPE_D-2];
assign fnl_lvds_de = fnl_lvds_data[14];
assign fnl_lvds_vs = fnl_lvds_data[15];
assign fnl_lvds_hs = fnl_lvds_data[16];
assign pat_gen_data_vld = pg_work_d[PIPE_D-1];
assign fnl_actv_data = actv_data_d[1];
assign comb_pat_gen_en = sync_pat_gen_en || sync_bist_en || sync_sync_en;
assign sync_fnl_de_pol = fnl_de_pol_d[1];
assign sync_fnl_de_en  = fnl_de_en_d[1];

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		for (i=0; i<PIPE_D; i=i+1)
			lvds_data_d[i] <= #`DLY 'd0;
	end
	else begin
		lvds_data_d[0] <= #`DLY lvds_data;
		for (i=1; i<PIPE_D; i=i+1) begin
			lvds_data_d[i] <= #`DLY lvds_data_d[i-1];
		end
	end
end

// note: in order to simplify the code, 
// all the mode, the valid image data will be generated x cycles later than pg_work
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		pg_work_d <= #`DLY {PIPE_D{1'b0}};
	end
	else begin
		pg_work_d[0] <= #`DLY pg_work;
		for (i=1; i<PIPE_D; i=i+1)
			pg_work_d[i] <= #`DLY pg_work_d[i-1];
	end
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		fnl_de_pol_d <= #`DLY 2'b0;
	else
		fnl_de_pol_d <= #`DLY {fnl_de_pol_d[0], fnl_de_pol};
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		fnl_de_en_d <= #`DLY 2'b0;
	else
		fnl_de_en_d <= #`DLY {fnl_de_en_d[0], fnl_de_en};
end

always @(*) begin
	if (pat_gen_vs_dis == 1'b1)
		vs_val = pat_gen_vs_pol;
	else
		vs_val = ~pat_gen_vs_pol;
end

always @(*) begin
	if (pat_gen_hs_dis == 1'b1)
		hs_val = pat_gen_hs_pol;
	else
		hs_val = ~pat_gen_hs_pol;
end

always @(*) begin
	if (sync_fnl_de_en == 1'b0)
		de_val = sync_fnl_de_pol;
	else
		de_val = ~sync_fnl_de_pol;
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		for (i=0; i<PIPE_D; i=i+1)
			int_x_zone_d[i] <= #`DLY 'd0;
	end
	else begin
		int_x_zone_d[0] <= #`DLY int_x_zone;
		for (i=1; i<PIPE_D; i=i+1) begin
			int_x_zone_d[i] <= #`DLY int_x_zone_d[i-1];
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		for (i=0; i<PIPE_D; i=i+1)
			int_y_zone_d[i] <= #`DLY 'd0;
	end
	else begin
		int_y_zone_d[0] <= #`DLY int_y_zone;
		for (i=1; i<PIPE_D; i=i+1) begin
			int_y_zone_d[i] <= #`DLY int_y_zone_d[i-1];
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		pat_gen_data <= #`DLY {DSIZE{1'b0}};
	end
	else if ((comb_pat_gen_en == 1'b1) && (pg_work_d[PIPE_D-2] == 1'b1)) begin
		if (sync_pat_gen_int_tmg == 1'b1) begin
			casez ({int_y_zone_d[PIPE_D-1], int_x_zone_d[PIPE_D-1]})
				{Y_VS, X_HS}:
					pat_gen_data <= #`DLY {BLANK_DATA[23:18], ~BLANK_DATA[18], BLANK_DATA[17:14], hs_val, vs_val, ~de_val, BLANK_DATA[13:0]};
				{Y_VS, X_HBP}, {Y_VS, X_ACTV}, {Y_VS, X_HFP}:                                          
					pat_gen_data <= #`DLY {BLANK_DATA[23:18], ~BLANK_DATA[18], BLANK_DATA[17:14], ~hs_val, vs_val, ~de_val, BLANK_DATA[13:0]};
                                                                     
				{Y_VBP, X_HS}:                                       
					pat_gen_data <= #`DLY {BLANK_DATA[23:18], ~BLANK_DATA[18], BLANK_DATA[17:14], hs_val, ~vs_val, ~de_val, BLANK_DATA[13:0]};
				{Y_VBP, X_HBP}, {Y_VBP, X_ACTV}, {Y_VBP, X_HFP}:                                         
					pat_gen_data <= #`DLY {BLANK_DATA[23:18], ~BLANK_DATA[18], BLANK_DATA[17:14], ~hs_val, ~vs_val, ~de_val, BLANK_DATA[13:0]};
                                                                     
				{Y_ACTV, X_HS}:                                      
					pat_gen_data <= #`DLY {BLANK_DATA[23:18], ~BLANK_DATA[18], BLANK_DATA[17:14], hs_val, ~vs_val, ~de_val, BLANK_DATA[13:0]};
				{Y_ACTV, X_HBP}:                                     
					pat_gen_data <= #`DLY {BLANK_DATA[23:18], ~BLANK_DATA[18], BLANK_DATA[17:14], ~hs_val, ~vs_val, ~de_val, BLANK_DATA[13:0]};
				{Y_ACTV, X_ACTV}:                                    
					pat_gen_data <= #`DLY {fnl_actv_data[23:18], ~fnl_actv_data[18], fnl_actv_data[17:14], ~hs_val, ~vs_val, de_val, fnl_actv_data[13:0]};
				{Y_ACTV, X_HFP}:                                     
					pat_gen_data <= #`DLY {BLANK_DATA[23:18], ~BLANK_DATA[18], BLANK_DATA[17:14], ~hs_val, ~vs_val, ~de_val, BLANK_DATA[13:0]};
                                                                     
				{Y_VFP, X_HS}:                                       
					pat_gen_data <= #`DLY {BLANK_DATA[23:18], ~BLANK_DATA[18], BLANK_DATA[17:14], hs_val, ~vs_val, ~de_val, BLANK_DATA[13:0]};
				{Y_VFP, X_HBP}, {Y_VFP, X_ACTV}, {Y_VFP, X_HFP}:                                         
					pat_gen_data <= #`DLY {BLANK_DATA[23:18], ~BLANK_DATA[18], BLANK_DATA[17:14], ~hs_val, ~vs_val, ~de_val, BLANK_DATA[13:0]};
			endcase
		end
	end
end

endmodule
