module pat_gen(/*AUTOARG*/
   // Outputs
   pat_gen_data, pat_gen_data_vld,
   // Inputs
   clk, rst_n, det_vld, hs_en, vs_en, fnl_de_en, hs_pol, vs_pol,
   fnl_de_pol, actv_wd, actv_ht, pseudo_vs, pseudo_vs_actv_trig,
   hs_actv_trig, vs_actv_trig, de_actv_trig, de_idle_trig, lvds_data,
   sync_en, bist_en, pat_gen_en, map_sel, pat_gen_mode,
   pat_gen_col_bar_en, pat_gen_rvs_vcom_en, pat_gen_chkbd_sc,
   pat_gen_cus_col_en, pat_gen_18bit, pat_gen_ext_clk_src,
   pat_gen_int_tmg, pat_gen_rvs_col_en, pat_gen_auto_scrl_en,
   int_reg_data, bist_clk_src, pat_gen_int_clk_en
   );

// PARAMETERS
parameter DSIZE = 28; 
parameter WD_SIZE = 12; 
parameter HT_SIZE = 12; 
localparam DIV_M = 16;           // Size of dividend
localparam DIV_N = 12;           // Size of divisor
localparam DIV_R = 0;            // Size of remainder
localparam DIV_S = 0;            // Skip leading zeros
localparam DIV_C = 5;            // 2^C-1 >= (M+R-S-1)
localparam Q_SIZE = (DIV_M+DIV_R-DIV_S);
localparam SYNC_N = 5;
// INPUTS
input                        clk;
input                        rst_n;
// from POL_DET
input                        det_vld;
input                        hs_en;
input                        vs_en;
input                        fnl_de_en;
input                        hs_pol;
input                        vs_pol;
input                        fnl_de_pol;
input  [WD_SIZE-1:0]         actv_wd;
input  [HT_SIZE-1:0]         actv_ht;
input                        pseudo_vs;
input                        pseudo_vs_actv_trig;
input                        hs_actv_trig;
input                        vs_actv_trig;
input                        de_actv_trig;
input                        de_idle_trig;
input  [DSIZE-1:0]           lvds_data;
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
input  [1:0]                 bist_clk_src;
input                        pat_gen_int_clk_en;
// OUTPUTS
output [DSIZE-1:0]           pat_gen_data;
output                       pat_gen_data_vld;
// REGS
// WIRES

/*AUTOINPUT*/
/*AUTOOUTPUT*/
/*AUTOREG*/
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			cal_trig;		// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire [WD_SIZE-1:0]	divisor_0;		// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire [HT_SIZE-1:0]	divisor_1;		// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire [WD_SIZE-1:0]	divisor_2;		// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire [WD_SIZE-1:0]	ext_actv_x_pos;		// From U_PAT_GEN_EXT of pat_gen_ext.v
wire [HT_SIZE-1:0]	ext_actv_y_pos;		// From U_PAT_GEN_EXT of pat_gen_ext.v
wire			ext_cal_trig;		// From U_PAT_GEN_EXT of pat_gen_ext.v
wire [3:0]		ext_scrl_mode;		// From U_PAT_GEN_EXT of pat_gen_ext.v
wire			ext_work;		// From U_PAT_GEN_EXT of pat_gen_ext.v
wire			ext_work_trig;		// From U_PAT_GEN_EXT of pat_gen_ext.v
wire [1:0]		ext_x_zone;		// From U_PAT_GEN_EXT of pat_gen_ext.v
wire [1:0]		ext_y_zone;		// From U_PAT_GEN_EXT of pat_gen_ext.v
wire [WD_SIZE-1:0]	int_actv_x_pos;		// From U_PAT_GEN_INT of pat_gen_int.v
wire [HT_SIZE-1:0]	int_actv_y_pos;		// From U_PAT_GEN_INT of pat_gen_int.v
wire			int_cal_trig;		// From U_PAT_GEN_INT of pat_gen_int.v
wire [3:0]		int_scrl_mode;		// From U_PAT_GEN_INT of pat_gen_int.v
wire			int_work;		// From U_PAT_GEN_INT of pat_gen_int.v
wire			int_work_trig;		// From U_PAT_GEN_INT of pat_gen_int.v
wire [1:0]		int_x_zone;		// From U_PAT_GEN_INT of pat_gen_int.v
wire [1:0]		int_y_zone;		// From U_PAT_GEN_INT of pat_gen_int.v
wire [HT_SIZE-1:0]	pat_gen_actv_ht;	// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire [WD_SIZE-1:0]	pat_gen_actv_wd;	// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire [7:0]		pat_gen_frms_per_pat;	// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire [7:0]		pat_gen_hbp_wd;		// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire [7:0]		pat_gen_hs_wd;		// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire [3:0]		pat_gen_slt_num;	// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire [3:0]		pat_gen_slt_pat_num [15:0];// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire [HT_SIZE-1:0]	pat_gen_tot_ht;		// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire [WD_SIZE-1:0]	pat_gen_tot_wd;		// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire [7:0]		pat_gen_vbp_wd;		// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire [7:0]		pat_gen_vs_wd;		// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire [DIV_M+DIV_R-DIV_S-1:0] quotient_0;	// From U_DIV_0 of ser_div.v
wire [DIV_M+DIV_R-DIV_S-1:0] quotient_1;	// From U_DIV_1 of ser_div.v
wire [DIV_M+DIV_R-DIV_S-1:0] quotient_2;	// From U_DIV_2 of ser_div.v
wire			sync_pat_gen_auto_scrl_en;// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire			sync_pat_gen_en;	// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire			sync_pat_gen_en_ack;	// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
wire			sync_pat_gen_int_tmg;	// From U_PAT_GEN_CTRL of pat_gen_ctrl.v
// End of automatics

