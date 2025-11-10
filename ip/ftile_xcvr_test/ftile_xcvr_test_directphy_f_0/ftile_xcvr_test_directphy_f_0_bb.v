module ftile_xcvr_test_directphy_f_0 (
		input  wire        rx_cdr_refclk_link,        //  rx_cdr_refclk_link.clk,                This is neither a physical nor a logical pin. The connection made from "Reference and SystemPLL Clocks IP" to this pin will guide Quartus on properly setting clock network.
		input  wire        tx_pll_refclk_link,        //  tx_pll_refclk_link.clk,                This is neither a physical nor a logical pin. The connection made from "Reference and SystemPLL Clocks IP" to this pin will guide Quartus on properly setting clock network.
		input  wire [0:0]  system_pll_clk_link,       // system_pll_clk_link.clk,                This is virtual representation of System PLL output clock. This is neither physical nor logical pin. The connection made from "Reference and SystemPLL Clocks IP" to this pin will guide Quartus on properly setting clock network.
		input  wire [0:0]  tx_reset,                  //            tx_reset.tx_reset,           TX reset input for TX XCVRs and TX datapath. Must be kept asserted until tx_reset_ack is asserted.
		input  wire [0:0]  rx_reset,                  //            rx_reset.rx_reset,           RX reset input for RX XCVRs and RX datapath. Must be kept asserted until rx_reset_ack is asserted.
		output wire [0:0]  tx_reset_ack,              //        tx_reset_ack.tx_reset_ack,       TX fully in reset indicator.
		output wire [0:0]  rx_reset_ack,              //        rx_reset_ack.rx_reset_ack,       RX fully in reset indicator.
		output wire [0:0]  tx_ready,                  //            tx_ready.tx_ready,           Status port to indicate when TX XCVRs and TX datapath are reset successfully and ready for data transfer.
		output wire [0:0]  rx_ready,                  //            rx_ready.rx_ready,           RX de-skew NOT enabled: Status port to indicate when RX XCVRs and RX datapath are reset successfully and ready for data transfer. RX de-skew enabled: Status port to indicate when RX XCVRs and RX datapath are reset successfully, RX de-skew is done, and ready for data transfer.
		input  wire        tx_coreclkin,              //        tx_coreclkin.clk,                TX parallel clock input.
		input  wire        rx_coreclkin,              //        rx_coreclkin.clk,                RX parallel clock input.
		output wire        tx_clkout,                 //           tx_clkout.clk,                Clockout ports are driven by word, bond or system pll clocks depending on customer selection for the source.
		output wire        rx_clkout,                 //           rx_clkout.clk,                Clockout ports are driven by word, bond or system pll clocks depending on customer selection for the source.
		output wire [0:0]  tx_serial_data,            //      tx_serial_data.tx_serial_data,     TX serial data port.
		output wire [0:0]  tx_serial_data_n,          //    tx_serial_data_n.tx_serial_data_n,   Differential pair for TX serial data port. Historically was hidden; however now used in pam4 signal simulation model, hence needs to be connected by user.
		input  wire [0:0]  rx_serial_data,            //      rx_serial_data.rx_serial_data,     RX serial data port.
		input  wire [0:0]  rx_serial_data_n,          //    rx_serial_data_n.rx_serial_data_n,   Differential pair for RX serial data port. Historically was hidden; however now used in pam4 signal simulation model, hence needs to be connected by user.
		output wire [0:0]  tx_pll_locked,             //       tx_pll_locked.tx_pll_locked,      Locked to reference clock within the PPM threshold status signal for fast/medium or slow PLL. 1`b1 - locked. 1'b0 - not locked. Applicable to both FGT and FHT transceivers.
		output wire [0:0]  rx_is_lockedtodata,        //  rx_is_lockedtodata.rx_is_lockedtodata, RX CDR data lock status signal. 1`b0: CDR is not locked to data. 1`b1: CDR is locked to data. Applicable to both FGT and FHT transceivers
		output wire [0:0]  rx_is_lockedtoref,         //   rx_is_lockedtoref.rx_is_lockedtoref,  CDR lock status signal. 1`b1 - CDR is frequency locked to reference clock within the PPM threshold, 1`b0 - CDR is not frequency locked within the PPM threshold. Applicable to FGT transceivers only
		input  wire [79:0] tx_parallel_data,          //    tx_parallel_data.tx_parallel_data,   TX parallel data.
		output wire [79:0] rx_parallel_data,          //    rx_parallel_data.rx_parallel_data,   RX parallel data.
		input  wire [0:0]  reconfig_xcvr_clk,         //   reconfig_xcvr_clk.clk,                PMA reconfiguration interface clock.
		input  wire [0:0]  reconfig_xcvr_reset,       // reconfig_xcvr_reset.reset,              PMA reconfiguration interface reset.
		input  wire [0:0]  reconfig_xcvr_write,       //  reconfig_xcvr_avmm.write,              PMA reconfiguration interface write.
		input  wire [0:0]  reconfig_xcvr_read,        //                    .read,               PMA reconfiguration interface read.
		input  wire [17:0] reconfig_xcvr_address,     //                    .address,            PMA reconfiguration interface address. Upper address bits are for shared PMAs decoding if more than 1 PMA exist.
		input  wire [3:0]  reconfig_xcvr_byteenable,  //                    .byteenable,         PMA reconfiguration interface byte enable. If byteenable[3:0] is 4`b1111, 32-bit Dword Access is assumed; otherwise byte access will be used.
		input  wire [31:0] reconfig_xcvr_writedata,   //                    .writedata,          PMA reconfiguration interface write data.
		output wire [31:0] reconfig_xcvr_readdata,    //                    .readdata,           PMA reconfiguration interface read data.
		output wire [0:0]  reconfig_xcvr_waitrequest  //                    .waitrequest,        PMA reconfiguration interface wait request.
	);
endmodule

