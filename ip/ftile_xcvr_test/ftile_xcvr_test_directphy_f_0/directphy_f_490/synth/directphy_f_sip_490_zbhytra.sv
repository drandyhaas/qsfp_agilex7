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


`timescale 1 ns/1 ps 
(* altera_attribute = "-name UNCONNECTED_OUTPUT_PORT_MESSAGE_LEVEL OFF" *)
`ifndef __MB__
 `define __MB__ (* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *)
`endif

`ifndef __MC__
 `define __MC__ (* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="soft_reset_ctlr_link" *)
`endif
(* tile_ip_sip  *)
module directphy_f_sip_zbhytra #(
    parameter          num_sys_cop                                              = 1,
    parameter          num_xcvr_per_sys                                         = 1,
    parameter          num_fec_ch                                               = 1,
    parameter          l_num_aib_per_xcvr                                       = 1,
    parameter          l_sys_xcvrs                                              = 1,
    parameter          l_sys_aibs                                               = 1,
    parameter          l_tx_enable                                              = 1,
    parameter          l_rx_enable                                              = 1,
    parameter          tx_custom_cadence_enable                                 = 0,
    parameter          enable_port_tx_cadence_slow_clk_locked                   = 0,
    parameter          fec_on                                                   = 0,
    parameter          bb_f_ehip_xcvr_type                                      = "XCVR_TYPE_UX",
    parameter          bb_f_ehip_xcvr_mode                                      = "XCVR_MODE_NRZ",
	parameter          bb_f_ux_tx_tuning_hint                                   = "TX_TUNING_HINT_DISABLED",
    parameter          l_soft_csr_enable                                        = 0,
    parameter          l_line_rate_p1ghz                                        = 250,   
    parameter          avmm1_split                                              = 0,
    parameter          avmm1_jtag_enable                                        = 0,
    parameter          avmm1_readdv_enable                                      = 0,
    parameter          l_av1_enable                                             = 0,
    parameter          l_av1_aib_enable                                         = 0,
    parameter          l_num_avmm1                                              = 1,
    parameter          l_av1_ifaces                                             = 1,
    parameter          l_av1_addr_bits                                          = 14,
    parameter          avmm2_split                                              = 0,
    parameter          avmm2_jtag_enable                                        = 0,
    parameter          avmm2_readdv_enable                                      = 0,
    parameter          l_av2_enable                                             = 0,
    parameter          l_num_avmm2                                              = 1,
    parameter          l_av2_ifaces                                             = 1,
    parameter          l_av2_addr_bits                                          = 18,
    parameter          cwbin_timeout_count                                      = 1399, //14us timer, 1400 for 100MHZ reconfig clock, 3500 for 250MHz clock
    parameter          enable_soft_cwbin                                        = 0,
    parameter          bb_f_ehip_frac_size                                      = "F25G",
	parameter          enable_N_width_ready_signal                              = 0,   // Enable N width TX and RX ready channel
	parameter          ready_width                                              = 1   // TX and RX port width
    ) (
  // User interface for XCVR (FGT/FHT)
     input   wire   [num_xcvr_per_sys*num_sys_cop-1:0]   tx_enable_xcvr,         // Each channel or only 1 bit for ALL?

    output   wire   [num_xcvr_per_sys*num_sys_cop-1:0]   pll_locked_xcvr,
	//csr access
	input    wire   [l_sys_xcvrs-1:0]                    cpi_cmn_busy_real ,

  // User interface for UX/BK bb   
    output          [l_sys_xcvrs-1:0]   fgt_rx_signal_detect,    
    output          [l_sys_xcvrs-1:0]   fgt_rx_signal_detect_lfps,    
    output          [l_sys_xcvrs-1:0]   fht_rx_energy_detect,    
    output          [l_sys_xcvrs-1:0]   tx_pll_locked,                 
    output          [l_sys_xcvrs-1:0]   rx_is_lockedtodata,          
    output          [l_sys_xcvrs-1:0]   rx_is_lockedtoref,          
    input           [l_sys_xcvrs-1:0]   fgt_rx_set_locktoref,
    input           [l_sys_xcvrs-1:0]   fgt_rx_set_locktodata,
    input           [l_sys_xcvrs-1:0]   fgt_rx_cdr_freeze, 
    input           [l_sys_xcvrs-1:0]   fgt_tx_beacon,
    input           [l_sys_xcvrs-1:0]   fgt_rx_cdr_fast_freeze_sel, 
    input           [l_sys_xcvrs-1:0]   fgt_rx_cdr_set_locktoref,


  // User interface for FEC
    output   wire   [num_sys_cop-1:0] rsfec_status_rx_not_deskew,
    output   wire   [num_sys_cop-1:0] rsfec_status_rx_not_locked,
    output   wire   [num_sys_cop-1:0] rsfec_status_rx_not_align,
    output   wire   [num_sys_cop-1:0] rsfec_sf,
     input   wire   [ l_sys_aibs-1:0] fec_snapshot,

  // Custom Cadence 
     input          [num_sys_cop-1:0]   tx_cadence_fast_clk,
     input          [num_sys_cop-1:0]   tx_cadence_slow_clk,
     input          [num_sys_cop-1:0]   tx_cadence_slow_clk_locked,
     output         [num_sys_cop-1:0]   tx_cadence,

  // User interface for XCVR-IF
    output   wire   [l_sys_aibs-1:0]  xcvrif_rxfifo_empty,
    output   wire   [l_sys_aibs-1:0]  xcvrif_rxfifo_pempty,
    output   wire   [l_sys_aibs-1:0]  xcvrif_rxfifo_pfull,

    output   wire   [l_sys_aibs-1:0]  xcvrif_txfifo_empty,
    output   wire   [l_sys_aibs-1:0]  xcvrif_txfifo_pempty,
    output   wire   [l_sys_aibs-1:0]  xcvrif_txfifo_pfull,

    output   wire   [l_sys_aibs-1:0]  xcvrif_hold_interrupt,

  // Interface to ux bb
     input          [num_xcvr_per_sys*num_sys_cop-1:0]   oct_pcs_rxsignaldetect_lx_a,    
     input          [num_xcvr_per_sys*num_sys_cop-1:0]   octl_pcs_rxsignaldetect_lfps_lx_a, 
     input          [num_xcvr_per_sys*num_sys_cop-1:0]   oct_pcs_all_synthlockstatus,                 
     input          [num_xcvr_per_sys*num_sys_cop-1:0]   oct_pcs_rxcdrlock2data_lx_a,          
     input          [num_xcvr_per_sys*num_sys_cop-1:0]   oct_pcs_rxcdrlockstatus_lx_a,       
     input          [num_xcvr_per_sys*num_sys_cop-1:0]   octl_pcs_txstatus_lx_a,    
     input          [num_xcvr_per_sys*num_sys_cop-1:0]   octl_pcs_rxstatus_lx_a,           
    output          [num_xcvr_per_sys*num_sys_cop-1:0]   ictl_pcs_rxovrcdrlock2dataen_lx_a,  
    output          [num_xcvr_per_sys*num_sys_cop-1:0]   ictl_pcs_rxovrcdrlock2data_lx_a,
    output          [num_xcvr_per_sys*num_sys_cop-1:0]   ictl_pcs_txbeacon_lx_a,
    output          [num_xcvr_per_sys*num_sys_cop-1:0]   flux_top__iflux_ingress_direct__231,
    output          [num_xcvr_per_sys*num_sys_cop-1:0]   i_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t,
    output          [num_xcvr_per_sys*num_sys_cop-1:0]   ictl_pcs_rxeiosdetectstat_lx_a,

  // Interface to BK BB
    output  wire    [l_sys_xcvrs*8-1:0]                  fht_ingress_direct,  
     input  wire    [l_sys_xcvrs*8-1:0]                  fht_rx_direct,           
     input  wire    [l_sys_xcvrs-1:0]                    fht_rxsrds_rdy,           

  // Interface to directphy_f_hip
    output   wire   [l_sys_aibs*4-1:0]    hip_aib_fsr_in,
    input    wire   [l_sys_aibs*4-1:0]    hip_aib_fsr_out,
    output   wire   [l_sys_aibs*40-1:0]   hip_aib_ssr_in,
    input    wire   [l_sys_aibs*8-1:0]    hip_aib_ssr_out,
    input    wire   [l_sys_aibs-1:0]      pld_10g_krfec_rx_blk_lock,
    output   wire   [l_sys_aibs-1:0]      pld_10g_krfec_rx_clr_errblk_cnt,
    input    wire   [l_sys_aibs*2-1:0]    pld_10g_krfec_rx_diag_data_status,
    input    wire   [l_sys_aibs-1:0]      pld_10g_krfec_rx_frame,
    input    wire   [l_sys_aibs-1:0]      pld_10g_rx_crc32_err,
    input    wire   [l_sys_aibs-1:0]      pld_10g_rx_frame_lock,
    input    wire   [l_sys_aibs-1:0]      pld_10g_rx_hi_ber,
    output   wire   [l_sys_aibs*7-1:0]    pld_10g_tx_bitslip,
    input    wire   [l_sys_aibs*4-1:0]    pld_8g_a1a2_k1k2_flag,
    output   wire   [l_sys_aibs-1:0]      pld_8g_bitloc_rev_en,
    output   wire   [l_sys_aibs-1:0]      pld_8g_byte_rev_en,
    output   wire   [l_sys_aibs*3-1:0]    pld_8g_eidleinfersel,
    input    wire   [l_sys_aibs-1:0]      pld_8g_empty_rmf,
    output   wire   [l_sys_aibs-1:0]      pld_8g_encdt,
    input    wire   [l_sys_aibs-1:0]      pld_8g_full_rmf,
    output   wire   [l_sys_aibs*5-1:0]    pld_8g_tx_boundary_sel,
    input    wire   [l_sys_aibs*5-1:0]    pld_8g_wa_boundary,
    input    wire   [l_sys_aibs-1:0]      pld_krfec_tx_alignment,
    input    wire   [l_sys_aibs-1:0]      pld_pma_adapt_done,
    output   wire   [l_sys_aibs-1:0]      pld_pma_adapt_start,
    output   wire   [l_sys_aibs-1:0]      pld_pma_csr_test_dis,
    output   wire   [l_sys_aibs-1:0]      pld_pma_early_eios,
    output   wire   [l_sys_aibs*6-1:0]    pld_pma_eye_monitor,
    input    wire   [l_sys_aibs-1:0]      pld_pma_fpll_clk0bad,
    input    wire   [l_sys_aibs-1:0]      pld_pma_fpll_clk1bad,
    input    wire   [l_sys_aibs-1:0]      pld_pma_fpll_clksel,
    output   wire   [l_sys_aibs*4-1:0]    pld_pma_fpll_cnt_sel,
    output   wire   [l_sys_aibs-1:0]      pld_pma_fpll_extswitch,
    output   wire   [l_sys_aibs*3-1:0]    pld_pma_fpll_num_phase_shifts,
    output   wire   [l_sys_aibs-1:0]      pld_pma_fpll_pfden,
    input    wire   [l_sys_aibs-1:0]      pld_pma_fpll_phase_done,
    output   wire   [l_sys_aibs-1:0]      pld_pma_fpll_up_dn_lc_lf_rstn,
    output   wire   [l_sys_aibs-1:0]      pld_pma_nrpi_freeze,
    input    wire   [l_sys_aibs*2-1:0]    pld_pma_pcie_sw_done,
    output   wire   [l_sys_aibs-1:0]      pld_pma_ppm_lock,
    input    wire   [l_sys_aibs*5-1:0]    pld_pma_reserved_in,
    output   wire   [l_sys_aibs*5-1:0]    pld_pma_reserved_out,
    output   wire   [l_sys_aibs-1:0]      pld_pma_rs_lpbk_b,
    input    wire   [l_sys_aibs-1:0]      pld_pma_rx_detect_valid,
    input    wire   [l_sys_aibs-1:0]      pld_pma_rx_found,
    input    wire   [l_sys_aibs-1:0]      pld_pma_signal_ok,
    output   wire   [l_sys_aibs-1:0]      pld_pma_tx_bitslip,
    output   wire   [l_sys_aibs-1:0]      pld_pma_tx_qpi_pulldn,
    output   wire   [l_sys_aibs-1:0]      pld_pma_tx_qpi_pullup,
    input    wire   [l_sys_aibs-1:0]      pld_pmaif_mask_tx_pll,
    output   wire   [l_sys_aibs-1:0]      pld_pmaif_rxclkslip,
    output   wire   [l_sys_aibs-1:0]      pld_polinv_rx,
    output   wire   [l_sys_aibs-1:0]      pld_polinv_tx,
    input    wire   [l_sys_aibs-1:0]      pld_rx_hssi_fifo_empty,
    input    wire   [l_sys_aibs-1:0]      pld_rx_hssi_fifo_full,
    input    wire   [l_sys_aibs-1:0]      pld_rx_prbs_done,
    input    wire   [l_sys_aibs-1:0]      pld_rx_prbs_err,
    output   wire   [l_sys_aibs-1:0]      pld_rx_prbs_err_clr,
    output   wire   [l_sys_aibs-1:0]      pld_syncsm_en,
    input    wire   [l_sys_aibs*20-1:0]   pld_test_data,
    input    wire   [l_sys_aibs-1:0]      pld_tx_hssi_fifo_empty,
    input    wire   [l_sys_aibs-1:0]      pld_tx_hssi_fifo_full,
    input    wire   [l_sys_aibs-1:0]      pld_txelecidle,
    input    wire   [l_sys_aibs-1:0]      pld_pma_rxpll_lock,
    input    wire   [l_sys_aibs-1:0]      pld_8g_rxelecidle,


  input  [l_sys_aibs*80-1:0] tx_parallel_data,
  output [l_sys_aibs*80-1:0] rx_parallel_data,
  input  [l_sys_aibs*80-1:0] sync_data_from_aib,
  output [l_sys_aibs*80-1:0] sync_data_to_aib,

//clock sync for cwbin
  input  [l_sys_aibs-1:0]    tx_coreclkin,

      // Virtual placement link ports for connection to HIP module - necessary for soft reset controller instantiation
`__MC__ input wire [num_xcvr_per_sys*num_sys_cop-1:0] placement_virtual_rx_xcvr,
`__MC__ input wire [num_xcvr_per_sys*num_sys_cop-1:0] placement_virtual_tx_xcvr,
`__MC__ input wire [num_xcvr_per_sys*num_sys_cop-1:0] placement_virtual_fht_xcvr,       

  // Reconfiguration:
  input   [l_av2_ifaces-1:0]       reconfig_clk,
  input   [l_av2_ifaces-1:0]       reconfig_reset,
  input   [l_av2_ifaces-1:0]       reconfig_write,
  input   [l_av2_ifaces-1:0]       reconfig_read,
  input   [l_av2_addr_bits*l_av2_ifaces-1:0]   reconfig_address,
  input   [l_av2_ifaces*4-1:0]     reconfig_byteenable,
  input   [l_av2_ifaces*32-1:0]    reconfig_writedata,
  output  [l_av2_ifaces*32-1:0]    reconfig_readdata,
  output  [l_av2_ifaces-1:0]       reconfig_waitrequest,
  output  [l_av2_ifaces-1:0]       reconfig_readdatavalid,

  input   [l_av1_ifaces-1:0]       reconfig_pdp_clk,
  input   [l_av1_ifaces-1:0]       reconfig_pdp_reset,
  input   [l_av1_ifaces-1:0]       reconfig_pdp_write,
  input   [l_av1_ifaces-1:0]       reconfig_pdp_read,
  input   [l_av1_addr_bits*l_av1_ifaces-1:0]  reconfig_pdp_address,
  input   [l_av1_ifaces*4-1:0]     reconfig_pdp_byteenable,
  input   [l_av1_ifaces*32-1:0]    reconfig_pdp_writedata,
  output  [l_av1_ifaces*32-1:0]    reconfig_pdp_readdata,
  output  [l_av1_ifaces-1:0]       reconfig_pdp_waitrequest,
  output  [l_av1_ifaces-1:0]       reconfig_pdp_readdatavalid,

  //  for AVMM1 bb ports
  input   wire  [l_num_avmm1-1:0]      pld_avmm1_busy,
  output  wire  [l_num_avmm1-1:0]      pld_avmm1_clk_rowclk,
  input   wire  [l_num_avmm1-1:0]      pld_avmm1_cmdfifo_wr_full,
  input   wire  [l_num_avmm1-1:0]      pld_avmm1_cmdfifo_wr_pfull,
  output  wire  [l_num_avmm1-1:0]      pld_avmm1_read,
  input   wire  [8*l_num_avmm1-1:0]    pld_avmm1_readdata,
  input   wire  [l_num_avmm1-1:0]      pld_avmm1_readdatavalid,
  output  wire  [10*l_num_avmm1-1:0]   pld_avmm1_reg_addr,
  output  wire  [l_num_avmm1-1:0]      pld_avmm1_request,
  output  wire  [9*l_num_avmm1-1:0]    pld_avmm1_reserved_in,
  input   wire  [3*l_num_avmm1-1:0]    pld_avmm1_reserved_out,
  output  wire  [l_num_avmm1-1:0]      pld_avmm1_write,
  output  wire  [8*l_num_avmm1-1:0]    pld_avmm1_writedata,
  input   wire  [l_num_avmm1-1:0]      pld_chnl_cal_done,
  input   wire  [l_num_avmm1-1:0]      pld_hssi_osc_transfer_en,
  //  for AVMM2 bb ports
  output  wire  [l_num_avmm2-1:0]      hip_avmm_read,
  input   wire  [8*l_num_avmm2-1:0]    hip_avmm_readdata,
  input   wire  [l_num_avmm2-1:0]      hip_avmm_readdatavalid,
  output  wire  [21*l_num_avmm2-1:0]   hip_avmm_reg_addr,
  input   wire  [5*l_num_avmm2-1:0]    hip_avmm_reserved_out,
  output  wire  [l_num_avmm2-1:0]      hip_avmm_write,
  output  wire  [8*l_num_avmm2-1:0]    hip_avmm_writedata,
  input   wire  [l_num_avmm2-1:0]      hip_avmm_writedone,
  input   wire  [l_num_avmm2-1:0]      pld_avmm2_busy,
  (* alt_clk_source_user="pld_avmm2_clk_rowclk", alt_clk_source_block="hdpldadapt_avmm2", alt_clk_source_port="pld_avmm2_clk_rowclk" *)
  input [l_num_avmm2-1:0] i_common_avmm2_clk,
  output  wire  [l_num_avmm2-1:0]      pld_avmm2_clk_rowclk,
  input   wire  [l_num_avmm2-1:0]      pld_avmm2_cmdfifo_wr_full,
  input   wire  [l_num_avmm2-1:0]      pld_avmm2_cmdfifo_wr_pfull,
  output  wire  [l_num_avmm2-1:0]      pld_avmm2_request,
  input   wire  [l_num_avmm2-1:0]      pld_pll_cal_done,
          // below are unused ports in hip mode
  output  wire  [l_num_avmm2-1:0]      pld_avmm2_write,
  output  wire  [l_num_avmm2-1:0]      pld_avmm2_read,
  output  wire  [9*l_num_avmm2-1:0]    pld_avmm2_reg_addr,
  input   wire  [8*l_num_avmm2-1:0]    pld_avmm2_readdata,
  output  wire  [8*l_num_avmm2-1:0]    pld_avmm2_writedata,
  input   wire  [l_num_avmm2-1:0]      pld_avmm2_readdatavalid,
  output  wire  [6*l_num_avmm2-1:0]    pld_avmm2_reserved_in,
  input   wire  [l_num_avmm2-1:0]      pld_avmm2_reserved_out,

       // Connections to the IP top level for reset and AM generation
  input wire  [num_sys_cop-1:0]    tx_reset,	     
  input wire  [num_sys_cop-1:0]    rx_reset,	     
  output wire [num_sys_cop-1:0]    tx_reset_ack,    
  output wire [num_sys_cop-1:0]    rx_reset_ack,
  // JRJ 10-15-2020 - Change to single wire interface for all lanes for tx_am_gen_start and tx_am_gen_2x_ack for each system copy.    
  // There is one tx_am_gen_start output for each system copy, all lanes, and one tx_am_gen_start_2x_ack input for each
  // system copy, all lanes.
  output wire [num_sys_cop-1:0]    tx_am_gen_start, 
  input wire  [num_sys_cop-1:0]    tx_am_gen_2x_ack,
  output wire [ready_width-1:0]    tx_ready,	     
  output wire [ready_width-1:0]    rx_ready,
  // connection to the IP top level for RX de-skew reset
  output wire [num_xcvr_per_sys*num_sys_cop-1:0] rx_lane_out_of_reset,
       // Soft reset controller:
       // Replaced the parameter l_sys_xcvrs with num_xcvr_per_sys*num_sys_cop to make it more explicit that the soft reset controller operates
       // on each transceiver lane in a system copy, or reset group, but each reset group is tied to a single system copy
       // The number of ports is unchanged.  The ports with the '__MB__ markup are not brought out to the top level in the IP, but are
       // connected at the qtlg step using cross-module references.
       // TX outputs are present only if the tx is enabled