/*
ser_div AUTO_TEMPLATE (
	.divisor (divisor_@[]),
	.div_done ({div_done_@}),
	.quotient (quotient_@[]),
);

*/

pat_gen_ctrl #(/*AUTOINSTPARAM*/
	       // Parameters
	       .DSIZE			(DSIZE),
	       .WD_SIZE			(WD_SIZE),
	       .HT_SIZE			(HT_SIZE),
	       .Q_SIZE			(Q_SIZE)) U_PAT_GEN_CTRL(/*AUTOINST*/
								 // Outputs
								 .pat_gen_data		(pat_gen_data[DSIZE-1:0]),
								 .pat_gen_data_vld	(pat_gen_data_vld),
								 .cal_trig		(cal_trig),
								 .divisor_0		(divisor_0[WD_SIZE-1:0]),
								 .divisor_1		(divisor_1[HT_SIZE-1:0]),
								 .divisor_2		(divisor_2[WD_SIZE-1:0]),
								 .sync_pat_gen_en	(sync_pat_gen_en),
								 .sync_pat_gen_en_ack	(sync_pat_gen_en_ack),
								 .sync_pat_gen_int_tmg	(sync_pat_gen_int_tmg),
								 .sync_pat_gen_auto_scrl_en(sync_pat_gen_auto_scrl_en),
								 .pat_gen_tot_wd	(pat_gen_tot_wd[WD_SIZE-1:0]),
								 .pat_gen_tot_ht	(pat_gen_tot_ht[HT_SIZE-1:0]),
								 .pat_gen_actv_wd	(pat_gen_actv_wd[WD_SIZE-1:0]),
								 .pat_gen_actv_ht	(pat_gen_actv_ht[HT_SIZE-1:0]),
								 .pat_gen_hs_wd		(pat_gen_hs_wd[7:0]),
								 .pat_gen_vs_wd		(pat_gen_vs_wd[7:0]),
								 .pat_gen_hbp_wd	(pat_gen_hbp_wd[7:0]),
								 .pat_gen_vbp_wd	(pat_gen_vbp_wd[7:0]),
								 .pat_gen_frms_per_pat	(pat_gen_frms_per_pat[7:0]),
								 .pat_gen_slt_num	(pat_gen_slt_num[3:0]),
								 .pat_gen_slt_pat_num	(pat_gen_slt_pat_num/*[3:0].[15:0]*/),
								 // Inputs
								 .clk			(clk),
								 .rst_n			(rst_n),
								 .hs_pol		(hs_pol),
								 .vs_pol		(vs_pol),
								 .fnl_de_pol		(fnl_de_pol),
								 .fnl_de_en		(fnl_de_en),
								 .actv_wd		(actv_wd[WD_SIZE-1:0]),
								 .actv_ht		(actv_ht[HT_SIZE-1:0]),
								 .lvds_data		(lvds_data[DSIZE-1:0]),
								 .ext_x_zone		(ext_x_zone[1:0]),
								 .ext_y_zone		(ext_y_zone[1:0]),
								 .ext_actv_x_pos	(ext_actv_x_pos[WD_SIZE-1:0]),
								 .ext_actv_y_pos	(ext_actv_y_pos[HT_SIZE-1:0]),
								 .ext_scrl_mode		(ext_scrl_mode[3:0]),
								 .ext_cal_trig		(ext_cal_trig),
								 .ext_work_trig		(ext_work_trig),
								 .ext_work		(ext_work),
								 .int_x_zone		(int_x_zone[1:0]),
								 .int_y_zone		(int_y_zone[1:0]),
								 .int_actv_x_pos	(int_actv_x_pos[WD_SIZE-1:0]),
								 .int_actv_y_pos	(int_actv_y_pos[HT_SIZE-1:0]),
								 .int_scrl_mode		(int_scrl_mode[3:0]),
								 .int_cal_trig		(int_cal_trig),
								 .int_work_trig		(int_work_trig),
								 .int_work		(int_work),
								 .quotient_0		(quotient_0[Q_SIZE-1:0]),
								 .quotient_1		(quotient_1[Q_SIZE-1:0]),
								 .quotient_2		(quotient_2[Q_SIZE-1:0]),
								 .sync_en		(sync_en),
								 .bist_en		(bist_en),
								 .pat_gen_en		(pat_gen_en),
								 .map_sel		(map_sel),
								 .pat_gen_mode		(pat_gen_mode[3:0]),
								 .pat_gen_col_bar_en	(pat_gen_col_bar_en),
								 .pat_gen_rvs_vcom_en	(pat_gen_rvs_vcom_en),
								 .pat_gen_chkbd_sc	(pat_gen_chkbd_sc),
								 .pat_gen_cus_col_en	(pat_gen_cus_col_en),
								 .pat_gen_18bit		(pat_gen_18bit),
								 .pat_gen_ext_clk_src	(pat_gen_ext_clk_src),
								 .pat_gen_int_tmg	(pat_gen_int_tmg),
								 .pat_gen_rvs_col_en	(pat_gen_rvs_col_en),
								 .pat_gen_auto_scrl_en	(pat_gen_auto_scrl_en),
								 .int_reg_data		(int_reg_data/*[7:0].[24:0]*/));
