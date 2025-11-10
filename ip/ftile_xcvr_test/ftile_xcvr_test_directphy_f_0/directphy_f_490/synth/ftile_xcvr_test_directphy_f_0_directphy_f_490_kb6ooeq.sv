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


`timescale 1 ps/1 ps
(* altera_attribute = "-name UNCONNECTED_OUTPUT_PORT_MESSAGE_LEVEL OFF" *)
module ftile_xcvr_test_directphy_f_0_directphy_f_490_kb6ooeq #(
    parameter          avmm1_jtag_enable    = 0,
    parameter          avmm1_split          = 0,
    parameter          avmm1_readdv_enable  = 1,
    parameter          avmm2_enable         = 0,
    parameter          avmm2_jtag_enable    = 0,
    parameter          avmm2_split          = 0,
    parameter          avmm2_readdv_enable  = 0,
    parameter          device_revision      = "10nm6agdra",
    parameter          silicon_revision     = "10nm6agdra",
    parameter          l_av1_enable         = 0,
    parameter          l_av1_aib_enable     = 0,
    parameter          l_soft_csr_enable    = 0,
    parameter          l_line_rate_p1ghz    = 250,
    parameter          l_av1_addr_bits      = 14,
    parameter          l_av1_ifaces         = 1,
    parameter          l_av2_addr_bits      = 18,
    parameter          l_av2_ifaces         = 1,
    parameter          l_num_aib_per_xcvr   = 1,
    parameter          l_num_avmm1          = 1,
    parameter          l_num_avmm2          = 1,
    parameter          l_rx_enable          = 1,
    parameter          l_sys_aibs           = 1,
    parameter          l_sys_xcvrs          = 1,
    parameter          l_sys_xcvrs_cascade  = 1,
    parameter          fgt_protocol_mode    = "DISABLED",
    parameter          l_tx_enable          = 1,
    parameter          num_sys_cop          = 1,
    parameter          num_xcvr_per_sys     = 1,
    parameter          fgt_serdes_lpbk_mode  = "LOOPBACK_MODE_DISABLED",
    parameter          pma_width            = 32,
    parameter          l_num_hip_per_sys    = 1,
    parameter          tx_custom_cadence_enable = 0,
    parameter          enable_port_tx_cadence_slow_clk_locked = 0,

  // CDR Clockout:
    parameter          enable_port_fgt_rx_cdr_divclk_link0  = 0,
    parameter          enable_port_fgt_rx_cdr_divclk_link1  = 0,
    parameter          fgt_rx_cdr_divclk_link0_sel          = 0,
    parameter          fgt_rx_cdr_divclk_link1_sel          = 0,

//  PLD Interface:
    parameter          pldif_tx_coreclkin_clock_network       = "rowclk",     // "dedicated:Dedicated Clock" "rowclk:Global Clock"
    parameter          pldif_rx_coreclkin_clock_network       = "rowclk",     // "dedicated:Dedicated Clock" "rowclk:Global Clock"
    parameter          pldif_tx_coreclkin2_clock_network      = "dedicated",  // "dedicated:Dedicated Clock" "rowclk:Global Clock"
    parameter          enable_port_tx_clkin2                  = 0,    


//  Building block attributes:

 //### FGT XCVR RX/TX PLL attributes:  controlled by computation code.
    parameter          bb_m_silicon_rev                       = "10nm6agdra",

    parameter          bb_m_hdpldadapt_rx_fifo_mode           = "PHASE_COMP",
    parameter          bb_m_hdpldadapt_rx_fifo_width          = "FIFO_SINGLE_WIDTH",
    parameter          bb_m_hdpldadapt_rx_pld_clk1_sel        = "PLD_CLK1_ROWCLK",
    parameter          bb_m_hdpldadapt_rx_hdpldadapt_speed_grade	=	"HDPLDADAPT_DASH_2"	,
    parameter          bb_m_hdpldadapt_rx_rxfifo_pempty       = 2,
    parameter          bb_m_hdpldadapt_rx_rxfifo_pfull        = 48,
    parameter          bb_m_hdpldadapt_rx_rx_datapath_tb_sel  = "PCS_CHNL_TB",

    parameter          bb_m_hdpldadapt_tx_duplex_mode         = "ENABLE",
    parameter          bb_m_hdpldadapt_tx_fifo_mode           = "PHASE_COMP",
    parameter          bb_m_hdpldadapt_tx_fifo_width          = "FIFO_SINGLE_WIDTH",
    parameter          bb_m_hdpldadapt_tx_pld_clk1_sel        = "PLD_CLK1_ROWCLK",
    parameter          bb_m_hdpldadapt_tx_hdpldadapt_speed_grade	=	"HDPLDADAPT_DASH_2"	,
    parameter          bb_m_hdpldadapt_tx_txfifo_pempty       = 2,
    parameter          bb_m_hdpldadapt_tx_txfifo_pfull        = 24,
    parameter          bb_m_hdpldadapt_tx_pld_clk2_sel        = "PLD_CLK2_DCM",
    parameter          bb_m_hdpldadapt_tx_tx_datapath_tb_sel  = "TX_FIFO_TB1",

    parameter          bb_m_hdpldadapt_rx_hdpldadapt_pld_rx_clk1_dcm_hz       = 0,
    parameter          bb_m_hdpldadapt_rx_hdpldadapt_pld_rx_clk1_rowclk_hz    = 0,
    parameter          bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz       = 0,
    parameter          bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk1_rowclk_hz    = 0,
    parameter          bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk2_dcm_hz       = 0,
    parameter          bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk2_rowclk_hz    = 0,


    parameter          bb_f_ehip_aib2_rx_st_clk_en            = "AIB2_RX_ST_CLK_EN_TX_BOND_CLK",
    parameter          bb_f_ehip_aib2_tx_st_clk_en            = "AIB2_TX_ST_CLK_EN_TX_BOND_CLK",
    parameter          bb_f_ehip_aib3_rx_st_clk_en            = "AIB3_RX_ST_CLK_EN_RX_WORD_CLK",  // TODO:  GUI control.  default for pmadir1-enh 
    parameter          bb_f_ehip_aib3_tx_st_clk_en            = "AIB3_TX_ST_CLK_EN_TX_WORD_CLK",  // TODO:  GUI control.  default for pmadir1-enh

    parameter          bb_f_aib_aibadapt_rx_rx_user_clk_sel   = "AIBADAPT_RX_RX_USER_CLK_EHIP_DIV2",  // TODO:  GUI control.  default for pmadir1-enh
    parameter          bb_f_aib_aibadapt_tx_tx_user_clk_sel   = "AIBADAPT_TX_TX_USER_CLK_EHIP_DIV2",  // TODO:  GUI control.  default for pmadir1-enh

    parameter bb_f_aib_aib_tx_user_clk_hz                                                          = 0,
    parameter bb_f_aib_aib_rx_user_clk_hz                                                          = 0,


 //### FGT XCVR RX/TX PLL attributes:  controlled by computation code.
    parameter          fgt_tx_pll_manual_enable               = 0,
    parameter          fgt_rx_pll_manual_enable               = 0,
    parameter          fgt_tx_pll_cascade_enable              = 0,
    parameter          fgt_tx_pll_frac_mode_enable            = 0,

    parameter          bb_f_ux_tx_pll                         = "__BB_DONT_CARE__",
    parameter          bb_f_ux_tx_pll_bw_sel                  = "__BB_DONT_CARE__",

    parameter          bb_f_ux_synth_lc_fast_f_out_hz         = "0",
    parameter          bb_f_ux_synth_lc_fast_f_vco_hz         = "0",
    parameter          bb_f_ux_synth_lc_fast_f_ref_hz         = 0,
    parameter          bb_f_ux_synth_lc_fast_fractional_en    = "__BB_DONT_CARE__",
    parameter          bb_f_ux_synth_lc_fast_k_counter        = 0,
    parameter          bb_f_ux_synth_lc_fast_l_counter        = 0,
    parameter          bb_f_ux_synth_lc_fast_m_counter        = 0,
    parameter          bb_f_ux_synth_lc_fast_n_counter        = 0,
    parameter          bb_f_ux_synth_lc_fast_primary_use      = "__BB_DONT_CARE__",

    parameter          bb_f_ux_synth_lc_med_f_out_hz          = "0",
    parameter          bb_f_ux_synth_lc_med_f_vco_hz          = "0",
    parameter          bb_f_ux_synth_lc_med_f_ref_hz          = 0,
    parameter          bb_f_ux_synth_lc_med_fractional_en     = "__BB_DONT_CARE__",
    parameter          bb_f_ux_synth_lc_med_k_counter         = 0,
    parameter          bb_f_ux_synth_lc_med_l_counter         = 0,
    parameter          bb_f_ux_synth_lc_med_m_counter         = 0,
    parameter          bb_f_ux_synth_lc_med_n_counter         = 0,
    parameter          bb_f_ux_synth_lc_med_primary_use       = "__BB_DONT_CARE__",

    parameter          bb_f_ux_synth_lc_slow_f_out_hz         = "0",
    parameter          bb_f_ux_synth_lc_slow_f_vco_hz         = "0",
    parameter          bb_f_ux_synth_lc_slow_f_ref_hz         = 0,
    parameter          bb_f_ux_synth_lc_slow_fractional_en    = "__BB_DONT_CARE__",
    parameter          bb_f_ux_synth_lc_slow_k_counter        = 0,
    parameter          bb_f_ux_synth_lc_slow_l_counter        = 0,
    parameter          bb_f_ux_synth_lc_slow_m_counter        = 0,
    parameter          bb_f_ux_synth_lc_slow_n_counter        = 0,
    parameter          bb_f_ux_synth_lc_slow_primary_use      = "__BB_DONT_CARE__",

    parameter          bb_f_ux_cdr_bw_sel                     = "__BB_DONT_CARE__",
    parameter          bb_f_ux_cdr_f_out_hz                   = "0",
    parameter          bb_f_ux_cdr_f_vco_hz                   = "0",
    parameter          bb_f_ux_cdr_f_ref_hz                   = 0,
    parameter          bb_f_ux_cdr_l_counter                  = 0,
    parameter          bb_f_ux_cdr_m_counter                  = 0,
    parameter          bb_f_ux_cdr_n_counter                  = 0,
    parameter          bb_f_ux_tx_fb_div_emb_mult_counter     = 0,
	
	
    //### FGT PLL Cascades:
    parameter          targettype_bb_f_ux_tx_pll                         = "__BB_DONT_CARE__",
    parameter          targettype_bb_f_ux_tx_pll_bw_sel                  = "__BB_DONT_CARE__",
    parameter          targettype_bb_f_ux_synth_lc_fast_f_out_hz         = "0",
    parameter          targettype_bb_f_ux_synth_lc_fast_f_vco_hz         = "0",
    parameter          targettype_bb_f_ux_synth_lc_fast_f_ref_hz         = 0,
    parameter          targettype_bb_f_ux_synth_lc_fast_fractional_en    = "__BB_DONT_CARE__",
    parameter          targettype_bb_f_ux_synth_lc_fast_k_counter        = 0,
    parameter          targettype_bb_f_ux_synth_lc_fast_l_counter        = 0,
    parameter          targettype_bb_f_ux_synth_lc_fast_m_counter        = 0,
    parameter          targettype_bb_f_ux_synth_lc_fast_n_counter        = 0,
    parameter          targettype_bb_f_ux_synth_lc_fast_primary_use      = "__BB_DONT_CARE__",

    parameter          targettype_bb_f_ux_synth_lc_med_f_out_hz          = "0",
    parameter          targettype_bb_f_ux_synth_lc_med_f_vco_hz          = "0",
    parameter          targettype_bb_f_ux_synth_lc_med_f_ref_hz          = 0,
    parameter          targettype_bb_f_ux_synth_lc_med_fractional_en     = "__BB_DONT_CARE__",
    parameter          targettype_bb_f_ux_synth_lc_med_k_counter         = 0,
    parameter          targettype_bb_f_ux_synth_lc_med_l_counter         = 0,
    parameter          targettype_bb_f_ux_synth_lc_med_m_counter         = 0,
    parameter          targettype_bb_f_ux_synth_lc_med_n_counter         = 0,
    parameter          targettype_bb_f_ux_synth_lc_med_primary_use       = "__BB_DONT_CARE__",

    parameter          targettype_bb_f_ux_synth_lc_slow_f_out_hz         = "0",
    parameter          targettype_bb_f_ux_synth_lc_slow_f_vco_hz         = "0",
    parameter          targettype_bb_f_ux_synth_lc_slow_f_ref_hz         = 0,
    parameter          targettype_bb_f_ux_synth_lc_slow_fractional_en    = "__BB_DONT_CARE__",
    parameter          targettype_bb_f_ux_synth_lc_slow_k_counter        = 0,
    parameter          targettype_bb_f_ux_synth_lc_slow_l_counter        = 0,
    parameter          targettype_bb_f_ux_synth_lc_slow_m_counter        = 0,
    parameter          targettype_bb_f_ux_synth_lc_slow_n_counter        = 0,
    parameter          targettype_bb_f_ux_synth_lc_slow_primary_use      = "__BB_DONT_CARE__",
	parameter          targettype_bb_f_ux_tx_fb_div_emb_mult_counter     = 0,


 //### EHIP:

    parameter          bb_f_ehip_frac_size                                      = "F25G", 
    parameter          bb_f_ehip_duplex_mode                                    = "DUPLEX_MODE_FULL_DUPLEX", 
    parameter          bb_f_ehip_fec_mode                                       = "FEC_MODE_DISABLED", 
    parameter          bb_f_ehip_fec_spec                                       = "FEC_SPEC_DISABLED", 
    parameter          bb_f_ehip_fec_clk_src                                    = "FEC_CLK_SRC_DISABLED",
    parameter          bb_f_ehip_lpbk_mode                               = "DISABLE", 
    parameter          bb_f_ehip_lphy_xcvrif_lpbk_en                            = "DISABLE", 
    parameter          bb_f_ehip_mac_mode                                       = "MAC_MODE_DISABLED", 
    parameter          bb_f_ehip_fec_802p3ck                                    = "DISABLE", 
    
    parameter          bb_f_ehip_rx_aib_if_fifo_mode                            = "RX_AIB_IF_FIFO_MODE_PHASECOMP", 
    parameter          dec_bb_f_ehip_rx_datarate                                = "2500000000", 
    parameter          bb_f_ehip_rx_en                                          = "TRUE", 
    parameter          bb_f_ehip_rx_excvr_if_fifo_mode                          = "RX_EXCVR_IF_FIFO_MODE_ELASTIC",
    parameter          bb_f_ehip_rx_excvr_gb_ratio_mode                         = "RX_EXCVR_GB_RATIO_MODE_DISABLED",
    parameter          bb_f_ehip_rx_fec_enable                                  = "RX_FEC_ENABLE_DISABLED", 
    parameter          bb_f_ehip_rx_pcs_mode                                    = "RX_PCS_MODE_DISABLED", 
    parameter          bb_f_ehip_rx_primary_use                                 = "RX_PRIMARY_USE_DIRECT_BUNDLE", 
    parameter  [4:0]   bb_f_ehip_rx_total_xcvr                                  = 1, 
    parameter          bb_f_ehip_rx_xcvr_width                                  = "RX_XCVR_WIDTH_8", 
    parameter          bb_f_ehip_tx_pmadirect_single_width                      = "FALSE",
    parameter          bb_f_ehip_rx_pmadirect_single_width                      = "FALSE",
    parameter          bb_f_ehip_silicon_rev                                    = "gdra", 
    parameter          bb_f_ehip_speed_map                                      = "SPEED_MAP_MAP_25G", 
    parameter          bb_f_ehip_sys_clk_src                                    = "sys_clk_src_pll0",
    parameter          bb_f_ehip_tx_aib_if_fifo_mode                            = "TX_AIB_IF_FIFO_MODE_PHASECOMP", 
    parameter          dec_bb_f_ehip_tx_datarate                                = "2500000000", 
    parameter          bb_f_ehip_tx_en                                          = "TRUE", 
    parameter          bb_f_ehip_tx_excvr_if_fifo_mode                          = "TX_EXCVR_IF_FIFO_MODE_ELASTIC", 
    parameter          bb_f_ehip_tx_excvr_gb_ratio_mode                         = "TX_EXCVR_GB_RATIO_MODE_DISABLED",
    parameter          bb_f_ehip_tx_fec_enable                                  = "TX_FEC_ENABLE_DISABLED", 
    parameter          bb_f_ehip_tx_pcs_mode                                    = "TX_PCS_MODE_DISABLED", 
    parameter          bb_f_ehip_tx_primary_use                                 = "TX_PRIMARY_USE_DIRECT_BUNDLE", 
    parameter  [4:0]   bb_f_ehip_tx_total_xcvr                                  = 1, 
    parameter          bb_f_ehip_tx_xcvr_width                                  = "TX_XCVR_WIDTH_8", 
    parameter          bb_f_ehip_xcvr_mode                                      = "XCVR_MODE_NRZ",
    parameter          bb_f_ehip_xcvr_type                                      = "XCVR_TYPE_UX",
    parameter          bb_f_ehip_is_fec_part_of_reconfig                        = "FALSE",
    parameter          dec_bb_f_ux_f_out_rx_cdr_pll_hz                          = "1500000000",
    parameter          bb_f_ux_loopback_mode                                     = "LOOPBACK_MODE_DISABLED",

    parameter          bb_f_ux_rx_cdr_pll_enable_half_divider                   = "RX_CDR_PLL_ENABLE_HALF_DIVIDER_INT_DIVISION",
    parameter          bb_f_ux_rx_cdr_pll_fast_refclk_mode                      = "DISABLE",
    parameter  [7:0]   bb_f_ux_rx_cdr_pll_l_counter                             = 16,
    parameter  [7:0]   bb_f_ux_rx_cdr_pll_n_counter                             = 1,
    parameter          bb_f_ux_rx_cdr_pll_postdiv_en                            = "RX_CDR_PLL_POSTDIV_EN_1",
    parameter          dec_bb_f_ux_f_out_synth_lc_hz                            = "125000000",
    parameter          dec_bb_f_ux_f_mod_synth_lc_hz                            = "0",
    parameter          bb_f_ux_synch_lc_modula_to_ren                           = "SYNCH_LC_MODULA_TO_REN_0",
    parameter          bb_f_ux_synth_lc_enable_half_divider                     = "SYNTH_LC_ENABLE_HALF_DIVIDER_INT_DIVISION",
    parameter          bb_f_ux_synth_lc_postdiv_en                              = "SYNTH_LC_POSTDIV_EN_1",
    parameter          bb_f_ux_fractional_mode                                  = "OFF",
    parameter          bb_f_ux_cdr_postdiv_counter                              = 0,
    parameter          bb_f_ux_cdr_postdiv_fractional_en                        = "DISABLE",
    parameter          bb_f_ux_cdr_f_postdiv_hz                              = 0,
    parameter          bb_f_ux_synth_lc_fast_tx_postdiv_counter                 = 0,
    parameter          bb_f_ux_synth_lc_med_tx_postdiv_counter                  = 0,
    parameter          bb_f_ux_synth_lc_slow_tx_postdiv_counter                 = 0,
    parameter          bb_f_ux_synth_lc_fast_tx_postdiv_fractional_en              = "DISABLE",
    parameter          bb_f_ux_synth_lc_med_tx_postdiv_fractional_en               = "DISABLE",
    parameter          bb_f_ux_synth_lc_slow_tx_postdiv_fractional_en              = "DISABLE",
    parameter          bb_f_ux_synth_lc_fast_f_tx_postdiv_hz          = 0,
    parameter          bb_f_ux_synth_lc_med_f_tx_postdiv_hz           = 0,
    parameter          bb_f_ux_synth_lc_slow_f_tx_postdiv_hz          = 0,

    parameter          bb_f_ux_synth_lc_fast_f_rx_postdiv_hz          = 0,
    parameter          bb_f_ux_synth_lc_fast_rx_postdiv_counter       = 0,
    parameter          bb_f_ux_synth_lc_med_f_rx_postdiv_hz           = 0,
    parameter          bb_f_ux_synth_lc_med_rx_postdiv_counter        = 0,
    parameter          bb_f_ux_synth_lc_slow_f_rx_postdiv_hz          = 0,
    parameter          bb_f_ux_synth_lc_slow_rx_postdiv_counter       = 0,

    parameter          bb_f_ux_tx_user_clk1_en                        = "DISABLE",
    parameter          bb_f_ux_tx_user_clk2_en                        = "DISABLE",
    parameter          bb_f_ux_tx_user_clk1_mux                       = "TX_USER_CLK1_MUX_DISABLED",
    parameter          bb_f_ux_tx_user_clk2_mux                       = "TX_USER_CLK2_MUX_DISABLED",
    parameter          bb_f_ux_tx_user_clk_slow_med_mux               = "TX_USER_CLK_SLOW_MED_MUX_DISABLED",
    parameter          bb_f_ux_rx_user_clk_en                         = "DISABLE",
    parameter          dec_bb_f_ux_f_out_synth_ring_hz                          = "1500000000",
    parameter          bb_f_ux_synch_ring_modula_to_ren                         = "SYNCH_RING_MODULA_TO_REN_0",
    parameter          bb_f_ux_synth_ring_enable_half_divider                   = "SYNTH_RING_ENABLE_HALF_DIVIDER_INT_DIVISION",
    parameter          bb_f_ux_synth_ring_fast_refclk_mode                      = "DISABLE",
    parameter  [7:0]   bb_f_ux_synth_ring_l_counter                             = 16,
    parameter  [7:0]   bb_f_ux_synth_ring_n_counter                             = 1,
    parameter          bb_f_ux_synth_ring_pcs_postdiv_en                        = "SYNTH_RING_PCS_POSTDIV_EN_0",
    parameter  [7:0]   bb_f_ux_digital_core_divider                             = 0,
    parameter  [7:0]   bb_f_ux_rx_clkdiv                                        = 8,
    parameter  [7:0]   bb_f_ux_tx_clkdiv                                        = 8,
    parameter          bb_f_ux_rx_width                                         = "RX_WIDTH_8",
    parameter          bb_f_ux_tx_width                                         = "TX_WIDTH_8",
    parameter          bb_f_ux_rx_bond_size                                     = "RX_BOND_SIZE_1",
    parameter          bb_f_ux_tx_bond_size                                     = "TX_BOND_SIZE_1",
    parameter          bb_f_ux_txrx_line_encoding_type                          = "TXRX_LINE_ENCODING_TYPE_NRZ",

    parameter          bb_f_ux_silicon_rev                                      = "gdra",
    parameter          bb_f_aib_silicon_rev                                     = "gdra",
    parameter          bb_f_aib_aib_hssi_rx_transfer_clk_hz                     = 0,
    parameter          bb_f_aib_aib_hssi_tx_transfer_clk_hz                     = 0,

    parameter          bb_f_ux_rx_protocol                                      = "RX_PROTOCOL_PMA_DIRECT_SYS_CLK",
    parameter          bb_f_ux_tx_protocol                                      = "TX_PROTOCOL_PMA_DIRECT_SYS_CLK",
    parameter          bb_f_ux_txrx_channel_operation                           = "TXRX_CHANNEL_OPERATION_FULL_DUPLEX",
    parameter          bb_f_ux_txrx_xcvr_speed_bucket                           = "TXRX_XCVR_SPEED_BUCKET_25G",
    parameter          bb_f_ux_squelch_detect                                   = "DISABLE",
    parameter          bb_f_ux_prbs_gen_en                                      = "DISABLE",
    parameter          bb_f_ux_prbs_mon_en                                      = "DISABLE",
    parameter [5:0]    bb_f_ux_prbs_pattern                                     = 7,
    parameter          bb_f_ux_rx_pam4_graycode_en                              = "DISABLE",
    parameter          bb_f_ux_tx_pam4_graycode_en                              = "DISABLE",
    parameter          bb_f_ux_rx_pam4_precode_en                               = "DISABLE",
    parameter          bb_f_ux_tx_pam4_precode_en                               = "DISABLE",
    parameter          bb_f_ux_force_cdr_ltd                                    = "DISABLE",
    parameter          bb_f_ux_force_cdr_ltr                                    = "DISABLE",
    parameter          bb_f_ux_enable_port_control_of_cdr_ltr_ltd               = "DISABLE",
    parameter          bb_f_ux_flux_mode                                        = "FLUX_MODE_CPRI",
    parameter          bb_f_ux_core_pll                                         = "CORE_PLL_DISABLED",
    parameter          bb_f_ux_rx_adapt_mode                                    = "RX_ADAPT_MODE_FLUX_RX_ADAPT",
    parameter          bb_f_ux_engineered_link_mode                             = "DISABLE",
    parameter          bb_f_ux_tx_tuning_hint                                   = "TX_TUNING_HINT_DISABLED",
    parameter          bb_f_ux_rx_tuning_hint                                   = "RX_TUNING_HINT_DISABLED",
	parameter          bb_f_ux_tx_spread_spectrum_en                            = "DISABLE",

    parameter          bb_f_bk_silicon_rev                                      = "gdra",
    parameter          bb_f_bk_package_type                                     = "HIGHEND",
    parameter          bb_f_bk_speed_grade                                      = "SPEED_GRADE_112G",
    parameter          bb_f_bk_sup_mode                                         = "SUP_MODE_USER_MODE",
    parameter          bb_f_bk_tx_protocol                                      = "TX_PROTOCOL_PMA_DIRECT_XCVR_CLK",
    parameter          bb_f_bk_tx_bond_size                                     = "TX_BOND_SIZE_1",
    parameter          bb_f_bk_tx_line_rate                                     = 1000000000,
    parameter          bb_f_bk_txrx_line_encoding_type                          = "TXRX_LINE_ENCODING_TYPE_NRZ",
    parameter          bb_f_bk_txout_tristate_en                                = "TXOUT_TRISTATE_EN", 
    parameter          bb_f_bk_tx_termination                                   = "TXTERM_OFFSET_P0",
    parameter          bb_f_bk_tx_invert_p_and_n                                = "TX_INVERT_PN_DIS",
    parameter [6:0]    bb_f_bk_txeq_main_tap                                    = 83,
    parameter [5:0]    bb_f_bk_txeq_post_tap_1                                  = 0,
    parameter [5:0]    bb_f_bk_txeq_post_tap_2                                  = 0,
    parameter [5:0]    bb_f_bk_txeq_post_tap_3                                  = 0,
    parameter [5:0]    bb_f_bk_txeq_post_tap_4                                  = 0,
    parameter [5:0]    bb_f_bk_txeq_pre_tap_1                                   = 0,
    parameter [5:0]    bb_f_bk_txeq_pre_tap_2                                   = 0,
    parameter [5:0]    bb_f_bk_txeq_pre_tap_3                                   = 0,  
                                                                                 
    parameter          bb_f_bk_refclk_source_lane_pll                           = "PLLA_100_MHZ",
    parameter          bb_f_bk_pll_pcs3334_ratio                                = "DIV_33_BY_2",
    parameter          bb_f_bk_pll_rx_pcs3334_ratio                             = "DIV_33_BY_2",
    parameter          bb_f_bk_pam4_rxgrey_code                                 = "PAM4_RXGREY_IS_B4",
    parameter          bb_f_bk_rx_user_clk1_en                                  = "RX_USRCLK1_DIS",
    parameter          bb_f_bk_rx_user_clk2_en                                  = "RX_USRCLK2_DIS",
    parameter          bb_f_bk_tx_user_clk1_en                                  = "TX_USRCLK1_DIS",
    parameter          bb_f_bk_tx_user_clk2_en                                  = "TX_USRCLK2_DIS",
    parameter          bb_f_bk_rx_user_clk1_sel                                 = "RX_USRCLK1SEL_DIV3334",
    parameter          bb_f_bk_rx_user_clk2_sel                                 = "RX_USRCLK2SEL_DIV3334",
    parameter          bb_f_bk_tx_user_clk1_sel                                 = "TX_USRCLK1SEL_DIV3334",
    parameter          bb_f_bk_tx_user_clk2_sel                                 = "TX_USRCLK2SEL_DIV3334",
                                                                                 
    parameter          bb_f_bk_an_mode                                          = "AN_MODE_DIS",
    parameter          bb_f_bk_bk_dl_enable                                     = "DETLAT_DIS",
    parameter          bb_f_bk_loopback_mode                                    = "LPBK_DISABLED",
    parameter          bb_f_bk_bti_protected                                    = "FALSE",
                                                                                 
    parameter          bb_f_bk_rx_termination                                   = "RXTERM_OFFSET_P0",
    parameter          bb_f_bk_rx_invert_p_and_n                                = "RX_INVERT_PN_DIS",
    parameter          bb_f_bk_bk_en_rxdat_profile                              = "RXDAT_PROF_DIS",
                                                                                 
    parameter          bb_f_bk_bk_lnx_txovf_rxbdstb_inten                       = 0,
    parameter          bb_f_bk_bk_lnx_txudf_pldrstb_inten                       = 0,
    parameter          bb_f_bk_bk_tx_lnx_ovf_inten_dirsignal                    = 0,
    parameter          bb_f_bk_bk_tx_lnx_rxbadst_inten_dirsignal                = 0,
    parameter          bb_f_bk_bk_tx_lnx_udf_inten_dirsignal                    = 0,
                                                                                 
    parameter          bb_f_bk_bk_rx_lat_bit_for_async                          = 0,
    parameter          bb_f_bk_bk_rxbit_cntr_pma                                = "RXBIT_CNTR_PMADIR_DIS",
    parameter  [31:0]  bb_f_bk_bk_rxbit_rollover                                = 5248, 

    parameter          bb_f_bk_rx_precode_en                                    = "RX_PRECODE_DIS",
    parameter          bb_f_bk_tx_precode_en                                    = "TX_PRECODE_DIS",
    parameter          bb_f_bk_pll_n_counter                                    = 1,
    
    parameter          duplex_mode                                              = "duplex", // duplex/simplex
    parameter          pldif_tx_double_width_transfer_enable                    = 1, // TX double/single data width transfer
    parameter          pldif_rx_double_width_transfer_enable                    = 1, // RX double/single data width transfer
    parameter          l_fec_mode                                               = "IEEE 802.3 RS(528,514) (CL 91,KR)", // RSFEC mode
    parameter          rx_deskew_en                                             = 1, // enable RX de-skew checkbox
    parameter          l_rx_deskew_enable                                       = 1, // enable RX de-skew feature
    parameter          enable_port_latency_measurement                          = 0, // enable deterministic latency 
    parameter          txparalleldata_width                                     = 80, // parallel data width
    parameter          txsimpleinterface_enable                                 = 0, // Mux for selecting data path for simplified interface
	parameter          cwbin_timeout_count       								= 1399, //14us timer, 1400 for 100MHZ reconfig clock, 3500 for 250MHz clock
	parameter          enable_soft_cwbin         								= 0,
	parameter          enable_N_width_ready_signal                              = 0,   // Enable N width TX and RX ready channel
	parameter          ready_width                                              = 1   // TX and RX port width
) (

// Building block Link ports:
  (* tile_ip_find_net *) output                       rx_cdr_divclk_link0,
  (* tile_ip_find_net *) output                       rx_cdr_divclk_link1,
  (* tile_ip_find_net *) input   [num_xcvr_per_sys*num_sys_cop-1:0] rx_cdr_refclk_link,
  (* tile_ip_find_net *) input   [l_sys_xcvrs_cascade-1:0] tx_pll_refclk_link,
  (* tile_ip_find_net *) input   [num_sys_cop-1:0]          system_pll_clk_link,


// Device Pins:
  (* tile_ip_find_net *)      input          [l_sys_xcvrs-1:0]   rx_serial_data,
  (* tile_ip_find_net *)      input          [l_sys_xcvrs-1:0]   rx_serial_data_n,
  (* tile_ip_find_net *)     output          [l_sys_xcvrs-1:0]   tx_serial_data,
  (* tile_ip_find_net *)     output          [l_sys_xcvrs-1:0]   tx_serial_data_n,


// User interface:  Clock and data and reset
      input         [num_sys_cop-1:0]   tx_reset,
      input         [num_sys_cop-1:0]   rx_reset,
     output         [num_sys_cop-1:0]   tx_reset_ack,
     output         [num_sys_cop-1:0]   rx_reset_ack,
 //    input                              gpon_reconfig_clk,
     // JRJ - 10-15-2020 There is a single output for tx_am_gen_start for all transceivers in each system copy.
     //                  There is also a single input for tx_am_gen_start_2x_ack for all transceivers in each system copy.
     //                  The user IP should start sending alignment markers on all lanes when the tx_am_gen_start asserts
     //                  and should assert tx_am_gen_2x_ack when all lanes have sent at least two alignment markers.
     // JRJ - 10-15-2020 was:
//     output         [l_sys_xcvrs-1:0]   tx_am_gen_start,
//     input          [l_sys_xcvrs-1:0]   tx_am_gen_2x_ack,
     // JRJ - 10-15-2020 is:
     output         [num_sys_cop-1:0]     tx_am_gen_start,
     input          [num_sys_cop-1:0]     tx_am_gen_2x_ack,
     // JRJ = 10-15-2020 End of modifications
     
     output         [ready_width-1:0]   tx_ready,
     output         [ready_width-1:0]   rx_ready,

      input         [(l_sys_aibs*txparalleldata_width)-1:0] tx_parallel_data,
      input         [l_sys_aibs*4-1:0]  fgt_tx_pma_elecidle, 
     output         [l_sys_aibs*80-1:0] rx_parallel_data,

// User interface PLD Clocks
      input wire    [l_sys_aibs-1:0]    tx_coreclkin,
      input wire    [l_sys_aibs-1:0]    rx_coreclkin,
      input wire    [l_sys_aibs-1:0]    tx_coreclkin2,
     output wire    [l_sys_aibs-1:0]    tx_clkout,
     output wire    [l_sys_aibs-1:0]    tx_clkout2,
     output wire    [l_sys_aibs-1:0]    tx_clkout_hioint,
     output wire    [l_sys_aibs-1:0]    tx_clkout2_hioint,
     output wire    [l_sys_aibs-1:0]    rx_clkout,
     output wire    [l_sys_aibs-1:0]    rx_clkout2,
     output wire    [l_sys_aibs-1:0]    rx_clkout_hioint,
     output wire    [l_sys_aibs-1:0]    rx_clkout2_hioint,

// Deterministic Latency 
     input [l_sys_xcvrs-1:0] dl_clk,
     input [l_sys_xcvrs-1:0] tx_dl_measure_sel,
     input [l_sys_xcvrs-1:0] rx_dl_measure_sel,
     output [l_sys_xcvrs-1:0] tx_dl_async_pulse,
     output [l_sys_xcvrs-1:0] rx_dl_async_pulse,

// Custom Cadence 
     input          [num_sys_cop-1:0]   tx_cadence_fast_clk,
     input          [num_sys_cop-1:0]   tx_cadence_slow_clk,
     input          [num_sys_cop-1:0]   tx_cadence_slow_clk_locked,
     output         [num_sys_cop-1:0]   tx_cadence,
 
  // User interface for XCVR (FGT/FHT)
    output          [l_sys_xcvrs-1:0]   fgt_rx_signal_detect,    
    output          [l_sys_xcvrs-1:0]   fgt_rx_signal_detect_lfps,   
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
    output   wire   [num_sys_cop-1:0]   rsfec_status_rx_not_deskew,
    output   wire   [num_sys_cop-1:0]   rsfec_status_rx_not_locked,
    output   wire   [num_sys_cop-1:0]   rsfec_status_rx_not_align,
    output   wire   [num_sys_cop-1:0]   rsfec_sf,
     input   wire   [ l_sys_aibs-1:0]   fec_snapshot,


  // User interface for AIB
    output   wire   [l_sys_aibs-1:0]    tx_fifo_full,
    output   wire   [l_sys_aibs-1:0]    tx_fifo_empty,
    output   wire   [l_sys_aibs-1:0]    tx_fifo_pfull,
    output   wire   [l_sys_aibs-1:0]    tx_fifo_pempty,
    output   wire   [l_sys_aibs-1:0]    tx_dll_lock,
    output   wire   [l_sys_aibs-1:0]    rx_fifo_full,
    output   wire   [l_sys_aibs-1:0]    rx_fifo_empty,
    output   wire   [l_sys_aibs-1:0]    rx_fifo_pfull,
    output   wire   [l_sys_aibs-1:0]    rx_fifo_pempty,
     input   wire   [l_sys_aibs-1:0]    rx_fifo_rd_en,


  // User interface for XCVR-IF
    output   wire   [l_sys_aibs-1:0]    rx_pmaif_fifo_empty,
    output   wire   [l_sys_aibs-1:0]    rx_pmaif_fifo_pempty,
    output   wire   [l_sys_aibs-1:0]    rx_pmaif_fifo_pfull,

    output   wire   [l_sys_aibs-1:0]    tx_pmaif_fifo_empty,
    output   wire   [l_sys_aibs-1:0]    tx_pmaif_fifo_pempty,
    output   wire   [l_sys_aibs-1:0]    tx_pmaif_fifo_pfull,


  // Reconfiguration:
  input   [l_av2_ifaces-1:0]       reconfig_xcvr_clk,             //       reconfig_clk.clk
  input   [l_av2_ifaces-1:0]       reconfig_xcvr_reset,           //     reconfig_reset.reset
  input   [l_av2_ifaces-1:0]       reconfig_xcvr_write,           //      reconfig_avmm.write
  input   [l_av2_ifaces-1:0]       reconfig_xcvr_read,            //                   .read
  input   [l_av2_addr_bits*l_av2_ifaces-1:0]   reconfig_xcvr_address,         //                   .address
  input   [l_av2_ifaces*32-1:0]    reconfig_xcvr_writedata,       //                   .writedata
  input   [l_av2_ifaces*4-1:0]     reconfig_xcvr_byteenable,      //                   .byteenable
  output  [l_av2_ifaces*32-1:0]    reconfig_xcvr_readdata,        //                   .readdata
  output  [l_av2_ifaces-1:0]       reconfig_xcvr_waitrequest,     //                   .waitrequest
  output  [l_av2_ifaces-1:0]       reconfig_xcvr_readdatavalid,   //                   .readdatavalid

  input   [l_av1_ifaces-1:0]       reconfig_pdp_clk,         //   reconfig_pdp_clk.clk
  input   [l_av1_ifaces-1:0]       reconfig_pdp_reset,       // reconfig_pdp_reset.reset
  input   [l_av1_ifaces-1:0]       reconfig_pdp_write,       //  reconfig_pdp_avmm.write
  input   [l_av1_ifaces-1:0]       reconfig_pdp_read,        //                   .read
  input   [l_av1_addr_bits*l_av1_ifaces-1:0]  reconfig_pdp_address,     //                   .address
  input   [l_av1_ifaces*32-1:0]    reconfig_pdp_writedata,   //                   .writedata
  input   [l_av1_ifaces*4-1:0]     reconfig_pdp_byteenable,  //                   .byteenable
  output  [l_av1_ifaces*32-1:0]    reconfig_pdp_readdata,    //                   .readdata
  output  [l_av1_ifaces-1:0]       reconfig_pdp_waitrequest,  //                   .waitrequest
  output  [l_av1_ifaces-1:0]       reconfig_pdp_readdatavalid   //                   .readdatavalid

);

localparam fec_on = (bb_f_ehip_rx_fec_enable == "RX_FEC_ENABLE_ENABLED" )|| (bb_f_ehip_tx_fec_enable == "TX_FEC_ENABLE_ENABLED") ;
localparam avmm2_enable_or_gpon = (avmm2_enable == 1 )|| (bb_f_ux_tx_tuning_hint == "TX_TUNING_HINT_GPON") ;


  wire  [l_sys_aibs*80-1:0]    sync_data_from_aib;
  wire  [l_sys_aibs*80-1:0]    sync_data_to_aib;


  //  for AVMM1 bb ports
  wire  [l_num_avmm1-1:0]      pld_avmm1_busy;
  wire  [l_num_avmm1-1:0]      pld_avmm1_clk_rowclk;
  wire  [l_num_avmm1-1:0]      pld_avmm1_cmdfifo_wr_full;
  wire  [l_num_avmm1-1:0]      pld_avmm1_cmdfifo_wr_pfull;
  wire  [l_num_avmm1-1:0]      pld_avmm1_read;
  wire  [8*l_num_avmm1-1:0]    pld_avmm1_readdata;
  wire  [l_num_avmm1-1:0]      pld_avmm1_readdatavalid;
  wire  [10*l_num_avmm1-1:0]   pld_avmm1_reg_addr;
  wire  [l_num_avmm1-1:0]      pld_avmm1_request;
  wire  [9*l_num_avmm1-1:0]    pld_avmm1_reserved_in;
  wire  [3*l_num_avmm1-1:0]    pld_avmm1_reserved_out;
  wire  [l_num_avmm1-1:0]      pld_avmm1_write;
  wire  [8*l_num_avmm1-1:0]    pld_avmm1_writedata;
  wire  [l_num_avmm1-1:0]      pld_chnl_cal_done;
  wire  [l_num_avmm1-1:0]      pld_hssi_osc_transfer_en;

  //  for AVMM2 bb ports
  wire  [l_num_avmm2-1:0]   hip_avmm_read;
  wire  [8*l_num_avmm2-1:0] hip_avmm_readdata;
  wire  [l_num_avmm2-1:0]   hip_avmm_readdatavalid;
  wire  [21*l_num_avmm2-1:0] hip_avmm_reg_addr;
  wire  [5*l_num_avmm2-1:0] hip_avmm_reserved_out;
  wire  [l_num_avmm2-1:0]   hip_avmm_write;
  wire  [8*l_num_avmm2-1:0] hip_avmm_writedata;
  wire  [l_num_avmm2-1:0]   hip_avmm_writedone;
  wire  [l_num_avmm2-1:0]   pld_avmm2_busy;
  wire  [l_num_avmm2-1:0]   pld_avmm2_clk_rowclk;
  wire  [l_num_avmm2-1:0]   pld_avmm2_cmdfifo_wr_full;
  wire  [l_num_avmm2-1:0]   pld_avmm2_cmdfifo_wr_pfull;
  wire  [l_num_avmm2-1:0]   pld_avmm2_request;
  wire  [l_num_avmm2-1:0]   pld_pll_cal_done;
  // below are unused ports in hip mode
  wire  [l_num_avmm2-1:0]   pld_avmm2_write;
  wire  [l_num_avmm2-1:0]   pld_avmm2_read;
  wire  [9*l_num_avmm2-1:0] pld_avmm2_reg_addr;
  wire  [8*l_num_avmm2-1:0] pld_avmm2_readdata;
  wire  [8*l_num_avmm2-1:0] pld_avmm2_writedata;
  wire  [l_num_avmm2-1:0]   pld_avmm2_readdatavalid;
  wire  [6*l_num_avmm2-1:0] pld_avmm2_reserved_in;
  wire  [l_num_avmm2-1:0]   pld_avmm2_reserved_out;

  // status signals 
  wire   [2:0]                         dphy_reset_status_system_pll_ready;
  wire   [15:0]                        phy_tx_pll_locked_tx_pll_locked;
  wire   [15:0]                        phy_rx_cdr_locked_rx_cdr_locked;
  wire   [15:0]                        aib_transfer_ready_status_dphy_rx_transfer_ready;
  wire   [15:0]                        aib_transfer_ready_status_dphy_tx_transfer_ready;


  // UX BB wires between SIP and HIP 
  wire          [num_xcvr_per_sys*num_sys_cop-1:0]   w_oct_pcs_rxsignaldetect_lx_a;    
  wire          [num_xcvr_per_sys*num_sys_cop-1:0]   w_octl_pcs_rxsignaldetect_lfps_lx_a;
  wire          [num_xcvr_per_sys*num_sys_cop-1:0]   w_oct_pcs_all_synthlockstatus;                 
  wire          [num_xcvr_per_sys*num_sys_cop-1:0]   w_oct_pcs_rxcdrlock2data_lx_a;          
  wire          [num_xcvr_per_sys*num_sys_cop-1:0]   w_oct_pcs_rxcdrlockstatus_lx_a;
  wire          [num_xcvr_per_sys*num_sys_cop-1:0]   w_octl_pcs_txstatus_lx_a;          
  wire          [num_xcvr_per_sys*num_sys_cop-1:0]   w_octl_pcs_rxstatus_lx_a;  
  wire          [num_xcvr_per_sys*num_sys_cop-1:0]   w_ictl_pcs_rxovrcdrlock2dataen_lx_a;  
  wire          [num_xcvr_per_sys*num_sys_cop-1:0]   w_ictl_pcs_rxovrcdrlock2data_lx_a;
  wire          [num_xcvr_per_sys*num_sys_cop-1:0]   w_ictl_pcs_txbeacon_lx_a;
  wire          [num_xcvr_per_sys*num_sys_cop-1:0]   w_flux_top__iflux_ingress_direct__231;
  wire          [num_xcvr_per_sys*num_sys_cop-1:0]   w_i_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t;
  wire          [num_xcvr_per_sys*num_sys_cop-1:0]   w_ictl_pcs_rxeiosdetectstat_lx_a;

  // BK BB wires between SIP and HIP
  wire   [l_sys_xcvrs*8-1:0]  fht_ingress_direct;  
  wire   [l_sys_xcvrs*8-1:0]  fht_rx_direct;           
  wire   [l_sys_xcvrs-1:0]    fht_rxsrds_rdy;  
  wire   [l_sys_xcvrs-1:0]    fht_latency_pulse;  
  wire   [l_sys_xcvrs-1:0]    fht_rx_energy_detect;
  
  // csr access
  wire   [l_sys_xcvrs-1:0]    cpi_cmn_busy_real;

  // PLD Interface signals
  wire   [l_sys_aibs*4-1:0]   hip_aib_fsr_in;
  wire   [l_sys_aibs*4-1:0]   hip_aib_fsr_out;
  wire   [l_sys_aibs*40-1:0]  hip_aib_ssr_in;
  wire   [l_sys_aibs*8-1:0]   hip_aib_ssr_out;
  wire   [l_sys_aibs*1-1:0]   pld_10g_krfec_rx_blk_lock;
  wire   [l_sys_aibs*1-1:0]   pld_10g_krfec_rx_clr_errblk_cnt;
  wire   [l_sys_aibs*2-1:0]   pld_10g_krfec_rx_diag_data_status;
  wire   [l_sys_aibs*1-1:0]   pld_10g_krfec_rx_frame;
  wire   [l_sys_aibs*1-1:0]   pld_10g_rx_crc32_err;
  wire   [l_sys_aibs*1-1:0]   pld_10g_rx_frame_lock;
  wire   [l_sys_aibs*1-1:0]   pld_10g_rx_hi_ber;
  wire   [l_sys_aibs*7-1:0]   pld_10g_tx_bitslip;
  wire   [l_sys_aibs*4-1:0]   pld_8g_a1a2_k1k2_flag;
  wire   [l_sys_aibs*1-1:0]   pld_8g_bitloc_rev_en;
  wire   [l_sys_aibs*1-1:0]   pld_8g_byte_rev_en;
  wire   [l_sys_aibs*3-1:0]   pld_8g_eidleinfersel;
  wire   [l_sys_aibs*1-1:0]   pld_8g_empty_rmf;
  wire   [l_sys_aibs*1-1:0]   pld_8g_encdt;
  wire   [l_sys_aibs*1-1:0]   pld_8g_full_rmf;
  wire   [l_sys_aibs*5-1:0]   pld_8g_tx_boundary_sel;
  wire   [l_sys_aibs*5-1:0]   pld_8g_wa_boundary;
  wire   [l_sys_aibs*1-1:0]   pld_krfec_tx_alignment;
  wire   [l_sys_aibs*1-1:0]   pld_pma_adapt_done;
  wire   [l_sys_aibs*1-1:0]   pld_pma_adapt_start;
  wire   [l_sys_aibs*1-1:0]   pld_pma_csr_test_dis;
  wire   [l_sys_aibs*1-1:0]   pld_pma_early_eios;
  wire   [l_sys_aibs*6-1:0]   pld_pma_eye_monitor;
  wire   [l_sys_aibs*1-1:0]   pld_pma_fpll_clk0bad;
  wire   [l_sys_aibs*1-1:0]   pld_pma_fpll_clk1bad;
  wire   [l_sys_aibs*1-1:0]   pld_pma_fpll_clksel;
  wire   [l_sys_aibs*4-1:0]   pld_pma_fpll_cnt_sel;
  wire   [l_sys_aibs*1-1:0]   pld_pma_fpll_extswitch;
  wire   [l_sys_aibs*3-1:0]   pld_pma_fpll_num_phase_shifts;
  wire   [l_sys_aibs*1-1:0]   pld_pma_fpll_pfden;
  wire   [l_sys_aibs*1-1:0]   pld_pma_fpll_phase_done;
  wire   [l_sys_aibs*1-1:0]   pld_pma_fpll_up_dn_lc_lf_rstn;
  wire   [l_sys_aibs*1-1:0]   pld_pma_nrpi_freeze;
  wire   [l_sys_aibs*2-1:0]   pld_pma_pcie_sw_done;
  wire   [l_sys_aibs*2-1:0]   pld_pma_pcie_switch;
  wire   [l_sys_aibs*1-1:0]   pld_pma_ppm_lock;
  wire   [l_sys_aibs*5-1:0]   pld_pma_reserved_in;
  wire   [l_sys_aibs*5-1:0]   pld_pma_reserved_out;
  wire   [l_sys_aibs*1-1:0]   pld_pma_rs_lpbk_b;
  wire   [l_sys_aibs*1-1:0]   pld_pma_rx_detect_valid;
  wire   [l_sys_aibs*1-1:0]   pld_pma_rx_found;
  wire   [l_sys_aibs*1-1:0]   pld_pma_signal_ok;
  wire   [l_sys_aibs*1-1:0]   pld_pma_tx_bitslip;
  wire   [l_sys_aibs*1-1:0]   pld_pma_tx_qpi_pulldn;
  wire   [l_sys_aibs*1-1:0]   pld_pma_tx_qpi_pullup;
  wire   [l_sys_aibs*1-1:0]   pld_pmaif_mask_tx_pll;
  wire   [l_sys_aibs*1-1:0]   pld_pmaif_rxclkslip;
  wire   [l_sys_aibs*1-1:0]   pld_polinv_rx;
  wire   [l_sys_aibs*1-1:0]   pld_polinv_tx;
  wire   [l_sys_aibs*1-1:0]   pld_rx_hssi_fifo_empty;
  wire   [l_sys_aibs*1-1:0]   pld_rx_hssi_fifo_full;
  wire   [l_sys_aibs*1-1:0]   pld_rx_prbs_done;
  wire   [l_sys_aibs*1-1:0]   pld_rx_prbs_err;
  wire   [l_sys_aibs*1-1:0]   pld_rx_prbs_err_clr;
  wire   [l_sys_aibs*1-1:0]   pld_syncsm_en;
  wire   [l_sys_aibs*20-1:0]  pld_test_data;
  wire   [l_sys_aibs*1-1:0]   pld_tx_hssi_fifo_empty;
  wire   [l_sys_aibs*1-1:0]   pld_tx_hssi_fifo_full;

//************************************************
//  Clock connections
//************************************************
  wire  [l_sys_aibs-1:0]   int_tx_coreclkin_rowclk;
  wire  [l_sys_aibs-1:0]   int_tx_coreclkin_dclk;
  wire  [l_sys_aibs-1:0]   int_rx_coreclkin_rowclk;
  wire  [l_sys_aibs-1:0]   int_rx_coreclkin_dclk;
  wire  [l_sys_aibs-1:0]   int_tx_coreclkin2_rowclk;
  wire  [l_sys_aibs-1:0]   int_tx_coreclkin2_dclk;

  
        assign int_tx_coreclkin_rowclk  = (pldif_tx_coreclkin_clock_network == "rowclk") ? tx_coreclkin : 1'b0;
        assign int_tx_coreclkin_dclk    = (pldif_tx_coreclkin_clock_network == "rowclk") ? 1'b0         : tx_coreclkin;
        assign int_rx_coreclkin_rowclk  = (pldif_rx_coreclkin_clock_network == "rowclk") ? rx_coreclkin : 1'b0;
        assign int_rx_coreclkin_dclk    = (pldif_rx_coreclkin_clock_network == "rowclk") ? 1'b0         : rx_coreclkin;
     
        assign int_tx_coreclkin2_rowclk = (enable_port_tx_clkin2) ? (pldif_tx_coreclkin2_clock_network == "rowclk") ? tx_coreclkin2 : 1'b0          : 1'b0;
        assign int_tx_coreclkin2_dclk   = (enable_port_tx_clkin2) ? (pldif_tx_coreclkin2_clock_network == "rowclk") ? 1'b0          : tx_coreclkin2 : 1'b0;

// Wires for placement_virtual links between SIP and HIP

  wire [num_xcvr_per_sys*num_sys_cop-1:0] placement_virtual_rx_xcvr;
  wire [num_xcvr_per_sys*num_sys_cop-1:0] placement_virtual_tx_xcvr;
  wire [num_xcvr_per_sys*num_sys_cop-1:0] placement_virtual_fht_xcvr;
  
// TX parallel data select
  wire [l_sys_aibs*80-1:0]         tx_parallel_data_sel;

// Wires for TX de-skew pulses generation   
  wire [l_sys_aibs*80-1:0]         int_tx_parallel_data;
// Wires for RX de-skew, connections from SIP   
  wire [l_sys_aibs*80-1:0]         int_rx_skewed_data;
  wire [num_sys_cop-1:0]           int_rx_ready;
  wire [num_xcvr_per_sys*num_sys_cop-1:0] rx_lane_out_of_reset;

//************************************************
//  SIP Instantiation
//************************************************
  directphy_f_sip_kb6ooeq #(
	.num_sys_cop                               (num_sys_cop),
	.num_xcvr_per_sys                          (num_xcvr_per_sys),
	.l_num_aib_per_xcvr                        (l_num_aib_per_xcvr),
	.l_sys_xcvrs                               (l_sys_xcvrs),
	.l_sys_aibs                                (l_sys_aibs),
        .l_tx_enable                               (l_tx_enable),
		.bb_f_ux_tx_tuning_hint                                   (bb_f_ux_tx_tuning_hint),
	.l_rx_enable                               (l_rx_enable),
        .tx_custom_cadence_enable                  (tx_custom_cadence_enable),
        .enable_port_tx_cadence_slow_clk_locked    (enable_port_tx_cadence_slow_clk_locked),
        .fec_on                                    (fec_on),
        .bb_f_ehip_xcvr_type                       (bb_f_ehip_xcvr_type),
        .bb_f_ehip_xcvr_mode                       (bb_f_ehip_xcvr_mode),
	.avmm1_split                               (avmm1_split),
	.avmm1_jtag_enable                         (avmm1_jtag_enable),
	.l_av1_enable                              (l_av1_enable),
        .l_soft_csr_enable                         (l_soft_csr_enable),
        .l_line_rate_p1ghz                         (l_line_rate_p1ghz),
        .avmm1_readdv_enable                       (avmm1_readdv_enable),
	.l_av1_aib_enable                          (l_av1_aib_enable),
	.l_num_avmm1                               (l_num_avmm1),
	.l_av1_ifaces                              (l_av1_ifaces),
	.l_av1_addr_bits                           (l_av1_addr_bits),
	.avmm2_split                               (avmm2_split),
	.avmm2_jtag_enable                         (avmm2_jtag_enable),
	.l_av2_enable                              (avmm2_enable),
        .avmm2_readdv_enable                       (avmm2_readdv_enable),
	.l_num_avmm2                               (l_num_avmm2),
	.l_av2_ifaces                              (l_av2_ifaces),
	.l_av2_addr_bits                           (l_av2_addr_bits),
	.cwbin_timeout_count                       (cwbin_timeout_count),
	.enable_soft_cwbin                         (enable_soft_cwbin),
	.bb_f_ehip_frac_size                       (bb_f_ehip_frac_size),
	.enable_N_width_ready_signal               (enable_N_width_ready_signal),
	.ready_width                               (ready_width)
  ) dphy_sip_inst (

//PLD Interface
    .hip_aib_fsr_in  ( hip_aib_fsr_in ),
    .hip_aib_fsr_out  ( hip_aib_fsr_out ),
    .hip_aib_ssr_in  ( hip_aib_ssr_in ),
    .hip_aib_ssr_out  ( hip_aib_ssr_out ),
	.cpi_cmn_busy_real (cpi_cmn_busy_real),
    .pld_10g_krfec_rx_blk_lock  ( pld_10g_krfec_rx_blk_lock ),
    .pld_10g_krfec_rx_clr_errblk_cnt  ( pld_10g_krfec_rx_clr_errblk_cnt ),
    .pld_10g_krfec_rx_diag_data_status  ( pld_10g_krfec_rx_diag_data_status ),
    .pld_10g_krfec_rx_frame  ( pld_10g_krfec_rx_frame ),
    .pld_10g_rx_crc32_err  ( pld_10g_rx_crc32_err ),
    .pld_10g_rx_frame_lock  ( pld_10g_rx_frame_lock ),
    .pld_10g_rx_hi_ber  ( pld_10g_rx_hi_ber ),
    .pld_10g_tx_bitslip  ( pld_10g_tx_bitslip ),
    .pld_8g_a1a2_k1k2_flag  ( pld_8g_a1a2_k1k2_flag ),
    .pld_8g_bitloc_rev_en  ( pld_8g_bitloc_rev_en ),
    .pld_8g_byte_rev_en  ( pld_8g_byte_rev_en ),
    .pld_8g_eidleinfersel  ( pld_8g_eidleinfersel ),
    .pld_8g_empty_rmf  ( pld_8g_empty_rmf ),
    .pld_8g_encdt  ( pld_8g_encdt ),
    .pld_8g_full_rmf  ( pld_8g_full_rmf ),
    .pld_8g_tx_boundary_sel  ( pld_8g_tx_boundary_sel ),
    .pld_8g_wa_boundary  ( pld_8g_wa_boundary ),
    .pld_krfec_tx_alignment  ( pld_krfec_tx_alignment ),
    .pld_pma_adapt_done  ( pld_pma_adapt_done ),
    .pld_pma_adapt_start  ( pld_pma_adapt_start ),
    .pld_pma_csr_test_dis  ( pld_pma_csr_test_dis ),
    .pld_pma_early_eios  ( pld_pma_early_eios ),
    .pld_pma_eye_monitor  ( pld_pma_eye_monitor ),
    .pld_pma_fpll_clk0bad  ( pld_pma_fpll_clk0bad ),
    .pld_pma_fpll_clk1bad  ( pld_pma_fpll_clk1bad ),
    .pld_pma_fpll_clksel  ( pld_pma_fpll_clksel ),
    .pld_pma_fpll_cnt_sel  ( pld_pma_fpll_cnt_sel ),
    .pld_pma_fpll_extswitch  ( pld_pma_fpll_extswitch ),
    .pld_pma_fpll_num_phase_shifts  ( pld_pma_fpll_num_phase_shifts ),
    .pld_pma_fpll_pfden  ( pld_pma_fpll_pfden ),
    .pld_pma_fpll_phase_done  ( pld_pma_fpll_phase_done ),
    .pld_pma_fpll_up_dn_lc_lf_rstn  ( pld_pma_fpll_up_dn_lc_lf_rstn ),
    .pld_pma_nrpi_freeze  ( pld_pma_nrpi_freeze ),
    .pld_pma_pcie_sw_done  ( pld_pma_pcie_sw_done ),
  //.pld_pma_pcie_switch  ( pld_pma_pcie_switch ),
    .pld_pma_ppm_lock  ( pld_pma_ppm_lock ),
    .pld_pma_reserved_in  ( pld_pma_reserved_in ),
    .pld_pma_reserved_out  ( pld_pma_reserved_out ),
    .pld_pma_rs_lpbk_b  ( pld_pma_rs_lpbk_b ),
    .pld_pma_rx_detect_valid  ( pld_pma_rx_detect_valid ),
    .pld_pma_rx_found  ( pld_pma_rx_found ),
    .pld_pma_signal_ok  ( pld_pma_signal_ok ),
    .pld_pma_tx_bitslip  ( pld_pma_tx_bitslip ),
    .pld_pma_tx_qpi_pulldn  ( pld_pma_tx_qpi_pulldn ),
    .pld_pma_tx_qpi_pullup  ( pld_pma_tx_qpi_pullup ),
    .pld_pmaif_mask_tx_pll  ( pld_pmaif_mask_tx_pll ),
    .pld_pmaif_rxclkslip  ( pld_pmaif_rxclkslip ),
    .pld_polinv_rx  ( pld_polinv_rx ),
    .pld_polinv_tx  ( pld_polinv_tx ),
    .pld_rx_hssi_fifo_empty  ( pld_rx_hssi_fifo_empty ),
    .pld_rx_hssi_fifo_full  ( pld_rx_hssi_fifo_full ),
    .pld_rx_prbs_done  ( pld_rx_prbs_done ),
    .pld_rx_prbs_err  ( pld_rx_prbs_err ),
    .pld_rx_prbs_err_clr  ( pld_rx_prbs_err_clr ),
    .pld_syncsm_en  ( pld_syncsm_en ),
    .pld_test_data  ( pld_test_data ),
    .pld_tx_hssi_fifo_empty  ( pld_tx_hssi_fifo_empty ),
    .pld_tx_hssi_fifo_full  ( pld_tx_hssi_fifo_full ),

    .tx_parallel_data                              ( int_tx_parallel_data  ),
    .rx_parallel_data                              ( int_rx_skewed_data  ),
    .sync_data_from_aib                            ( sync_data_from_aib  ),
    .sync_data_to_aib                              ( sync_data_to_aib  ),

//clock sync for cwbin
     .tx_coreclkin (tx_coreclkin),

    .tx_pll_locked                     (tx_pll_locked),                 
    .rx_is_lockedtodata                (rx_is_lockedtodata),          
    .rx_is_lockedtoref                 (rx_is_lockedtoref),
  //  .gpon_reconfig_clk                 (gpon_reconfig_clk),  

// Custom Cadence 
    .tx_cadence_fast_clk         (tx_cadence_fast_clk),
    .tx_cadence_slow_clk         (tx_cadence_slow_clk),
    .tx_cadence_slow_clk_locked  (tx_cadence_slow_clk_locked),
    .tx_cadence                  (tx_cadence),
                                   
// UX                              
    .fgt_rx_signal_detect              (fgt_rx_signal_detect),    
    .fgt_rx_signal_detect_lfps         (fgt_rx_signal_detect_lfps),    
    .fgt_rx_set_locktoref              (fgt_rx_set_locktoref),
    .fgt_rx_set_locktodata             (fgt_rx_set_locktodata),
    .fgt_rx_cdr_freeze                 (fgt_rx_cdr_freeze),
    .fgt_tx_beacon                     (fgt_tx_beacon),
	.fgt_rx_cdr_fast_freeze_sel        (fgt_rx_cdr_fast_freeze_sel), 
    .fgt_rx_cdr_set_locktoref          (fgt_rx_cdr_set_locktoref),
	
    .oct_pcs_rxsignaldetect_lx_a       (w_oct_pcs_rxsignaldetect_lx_a),    
    .octl_pcs_rxsignaldetect_lfps_lx_a (w_octl_pcs_rxsignaldetect_lfps_lx_a),    
    .oct_pcs_all_synthlockstatus       (w_oct_pcs_all_synthlockstatus),                 
    .oct_pcs_rxcdrlock2data_lx_a       (w_oct_pcs_rxcdrlock2data_lx_a),          
    .oct_pcs_rxcdrlockstatus_lx_a      (w_oct_pcs_rxcdrlockstatus_lx_a),         
    .octl_pcs_txstatus_lx_a            (w_octl_pcs_txstatus_lx_a),       
    .octl_pcs_rxstatus_lx_a            (w_octl_pcs_rxstatus_lx_a),      
    .ictl_pcs_rxovrcdrlock2dataen_lx_a (w_ictl_pcs_rxovrcdrlock2dataen_lx_a),  
    .ictl_pcs_rxovrcdrlock2data_lx_a   (w_ictl_pcs_rxovrcdrlock2data_lx_a),
    .ictl_pcs_txbeacon_lx_a            (w_ictl_pcs_txbeacon_lx_a),
    .flux_top__iflux_ingress_direct__231(w_flux_top__iflux_ingress_direct__231),
    .i_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t (w_i_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t),
    .ictl_pcs_rxeiosdetectstat_lx_a (w_ictl_pcs_rxeiosdetectstat_lx_a),

// BK
    .fht_rx_energy_detect              (fht_rx_energy_detect),    
    .fht_ingress_direct                (fht_ingress_direct),  
    .fht_rx_direct                     (fht_rx_direct     ),      
    .fht_rxsrds_rdy                    (fht_rxsrds_rdy    ), 

// FEC
    .rsfec_status_rx_not_deskew (rsfec_status_rx_not_deskew),
    .rsfec_status_rx_not_locked (rsfec_status_rx_not_locked),
    .rsfec_status_rx_not_align  (rsfec_status_rx_not_align),
    .rsfec_sf                   (rsfec_sf),
    .fec_snapshot               (fec_snapshot),

// XCVR-IF
    .xcvrif_rxfifo_empty    (rx_pmaif_fifo_empty),
    .xcvrif_rxfifo_pempty   (rx_pmaif_fifo_pempty),
    .xcvrif_rxfifo_pfull    (rx_pmaif_fifo_pfull),

    .xcvrif_txfifo_empty    (tx_pmaif_fifo_empty),
    .xcvrif_txfifo_pempty   (tx_pmaif_fifo_pempty),   
    .xcvrif_txfifo_pfull    (tx_pmaif_fifo_pfull),

    .xcvrif_hold_interrupt  (),


// Reconfiguration
    .reconfig_clk                                  (reconfig_xcvr_clk),             
    .reconfig_reset                                (reconfig_xcvr_reset),           
    .reconfig_write                                (reconfig_xcvr_write),           
    .reconfig_read                                 (reconfig_xcvr_read),            
    .reconfig_address                              (reconfig_xcvr_address),         
    .reconfig_byteenable                           (reconfig_xcvr_byteenable),         
    .reconfig_writedata                            (reconfig_xcvr_writedata),       
    .reconfig_readdata                             (reconfig_xcvr_readdata),        
    .reconfig_waitrequest                          (reconfig_xcvr_waitrequest),     
    .reconfig_readdatavalid                        (reconfig_xcvr_readdatavalid),     

    .reconfig_pdp_clk                              (reconfig_pdp_clk),         
    .reconfig_pdp_reset                            (reconfig_pdp_reset),       
    .reconfig_pdp_write                            (reconfig_pdp_write),       
    .reconfig_pdp_read                             (reconfig_pdp_read),        
    .reconfig_pdp_address                          (reconfig_pdp_address),     
    .reconfig_pdp_byteenable                       (reconfig_pdp_byteenable),         
    .reconfig_pdp_writedata                        (reconfig_pdp_writedata),   
    .reconfig_pdp_readdata                         (reconfig_pdp_readdata),    
    .reconfig_pdp_waitrequest                      (reconfig_pdp_waitrequest),  
    .reconfig_pdp_readdatavalid                    (reconfig_pdp_readdatavalid),     


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
    .pld_avmm2_clk_rowclk                          ( pld_avmm2_clk_rowclk       ),
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
    .pld_avmm2_reserved_out                        ( pld_avmm2_reserved_out     ),
     // ctrl/status
    .tx_reset                                      (tx_reset),	     
    .rx_reset                                      (rx_reset),	     
    .tx_reset_ack                                  (tx_reset_ack),    
    .rx_reset_ack                                  (rx_reset_ack),    
    .tx_am_gen_start                               (tx_am_gen_start), 
    .tx_am_gen_2x_ack                              (tx_am_gen_2x_ack),
    .tx_ready                                      (tx_ready),	     
    .rx_ready                                      (int_rx_ready),
    .rx_lane_out_of_reset                          (rx_lane_out_of_reset),
   // Link ports for instantiation of SRC IP
    .placement_virtual_rx_xcvr                     (placement_virtual_rx_xcvr   ),
    .placement_virtual_tx_xcvr                     (placement_virtual_tx_xcvr   ),
    .placement_virtual_fht_xcvr                    (placement_virtual_fht_xcvr  )
  );

  directphy_f_hip #(
    .num_sys_cop                                              (num_sys_cop),
    .num_xcvr_per_sys                                         (num_xcvr_per_sys),
    .l_num_hip_per_sys                                        (l_num_hip_per_sys),
    .l_num_aib_per_xcvr                                       (l_num_aib_per_xcvr),
    .l_sys_xcvrs                                              (l_sys_xcvrs),
    .l_sys_aibs                                               (l_sys_aibs),
	.l_sys_xcvrs_cascade                                      (l_sys_xcvrs_cascade),
    .l_tx_enable                                              (l_tx_enable),
    .l_rx_enable                                              (l_rx_enable),
    .enable_port_fgt_rx_cdr_divclk_link0                      (enable_port_fgt_rx_cdr_divclk_link0),
    .enable_port_fgt_rx_cdr_divclk_link1                      (enable_port_fgt_rx_cdr_divclk_link1),
    .fgt_rx_cdr_divclk_link0_sel                              (fgt_rx_cdr_divclk_link0_sel),
    .fgt_rx_cdr_divclk_link1_sel                              (fgt_rx_cdr_divclk_link1_sel),
    .l_av1_enable                                             (l_av1_enable),
    .l_num_avmm1                                              (l_num_avmm1),
    .l_av2_enable                                             (avmm2_enable_or_gpon),
    .l_num_avmm2                                              (l_num_avmm2),
    .fec_on                                                   (fec_on),

  // Silicon Revision:
    .m_silicon_revision   (silicon_revision),
    .silicon_revision     (silicon_revision),
  // Building block settings:
  // ------------------------   MAIB/AIB   -----------------------------------------------------
    .bb_m_hdpldadapt_rx_fifo_mode           (bb_m_hdpldadapt_rx_fifo_mode),
    .bb_m_hdpldadapt_rx_fifo_width          (bb_m_hdpldadapt_rx_fifo_width),
    .bb_m_hdpldadapt_rx_pld_clk1_sel        (bb_m_hdpldadapt_rx_pld_clk1_sel),
    .bb_m_hdpldadapt_rx_hdpldadapt_speed_grade (bb_m_hdpldadapt_rx_hdpldadapt_speed_grade),
    .bb_m_hdpldadapt_rx_rxfifo_pempty       (bb_m_hdpldadapt_rx_rxfifo_pempty),
    .bb_m_hdpldadapt_rx_rxfifo_pfull        (bb_m_hdpldadapt_rx_rxfifo_pfull),
    .bb_m_hdpldadapt_rx_rx_datapath_tb_sel  (bb_m_hdpldadapt_rx_rx_datapath_tb_sel),

    .bb_m_hdpldadapt_tx_duplex_mode         (bb_m_hdpldadapt_tx_duplex_mode),
    .bb_m_hdpldadapt_tx_fifo_mode           (bb_m_hdpldadapt_tx_fifo_mode),
    .bb_m_hdpldadapt_tx_fifo_width          (bb_m_hdpldadapt_tx_fifo_width),
    .bb_m_hdpldadapt_tx_pld_clk1_sel        (bb_m_hdpldadapt_tx_pld_clk1_sel),
    .bb_m_hdpldadapt_tx_pld_clk2_sel        (bb_m_hdpldadapt_tx_pld_clk2_sel),
    .bb_m_hdpldadapt_tx_hdpldadapt_speed_grade (bb_m_hdpldadapt_tx_hdpldadapt_speed_grade),
    .bb_m_hdpldadapt_tx_txfifo_pempty       (bb_m_hdpldadapt_tx_txfifo_pempty),
    .bb_m_hdpldadapt_tx_txfifo_pfull        (bb_m_hdpldadapt_tx_txfifo_pfull),
    .bb_m_hdpldadapt_tx_tx_datapath_tb_sel  (bb_m_hdpldadapt_tx_tx_datapath_tb_sel),

    .bb_m_hdpldadapt_rx_hdpldadapt_pld_rx_clk1_dcm_hz       (bb_m_hdpldadapt_rx_hdpldadapt_pld_rx_clk1_dcm_hz),
    .bb_m_hdpldadapt_rx_hdpldadapt_pld_rx_clk1_rowclk_hz    (bb_m_hdpldadapt_rx_hdpldadapt_pld_rx_clk1_rowclk_hz),
    .bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz       (bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz),
    .bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk1_rowclk_hz    (bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk1_rowclk_hz),
    .bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk2_dcm_hz       (bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk2_dcm_hz),
    .bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk2_rowclk_hz    (bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk2_rowclk_hz),

    .bb_f_ehip_aib2_rx_st_clk_en            (bb_f_ehip_aib2_rx_st_clk_en),
    .bb_f_ehip_aib2_tx_st_clk_en            (bb_f_ehip_aib2_tx_st_clk_en),
    .bb_f_ehip_aib3_rx_st_clk_en            (bb_f_ehip_aib3_rx_st_clk_en),
    .bb_f_ehip_aib3_tx_st_clk_en            (bb_f_ehip_aib3_tx_st_clk_en),
    .bb_f_aib_aibadapt_rx_rx_user_clk_sel   (bb_f_aib_aibadapt_rx_rx_user_clk_sel),
    .bb_f_aib_aibadapt_tx_tx_user_clk_sel   (bb_f_aib_aibadapt_tx_tx_user_clk_sel),
    .bb_f_aib_aib_hssi_rx_transfer_clk_hz   (bb_f_aib_aib_hssi_rx_transfer_clk_hz),
    .bb_f_aib_aib_hssi_tx_transfer_clk_hz   (bb_f_aib_aib_hssi_tx_transfer_clk_hz),
    .bb_f_aib_aib_tx_user_clk_hz (bb_f_aib_aib_tx_user_clk_hz),
    .bb_f_aib_aib_rx_user_clk_hz (bb_f_aib_aib_rx_user_clk_hz),


    .bb_f_ux_loopback_mode                  (bb_f_ux_loopback_mode),

  // ------------------------   UX TX PLL   ------------------------------------------------
    .fgt_tx_pll_cascade_enable                (fgt_tx_pll_cascade_enable),
    .fgt_tx_pll_frac_mode_enable              (fgt_tx_pll_frac_mode_enable),

    .bb_f_ux_tx_pll                           (bb_f_ux_tx_pll),
    .bb_f_ux_tx_pll_bw_sel                    (bb_f_ux_tx_pll_bw_sel),

    .bb_f_ux_synth_lc_fast_f_out_hz           (bb_f_ux_synth_lc_fast_f_out_hz),
    .bb_f_ux_synth_lc_fast_f_vco_hz           (bb_f_ux_synth_lc_fast_f_vco_hz),
    .bb_f_ux_synth_lc_fast_f_ref_hz           (bb_f_ux_synth_lc_fast_f_ref_hz),
    .bb_f_ux_synth_lc_fast_fractional_en      (bb_f_ux_synth_lc_fast_fractional_en),
    .bb_f_ux_synth_lc_fast_k_counter          (bb_f_ux_synth_lc_fast_k_counter),
    .bb_f_ux_synth_lc_fast_l_counter          (bb_f_ux_synth_lc_fast_l_counter),
    .bb_f_ux_synth_lc_fast_m_counter          (bb_f_ux_synth_lc_fast_m_counter),
    .bb_f_ux_synth_lc_fast_n_counter          (bb_f_ux_synth_lc_fast_n_counter),
    .bb_f_ux_synth_lc_fast_primary_use        (bb_f_ux_synth_lc_fast_primary_use),

    .bb_f_ux_synth_lc_med_f_out_hz            (bb_f_ux_synth_lc_med_f_out_hz),
    .bb_f_ux_synth_lc_med_f_vco_hz            (bb_f_ux_synth_lc_med_f_vco_hz),
    .bb_f_ux_synth_lc_med_f_ref_hz            (bb_f_ux_synth_lc_med_f_ref_hz),
    .bb_f_ux_synth_lc_med_fractional_en       (bb_f_ux_synth_lc_med_fractional_en),
    .bb_f_ux_synth_lc_med_k_counter           (bb_f_ux_synth_lc_med_k_counter),
    .bb_f_ux_synth_lc_med_l_counter           (bb_f_ux_synth_lc_med_l_counter),
    .bb_f_ux_synth_lc_med_m_counter           (bb_f_ux_synth_lc_med_m_counter),
    .bb_f_ux_synth_lc_med_n_counter           (bb_f_ux_synth_lc_med_n_counter),
    .bb_f_ux_synth_lc_med_primary_use         (bb_f_ux_synth_lc_med_primary_use),

    .bb_f_ux_synth_lc_slow_f_out_hz           (bb_f_ux_synth_lc_slow_f_out_hz),
    .bb_f_ux_synth_lc_slow_f_vco_hz           (bb_f_ux_synth_lc_slow_f_vco_hz),
    .bb_f_ux_synth_lc_slow_f_ref_hz           (bb_f_ux_synth_lc_slow_f_ref_hz),
    .bb_f_ux_synth_lc_slow_fractional_en      (bb_f_ux_synth_lc_slow_fractional_en),
    .bb_f_ux_synth_lc_slow_k_counter          (bb_f_ux_synth_lc_slow_k_counter),
    .bb_f_ux_synth_lc_slow_l_counter          (bb_f_ux_synth_lc_slow_l_counter),
    .bb_f_ux_synth_lc_slow_m_counter          (bb_f_ux_synth_lc_slow_m_counter),
    .bb_f_ux_synth_lc_slow_n_counter          (bb_f_ux_synth_lc_slow_n_counter),
    .bb_f_ux_synth_lc_slow_primary_use        (bb_f_ux_synth_lc_slow_primary_use),

    .bb_f_ux_synth_lc_fast_f_rx_postdiv_hz    (bb_f_ux_synth_lc_fast_f_rx_postdiv_hz),
    .bb_f_ux_synth_lc_fast_rx_postdiv_counter (bb_f_ux_synth_lc_fast_rx_postdiv_counter),
    .bb_f_ux_synth_lc_med_f_rx_postdiv_hz     (bb_f_ux_synth_lc_med_f_rx_postdiv_hz),
    .bb_f_ux_synth_lc_med_rx_postdiv_counter  (bb_f_ux_synth_lc_med_rx_postdiv_counter),
    .bb_f_ux_synth_lc_slow_f_rx_postdiv_hz    (bb_f_ux_synth_lc_slow_f_rx_postdiv_hz),
    .bb_f_ux_synth_lc_slow_rx_postdiv_counter (bb_f_ux_synth_lc_slow_rx_postdiv_counter),
    .bb_f_ux_tx_fb_div_emb_mult_counter       (bb_f_ux_tx_fb_div_emb_mult_counter),


  // ------------------------   UX Clock-outs   ------------------------------------------------
    .bb_f_ux_synth_lc_fast_tx_postdiv_counter (bb_f_ux_synth_lc_fast_tx_postdiv_counter),
    .bb_f_ux_synth_lc_med_tx_postdiv_counter  (bb_f_ux_synth_lc_med_tx_postdiv_counter),
    .bb_f_ux_synth_lc_slow_tx_postdiv_counter (bb_f_ux_synth_lc_slow_tx_postdiv_counter),
    .bb_f_ux_synth_lc_fast_tx_postdiv_fractional_en  (bb_f_ux_synth_lc_fast_tx_postdiv_fractional_en),
    .bb_f_ux_synth_lc_med_tx_postdiv_fractional_en   (bb_f_ux_synth_lc_med_tx_postdiv_fractional_en),
    .bb_f_ux_synth_lc_slow_tx_postdiv_fractional_en  (bb_f_ux_synth_lc_slow_tx_postdiv_fractional_en),
    .bb_f_ux_synth_lc_fast_f_tx_postdiv_hz           (bb_f_ux_synth_lc_fast_f_tx_postdiv_hz),
    .bb_f_ux_synth_lc_med_f_tx_postdiv_hz            (bb_f_ux_synth_lc_med_f_tx_postdiv_hz),
    .bb_f_ux_synth_lc_slow_f_tx_postdiv_hz           (bb_f_ux_synth_lc_slow_f_tx_postdiv_hz),
    .bb_f_ux_tx_user_clk1_en                         (bb_f_ux_tx_user_clk1_en),
    .bb_f_ux_tx_user_clk2_en                         (bb_f_ux_tx_user_clk2_en),
    .bb_f_ux_tx_user_clk1_mux                        (bb_f_ux_tx_user_clk1_mux),
    .bb_f_ux_tx_user_clk2_mux                        (bb_f_ux_tx_user_clk2_mux),
    .bb_f_ux_tx_user_clk_slow_med_mux                (bb_f_ux_tx_user_clk_slow_med_mux),
    .bb_f_ux_rx_user_clk_en                          (bb_f_ux_rx_user_clk_en),

    .targettype_bb_f_ux_tx_pll                         (targettype_bb_f_ux_tx_pll),
    .targettype_bb_f_ux_tx_pll_bw_sel                  (targettype_bb_f_ux_tx_pll_bw_sel),

    .targettype_bb_f_ux_synth_lc_fast_f_out_hz         (targettype_bb_f_ux_synth_lc_fast_f_out_hz),
    .targettype_bb_f_ux_synth_lc_fast_f_vco_hz         (targettype_bb_f_ux_synth_lc_fast_f_vco_hz),
    .targettype_bb_f_ux_synth_lc_fast_f_ref_hz         (targettype_bb_f_ux_synth_lc_fast_f_ref_hz),
    .targettype_bb_f_ux_synth_lc_fast_fractional_en    (targettype_bb_f_ux_synth_lc_fast_fractional_en),
    .targettype_bb_f_ux_synth_lc_fast_k_counter        (targettype_bb_f_ux_synth_lc_fast_k_counter),
    .targettype_bb_f_ux_synth_lc_fast_l_counter        (targettype_bb_f_ux_synth_lc_fast_l_counter),
    .targettype_bb_f_ux_synth_lc_fast_m_counter        (targettype_bb_f_ux_synth_lc_fast_m_counter),
    .targettype_bb_f_ux_synth_lc_fast_n_counter        (targettype_bb_f_ux_synth_lc_fast_n_counter),
    .targettype_bb_f_ux_synth_lc_fast_primary_use      (targettype_bb_f_ux_synth_lc_fast_primary_use),

    .targettype_bb_f_ux_synth_lc_med_f_out_hz          (targettype_bb_f_ux_synth_lc_med_f_out_hz),
    .targettype_bb_f_ux_synth_lc_med_f_vco_hz          (targettype_bb_f_ux_synth_lc_med_f_vco_hz),
    .targettype_bb_f_ux_synth_lc_med_f_ref_hz          (targettype_bb_f_ux_synth_lc_med_f_ref_hz),
    .targettype_bb_f_ux_synth_lc_med_fractional_en     (targettype_bb_f_ux_synth_lc_med_fractional_en),
    .targettype_bb_f_ux_synth_lc_med_k_counter         (targettype_bb_f_ux_synth_lc_med_k_counter),
    .targettype_bb_f_ux_synth_lc_med_l_counter         (targettype_bb_f_ux_synth_lc_med_l_counter),
    .targettype_bb_f_ux_synth_lc_med_m_counter         (targettype_bb_f_ux_synth_lc_med_m_counter),
    .targettype_bb_f_ux_synth_lc_med_n_counter         (targettype_bb_f_ux_synth_lc_med_n_counter),
    .targettype_bb_f_ux_synth_lc_med_primary_use       (targettype_bb_f_ux_synth_lc_med_primary_use),

    .targettype_bb_f_ux_synth_lc_slow_f_out_hz         (targettype_bb_f_ux_synth_lc_slow_f_out_hz),
    .targettype_bb_f_ux_synth_lc_slow_f_vco_hz         (targettype_bb_f_ux_synth_lc_slow_f_vco_hz),
    .targettype_bb_f_ux_synth_lc_slow_f_ref_hz         (targettype_bb_f_ux_synth_lc_slow_f_ref_hz),
    .targettype_bb_f_ux_synth_lc_slow_fractional_en    (targettype_bb_f_ux_synth_lc_slow_fractional_en),
    .targettype_bb_f_ux_synth_lc_slow_k_counter        (targettype_bb_f_ux_synth_lc_slow_k_counter),
    .targettype_bb_f_ux_synth_lc_slow_l_counter        (targettype_bb_f_ux_synth_lc_slow_l_counter),
    .targettype_bb_f_ux_synth_lc_slow_m_counter        (targettype_bb_f_ux_synth_lc_slow_m_counter),
    .targettype_bb_f_ux_synth_lc_slow_n_counter        (targettype_bb_f_ux_synth_lc_slow_n_counter),
    .targettype_bb_f_ux_synth_lc_slow_primary_use      (targettype_bb_f_ux_synth_lc_slow_primary_use),
	.targettype_bb_f_ux_tx_fb_div_emb_mult_counter     (targettype_bb_f_ux_tx_fb_div_emb_mult_counter ),
	

  // ------------------------   UX RX PLL   ------------------------------------------------
    .bb_f_ux_cdr_postdiv_counter               (bb_f_ux_cdr_postdiv_counter),
    .bb_f_ux_cdr_postdiv_fractional_en         (bb_f_ux_cdr_postdiv_fractional_en),
    .bb_f_ux_cdr_f_postdiv_hz                  (bb_f_ux_cdr_f_postdiv_hz),

    .bb_f_ux_cdr_bw_sel                     (bb_f_ux_cdr_bw_sel),
    .bb_f_ux_cdr_f_out_hz                   (bb_f_ux_cdr_f_out_hz),
    .bb_f_ux_cdr_f_vco_hz                   (bb_f_ux_cdr_f_vco_hz),
    .bb_f_ux_cdr_f_ref_hz                   (bb_f_ux_cdr_f_ref_hz),
    .bb_f_ux_cdr_l_counter                  (bb_f_ux_cdr_l_counter),
    .bb_f_ux_cdr_m_counter                  (bb_f_ux_cdr_m_counter),
    .bb_f_ux_cdr_n_counter                  (bb_f_ux_cdr_n_counter),
    //.bb_f_ux_cdr_fb_div_emb_mult_counter    (bb_f_ux_cdr_fb_div_emb_mult_counter),
	

  // ------------------------   EHIP        ------------------------------------------------
    .bb_f_ehip_frac_size                                      (bb_f_ehip_frac_size), 
    .bb_f_ehip_duplex_mode                                    (bb_f_ehip_duplex_mode), 
    .bb_f_ehip_fec_mode                                       (bb_f_ehip_fec_mode), 
    .bb_f_ehip_fec_spec                                       (bb_f_ehip_fec_spec),
    .bb_f_ehip_fec_802p3ck                                    (bb_f_ehip_fec_802p3ck), 
    .bb_f_ehip_fec_clk_src                                    (bb_f_ehip_fec_clk_src),
    .bb_f_ehip_sys_clk_src                                    (bb_f_ehip_sys_clk_src),
    .bb_f_ehip_lpbk_mode                                      (bb_f_ehip_lpbk_mode), 
    .bb_f_ehip_lphy_xcvrif_lpbk_en                            (bb_f_ehip_lphy_xcvrif_lpbk_en), 
    .bb_f_ehip_mac_mode                                       (bb_f_ehip_mac_mode), 
    .bb_f_ehip_rx_aib_if_fifo_mode                            (bb_f_ehip_rx_aib_if_fifo_mode), 
    .dec_bb_f_ehip_rx_datarate                                (dec_bb_f_ehip_rx_datarate), 
    .bb_f_ehip_rx_en                                          (bb_f_ehip_rx_en), 
    .bb_f_ehip_rx_excvr_if_fifo_mode                          (bb_f_ehip_rx_excvr_if_fifo_mode),
    .bb_f_ehip_rx_excvr_gb_ratio_mode                         (bb_f_ehip_rx_excvr_gb_ratio_mode),
    .bb_f_ehip_rx_fec_enable                                  (bb_f_ehip_rx_fec_enable), 
    .bb_f_ehip_rx_pcs_mode                                    (bb_f_ehip_rx_pcs_mode), 
    .bb_f_ehip_rx_primary_use                                 (bb_f_ehip_rx_primary_use), 
    .bb_f_ehip_rx_total_xcvr                                  (bb_f_ehip_rx_total_xcvr), 
    .bb_f_ehip_rx_xcvr_width                                  (bb_f_ehip_rx_xcvr_width), 
    .bb_f_ehip_tx_pmadirect_single_width                      (bb_f_ehip_tx_pmadirect_single_width),
    .bb_f_ehip_rx_pmadirect_single_width                      (bb_f_ehip_rx_pmadirect_single_width),
    .bb_f_ehip_speed_map                                      (bb_f_ehip_speed_map), 
    .bb_f_ehip_tx_aib_if_fifo_mode                            (bb_f_ehip_tx_aib_if_fifo_mode), 
    .dec_bb_f_ehip_tx_datarate                                (dec_bb_f_ehip_tx_datarate), 
    .bb_f_ehip_tx_en                                          (bb_f_ehip_tx_en), 
    .bb_f_ehip_tx_excvr_if_fifo_mode                          (bb_f_ehip_tx_excvr_if_fifo_mode), 
    .bb_f_ehip_tx_excvr_gb_ratio_mode                         (bb_f_ehip_tx_excvr_gb_ratio_mode), 
    .bb_f_ehip_tx_fec_enable                                  (bb_f_ehip_tx_fec_enable), 
    .bb_f_ehip_tx_pcs_mode                                    (bb_f_ehip_tx_pcs_mode), 
    .bb_f_ehip_tx_primary_use                                 (bb_f_ehip_tx_primary_use), 
    .bb_f_ehip_tx_total_xcvr                                  (bb_f_ehip_tx_total_xcvr), 
    .bb_f_ehip_tx_xcvr_width                                  (bb_f_ehip_tx_xcvr_width), 
    .bb_f_ehip_xcvr_mode                                      (bb_f_ehip_xcvr_mode),
    .bb_f_ehip_xcvr_type                                      (bb_f_ehip_xcvr_type),
    .dec_bb_f_ux_f_out_rx_cdr_pll_hz                          (dec_bb_f_ux_f_out_rx_cdr_pll_hz),
    .bb_f_ehip_is_fec_part_of_reconfig                        (bb_f_ehip_is_fec_part_of_reconfig),
    .bb_f_ux_rx_cdr_pll_enable_half_divider                   (bb_f_ux_rx_cdr_pll_enable_half_divider),
    .bb_f_ux_rx_cdr_pll_fast_refclk_mode                      (bb_f_ux_rx_cdr_pll_fast_refclk_mode),
    .bb_f_ux_rx_cdr_pll_l_counter                             (bb_f_ux_rx_cdr_pll_l_counter),
    .bb_f_ux_rx_cdr_pll_n_counter                             (bb_f_ux_rx_cdr_pll_n_counter),
    .bb_f_ux_rx_cdr_pll_postdiv_en                            (bb_f_ux_rx_cdr_pll_postdiv_en),
    .dec_bb_f_ux_f_out_synth_lc_hz                            (dec_bb_f_ux_f_out_synth_lc_hz),
    .dec_bb_f_ux_f_mod_synth_lc_hz                            (dec_bb_f_ux_f_mod_synth_lc_hz),

    .bb_f_ux_synch_lc_modula_to_ren                           (bb_f_ux_synch_lc_modula_to_ren),
    .bb_f_ux_synth_lc_enable_half_divider                     (bb_f_ux_synth_lc_enable_half_divider),
    .bb_f_ux_synth_lc_postdiv_en                              (bb_f_ux_synth_lc_postdiv_en),
    .bb_f_ux_fractional_mode                                  (bb_f_ux_fractional_mode),
    .dec_bb_f_ux_f_out_synth_ring_hz                          (dec_bb_f_ux_f_out_synth_ring_hz),
    .bb_f_ux_synch_ring_modula_to_ren                         (bb_f_ux_synch_ring_modula_to_ren),
    .bb_f_ux_synth_ring_enable_half_divider                   (bb_f_ux_synth_ring_enable_half_divider),
    .bb_f_ux_synth_ring_fast_refclk_mode                      (bb_f_ux_synth_ring_fast_refclk_mode),
    .bb_f_ux_synth_ring_l_counter                             (bb_f_ux_synth_ring_l_counter),
    .bb_f_ux_synth_ring_n_counter                             (bb_f_ux_synth_ring_n_counter),
    .bb_f_ux_synth_ring_pcs_postdiv_en                        (bb_f_ux_synth_ring_pcs_postdiv_en),
    .bb_f_ux_digital_core_divider                             (bb_f_ux_digital_core_divider),
    .bb_f_ux_rx_clkdiv                                        (bb_f_ux_rx_clkdiv),
    .bb_f_ux_tx_clkdiv                                        (bb_f_ux_tx_clkdiv),
    .bb_f_ux_rx_width                                         (bb_f_ux_rx_width),
    .bb_f_ux_tx_width                                         (bb_f_ux_tx_width),
    .bb_f_ux_txrx_line_encoding_type                          (bb_f_ux_txrx_line_encoding_type),
    .bb_f_ux_rx_bond_size                                     (bb_f_ux_rx_bond_size),
    .bb_f_ux_tx_bond_size                                     (bb_f_ux_tx_bond_size),
    .bb_f_ux_rx_protocol                                      (bb_f_ux_rx_protocol),
    .bb_f_ux_tx_protocol                                      (bb_f_ux_tx_protocol),
    .bb_f_ux_txrx_channel_operation                           (bb_f_ux_txrx_channel_operation),
    .bb_f_ux_txrx_xcvr_speed_bucket                           (bb_f_ux_txrx_xcvr_speed_bucket),
    .bb_f_ux_squelch_detect                                   (bb_f_ux_squelch_detect),
    .bb_f_ux_prbs_gen_en                                      (bb_f_ux_prbs_gen_en),
    .bb_f_ux_prbs_mon_en                                      (bb_f_ux_prbs_mon_en),
    .bb_f_ux_prbs_pattern                                     (bb_f_ux_prbs_pattern),
    .bb_f_ux_rx_pam4_graycode_en                              (bb_f_ux_rx_pam4_graycode_en),
    .bb_f_ux_tx_pam4_graycode_en                              (bb_f_ux_tx_pam4_graycode_en),
    .bb_f_ux_rx_pam4_precode_en                               (bb_f_ux_rx_pam4_precode_en),
    .bb_f_ux_tx_pam4_precode_en                               (bb_f_ux_tx_pam4_precode_en),
    .bb_f_ux_force_cdr_ltd                                    (bb_f_ux_force_cdr_ltd),
    .bb_f_ux_force_cdr_ltr                                    (bb_f_ux_force_cdr_ltr),
    .bb_f_ux_enable_port_control_of_cdr_ltr_ltd               (bb_f_ux_enable_port_control_of_cdr_ltr_ltd),
    .bb_f_ux_flux_mode                                        (bb_f_ux_flux_mode),
    .bb_f_ux_core_pll                                         (bb_f_ux_core_pll ),
    .bb_f_ux_rx_adapt_mode                                    (bb_f_ux_rx_adapt_mode),
    .bb_f_ux_engineered_link_mode                             (bb_f_ux_engineered_link_mode),
    .bb_f_ux_tx_tuning_hint                                   (bb_f_ux_tx_tuning_hint),
    .bb_f_ux_rx_tuning_hint                                   (bb_f_ux_rx_tuning_hint),
	.bb_f_ux_tx_spread_spectrum_en                            (bb_f_ux_tx_spread_spectrum_en),

    .bb_f_bk_package_type                                     (bb_f_bk_package_type),
    .bb_f_bk_speed_grade                                      (bb_f_bk_speed_grade),
    .bb_f_bk_sup_mode                                         (bb_f_bk_sup_mode),                           
    .bb_f_bk_tx_bond_size                                     (bb_f_bk_tx_bond_size),                     
    .bb_f_bk_tx_line_rate                                     (bb_f_bk_tx_line_rate),                     
    .bb_f_bk_tx_protocol                                      (bb_f_bk_tx_protocol),                     
    .bb_f_bk_txrx_line_encoding_type                          (bb_f_bk_txrx_line_encoding_type),       
                                                                                                           
    .bb_f_bk_txout_tristate_en                                (bb_f_bk_txout_tristate_en),
    .bb_f_bk_tx_termination                                   (bb_f_bk_tx_termination),
    .bb_f_bk_tx_invert_p_and_n                                (bb_f_bk_tx_invert_p_and_n),
    .bb_f_bk_txeq_main_tap                                    (bb_f_bk_txeq_main_tap       ), 
    .bb_f_bk_txeq_post_tap_1                                  (bb_f_bk_txeq_post_tap_1     ), 
    .bb_f_bk_txeq_post_tap_2                                  (bb_f_bk_txeq_post_tap_2     ), 
    .bb_f_bk_txeq_post_tap_3                                  (bb_f_bk_txeq_post_tap_3     ), 
    .bb_f_bk_txeq_post_tap_4                                  (bb_f_bk_txeq_post_tap_4     ), 
    .bb_f_bk_txeq_pre_tap_1                                   (bb_f_bk_txeq_pre_tap_1      ), 
    .bb_f_bk_txeq_pre_tap_2                                   (bb_f_bk_txeq_pre_tap_2      ), 
    .bb_f_bk_txeq_pre_tap_3                                   (bb_f_bk_txeq_pre_tap_3      ), 

    .bb_f_bk_refclk_source_lane_pll                           (bb_f_bk_refclk_source_lane_pll),           
    .bb_f_bk_pll_pcs3334_ratio                                (bb_f_bk_pll_pcs3334_ratio),
    .bb_f_bk_pll_rx_pcs3334_ratio                             (bb_f_bk_pll_rx_pcs3334_ratio),
    .bb_f_bk_pam4_rxgrey_code                                 (bb_f_bk_pam4_rxgrey_code),                
    .bb_f_bk_rx_user_clk1_en                                  (bb_f_bk_rx_user_clk1_en ),        
    .bb_f_bk_rx_user_clk2_en                                  (bb_f_bk_rx_user_clk2_en ),        
    .bb_f_bk_tx_user_clk1_en                                  (bb_f_bk_tx_user_clk1_en ),        
    .bb_f_bk_tx_user_clk2_en                                  (bb_f_bk_tx_user_clk2_en ),        
    .bb_f_bk_rx_user_clk1_sel                                 (bb_f_bk_rx_user_clk1_sel),        
    .bb_f_bk_rx_user_clk2_sel                                 (bb_f_bk_rx_user_clk2_sel),        
    .bb_f_bk_tx_user_clk1_sel                                 (bb_f_bk_tx_user_clk1_sel),        
    .bb_f_bk_tx_user_clk2_sel                                 (bb_f_bk_tx_user_clk2_sel),        
                                                                
    .bb_f_bk_an_mode                                          (bb_f_bk_an_mode),                          
    .bb_f_bk_bk_dl_enable                                     (bb_f_bk_bk_dl_enable),                     
    .bb_f_bk_loopback_mode                                    (bb_f_bk_loopback_mode),                    
    .bb_f_bk_bti_protected                                    (bb_f_bk_bti_protected),          
                                                                       
    .bb_f_bk_rx_termination                                   (bb_f_bk_rx_termination ),
    .bb_f_bk_rx_invert_p_and_n                                (bb_f_bk_rx_invert_p_and_n),
    .bb_f_bk_bk_en_rxdat_profile                              (bb_f_bk_bk_en_rxdat_profile),              
                                                                                                           
    .bb_f_bk_bk_lnx_txovf_rxbdstb_inten                       (bb_f_bk_bk_lnx_txovf_rxbdstb_inten),       
    .bb_f_bk_bk_lnx_txudf_pldrstb_inten                       (bb_f_bk_bk_lnx_txudf_pldrstb_inten),     
    .bb_f_bk_bk_tx_lnx_ovf_inten_dirsignal                    (bb_f_bk_bk_tx_lnx_ovf_inten_dirsignal),    
    .bb_f_bk_bk_tx_lnx_rxbadst_inten_dirsignal                (bb_f_bk_bk_tx_lnx_rxbadst_inten_dirsignal),
    .bb_f_bk_bk_tx_lnx_udf_inten_dirsignal                    (bb_f_bk_bk_tx_lnx_udf_inten_dirsignal),    
                                                              
    .bb_f_bk_bk_rx_lat_bit_for_async                          (bb_f_bk_bk_rx_lat_bit_for_async),
    .bb_f_bk_bk_rxbit_cntr_pma                                (bb_f_bk_bk_rxbit_cntr_pma),                
    .bb_f_bk_bk_rxbit_rollover                                (bb_f_bk_bk_rxbit_rollover),

    .bb_f_bk_rx_precode_en                                    (bb_f_bk_rx_precode_en),
    .bb_f_bk_tx_precode_en                                    (bb_f_bk_tx_precode_en),
    .bb_f_bk_pll_n_counter                                    (bb_f_bk_pll_n_counter),

    .enable_port_latency_measurement                          (enable_port_latency_measurement) // enable deterministic latency

  ) dphy_hip_inst (
//PLD Interface
    .hip_aib_fsr_in  ( hip_aib_fsr_in ),
    .hip_aib_fsr_out  ( hip_aib_fsr_out ),
    .hip_aib_ssr_in  ( hip_aib_ssr_in ),
    .hip_aib_ssr_out  ( hip_aib_ssr_out ),
	.cpi_cmn_busy_real (cpi_cmn_busy_real),
    .pld_10g_krfec_rx_blk_lock  ( pld_10g_krfec_rx_blk_lock ),
    .pld_10g_krfec_rx_clr_errblk_cnt  ( pld_10g_krfec_rx_clr_errblk_cnt ),
    .pld_10g_krfec_rx_diag_data_status  ( pld_10g_krfec_rx_diag_data_status ),
    .pld_10g_krfec_rx_frame  ( pld_10g_krfec_rx_frame ),
    .pld_10g_rx_crc32_err  ( pld_10g_rx_crc32_err ),
    .pld_10g_rx_frame_lock  ( pld_10g_rx_frame_lock ),
    .pld_10g_rx_hi_ber  ( pld_10g_rx_hi_ber ),
    .pld_10g_tx_bitslip  ( pld_10g_tx_bitslip ),
    .pld_8g_a1a2_k1k2_flag  ( pld_8g_a1a2_k1k2_flag ),
    .pld_8g_bitloc_rev_en  ( pld_8g_bitloc_rev_en ),
    .pld_8g_byte_rev_en  ( pld_8g_byte_rev_en ),
    .pld_8g_eidleinfersel  ( pld_8g_eidleinfersel ),
    .pld_8g_empty_rmf  ( pld_8g_empty_rmf ),
    .pld_8g_encdt  ( pld_8g_encdt ),
    .pld_8g_full_rmf  ( pld_8g_full_rmf ),
    .pld_8g_tx_boundary_sel  ( pld_8g_tx_boundary_sel ),
    .pld_8g_wa_boundary  ( pld_8g_wa_boundary ),
    .pld_krfec_tx_alignment  ( pld_krfec_tx_alignment ),
    .pld_pma_adapt_done  ( pld_pma_adapt_done ),
    .pld_pma_adapt_start  ( pld_pma_adapt_start ),
    .pld_pma_csr_test_dis  ( pld_pma_csr_test_dis ),
    .pld_pma_early_eios  ( pld_pma_early_eios ),
    .pld_pma_eye_monitor  ( pld_pma_eye_monitor ),
    .pld_pma_fpll_clk0bad  ( pld_pma_fpll_clk0bad ),
    .pld_pma_fpll_clk1bad  ( pld_pma_fpll_clk1bad ),
    .pld_pma_fpll_clksel  ( pld_pma_fpll_clksel ),
    .pld_pma_fpll_cnt_sel  ( pld_pma_fpll_cnt_sel ),
    .pld_pma_fpll_extswitch  ( pld_pma_fpll_extswitch ),
    .pld_pma_fpll_num_phase_shifts  ( pld_pma_fpll_num_phase_shifts ),
    .pld_pma_fpll_pfden  ( pld_pma_fpll_pfden ),
    .pld_pma_fpll_phase_done  ( pld_pma_fpll_phase_done ),
    .pld_pma_fpll_up_dn_lc_lf_rstn  ( pld_pma_fpll_up_dn_lc_lf_rstn ),
    .pld_pma_nrpi_freeze  ( pld_pma_nrpi_freeze ),
    .pld_pma_pcie_sw_done  ( pld_pma_pcie_sw_done ),
  //.pld_pma_pcie_switch  ( pld_pma_pcie_switch ),
    .pld_pma_ppm_lock  ( pld_pma_ppm_lock ),
    .pld_pma_reserved_in  ( pld_pma_reserved_in ),
    .pld_pma_reserved_out  ( pld_pma_reserved_out ),
    .pld_pma_rs_lpbk_b  ( pld_pma_rs_lpbk_b ),
    .pld_pma_rx_detect_valid  ( pld_pma_rx_detect_valid ),
    .pld_pma_rx_found  ( pld_pma_rx_found ),
    .pld_pma_signal_ok  ( pld_pma_signal_ok ),
    .pld_pma_tx_bitslip  ( pld_pma_tx_bitslip ),
    .pld_pma_tx_qpi_pulldn  ( pld_pma_tx_qpi_pulldn ),
    .pld_pma_tx_qpi_pullup  ( pld_pma_tx_qpi_pullup ),
    .pld_pmaif_mask_tx_pll  ( pld_pmaif_mask_tx_pll ),
    .pld_pmaif_rxclkslip  ( pld_pmaif_rxclkslip ),
    .pld_polinv_rx  ( pld_polinv_rx ),
    .pld_polinv_tx  ( pld_polinv_tx ),
    .pld_rx_hssi_fifo_empty  ( pld_rx_hssi_fifo_empty ),
    .pld_rx_hssi_fifo_full  ( pld_rx_hssi_fifo_full ),
    .pld_rx_prbs_done  ( pld_rx_prbs_done ),
    .pld_rx_prbs_err  ( pld_rx_prbs_err ),
    .pld_rx_prbs_err_clr  ( pld_rx_prbs_err_clr ),
    .pld_syncsm_en  ( pld_syncsm_en ),
    .pld_test_data  ( pld_test_data ),
    .pld_tx_hssi_fifo_empty  ( pld_tx_hssi_fifo_empty ),
    .pld_tx_hssi_fifo_full  ( pld_tx_hssi_fifo_full ),

// Serial pins
    .rx_serial_data                ( rx_serial_data   ),
    .rx_serial_data_n              ( rx_serial_data_n ),
    .tx_serial_data                ( tx_serial_data   ),
    .tx_serial_data_n              ( tx_serial_data_n ),

// MAIB Status signals:
    .tx_fifo_full                  ( tx_fifo_full    ),
    .tx_fifo_empty                 ( tx_fifo_empty   ),
    .tx_fifo_pfull                 ( tx_fifo_pfull   ),
    .tx_fifo_pempty                ( tx_fifo_pempty  ),
    .tx_dll_lock                   ( tx_dll_lock     ),
    .rx_fifo_full                  ( rx_fifo_full    ),
    .rx_fifo_empty                 ( rx_fifo_empty   ),
    .rx_fifo_pfull                 ( rx_fifo_pfull   ),
    .rx_fifo_pempty                ( rx_fifo_pempty  ),
    .rx_fifo_rd_en                 ( rx_fifo_rd_en   ),

// UX BB signals between HIP and SIP
    .oct_pcs_rxsignaldetect_lx_a       (w_oct_pcs_rxsignaldetect_lx_a),   
    .octl_pcs_rxsignaldetect_lfps_lx_a (w_octl_pcs_rxsignaldetect_lfps_lx_a),     
    .oct_pcs_all_synthlockstatus       (w_oct_pcs_all_synthlockstatus),                 
    .oct_pcs_rxcdrlock2data_lx_a       (w_oct_pcs_rxcdrlock2data_lx_a),          
    .oct_pcs_rxcdrlockstatus_lx_a      (w_oct_pcs_rxcdrlockstatus_lx_a),        
    .octl_pcs_txstatus_lx_a            (w_octl_pcs_txstatus_lx_a),   
    .octl_pcs_rxstatus_lx_a            (w_octl_pcs_rxstatus_lx_a),     
    .ictl_pcs_rxovrcdrlock2dataen_lx_a (w_ictl_pcs_rxovrcdrlock2dataen_lx_a),  
    .ictl_pcs_rxovrcdrlock2data_lx_a   (w_ictl_pcs_rxovrcdrlock2data_lx_a),
    .ictl_pcs_txbeacon_lx_a            (w_ictl_pcs_txbeacon_lx_a),
    .flux_top__iflux_ingress_direct__231(w_flux_top__iflux_ingress_direct__231),
    .i_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t (w_i_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t),
    .ictl_pcs_rxeiosdetectstat_lx_a (w_ictl_pcs_rxeiosdetectstat_lx_a),

// BK BB signals between HIP and SIP
    .fht_ingress_direct                (fht_ingress_direct),  
    .fht_rx_direct                     (fht_rx_direct     ),      
    .fht_rxsrds_rdy                    (fht_rxsrds_rdy    ), 
    .fht_latency_pulse                 (fht_latency_pulse),    

// Reference and SystemPLL clocks
    .rx_cdr_divclk_link0           (rx_cdr_divclk_link0),
    .rx_cdr_divclk_link1           (rx_cdr_divclk_link1),
    .tx_pll_refclk_link            (tx_pll_refclk_link),
    .system_pll_clk_link           (system_pll_clk_link),
    .rx_cdr_refclk_link            (rx_cdr_refclk_link), 


// PLD Interface:  Clocks
    .pld_rx_clk1_dcm               ( int_rx_coreclkin_dclk    ),
    .pld_rx_clk1_rowclk            ( int_rx_coreclkin_rowclk  ),
    .pld_rx_clk2_rowclk            ( {l_sys_aibs{1'b0}}       ),

    .pld_tx_clk1_dcm               ( int_tx_coreclkin_dclk    ),
    .pld_tx_clk2_dcm               ( int_tx_coreclkin2_dclk   ),
    .pld_tx_clk1_rowclk            ( int_tx_coreclkin_rowclk  ),
    .pld_tx_clk2_rowclk            ( int_tx_coreclkin2_rowclk ),

    .pld_pcs_rx_clk_out1_dcm       ( rx_clkout        ),
    .pld_pcs_rx_clk_out1_hioint    ( rx_clkout_hioint ),
    .pld_pcs_rx_clk_out2_dcm       ( rx_clkout2       ),
    .pld_pcs_rx_clk_out2_hioint    ( rx_clkout2_hioint),

    .pld_pcs_tx_clk_out1_dcm       ( tx_clkout        ),
    .pld_pcs_tx_clk_out1_hioint    ( tx_clkout_hioint ),
    .pld_pcs_tx_clk_out2_dcm       ( tx_clkout2       ),
    .pld_pcs_tx_clk_out2_hioint    ( tx_clkout2_hioint),

// Deterministic latency
    .dl_sclk                       (dl_clk),
    .tx_dl_async_pulse             (tx_dl_async_pulse),
    .rx_dl_async_pulse             (rx_dl_async_pulse),
    .tx_dl_measure_sel             (tx_dl_measure_sel),
    .rx_dl_measure_sel             (rx_dl_measure_sel),
// AIB
    .sync_data_from_aib                            ( sync_data_from_aib  ),
    .sync_data_to_aib                              ( sync_data_to_aib  ),


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
    .pld_avmm2_clk_rowclk                          ( pld_avmm2_clk_rowclk       ),
    .pld_avmm2_cmdfifo_wr_full                     ( pld_avmm2_cmdfifo_wr_full  ),
    .pld_avmm2_cmdfifo_wr_pfull                    ( pld_avmm2_cmdfifo_wr_pfull ),
    .pld_avmm2_request                             ( pld_avmm2_request          ),
    .pld_pll_cal_done                              ( pld_pll_cal_done           ),
    //
    .pld_avmm2_write                               ( pld_avmm2_write            ),
    .pld_avmm2_read                                ( pld_avmm2_read             ),
    .pld_avmm2_reg_addr                            ( pld_avmm2_reg_addr         ),
    .pld_avmm2_readdata                            ( pld_avmm2_readdata         ),
    .pld_avmm2_writedata                           ( pld_avmm2_writedata        ),
    .pld_avmm2_readdatavalid                       ( pld_avmm2_readdatavalid    ),
    .pld_avmm2_reserved_in                         ( pld_avmm2_reserved_in      ),
    .pld_avmm2_reserved_out                        ( pld_avmm2_reserved_out     ),

   // Link ports for instantiation of SRC IP
    .placement_virtual_rx_xcvr                     (placement_virtual_rx_xcvr   ),
    .placement_virtual_tx_xcvr                     (placement_virtual_tx_xcvr   ),
    .placement_virtual_fht_xcvr                    (placement_virtual_fht_xcvr  )


  );

// RX de-skew ////
localparam rx_deskew_bit = pldif_rx_double_width_transfer_enable ? 7'd78 : 7'd36; 
localparam rx_deskew_on = rx_deskew_en && l_rx_deskew_enable;

localparam l_per_rx_dsk_inst = fec_on ? (l_num_aib_per_xcvr*num_xcvr_per_sys) : l_num_aib_per_xcvr;
localparam num_rx_dsk_inst = fec_on ? 1 : num_xcvr_per_sys; //per sys

   reg  [l_sys_aibs-1:0][80-1:0]  rx_skewed_data;
   reg  [l_sys_aibs-1:0]            rx_skewed_pulse;
   wire  [l_sys_aibs-1:0][80-1:0]  o_aib_deskew_data;
   wire [num_rx_dsk_inst*num_sys_cop-1:0]      int_o_deskew_done;
   wire [num_sys_cop-1:0]               o_deskew_done;
   reg  [l_sys_aibs*80-1:0]         int_rx_parallel_data;
   
 genvar idx_sys_cop;   

generate
  genvar k; 
       for(k=0; k<l_sys_aibs; k=k+1) begin: tx_data_sel
           assign tx_parallel_data_sel[k*80+:80] =  txsimpleinterface_enable ? {tx_parallel_data[((k*76)+36)+:40],fgt_tx_pma_elecidle[((4*k)+3)],tx_parallel_data[((76*k)+35)],fgt_tx_pma_elecidle[k*4+:3],tx_parallel_data[k*76+:35]} : tx_parallel_data[k*80+:80];
       end    
endgenerate
 
generate
if (rx_deskew_on) begin: directphy_rx_deskew
   wire [num_sys_cop-1:0]                                rx_deskew_reset_n_fec_per_sys;
   wire [num_xcvr_per_sys*num_sys_cop-1:0]               rx_deskew_reset_n;
   wire [num_xcvr_per_sys*num_sys_cop-1:0]               rx_deskew_reset_n_resync;

  genvar l;
       for(l=0;l<l_sys_aibs;l=l+1)begin: skewed_data_ln
          assign rx_skewed_data[l] = int_rx_skewed_data[l*80+:80];
          assign rx_skewed_pulse[l] = int_rx_skewed_data[l*80+rx_deskew_bit]; //de-skew bit
       end
 for(idx_sys_cop=0;idx_sys_cop<num_sys_cop;idx_sys_cop=idx_sys_cop+1) begin: persys
     
   // RX de-skew reset
     assign rx_deskew_reset_n_fec_per_sys[idx_sys_cop] = &rx_lane_out_of_reset[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys];
     assign rx_deskew_reset_n[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys] = fec_on ? {{num_xcvr_per_sys}{rx_deskew_reset_n_fec_per_sys[idx_sys_cop]}} : rx_lane_out_of_reset[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]; 

     genvar idx_rx_dsk_inst;
     for (idx_rx_dsk_inst=idx_sys_cop*num_rx_dsk_inst;idx_rx_dsk_inst<num_rx_dsk_inst*(idx_sys_cop+1);idx_rx_dsk_inst=idx_rx_dsk_inst+1) begin: per_rx_dsk_inst

           localparam idx_rx_dsk_rst = fec_on ? idx_rx_dsk_inst*num_xcvr_per_sys : idx_rx_dsk_inst;

             alt_xcvr_resync_etile #(
                           .SYNC_CHAIN_LENGTH (2),
                           .WIDTH(1),
                           .INIT_VALUE(0)
                           ) U_rst_resync_inst (
           	           .clk   (rx_coreclkin[idx_rx_dsk_inst*l_per_rx_dsk_inst]),
           	           .reset (1'b0),
           	           .d     (rx_deskew_reset_n[idx_rx_dsk_rst]),
           	           .q     (rx_deskew_reset_n_resync[idx_rx_dsk_rst])
           		  );        

           directphy_f_rx_deskew  #(.WIDTH       (80),
                                  .LANES       (l_per_rx_dsk_inst),
                                  .SIM_EMULATE (0)
                                 ) U_aib_dsk_rx (
                                 // Outputs
                                  .o_data       (o_aib_deskew_data[idx_rx_dsk_inst*l_per_rx_dsk_inst+:l_per_rx_dsk_inst]), 
                                  .o_deskew_done    (int_o_deskew_done[idx_rx_dsk_inst]),
                                 // Inputs
                                  .i_clk        (rx_coreclkin[idx_rx_dsk_inst*l_per_rx_dsk_inst]),    
                                  .i_reset      (~rx_deskew_reset_n_resync[idx_rx_dsk_rst]),   
                                  .i_data       (rx_skewed_data[idx_rx_dsk_inst*l_per_rx_dsk_inst+:l_per_rx_dsk_inst]), 
                                  .i_sync_pulse     (rx_skewed_pulse[idx_rx_dsk_inst*l_per_rx_dsk_inst+:l_per_rx_dsk_inst])); 
      end // per_rx_dsk_inst
      assign o_deskew_done[idx_sys_cop] = &int_o_deskew_done[idx_sys_cop*num_rx_dsk_inst+:num_rx_dsk_inst];

  end // persys       
                     for(l=0;l<l_sys_aibs;l=l+1)begin: deskew_data_ln
                      assign int_rx_parallel_data[l*80+:80] = o_aib_deskew_data[l];
      	             end
    assign rx_parallel_data = int_rx_parallel_data;
    assign rx_ready = int_rx_ready&o_deskew_done;
end // directphy_rx_deskew
else begin // NOT directphy_rx_deskew
     assign rx_parallel_data = int_rx_skewed_data;
     assign rx_ready = int_rx_ready;
     assign o_deskew_done = {(num_sys_cop){1'b0}}; 
end // NOT directphy_rx_deskew

endgenerate

   generate
      for (idx_sys_cop = 0; idx_sys_cop < num_sys_cop; idx_sys_cop = idx_sys_cop + 1) begin: tx_deskew_generate_block

      // TX de-skew pulse generation ////
	 dphy_f_tx_dsk_gen # 
			 (
			  .WIDTH            (80),
			  .LANES            (num_xcvr_per_sys * l_num_aib_per_xcvr),
			  .FEC_ON           (fec_on),
			  .FEC_MODE         (l_fec_mode),
			  .DOUBLE_WIDTH_ON  (pldif_tx_double_width_transfer_enable),
                          .tuning_hint      (bb_f_ux_tx_tuning_hint),
                          .pma_lanes         (num_xcvr_per_sys),
                          .pma_width         (pma_width)
			  )
	 tx_dsk_gen_inst
			 (
			  // Outputs
			  .o_data       (int_tx_parallel_data[((idx_sys_cop) * num_xcvr_per_sys * l_num_aib_per_xcvr * 80) +: (num_xcvr_per_sys * l_num_aib_per_xcvr * 80)]),
			  // Inputs
			  .i_clk        (tx_coreclkin[idx_sys_cop * num_xcvr_per_sys * l_num_aib_per_xcvr]), 
                          .tx_ready(tx_ready),   
			  //    .i_reset      (tx_reset),   
			  .i_data       (tx_parallel_data_sel[((idx_sys_cop) * num_xcvr_per_sys * l_num_aib_per_xcvr * 80) +: (num_xcvr_per_sys * l_num_aib_per_xcvr * 80)])
			  );
      end : tx_deskew_generate_block
   endgenerate
 
 //// add for IP SDC to get fanin clocks ////
wire [l_sys_aibs-1 : 0] dummy_in_for_timing /* synthesis syn_noprune syn_preserve = 1 */;
assign dummy_in_for_timing = l_sys_aibs'('h0);
reg  [l_sys_aibs-1 : 0] dummy_out_for_timing /* synthesis syn_noprune syn_preserve = 1 */;
wire [l_sys_aibs-1 : 0] dummy_clk_for_timing /* synthesis syn_noprune syn_preserve = 1 */;

assign dummy_clk_for_timing = (duplex_mode != "rx") ? tx_clkout2 : rx_clkout;

    genvar i;
    generate
         for (i=0; i<l_sys_aibs; i=i+1) begin: dummy_clk
              always @ (posedge dummy_clk_for_timing[i]) begin
                   dummy_out_for_timing[i] <= dummy_in_for_timing[i];
              end
         end
    endgenerate


endmodule