`__MB__  output wire [num_xcvr_per_sys*num_sys_cop-1:0]       tx_lane_desired_state, // 0:operate  1:reset
`__MB__  output wire [num_xcvr_per_sys*num_sys_cop-1:0]       tx_clear_alarm,
// At the input to the soft reset controller, there is one sip_am_gen_start output per transceiver lane and one
// sip_am_gen_2_ack input per transceiver lane.  The soft IP component (this file) maps this to a single
// port accessible to the user IP for each system copy.
`__MB__  output wire [num_xcvr_per_sys*num_sys_cop-1:0]       sip_am_gen_2x_ack,
       // RX outputs are present only if the rx is enabled
`__MB__  output wire [num_xcvr_per_sys*num_sys_cop-1:0]       rx_lane_desired_state, // 0:operate  1:reset
`__MB__  output wire [num_xcvr_per_sys*num_sys_cop-1:0]       rx_clear_alarm,
`__MB__  output wire [num_xcvr_per_sys*num_sys_cop-1:0]       sip_rx_ignore_lock2data,
`__MB__   input wire [num_xcvr_per_sys*num_sys_cop-1:0]       sip_am_gen_start,
`__MB__   input wire [num_xcvr_per_sys*num_sys_cop-1:0]       tx_alarm,
`__MB__   input wire [num_xcvr_per_sys*num_sys_cop-1:0]       rx_alarm,
`__MB__   input wire [num_xcvr_per_sys*num_sys_cop-1:0][2:0]  tx_lane_current_state,
       // 100 - in a transitional state
       // 101 - in the full reset state
       // 110 - in the normal operational state