pat_gen_ext  #(/*AUTOINSTPARAM*/
	       // Parameters
	       .WD_SIZE			(WD_SIZE),
	       .HT_SIZE			(HT_SIZE)) U_PAT_GEN_EXT(/*AUTOINST*/
								 // Outputs
								 .ext_x_zone		(ext_x_zone[1:0]),
								 .ext_y_zone		(ext_y_zone[1:0]),
								 .ext_actv_x_pos	(ext_actv_x_pos[WD_SIZE-1:0]),
								 .ext_actv_y_pos	(ext_actv_y_pos[HT_SIZE-1:0]),
								 .ext_cal_trig		(ext_cal_trig),
								 .ext_work_trig		(ext_work_trig),
								 .ext_work		(ext_work),
								 .ext_scrl_mode		(ext_scrl_mode[3:0]),
								 // Inputs
								 .clk			(clk),
								 .rst_n			(rst_n),
								 .det_vld		(det_vld),
								 .hs_pol		(hs_pol),
								 .hs_en			(hs_en),
								 .vs_pol		(vs_pol),
								 .vs_en			(vs_en),
								 .fnl_de_pol		(fnl_de_pol),
								 .fnl_de_en		(fnl_de_en),
								 .actv_wd		(actv_wd[WD_SIZE-1:0]),
								 .actv_ht		(actv_ht[HT_SIZE-1:0]),
								 .hs_actv_trig		(hs_actv_trig),
								 .vs_actv_trig		(vs_actv_trig),
								 .de_actv_trig		(de_actv_trig),
								 .de_idle_trig		(de_idle_trig),
								 .pseudo_vs_actv_trig	(pseudo_vs_actv_trig),
								 .sync_pat_gen_en	(sync_pat_gen_en),
								 .sync_pat_gen_en_ack	(sync_pat_gen_en_ack),
								 .sync_pat_gen_int_tmg	(sync_pat_gen_int_tmg),
								 .sync_pat_gen_auto_scrl_en(sync_pat_gen_auto_scrl_en),
								 .pat_gen_frms_per_pat	(pat_gen_frms_per_pat[7:0]),
								 .pat_gen_slt_num	(pat_gen_slt_num[3:0]),
								 .pat_gen_slt_pat_num	(pat_gen_slt_pat_num/*[3:0].[15:0]*/));
