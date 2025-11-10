module ftile_xcvr_test (
		input  wire        clk_100_clk,                                     //                           clk_100.clk
		input  wire        reset_100_reset_n,                               //                         reset_100.reset_n
		input  wire        clk_50_clk,                                      //                            clk_50.clk
		input  wire        reset_50_reset_n,                                //                          reset_50.reset_n
		input  wire        directphy_f_0_rx_cdr_refclk_link_clk,            //  directphy_f_0_rx_cdr_refclk_link.clk
		input  wire        directphy_f_0_tx_pll_refclk_link_clk,            //  directphy_f_0_tx_pll_refclk_link.clk
		input  wire [0:0]  directphy_f_0_system_pll_clk_link_clk,           // directphy_f_0_system_pll_clk_link.clk
		output wire [0:0]  directphy_f_0_tx_serial_data_tx_serial_data,     //      directphy_f_0_tx_serial_data.tx_serial_data
		output wire [0:0]  directphy_f_0_tx_serial_data_n_tx_serial_data_n, //    directphy_f_0_tx_serial_data_n.tx_serial_data_n
		input  wire [0:0]  directphy_f_0_rx_serial_data_rx_serial_data,     //      directphy_f_0_rx_serial_data.rx_serial_data
		input  wire [0:0]  directphy_f_0_rx_serial_data_n_rx_serial_data_n, //    directphy_f_0_rx_serial_data_n.rx_serial_data_n
		output wire        mm_bridge_0_s0_waitrequest,                      //                    mm_bridge_0_s0.waitrequest
		output wire [31:0] mm_bridge_0_s0_readdata,                         //                                  .readdata
		output wire        mm_bridge_0_s0_readdatavalid,                    //                                  .readdatavalid
		input  wire [0:0]  mm_bridge_0_s0_burstcount,                       //                                  .burstcount
		input  wire [31:0] mm_bridge_0_s0_writedata,                        //                                  .writedata
		input  wire [20:0] mm_bridge_0_s0_address,                          //                                  .address
		input  wire        mm_bridge_0_s0_write,                            //                                  .write
		input  wire        mm_bridge_0_s0_read,                             //                                  .read
		input  wire [3:0]  mm_bridge_0_s0_byteenable,                       //                                  .byteenable
		input  wire        mm_bridge_0_s0_debugaccess                       //                                  .debugaccess
	);
endmodule