`__MB__   input wire [num_xcvr_per_sys*num_sys_cop-1:0][2:0]  rx_lane_current_state,
       // 100 - in a transitional state
       // 101 - in the full reset state
       // 110 - in the normal operational state
`__MB__   output wire [num_xcvr_per_sys*num_sys_cop-1:0]  i_dphy_iflux_ingress_input	   
);

localparam avmm2_enable_or_gpon = (l_av2_enable == 1 )|| (bb_f_ux_tx_tuning_hint == "TX_TUNING_HINT_GPON") ;
 
   wire [num_sys_cop-1:0]   w_src_ctrl_rx_ignore_locked2data;

   // Status lines from the soft reset controller - JRJ
   wire [num_xcvr_per_sys*num_sys_cop-1:0] tx_lane_is_in_reset;
   wire [num_xcvr_per_sys*num_sys_cop-1:0] rx_lane_is_in_reset;
   wire [num_xcvr_per_sys*num_sys_cop-1:0] tx_lane_out_of_reset;
  // wire [num_xcvr_per_sys*num_sys_cop-1:0] rx_lane_out_of_reset; // make it as connection to the IP top level for RX de-skew reset
   wire [num_xcvr_per_sys-1:0] tx_per_lane_sip_am_gen_start[num_sys_cop-1:0];
   wire [num_xcvr_per_sys-1:0] tx_per_lane_sip_am_gen_2x_ack[num_sys_cop-1:0];

   // UX PMA status 
   wire [l_sys_xcvrs-1:0]   fgt_tx_pll_locked;                 
   wire [l_sys_xcvrs-1:0]   fgt_rx_is_lockedtodata;          
   wire [l_sys_xcvrs-1:0]   fgt_rx_is_lockedtoref;          

   // BK PMA status
   wire [l_sys_xcvrs-1:0]   fht_tx_pll_locked;                 
   wire [l_sys_xcvrs-1:0]   fht_rx_is_lockedtodata;          
   wire [l_sys_xcvrs-1:0]   fht_rx_is_lockedtoref;  

  // ctrl  signals from and and status signals to soft CSR
  wire    [num_sys_cop-1:0]                     dphy_reset_soft_tx_rst;
  wire    [num_sys_cop-1:0]                     dphy_reset_tx_rst_ovr;
  wire    [num_sys_cop-1:0]                     dphy_reset_soft_rx_rst;
  wire    [num_sys_cop-1:0]                     dphy_reset_rx_rst_ovr;
 




  // Wires for EHIP
   wire  [l_sys_aibs-1:0]  w_ehip__i_clear_internal;
   wire  [l_sys_aibs-1:0]  w_ehip__i_pld_ready;
   wire  [l_sys_aibs-1:0]  w_ehip__i_signal_ok;                  // Driven by Reset Controller
   wire  [l_sys_aibs-1:0]  w_ehip__o_hi_ber;
   wire  [l_sys_aibs-1:0]  w_ehip__o_hip_ready;
   wire  [l_sys_aibs-1:0]  w_ehip__o_local_fault;
   wire  [l_sys_aibs-1:0]  w_ehip__o_rx_am_lock;
   wire  [l_sys_aibs-1:0]  w_ehip__o_rx_block_lock;
   wire  [l_sys_aibs-1:0]  w_ehip__o_rx_dsk_done;
   wire  [l_sys_aibs-1:0]  w_ehip__o_rx_pcs_fully_aligned;
   wire  [l_sys_aibs-1:0]  w_ehip__o_rx_pcs_internal_err;
   wire  [l_sys_aibs-1:0]  w_ehip__o_rx_rst_n;
   wire  [l_sys_aibs-1:0]  w_ehip__o_tx_rst_n;
   wire  [l_sys_aibs-1:0]  w_ehip__o_txfifo_pfull;
   wire  [l_sys_aibs-1:0]  w_ehip__i_sfreeze[3:0];
   wire  [l_sys_aibs-1:0]  w_ehip__i_tx_pause;
   wire  [l_sys_aibs-1:0]  w_ehip__i_tx_pfc[7:0];
   wire  [l_sys_aibs-1:0]  w_ehip__o_remote_fault;
   wire  [l_sys_aibs-1:0]  w_ehip__o_rx_pause;
   wire  [l_sys_aibs-1:0]  w_ehip__o_rx_pfc[7:0];

  // Wires for GDR Ctrol:  FEC, XCVRIF
   wire  [l_sys_aibs-1:0]  w_gdrctrl__xcvrif_hold_inter;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__rx_lane_hold_inter;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__rx_aggr_hold_inter;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__o_pcs_rx_sf;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__fec_not_align;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__fec_not_deskew;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__fec_not_locked;

                 // unverified:
   wire  [l_sys_aibs-1:0]  w_gdrctrl__i_lphy_signal_ok;           // Driven by Reset Controller
   wire  [l_sys_aibs-1:0]  w_gdrctrl__i_rx_async_pulseTBD;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__i_rx_reset_sfreeze_fec;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__i_rx_reset_sfreeze_xcvrif;  // Driven by Reset Controller
   wire  [l_sys_aibs-1:0]  w_gdrctrl__i_tx_async_pulseTBD;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__i_tx_reset_sfreeze_fec;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__i_tx_reset_sfreeze_xcvrif;  // Driven by Reset Controller
   wire  [l_sys_aibs-1:0]  w_gdrctrl__o_xcvrif_rxfifo_empty;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__o_xcvrif_rxfifo_pempty;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__o_xcvrif_rxfifo_pfull;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__o_xcvrif_txfifo_empty;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__o_xcvrif_txfifo_pempty;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__o_xcvrif_txfifo_pfull;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__rx_gb_resync;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__tx_gb_resync;
   wire  [l_sys_aibs-1:0]  w_gdrctrl__tx_lane_hold_interrupt;


  // Wires for FHTs 
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fht__obrk_rx_direct_lane1[7:0];



  // Wires for FGTs 
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_rxbist_en_lx_a;
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_rxbitslip_lx_a;
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_rxeiosdetectstat_lx_a;
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_rxeq_clr_lx_a;
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_rxeq_precal_code_sel_lx_nt_[2:0];
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_rxeq_start_lx_a;
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_rxeq_static_en_lx_a;
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_rxeyediag_start_lx_a;
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_rxrate_lx_[3:0];
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_rxterm_hiz_en_lx_a;
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_txdrv_levnm1_lx_[4:0];
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_txdrv_levnm2_lx_[2:0];
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_txdrv_levnp1_lx_[4:0];
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_txdrv_slew_lx_[3:0];
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_txenable;
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_txrate_lx_[3:0];
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__ictl_pcs_txwidth_lx_[2:0];
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__octl_pcs_rxeq_done_lx_a;
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__octl_pcs_synthlcslow_ready_a;
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__octl_pcs_txdetectrx_ack_lx_a;
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__octl_pcs_txdetectrx_stat_lx_ct;
   wire [num_sys_cop*num_xcvr_per_sys-1:0] w_fgt__octl_pcs_cmn_ready_a;
   
   //cw bin counter
   logic  o_stats_snapshot;
   logic  o_stats_snapshot_sync;
   logic [num_sys_cop-1:0] cwbin_rst;
   logic [num_sys_cop*32-1:0] cwbin0A_out;
   logic [num_sys_cop*32-1:0] cwbin1A_out;
   logic [num_sys_cop*32-1:0] cwbin2A_out;
   logic [num_sys_cop*32-1:0] cwbin3A_out;
   logic [num_sys_cop*32-1:0] cwbin0B_out;
   logic [num_sys_cop*32-1:0] cwbin1B_out;
   logic [num_sys_cop*32-1:0] cwbin2B_out;
   logic [num_sys_cop*32-1:0] cwbin3B_out;
   logic [num_sys_cop*32-1:0] cwbin_timer_timeout;
   
   
 //JTAG AVMM DPHY RECONFIG 
    wire [l_av1_addr_bits*l_av1_ifaces-1:0] reconfig_pdp_address_cw;
    wire [l_av1_ifaces*4-1:0]               reconfig_pdp_byteenable_cw;
    wire [l_av1_ifaces-1:0]                 reconfig_pdp_write_cw;
    wire [l_av1_ifaces-1:0]                 reconfig_pdp_read_cw;
    wire [l_av1_ifaces*32-1:0]              reconfig_pdp_writedata_cw;
    wire [l_av1_ifaces*32-1:0]              reconfig_pdp_readdata_cw;//reg
    wire [l_av1_ifaces-1:0]                 reconfig_pdp_readdata_valid_cw;//wire
    wire [l_av1_ifaces-1:0]                 reconfig_pdp_waitrequest_cw;//reg


//-----------------------------------------------------------------------------
//   Interface mapping:  XCVR FGT/FHT
//-----------------------------------------------------------------------------
if (bb_f_ehip_xcvr_type=="XCVR_TYPE_UX") begin:mapping_fgt
    // Does  num_xcvr_per_sys*num_sys_cop == l_sys_aibs for UX case?
   assign               w_fgt__ictl_pcs_txenable = tx_enable_xcvr;
end



//-----------------------------------------------------------------------------
//   Interface mapping:  XCVR IF
//-----------------------------------------------------------------------------
   assign  xcvrif_rxfifo_empty = w_gdrctrl__o_xcvrif_rxfifo_empty;
   assign xcvrif_rxfifo_pempty = w_gdrctrl__o_xcvrif_rxfifo_pempty;
   assign  xcvrif_rxfifo_pfull = w_gdrctrl__o_xcvrif_rxfifo_pfull;

   assign  xcvrif_txfifo_empty = w_gdrctrl__o_xcvrif_txfifo_empty;
   assign xcvrif_txfifo_pempty = w_gdrctrl__o_xcvrif_txfifo_pempty;
   assign  xcvrif_txfifo_pfull = w_gdrctrl__o_xcvrif_txfifo_pfull;

   assign xcvrif_hold_interrupt = w_gdrctrl__xcvrif_hold_inter;

