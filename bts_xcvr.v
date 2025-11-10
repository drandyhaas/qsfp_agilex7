`timescale 1ns / 100ps

module  bts_xcvr (
        //Reset&Clock
        input  wire        cpu_1v2_resetn        , // Reset, low active
        input  wire        clk_sys_100m_p        , // System clock, 100MHz
        input  wire        refclk_fgt13Ach4_p    , // QSFPDD1 reference clock 156.25MHz from 
        input  wire        refclk_fgt13Ach2_p    , // QSFPDD2 reference clock 156.25MHz from 
		input  wire        refclk_fgt13Cch4_p    , // QSFPDD0 reference clock 156.25MHz from
		
		//SGPIO for dipsw, leds
        input  wire        fpga_sgpio_sync,
        input  wire        fpga_sgpio_clk ,
        input  wire        fpga_sgpi      ,    
        output wire        fpga_sgpo      ,
		output wire        si5395_1_1v2_a_oen        ,
		output wire        si5395_2_1v2_a_oen        ,       
	   //QSFPDD XCVR channels
        input  wire [3:0]  qsfp0_rx_p          , // QSFP #0 RX P
        input  wire [3:0]  qsfp0_rx_n          , // QSFP #0 RX N
        output wire [3:0]  qsfp0_tx_p          , // QSFP #0 TX P
        output wire [3:0]  qsfp0_tx_n          , // QSFP #0 TX N
        input  wire [3:0]  qsfp1_rx_p          , // QSFP #1 RX P
        input  wire [3:0]  qsfp1_rx_n          , // QSFP #1 RX N
        output wire [3:0]  qsfp1_tx_p          , // QSFP #1 TX P
        output wire [3:0]  qsfp1_tx_n          , // QSFP #1 TX N
        input  wire [3:0]  qsfp2_rx_p          , // QSFP #2 RX P
        input  wire [3:0]  qsfp2_rx_n          , // QSFP #2 RX N
        output wire [3:0]  qsfp2_tx_p          , // QSFP #2 TX P
        output wire [3:0]  qsfp2_tx_n            // QSFP #2 TX N
	);
//////////////////////

assign si5395_1_1v2_a_oen   = 1'b0;
assign si5395_2_1v2_a_oen   = 1'b0; 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Signal definitions
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
wire          ninit_done;
wire          global_resetn;
wire          clk_sys_100m;
wire          clk_sys_50m ;
wire[7:0]     fpga_led;
reg [26:0]    heart_beat_cnt;
	

//----------------------------------------------------------------------------------------------------------
// Intel Agilex Reset Release
//----------------------------------------------------------------------------------------------------------
reset_release reset_release_inst 
              (
              .ninit_done (ninit_done)  // ninit_done.ninit_done
              );

assign global_resetn = !ninit_done & cpu_1v2_resetn;

//---------------------------------------------------------------------------------------------------------


iopll iopll_u0 (
		.rst      (!cpu_1v2_resetn),      //   input,  width = 1, reset.reset
		.refclk   (clk_sys_100m_p),       //   input,  width = 1, refclk.clk
		.locked   (),                     //  output,  width = 1, locked.export
		.outclk_0 (clk_sys_100m) ,        //  output,  width = 1, outclk0.clk
		.outclk_1 (clk_sys_50m)           //  output,  width = 1, outclk1.clk
	);
	
	
always @(posedge clk_sys_50m or negedge global_resetn)
    if (!global_resetn)
        heart_beat_cnt <= 27'h0; //0x7ffffff
    else
        heart_beat_cnt <= heart_beat_cnt + 1'b1;
		
	
sgpio_slave sgpio_slave_inst(
    .i_rstn     (global_resetn ),
    .i_clk      (fpga_sgpio_clk  ),
    .i_sync     (fpga_sgpio_sync ),
    .i_mosi     (fpga_sgpi       ),
    .o_miso     (fpga_sgpo       ),
    .o_user_sw  (         ),
    .i_user_led (fpga_led        )
  );
  
assign fpga_led = {4'hf, heart_beat_cnt[26], heart_beat_cnt[26], heart_beat_cnt[26], heart_beat_cnt[26]};
	

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//XCVR system Qsys module
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
q_sys   q_sys_u0 (
        .clk_100_clk                                                       (clk_sys_100m         ), //  clk_100.clk
        .reset_100_reset_n                                                 (global_resetn        ), //  reset_100.reset_n
        .clk_50_clk                                                        (clk_sys_50m          ), //  clk_50.clk
        .reset_50_reset_n                                                  (global_resetn        ), //  reset_50.reset_n
        .systemclk_f_0_refclk_fgt_in_refclk_fgt_4                          (refclk_fgt13Cch4_p   ), //  systemclk_f_0_refclk_fgt.in_refclk_fgt_4
        .systemclk_f_1_refclk_fgt_in_refclk_fgt_4                          (refclk_fgt13Ach4_p   ), //  systemclk_f_0_refclk_fgt.in_refclk_fgt_4       
        .systemclk_f_2_refclk_fgt_in_refclk_fgt_4                          (refclk_fgt13Ach2_p   ), //  systemclk_f_0_refclk_fgt.in_refclk_fgt_4       
		.ftile_xcvr_test_0_directphy_f_0_tx_serial_data_tx_serial_data     (qsfp0_tx_p[0]      ),   
        .ftile_xcvr_test_0_directphy_f_0_tx_serial_data_n_tx_serial_data_n (qsfp0_tx_n[0]      ),  
        .ftile_xcvr_test_0_directphy_f_0_rx_serial_data_rx_serial_data     (qsfp0_rx_p[0]      ),  
        .ftile_xcvr_test_0_directphy_f_0_rx_serial_data_n_rx_serial_data_n (qsfp0_rx_n[0]      ),  
        .ftile_xcvr_test_1_directphy_f_0_tx_serial_data_tx_serial_data     (qsfp0_tx_p[1]      ),  
        .ftile_xcvr_test_1_directphy_f_0_tx_serial_data_n_tx_serial_data_n (qsfp0_tx_n[1]      ),  
        .ftile_xcvr_test_1_directphy_f_0_rx_serial_data_rx_serial_data     (qsfp0_rx_p[1]      ),  
        .ftile_xcvr_test_1_directphy_f_0_rx_serial_data_n_rx_serial_data_n (qsfp0_rx_n[1]      ),  
        .ftile_xcvr_test_2_directphy_f_0_tx_serial_data_tx_serial_data     (qsfp0_tx_p[2]      ), 
		.ftile_xcvr_test_2_directphy_f_0_tx_serial_data_n_tx_serial_data_n (qsfp0_tx_n[2]      ),
        .ftile_xcvr_test_2_directphy_f_0_rx_serial_data_rx_serial_data     (qsfp0_rx_p[2]      ),
        .ftile_xcvr_test_2_directphy_f_0_rx_serial_data_n_rx_serial_data_n (qsfp0_rx_n[2]      ),
        .ftile_xcvr_test_3_directphy_f_0_tx_serial_data_tx_serial_data     (qsfp0_tx_p[3]      ),
        .ftile_xcvr_test_3_directphy_f_0_tx_serial_data_n_tx_serial_data_n (qsfp0_tx_n[3]      ),
        .ftile_xcvr_test_3_directphy_f_0_rx_serial_data_rx_serial_data     (qsfp0_rx_p[3]      ),
        .ftile_xcvr_test_3_directphy_f_0_rx_serial_data_n_rx_serial_data_n (qsfp0_rx_n[3]      ),
        .ftile_xcvr_test_4_directphy_f_0_tx_serial_data_tx_serial_data     (qsfp1_tx_p[0]      ),
        .ftile_xcvr_test_4_directphy_f_0_tx_serial_data_n_tx_serial_data_n (qsfp1_tx_n[0]      ),
        .ftile_xcvr_test_4_directphy_f_0_rx_serial_data_rx_serial_data     (qsfp1_rx_p[0]      ),
        .ftile_xcvr_test_4_directphy_f_0_rx_serial_data_n_rx_serial_data_n (qsfp1_rx_n[0]      ),
        .ftile_xcvr_test_5_directphy_f_0_tx_serial_data_tx_serial_data     (qsfp1_tx_p[1]      ),
        .ftile_xcvr_test_5_directphy_f_0_tx_serial_data_n_tx_serial_data_n (qsfp1_tx_n[1]      ),
        .ftile_xcvr_test_5_directphy_f_0_rx_serial_data_rx_serial_data     (qsfp1_rx_p[1]      ),
        .ftile_xcvr_test_5_directphy_f_0_rx_serial_data_n_rx_serial_data_n (qsfp1_rx_n[1]      ),
        .ftile_xcvr_test_6_directphy_f_0_tx_serial_data_tx_serial_data     (qsfp1_tx_p[2]      ),
        .ftile_xcvr_test_6_directphy_f_0_tx_serial_data_n_tx_serial_data_n (qsfp1_tx_n[2]      ),
        .ftile_xcvr_test_6_directphy_f_0_rx_serial_data_rx_serial_data     (qsfp1_rx_p[2]      ),
        .ftile_xcvr_test_6_directphy_f_0_rx_serial_data_n_rx_serial_data_n (qsfp1_rx_n[2]      ),
        .ftile_xcvr_test_7_directphy_f_0_tx_serial_data_tx_serial_data     (qsfp1_tx_p[3]      ),
		.ftile_xcvr_test_7_directphy_f_0_tx_serial_data_n_tx_serial_data_n (qsfp1_tx_n[3]      ),
		.ftile_xcvr_test_7_directphy_f_0_rx_serial_data_rx_serial_data     (qsfp1_rx_p[3]      ),
		.ftile_xcvr_test_7_directphy_f_0_rx_serial_data_n_rx_serial_data_n (qsfp1_rx_n[3]      ),
		.ftile_xcvr_test_8_directphy_f_0_tx_serial_data_tx_serial_data     (qsfp2_tx_p[0]      ),
		.ftile_xcvr_test_8_directphy_f_0_tx_serial_data_n_tx_serial_data_n (qsfp2_tx_n[0]      ),
		.ftile_xcvr_test_8_directphy_f_0_rx_serial_data_rx_serial_data     (qsfp2_rx_p[0]      ),
		.ftile_xcvr_test_8_directphy_f_0_rx_serial_data_n_rx_serial_data_n (qsfp2_rx_n[0]      ),
		.ftile_xcvr_test_9_directphy_f_0_tx_serial_data_tx_serial_data     (qsfp2_tx_p[1]      ),
		.ftile_xcvr_test_9_directphy_f_0_tx_serial_data_n_tx_serial_data_n (qsfp2_tx_n[1]      ),
		.ftile_xcvr_test_9_directphy_f_0_rx_serial_data_rx_serial_data     (qsfp2_rx_p[1]      ),
		.ftile_xcvr_test_9_directphy_f_0_rx_serial_data_n_rx_serial_data_n (qsfp2_rx_n[1]      ),
		.ftile_xcvr_test_10_directphy_f_0_tx_serial_data_tx_serial_data    (qsfp2_tx_p[2]      ),
		.ftile_xcvr_test_10_directphy_f_0_tx_serial_data_n_tx_serial_data_n(qsfp2_tx_n[2]      ),
		.ftile_xcvr_test_10_directphy_f_0_rx_serial_data_rx_serial_data    (qsfp2_rx_p[2]      ),
		.ftile_xcvr_test_10_directphy_f_0_rx_serial_data_n_rx_serial_data_n(qsfp2_rx_n[2]      ),
		.ftile_xcvr_test_11_directphy_f_0_tx_serial_data_tx_serial_data    (qsfp2_tx_p[3]      ),
		.ftile_xcvr_test_11_directphy_f_0_tx_serial_data_n_tx_serial_data_n(qsfp2_tx_n[3]      ),
		.ftile_xcvr_test_11_directphy_f_0_rx_serial_data_rx_serial_data    (qsfp2_rx_p[3]      ),
		.ftile_xcvr_test_11_directphy_f_0_rx_serial_data_n_rx_serial_data_n(qsfp2_rx_n[3]      )
//		.ftile_xcvr_test_12_directphy_f_0_tx_serial_data_tx_serial_data    (qsfpdd1_tx_p[4]      ),
//		.ftile_xcvr_test_12_directphy_f_0_tx_serial_data_n_tx_serial_data_n(qsfpdd1_tx_n[4]      ),
//		.ftile_xcvr_test_12_directphy_f_0_rx_serial_data_rx_serial_data    (qsfpdd1_rx_p[4]      ),
//		.ftile_xcvr_test_12_directphy_f_0_rx_serial_data_n_rx_serial_data_n(qsfpdd1_rx_n[4]      ),
//		.ftile_xcvr_test_13_directphy_f_0_tx_serial_data_tx_serial_data    (qsfpdd1_tx_p[5]      ),
//		.ftile_xcvr_test_13_directphy_f_0_tx_serial_data_n_tx_serial_data_n(qsfpdd1_tx_n[5]      ),
//		.ftile_xcvr_test_13_directphy_f_0_rx_serial_data_rx_serial_data    (qsfpdd1_rx_p[5]      ),
//		.ftile_xcvr_test_13_directphy_f_0_rx_serial_data_n_rx_serial_data_n(qsfpdd1_rx_n[5]      ),
//		.ftile_xcvr_test_14_directphy_f_0_tx_serial_data_tx_serial_data    (qsfpdd1_tx_p[6]      ),
//		.ftile_xcvr_test_14_directphy_f_0_tx_serial_data_n_tx_serial_data_n(qsfpdd1_tx_n[6]      ),
//		.ftile_xcvr_test_14_directphy_f_0_rx_serial_data_rx_serial_data    (qsfpdd1_rx_p[6]      ),
//		.ftile_xcvr_test_14_directphy_f_0_rx_serial_data_n_rx_serial_data_n(qsfpdd1_rx_n[6]      ),
//		.ftile_xcvr_test_15_directphy_f_0_tx_serial_data_tx_serial_data    (qsfpdd1_tx_p[7]      ),
//		.ftile_xcvr_test_15_directphy_f_0_tx_serial_data_n_tx_serial_data_n(qsfpdd1_tx_n[7]      ),
//		.ftile_xcvr_test_15_directphy_f_0_rx_serial_data_rx_serial_data    (qsfpdd1_rx_p[7]      ),
//		.ftile_xcvr_test_15_directphy_f_0_rx_serial_data_n_rx_serial_data_n(qsfpdd1_rx_n[7]      )
		 );                                                                   

endmodule
