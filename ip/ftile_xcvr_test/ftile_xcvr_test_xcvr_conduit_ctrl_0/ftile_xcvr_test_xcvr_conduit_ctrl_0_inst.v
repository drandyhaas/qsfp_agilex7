	ftile_xcvr_test_xcvr_conduit_ctrl_0 u0 (
		.reset_n            (_connected_to_reset_n_),            //   input,   width = 1,              reset.reset_n
		.clk                (_connected_to_clk_),                //   input,   width = 1,              clock.clk
		.csr_address        (_connected_to_csr_address_),        //   input,   width = 4,                csr.address
		.csr_read           (_connected_to_csr_read_),           //   input,   width = 1,                   .read
		.csr_write          (_connected_to_csr_write_),          //   input,   width = 1,                   .write
		.csr_readdata       (_connected_to_csr_readdata_),       //  output,  width = 32,                   .readdata
		.csr_writedata      (_connected_to_csr_writedata_),      //   input,  width = 32,                   .writedata
		.tx_pll_locked      (_connected_to_tx_pll_locked_),      //   input,   width = 1,      tx_pll_locked.tx_pll_locked
		.rx_is_lockedtoref  (_connected_to_rx_is_lockedtoref_),  //   input,   width = 1,  rx_is_lockedtoref.rx_is_lockedtoref
		.rx_is_lockedtodata (_connected_to_rx_is_lockedtodata_), //   input,   width = 1, rx_is_lockedtodata.rx_is_lockedtodata
		.tx_reset           (_connected_to_tx_reset_),           //  output,   width = 1,           tx_reset.tx_reset
		.tx_reset_ack       (_connected_to_tx_reset_ack_),       //   input,   width = 1,       tx_reset_ack.tx_reset_ack
		.tx_ready           (_connected_to_tx_ready_),           //   input,   width = 1,           tx_ready.tx_ready
		.rx_reset           (_connected_to_rx_reset_),           //  output,   width = 1,           rx_reset.rx_reset
		.rx_reset_ack       (_connected_to_rx_reset_ack_),       //   input,   width = 1,       rx_reset_ack.rx_reset_ack
		.rx_ready           (_connected_to_rx_ready_)            //   input,   width = 1,           rx_ready.rx_ready
	);

