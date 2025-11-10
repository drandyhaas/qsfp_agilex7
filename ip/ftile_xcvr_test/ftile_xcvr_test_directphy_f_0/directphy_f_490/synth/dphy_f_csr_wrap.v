// (C) 2001-2024 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


//-----------------------------------------------------------------------------------------------//
//   dphy_f_csr_wrap                                   
//   convert parameters to register inputs, generate waitrequest     
//   synchronizers for signals from different clock domains
//-----------------------------------------------------------------------------------------------//


`timescale 1 ps/1 ps 
module dphy_f_csr_wrap # (
parameter enable_readdv = 0,
parameter [11:0] line_rate_p1ghz = 12'd250,
parameter [0:0] xcvr_type     = 1'b0,
parameter [0:0] modulation_type = 1'b0,
parameter [4:0] num_xcvr      = 5'h01,
parameter [4:0] num_aib       = 5'h01,
parameter [0:0] fec_enable    = 1'b0,
parameter [1:0] duplex_mode   = 2'b11
) (
// register offset : 0x08, field offset : 0, access : RW, dphy_reset.soft_tx_rst
output wire dphy_reset_soft_tx_rst,
// register offset : 0x08, field offset : 1, access : RW, dphy_reset.soft_rx_rst
output wire dphy_reset_soft_rx_rst,
// register offset : 0x08, field offset : 4, access : RW, dphy_reset.tx_rst_ovr
output wire dphy_reset_tx_rst_ovr,
// register offset : 0x08, field offset : 5, access : RW, dphy_reset.rx_rst_ovr
output wire dphy_reset_rx_rst_ovr,
// register offset : 0x0c, field offset : 0, access : RO, dphy_reset_status.tx_rst_ack_n
input   dphy_reset_status_tx_rst_ack_n_i,
// register offset : 0x0c, field offset : 1, access : RO, dphy_reset_status.rx_rst_ack_n
input   dphy_reset_status_rx_rst_ack_n_i,
// register offset : 0x0c, field offset : 4, access : RO, dphy_reset_status.tx_ready
input   dphy_reset_status_tx_ready_i,
// register offset : 0x0c, field offset : 5, access : RO, dphy_reset_status.rx_ready
input   dphy_reset_status_rx_ready_i,
// register offset : 0x0c, field offset : 7, access : RO, dphy_reset_status.avmm_ready
input   dphy_reset_status_avmm_ready_i,
// register offset : 0x10, field offset : 0, access : RO, phy_tx_pll_locked.tx_pll_locked
input  [num_xcvr-1:0] phy_tx_pll_locked_tx_pll_locked_i,
// register offset : 0x14, field offset : 0, access : RO, phy_rx_cdr_locked.rx_cdr_locked
input  [num_xcvr-1:0] phy_rx_cdr_locked_rx_cdr_locked_i,
// register offset : 0x14, field offset : 16,access : RO, phy_rx_cdr_locked.rx_cdr_locked2data
input  [num_xcvr-1:0] phy_rx_cdr_locked_rx_cdr_locked2data_i,
// register offset : 0x18, field offset : 0, access : RW, src_ctrl_rx_ignore_locked2data.rx_ignore_locked2data
output                src_ctrl_rx_ignore_locked2data,
//Bus Interface
input clk,
input reset,
input [31:0] writedata,
input read,
input write,
input [3:0] byteenable,
output wire [31:0] readdata,
output wire readdatavalid,
output wire waitrequest,
input [11:0] address,
output 						                reset_swcwbin,
input  [31:0] 							cwbin0_stat_block_A_i,
input  [31:0] 							cwbin1_stat_block_A_i,
input  [31:0] 							cwbin2_stat_block_A_i,
input  [31:0] 							cwbin3_stat_block_A_i,
input  [31:0] 							cwbin0_stat_block_B_i,
input  [31:0] 							cwbin1_stat_block_B_i,
input  [31:0] 							cwbin2_stat_block_B_i,
input  [31:0] 							cwbin3_stat_block_B_i,
output [31:0] 						        cwbin_timer_timeout

);

wire       reset_sync;

wire rx_rst_ack_n_sync;
wire rx_ready_sync;
wire [15:0] rx_cdr_locked_sync;
wire [15:0] rx_cdr_locked2data_sync;

wire tx_rst_ack_n_sync;
wire tx_ready_sync;
wire [15:0] tx_pll_locked_sync;

assign waitrequest = ~ ( write | ((enable_readdv)? readdatavalid : readdatavalid) );


dphy_f_sip_csr     dphy_f_soft_csr_inst (

    .gui_option_line_rate_p1ghz_i                               (line_rate_p1ghz),
    .gui_option_xcvr_type_i                                     (xcvr_type),
    .gui_option_modulation_type_i                               (modulation_type),
    .gui_option_num_xcvr_i                                      (num_xcvr),
    .gui_option_fec_enable_i                                    (fec_enable),
    .gui_option_num_aib_i                                       (num_aib),
    .gui_option_duplex_mode_i                                   (duplex_mode),
    .dphy_reset_soft_tx_rst                                     (dphy_reset_soft_tx_rst),
    .dphy_reset_soft_rx_rst                                     (dphy_reset_soft_rx_rst),
    .dphy_reset_tx_rst_ovr                                      (dphy_reset_tx_rst_ovr),
    .dphy_reset_rx_rst_ovr                                      (dphy_reset_rx_rst_ovr),
    .dphy_reset_status_tx_rst_ack_n_i                           (tx_rst_ack_n_sync),
    .dphy_reset_status_rx_rst_ack_n_i                           (rx_rst_ack_n_sync),
    .dphy_reset_status_tx_ready_i                               (tx_ready_sync),
    .dphy_reset_status_rx_ready_i                               (rx_ready_sync),
    .dphy_reset_status_avmm_ready_i                             (dphy_reset_status_avmm_ready_i),
    .phy_tx_pll_locked_tx_pll_locked_i                          (tx_pll_locked_sync),
    .phy_rx_cdr_locked_rx_cdr_locked_i                          (rx_cdr_locked_sync),
    .phy_rx_cdr_locked_rx_cdr_locked2data_i                     (rx_cdr_locked2data_sync),
    .src_ctrl_rx_ignore_locked2data                             (src_ctrl_rx_ignore_locked2data),
    .clk                                                        (clk),
    .reset                                                      (reset_sync),
    .writedata                                                  (writedata),
    .read                                                       (read),
    .write                                                      (write),
    .byteenable                                                 (byteenable),
    .readdata                                                   (readdata),
    .readdatavalid                                              (readdatavalid),
    .address                                                    (address),
	.cwbin_control_register_cwbin_control_register					 (reset_swcwbin),
	.cwbin0_A_cwbin0_A_i					  (cwbin0_stat_block_A_i),
	.cwbin1_A_cwbin1_A_i					  (cwbin1_stat_block_A_i),
	.cwbin2_A_cwbin2_A_i					  (cwbin2_stat_block_A_i),
	.cwbin3_A_cwbin3_A_i					  (cwbin3_stat_block_A_i),
	.cwbin0_B_cwbin0_B_i					  (cwbin0_stat_block_B_i),
	.cwbin1_B_cwbin1_B_i					  (cwbin1_stat_block_B_i),
	.cwbin2_B_cwbin2_B_i					  (cwbin2_stat_block_B_i),
	.cwbin3_B_cwbin3_B_i					  (cwbin3_stat_block_B_i),
    .cwbin_timer_cwbin_timer				  (cwbin_timer_timeout)
);

    alt_xcvr_resync_etile #(
        .SYNC_CHAIN_LENGTH (2),
        .WIDTH(1)
    )
      reset_sync_inst  (
        .clk   (clk),
        .reset (1'b0),
        .d     ( reset ),
        .q     ( reset_sync )
      );    


generate if (duplex_mode[1]) begin: tx_enabled
    alt_xcvr_resync_etile #(
        .SYNC_CHAIN_LENGTH (2),
        .WIDTH(num_xcvr+2)
    )
      rst_txpll_xfr_sync_inst  (
        .clk   (clk),
        .reset (1'b0),
        .d     ( { phy_tx_pll_locked_tx_pll_locked_i, dphy_reset_status_tx_rst_ack_n_i, dphy_reset_status_tx_ready_i} ),
        .q     ( { tx_pll_locked_sync[0+:num_xcvr], tx_rst_ack_n_sync, tx_ready_sync} )
      );    
    if (num_xcvr<16) begin: fill_xcvr_tx_slot
        assign tx_pll_locked_sync[15:num_xcvr] = 'h0;
    end
end else begin: tx_disabled
    assign tx_rst_ack_n_sync = 1'b1;
    assign tx_ready_sync     = 1'b0;
    assign tx_pll_locked_sync = 16'h0;
end
endgenerate

generate if (duplex_mode[0]) begin: rx_enabled
    alt_xcvr_resync_etile #(
        .SYNC_CHAIN_LENGTH (2),
        .WIDTH(num_xcvr*2+2)
    )
      rst_rxpll_xfr_sync_inst  (
        .clk   (clk),
        .reset (1'b0),
        .d     ( { phy_rx_cdr_locked_rx_cdr_locked2data_i, phy_rx_cdr_locked_rx_cdr_locked_i, dphy_reset_status_rx_rst_ack_n_i, dphy_reset_status_rx_ready_i} ),
        .q     ( { rx_cdr_locked2data_sync[0+:num_xcvr], rx_cdr_locked_sync[0+:num_xcvr], rx_rst_ack_n_sync, rx_ready_sync} )
      );    
    if (num_xcvr<16) begin: fill_xcvr_rx_slot
        assign rx_cdr_locked_sync[15:num_xcvr] = 'h0;
        assign rx_cdr_locked2data_sync[15:num_xcvr] = 'h0;
    end
end else begin: rx_disabled
    assign rx_rst_ack_n_sync = 1'b1;
    assign rx_ready_sync     = 1'b0;
    assign rx_cdr_locked_sync = 16'h0;
    assign rx_cdr_locked2data_sync = 16'h0;
end
endgenerate



endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "GCmaWWfu8/z90U1Cmo5rPCMDlKlyM0GNy39hltItZu8hjp+ConPPnsllU0R3HQGDlHAZ73evWKdnQ3lDsZKXjvyxG/vMsJGlHhUjn18rLQtcWxIJVkzmz4DRGHUc79xjE5Ra6dXiFrovOM0nWa82j0WjiYv6AoXMP1ztF/irbbWTqsqUcTOLaKJT5ueWX0R9FbNv77cBFyzVTW5v/1dofdTWdWqd6lTx+9/Vzmh/0Y6yzvweAI481w6MKsTNh1F9m91S0fSyrCbZ11pl6qqgj9ax12vTBO7gSY+kFYvnBQVDcbASaW8WVcGoSaPzi3rV2EMbN7igGjLMIHT4OCVo7MIOm9BBu6XgMa7OWxQXtNy9KMWr3PMh617czTKS9dAVAlWEoqPVbz6JJjC5LTH5+bDmMzYWcplH99vuos6mPtIK6a4Zl/3uRAKAY0yHV+deV/XKYd/5DQMMZU5apUFrZK/PYUtMB+wn3d8sI3cXl5lXvO9aqYExaOOYvg7ZESpFknxIZaELVe4HR4aa+/CrVNbZa3DKqSCfzBdlg4GePR9xSU8RNQefpfUZ8RQFjKBiIk6jys2zOwP7unFP34UEUP0rXOgBIc6G/ILzSnCl6qKRg1xvTlgBQe576meYQrPzvrsZU4MVyJPENVvcNniF2LKMMhOkcuALI/UrZOhIwwQ72hY2eN1aZghwmqbtY/tnkmhlmbSyVlgGhoI4DzCHJram9AtylIvRsY58mx4LndVtn6Ktm8bbgCLJ3rJOIML7fXBO3cqoiszvuMHHtfHZeyX+qk+3/lXv0D/yVLBa3Q8LI9FW7ZHCcdYklAElF09owtJoZ9ov5UfrU2DQrxvBlGCOmyNtHRIFi6EowphqHbXHDUf3/wCCTtVX1GY5kveCSpD46agM44ZFB3CNHP2xEjTz9AM0a1UU1aFCfyrEy3SEKfyxd0o3C+nNV12si3EK9gCISOqWuAyTW/jNKDr/h5F/T6XrewL9Hqhg0Gz41/xrvL5kp/7aAjCFoWV39o+/"
`endif