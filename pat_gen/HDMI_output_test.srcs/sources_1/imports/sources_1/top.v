module top(
    input sys_clk,
    output [0:0]HDMI_OEN,
    output TMDS_clk_n,
    output TMDS_clk_p,
    output [2:0]TMDS_data_n,
    output [2:0]TMDS_data_p
);
wire video_clk;
wire video_clk_5x;

parameter DSIZE = 28; 
parameter WD_SIZE = 12; 
parameter HT_SIZE = 12; 
parameter MAX_RST_CNT = 8'd8;
parameter MAX_CNT = 8'd8;
wire pat_gen_clk;
wire det_vld;
wire hs_en;
wire vs_en;
wire fnl_de_en;
wire hs_pol;
wire vs_pol;
wire fnl_de_pol;
wire [WD_SIZE-1:0] actv_wd;
wire [HT_SIZE-1:0] actv_ht;
wire pseudo_vs;
wire pseudo_vs_actv_trig;
wire hs_actv_trig;
wire vs_actv_trig;
wire de_actv_trig;
wire [DSIZE-1:0] lvds_data;
wire sync_en;
wire bist_en;
wire map_sel;
wire [3:0] pat_gen_mode;
wire pat_gen_col_var_en;
wire pat_gen_rvs_vcom_en;
wire pat_gen_chkbd_sc;
wire pat_gen_cus_col_en;
wire pat_gen_18bit;
wire pat_gen_ext_clk_src;
wire pat_gen_int_tmg;
wire pat_gen_rvs_col_en;
wire pat_gen_auto_scrl_en;
wire [1:0] bist_clk_sr;
wire [DSIZE-1:0] pat_gen_data;
wire pat_gen_data_vld;
wire [1:0] bist_clk_src;
reg  pat_gen_rst_n;
reg [7:0] rst_cnt;
reg  pat_gen_en;
reg [7:0] cnt;
reg [7:0] int_reg_data[8'h18:0];
reg video_hs;
reg video_vs;
reg video_de;
reg [7:0] video_r;
reg [7:0] video_g;
reg [7:0] video_b;


assign HDMI_OEN = 1'b1;

pat_gen      #(/*AUTOINSTPARAM*/
	       // Parameters
	       .DSIZE			(DSIZE),
	       .WD_SIZE			(WD_SIZE),
	       .HT_SIZE			(HT_SIZE))  U_PAT_GEN(/*AUTOINST*/
							      // Outputs
							      .pat_gen_data	(pat_gen_data[DSIZE-1:0]),
							      .pat_gen_data_vld	(pat_gen_data_vld),
							      // Inputs
							      .clk		(pat_gen_clk),	 // Templated
							      .rst_n		(pat_gen_rst_n), // Templated
							      .det_vld		(det_vld),
							      .hs_en		(hs_en),
							      .vs_en		(vs_en),
							      .fnl_de_en	(fnl_de_en),
							      .hs_pol		(hs_pol),
							      .vs_pol		(vs_pol),
							      .fnl_de_pol	(fnl_de_pol),
							      .actv_wd		(actv_wd[WD_SIZE-1:0]),
							      .actv_ht		(actv_ht[HT_SIZE-1:0]),
							      .pseudo_vs	(pseudo_vs),
							      .pseudo_vs_actv_trig(pseudo_vs_actv_trig),
							      .hs_actv_trig	(hs_actv_trig),
							      .vs_actv_trig	(vs_actv_trig),
							      .de_actv_trig	(de_actv_trig),
							      .de_idle_trig	(de_idle_trig),
							      .lvds_data	(lvds_data[DSIZE-1:0]),
							      .sync_en		(sync_en),
							      .bist_en		(bist_en),
							      .pat_gen_en	(pat_gen_en),
							      .map_sel		(map_sel),
							      .pat_gen_mode	(pat_gen_mode[3:0]),
							      .pat_gen_col_bar_en(pat_gen_col_bar_en),
							      .pat_gen_rvs_vcom_en(pat_gen_rvs_vcom_en),
							      .pat_gen_chkbd_sc	(pat_gen_chkbd_sc),
							      .pat_gen_cus_col_en(pat_gen_cus_col_en),
							      .pat_gen_18bit	(pat_gen_18bit),
							      .pat_gen_ext_clk_src(pat_gen_ext_clk_src),
							      .pat_gen_int_tmg	(pat_gen_int_tmg),
							      .pat_gen_rvs_col_en(pat_gen_rvs_col_en),
							      .pat_gen_auto_scrl_en(pat_gen_auto_scrl_en),
							      .int_reg_data	(int_reg_data/*[7:0].[24:0]*/),
							      .bist_clk_src	(bist_clk_src[1:0]),
							      .pat_gen_int_clk_en(1'b0));	 // Templated

video_pll video_pll_m0
 (
 // Clock in ports
    .clk_in1(sys_clk),
  // Clock out ports
    .clk_out1(video_clk),
    .clk_out2(video_clk_5x),
  // Status and control signals
    .resetn(1'b1),
    .locked()
 );

rgb2dvi
#(
      .kGenerateSerialClk(1'b0),
      .kClkRange(1),     
      .kRstActiveHigh(1'b0)
)
rgb2dvi_m0 (
     // DVI 1.0 TMDS video interface
      .TMDS_Clk_p(TMDS_clk_p),
      .TMDS_Clk_n(TMDS_clk_n),
      .TMDS_Data_p(TMDS_data_p),
      .TMDS_Data_n(TMDS_data_n),
      
     //Auxiliary signals 
      .aRst(1'b0), //asynchronous reset; must be reset when RefClk is not within spec
      .aRst_n(1'b1), //-asynchronous reset; must be reset when RefClk is not within spec
      
      // Video in
      .vid_pData({video_r,video_b,video_g}),
      .vid_pVDE(video_de),
      .vid_pHSync(video_hs),
      .vid_pVSync(video_vs),
      .PixelClk(video_clk),
      
      .SerialClk(video_clk_5x)// 5x PixelClk
      ); 
 



///////////////////////////////
assign pat_gen_clk = video_clk;
assign det_vld = 1'b1;
assign hs_en = 1'b1;
assign vs_en = 1'b1;
assign fnl_de_en = 1'b1;
assign hs_pol = 1'b0;
assign vs_pol = 1'b0;
assign fnl_de_pol = 1'b0;
assign actv_wd = 'd0;
assign actv_ht = 'd0;
assign pseudo_vs = 'd0;
assign pseudo_vs_actv_trig = 'd0;
assign hs_actv_trig = 'd0;
assign vs_actv_trig = 'd0;
assign de_actv_trig = 'd0;
assign lvds_data = 'd0;
////////////////////////////////
assign sync_en = 1'b0;
assign bist_en = 1'b0;
assign map_sel = 1'b0;
assign pat_gen_mode = 'd0; //
assign pat_gen_col_bar_en = 1'b0; //1'b1;
assign pat_gen_rvs_vcom_en = 1'b0;
assign pat_gen_chkbd_sc = 1'b0;
assign pat_gen_cus_col_en = 1'b0;
assign pat_gen_18bit = 1'b0;
assign pat_gen_ext_clk_src = 1'b0;
assign pat_gen_int_tmg = 1'b1;
assign pat_gen_rvs_col_en = 1'b0;
assign pat_gen_auto_scrl_en = 1'b1; //1'b0
assign bist_clk_src = 'd0;

always @(posedge pat_gen_clk) begin
	if (pat_gen_rst_n == 1'b0) begin
		if (rst_cnt < MAX_RST_CNT)
			rst_cnt <= rst_cnt + 1'b1;
		else begin
			pat_gen_rst_n <= 1'b1;
		end
	end
end

always @(posedge pat_gen_clk or negedge pat_gen_rst_n) begin
	if (pat_gen_rst_n == 1'b0) begin
		pat_gen_en <= 1'b0;
		cnt <= 8'd0;
	end
	else begin		
		if (pat_gen_en == 1'b0) begin
			if (cnt < MAX_CNT)
				cnt <= cnt + 1'b1;
			else begin
				pat_gen_en <= 1'b1;
			end
		end
	end
end

always @(posedge pat_gen_clk or negedge pat_gen_rst_n) begin
	if (pat_gen_rst_n == 1'b0) begin
		int_reg_data[8'h0] <= 8'h0;
		int_reg_data[8'h1] <= 8'h0;
		int_reg_data[8'h2] <= 8'hff;
		int_reg_data[8'h3] <= 8'b0000_1000;
		int_reg_data[8'h4] <= 8'b0100_1000;
		int_reg_data[8'h5] <= 8'b0101_0011;
		int_reg_data[8'h6] <= 8'b0001_1110;
		int_reg_data[8'h7] <= 8'b0010_0000;
		int_reg_data[8'h8] <= 8'b0000_0011;
		int_reg_data[8'h9] <= 8'b0001_1110;
		int_reg_data[8'h0A] <= 8'b0000_1010;
		int_reg_data[8'h0B] <= 8'b0000_0010;
		int_reg_data[8'h0C] <= 8'b0000_1010;
		int_reg_data[8'h0D] <= 8'b0000_0010;
		int_reg_data[8'h0E] <= 8'b0000_0011;
		int_reg_data[8'h0F] <= 8'b0001_1110;
		int_reg_data[8'h10] <= 8'b0000_1110;
		int_reg_data[8'h11] <= 8'b0010_0001;
		int_reg_data[8'h12] <= 8'b0100_0011;
		int_reg_data[8'h13] <= 8'b0110_0101;
		int_reg_data[8'h14] <= 8'b1000_0111;
		int_reg_data[8'h15] <= 8'b1010_1001;
		int_reg_data[8'h16] <= 8'b1100_1011;
		int_reg_data[8'h17] <= 8'b1110_1101;
		int_reg_data[8'h18] <= 8'b0000_1111;
	end
end

always @(*) begin
	if (map_sel == 1'b0) begin
		video_r = {pat_gen_data[1], pat_gen_data[2], pat_gen_data[3], pat_gen_data[4], 
			pat_gen_data[5], pat_gen_data[6], pat_gen_data[26], pat_gen_data[27]};
		video_g = {pat_gen_data[9], pat_gen_data[10], pat_gen_data[11], pat_gen_data[12],
			pat_gen_data[13], pat_gen_data[0], pat_gen_data[24], pat_gen_data[25]};
		video_b = {pat_gen_data[17], pat_gen_data[18], pat_gen_data[19], pat_gen_data[20],
			pat_gen_data[7], pat_gen_data[8], pat_gen_data[22], pat_gen_data[23]};
		video_hs = pat_gen_data[16];
		video_vs = pat_gen_data[15];
		video_de = pat_gen_data[14];
	end
	else begin
		video_r = 'd0;
		video_g = 'd0;
		video_b = 'd0;
		video_hs = 'd0;
		video_vs = 'd0;
		video_de = 'd0;
	end
end
 
endmodule