//cwbin counter ethip rate calculation
localparam EHIP_RATE_CSR = (bb_f_ehip_frac_size == "F10G")  ? 3'd0 : (bb_f_ehip_frac_size == "F25G")  ? 3'd1 : (bb_f_ehip_frac_size == "F40G")  ? 3'd2 : (bb_f_ehip_frac_size == "F50G")  ? 3'd3 : (bb_f_ehip_frac_size == "F100G") ? 3'd4 : (bb_f_ehip_frac_size == "F200G") ? 3'd5 : 3'd6;

//-----------------------------------------------------------------------------
//    HW Block <-> Soft-IP
//-----------------------------------------------------------------------------
 //  assign    pld_pma_ppm_lock = fec_snapshot;

assign    pld_pma_ppm_lock = {l_sys_aibs{o_stats_snapshot_sync}};

genvar idx_aib;
generate
  for(idx_aib=0;idx_aib<l_sys_aibs;idx_aib=idx_aib+1) begin: pld_intf

   // EHIP
   assign    w_gdrctrl__o_xcvrif_rxfifo_empty[idx_aib] = pld_rx_prbs_done[idx_aib];
   assign    w_gdrctrl__o_xcvrif_rxfifo_pempty[idx_aib] = pld_10g_rx_frame_lock[idx_aib];
   assign    w_gdrctrl__o_xcvrif_rxfifo_pfull[idx_aib] = pld_10g_rx_hi_ber[idx_aib];
   assign    w_gdrctrl__o_xcvrif_txfifo_empty[idx_aib] = pld_rx_prbs_err[idx_aib];
   assign    w_gdrctrl__rx_gb_resync[idx_aib] = pld_rx_hssi_fifo_full[idx_aib];
   assign    w_gdrctrl__tx_gb_resync[idx_aib] = pld_tx_hssi_fifo_empty[idx_aib];
   assign    w_gdrctrl__tx_lane_hold_interrupt[idx_aib] = pld_tx_hssi_fifo_full[idx_aib];
   assign    { w_ehip__o_txfifo_pfull[idx_aib], w_gdrctrl__o_xcvrif_txfifo_pfull[idx_aib], w_gdrctrl__o_xcvrif_txfifo_pempty[idx_aib]  } = hip_aib_fsr_out[4*idx_aib+:3];
   assign    { w_gdrctrl__xcvrif_hold_inter[idx_aib],w_gdrctrl__fec_not_align[idx_aib],w_gdrctrl__fec_not_deskew[idx_aib],w_gdrctrl__fec_not_locked[idx_aib],w_gdrctrl__rx_aggr_hold_inter[idx_aib],w_gdrctrl__o_pcs_rx_sf[idx_aib],w_gdrctrl__rx_lane_hold_inter[idx_aib] } = hip_aib_ssr_out[8*idx_aib+:7];

// assign    hip_aib_fsr_in[4*idx_aib] = w_gdrctrl__i_lphy_signal_ok[idx_aib];  -- Driven by Reset Controller
//                                       w_gdrctrl__i_rx_reset_sfreeze_xcvrif   -- Driven by Reset Controller
//                                       w_gdrctrl__i_tx_reset_sfreeze_xcvrif   -- Driven by Reset Controller
//                                       w_ehip__i_signal_ok                    -- Driven by Reset Controller
//TODO assign    hip_aib_ssr_in[40*idx_aib+:40] = { w_fgt__ictl_pcs_txdrv_levnp1_lx_[1][idx_aib], w_fgt__ictl_pcs_txdrv_levnp1_lx_[2][idx_aib], w_fgt__ictl_pcs_txdrv_levnp1_lx_[3][idx_aib], w_fgt__ictl_pcs_txdrv_levnp1_lx_[4][idx_aib], w_fgt__ictl_pcs_txdrv_slew_lx_[0][idx_aib], w_fgt__ictl_pcs_txdrv_slew_lx_[1][idx_aib], w_fgt__ictl_pcs_txdrv_slew_lx_[2][idx_aib], w_fgt__ictl_pcs_txdrv_slew_lx_[3][idx_aib], w_fgt__ictl_pcs_rxeq_start_lx_a[idx_aib], w_fgt__ictl_pcs_rxeq_precal_code_sel_lx_nt_[0][idx_aib], w_fgt__ictl_pcs_rxeq_precal_code_sel_lx_nt_[1][idx_aib], w_fgt__ictl_pcs_rxeq_precal_code_sel_lx_nt_[2][idx_aib], w_fgt__ictl_pcs_rxeq_clr_lx_a[idx_aib], w_fgt__ictl_pcs_txenable[idx_aib], w_fgt__ictl_pcs_rxeyediag_start_lx_a[idx_aib], w_fgt__ictl_pcs_rxbist_en_lx_a[idx_aib], w_ehip__i_tx_pfc[0][idx_aib], w_ehip__i_tx_pfc[1][idx_aib], w_ehip__i_tx_pfc[2][idx_aib], w_ehip__i_tx_pfc[3][idx_aib], w_ehip__i_tx_pfc[4][idx_aib], w_ehip__i_tx_pfc[5][idx_aib], w_ehip__i_tx_pfc[6][idx_aib], w_ehip__i_tx_pfc[7][idx_aib], w_ehip__i_tx_pause[idx_aib], w_ehip__i_clear_internal[idx_aib], w_ehip__i_signal_ok[idx_aib], w_ehip__i_pld_ready[idx_aib], w_ehip__i_sfreeze[0][idx_aib], w_ehip__i_sfreeze[1][idx_aib], w_ehip__i_sfreeze[2][idx_aib], w_ehip__i_sfreeze[3][idx_aib],,, w_gdrctrl__i_tx_async_pulseTBD[idx_aib], w_gdrctrl__i_rx_async_pulseTBD[idx_aib], w_gdrctrl__i_tx_reset_sfreeze_fec[idx_aib], w_gdrctrl__i_rx_reset_sfreeze_fec[idx_aib], w_gdrctrl__i_tx_reset_sfreeze_xcvrif[idx_aib], w_gdrctrl__i_rx_reset_sfreeze_xcvrif[idx_aib] };

  end // end for idx_aib
endgenerate





