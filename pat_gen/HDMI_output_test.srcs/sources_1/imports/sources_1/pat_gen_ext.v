module pat_gen_ext(/*AUTOARG*/
   // Outputs
   ext_x_zone, ext_y_zone, ext_actv_x_pos, ext_actv_y_pos,
   ext_cal_trig, ext_work_trig, ext_work, ext_scrl_mode,
   // Inputs
   clk, rst_n, det_vld, hs_pol, hs_en, vs_pol, vs_en, fnl_de_pol,
   fnl_de_en, actv_wd, actv_ht, hs_actv_trig, vs_actv_trig,
   de_actv_trig, de_idle_trig, pseudo_vs_actv_trig, sync_pat_gen_en,
   sync_pat_gen_en_ack, sync_pat_gen_int_tmg,
   sync_pat_gen_auto_scrl_en, pat_gen_frms_per_pat, pat_gen_slt_num,
   pat_gen_slt_pat_num
   );

//PARAMETERS
parameter WD_SIZE = 12; 
parameter HT_SIZE = 12; 
// INPUTS
input                        clk;
input                        rst_n;
// from POL_DET
input                        det_vld;
input                        hs_pol;
input                        hs_en;
input                        vs_pol;
input                        vs_en;
input                        fnl_de_pol;
input                        fnl_de_en;
input  [WD_SIZE-1:0]         actv_wd;
input  [HT_SIZE-1:0]         actv_ht;
input                        hs_actv_trig;
input                        vs_actv_trig;
input                        de_actv_trig;
input                        de_idle_trig;
input                        pseudo_vs_actv_trig;
input                        sync_pat_gen_en;
input                        sync_pat_gen_en_ack;
input                        sync_pat_gen_int_tmg;
input                        sync_pat_gen_auto_scrl_en;
input  [7:0]                 pat_gen_frms_per_pat;
input  [3:0]                 pat_gen_slt_num;
input  [3:0]                 pat_gen_slt_pat_num[15:0];
// OUTPUTS
output [1:0]                 ext_x_zone;
output [1:0]                 ext_y_zone;
output [WD_SIZE-1:0]         ext_actv_x_pos;
output [HT_SIZE-1:0]         ext_actv_y_pos;
output                       ext_cal_trig;
output                       ext_work_trig;
output                       ext_work;
output [3:0]                 ext_scrl_mode;
// REGS

//--========================MODULE SOURCE CODE==========================--


endmodule
