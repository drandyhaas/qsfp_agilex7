	ftile_xcvr_test_directphy_f_0 u0 (
		.rx_cdr_refclk_link        (_connected_to_rx_cdr_refclk_link_),        //   input,   width = 1,  rx_cdr_refclk_link.clk
		.tx_pll_refclk_link        (_connected_to_tx_pll_refclk_link_),        //   input,   width = 1,  tx_pll_refclk_link.clk
		.system_pll_clk_link       (_connected_to_system_pll_clk_link_),       //   input,   width = 1, system_pll_clk_link.clk
		.tx_reset                  (_connected_to_tx_reset_),                  //   input,   width = 1,            tx_reset.tx_reset
		.rx_reset                  (_connected_to_rx_reset_),                  //   input,   width = 1,            rx_reset.rx_reset
		.tx_reset_ack              (_connected_to_tx_reset_ack_),              //  output,   width = 1,        tx_reset_ack.tx_reset_ack
		.rx_reset_ack              (_connected_to_rx_reset_ack_),              //  output,   width = 1,        rx_reset_ack.rx_reset_ack
		.tx_ready                  (_connected_to_tx_ready_),                  //  output,   width = 1,            tx_ready.tx_ready
		.rx_ready                  (_connected_to_rx_ready_),                  //  output,   width = 1,            rx_ready.rx_ready
		.tx_coreclkin              (_connected_to_tx_coreclkin_),              //   input,   width = 1,        tx_coreclkin.clk
		.rx_coreclkin              (_connected_to_rx_coreclkin_),              //   input,   width = 1,        rx_coreclkin.clk
		.tx_clkout                 (_connected_to_tx_clkout_),                 //  output,   width = 1,           tx_clkout.clk
		.rx_clkout                 (_connected_to_rx_clkout_),                 //  output,   width = 1,           rx_clkout.clk
		.tx_serial_data            (_connected_to_tx_serial_data_),            //  output,   width = 1,      tx_serial_data.tx_serial_data
		.tx_serial_data_n          (_connected_to_tx_serial_data_n_),          //  output,   width = 1,    tx_serial_data_n.tx_serial_data_n
		.rx_serial_data            (_connected_to_rx_serial_data_),            //   input,   width = 1,      rx_serial_data.rx_serial_data
		.rx_serial_data_n          (_connected_to_rx_serial_data_n_),          //   input,   width = 1,    rx_serial_data_n.rx_serial_data_n
		.tx_pll_locked             (_connected_to_tx_pll_locked_),             //  output,   width = 1,       tx_pll_locked.tx_pll_locked
		.rx_is_lockedtodata        (_connected_to_rx_is_lockedtodata_),        //  output,   width = 1,  rx_is_lockedtodata.rx_is_lockedtodata
		.rx_is_lockedtoref         (_connected_to_rx_is_lockedtoref_),         //  output,   width = 1,   rx_is_lockedtoref.rx_is_lockedtoref
		.tx_parallel_data          (_connected_to_tx_parallel_data_),          //   input,  width = 80,    tx_parallel_data.tx_parallel_data
		.rx_parallel_data          (_connected_to_rx_parallel_data_),          //  output,  width = 80,    rx_parallel_data.rx_parallel_data
		.reconfig_xcvr_clk         (_connected_to_reconfig_xcvr_clk_),         //   input,   width = 1,   reconfig_xcvr_clk.clk
		.reconfig_xcvr_reset       (_connected_to_reconfig_xcvr_reset_),       //   input,   width = 1, reconfig_xcvr_reset.reset
		.reconfig_xcvr_write       (_connected_to_reconfig_xcvr_write_),       //   input,   width = 1,  reconfig_xcvr_avmm.write
		.reconfig_xcvr_read        (_connected_to_reconfig_xcvr_read_),        //   input,   width = 1,                    .read
		.reconfig_xcvr_address     (_connected_to_reconfig_xcvr_address_),     //   input,  width = 18,                    .address
		.reconfig_xcvr_byteenable  (_connected_to_reconfig_xcvr_byteenable_),  //   input,   width = 4,                    .byteenable
		.reconfig_xcvr_writedata   (_connected_to_reconfig_xcvr_writedata_),   //   input,  width = 32,                    .writedata
		.reconfig_xcvr_readdata    (_connected_to_reconfig_xcvr_readdata_),    //  output,  width = 32,                    .readdata
		.reconfig_xcvr_waitrequest (_connected_to_reconfig_xcvr_waitrequest_)  //  output,   width = 1,                    .waitrequest
	);