pat_gen_int  #(/*AUTOINSTPARAM*/
	       // Parameters
	       .HT_SIZE			(HT_SIZE),
	       .WD_SIZE			(WD_SIZE)) U_PAT_GEN_INT(/*AUTOINST*/
								 // Outputs
								 .int_x_zone		(int_x_zone[1:0]),
								 .int_y_zone		(int_y_zone[1:0]),
								 .int_actv_x_pos	(int_actv_x_pos[WD_SIZE-1:0]),
								 .int_actv_y_pos	(int_actv_y_pos[HT_SIZE-1:0]),
								 .int_cal_trig		(int_cal_trig),
								 .int_work_trig		(int_work_trig),
								 .int_work		(int_work),
								 .int_scrl_mode		(int_scrl_mode[3:0]),
								 // Inputs
								 .clk			(clk),
								 .rst_n			(rst_n),
								 .sync_pat_gen_en	(sync_pat_gen_en),
								 .sync_pat_gen_en_ack	(sync_pat_gen_en_ack),
								 .sync_pat_gen_int_tmg	(sync_pat_gen_int_tmg),
								 .sync_pat_gen_auto_scrl_en(sync_pat_gen_auto_scrl_en),
								 .pat_gen_tot_wd	(pat_gen_tot_wd[WD_SIZE-1:0]),
								 .pat_gen_tot_ht	(pat_gen_tot_ht[HT_SIZE-1:0]),
								 .pat_gen_actv_wd	(pat_gen_actv_wd[WD_SIZE-1:0]),
								 .pat_gen_actv_ht	(pat_gen_actv_ht[HT_SIZE-1:0]),
								 .pat_gen_hs_wd		(pat_gen_hs_wd[7:0]),
								 .pat_gen_vs_wd		(pat_gen_vs_wd[7:0]),
								 .pat_gen_hbp_wd	(pat_gen_hbp_wd[7:0]),
								 .pat_gen_vbp_wd	(pat_gen_vbp_wd[7:0]),
								 .pat_gen_frms_per_pat	(pat_gen_frms_per_pat[7:0]),
								 .pat_gen_slt_num	(pat_gen_slt_num[3:0]),
								 .pat_gen_slt_pat_num	(pat_gen_slt_pat_num/*[3:0].[15:0]*/));
ser_div      #(/*AUTOINSTPARAM*/
	       // Parameters
	       .DIV_M			(DIV_M),
	       .DIV_N			(DIV_N),
	       .DIV_R			(DIV_R),
	       .DIV_S			(DIV_S),
	       .DIV_C			(DIV_C)) U_DIV_0(
							.dividend (16'hFF00),
						/*AUTOINST*/
							 // Outputs
							 .quotient		(quotient_0[DIV_M+DIV_R-DIV_S-1:0]), // Templated
							 .div_done		({div_done_0}),	 // Templated
							 // Inputs
							 .clk			(clk),
							 .rst_n			(rst_n),
							 .cal_trig		(cal_trig),
							 .divisor		(divisor_0[DIV_N-1:0])); // Templated
ser_div      #(/*AUTOINSTPARAM*/
	       // Parameters
	       .DIV_M			(DIV_M),
	       .DIV_N			(DIV_N),
	       .DIV_R			(DIV_R),
	       .DIV_S			(DIV_S),
	       .DIV_C			(DIV_C)) U_DIV_1(
							.dividend (16'hFF00),
						/*AUTOINST*/
							 // Outputs
							 .quotient		(quotient_1[DIV_M+DIV_R-DIV_S-1:0]), // Templated
							 .div_done		({div_done_1}),	 // Templated
							 // Inputs
							 .clk			(clk),
							 .rst_n			(rst_n),
							 .cal_trig		(cal_trig),
							 .divisor		(divisor_1[DIV_N-1:0])); // Templated
// for colorbar
ser_div      #(/*AUTOINSTPARAM*/
	       // Parameters
	       .DIV_M			(DIV_M),
	       .DIV_N			(DIV_N),
	       .DIV_R			(DIV_R),
	       .DIV_S			(DIV_S),
	       .DIV_C			(DIV_C)) U_DIV_2(
							.dividend (16'h7000),
						/*AUTOINST*/
							 // Outputs
							 .quotient		(quotient_2[DIV_M+DIV_R-DIV_S-1:0]), // Templated
							 .div_done		({div_done_2}),	 // Templated
							 // Inputs
							 .clk			(clk),
							 .rst_n			(rst_n),
							 .cal_trig		(cal_trig),
							 .divisor		(divisor_2[DIV_N-1:0])); // Templated

endmodule
