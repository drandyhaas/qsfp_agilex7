module xcvr_test_system (
		input  wire        clk_50_clk,                                              //                                           clk_50.clk
		input  wire        reset_50_reset_n,                                        //                                         reset_50.reset_n
		input  wire        data_pattern_checker_0_conduit_pattern_in_clk_export,    //    data_pattern_checker_0_conduit_pattern_in_clk.export
		input  wire [63:0] data_pattern_checker_0_conduit_pattern_in_export,        //        data_pattern_checker_0_conduit_pattern_in.export
		input  wire        data_pattern_generator_0_conduit_pattern_out_clk_export, // data_pattern_generator_0_conduit_pattern_out_clk.export
		output wire [63:0] data_pattern_generator_0_conduit_pattern_out_export,     //     data_pattern_generator_0_conduit_pattern_out.export
		output wire        mm_bridge_0_s0_waitrequest,                              //                                   mm_bridge_0_s0.waitrequest
		output wire [31:0] mm_bridge_0_s0_readdata,                                 //                                                 .readdata
		output wire        mm_bridge_0_s0_readdatavalid,                            //                                                 .readdatavalid
		input  wire [0:0]  mm_bridge_0_s0_burstcount,                               //                                                 .burstcount
		input  wire [31:0] mm_bridge_0_s0_writedata,                                //                                                 .writedata
		input  wire [12:0] mm_bridge_0_s0_address,                                  //                                                 .address
		input  wire        mm_bridge_0_s0_write,                                    //                                                 .write
		input  wire        mm_bridge_0_s0_read,                                     //                                                 .read
		input  wire [3:0]  mm_bridge_0_s0_byteenable,                               //                                                 .byteenable
		input  wire        mm_bridge_0_s0_debugaccess                               //                                                 .debugaccess
	);
endmodule