genvar idx_sys_cop;
generate
for(idx_sys_cop=0;idx_sys_cop<num_sys_cop;idx_sys_cop=idx_sys_cop+1) begin: persystem

     assign sip_rx_ignore_lock2data[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys] = {num_xcvr_per_sys{w_src_ctrl_rx_ignore_locked2data[idx_sys_cop]}};

   // Ingress_231 GPON signal routing through SRC
      assign i_dphy_iflux_ingress_input[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  = fgt_rx_cdr_freeze[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys];


   //-----------------------------------------------------------------------------
   //   Instantiations of soft custom cadence generation (CCG)
   //-----------------------------------------------------------------------------
   if (tx_custom_cadence_enable == 1) begin : ccg
       // custom cadence controller with it's ram disabled
       // follows example in regtest/ip/efifo_f/hsl_dcfifo_v3_ext_ram/test/dut.sv
       dphy_f_ccg # (
          .WIDTH       (80),
          .DISABLE_RAM (1),
          .ADDR_WIDTH (5)
        ) ccg (
          .aclr   ((enable_port_tx_cadence_slow_clk_locked == 0) ? tx_reset[idx_sys_cop] | ~(&tx_pll_locked[num_xcvr_per_sys*idx_sys_cop +: num_xcvr_per_sys]) : tx_reset[idx_sys_cop] | ~tx_cadence_slow_clk_locked[idx_sys_cop]),    
          .wclk   (tx_cadence_slow_clk[idx_sys_cop]),
          .wreq   (1'b1),  
          .rclk   (tx_cadence_fast_clk[idx_sys_cop]),
          .rreq   (1'b1),
          .rempty (),
          .data_valid (tx_cadence[idx_sys_cop])
        );
   end

   //-----------------------------------------------------------------------------
   //   Interface mapping:  RSFEC
   //-----------------------------------------------------------------------------
   if (num_fec_ch>0) begin:mapping_rsfec
       assign  rsfec_status_rx_not_deskew[idx_sys_cop] = w_gdrctrl__fec_not_deskew[idx_sys_cop*num_xcvr_per_sys*l_num_aib_per_xcvr];
       assign  rsfec_status_rx_not_locked[idx_sys_cop] = w_gdrctrl__fec_not_locked[idx_sys_cop*num_xcvr_per_sys*l_num_aib_per_xcvr];
       assign   rsfec_status_rx_not_align[idx_sys_cop] =  w_gdrctrl__fec_not_align[idx_sys_cop*num_xcvr_per_sys*l_num_aib_per_xcvr];
       assign                    rsfec_sf[idx_sys_cop] =    w_gdrctrl__o_pcs_rx_sf[idx_sys_cop*num_xcvr_per_sys*l_num_aib_per_xcvr];
     //assign                   fec_ready = w_ehip__o_hip_ready;
   end


   genvar idx_xcvr;
   for (idx_xcvr=0;idx_xcvr<num_xcvr_per_sys;idx_xcvr=idx_xcvr+1) begin: perxcvr
   localparam idx_sys_xcvr = num_xcvr_per_sys*idx_sys_cop + idx_xcvr;

/*
        //instantiate aibs, for now assuming num tx and rx are equal
        genvar idx_aib;

        for(idx_aib=0;idx_aib<l_num_aib_per_xcvr;idx_aib=idx_aib+1) begin: peraib
           localparam idx_xcvr_aib = idx_xcvr*l_num_aib_per_xcvr + idx_aib;
           localparam idx_sys_aib  = idx_sys_cop*num_xcvr_per_sys*l_num_aib_per_xcvr + idx_xcvr_aib;

        end // end for idx_aib
*/


       if (bb_f_ehip_xcvr_type=="XCVR_TYPE_UX") begin:fgt
         // Shared bits
	 
       end  // end if bb_f_ehip_xcvr_type=FGT
       else begin:fht


	 //map BK PMA status 
           assign fht_rx_energy_detect[idx_sys_xcvr]   = fht_rx_direct[idx_sys_xcvr*8+2];    //TODO: energy detect = signal detect?
           assign fht_tx_pll_locked[idx_sys_xcvr]      = fht_rx_direct[idx_sys_xcvr*8];      //TODO: control bits?           
           assign fht_rx_is_lockedtodata[idx_sys_xcvr] = fht_rxsrds_rdy[idx_sys_xcvr];          
           assign fht_rx_is_lockedtoref[idx_sys_xcvr]  = fht_rx_direct[idx_sys_xcvr*8+1];  
       end  // end if bb_f_ehip_xcvr_type=FHT

     // Connect soft reset controller desired lane state inputs
     // For right now, there is a single tx_reset and a single rx_reset input - JRJ
      assign tx_lane_desired_state[idx_sys_xcvr] = (dphy_reset_tx_rst_ovr[idx_sys_cop])? dphy_reset_soft_tx_rst[idx_sys_cop] : tx_reset[idx_sys_cop];
      assign rx_lane_desired_state[idx_sys_xcvr] = (dphy_reset_rx_rst_ovr[idx_sys_cop])? dphy_reset_soft_rx_rst[idx_sys_cop] : rx_reset[idx_sys_cop];

      // Connect soft reset controller current lane state outputs
      assign tx_lane_is_in_reset[idx_sys_xcvr]  = tx_lane_current_state[idx_sys_xcvr][0];
      assign rx_lane_is_in_reset[idx_sys_xcvr]  = rx_lane_current_state[idx_sys_xcvr][0];
      assign tx_lane_out_of_reset[idx_sys_xcvr] = tx_lane_current_state[idx_sys_xcvr][1];
      assign rx_lane_out_of_reset[idx_sys_xcvr] = rx_lane_current_state[idx_sys_xcvr][1];

      // Connect soft reset controller sip_am_gen_start and sip_am_gen_2x_ack ports for each transceiver
      assign tx_per_lane_sip_am_gen_start[idx_sys_cop][idx_xcvr] = sip_am_gen_start[idx_sys_xcvr];
      assign sip_am_gen_2x_ack[idx_sys_xcvr] = tx_per_lane_sip_am_gen_2x_ack[idx_sys_cop][idx_xcvr];
    
   end // end for perxcvr

   // And together all the lane state wires of one system to get a top-level output.  
   assign tx_reset_ack[idx_sys_cop] = &tx_lane_is_in_reset[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys];
   assign rx_reset_ack[idx_sys_cop] = &rx_lane_is_in_reset[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys];
   assign tx_ready[idx_sys_cop]     = &tx_lane_out_of_reset[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys];
   assign rx_ready[idx_sys_cop]     = &rx_lane_out_of_reset[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys];
      // Assign the alignment marker start and acknowledge lines
   assign tx_am_gen_start[idx_sys_cop] = &tx_per_lane_sip_am_gen_start[idx_sys_cop];
   assign tx_per_lane_sip_am_gen_2x_ack[idx_sys_cop] = {num_xcvr_per_sys {tx_am_gen_2x_ack[idx_sys_cop]}};

end // end for persystem

endgenerate
   

//-----------------------------------------------------------------------------
//   Interface mapping:  UX BB
//-----------------------------------------------------------------------------
   assign fgt_rx_signal_detect = oct_pcs_rxsignaldetect_lx_a;
   assign fgt_rx_signal_detect_lfps = octl_pcs_rxsignaldetect_lfps_lx_a;
   assign fgt_tx_pll_locked = oct_pcs_all_synthlockstatus & octl_pcs_txstatus_lx_a;//status signal is more like pma ready hence anding them to make it similar to previous tiles                
   assign fgt_rx_is_lockedtodata = oct_pcs_rxcdrlock2data_lx_a;        
   assign fgt_rx_is_lockedtoref = oct_pcs_rxcdrlockstatus_lx_a;
   assign ictl_pcs_rxovrcdrlock2dataen_lx_a = fgt_rx_set_locktoref;
//   assign ictl_pcs_rxovrcdrlock2data_lx_a = '0;//setting mode to always locktoref and reflecting functionality on enable disable.
   assign ictl_pcs_rxovrcdrlock2data_lx_a = fgt_rx_set_locktodata;
   assign ictl_pcs_txbeacon_lx_a = fgt_tx_beacon;
   assign flux_top__iflux_ingress_direct__231 = '0;//This signal routing through SRC module.
   assign i_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t = fgt_rx_cdr_fast_freeze_sel;
   assign ictl_pcs_rxeiosdetectstat_lx_a         = fgt_rx_cdr_set_locktoref;

   assign tx_pll_locked      = (bb_f_ehip_xcvr_type=="XCVR_TYPE_UX")? fgt_tx_pll_locked       : fht_tx_pll_locked     ;  
   assign rx_is_lockedtoref  = (bb_f_ehip_xcvr_type=="XCVR_TYPE_UX")? fgt_rx_is_lockedtoref   : fht_rx_is_lockedtoref ; 
   assign rx_is_lockedtodata = (bb_f_ehip_xcvr_type=="XCVR_TYPE_UX")? fgt_rx_is_lockedtodata  : fht_rx_is_lockedtodata;   

//-----------------------------------------------------------------------------
//   Interface mapping:  Clocks and Data
//-----------------------------------------------------------------------------
     // TO DO, map the parallel data in simplified data bus
     // for now, just pass through
  assign sync_data_to_aib   = tx_parallel_data;
  assign rx_parallel_data   = sync_data_from_aib;

//-----------------------------------------------------------------------------
//   Interface mapping:  Instantiations of soft AVMM1/2 modules
//-----------------------------------------------------------------------------
// TO DO: add AVMM soft logic, shared I/F, 32 to 8 conversion, and ADME

   wire  [num_sys_cop-1:0]    ftile_dphy_adme_avmm1_clk;
   wire  [num_sys_cop-1:0]    ftile_dphy_adme_avmm1_reset;
   wire  [num_sys_cop-1:0]    ftile_dphy_adme_avmm1_write;
   wire  [num_sys_cop-1:0]    ftile_dphy_adme_avmm1_read;
   wire  [num_sys_cop*l_av1_addr_bits-1:0]  ftile_dphy_adme_avmm1_address;
   wire  [num_sys_cop*4-1:0]  ftile_dphy_adme_avmm1_byteenable;
   wire  [num_sys_cop*32-1:0] ftile_dphy_adme_avmm1_writedata;
   wire  [num_sys_cop*32-1:0] ftile_dphy_adme_avmm1_readdata;
   wire  [num_sys_cop-1:0]    ftile_dphy_adme_avmm1_waitrequest;
   wire  [num_sys_cop-1:0]    ftile_dphy_adme_avmm1_readdatavalid;

   wire  [num_sys_cop-1:0]    ftile_dphy_adme_avmm2_clk;
   wire  [num_sys_cop-1:0]    ftile_dphy_adme_avmm2_reset;
   wire  [num_sys_cop-1:0]    ftile_dphy_adme_avmm2_write;
   wire  [num_sys_cop-1:0]    ftile_dphy_adme_avmm2_read;
   wire  [num_sys_cop*l_av2_addr_bits-1:0]  ftile_dphy_adme_avmm2_address;
   wire  [num_sys_cop*4-1:0]  ftile_dphy_adme_avmm2_byteenable;
   wire  [num_sys_cop*32-1:0] ftile_dphy_adme_avmm2_writedata;
   wire  [num_sys_cop*32-1:0] ftile_dphy_adme_avmm2_readdata;
   wire  [num_sys_cop-1:0]    ftile_dphy_adme_avmm2_waitrequest;
   wire  [num_sys_cop-1:0]    ftile_dphy_adme_avmm2_readdatavalid;

   wire  [l_av1_ifaces*32-1:0] dphy_avmm1_readdata;
   wire  [l_av1_ifaces-1:0]    dphy_avmm1_waitrequest;
   wire  [l_av1_ifaces-1:0]    dphy_avmm1_readdatavalid;

   wire  [l_av2_ifaces*32-1:0] dphy_avmm2_readdata;
   wire  [l_av2_ifaces-1:0]    dphy_avmm2_waitrequest;
   wire  [l_av2_ifaces-1:0]    dphy_avmm2_readdatavalid;

     genvar ig;
     for(ig=0;ig<num_sys_cop;ig=ig+1) begin:f_dphy_adme

        ftile_xcvr_test_directphy_f_0_directphy_f_ftile_adme_490_nft75ny #(
           .avmm1_addr_width   (l_av1_addr_bits),
           .avmm2_addr_width   (l_av2_addr_bits)
        ) f_dphy_adme_inst (

           .avmm1_clk_user                ( reconfig_pdp_clk[ig] ),
           .avmm1_reset_user              ( reconfig_pdp_reset[ig] ),
           .avmm1_address_user            ( reconfig_pdp_address_cw[ig*l_av1_addr_bits+:l_av1_addr_bits] ),
           .avmm1_byte_enable_user        ( reconfig_pdp_byteenable_cw[ig*4+:4] ),     
           .avmm1_write_user              ( reconfig_pdp_write_cw[ig] ),           
           .avmm1_read_user               ( reconfig_pdp_read_cw[ig] ),            
           .avmm1_write_data_user         ( reconfig_pdp_writedata_cw[ig*32+:32] ),      
           .avmm1_read_data_user          ( ftile_dphy_adme_avmm1_readdata[ig*32+:32] ),       
           .avmm1_waitrequest_user        ( ftile_dphy_adme_avmm1_waitrequest[ig] ),     
           .avmm1_read_data_valid_user    ( ftile_dphy_adme_avmm1_readdatavalid[ig] ), 

           .avmm1_clk_tile                ( ftile_dphy_adme_avmm1_clk[ig] ),
           .avmm1_reset_tile              ( ftile_dphy_adme_avmm1_reset[ig] ),
           .avmm1_address_tile            ( ftile_dphy_adme_avmm1_address[ig*l_av1_addr_bits+:l_av1_addr_bits] ),
           .avmm1_byte_enable_tile        ( ftile_dphy_adme_avmm1_byteenable[ig*4+:4] ),     
           .avmm1_write_tile              ( ftile_dphy_adme_avmm1_write[ig] ),           
           .avmm1_read_tile               ( ftile_dphy_adme_avmm1_read[ig] ),            
           .avmm1_write_data_tile         ( ftile_dphy_adme_avmm1_writedata[ig*32+:32] ),      
           .avmm1_read_data_tile          ( dphy_avmm1_readdata[ig*32+:32] ),       
           .avmm1_waitrequest_tile        ( dphy_avmm1_waitrequest[ig] ),     
           .avmm1_read_data_valid_tile    ( dphy_avmm1_readdatavalid[ig] ), 

           .avmm2_clk_user                ( reconfig_clk[ig] ),
           .avmm2_reset_user              ( reconfig_reset[ig] ),
           .avmm2_address_user            ( reconfig_address[ig*l_av2_addr_bits+:l_av2_addr_bits] ),
           .avmm2_byte_enable_user        ( reconfig_byteenable[ig*4+:4] ),     
           .avmm2_write_user              ( reconfig_write[ig] ),           
           .avmm2_read_user               ( reconfig_read[ig] ),            
           .avmm2_write_data_user         ( reconfig_writedata[ig*32+:32] ),      
           .avmm2_read_data_user          ( ftile_dphy_adme_avmm2_readdata[ig*32+:32] ),       
           .avmm2_waitrequest_user        ( ftile_dphy_adme_avmm2_waitrequest[ig] ),     
           .avmm2_read_data_valid_user    ( ftile_dphy_adme_avmm2_readdatavalid[ig] ), 

           .avmm2_clk_tile                ( ftile_dphy_adme_avmm2_clk[ig] ),
           .avmm2_reset_tile              ( ftile_dphy_adme_avmm2_reset[ig] ),
           .avmm2_address_tile            ( ftile_dphy_adme_avmm2_address[ig*l_av2_addr_bits+:l_av2_addr_bits] ),
           .avmm2_byte_enable_tile        ( ftile_dphy_adme_avmm2_byteenable[ig*4+:4] ),     
           .avmm2_write_tile              ( ftile_dphy_adme_avmm2_write[ig] ),           
           .avmm2_read_tile               ( ftile_dphy_adme_avmm2_read[ig] ),            
           .avmm2_write_data_tile         ( ftile_dphy_adme_avmm2_writedata[ig*32+:32] ),      
           .avmm2_read_data_tile          ( dphy_avmm2_readdata[ig*32+:32] ),       
           .avmm2_waitrequest_tile        ( dphy_avmm2_waitrequest[ig] ),     
           .avmm2_read_data_valid_tile    ( dphy_avmm2_readdatavalid[ig] )
	);
     end
    assign  reconfig_pdp_readdata_cw       = ( (avmm1_jtag_enable) ? ftile_dphy_adme_avmm1_readdata      : dphy_avmm1_readdata);       
    assign  reconfig_pdp_waitrequest_cw    = ( (avmm1_jtag_enable) ? ftile_dphy_adme_avmm1_waitrequest   : dphy_avmm1_waitrequest);     
    assign  reconfig_pdp_readdata_valid_cw  = ( (avmm1_jtag_enable) ? ftile_dphy_adme_avmm1_readdatavalid : dphy_avmm1_readdatavalid); 
    assign  reconfig_readdata           = ( (avmm2_jtag_enable) ? ftile_dphy_adme_avmm2_readdata      : dphy_avmm2_readdata);       
    assign  reconfig_waitrequest        = ( (avmm2_jtag_enable) ? ftile_dphy_adme_avmm2_waitrequest   : dphy_avmm2_waitrequest);     
    assign  reconfig_readdatavalid      = ( (avmm2_jtag_enable) ? ftile_dphy_adme_avmm2_readdatavalid : dphy_avmm2_readdatavalid); 

  dphy_f_avmm1 #(
	.num_sys_cop                               (num_sys_cop),
	.num_xcvr_per_sys                          (num_xcvr_per_sys),
	.l_num_aib_per_xcvr                        (l_num_aib_per_xcvr),
	.l_sys_aibs                                (l_sys_aibs),
        .l_tx_enable                               (l_tx_enable),
	.l_rx_enable                               (l_rx_enable),
        .xcvr_type                                 ((bb_f_ehip_xcvr_type=="XCVR_TYPE_UX"? 1'b0 : 1'b1)),
        .modulation_type                           ((bb_f_ehip_xcvr_mode=="XCVR_MODE_NRZ")? 1'b0: 1'b1),
        .l_soft_csr_enable                         (l_soft_csr_enable),
        .l_line_rate_p1ghz                         (l_line_rate_p1ghz),
        .avmm1_readdv_enable                       (avmm1_readdv_enable),
	.fec_enable                                (fec_on),
	.avmm1_split                               (avmm1_split),
	.l_av1_enable                              (l_av1_enable),
	.l_av1_aib_enable                          (l_av1_aib_enable),
	.l_num_avmm1                               (l_num_avmm1),
	.l_av1_ifaces                              (l_av1_ifaces),
	.l_av1_addr_bits                           (l_av1_addr_bits)
  ) dphy_avmm1_inst (

    .reconfig_pdp_clk                              ( (avmm1_jtag_enable) ? ftile_dphy_adme_avmm1_clk           : reconfig_pdp_clk),
    .reconfig_pdp_reset                            ( (avmm1_jtag_enable) ? ftile_dphy_adme_avmm1_reset         : reconfig_pdp_reset),
    .reconfig_pdp_address                          ( (avmm1_jtag_enable) ? ftile_dphy_adme_avmm1_address       : reconfig_pdp_address_cw),
    .reconfig_pdp_byteenable                       ( (avmm1_jtag_enable) ? ftile_dphy_adme_avmm1_byteenable    : reconfig_pdp_byteenable_cw),     
    .reconfig_pdp_write                            ( (avmm1_jtag_enable) ? ftile_dphy_adme_avmm1_write         : reconfig_pdp_write_cw),           
    .reconfig_pdp_read                             ( (avmm1_jtag_enable) ? ftile_dphy_adme_avmm1_read          : reconfig_pdp_read_cw),            
    .reconfig_pdp_writedata                        ( (avmm1_jtag_enable) ? ftile_dphy_adme_avmm1_writedata     : reconfig_pdp_writedata_cw),      
    .reconfig_pdp_readdata                         ( dphy_avmm1_readdata      ),       
    .reconfig_pdp_waitrequest                      ( dphy_avmm1_waitrequest   ),     
    .reconfig_pdp_readdatavalid                    ( dphy_avmm1_readdatavalid ), 

// AVMM1 ports
    .pld_avmm1_busy                                ( pld_avmm1_busy ),
    .pld_avmm1_clk_rowclk                          ( pld_avmm1_clk_rowclk ),
    .pld_avmm1_cmdfifo_wr_full                     ( pld_avmm1_cmdfifo_wr_full ),
    .pld_avmm1_cmdfifo_wr_pfull                    ( pld_avmm1_cmdfifo_wr_pfull ),
    .pld_avmm1_read                                ( pld_avmm1_read ),
    .pld_avmm1_readdata                            ( pld_avmm1_readdata ),
    .pld_avmm1_readdatavalid                       ( pld_avmm1_readdatavalid ),
    .pld_avmm1_reg_addr                            ( pld_avmm1_reg_addr ),
    .pld_avmm1_request                             ( pld_avmm1_request ),
    .pld_avmm1_reserved_in                         ( pld_avmm1_reserved_in ),
    .pld_avmm1_reserved_out                        ( pld_avmm1_reserved_out ),
    .pld_avmm1_write                               ( pld_avmm1_write ),
    .pld_avmm1_writedata                           ( pld_avmm1_writedata ),
    .pld_chnl_cal_done                             ( pld_chnl_cal_done ),
    .pld_hssi_osc_transfer_en                      ( pld_hssi_osc_transfer_en ),  
// ctrl/status
    .dphy_reset_soft_tx_rst                        (dphy_reset_soft_tx_rst),
    .dphy_reset_tx_rst_ovr                         (dphy_reset_tx_rst_ovr),
    .dphy_reset_soft_rx_rst                        (dphy_reset_soft_rx_rst),
    .dphy_reset_rx_rst_ovr                         (dphy_reset_rx_rst_ovr),
    .dphy_reset_status_tx_rst_ack_n_i              (tx_reset_ack),
    .dphy_reset_status_rx_rst_ack_n_i              (rx_reset_ack),
    .dphy_reset_status_tx_ready_i                  (tx_ready),
    .dphy_reset_status_rx_ready_i                  (rx_ready),
    .phy_tx_pll_locked_tx_pll_locked_i             (tx_pll_locked),
    .phy_rx_cdr_locked_rx_cdr_locked_i             (rx_is_lockedtoref),
    .phy_rx_cdr_locked_rx_cdr_locked2data_i        (rx_is_lockedtodata),
    .src_ctrl_rx_ignore_locked2data                (w_src_ctrl_rx_ignore_locked2data),
// cw bin counter	
	.reset_swcwbin 						    (cwbin_rst),
	.cwbin0_stat_block_A_i					(cwbin0A_out),
	.cwbin1_stat_block_A_i					(cwbin1A_out),
	.cwbin2_stat_block_A_i					(cwbin2A_out),
	.cwbin3_stat_block_A_i					(cwbin3A_out),
	.cwbin0_stat_block_B_i					(cwbin0B_out),
	.cwbin1_stat_block_B_i					(cwbin1B_out),
	.cwbin2_stat_block_B_i					(cwbin2B_out),
	.cwbin3_stat_block_B_i					(cwbin3B_out),
    .cwbin_timer_timeout					(cwbin_timer_timeout)
  );

