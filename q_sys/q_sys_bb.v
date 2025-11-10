module q_sys (
		input  wire       clk_100_clk,                                                        //                                           clk_100.clk
		input  wire       reset_100_reset_n,                                                  //                                         reset_100.reset_n
		input  wire       clk_50_clk,                                                         //                                            clk_50.clk
		input  wire       reset_50_reset_n,                                                   //                                          reset_50.reset_n
		input  wire       systemclk_f_0_refclk_fgt_in_refclk_fgt_4,                           //                          systemclk_f_0_refclk_fgt.in_refclk_fgt_4
		input  wire       systemclk_f_1_refclk_fgt_in_refclk_fgt_4,                           //                          systemclk_f_1_refclk_fgt.in_refclk_fgt_4
		input  wire       systemclk_f_2_refclk_fgt_in_refclk_fgt_4,                           //                          systemclk_f_2_refclk_fgt.in_refclk_fgt_4
		output wire [0:0] ftile_xcvr_test_0_directphy_f_0_tx_serial_data_tx_serial_data,      //    ftile_xcvr_test_0_directphy_f_0_tx_serial_data.tx_serial_data
		output wire [0:0] ftile_xcvr_test_0_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  //  ftile_xcvr_test_0_directphy_f_0_tx_serial_data_n.tx_serial_data_n
		input  wire [0:0] ftile_xcvr_test_0_directphy_f_0_rx_serial_data_rx_serial_data,      //    ftile_xcvr_test_0_directphy_f_0_rx_serial_data.rx_serial_data
		input  wire [0:0] ftile_xcvr_test_0_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  //  ftile_xcvr_test_0_directphy_f_0_rx_serial_data_n.rx_serial_data_n
		output wire [0:0] ftile_xcvr_test_1_directphy_f_0_tx_serial_data_tx_serial_data,      //    ftile_xcvr_test_1_directphy_f_0_tx_serial_data.tx_serial_data
		output wire [0:0] ftile_xcvr_test_1_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  //  ftile_xcvr_test_1_directphy_f_0_tx_serial_data_n.tx_serial_data_n
		input  wire [0:0] ftile_xcvr_test_1_directphy_f_0_rx_serial_data_rx_serial_data,      //    ftile_xcvr_test_1_directphy_f_0_rx_serial_data.rx_serial_data
		input  wire [0:0] ftile_xcvr_test_1_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  //  ftile_xcvr_test_1_directphy_f_0_rx_serial_data_n.rx_serial_data_n
		output wire [0:0] ftile_xcvr_test_10_directphy_f_0_tx_serial_data_tx_serial_data,     //   ftile_xcvr_test_10_directphy_f_0_tx_serial_data.tx_serial_data
		output wire [0:0] ftile_xcvr_test_10_directphy_f_0_tx_serial_data_n_tx_serial_data_n, // ftile_xcvr_test_10_directphy_f_0_tx_serial_data_n.tx_serial_data_n
		input  wire [0:0] ftile_xcvr_test_10_directphy_f_0_rx_serial_data_rx_serial_data,     //   ftile_xcvr_test_10_directphy_f_0_rx_serial_data.rx_serial_data
		input  wire [0:0] ftile_xcvr_test_10_directphy_f_0_rx_serial_data_n_rx_serial_data_n, // ftile_xcvr_test_10_directphy_f_0_rx_serial_data_n.rx_serial_data_n
		output wire [0:0] ftile_xcvr_test_11_directphy_f_0_tx_serial_data_tx_serial_data,     //   ftile_xcvr_test_11_directphy_f_0_tx_serial_data.tx_serial_data
		output wire [0:0] ftile_xcvr_test_11_directphy_f_0_tx_serial_data_n_tx_serial_data_n, // ftile_xcvr_test_11_directphy_f_0_tx_serial_data_n.tx_serial_data_n
		input  wire [0:0] ftile_xcvr_test_11_directphy_f_0_rx_serial_data_rx_serial_data,     //   ftile_xcvr_test_11_directphy_f_0_rx_serial_data.rx_serial_data
		input  wire [0:0] ftile_xcvr_test_11_directphy_f_0_rx_serial_data_n_rx_serial_data_n, // ftile_xcvr_test_11_directphy_f_0_rx_serial_data_n.rx_serial_data_n
		output wire [0:0] ftile_xcvr_test_2_directphy_f_0_tx_serial_data_tx_serial_data,      //    ftile_xcvr_test_2_directphy_f_0_tx_serial_data.tx_serial_data
		output wire [0:0] ftile_xcvr_test_2_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  //  ftile_xcvr_test_2_directphy_f_0_tx_serial_data_n.tx_serial_data_n
		input  wire [0:0] ftile_xcvr_test_2_directphy_f_0_rx_serial_data_rx_serial_data,      //    ftile_xcvr_test_2_directphy_f_0_rx_serial_data.rx_serial_data
		input  wire [0:0] ftile_xcvr_test_2_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  //  ftile_xcvr_test_2_directphy_f_0_rx_serial_data_n.rx_serial_data_n
		output wire [0:0] ftile_xcvr_test_3_directphy_f_0_tx_serial_data_tx_serial_data,      //    ftile_xcvr_test_3_directphy_f_0_tx_serial_data.tx_serial_data
		output wire [0:0] ftile_xcvr_test_3_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  //  ftile_xcvr_test_3_directphy_f_0_tx_serial_data_n.tx_serial_data_n
		input  wire [0:0] ftile_xcvr_test_3_directphy_f_0_rx_serial_data_rx_serial_data,      //    ftile_xcvr_test_3_directphy_f_0_rx_serial_data.rx_serial_data
		input  wire [0:0] ftile_xcvr_test_3_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  //  ftile_xcvr_test_3_directphy_f_0_rx_serial_data_n.rx_serial_data_n
		output wire [0:0] ftile_xcvr_test_4_directphy_f_0_tx_serial_data_tx_serial_data,      //    ftile_xcvr_test_4_directphy_f_0_tx_serial_data.tx_serial_data
		output wire [0:0] ftile_xcvr_test_4_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  //  ftile_xcvr_test_4_directphy_f_0_tx_serial_data_n.tx_serial_data_n
		input  wire [0:0] ftile_xcvr_test_4_directphy_f_0_rx_serial_data_rx_serial_data,      //    ftile_xcvr_test_4_directphy_f_0_rx_serial_data.rx_serial_data
		input  wire [0:0] ftile_xcvr_test_4_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  //  ftile_xcvr_test_4_directphy_f_0_rx_serial_data_n.rx_serial_data_n
		output wire [0:0] ftile_xcvr_test_5_directphy_f_0_tx_serial_data_tx_serial_data,      //    ftile_xcvr_test_5_directphy_f_0_tx_serial_data.tx_serial_data
		output wire [0:0] ftile_xcvr_test_5_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  //  ftile_xcvr_test_5_directphy_f_0_tx_serial_data_n.tx_serial_data_n
		input  wire [0:0] ftile_xcvr_test_5_directphy_f_0_rx_serial_data_rx_serial_data,      //    ftile_xcvr_test_5_directphy_f_0_rx_serial_data.rx_serial_data
		input  wire [0:0] ftile_xcvr_test_5_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  //  ftile_xcvr_test_5_directphy_f_0_rx_serial_data_n.rx_serial_data_n
		output wire [0:0] ftile_xcvr_test_6_directphy_f_0_tx_serial_data_tx_serial_data,      //    ftile_xcvr_test_6_directphy_f_0_tx_serial_data.tx_serial_data
		output wire [0:0] ftile_xcvr_test_6_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  //  ftile_xcvr_test_6_directphy_f_0_tx_serial_data_n.tx_serial_data_n
		input  wire [0:0] ftile_xcvr_test_6_directphy_f_0_rx_serial_data_rx_serial_data,      //    ftile_xcvr_test_6_directphy_f_0_rx_serial_data.rx_serial_data
		input  wire [0:0] ftile_xcvr_test_6_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  //  ftile_xcvr_test_6_directphy_f_0_rx_serial_data_n.rx_serial_data_n
		output wire [0:0] ftile_xcvr_test_7_directphy_f_0_tx_serial_data_tx_serial_data,      //    ftile_xcvr_test_7_directphy_f_0_tx_serial_data.tx_serial_data
		output wire [0:0] ftile_xcvr_test_7_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  //  ftile_xcvr_test_7_directphy_f_0_tx_serial_data_n.tx_serial_data_n
		input  wire [0:0] ftile_xcvr_test_7_directphy_f_0_rx_serial_data_rx_serial_data,      //    ftile_xcvr_test_7_directphy_f_0_rx_serial_data.rx_serial_data
		input  wire [0:0] ftile_xcvr_test_7_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  //  ftile_xcvr_test_7_directphy_f_0_rx_serial_data_n.rx_serial_data_n
		output wire [0:0] ftile_xcvr_test_8_directphy_f_0_tx_serial_data_tx_serial_data,      //    ftile_xcvr_test_8_directphy_f_0_tx_serial_data.tx_serial_data
		output wire [0:0] ftile_xcvr_test_8_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  //  ftile_xcvr_test_8_directphy_f_0_tx_serial_data_n.tx_serial_data_n
		input  wire [0:0] ftile_xcvr_test_8_directphy_f_0_rx_serial_data_rx_serial_data,      //    ftile_xcvr_test_8_directphy_f_0_rx_serial_data.rx_serial_data
		input  wire [0:0] ftile_xcvr_test_8_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  //  ftile_xcvr_test_8_directphy_f_0_rx_serial_data_n.rx_serial_data_n
		output wire [0:0] ftile_xcvr_test_9_directphy_f_0_tx_serial_data_tx_serial_data,      //    ftile_xcvr_test_9_directphy_f_0_tx_serial_data.tx_serial_data
		output wire [0:0] ftile_xcvr_test_9_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  //  ftile_xcvr_test_9_directphy_f_0_tx_serial_data_n.tx_serial_data_n
		input  wire [0:0] ftile_xcvr_test_9_directphy_f_0_rx_serial_data_rx_serial_data,      //    ftile_xcvr_test_9_directphy_f_0_rx_serial_data.rx_serial_data
		input  wire [0:0] ftile_xcvr_test_9_directphy_f_0_rx_serial_data_n_rx_serial_data_n   //  ftile_xcvr_test_9_directphy_f_0_rx_serial_data_n.rx_serial_data_n
	);
endmodule

