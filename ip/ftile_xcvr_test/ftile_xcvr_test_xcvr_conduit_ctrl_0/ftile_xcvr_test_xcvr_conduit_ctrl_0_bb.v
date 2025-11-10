module ftile_xcvr_test_xcvr_conduit_ctrl_0 (
		input  wire        reset_n,            //              reset.reset_n
		input  wire        clk,                //              clock.clk
		input  wire [3:0]  csr_address,        //                csr.address
		input  wire        csr_read,           //                   .read
		input  wire        csr_write,          //                   .write
		output wire [31:0] csr_readdata,       //                   .readdata
		input  wire [31:0] csr_writedata,      //                   .writedata
		input  wire [0:0]  tx_pll_locked,      //      tx_pll_locked.tx_pll_locked
		input  wire [0:0]  rx_is_lockedtoref,  //  rx_is_lockedtoref.rx_is_lockedtoref
		input  wire [0:0]  rx_is_lockedtodata, // rx_is_lockedtodata.rx_is_lockedtodata
		output wire [0:0]  tx_reset,           //           tx_reset.tx_reset
		input  wire [0:0]  tx_reset_ack,       //       tx_reset_ack.tx_reset_ack
		input  wire [0:0]  tx_ready,           //           tx_ready.tx_ready
		output wire [0:0]  rx_reset,           //           rx_reset.rx_reset
		input  wire [0:0]  rx_reset_ack,       //       rx_reset_ack.rx_reset_ack
		input  wire [0:0]  rx_ready            //           rx_ready.rx_ready
	);
endmodule