///GPON arbitator


   logic                       cpi_cmn_busy_real_reg;
   logic                       cpi_cmn_busy_real_reg1;
   logic                       cpi_cmn_busy_real_reg2;
   logic                       cpi_cmn_busy_real_neg_edge;  
   logic                       avmm_reset;
   logic                       avmm_write    ; 
   logic [l_av2_addr_bits-1:0] avmm_address  ; 
   logic [3:0]                 avmm_byteenable;
   logic [31:0]                avmm_writedata ;
   logic [31:0]                dphy_avmm2_readdata_gpon;
   logic                       avmm_waitrequest;
   logic                       avmm_clk='d0;
   logic                       avmm_read;  
   logic                       avmm_read_reg;
   logic                       avmm_read_negedge;
   logic  [31:0]               store_data;
   logic                       count_test;
   logic                       osc_clk;
   logic [l_num_avmm2-1:0]     cnoc_clk;
//xcvr pass for GPON							
   logic [3:0]                 m32_byteenable_gpon;
   logic [31:0]                m32_writedata_gpon; 
   logic                       m32_write_gpon ; 
   logic [l_av2_addr_bits-1:0] m32_address_gpon; 
   logic                       reconfig_clk_gpon;
   logic                       reconfig_reset_gpon;
   logic                       m32_read_gpon;
   
   logic [3:0]                 m32_byteenable_gpon1;
   logic [31:0]                m32_writedata_gpon1; 
   logic                       m32_write_gpon1 ; 
   logic [l_av2_addr_bits-1:0] m32_address_gpon1; 
   logic                       m32_read_gpon1;
	
	
//ADME pass for GPON
   logic [3:0]                 adme_m32_byteenable_gpon;
   logic [31:0]                adme_m32_writedata_gpon; 
   logic                       adme_m32_write_gpon ; 
   logic [l_av2_addr_bits-1:0] adme_m32_address_gpon; 
   logic                       adme_reconfig_clk_gpon;
   logic                       adme_reconfig_reset_gpon;
   logic                       adme_m32_read_gpon;
 
   logic [3:0]                 adme_m32_byteenable_gpon1;
   logic [31:0]                adme_m32_writedata_gpon1; 
   logic                       adme_m32_write_gpon1 ; 
   logic [l_av2_addr_bits-1:0] adme_m32_address_gpon1; 
   logic                       adme_m32_read_gpon1;

dphy_f_avmm2 #(
	.num_sys_cop                               (num_sys_cop),
	.num_xcvr_per_sys                          (num_xcvr_per_sys),
	.l_num_aib_per_xcvr                        (l_num_aib_per_xcvr),
	.l_sys_xcvrs                               (l_sys_xcvrs),
        .l_tx_enable                               (l_tx_enable),
	.l_rx_enable                               (l_rx_enable),
	.avmm2_split                               (avmm2_split),
        .avmm2_readdv_enable                       (avmm2_readdv_enable),
	.l_av2_enable                              (avmm2_enable_or_gpon),
	.l_num_avmm2                               (l_num_avmm2),
	.l_av2_ifaces                              (l_av2_ifaces),
	.l_av2_addr_bits                           (l_av2_addr_bits)
  ) dphy_avmm2_inst (
 
    .reconfig_clk                                  (i_common_avmm2_clk),
    .reconfig_reset                                ((avmm2_jtag_enable) ?  ((bb_f_ux_tx_tuning_hint =="TX_TUNING_HINT_GPON") ? adme_reconfig_reset_gpon : ftile_dphy_adme_avmm2_reset)      : ((bb_f_ux_tx_tuning_hint =="TX_TUNING_HINT_GPON") ? reconfig_reset_gpon : reconfig_reset )),
    .reconfig_address                              ((avmm2_jtag_enable) ?  ((bb_f_ux_tx_tuning_hint =="TX_TUNING_HINT_GPON") ? adme_m32_address_gpon1    : ftile_dphy_adme_avmm2_address)    : ((bb_f_ux_tx_tuning_hint =="TX_TUNING_HINT_GPON") ? m32_address_gpon1    : reconfig_address   )),
    .reconfig_byteenable                           ((avmm2_jtag_enable) ?  ((bb_f_ux_tx_tuning_hint =="TX_TUNING_HINT_GPON") ? adme_m32_byteenable_gpon1 : ftile_dphy_adme_avmm2_byteenable) : ((bb_f_ux_tx_tuning_hint =="TX_TUNING_HINT_GPON") ? m32_byteenable_gpon1 : reconfig_byteenable )),
    .reconfig_write                                ((avmm2_jtag_enable) ?  ((bb_f_ux_tx_tuning_hint =="TX_TUNING_HINT_GPON") ? adme_m32_write_gpon1      : ftile_dphy_adme_avmm2_write)      : ((bb_f_ux_tx_tuning_hint =="TX_TUNING_HINT_GPON") ? m32_write_gpon1      : reconfig_write )),                    
    .reconfig_read                                 ((avmm2_jtag_enable) ?  ((bb_f_ux_tx_tuning_hint =="TX_TUNING_HINT_GPON") ? adme_m32_read_gpon1       : ftile_dphy_adme_avmm2_read)       : ((bb_f_ux_tx_tuning_hint =="TX_TUNING_HINT_GPON") ? m32_read_gpon1       : reconfig_read   )),
    .reconfig_writedata                            ((avmm2_jtag_enable) ?  ((bb_f_ux_tx_tuning_hint =="TX_TUNING_HINT_GPON") ? adme_m32_writedata_gpon1  : ftile_dphy_adme_avmm2_writedata)  : ((bb_f_ux_tx_tuning_hint =="TX_TUNING_HINT_GPON") ? m32_writedata_gpon1  : reconfig_writedata   )),
    .reconfig_readdata                             ( dphy_avmm2_readdata      ),       
    .reconfig_waitrequest                          ( dphy_avmm2_waitrequest   ),     
    .reconfig_readdatavalid                        ( dphy_avmm2_readdatavalid ), 

  //  for AVMM2 bb ports
    .hip_avmm_read                                 ( hip_avmm_read              ),   
    .hip_avmm_readdata                             ( hip_avmm_readdata          ),
    .hip_avmm_readdatavalid                        ( hip_avmm_readdatavalid     ),
    .hip_avmm_reg_addr                             ( hip_avmm_reg_addr          ),
    .hip_avmm_reserved_out                         ( hip_avmm_reserved_out      ),
    .hip_avmm_write                                ( hip_avmm_write             ),
    .hip_avmm_writedata                            ( hip_avmm_writedata         ),
    .hip_avmm_writedone                            ( hip_avmm_writedone         ),
    .pld_avmm2_busy                                ( pld_avmm2_busy             ),
    .pld_avmm2_clk_rowclk                     (),     //( pld_avmm2_clk_rowclk       ),
    .pld_avmm2_cmdfifo_wr_full                     ( pld_avmm2_cmdfifo_wr_full  ),
    .pld_avmm2_cmdfifo_wr_pfull                    ( pld_avmm2_cmdfifo_wr_pfull ),
    .pld_avmm2_request                             ( pld_avmm2_request          ),
    .pld_pll_cal_done                              ( pld_pll_cal_done           ),
    .pld_avmm2_write                               ( pld_avmm2_write            ),
    .pld_avmm2_read                                ( pld_avmm2_read             ),
    .pld_avmm2_reg_addr                            ( pld_avmm2_reg_addr         ),
    .pld_avmm2_readdata                            ( pld_avmm2_readdata         ),
    .pld_avmm2_writedata                           ( pld_avmm2_writedata        ),
    .pld_avmm2_readdatavalid                       ( pld_avmm2_readdatavalid    ),
    .pld_avmm2_reserved_in                         ( pld_avmm2_reserved_in      ),
    .pld_avmm2_reserved_out                        ( pld_avmm2_reserved_out     )
    
  );

assign pld_avmm2_clk_rowclk=  (avmm2_jtag_enable ) ? {l_num_avmm2{ftile_dphy_adme_avmm2_clk[0]}} : (l_av2_enable) ? {l_num_avmm2{reconfig_clk[0]}} : (bb_f_ux_tx_tuning_hint =="TX_TUNING_HINT_GPON") ? cnoc_clk :{l_num_avmm2{1'b0}};

assign cnoc_clk= {l_num_avmm2{avmm_clk}};
/*  logic [9:0] count=0 ;
  always_ff@ (posedge i_common_avmm2_clk)
    begin 
	  if (count==10'd511)
	    count<=count;
	  else
	    count<=count+1'b1;
	end
 
assign avmm_reset_config= (count==10'd511) ? 0 : 1;
*/

if (bb_f_ux_tx_tuning_hint =="TX_TUNING_HINT_GPON" ) begin: GPON_AVMM

assign avmm_reset=rx_reset[0] || tx_reset[0];


 `ifndef ALTERA_RESERVED_QIS
   initial begin
    avmm_clk = 1'b0;
  end
  always begin
    #2ns avmm_clk = ~avmm_clk;
  end
`else
  altera_config_clock_source_endpoint clock_endpoint (
    .clk(avmm_clk)
    );
`endif // ifndef ALTERA_RESERVED_QIS
// cpi_cmn_busy_real_reg from hip 

always_ff @(posedge i_common_avmm2_clk)
begin 
    avmm_read_reg<=avmm_read; 
end 
    assign avmm_read_negedge= (!avmm_read && avmm_read_reg) ? 1'b1 :1'b0;

 always_ff @(posedge i_common_avmm2_clk)
begin 
  if (avmm_read_negedge)
    store_data<=dphy_avmm2_readdata; 
  end  
 //2 FF synchronizer 
  always_ff @(posedge i_common_avmm2_clk ) begin                 //need to check how to connect this clock as avmm 
       cpi_cmn_busy_real_reg      <= cpi_cmn_busy_real[0];
	   cpi_cmn_busy_real_reg1     <= cpi_cmn_busy_real_reg;
	   cpi_cmn_busy_real_reg2     <= cpi_cmn_busy_real_reg1;
    end
 assign cpi_cmn_busy_real_neg_edge = ((~cpi_cmn_busy_real_reg1) && cpi_cmn_busy_real_reg2 ) ? 1'b1 : 1'b0;
 
 
 always_ff @(posedge i_common_avmm2_clk ) 
   begin 
     if (count_test==1'b1)
       count_test<=count_test;
     else if (cpi_cmn_busy_real_neg_edge)
       count_test<=count_test+1'b1;
     else
       count_test<=1'b0;
   end

   /// 3bit state enum data type for state machine 
   enum logic [3:0] {ST_IDLE,ST_START,ST_READ0,ST_PASS0,ST_WRITE0,ST_WRITE_check0,ST_READ_check0,ST_READ1,ST_PASS1,ST_WRITE1,ST_WRITE_check1,ST_READ_check1,ST_WAIT} cur_st, next_st; 
 // Next state transtion for melay state machine  
  always_ff @(posedge i_common_avmm2_clk ) begin  //need to check how to connect this clock as avmm
   if(avmm_reset) begin                 // tx_reset or rx_reset required to do reset 
      cur_st     <= ST_IDLE;
   end else begin
       cur_st     <= next_st;
    end
 end
 
 always_ff @(posedge i_common_avmm2_clk  ) begin  //need to check how to connect this clock as avmm
   if(adme_reconfig_reset_gpon) begin            
      adme_m32_byteenable_gpon1<=0;
      adme_m32_writedata_gpon1 <=0;
      adme_m32_write_gpon1     <=0;
      adme_m32_address_gpon1   <=0;
      adme_m32_read_gpon1      <=0;
	end else begin
	   adme_m32_byteenable_gpon1<=adme_m32_byteenable_gpon;
	   adme_m32_writedata_gpon1 <=adme_m32_writedata_gpon;
      adme_m32_write_gpon1     <=adme_m32_write_gpon;
      adme_m32_address_gpon1   <=adme_m32_address_gpon;
      adme_m32_read_gpon1      <=adme_m32_read_gpon;
	end
end		
 
 always_ff @(posedge i_common_avmm2_clk ) begin  //need to check how to connect this clock as avmm
   if(reconfig_reset_gpon) begin            
      m32_byteenable_gpon1<=0;
      m32_writedata_gpon1 <=0;
      m32_write_gpon1     <=0;
      m32_address_gpon1   <=0;
      m32_read_gpon1      <=0;
	end else begin
	   m32_byteenable_gpon1<=m32_byteenable_gpon;
	   m32_writedata_gpon1 <=m32_writedata_gpon;
      m32_write_gpon1     <=m32_write_gpon;     
      m32_address_gpon1   <=m32_address_gpon;   
      m32_read_gpon1      <=m32_read_gpon;      
	end
end	 

 
/// mealay state machine 
always_comb  
  begin  // intilization for all the logic.
     avmm_write = 1'b0;
	 avmm_read  = 1'b0;
     avmm_address =18'h0;
     avmm_byteenable =4'b0;
     avmm_writedata =32'h0;
     next_st      = ST_IDLE;
  case (cur_st) 
    ST_IDLE: 
	begin  // intilize logic
           avmm_write = 1'b0;
           avmm_address =18'h0;
           avmm_byteenable =4'b0;
           avmm_writedata =32'h0;
           next_st = ST_START;
    end
	ST_START:  
	    begin // wait for cpi_cmn_busy_real negedge
	       avmm_write = 1'b0;
           avmm_address =18'h0;
           avmm_byteenable =4'b0;
           avmm_writedata =32'h0;
		 if (!cpi_cmn_busy_real_reg2 && count_test==1'b1)		
             next_st = ST_READ0;
		   else
             next_st = ST_START;
        end    
    ST_READ0:
	 begin // start write for cfg_srds_dsp_rx_swrstn reg
            if (avmm_waitrequest) begin
              avmm_write = 1'b0;
			  avmm_read  = 1'b1;
              avmm_address =18'h18800;
              avmm_byteenable =4'b1111;
              avmm_writedata =32'h0;
              next_st = ST_READ0;
		    end else begin 
	          avmm_write = 1'b0;
			  avmm_read  = 1'b0;
              avmm_byteenable =4'b0000;
		      next_st = ST_PASS0;	
            end 	     
        end
	ST_PASS0:
	  begin 
	    next_st = ST_WRITE0;
	  end 
	ST_WRITE0: 
	    begin // start write for cfg_srds_dsp_rx_swrstn reg
            if (avmm_waitrequest) begin
              avmm_write = 1'b1;
			  avmm_read  = 1'b0;
              avmm_address =18'h18800;
              avmm_byteenable =4'b1111;
              avmm_writedata ={store_data[31:17], 1'b1, store_data[15:0]};
              next_st = ST_WRITE0;
		    end else begin 
	          avmm_write = 1'b0;
              avmm_byteenable =4'b0000;
		      next_st = ST_WRITE_check0;	
            end 	     
        end
    ST_WRITE_check0: 
	    begin   // wait for register to write 
            if (avmm_waitrequest) begin
              next_st = ST_READ1;
            end else begin
              next_st = ST_WRITE_check0;
            end
        end					
	ST_READ1: 
	    begin // start write for cfg_srds_dsp_rx_swrstn reg
            if (avmm_waitrequest) begin
              avmm_write = 1'b0;
			  avmm_read  = 1'b1;
              avmm_address =18'h18801;
              avmm_byteenable =4'b1111;
              avmm_writedata =32'h0;
              next_st = ST_READ1;
		    end else begin 
	          avmm_write = 1'b0;
			  avmm_read  = 1'b0;
              avmm_byteenable =4'b0000;
		      next_st = ST_PASS1;	
            end 	     
        end
    ST_PASS1:
	  begin 
	    next_st = ST_WRITE1;
	  end 		
    ST_WRITE1:
        begin  // start write cfg_srds_dsp_rx_clken reg 
            if (avmm_waitrequest) begin
              avmm_write = 1'b1;
			  avmm_read  = 1'b0;
              avmm_address =18'h18801;
              avmm_byteenable =4'b1111;
              avmm_writedata ={store_data[31:13], 1'b1, store_data[11:0]};
              next_st = ST_WRITE1;
		    end else begin 
	          avmm_write = 1'b0;
              avmm_byteenable =4'b0000;
		      next_st = ST_WRITE_check1;	
            end 	     
        end
    ST_WRITE_check1: 
	    begin  // wait for register to write 
            if (avmm_waitrequest) begin
              next_st = ST_WAIT;
            end
            else begin
              next_st = ST_WRITE_check1;
            end
        end
	ST_WAIT:
		begin // wait untill next reset asserted.
		  next_st=ST_WAIT;
		end
  endcase
end

  


        // All the avmm2 port should be arbitate by apporipritely considering user avmm.
		

         assign avmm_waitrequest         =  dphy_avmm2_waitrequest  ; 		 
         assign m32_write_gpon           = (cur_st!=ST_WAIT ) ? avmm_write        :reconfig_write    ;
         assign m32_address_gpon         = (cur_st!=ST_WAIT ) ? avmm_address      :reconfig_address    ;
         assign m32_byteenable_gpon      = (cur_st!=ST_WAIT ) ? avmm_byteenable   : reconfig_byteenable ;
         assign m32_writedata_gpon       = (cur_st!=ST_WAIT ) ? avmm_writedata    :reconfig_writedata  ;
         assign reconfig_reset_gpon      = (cur_st!=ST_WAIT ) ? (avmm_reset || reconfig_reset[0])        :reconfig_reset ;
         assign m32_read_gpon            = (cur_st!=ST_WAIT ) ? avmm_read         : reconfig_read;
         assign dphy_avmm2_readdata_gpon =  dphy_avmm2_readdata;
		 
         assign adme_m32_write_gpon           = (cur_st!=ST_WAIT ) ? avmm_write        :ftile_dphy_adme_avmm2_write    ;
         assign adme_m32_address_gpon         = (cur_st!=ST_WAIT ) ? avmm_address      :ftile_dphy_adme_avmm2_address    ;
         assign adme_m32_byteenable_gpon      = (cur_st!=ST_WAIT ) ? avmm_byteenable   : ftile_dphy_adme_avmm2_byteenable ;
         assign adme_m32_writedata_gpon       = (cur_st!=ST_WAIT ) ? avmm_writedata    :ftile_dphy_adme_avmm2_writedata  ;
         assign adme_reconfig_reset_gpon      = (cur_st!=ST_WAIT ) ? (avmm_reset || ftile_dphy_adme_avmm2_reset[0])        :ftile_dphy_adme_avmm2_reset ;
	 assign adme_m32_read_gpon            = (cur_st!=ST_WAIT ) ? avmm_read         : ftile_dphy_adme_avmm2_read;
		 


end



////////CWBIN COUNTER IMPLEMENTATION
	 
generate
	 if (enable_soft_cwbin) begin: GEN_SOFT_CWBIN_AVMM
logic stats_snapshot_sync;
	 
  alt_xcvr_resync_etile #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (1)
      //.INIT_VALUE         (0)
  ) stats_snapshot_sync_inst (
      .clk                (reconfig_pdp_clk),
      .reset              (1'b0),
      .d                  (|fec_snapshot),
      .q                  (stats_snapshot_sync)
  );
 
 logic o_stats_snapshot_1; 
 
 always @ (posedge reconfig_pdp_clk) begin
 o_stats_snapshot_1 <= o_stats_snapshot;
 end

alt_xcvr_resync_etile #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (1),
      .INIT_VALUE         (0)
  ) o_stats_snapshot_sync_inst (
      .clk                (|tx_coreclkin),
      .reset              (1'b0),
      .d                  (o_stats_snapshot_1),
      .q                  (o_stats_snapshot_sync)
  ); 
  
  
 genvar ig;
     for(ig=0;ig<num_sys_cop;ig=ig+1) begin:soft_cwbin  
  
directphy_f_soft_cwbin_counter
#(
    .TIMEOUT_COUNT (cwbin_timeout_count), //14us timer, 1400 for 100MHZ reconfig clock, 3500 for 250MHz clock
    .ADDR_WIDTH  (14)
) soft32bit_cwbin0_3
(
    .i_reconfig_clk					(reconfig_pdp_clk[ig]), 
    .i_reset				        (~rx_ready[ig]),
    .i_reconfig_reset				(reconfig_pdp_reset[ig]),
	 .i_stats_snapshot				(stats_snapshot_sync),
	 .i_ehip_rate                   (EHIP_RATE_CSR),
	 .i_fec_enable                   (1'b1), // fixed to 1 for baseIP and used for MRIP
    .i_reconfig_write					(reconfig_pdp_write[ig]),
    .i_reconfig_byteenable			(reconfig_pdp_byteenable[ig*4+:4]),	
    .i_reconfig_read					(reconfig_pdp_read[ig]),
    .i_reconfig_addr					(reconfig_pdp_address[ig*l_av1_addr_bits+:l_av1_addr_bits]),
    .i_reconfig_writedata			(reconfig_pdp_writedata[ig*32+:32]),
    .o_reconfig_readdata				(reconfig_pdp_readdata[ig*32+:32]),		
    .o_reconfig_readdata_valid		(reconfig_pdp_readdatavalid[ig]),
    .o_reconfig_waitrequest			(reconfig_pdp_waitrequest[ig]),
	 .o_stats_snapshot            (o_stats_snapshot),
    .o_rcfg_write						(reconfig_pdp_write_cw[ig]),
    .o_rcfg_byteenable				(reconfig_pdp_byteenable_cw[ig*4+:4]),
    .o_rcfg_read						(reconfig_pdp_read_cw[ig]),
    .o_rcfg_addr						(reconfig_pdp_address_cw[ig*l_av1_addr_bits+:l_av1_addr_bits]),
    .o_rcfg_writedata					(reconfig_pdp_writedata_cw[ig*32+:32]),
    .i_rcfg_readdata					(reconfig_pdp_readdata_cw[ig*32+:32]),
    .i_rcfg_readdata_valid			(reconfig_pdp_readdata_valid_cw[ig]),
    .i_rcfg_waitrequest				(reconfig_pdp_waitrequest_cw[ig]),
	 .cwbin_rst							(cwbin_rst[ig]),
	 .cwbin0A_out						(cwbin0A_out[ig*32+:32]),
    .cwbin1A_out						(cwbin1A_out[ig*32+:32]),
	 .cwbin2A_out						(cwbin2A_out[ig*32+:32]),
	 .cwbin3A_out						(cwbin3A_out[ig*32+:32]),
	 .cwbin0B_out						(cwbin0B_out[ig*32+:32]),
    .cwbin1B_out						(cwbin1B_out[ig*32+:32]),
	 .cwbin2B_out						(cwbin2B_out[ig*32+:32]),
	 .cwbin3B_out						(cwbin3B_out[ig*32+:32]),
	 .cwbin_timer_timeout			    (cwbin_timer_timeout[ig*32+:32])
 
); 
 end
	end
    else 
    begin: NO_SOFT_CWBIN_AVMM
	             assign  reconfig_pdp_address_cw            =   reconfig_pdp_address;
                assign  reconfig_pdp_byteenable_cw       =   reconfig_pdp_byteenable;
                assign  reconfig_pdp_read_cw             =   reconfig_pdp_read;
                assign  reconfig_pdp_write_cw            =   reconfig_pdp_write;
                assign  reconfig_pdp_writedata_cw        =   reconfig_pdp_writedata;
                assign  reconfig_pdp_readdatavalid       =   reconfig_pdp_readdata_valid_cw ;
                assign  reconfig_pdp_readdata            =   reconfig_pdp_readdata_cw;
                assign  reconfig_pdp_waitrequest         =   reconfig_pdp_waitrequest_cw ; 
					 
					 assign o_stats_snapshot = 1'b0;
					 assign o_stats_snapshot_sync = |fec_snapshot;
					 assign cwbin0A_out = 32'h0;
					 assign cwbin1A_out = 32'h0;
					 assign cwbin2A_out = 32'h0;
					 assign cwbin3A_out = 32'h0;
					 assign cwbin0B_out = 32'h0;
					 assign cwbin1B_out = 32'h0;
					 assign cwbin2B_out = 32'h0;
					 assign cwbin3B_out = 32'h0;
					 
					 
					 
	 
    end		
    endgenerate


endmodule

// Change log:
//    HSD:22010528537   Driven by Reset Controller
//    HSD:<id>          <comment>











