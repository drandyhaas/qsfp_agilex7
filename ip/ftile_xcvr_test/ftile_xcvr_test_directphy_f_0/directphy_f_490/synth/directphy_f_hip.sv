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
(* tile_ip_hip *)
module directphy_f_hip
  #(
    parameter          num_sys_cop                                              = 1,
    parameter          num_xcvr_per_sys                                         = 1,
    parameter          l_num_hip_per_sys                                        = 1,
    parameter          l_num_aib_per_xcvr                                       = 1,
    parameter          l_sys_xcvrs                                              = 1,
	parameter         l_sys_xcvrs_cascade                                       = 1,
    parameter          l_sys_aibs                                               = 1,
    parameter          l_tx_enable                                              = 1,
    parameter          l_rx_enable                                              = 1,
    parameter          l_av1_enable                                             = 0,
    parameter          l_num_avmm1                                              = 1,
    parameter          l_av2_enable                                             = 0,
    parameter          l_num_avmm2                                              = 1,
    parameter          fec_on                                                   = 0,

  // CDR Clockout:
    parameter          enable_port_fgt_rx_cdr_divclk_link0                      = 0,
    parameter          enable_port_fgt_rx_cdr_divclk_link1                      = 0,
    parameter          fgt_rx_cdr_divclk_link0_sel                              = 0,
    parameter          fgt_rx_cdr_divclk_link1_sel                              = 0,


//  Silicon revision:
    parameter          m_silicon_revision    = "10nm6agdra",
    parameter          silicon_revision      = "10nm6agdra",


      //-----------------------------------------------------------------------------------------------
      //TODO:  ALL  bb_m_* below are to be REMOVED, after setting hardcodes for pma-dir1 are removed.
      //-----------------------------------------------------------------------------------------------
    parameter          bb_m_hdpldadapt_rx_hdpldadapt_rx_chnl_fifo_width           = "__BB_DONT_CARE__",
    parameter          bb_m_hdpldadapt_tx_hdpldadapt_tx_chnl_fifo_width           = "__BB_DONT_CARE__",


    parameter          bb_f_ehip_lphy_xcvrif_lpbk_en                            ="DISABLE", 
    parameter          bb_f_ehip_mac_mode                                       = "MAC_MODE_DISABLED", 
    parameter          dec_bb_f_ehip_rx_datarate                                = "2500000000", 
    parameter          dec_bb_f_ehip_tx_datarate                                = "2500000000", 

    //### BB bb_f_ux_
    parameter          dec_bb_f_ux_f_out_rx_cdr_pll_hz                          = "1500000000",
    parameter          bb_f_ux_rx_cdr_pll_enable_half_divider                   = "RX_CDR_PLL_ENABLE_HALF_DIVIDER_INT_DIVISION",
    parameter          bb_f_ux_rx_cdr_pll_fast_refclk_mode                      = "DISABLE",
    parameter  [7:0]   bb_f_ux_rx_cdr_pll_l_counter                             = 1,
    parameter  [7:0]   bb_f_ux_rx_cdr_pll_n_counter                             = 1,
    parameter          bb_f_ux_rx_cdr_pll_postdiv_en                            = "RX_CDR_PLL_POSTDIV_EN_1",
    parameter          dec_bb_f_ux_f_out_synth_lc_hz                            = "125000000",
    parameter          dec_bb_f_ux_f_mod_synth_lc_hz                            = "0",
    parameter          bb_f_ux_synch_lc_modula_to_ren                           = "SYNCH_LC_MODULA_TO_REN_0",
    parameter          bb_f_ux_synth_lc_enable_half_divider                     = "SYNTH_LC_ENABLE_HALF_DIVIDER_INT_DIVISION",
    parameter          bb_f_ux_synth_lc_postdiv_en                              = "SYNTH_LC_POSTDIV_EN_1",
    parameter          bb_f_ux_fractional_mode                                  = "OFF",
    parameter          dec_bb_f_ux_f_out_synth_ring_hz                          = "1500000000",
    parameter          bb_f_ux_synch_ring_modula_to_ren                         = "SYNCH_RING_MODULA_TO_REN_0",
    parameter          bb_f_ux_synth_ring_enable_half_divider                   = "SYNTH_RING_ENABLE_HALF_DIVIDER_INT_DIVISION",
    parameter          bb_f_ux_synth_ring_fast_refclk_mode                      = "DISABLE",
    parameter  [7:0]   bb_f_ux_synth_ring_l_counter                             = 1,
    parameter  [7:0]   bb_f_ux_synth_ring_n_counter                             = 1,
    parameter          bb_f_ux_synth_ring_pcs_postdiv_en                        = "SYNTH_RING_PCS_POSTDIV_EN_0",
    parameter  [7:0]   bb_f_ux_digital_core_divider                             = 0,
    parameter  [7:0]   bb_f_ux_rx_clkdiv                                        = 8,
    parameter  [7:0]   bb_f_ux_tx_clkdiv                                        = 8,

    //### BB bb_f_bk
    parameter          bb_f_bk_package_type                       = "HIGHEND",
    parameter          bb_f_bk_speed_grade                        = "SPEED_GRADE_112G",
    parameter          bb_f_bk_sup_mode                           = "SUP_MODE_USER_MODE",
    parameter          bb_f_bk_tx_protocol                        = "TX_PROTOCOL_PMA_DIRECT_XCVR_CLK",
    parameter          bb_f_bk_tx_bond_size                       = "TX_BOND_SIZE_1",
    parameter          bb_f_bk_tx_line_rate                       = 1000000000,
    parameter          bb_f_bk_txrx_line_encoding_type            = "TXRX_LINE_ENCODING_TYPE_NRZ",
    parameter          bb_f_bk_txout_tristate_en                  = "TXOUT_TRISTATE_EN", 
    parameter          bb_f_bk_tx_termination                     = "TXTERM_OFFSET_P0",
    parameter          bb_f_bk_tx_invert_p_and_n                  = "TX_INVERT_PN_DIS",
    parameter [6:0]    bb_f_bk_txeq_main_tap                      = 83,
    parameter [5:0]    bb_f_bk_txeq_post_tap_1                    = 0,
    parameter [5:0]    bb_f_bk_txeq_post_tap_2                    = 0,
    parameter [5:0]    bb_f_bk_txeq_post_tap_3                    = 0,
    parameter [5:0]    bb_f_bk_txeq_post_tap_4                    = 0,
    parameter [5:0]    bb_f_bk_txeq_pre_tap_1                     = 0,
    parameter [5:0]    bb_f_bk_txeq_pre_tap_2                     = 0,
    parameter [5:0]    bb_f_bk_txeq_pre_tap_3                     = 0,  
                                                                                                   
    parameter          bb_f_bk_refclk_source_lane_pll             = "PLLA_100_MHZ",
    parameter          bb_f_bk_pll_pcs3334_ratio                  = "DIV_33_BY_2",
    parameter          bb_f_bk_pll_rx_pcs3334_ratio               = "RX_DIV_33_BY_2",
    parameter          bb_f_bk_pam4_rxgrey_code                   = "PAM4_RXGREY_IS_B4",
    parameter          bb_f_bk_rx_user_clk1_en                    = "RX_USRCLK1_DIS",
    parameter          bb_f_bk_rx_user_clk2_en                    = "RX_USRCLK2_DIS",
    parameter          bb_f_bk_tx_user_clk1_en                    = "TX_USRCLK1_DIS",
    parameter          bb_f_bk_tx_user_clk2_en                    = "TX_USRCLK2_DIS",
    parameter          bb_f_bk_rx_user_clk1_sel                   = "RX_USRCLK1SEL_DIV3334",
    parameter          bb_f_bk_rx_user_clk2_sel                   = "RX_USRCLK2SEL_DIV3334",
    parameter          bb_f_bk_tx_user_clk1_sel                   = "TX_USRCLK1SEL_DIV3334",
    parameter          bb_f_bk_tx_user_clk2_sel                   = "TX_USRCLK2SEL_DIV3334",
                                                                                                   
    parameter          bb_f_bk_an_mode                            = "AN_MODE_DIS",
    parameter          bb_f_bk_bk_dl_enable                       = "DETLAT_DIS",
    parameter          bb_f_bk_loopback_mode                      = "LPBK_DISABLED",
    parameter          bb_f_bk_bti_protected                      = "FALSE",
                                                                                                   
    parameter          bb_f_bk_rx_termination                     = "RXTERM_OFFSET_P0",
    parameter          bb_f_bk_rx_invert_p_and_n                  = "RX_INVERT_PN_DIS",
    parameter          bb_f_bk_bk_en_rxdat_profile                = "RXDAT_PROF_DIS",
                                                                                                   
    parameter          bb_f_bk_bk_lnx_txovf_rxbdstb_inten         = 0,
    parameter          bb_f_bk_bk_lnx_txudf_pldrstb_inten         = 0,
    parameter          bb_f_bk_bk_tx_lnx_ovf_inten_dirsignal      = 0,
    parameter          bb_f_bk_bk_tx_lnx_rxbadst_inten_dirsignal  = 0,
    parameter          bb_f_bk_bk_tx_lnx_udf_inten_dirsignal      = 0,
                                                                                                   
    parameter          bb_f_bk_bk_rx_lat_bit_for_async            = 0,
    parameter          bb_f_bk_bk_rxbit_cntr_pma                  = "RXBIT_CNTR_PMADIR_DIS",
    parameter  [31:0]  bb_f_bk_bk_rxbit_rollover                  = 5248, 

    parameter          bb_f_bk_rx_precode_en                      = "RX_PRECODE_DIS",
    parameter          bb_f_bk_tx_precode_en                      = "TX_PRECODE_DIS",
    parameter          bb_f_bk_pll_n_counter                      = 1,
    
    
parameter bb_m_hdpldadapt_rx_speed_grade= "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_tx_speed_grade= "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_tx_csr_clk_hz="__BB_DONT_CARE__",


//LUZ SCRIPT AUTO
//### NEW BB bb_f_aib_
parameter bb_f_aib_aibadapt_rx_rx_10g_krfec_rx_diag_data_status_polling_bypass                 = "disable",
parameter bb_f_aib_aibadapt_rx_rx_pld_8g_wa_boundary_polling_bypass                            = "disable",
parameter bb_f_aib_aibadapt_rx_rx_pld_pma_reser_in_polling_bypass                              = "disable",
parameter bb_f_aib_aibadapt_rx_rx_pld_pma_testbus_polling_bypass                               = "disable",
parameter bb_f_aib_aibadapt_rx_rx_pld_test_data_polling_bypass                                 = "disable",
parameter bb_f_aib_aibadapt_rx_rx_user_clk_rst_sel                                             = "aibadapt_rx_rx_user_clk_hard_rst",
parameter bb_f_aib_aibadapt_rx_rx_user_clk_sel                                                 = "aibadapt_rx_rx_user_clk_ehip",
parameter bb_f_aib_aibadapt_tx_tx_latency_src_xcvrif                                           = "aibadapt_tx_latency_pls_e400e200",
parameter bb_f_aib_aibadapt_tx_tx_user_clk_rst_sel                                             = "aibadapt_tx_tx_user_clk_hard_rst",
parameter bb_f_aib_aibadapt_tx_tx_user_clk_sel                                                 = "aibadapt_tx_tx_user_clk_ehip_div2",
parameter bb_f_aib_location                                                                    = "__BB_DONT_CARE__",

parameter bb_f_aib_aib_hssi_rx_transfer_clk_hz                                                 = 0,
parameter bb_f_aib_aib_hssi_tx_transfer_clk_hz                                                 = 0,

parameter bb_f_aib_aib_tx_user_clk_hz                                                          = 0,
parameter bb_f_aib_aib_rx_user_clk_hz                                                          = 0,

//### NEW BB bb_f_ehip_

parameter bb_f_ehip_aib2_rx_st_clk_en                                                           = "aib2_rx_st_clk_en_pll0_div2",
parameter bb_f_ehip_aib2_tx_st_clk_en                                                           = "aib2_tx_st_clk_en_pll0_div2",
parameter bb_f_ehip_aib3_rx_st_clk_en            = "AIB3_RX_ST_CLK_EN_RX_WORD_CLK",  // TODO:  GUI control.  default for pmadir1-enh 
parameter bb_f_ehip_aib3_tx_st_clk_en            = "AIB3_TX_ST_CLK_EN_TX_WORD_CLK",  // TODO:  GUI control.  default for pmadir1-enh
parameter bb_f_ehip_aibif_data_valid                                                            = "aibif_data_valid_25g",
parameter bb_f_ehip_dl_enable                                                                   = "disable",
parameter bb_f_ehip_fec_802p3ck                                                                 = "disable",
parameter bb_f_ehip_duplex_mode                                                                 = "duplex_mode_full_duplex",
parameter bb_f_ehip_fec_clk_src                                                                 = "fec_clk_src_disabled",
parameter bb_f_ehip_fec_mode                                                                    = "fec_mode_disabled",
parameter bb_f_ehip_fec_spec                                                                    = "fec_spec_disabled",
parameter bb_f_ehip_frac_size                                                                   = "__BB_DONT_CARE__",
parameter bb_f_ehip_location                                                                    = "__BB_DONT_CARE__",
parameter bb_f_ehip_lpbk_mode                                                                   = "lpbk_mode_disabled",
parameter bb_f_ehip_tx_pmadirect_single_width                                                   = "false",
parameter bb_f_ehip_rx_pmadirect_single_width                                                   = "false",
parameter bb_f_ehip_rx_aib_if_fifo_mode                                                         = "rx_aib_if_fifo_mode_register",
parameter bb_f_ehip_rx_datarate                                                                 = 37'h5d21dba00,
parameter bb_f_ehip_rx_en                                                                       = "true",
parameter bb_f_ehip_rx_excvr_gb_ratio_mode                                                      = "rx_excvr_gb_ratio_mode_disabled",
parameter bb_f_ehip_rx_excvr_if_fifo_mode                                                       = "rx_excvr_if_fifo_mode_elastic",
parameter bb_f_ehip_rx_fec_enable                                                               = "rx_fec_enable_disabled",
parameter bb_f_ehip_rx_pcs_mode                                                                 = "rx_pcs_mode_disabled",
parameter bb_f_ehip_rx_powerdown_mode                                                           = "false",
parameter bb_f_ehip_rx_primary_use                                                              = "rx_primary_use_direct_bundle",
parameter bb_f_ehip_rx_total_xcvr                                                               = 5'h1,
parameter bb_f_ehip_rx_word_clk_hz                                                              = 37'h6e9dc804a,
parameter bb_f_ehip_rx_xcvr_width                                                               = "rx_xcvr_width_32",
parameter bb_f_ehip_speed_map                                                                   = "speed_map_map_25g",
parameter bb_f_ehip_sys_clk_src                                                                 = "sys_clk_src_pll0",
parameter bb_f_ehip_topo_supports_barak                                                         = "__BB_DONT_CARE__",
parameter bb_f_ehip_topology                                                                    = "__BB_DONT_CARE__",
parameter bb_f_ehip_tx_aib_if_fifo_mode                                                         = "tx_aib_if_fifo_mode_phasecomp",
parameter bb_f_ehip_tx_datarate                                                                 = 37'h5d21dba00,
parameter bb_f_ehip_tx_en                                                                       = "true",
parameter bb_f_ehip_tx_excvr_gb_ratio_mode                                                      = "tx_excvr_gb_ratio_mode_disabled",
parameter bb_f_ehip_tx_excvr_if_fifo_mode                                                       = "tx_excvr_if_fifo_mode_elastic",
parameter bb_f_ehip_tx_fec_enable                                                               = "tx_fec_enable_disabled",
parameter bb_f_ehip_tx_pcs_mode                                                                 = "tx_pcs_mode_disabled",
parameter bb_f_ehip_tx_powerdown_mode                                                           = "false",
parameter bb_f_ehip_tx_primary_use                                                              = "tx_primary_use_direct_bundle",
parameter bb_f_ehip_tx_total_xcvr                                                               = 5'h1,
parameter bb_f_ehip_tx_word_clk_hz                                                              = 37'h1c489e18a8,
parameter bb_f_ehip_tx_xcvr_width                                                               = "tx_xcvr_width_32",
parameter bb_f_ehip_xcvr_mode                                                                   = "xcvr_mode_nrz",
parameter bb_f_ehip_xcvr_type                                                                   = "xcvr_type_disabled",
parameter bb_f_ehip_is_fec_part_of_reconfig                                                     = "false",
//### NEW BB bb_f_system_pll_


//### NEW BB bb_f_ux_

parameter bb_f_ux_all_ux_powerdown_mode                                                       = "false",
parameter bb_f_ux_cdr_bw_sel                                                                  = "cdr_bw_sel_medium",
parameter bb_f_ux_cdr_f_out_hz                                                                = "0",
parameter bb_f_ux_cdr_f_vco_hz                                                                = "0",
parameter bb_f_ux_cdr_f_ref_hz                                                                = 36'h9502f90,
parameter bb_f_ux_cdr_is_cascaded                                                             = "false",
parameter bb_f_ux_cdr_l_counter                                                               = 9'ha5,
parameter bb_f_ux_cdr_m_counter                                                               = 9'ha5,
parameter bb_f_ux_cdr_n_counter                                                               = 6'h4,
parameter bb_f_ux_tx_fb_div_emb_mult_counter                                                  = 2'h2,
parameter bb_f_ux_cdr_postdiv_fractional_en                                                   = "disable",
parameter bb_f_ux_cdr_ppm_driftcount                                                          = 16'h400,
parameter bb_f_ux_cdr_ppm_tolerance                                                           = 16'h1db0,
parameter bb_f_ux_clkrx_powerdown_mode                                                        = "false",
parameter bb_f_ux_core_pll                                                                    = "core_pll_med",
parameter bb_f_ux_dl_enable                                                                   = "disable",
parameter bb_f_ux_enable_static_refclk_network                                                = "false",
parameter bb_f_ux_force_refclk_power_to_specific_value                                        = "force_refclk_power_to_specific_value_none",
parameter bb_f_ux_location                                                                    = "__BB_DONT_CARE__",
parameter bb_f_ux_loopback_mode                                                               = "loopback_mode_off",
parameter bb_f_ux_rx_bond_size                                                                = "rx_bond_size_1",
parameter bb_f_ux_rx_powerdown_mode                                                           = "false",
parameter bb_f_ux_rx_protocol                                                                 = "rx_protocol_pma_direct_sys_clk",
parameter bb_f_ux_rx_user_clk_en                                                              = "enable",
parameter bb_f_ux_rx_width                                                                    = "rx_width_32",
parameter bb_f_ux_squelch_detect                                                              = "enable",
parameter bb_f_ux_prbs_gen_en                                                                 = "DISABLE",
parameter bb_f_ux_prbs_mon_en                                                                 = "DISABLE",
parameter [5:0]    bb_f_ux_prbs_pattern                                                       = 7,
parameter bb_f_ux_rx_pam4_graycode_en                                                         = "DISABLE",
parameter bb_f_ux_tx_pam4_graycode_en                                                         = "DISABLE",
parameter bb_f_ux_rx_pam4_precode_en                                                          = "DISABLE",
parameter bb_f_ux_tx_pam4_precode_en                                                          = "DISABLE",
parameter bb_f_ux_force_cdr_ltd                                                               = "DISABLE",
parameter bb_f_ux_force_cdr_ltr                                                               = "DISABLE",
parameter bb_f_ux_enable_port_control_of_cdr_ltr_ltd                                          = "DISABLE",
parameter bb_f_ux_flux_mode                                                                   = "FLUX_MODE_CPRI", 
parameter bb_f_ux_rx_adapt_mode                                                               = "RX_ADAPT_MODE_FLUX_RX_ADAPT", 
parameter bb_f_ux_engineered_link_mode                                                        = "DISABLE",
parameter bb_f_ux_tx_tuning_hint                                                              = "TX_TUNING_HINT_DISABLED",
parameter bb_f_ux_rx_tuning_hint                                                              = "RX_TUNING_HINT_DISABLED",
parameter bb_f_ux_tx_spread_spectrum_en                                                       = "DISABLE",

parameter bb_f_ux_cdr_postdiv_counter                              = 0,
parameter bb_f_ux_synth_lc_fast_tx_postdiv_counter                 = 0,
parameter bb_f_ux_synth_lc_med_tx_postdiv_counter                  = 0,
parameter bb_f_ux_synth_lc_slow_tx_postdiv_counter                 = 0,
parameter bb_f_ux_synth_lc_fast_tx_postdiv_fractional_en              = "DISABLE",
parameter bb_f_ux_synth_lc_med_tx_postdiv_fractional_en               = "DISABLE",
parameter bb_f_ux_synth_lc_slow_tx_postdiv_fractional_en              = "DISABLE",

parameter bb_f_ux_cdr_f_postdiv_hz                              = 0,
parameter bb_f_ux_synth_lc_fast_f_tx_postdiv_hz          = 0,
parameter bb_f_ux_synth_lc_med_f_tx_postdiv_hz           = 0,
parameter bb_f_ux_synth_lc_slow_f_tx_postdiv_hz          = 0,

//### FGT XCVR RX/TX PLL attributes:  controlled by computation code.
    parameter fgt_tx_pll_cascade_enable               = 0,
    parameter fgt_tx_pll_frac_mode_enable             = 0,


    parameter bb_f_ux_tx_pll                          = "__BB_DONT_CARE__",
    parameter bb_f_ux_tx_pll_bw_sel                   = "__BB_DONT_CARE__",
    
    parameter bb_f_ux_synth_lc_fast_f_out_hz          = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_fast_f_vco_hz          = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_fast_f_ref_hz          = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_fast_fractional_en     = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_fast_k_counter         = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_fast_l_counter         = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_fast_m_counter         = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_fast_n_counter         = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_fast_primary_use       = "__BB_DONT_CARE__",
    
    parameter bb_f_ux_synth_lc_med_f_out_hz           = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_med_f_vco_hz           = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_med_f_ref_hz           = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_med_fractional_en      = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_med_k_counter          = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_med_l_counter          = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_med_m_counter          = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_med_n_counter          = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_med_primary_use        = "__BB_DONT_CARE__",
    
    parameter bb_f_ux_synth_lc_slow_f_out_hz          = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_slow_f_vco_hz          = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_slow_f_ref_hz          = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_slow_fractional_en     = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_slow_k_counter         = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_slow_l_counter         = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_slow_m_counter         = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_slow_n_counter         = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_slow_primary_use       = "__BB_DONT_CARE__",
    
  //### FGT PLL Cascades:
    parameter targettype_bb_f_ux_tx_pll                         = "__BB_DONT_CARE__",
    parameter targettype_bb_f_ux_tx_pll_bw_sel                  = "__BB_DONT_CARE__",

    parameter targettype_bb_f_ux_synth_lc_fast_f_out_hz         = "0",
    parameter targettype_bb_f_ux_synth_lc_fast_f_vco_hz         = "0",
    parameter targettype_bb_f_ux_synth_lc_fast_f_ref_hz         = 0,
    parameter targettype_bb_f_ux_synth_lc_fast_fractional_en    = "__BB_DONT_CARE__",
    parameter targettype_bb_f_ux_synth_lc_fast_k_counter        = 0,
    parameter targettype_bb_f_ux_synth_lc_fast_l_counter        = 0,
    parameter targettype_bb_f_ux_synth_lc_fast_m_counter        = 0,
    parameter targettype_bb_f_ux_synth_lc_fast_n_counter        = 0,
    parameter targettype_bb_f_ux_synth_lc_fast_primary_use      = "__BB_DONT_CARE__",

    parameter targettype_bb_f_ux_synth_lc_med_f_out_hz          = "0",
    parameter targettype_bb_f_ux_synth_lc_med_f_vco_hz          = "0",
    parameter targettype_bb_f_ux_synth_lc_med_f_ref_hz          = 0,
    parameter targettype_bb_f_ux_synth_lc_med_fractional_en     = "__BB_DONT_CARE__",
    parameter targettype_bb_f_ux_synth_lc_med_k_counter         = 0,
    parameter targettype_bb_f_ux_synth_lc_med_l_counter         = 0,
    parameter targettype_bb_f_ux_synth_lc_med_m_counter         = 0,
    parameter targettype_bb_f_ux_synth_lc_med_n_counter         = 0,
    parameter targettype_bb_f_ux_synth_lc_med_primary_use       = "__BB_DONT_CARE__",

    parameter targettype_bb_f_ux_synth_lc_slow_f_out_hz         = "0",
    parameter targettype_bb_f_ux_synth_lc_slow_f_vco_hz         = "0",
    parameter targettype_bb_f_ux_synth_lc_slow_f_ref_hz         = 0,
    parameter targettype_bb_f_ux_synth_lc_slow_fractional_en    = "__BB_DONT_CARE__",
    parameter targettype_bb_f_ux_synth_lc_slow_k_counter        = 0,
    parameter targettype_bb_f_ux_synth_lc_slow_l_counter        = 0,
    parameter targettype_bb_f_ux_synth_lc_slow_m_counter        = 0,
    parameter targettype_bb_f_ux_synth_lc_slow_n_counter        = 0,
    parameter targettype_bb_f_ux_synth_lc_slow_primary_use      = "__BB_DONT_CARE__",
	parameter targettype_bb_f_ux_tx_fb_div_emb_mult_counter     = 0,

    parameter bb_f_ux_synth_lc_fast_f_rx_postdiv_hz             = 0,
    parameter bb_f_ux_synth_lc_fast_rx_postdiv_counter          = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_med_f_rx_postdiv_hz              = 0,
    parameter bb_f_ux_synth_lc_med_rx_postdiv_counter           = "__BB_DONT_CARE__",
    parameter bb_f_ux_synth_lc_slow_f_rx_postdiv_hz             = 0,
    parameter bb_f_ux_synth_lc_slow_rx_postdiv_counter          = "__BB_DONT_CARE__",



parameter bb_f_ux_tx_bond_size                                                                = "tx_bond_size_1",
parameter bb_f_ux_tx_powerdown_mode                                                           = "false",
parameter bb_f_ux_tx_protocol                                                                 = "tx_protocol_pma_direct_sys_clk",
parameter bb_f_ux_tx_user_clk1_en                                                             = "disable",
parameter bb_f_ux_tx_user_clk1_mux                                                            = "tx_user_clk1_mux_slow_med",
parameter bb_f_ux_tx_user_clk2_en                                                             = "disable",
parameter bb_f_ux_tx_user_clk2_mux                                                            = "tx_user_clk2_mux_slow_med",
parameter bb_f_ux_tx_user_clk_slow_med_mux                                                    = "tx_user_clk_slow_med_mux_slow",
parameter bb_f_ux_tx_width                                                                    = "tx_width_32",
parameter bb_f_ux_txrx_channel_operation                                                      = "txrx_channel_operation_full_duplex",
parameter bb_f_ux_txrx_line_encoding_type                                                     = "txrx_line_encoding_type_nrz",
parameter bb_f_ux_txrx_xcvr_speed_bucket                                                      = "txrx_xcvr_speed_bucket_25g",
parameter bb_f_ux_ux_q_ckmux_cpu_attr                                                         = "ckmux_cpu_avmm",
parameter bb_f_ux_ux_q_e_rx_dp_pipe_l0_attr                                                   = "e_rx_dp_no_pipe_l0",
parameter bb_f_ux_ux_q_e_tx_dp_pipe_l0_attr                                                   = "e_tx_dp_no_pipe_l0",

//### NEW BB bb_f_ux_refclk_


//### NEW BB bb_m_aib_rx_

parameter bb_m_aib_rx_location                                                                    = "__BB_DONT_CARE__",
parameter bb_m_aib_rx_xavmm1_op_mode                                                              = "__BB_DONT_CARE__",
parameter bb_m_aib_rx_xavmm2_op_mode                                                              = "__BB_DONT_CARE__",
parameter bb_m_aib_rx_xrxdatapath_rx_op_mode                                                      = "xrxdatapath_rx_rx_dcc_enable",

//### NEW BB bb_m_aib_tx_

parameter bb_m_aib_tx_location                                                                    = "__BB_DONT_CARE__",
parameter bb_m_aib_tx_xavmm1_op_mode                                                              = "__BB_DONT_CARE__",
parameter bb_m_aib_tx_xavmm2_op_mode                                                              = "__BB_DONT_CARE__",
parameter bb_m_aib_tx_xtxdatapath_tx_op_mode                                                      = "xtxdatapath_tx_tx_dll_enable",

//### NEW BB bb_m_hdpldadapt_avmm1_

parameter bb_m_hdpldadapt_avmm1_aib_fabric_pma_aib_tx_clk_hz                                                = "__BB_DONT_CARE__",//LUZ
parameter bb_m_hdpldadapt_avmm1_aib_fabric_rx_transfer_clk_hz                                               = "__BB_DONT_CARE__",//LUZ
parameter bb_m_hdpldadapt_avmm1_hdpldadapt_avmm_avmm1_avmm_clk_scg_en                                       = "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_avmm1_hdpldadapt_avmm_avmm1_nfhssi_calibratio_feature_en                          = "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_avmm1_hdpldadapt_avmm_hip_mode                                                    = "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_avmm1_hdpldadapt_avmm_powermode_dc                                                = "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_avmm1_hdpldadapt_sr_hip_mode                                                      = "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_avmm1_hdpldadapt_sr_powermode_dc                                                  = "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_avmm1_hdpldadapt_sr_sr_parity_en                                                  = "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_avmm1_location                                                                    = "__BB_DONT_CARE__",

//### NEW BB bb_m_hdpldadapt_avmm2_

parameter bb_m_hdpldadapt_avmm2_aib_fabric_pma_aib_tx_clk_hz                                                = "__BB_DONT_CARE__",//LUZ
parameter bb_m_hdpldadapt_avmm2_aib_fabric_rx_sr_clk_in_hz                                                  = "__BB_DONT_CARE__",//LUZ
parameter bb_m_hdpldadapt_avmm2_aib_fabric_rx_transfer_clk_hz                                               = "__BB_DONT_CARE__",//LUZ
parameter bb_m_hdpldadapt_avmm2_aib_fabric_tx_sr_clk_in_hz                                                  = "__BB_DONT_CARE__",//LUZ
parameter bb_m_hdpldadapt_avmm2_hdpldadapt_avmm_avmm2_avmm_clk_scg_en                                       = "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_avmm2_hdpldadapt_avmm_avmm2_hip_sel                                               = "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_avmm2_hdpldadapt_avmm_hip_mode                                                    = "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_avmm2_hdpldadapt_avmm_powermode_dc                                                = "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_avmm2_hdpldadapt_sr_hip_mode                                                      = "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_avmm2_hdpldadapt_sr_powermode_dc                                                  = "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_avmm2_hdpldadapt_sr_sr_parity_en                                                  = "__BB_DONT_CARE__",
parameter bb_m_hdpldadapt_avmm2_location                                                                    = "__BB_DONT_CARE__",

//### NEW BB bb_m_hdpldadapt_rx_
parameter	bb_m_hdpldadapt_rx_fifo_mode	=	"PHASE_COMP"	,
parameter	bb_m_hdpldadapt_rx_fifo_width	=	"FIFO_DOUBLE_WIDTH"	,
parameter	bb_m_hdpldadapt_rx_hdpldadapt_pld_rx_clk1_dcm_hz	=	31'b11011110011000101100000110110	,
parameter	bb_m_hdpldadapt_rx_hdpldadapt_pld_rx_clk1_rowclk_hz	=	31'b10101100101001101101100001111	,
parameter	bb_m_hdpldadapt_rx_hdpldadapt_pld_sclk1_rowclk_hz	=	31'b1100111011111100100001100	,
parameter	bb_m_hdpldadapt_rx_hdpldadapt_pld_sclk2_rowclk_hz	=	31'b11011101110100111001111101	,
parameter	bb_m_hdpldadapt_rx_hdpldadapt_speed_grade	=	"HDPLDADAPT_DASH_2"	,
parameter	bb_m_hdpldadapt_rx_pld_clk1_sel	=	"PLD_CLK1_DCM"	,
parameter	bb_m_hdpldadapt_rx_rx_datapath_tb_sel	=	"PCS_CHNL_TB"	,
parameter	bb_m_hdpldadapt_rx_rxfifo_pempty	=	6'b10	,
parameter	bb_m_hdpldadapt_rx_rxfifo_pfull	=	6'b1010	,

//### NEW BB bb_m_hdpldadapt_tx_


parameter bb_m_hdpldadapt_tx_duplex_mode	=	"ENABLE",
parameter bb_m_hdpldadapt_tx_fifo_mode	=	"PHASE_COMP",
parameter bb_m_hdpldadapt_tx_fifo_width	=	"FIFO_DOUBLE_WIDTH",
parameter bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz	=	31'b11111101010010001000100100,
parameter bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk1_rowclk_hz	=	31'b1010001000111101000110011100,
parameter bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk2_dcm_hz	=	31'b11101110101111100010111101101,
parameter bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk2_rowclk_hz	=	31'b101001111110000110010111011101,
parameter bb_m_hdpldadapt_tx_hdpldadapt_speed_grade	=	"HDPLDADAPT_DASH_2",
parameter bb_m_hdpldadapt_tx_pld_clk1_sel	=	"PLD_CLK1_DCM",
parameter bb_m_hdpldadapt_tx_pld_clk2_sel	=	"PLD_CLK2_DCM",
parameter bb_m_hdpldadapt_tx_tx_datapath_tb_sel	=	"TX_FIFO_TB1",
parameter bb_m_hdpldadapt_tx_txfifo_pempty	=	5'b10,
parameter bb_m_hdpldadapt_tx_txfifo_pfull	=	5'b1010,

parameter enable_port_latency_measurement       = 0 // deterministic latency enable


  )  (
    output  wire                                    rx_cdr_divclk_link0,
    output  wire                                    rx_cdr_divclk_link1,
    input   wire [num_xcvr_per_sys*num_sys_cop-1:0] rx_cdr_refclk_link,
    input   wire [l_sys_xcvrs_cascade-1:0] tx_pll_refclk_link,
             // Barak uses tx_pll_refclk_link connecting to a common PLL (A or B) output, either 100MHz or 156.25MHz
    input   wire  [num_sys_cop-1:0]         system_pll_clk_link,

    input   wire  [num_xcvr_per_sys*num_sys_cop-1:0]  rx_serial_data,
    input   wire  [num_xcvr_per_sys*num_sys_cop-1:0]  rx_serial_data_n,
    output  wire  [num_xcvr_per_sys*num_sys_cop-1:0]  tx_serial_data,
    output  wire  [num_xcvr_per_sys*num_sys_cop-1:0]  tx_serial_data_n,

    // UX to/from PLD
    output          [num_xcvr_per_sys*num_sys_cop-1:0]   oct_pcs_rxsignaldetect_lx_a,    
    output          [num_xcvr_per_sys*num_sys_cop-1:0]   octl_pcs_rxsignaldetect_lfps_lx_a,   
    output          [num_xcvr_per_sys*num_sys_cop-1:0]   oct_pcs_all_synthlockstatus,                 
    output          [num_xcvr_per_sys*num_sys_cop-1:0]   oct_pcs_rxcdrlock2data_lx_a,          
    output          [num_xcvr_per_sys*num_sys_cop-1:0]   oct_pcs_rxcdrlockstatus_lx_a,     
    output          [num_xcvr_per_sys*num_sys_cop-1:0]   octl_pcs_txstatus_lx_a,     
    output          [num_xcvr_per_sys*num_sys_cop-1:0]   octl_pcs_rxstatus_lx_a,  
     input          [num_xcvr_per_sys*num_sys_cop-1:0]   ictl_pcs_rxovrcdrlock2dataen_lx_a,  
     input          [num_xcvr_per_sys*num_sys_cop-1:0]   ictl_pcs_rxovrcdrlock2data_lx_a,
     input          [num_xcvr_per_sys*num_sys_cop-1:0]   ictl_pcs_txbeacon_lx_a,
     input          [num_xcvr_per_sys*num_sys_cop-1:0]   flux_top__iflux_ingress_direct__231,
     input          [num_xcvr_per_sys*num_sys_cop-1:0]   i_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t,
     input          [num_xcvr_per_sys*num_sys_cop-1:0]   ictl_pcs_rxeiosdetectstat_lx_a,


    // BK to/from PLD
     input  wire    [l_sys_xcvrs*8-1:0]                  fht_ingress_direct,  
    output  wire    [l_sys_xcvrs*8-1:0]                  fht_rx_direct,           
    output  wire    [l_sys_xcvrs-1:0]                    fht_rxsrds_rdy,           
    output  wire    [l_sys_xcvrs-1:0]                    fht_latency_pulse,
    
   
    // MAIB status signals:
    output  wire   [l_sys_aibs-1:0]    tx_fifo_full,
    output  wire   [l_sys_aibs-1:0]    tx_fifo_empty,
    output  wire   [l_sys_aibs-1:0]    tx_fifo_pfull,
    output  wire   [l_sys_aibs-1:0]    tx_fifo_pempty,
    output  wire   [l_sys_aibs-1:0]    tx_dll_lock,

    output  wire   [l_sys_aibs-1:0]    rx_fifo_full,
    output  wire   [l_sys_aibs-1:0]    rx_fifo_empty,
    output  wire   [l_sys_aibs-1:0]    rx_fifo_pfull,
    output  wire   [l_sys_aibs-1:0]    rx_fifo_pempty,
     input  wire   [l_sys_aibs-1:0]    rx_fifo_rd_en,

    // PLD interface
     input  wire   [l_sys_aibs*4-1:0]   hip_aib_fsr_in,
    output  wire   [l_sys_aibs*4-1:0]   hip_aib_fsr_out,
     input  wire   [l_sys_aibs*40-1:0]  hip_aib_ssr_in,
    output  wire   [l_sys_aibs*8-1:0]   hip_aib_ssr_out,
    output  wire   [l_sys_aibs-1:0]     pld_10g_krfec_rx_blk_lock,
     input  wire   [l_sys_aibs-1:0]     pld_10g_krfec_rx_clr_errblk_cnt,
    output  wire   [l_sys_aibs*2-1:0]   pld_10g_krfec_rx_diag_data_status,
    output  wire   [l_sys_aibs-1:0]     pld_10g_krfec_rx_frame,
    output  wire   [l_sys_aibs-1:0]     pld_10g_rx_crc32_err,
    output  wire   [l_sys_aibs-1:0]     pld_10g_rx_frame_lock,
    output  wire   [l_sys_aibs-1:0]     pld_10g_rx_hi_ber,
     input  wire   [l_sys_aibs*7-1:0]   pld_10g_tx_bitslip,
    output  wire   [l_sys_aibs*4-1:0]   pld_8g_a1a2_k1k2_flag,
     input  wire   [l_sys_aibs-1:0]     pld_8g_bitloc_rev_en,
     input  wire   [l_sys_aibs-1:0]     pld_8g_byte_rev_en,
     input  wire   [l_sys_aibs*3-1:0]   pld_8g_eidleinfersel,
    output  wire   [l_sys_aibs-1:0]     pld_8g_empty_rmf,
     input  wire   [l_sys_aibs-1:0]     pld_8g_encdt,
    output  wire   [l_sys_aibs-1:0]     pld_8g_full_rmf,
     input  wire   [l_sys_aibs*5-1:0]   pld_8g_tx_boundary_sel,
    output  wire   [l_sys_aibs*5-1:0]   pld_8g_wa_boundary,
    output  wire   [l_sys_aibs-1:0]     pld_krfec_tx_alignment,
    output  wire   [l_sys_aibs-1:0]     pld_pma_adapt_done,
     input  wire   [l_sys_aibs-1:0]     pld_pma_adapt_start,
     input  wire   [l_sys_aibs-1:0]     pld_pma_csr_test_dis,
     input  wire   [l_sys_aibs-1:0]     pld_pma_early_eios,
     input  wire   [l_sys_aibs*6-1:0]   pld_pma_eye_monitor,
    output  wire   [l_sys_aibs-1:0]     pld_pma_fpll_clk0bad,
    output  wire   [l_sys_aibs-1:0]     pld_pma_fpll_clk1bad,
    output  wire   [l_sys_aibs-1:0]     pld_pma_fpll_clksel,
     input  wire   [l_sys_aibs*4-1:0]   pld_pma_fpll_cnt_sel,
     input  wire   [l_sys_aibs-1:0]     pld_pma_fpll_extswitch,
     input  wire   [l_sys_aibs*3-1:0]   pld_pma_fpll_num_phase_shifts,
     input  wire   [l_sys_aibs-1:0]     pld_pma_fpll_pfden,
    output  wire   [l_sys_aibs-1:0]     pld_pma_fpll_phase_done,
     input  wire   [l_sys_aibs-1:0]     pld_pma_fpll_up_dn_lc_lf_rstn,
     input  wire   [l_sys_aibs-1:0]     pld_pma_nrpi_freeze,
    output  wire   [l_sys_aibs*2-1:0]   pld_pma_pcie_sw_done,
     input  wire   [l_sys_aibs*2-1:0]   pld_pma_pcie_switch,
     input  wire   [l_sys_aibs-1:0]     pld_pma_ppm_lock,
    output  wire   [l_sys_aibs*5-1:0]   pld_pma_reserved_in,
     input  wire   [l_sys_aibs*5-1:0]   pld_pma_reserved_out,
     input  wire   [l_sys_aibs-1:0]     pld_pma_rs_lpbk_b,
    output  wire   [l_sys_aibs-1:0]     pld_pma_rx_detect_valid,
    output  wire   [l_sys_aibs-1:0]     pld_pma_rx_found,
    output  wire   [l_sys_aibs-1:0]     pld_pma_signal_ok,
     input  wire   [l_sys_aibs-1:0]     pld_pma_tx_bitslip,
     input  wire   [l_sys_aibs-1:0]     pld_pma_tx_qpi_pulldn,
     input  wire   [l_sys_aibs-1:0]     pld_pma_tx_qpi_pullup,
    output  wire   [l_sys_aibs-1:0]     pld_pmaif_mask_tx_pll,
     input  wire   [l_sys_aibs-1:0]     pld_pmaif_rxclkslip,
     input  wire   [l_sys_aibs-1:0]     pld_polinv_rx,
     input  wire   [l_sys_aibs-1:0]     pld_polinv_tx,
    output  wire   [l_sys_aibs-1:0]     pld_rx_hssi_fifo_empty,
    output  wire   [l_sys_aibs-1:0]     pld_rx_hssi_fifo_full,
    output  wire   [l_sys_aibs-1:0]     pld_rx_prbs_done,
    output  wire   [l_sys_aibs-1:0]     pld_rx_prbs_err,
     input  wire   [l_sys_aibs-1:0]     pld_rx_prbs_err_clr,
     input  wire   [l_sys_aibs-1:0]     pld_syncsm_en,
    output  wire   [l_sys_aibs*20-1:0]  pld_test_data,
    output  wire   [l_sys_aibs-1:0]     pld_tx_hssi_fifo_empty,
    output  wire   [l_sys_aibs-1:0]     pld_tx_hssi_fifo_full,
    output  wire   [l_sys_aibs-1:0]     pld_txelecidle,
    output  wire   [l_sys_aibs-1:0]     pld_pma_rxpll_lock,
    output  wire   [l_sys_aibs-1:0]     pld_8g_rxelecidle,


    output  wire  [l_sys_aibs*80-1:0]      sync_data_from_aib,
    input   wire  [l_sys_aibs*80-1:0]      sync_data_to_aib,

    output  wire  [l_sys_aibs-1:0]         pld_pcs_rx_clk_out1_dcm,
    output  wire  [l_sys_aibs-1:0]         pld_pcs_rx_clk_out1_hioint,
    output  wire  [l_sys_aibs-1:0]         pld_pcs_rx_clk_out2_dcm,
    output  wire  [l_sys_aibs-1:0]         pld_pcs_rx_clk_out2_hioint,
     input  wire  [l_sys_aibs-1:0]         pld_rx_clk1_dcm,
     input  wire  [l_sys_aibs-1:0]         pld_rx_clk1_rowclk,
     input  wire  [l_sys_aibs-1:0]         pld_rx_clk2_rowclk,

    output  wire  [l_sys_aibs-1:0]         pld_pcs_tx_clk_out1_dcm,
    output  wire  [l_sys_aibs-1:0]         pld_pcs_tx_clk_out1_hioint,
    output  wire  [l_sys_aibs-1:0]         pld_pcs_tx_clk_out2_dcm,
    output  wire  [l_sys_aibs-1:0]         pld_pcs_tx_clk_out2_hioint,   
     input  wire  [l_sys_aibs-1:0]         pld_tx_clk1_dcm,
     input  wire  [l_sys_aibs-1:0]         pld_tx_clk1_rowclk,
     input  wire  [l_sys_aibs-1:0]         pld_tx_clk2_dcm,
     input  wire  [l_sys_aibs-1:0]         pld_tx_clk2_rowclk,

    // Deterministic Latency
     input wire   [l_sys_aibs-1:0]         pld_sclk1_rowclk,
     input wire   [l_sys_aibs-1:0]         pld_sclk2_rowclk,
     output wire  [l_sys_aibs-1:0]         pld_pma_internal_clk1_hioint,
     output wire  [l_sys_aibs-1:0]         pld_pma_internal_clk2_hioint,
     input wire   [l_sys_aibs-1:0]         pld_10g_tx_bitslip_tx, 
     input wire   [l_sys_aibs-1:0]         pld_10g_tx_bitslip_rx, 
     input wire   [l_sys_xcvrs-1:0]         dl_sclk,
     output wire  [l_sys_xcvrs-1:0]         tx_dl_async_pulse,
     output wire  [l_sys_xcvrs-1:0]         rx_dl_async_pulse,
     input wire   [l_sys_xcvrs-1:0]         tx_dl_measure_sel, 
     input wire   [l_sys_xcvrs-1:0]         rx_dl_measure_sel,
    // port for csr
	output wire  [l_sys_xcvrs-1:0]          cpi_cmn_busy_real,
     	

    //  for AVMM1 bb ports
    output  wire  [l_num_avmm1-1:0]      pld_avmm1_busy,
    input   wire  [l_num_avmm1-1:0]      pld_avmm1_clk_rowclk,
    output  wire  [l_num_avmm1-1:0]      pld_avmm1_cmdfifo_wr_full,
    output  wire  [l_num_avmm1-1:0]      pld_avmm1_cmdfifo_wr_pfull,
    input   wire  [l_num_avmm1-1:0]      pld_avmm1_read,
    output  wire  [8*l_num_avmm1-1:0]    pld_avmm1_readdata,
    output  wire  [l_num_avmm1-1:0]      pld_avmm1_readdatavalid,
    input   wire  [10*l_num_avmm1-1:0]   pld_avmm1_reg_addr,
    input   wire  [l_num_avmm1-1:0]      pld_avmm1_request,
    input   wire  [9*l_num_avmm1-1:0]    pld_avmm1_reserved_in,
    output  wire  [3*l_num_avmm1-1:0]    pld_avmm1_reserved_out,
    input   wire  [l_num_avmm1-1:0]      pld_avmm1_write,
    input   wire  [8*l_num_avmm1-1:0]    pld_avmm1_writedata,
    output  wire  [l_num_avmm1-1:0]      pld_chnl_cal_done,
    output  wire  [l_num_avmm1-1:0]      pld_hssi_osc_transfer_en,
    //  for AVMM2 bb ports
    input   wire  [l_num_avmm2-1:0]      hip_avmm_read,
    output  wire  [8*l_num_avmm2-1:0]    hip_avmm_readdata,
    output  wire  [l_num_avmm2-1:0]      hip_avmm_readdatavalid,
    input   wire  [21*l_num_avmm2-1:0]   hip_avmm_reg_addr,
    output  wire  [5*l_num_avmm2-1:0]    hip_avmm_reserved_out,
    input   wire  [l_num_avmm2-1:0]      hip_avmm_write,
    input   wire  [8*l_num_avmm2-1:0]    hip_avmm_writedata,
    output  wire  [l_num_avmm2-1:0]      hip_avmm_writedone,
    output  wire  [l_num_avmm2-1:0]      pld_avmm2_busy,
    input   wire  [l_num_avmm2-1:0]      pld_avmm2_clk_rowclk,
    output  wire  [l_num_avmm2-1:0]      pld_avmm2_cmdfifo_wr_full,
    output  wire  [l_num_avmm2-1:0]      pld_avmm2_cmdfifo_wr_pfull,
    input   wire  [l_num_avmm2-1:0]      pld_avmm2_request,
    output  wire  [l_num_avmm2-1:0]      pld_pll_cal_done,
            // below are unused ports in hip mode
    input   wire  [l_num_avmm2-1:0]      pld_avmm2_write,
    input   wire  [l_num_avmm2-1:0]      pld_avmm2_read,
    input   wire  [9*l_num_avmm2-1:0]    pld_avmm2_reg_addr,
    output  wire  [8*l_num_avmm2-1:0]    pld_avmm2_readdata,
    input   wire  [8*l_num_avmm2-1:0]    pld_avmm2_writedata,
    output  wire  [l_num_avmm2-1:0]      pld_avmm2_readdatavalid,
    input   wire  [6*l_num_avmm2-1:0]    pld_avmm2_reserved_in,
    output  wire  [l_num_avmm2-1:0]      pld_avmm2_reserved_out,

      // Placement link ports for auto-instantiation of the soft reset controller
    output wire [num_xcvr_per_sys*num_sys_cop-1:0] placement_virtual_rx_xcvr,
    output wire [num_xcvr_per_sys*num_sys_cop-1:0] placement_virtual_tx_xcvr,
    output wire [num_xcvr_per_sys*num_sys_cop-1:0] placement_virtual_fht_xcvr
  );

localparam l_num_datalink_per_xcvr = l_num_aib_per_xcvr;
localparam fec_pma_150_on = fec_on? fec_on : ((num_xcvr_per_sys == 6)|| (num_xcvr_per_sys == 12));
localparam l_num_aib_per_hip = (fec_pma_150_on)? l_num_aib_per_xcvr * num_xcvr_per_sys  : l_num_aib_per_xcvr;
localparam num_hip_tx_per_sys = (fec_pma_150_on)? 1: l_num_hip_per_sys;
localparam num_hip_rx_per_sys = l_num_hip_per_sys;
localparam bb_f_ehip_frac_size_tx = (fec_on||(!fec_pma_150_on))? bb_f_ehip_frac_size : ((num_xcvr_per_sys == 6)? "F150G": "F300G");

// ------------------------------------------------------------------------ //
// ---------------------define local bb parameters ------------------------ //
// ------------------------------------------------------------------------ //
// bb_f_aib //
localparam  local_bb_f_aib_aibadapt_rx_rx_10g_krfec_rx_diag_data_status_polling_bypass = "DISABLE";
localparam  local_bb_f_aib_aibadapt_rx_rx_datapath_tb_sel = "AIBADAPT_RX_PCS_CHNL_TB";
localparam  local_bb_f_aib_aibadapt_rx_rx_pld_8g_wa_boundary_polling_bypass =  "DISABLE";
localparam  local_bb_f_aib_aibadapt_rx_rx_pld_pma_reser_in_polling_bypass = "DISABLE";
localparam  local_bb_f_aib_aibadapt_rx_rx_pld_pma_testbus_polling_bypass =  "DISABLE";
localparam  local_bb_f_aib_aibadapt_rx_rx_pld_test_data_polling_bypass =  "DISABLE";
localparam  local_bb_f_aib_aibadapt_rx_rx_user_clk_rst_sel = "AIBADAPT_RX_RX_USER_CLK_HARD_RST";
localparam  local_bb_f_aib_aibadapt_tx_loopback_mode =  "AIBADAPT_TX_LOOPBACK_DISABLE";
localparam  local_bb_f_aib_aibadapt_tx_tx_latency_src_xcvrif = "AIBADAPT_TX_LATENCY_PLS_E400E200";
localparam  local_bb_f_aib_aibadapt_tx_tx_user_clk_rst_sel = "AIBADAPT_TX_TX_USER_CLK_HARD_RST";
localparam  local_bb_f_aib_silicon_rev = "10nm6agdra";

localparam local_bb_f_aib_aib_tx_user_clk_hz = (bb_f_aib_aib_tx_user_clk_hz == -1) ? "__BB_DONT_CARE__" : bb_f_aib_aib_tx_user_clk_hz;     
localparam local_bb_f_aib_aib_rx_user_clk_hz = (bb_f_aib_aib_rx_user_clk_hz == -1) ? "__BB_DONT_CARE__" : bb_f_aib_aib_rx_user_clk_hz;    

// bb_f_ehip //
localparam  local_bb_f_ehip_aibif_data_valid =  "AIBIF_DATA_VALID_25G";
localparam  local_bb_f_ehip_dl_enable = enable_port_latency_measurement ? "ENABLE" : "DISABLE";
localparam [17:0] local_bb_f_ehip_q_dl_cfg_rxbit_rollover_attr = enable_port_latency_measurement ? 18'h1480: 18'h0;
//'h1480='d5280-xcvr_width(32)


localparam [36:0] local_bb_f_ehip_rx_word_clk_hz = bb_f_aib_aib_hssi_rx_transfer_clk_hz;
localparam  local_bb_f_ehip_sim_mode = "DISABLE";  //ww46 snap
localparam  [36:0]local_bb_f_ehip_tx_word_clk_hz = bb_f_aib_aib_hssi_tx_transfer_clk_hz;


// bb_f_ux //
localparam         local_bb_f_ux_cdr_bw_sel    = bb_f_ux_cdr_bw_sel    ;
localparam  [35:0] local_bb_f_ux_cdr_f_out_hz  = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_cdr_f_out_hz) ;
localparam  [35:0] local_bb_f_ux_cdr_f_vco_hz  = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_cdr_f_vco_hz) ;
localparam  [35:0] local_bb_f_ux_cdr_f_ref_hz  = bb_f_ux_cdr_f_ref_hz  ;
localparam   [5:0] local_bb_f_ux_cdr_l_counter = bb_f_ux_cdr_l_counter ;
localparam   [8:0] local_bb_f_ux_cdr_m_counter = bb_f_ux_cdr_m_counter ;
localparam   [5:0] local_bb_f_ux_cdr_n_counter = bb_f_ux_cdr_n_counter ;

//localparam   [1:0] local_bb_f_ux_cdr_fb_div_emb_mult_counter = bb_f_ux_cdr_fb_div_emb_mult_counter ;
localparam   [1:0] local_bb_f_ux_tx_fb_div_emb_mult_counter  = bb_f_ux_tx_fb_div_emb_mult_counter ;

localparam  local_bb_f_ux_cdr_postdiv_fractional_en = "DISABLE";

localparam  [15:0] local_bb_f_ux_cdr_ppm_driftcount = 16'h400;
localparam  local_bb_f_ux_dl_enable = enable_port_latency_measurement ? "ENABLE" : "DISABLE"; //ww46 snap
localparam  local_bb_f_ux_enable_static_refclk_network =  "FALSE";
localparam  local_bb_f_ux_force_refclk_power_to_specific_value = "FORCE_REFCLK_POWER_TO_SPECIFIC_VALUE_NONE";
localparam  [17:0] local_bb_f_ux_q_dl_cfg_rx_lat_bit_for_async_attr = enable_port_latency_measurement ? 18'h3e8 : 18'h0; //ww46 snap, 2020/03 learn from CPRI doc, this should be left empty, user read from CSR and set FEC codeword position

localparam  local_bb_f_ux_q_dl_cfg_rxbit_cntr_pma_attr = enable_port_latency_measurement ? "ENABLE" : "DISABLE";
localparam  [17:0] local_bb_f_ux_q_dl_cfg_rxbit_rollover_attr = enable_port_latency_measurement ? 18'h1480 : 18'h0; //ww46 snap
//'h1480='d5280-xcvr_width(32)

localparam  local_bb_f_ux_rx_powerdown_mode = "FALSE";
localparam  local_bb_f_ux_sim_mode = "DISABLE";    //ww46 snap
   


//### FGT XCVR RX/TX PLL attributes:
localparam  [35:0] local_bb_f_ux_synth_lc_fast_f_out_hz      = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_synth_lc_fast_f_out_hz);
localparam  [35:0] local_bb_f_ux_synth_lc_fast_f_vco_hz      = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_synth_lc_fast_f_vco_hz);
localparam  [35:0] local_bb_f_ux_synth_lc_fast_f_ref_hz      = bb_f_ux_synth_lc_fast_f_ref_hz;
localparam         local_bb_f_ux_synth_lc_fast_fractional_en = bb_f_ux_synth_lc_fast_fractional_en;
localparam  [21:0] local_bb_f_ux_synth_lc_fast_k_counter     = bb_f_ux_synth_lc_fast_k_counter ;
localparam  [5:0]  local_bb_f_ux_synth_lc_fast_l_counter     = bb_f_ux_synth_lc_fast_l_counter;
localparam  [8:0]  local_bb_f_ux_synth_lc_fast_m_counter     = bb_f_ux_synth_lc_fast_m_counter;
localparam  [5:0]  local_bb_f_ux_synth_lc_fast_n_counter     = bb_f_ux_synth_lc_fast_n_counter;
localparam         local_bb_f_ux_synth_lc_fast_primary_use   = bb_f_ux_synth_lc_fast_primary_use;

localparam  [35:0] local_bb_f_ux_synth_lc_med_f_out_hz       = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_synth_lc_med_f_out_hz);
localparam  [35:0] local_bb_f_ux_synth_lc_med_f_vco_hz       = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_synth_lc_med_f_vco_hz);
localparam  [35:0] local_bb_f_ux_synth_lc_med_f_ref_hz       = bb_f_ux_synth_lc_med_f_ref_hz;
localparam         local_bb_f_ux_synth_lc_med_fractional_en  = bb_f_ux_synth_lc_med_fractional_en;
localparam  [21:0] local_bb_f_ux_synth_lc_med_k_counter      = bb_f_ux_synth_lc_med_k_counter ;
localparam  [5:0]  local_bb_f_ux_synth_lc_med_l_counter      = bb_f_ux_synth_lc_med_l_counter;
localparam  [8:0]  local_bb_f_ux_synth_lc_med_m_counter      = bb_f_ux_synth_lc_med_m_counter;
localparam  [5:0]  local_bb_f_ux_synth_lc_med_n_counter      = bb_f_ux_synth_lc_med_n_counter;
localparam         local_bb_f_ux_synth_lc_med_primary_use    = bb_f_ux_synth_lc_med_primary_use;

localparam  [35:0] local_bb_f_ux_synth_lc_slow_f_out_hz      = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_synth_lc_slow_f_out_hz);
localparam  [35:0] local_bb_f_ux_synth_lc_slow_f_vco_hz      = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_synth_lc_slow_f_vco_hz);
localparam  [35:0] local_bb_f_ux_synth_lc_slow_f_ref_hz      = bb_f_ux_synth_lc_slow_f_ref_hz;
localparam         local_bb_f_ux_synth_lc_slow_fractional_en = bb_f_ux_synth_lc_slow_fractional_en;
localparam  [21:0] local_bb_f_ux_synth_lc_slow_k_counter     = bb_f_ux_synth_lc_slow_k_counter ;
localparam  [5:0]  local_bb_f_ux_synth_lc_slow_l_counter     = bb_f_ux_synth_lc_slow_l_counter;
localparam  [8:0]  local_bb_f_ux_synth_lc_slow_m_counter     = bb_f_ux_synth_lc_slow_m_counter;
localparam  [5:0]  local_bb_f_ux_synth_lc_slow_n_counter     = bb_f_ux_synth_lc_slow_n_counter;
localparam         local_bb_f_ux_synth_lc_slow_primary_use   = bb_f_ux_synth_lc_slow_primary_use;

localparam         local_bb_f_ux_tx_pll                      = bb_f_ux_tx_pll;
localparam         local_bb_f_ux_tx_pll_bw_sel               = bb_f_ux_tx_pll_bw_sel;



//### FGT XCVR:
localparam  local_bb_f_ux_tx_powerdown_mode = "FALSE";
localparam  local_bb_f_ux_ux_q_ckmux_cpu_attr =  "CKMUX_CPU_AVMM";
localparam  local_bb_f_ux_ux_q_e_rx_dp_pipe_attr =  "E_RX_DP_NO_PIPE";
localparam  local_bb_f_ux_ux_q_e_tx_dp_pipe_attr =  "E_TX_DP_NO_PIPE";


//vsr mode, parallel loopback_mode and hard pcie low loss attribute issue
localparam  local_protocol_hard_pcie_lowloss = (bb_f_ux_loopback_mode=="LOOPBACK_MODE_PARALLEL_LOOPBACK" ) ? "ENABLE" : "DISABLE" ;


// bb_m_hdpldadapt_avmm1 //
localparam  [30:0] local_bb_m_hdpldadapt_avmm1_hdpldadapt_pld_avmm1_clk_rowclk_hz = 31'b10001001010100001101001101;

// bb_m_hdpldadapt_avmm2 //
localparam  [30:0] local_bb_m_hdpldadapt_avmm2_hdpldadapt_pld_avmm2_clk_rowclk_hz = 31'b1010101111001000111101000111;

// bb_m_avmm.auto_profile_id, set it when it is tx simplex //
localparam avmm_profile_id = (l_tx_enable & ~l_rx_enable)? "__${ip_inst_d}__" : "__BB_DONT_CARE__" ;

// bb_m_hdpldadapt_tx //
localparam  local_bb_m_hdpldadapt_tx_duplex_mode = "ENABLE";


//TODO move this logic to tcl
// this one is pma4style
//localparam  local_bb_f_ux_rx_master_bond_chnl = (bb_f_ehip_xcvr_type=="XCVR_TYPE_UX" && bb_f_ux_txrx_channel_operation == "TXRX_CHANNEL_OPERATION_DUAL_SIMPLEX") ? "RX_MASTER_BOND_CHNL_DISABLED" : bb_f_ux_rx_master_bond_chnl;
localparam  local_bb_f_ux_rx_bond_size        = (bb_f_ehip_xcvr_type=="XCVR_TYPE_UX" && bb_f_ux_txrx_channel_operation == "TXRX_CHANNEL_OPERATION_DUAL_SIMPLEX") ? "RX_BOND_SIZE_1"               : bb_f_ux_rx_bond_size;

// this one is pma2style
//localparam  local_bb_f_ux_rx_master_bond_chnl = (bb_f_ehip_xcvr_type=="XCVR_TYPE_UX" && bb_f_ux_txrx_channel_operation == "TXRX_CHANNEL_OPERATION_DUAL_SIMPLEX") ? "RX_MASTER_BOND_CHNL_DISABLED" : bb_f_ux_rx_master_bond_chnl;
//localparam  local_bb_f_ux_rx_bond_size        = (bb_f_ehip_xcvr_type=="XCVR_TYPE_UX" && bb_f_ux_txrx_channel_operation == "TXRX_CHANNEL_OPERATION_DUAL_SIMPLEX") ? "RX_BOND_SIZE_DISABLED"        : bb_f_ux_rx_bond_size;

// ---------------------define local bb parameters END ------------------------ //
    wire [num_xcvr_per_sys*num_sys_cop-1:0] lc_cascade_out_link;
      
    wire [47:0]                              xcvr_tx_data_link     [2*num_sys_cop*num_hip_tx_per_sys-1:0];  
    wire [47:0]                              xcvr_rx_data_link     [2*num_sys_cop*num_hip_rx_per_sys-1:0];  
    wire [15:0]                              ip_tx_data_link       [num_sys_cop*num_hip_tx_per_sys-1:0];
    wire [15:0]                              ip_rx_data_link       [num_sys_cop*num_hip_rx_per_sys-1:0];
    wire [num_xcvr_per_sys*l_num_aib_per_xcvr-1:0]            aib_tx_data_link   [num_sys_cop-1:0];
    wire [num_xcvr_per_sys*l_num_aib_per_xcvr-1:0]            aib_rx_data_link   [num_sys_cop-1:0];
    wire [num_xcvr_per_sys*l_num_aib_per_xcvr-1:0]            adapt_tx_data_link [num_sys_cop-1:0];
    wire [num_xcvr_per_sys*l_num_aib_per_xcvr-1:0]            adapt_rx_data_link [num_sys_cop-1:0];

    wire  [num_xcvr_per_sys*l_num_aib_per_xcvr-1:0]           avmm1_link [num_sys_cop-1:0];
    wire  [num_xcvr_per_sys-1:0]                     avmm2_link [num_sys_cop-1:0];
    
    wire  [num_xcvr_per_sys*num_sys_cop-1:0] cdrdiv_clkout;

    assign rx_cdr_divclk_link0 = cdrdiv_clkout[fgt_rx_cdr_divclk_link0_sel];
    assign rx_cdr_divclk_link1 = cdrdiv_clkout[fgt_rx_cdr_divclk_link1_sel];
  
    localparam  MAX_CONVERSION_SIZE_ALT_XCVR_NATIVE_S10 = 128;
    localparam  MAX_STRING_CHARS_ALT_XCVR_NATIVE_S10  = 64;
    localparam integer MAX_CHARS_ALT_XCVR_NATIVE_S10 = 86; // To accomodate LONG parameter lists.
    
    function automatic [127:0] str_2_bin_alt_xcvr_native_gdr;
      input [511:0] instring;

      integer this_char;
      integer i;
      begin
        // Initialize accumulator
        str_2_bin_alt_xcvr_native_gdr = {128{1'b0}};
        for(i=63;i>=0;i=i-1) begin
          this_char = instring[i*8+:8];
          // Add value of this digit
          if(this_char >= 48 && this_char <= 57)
            str_2_bin_alt_xcvr_native_gdr = (str_2_bin_alt_xcvr_native_gdr * 10) + (this_char - 48);
        end
      end
    endfunction    
    
    //todo: in the absence of proper documentation, all frequency and datarate related attributes assumed to be 37 bits which might be wrong
    localparam [36:0] bin_bb_f_ehip_tx_datarate       = str_2_bin_alt_xcvr_native_gdr(dec_bb_f_ehip_tx_datarate);
    localparam [36:0] bin_bb_f_ehip_rx_datarate       = str_2_bin_alt_xcvr_native_gdr(dec_bb_f_ehip_rx_datarate);
    localparam [36:0] bin_bb_f_ux_tx_line_rate_bps    = str_2_bin_alt_xcvr_native_gdr(dec_bb_f_ehip_tx_datarate);
    localparam [36:0] bin_bb_f_ux_rx_line_rate_bps    = str_2_bin_alt_xcvr_native_gdr(dec_bb_f_ehip_rx_datarate);

 
`ifdef __TILE_IP__
    wire [num_sys_cop*num_hip_rx_per_sys-1:0] duplex_bond_ehip_rx;
    wire [num_sys_cop*num_hip_tx_per_sys-1:0] duplex_bond_ehip_tx;
    wire [num_sys_cop*num_hip_tx_per_sys-1:0] duplex_bond_ehip_dummy;
  
    assign duplex_bond_ehip_tx = ((num_xcvr_per_sys ==6)||(num_xcvr_per_sys == 12))? duplex_bond_ehip_dummy : duplex_bond_ehip_rx; 
    wire [num_sys_cop*num_xcvr_per_sys-1:0] duplex_bond_ux_rx;
    wire [num_sys_cop*num_xcvr_per_sys-1:0] duplex_bond_ux_tx;
    assign duplex_bond_ux_rx = duplex_bond_ux_tx;

    wire [l_sys_aibs-1:0] duplex_bond_aib_rx ;
    wire [l_sys_aibs-1:0] duplex_bond_aib_tx;
    assign duplex_bond_aib_rx = duplex_bond_aib_tx;

    wire [num_hip_rx_per_sys:0] ehip_bonding_link_rx [num_sys_cop-1:0] ;
    wire [num_hip_tx_per_sys:0] ehip_bonding_link_tx [num_sys_cop-1:0] ;
    wire [num_xcvr_per_sys:0] ux_bonding_link_rx [num_sys_cop-1:0] ;
    wire [num_xcvr_per_sys:0] ux_bonding_link_tx [num_sys_cop-1:0] ;
    wire [num_xcvr_per_sys:0] bk_bonding_link [num_sys_cop-1:0] ;

   // JRJ - 9/22/2020 - wires for connecting primary channel and secondary channels for soft reset controller MIF generation

   logic [num_sys_cop-1:0] mif_generation_link_rx;
   logic [num_sys_cop-1:0] mif_generation_link_tx;
   logic [num_sys_cop-1:0] mif_generation_link_fht;

   logic [num_xcvr_per_sys*num_sys_cop-1:0] mif_generation_link_primary_rx;
   logic [num_xcvr_per_sys*num_sys_cop-1:0] mif_generation_link_primary_tx;
   logic [num_xcvr_per_sys*num_sys_cop-1:0] mif_generation_link_primary_fht;

   logic [num_xcvr_per_sys*num_sys_cop-1:0] mif_generation_link_secondary_rx;
   logic [num_xcvr_per_sys*num_sys_cop-1:0] mif_generation_link_secondary_tx;
   logic [num_xcvr_per_sys*num_sys_cop-1:0] mif_generation_link_secondary_fht;
   
    genvar idx_sys_cop;
    generate
      for(idx_sys_cop=0;idx_sys_cop<num_sys_cop;idx_sys_cop=idx_sys_cop+1) begin: persystem

//LUZ ehip = num_xcvr for pmadir, fecdir num_ehip_per_sys=1;
            genvar idx_hip;
            for(idx_hip=0;idx_hip<num_hip_rx_per_sys;idx_hip=idx_hip+1) begin: perehip_rx
                localparam idx_hip_total = idx_sys_cop*num_hip_rx_per_sys+idx_hip;
		localparam idx_avmm1_psys = l_num_aib_per_hip * idx_hip;
      
         if (l_rx_enable && (bb_f_ehip_xcvr_type == "XCVR_TYPE_UX")) begin:rx_ehip 
             bb_f_ehip_rx
        #( 
            .silicon_rev  (silicon_revision),
            .aib2_rx_st_clk_en  (bb_f_ehip_aib2_rx_st_clk_en),
            .aib3_rx_st_clk_en  (bb_f_ehip_aib3_rx_st_clk_en),
            .dl_enable  (local_bb_f_ehip_dl_enable),
            .duplex_mode  (bb_f_ehip_duplex_mode),
            .fec_802p3ck  (bb_f_ehip_fec_802p3ck),
            .fec_clk_src  (bb_f_ehip_fec_clk_src),
            .fec_mode  (bb_f_ehip_fec_mode),
            .fec_spec  (bb_f_ehip_fec_spec),
            .frac_size  (bb_f_ehip_frac_size),
            .lpbk_mode  (bb_f_ehip_lpbk_mode),
            .mac_mode   (bb_f_ehip_mac_mode),
            .rx_pmadirect_single_width  (bb_f_ehip_rx_pmadirect_single_width),//copy from MAIB FIFO width, PHE may remove later. TOG pattern all double width
            .q_dl_cfg_rxbit_rollover_attr  (local_bb_f_ehip_q_dl_cfg_rxbit_rollover_attr),//DL support
            .is_fec_part_of_reconfig (bb_f_ehip_is_fec_part_of_reconfig),
            .rx_aib_if_fifo_mode  (bb_f_ehip_rx_aib_if_fifo_mode),
            .rx_datarate  (bin_bb_f_ehip_rx_datarate),
            .rx_en  (bb_f_ehip_rx_en),
            .rx_excvr_gb_ratio_mode  (bb_f_ehip_rx_excvr_gb_ratio_mode),
            .rx_excvr_if_fifo_mode  (bb_f_ehip_rx_excvr_if_fifo_mode),
            .rx_fec_enable  (bb_f_ehip_rx_fec_enable),
            .rx_pcs_mode  (bb_f_ehip_rx_pcs_mode),
            .rx_primary_use  (bb_f_ehip_rx_primary_use),
            .rx_total_xcvr  (bb_f_ehip_rx_total_xcvr),
            .rx_word_clk_hz  (local_bb_f_ehip_rx_word_clk_hz),
            .rx_xcvr_width  (bb_f_ehip_rx_xcvr_width),
            .sim_mode  (local_bb_f_ehip_sim_mode),
            .speed_map  (bb_f_ehip_speed_map),
            .sup_mode  ("SUP_MODE_USER_MODE"),
            .sys_clk_src  (bb_f_ehip_sys_clk_src),
            .xcvr_mode  (bb_f_ehip_xcvr_mode),
            .xcvr_type  (bb_f_ehip_xcvr_type)
        )
   x_bb_f_ehip_rx
     (
      .duplex_bond_link(duplex_bond_ehip_rx[idx_hip_toal]),
//      .xcvr_data_link((bb_f_ehip_xcvr_type == "XCVR_TYPE_UX")?xcvr_rx_data_link[idx_hip_total]:xcvr_tx_data_link[idx_hip_total]),
      .xcvr_data_link(xcvr_rx_data_link[idx_hip_total]), //QTLG PASS
      .ip_data_link(ip_rx_data_link[idx_hip_total]),
      .next_bonding_link(ehip_bonding_link_rx[idx_sys_cop][idx_hip+1]),
      .prev_bonding_link(ehip_bonding_link_rx[idx_sys_cop][idx_hip]),
      .pll_link(system_pll_clk_link[idx_sys_cop]),
      .avmm1_link(avmm1_link[idx_sys_cop][idx_avmm1_psys]) 
     );
    end //rx_ehip
    
         else if (l_rx_enable && (bb_f_ehip_xcvr_type != "XCVR_TYPE_UX")) begin:rx_ehip 
             bb_f_ehip_rx
        #( 
            .silicon_rev  (silicon_revision),
            .aib2_rx_st_clk_en  (bb_f_ehip_aib2_rx_st_clk_en),
            .aib3_rx_st_clk_en  (bb_f_ehip_aib3_rx_st_clk_en),
            .dl_enable  (local_bb_f_ehip_dl_enable),
            .duplex_mode  (bb_f_ehip_duplex_mode),
            .fec_802p3ck  (bb_f_ehip_fec_802p3ck),
            .fec_clk_src  (bb_f_ehip_fec_clk_src),
            .fec_mode  (bb_f_ehip_fec_mode),
            .fec_spec  (bb_f_ehip_fec_spec),
            .frac_size  (bb_f_ehip_frac_size),
            .lpbk_mode  (bb_f_ehip_lpbk_mode),
            .mac_mode   (bb_f_ehip_mac_mode),
             .rx_pmadirect_single_width  (bb_f_ehip_rx_pmadirect_single_width),//copy from MAIB FIFO width, PHE may remove later. TOG pattern all double width
            .q_dl_cfg_rxbit_rollover_attr  (local_bb_f_ehip_q_dl_cfg_rxbit_rollover_attr),//DL support
            .is_fec_part_of_reconfig (bb_f_ehip_is_fec_part_of_reconfig),
            .rx_aib_if_fifo_mode  (bb_f_ehip_rx_aib_if_fifo_mode),
            .rx_datarate  (bin_bb_f_ehip_rx_datarate),
            .rx_en  (bb_f_ehip_rx_en),
            .rx_excvr_gb_ratio_mode  (bb_f_ehip_rx_excvr_gb_ratio_mode),
            .rx_excvr_if_fifo_mode  (bb_f_ehip_rx_excvr_if_fifo_mode),
            .rx_fec_enable  (bb_f_ehip_rx_fec_enable),
            .rx_pcs_mode  (bb_f_ehip_rx_pcs_mode),
            .rx_primary_use  (bb_f_ehip_rx_primary_use),
            .rx_total_xcvr  (bb_f_ehip_rx_total_xcvr),
            .rx_word_clk_hz  (local_bb_f_ehip_rx_word_clk_hz),
            .rx_xcvr_width  (bb_f_ehip_rx_xcvr_width),
            .sim_mode  (local_bb_f_ehip_sim_mode),
            .speed_map  (bb_f_ehip_speed_map),
            .sup_mode  ("SUP_MODE_USER_MODE"),
            .sys_clk_src  (bb_f_ehip_sys_clk_src),
            .xcvr_mode  (bb_f_ehip_xcvr_mode),
            .xcvr_type  (bb_f_ehip_xcvr_type)
        )
   x_bb_f_ehip_rx
     (
      .duplex_bond_link(duplex_bond_ehip_rx[idx_hip_toal]),
//      .xcvr_data_link((bb_f_ehip_xcvr_type == "XCVR_TYPE_UX")?xcvr_rx_data_link[idx_hip_total]:xcvr_tx_data_link[idx_hip_total]),
      .xcvr_data_link(xcvr_tx_data_link[idx_hip_total]), //QTLG PASS
      .ip_data_link(ip_rx_data_link[idx_hip_total]),
      .next_bonding_link(ehip_bonding_link_rx[idx_sys_cop][idx_hip+1]),
      .prev_bonding_link(ehip_bonding_link_rx[idx_sys_cop][idx_hip]),
      .pll_link(system_pll_clk_link[idx_sys_cop]),
      .avmm1_link(avmm1_link[idx_sys_cop][idx_avmm1_psys]) 
     );
    end //rx_ehip
end //perehip_rx
    for(idx_hip=0;idx_hip<num_hip_tx_per_sys;idx_hip=idx_hip+1) begin: perehip_tx
    localparam idx_hip_total = idx_sys_cop*num_hip_tx_per_sys+idx_hip;
    localparam idx_avmm1_psys = l_num_aib_per_hip * idx_hip;
    if (l_tx_enable) begin:tx_ehip 
        bb_f_ehip_tx
        #( 
            .silicon_rev  (silicon_revision),
            .aib2_tx_st_clk_en  (bb_f_ehip_aib2_tx_st_clk_en),
            .aib3_tx_st_clk_en  ( (bb_f_ux_core_pll=="CORE_PLL_DISABLED") ? bb_f_ehip_aib3_tx_st_clk_en : "__BB_DONT_CARE__"),
            .aibif_data_valid  (local_bb_f_ehip_aibif_data_valid),
            .dl_enable  (local_bb_f_ehip_dl_enable),
            .duplex_mode  (bb_f_ehip_duplex_mode),
            .fec_802p3ck  (bb_f_ehip_fec_802p3ck),
            .fec_clk_src  (bb_f_ehip_fec_clk_src),
            .fec_mode  (bb_f_ehip_fec_mode),
            .fec_spec  (bb_f_ehip_fec_spec),
            .frac_size  (bb_f_ehip_frac_size_tx),
            .lpbk_mode  (bb_f_ehip_lpbk_mode),
            .mac_mode   (bb_f_ehip_mac_mode),
             .tx_pmadirect_single_width  (bb_f_ehip_tx_pmadirect_single_width),//copy from MAIB FIFO width, PHE may remove later. TOG pattern all double width
            .q_dl_cfg_rxbit_rollover_attr  (local_bb_f_ehip_q_dl_cfg_rxbit_rollover_attr),//DL support
            .is_fec_part_of_reconfig (bb_f_ehip_is_fec_part_of_reconfig),
            .sim_mode  (local_bb_f_ehip_sim_mode),
            .speed_map  (bb_f_ehip_speed_map),
            .sup_mode  ( (bb_f_ux_core_pll=="CORE_PLL_DISABLED") ? "SUP_MODE_USER_MODE" : "__BB_DONT_CARE__"),
            .sys_clk_src  (bb_f_ehip_sys_clk_src),
            .tx_aib_if_fifo_mode  (bb_f_ehip_tx_aib_if_fifo_mode),
            .tx_datarate  (bin_bb_f_ehip_tx_datarate),
            .tx_en  (bb_f_ehip_tx_en),
            .tx_excvr_gb_ratio_mode  (bb_f_ehip_tx_excvr_gb_ratio_mode),
            .tx_excvr_if_fifo_mode  (bb_f_ehip_tx_excvr_if_fifo_mode),
            .tx_fec_enable  (bb_f_ehip_tx_fec_enable),
            .tx_pcs_mode  (bb_f_ehip_tx_pcs_mode),
            .tx_primary_use  (bb_f_ehip_tx_primary_use),
            .tx_total_xcvr  (bb_f_ehip_tx_total_xcvr),
            .tx_word_clk_hz  (local_bb_f_ehip_tx_word_clk_hz),
            .tx_xcvr_width  (bb_f_ehip_tx_xcvr_width),
            .xcvr_mode  (bb_f_ehip_xcvr_mode),
            .xcvr_type  (bb_f_ehip_xcvr_type)
        )
   x_bb_f_ehip_tx
     (
      .duplex_bond_link(duplex_bond_ehip_tx[idx_hip_total]),
      .xcvr_data_link(xcvr_tx_data_link[idx_hip_total]),
      .ip_data_link(ip_tx_data_link[idx_hip_total]),
      .pll_link(system_pll_clk_link[idx_sys_cop]),
      .next_bonding_link(ehip_bonding_link_tx[idx_sys_cop][idx_hip+1]),
      .prev_bonding_link(ehip_bonding_link_tx[idx_sys_cop][idx_hip]),
      .avmm1_link(avmm1_link[idx_sys_cop][idx_avmm1_psys]) 
     );
       end //tx_ehip

    end          //perehip_tx                                                          

     genvar idx_xcvr_per_sys;
             for (idx_xcvr_per_sys=0;idx_xcvr_per_sys<num_xcvr_per_sys;idx_xcvr_per_sys=idx_xcvr_per_sys+1) begin: perxcvr
                 localparam idx_xcvr_total = num_xcvr_per_sys*idx_sys_cop + idx_xcvr_per_sys;
                 localparam idx_m_data0link = (fec_pma_150_on == 1) ? (idx_sys_cop) : (idx_sys_cop*num_xcvr_per_sys+idx_xcvr_per_sys);
                 localparam idx_n_data0link = (fec_pma_150_on == 0 )? (0)           : (idx_xcvr_per_sys*l_num_datalink_per_xcvr);
                 localparam idx_m_data1link = l_num_datalink_per_xcvr>1  ? (idx_m_data0link)   : (fec_pma_150_on ?  (num_sys_cop+idx_sys_cop) : (num_sys_cop*num_xcvr_per_sys+idx_xcvr_per_sys));
                 localparam idx_n_data1link = l_num_datalink_per_xcvr>1  ? (idx_n_data0link+1) : (!fec_pma_150_on ? (1)           : idx_n_data0link);
                 localparam idx_m_data23link = l_num_datalink_per_xcvr>3 ? (idx_m_data0link)   : (fec_pma_150_on ?  (num_sys_cop+idx_sys_cop) : (num_sys_cop*num_xcvr_per_sys+idx_xcvr_per_sys));
                 localparam idx_n_data2link = l_num_datalink_per_xcvr>3  ? (idx_n_data0link+2) : (!fec_pma_150_on ? (2)           : (idx_n_data0link+16));
                 localparam idx_n_data3link = l_num_datalink_per_xcvr>3  ? (idx_n_data0link+3) : (!fec_pma_150_on ? (3)           : (idx_n_data0link+32));
///DEBUG
                 localparam idx_m_data0link_rx = (fec_on == 1) ? (idx_sys_cop) : (idx_sys_cop*num_xcvr_per_sys+idx_xcvr_per_sys);
                 localparam idx_n_data0link_rx = (fec_on == 0 )? (0)           : (idx_xcvr_per_sys*l_num_datalink_per_xcvr);
                 localparam idx_m_data1link_rx = l_num_datalink_per_xcvr>1  ? (idx_m_data0link_rx)   : (fec_on ?  (num_sys_cop+idx_sys_cop) : (num_sys_cop*num_xcvr_per_sys+idx_xcvr_per_sys));
                 localparam idx_n_data1link_rx = l_num_datalink_per_xcvr>1  ? (idx_n_data0link_rx+1) : (!fec_on ? (1)           : idx_n_data0link);
                 localparam idx_m_data23link_rx = l_num_datalink_per_xcvr>3 ? (idx_m_data0link_rx)   : (fec_on ?  (num_sys_cop+idx_sys_cop) : (num_sys_cop*num_xcvr_per_sys+idx_xcvr_per_sys));
                 localparam idx_n_data2link_rx = l_num_datalink_per_xcvr>3  ? (idx_n_data0link_rx+2) : (!fec_on ? (2)           : (idx_n_data0link_rx+16));
                 localparam idx_n_data3link_rx = l_num_datalink_per_xcvr>3  ? (idx_n_data0link_rx+3) : (!fec_on ? (3)           : (idx_n_data0link_rx+32));
            //instantiate aibs, for now assuming num tx and rx are equal
                genvar idx_aib_per_xcvr;
                for(idx_aib_per_xcvr=0;idx_aib_per_xcvr<l_num_aib_per_xcvr;idx_aib_per_xcvr=idx_aib_per_xcvr+1) begin: peraib
                     localparam idx_aib_per_sys = idx_xcvr_per_sys*l_num_aib_per_xcvr + idx_aib_per_xcvr;
                     localparam idx_aib_total  = idx_sys_cop*num_xcvr_per_sys*l_num_aib_per_xcvr + idx_aib_per_sys;
                     localparam idx_m_iplink = (fec_pma_150_on == 1)? (idx_sys_cop)     : (l_num_datalink_per_xcvr==1 ? (idx_aib_total) : (idx_sys_cop*num_xcvr_per_sys+idx_xcvr_per_sys));
                     localparam idx_n_iplink = (fec_pma_150_on == 1)? (idx_aib_per_sys) : (l_num_datalink_per_xcvr==1 ? (0)               : (idx_aib_per_xcvr));
// DEBUG
                     localparam idx_m_iplink_rx = (fec_on == 1)? (idx_sys_cop)     : (l_num_datalink_per_xcvr==1 ? (idx_aib_total) : (idx_sys_cop*num_xcvr_per_sys+idx_xcvr_per_sys));
                     localparam idx_n_iplink_rx = (fec_on == 1)? (idx_aib_per_sys) : (l_num_datalink_per_xcvr==1 ? (0)               : (idx_aib_per_xcvr));
                                                        
                 if (l_rx_enable) begin:rx_aib 
                     bb_f_aib_rx
                #(
                    .silicon_rev  (silicon_revision),
.aib_rx_user_clk_hz(local_bb_f_aib_aib_rx_user_clk_hz),
.aibadapt_rx_rx_datapath_tb_sel  (local_bb_f_aib_aibadapt_rx_rx_datapath_tb_sel),
.aib_hssi_rx_transfer_clk_hz (bb_f_aib_aib_hssi_rx_transfer_clk_hz),
.aibadapt_rx_rx_user_clk_rst_sel  (local_bb_f_aib_aibadapt_rx_rx_user_clk_rst_sel),
.aibadapt_rx_rx_user_clk_sel  (bb_f_aib_aibadapt_rx_rx_user_clk_sel)
                )
                x_bb_f_aib_rx
                (
                    .duplex_bond_link (duplex_bond_aib_rx[idx_aib_total]),
                    .ip_data_link(ip_rx_data_link[idx_m_iplink_rx][idx_n_iplink_rx]),
                    .aib_rx_data_link(aib_rx_data_link[idx_sys_cop][idx_aib_per_sys]),
                    .avmm1_link(avmm1_link[idx_sys_cop][idx_aib_per_sys]) 
                );
	        end
                if (l_tx_enable) begin:tx_aib 
		    bb_f_aib_tx
                #(
                    .silicon_rev  (silicon_revision),
.aib_tx_user_clk_hz(local_bb_f_aib_aib_tx_user_clk_hz),
.aibadapt_tx_loopback_mode  (local_bb_f_aib_aibadapt_tx_loopback_mode),
.aibadapt_tx_sup_mode  ("AIBADAPT_TX_USER_MODE"),
.aibadapt_tx_tx_latency_src_xcvrif  (local_bb_f_aib_aibadapt_tx_tx_latency_src_xcvrif),
.aibadapt_tx_tx_user_clk_rst_sel  (local_bb_f_aib_aibadapt_tx_tx_user_clk_rst_sel),
.aib_hssi_tx_transfer_clk_hz (bb_f_aib_aib_hssi_tx_transfer_clk_hz),
.aibadapt_tx_tx_user_clk_sel  (bb_f_aib_aibadapt_tx_tx_user_clk_sel)
                )
                x_bb_f_aib_tx
                (
                    .duplex_bond_link (duplex_bond_aib_tx[idx_aib_total]),
                    .ip_data_link(ip_tx_data_link[idx_m_iplink][idx_n_iplink]),
                    .aib_tx_data_link(aib_tx_data_link[idx_sys_cop][idx_aib_per_sys]),
                    .avmm1_link(avmm1_link[idx_sys_cop][idx_aib_per_sys]) 
                );
	       end

	       if (l_av1_enable) begin: av1_en
	           bb_m_hdpldadapt_avmm1 #(
                          .silicon_rev  (m_silicon_revision),
                          .auto_profile_id  (avmm_profile_id),
                          .hdpldadapt_pld_avmm1_clk_rowclk_hz(local_bb_m_hdpldadapt_avmm1_hdpldadapt_pld_avmm1_clk_rowclk_hz )
                   )
                   x_bb_f_avmm1 (
                   .pld_avmm1_busy_real              ( pld_avmm1_busy[idx_aib_total] ), 
                   .pld_avmm1_clk_rowclk_real        ( pld_avmm1_clk_rowclk[idx_aib_total] ),
                   .pld_avmm1_cmdfifo_wr_full_real   ( pld_avmm1_cmdfifo_wr_full[idx_aib_total] ),
                   .pld_avmm1_cmdfifo_wr_pfull_real  ( pld_avmm1_cmdfifo_wr_pfull[idx_aib_total] ),
                   .pld_avmm1_read_real              ( pld_avmm1_read[idx_aib_total] ),
                   .pld_avmm1_readdata_real          ( pld_avmm1_readdata[8*idx_aib_total+:8] ),
                   .pld_avmm1_readdatavalid_real     ( pld_avmm1_readdatavalid[idx_aib_total] ),
                   .pld_avmm1_reg_addr_real          ( pld_avmm1_reg_addr[10*idx_aib_total+:10] ),
                   .pld_avmm1_request_real           ( pld_avmm1_request[idx_aib_total] ),
                   .pld_avmm1_reserved_in_real       ( pld_avmm1_reserved_in[9*idx_aib_total+:9] ),
                   .pld_avmm1_reserved_out_real      ( pld_avmm1_reserved_out[3*idx_aib_total+:3] ),
                   .pld_avmm1_write_real             ( pld_avmm1_write[idx_aib_total] ),
                   .pld_avmm1_writedata_real         ( pld_avmm1_writedata[8*idx_aib_total+:8] ),
                  // removed for  PMA direct SR   .pld_chnl_cal_done_real           ( pld_chnl_cal_done[idx_aib_total] ),
                   .pld_hssi_osc_transfer_en_real    ( pld_hssi_osc_transfer_en[idx_aib_total] ),
                   .avmm1_link                       (avmm1_link[idx_sys_cop][idx_aib_per_sys])
	          );
                end   

                if (l_rx_enable) begin:rx_aib 
		  bb_m_aib_rx
                   #(
                     .silicon_rev  (m_silicon_revision)
                   )
                   x_bb_m_aib_rx
                   (
                     .aib_rx_data_link(aib_rx_data_link[idx_sys_cop][idx_aib_per_sys]),
                     .adapt_rx_data_link(adapt_rx_data_link[idx_sys_cop][idx_aib_per_sys]),
                     .avmm1_link(avmm1_link[idx_sys_cop][idx_aib_per_sys])
                   );
 
                   bb_m_hdpldadapt_rx
                   #(
                     .silicon_rev  (m_silicon_revision),
                     .fifo_mode  (bb_m_hdpldadapt_rx_fifo_mode),
                     .fifo_width  (bb_m_hdpldadapt_rx_fifo_width),
                     .hdpldadapt_pld_rx_clk1_dcm_hz  (bb_m_hdpldadapt_rx_hdpldadapt_pld_rx_clk1_dcm_hz),
                     .hdpldadapt_pld_rx_clk1_rowclk_hz  (bb_m_hdpldadapt_rx_hdpldadapt_pld_rx_clk1_rowclk_hz),
                     //.hdpldadapt_speed_grade  (bb_m_hdpldadapt_rx_hdpldadapt_speed_grade),
                     .pld_clk1_sel  (bb_m_hdpldadapt_rx_pld_clk1_sel),
                     .rx_datapath_tb_sel  (bb_m_hdpldadapt_rx_rx_datapath_tb_sel),
                     .rxfifo_pempty  (bb_m_hdpldadapt_rx_rxfifo_pempty),
                     .rxfifo_pfull  (bb_m_hdpldadapt_rx_rxfifo_pfull)
                   )
                   x_bb_m_hdpldadapt_rx
                   (
                     .pld_rx_fabric_fifo_rd_en_real        ( rx_fifo_rd_en[idx_aib_per_sys]  ),
                     .pld_rx_fabric_fifo_empty_real        ( rx_fifo_empty[idx_aib_per_sys]  ),
                     .pld_rx_fabric_fifo_full_real         ( rx_fifo_full[idx_aib_per_sys]   ),
                     .pld_rx_fabric_fifo_pempty_real       ( rx_fifo_pempty[idx_aib_per_sys] ),
                     .pld_rx_fabric_fifo_pfull_real        ( rx_fifo_pfull[idx_aib_per_sys]  ),

                     .pld_10g_krfec_rx_blk_lock_real  ( pld_10g_krfec_rx_blk_lock[idx_aib_per_sys] ),
                     .pld_10g_krfec_rx_clr_errblk_cnt_real  ( pld_10g_krfec_rx_clr_errblk_cnt[idx_aib_per_sys] ),
                     .pld_10g_krfec_rx_diag_data_status_real  ( pld_10g_krfec_rx_diag_data_status[2*idx_aib_per_sys+:2] ),
                     .pld_10g_krfec_rx_frame_real  ( pld_10g_krfec_rx_frame[idx_aib_per_sys] ),
                     .pld_10g_rx_crc32_err_real  ( pld_10g_rx_crc32_err[idx_aib_per_sys] ),
                     .pld_10g_rx_frame_lock_real  ( pld_10g_rx_frame_lock[idx_aib_per_sys] ),
                     .pld_10g_rx_hi_ber_real  ( pld_10g_rx_hi_ber[idx_aib_per_sys] ),
                     .pld_8g_a1a2_k1k2_flag_real  ( pld_8g_a1a2_k1k2_flag[4*idx_aib_per_sys+:4] ),
                     .pld_8g_bitloc_rev_en_real  ( pld_8g_bitloc_rev_en[idx_aib_per_sys] ),
                     .pld_8g_byte_rev_en_real  ( pld_8g_byte_rev_en[idx_aib_per_sys] ),
                     .pld_8g_eidleinfersel_real  ( pld_8g_eidleinfersel[3*idx_aib_per_sys+:3] ),
                     .pld_8g_empty_rmf_real  ( pld_8g_empty_rmf[idx_aib_per_sys] ),
                     .pld_8g_encdt_real  ( pld_8g_encdt[idx_aib_per_sys] ),
                     .pld_8g_full_rmf_real  ( pld_8g_full_rmf[idx_aib_per_sys] ),
                     .pld_8g_wa_boundary_real  ( pld_8g_wa_boundary[5*idx_aib_per_sys+:5] ),
                    // removed for PMA direct SR  .pld_pma_adapt_done_real  ( pld_pma_adapt_done[idx_aib_per_sys] ),
                     .pld_pma_adapt_start_real  ( pld_pma_adapt_start[idx_aib_per_sys] ),
                     .pld_pma_early_eios_real  ( pld_pma_early_eios[idx_aib_per_sys] ),
                     .pld_pma_eye_monitor_real  ( pld_pma_eye_monitor[6*idx_aib_per_sys+:6] ),
                    // removed for PMA direct SR   .pld_pma_pcie_sw_done_real  ( pld_pma_pcie_sw_done[2*idx_aib_per_sys+:2] ),
                     .pld_pma_pcie_switch_real  ( pld_pma_pcie_switch[2*idx_aib_per_sys+:2] ),
                     .pld_pma_ppm_lock_real  ( pld_pma_ppm_lock[idx_aib_per_sys] ),
                     .pld_pma_reserved_in_real  ( pld_pma_reserved_in[5*idx_aib_per_sys+:5] ),
                     .pld_pma_reserved_out_real  ( pld_pma_reserved_out[5*idx_aib_per_sys+:5] ),
                     .pld_pma_rs_lpbk_b_real  ( pld_pma_rs_lpbk_b[idx_aib_per_sys] ),
                    // removed for PMA direct SR .pld_pma_rx_detect_valid_real  ( pld_pma_rx_detect_valid[idx_aib_per_sys] ),
                     .pld_pma_rx_found_real  ( pld_pma_rx_found[idx_aib_per_sys] ),
                     .pld_pma_signal_ok_real  ( pld_pma_signal_ok[idx_aib_per_sys] ),
                     .pld_pmaif_rxclkslip_real  ( pld_pmaif_rxclkslip[idx_aib_per_sys] ),
                     .pld_polinv_rx_real  ( pld_polinv_rx[idx_aib_per_sys] ),
                     .pld_rx_hssi_fifo_empty_real  ( pld_rx_hssi_fifo_empty[idx_aib_per_sys] ),
                     .pld_rx_hssi_fifo_full_real  ( pld_rx_hssi_fifo_full[idx_aib_per_sys] ),
                     .pld_rx_prbs_done_real  ( pld_rx_prbs_done[idx_aib_per_sys] ),
                     .pld_rx_prbs_err_clr_real  ( pld_rx_prbs_err_clr[idx_aib_per_sys] ),
                     .pld_rx_prbs_err_real  ( pld_rx_prbs_err[idx_aib_per_sys] ),
                     .pld_syncsm_en_real  ( pld_syncsm_en[idx_aib_per_sys] ),
                // removed for PMA direct SSR     .pld_test_data_real  ( pld_test_data[20*idx_aib_per_sys+:20] ),

                     .pld_rx_fabric_data_out_real       (sync_data_from_aib[idx_aib_total*80+:80]),

                     .pld_pcs_rx_clk_out1_dcm_real      (    pld_pcs_rx_clk_out1_dcm[idx_aib_total] ), 
                     .pld_pcs_rx_clk_out1_hioint_real   ( pld_pcs_rx_clk_out1_hioint[idx_aib_total] ),
                     .pld_pcs_rx_clk_out2_dcm_real      (    pld_pcs_rx_clk_out2_dcm[idx_aib_total] ),
                     .pld_pcs_rx_clk_out2_hioint_real   ( pld_pcs_rx_clk_out2_hioint[idx_aib_total] ), 
                     .pld_rx_clk1_dcm_real              (            pld_rx_clk1_dcm[idx_aib_total] ),
                     .pld_rx_clk1_rowclk_real           (         pld_rx_clk1_rowclk[idx_aib_total] ),
                     .pld_rx_clk2_rowclk_real           (         pld_rx_clk2_rowclk[idx_aib_total] ),
                     
		     // Deterministic Latency ports
//		     .pld_sclk1_rowclk_real             ( pld_sclk1_rowclk[idx_aib_total] ),
//		     .pld_sclk2_rowclk_real             ( pld_sclk2_rowclk[idx_aib_total] ),
//                     .pld_pma_internal_clk1_hioint_real (pld_pma_internal_clk1_hioint[idx_aib_total]),
//                     .pld_pma_internal_clk2_hioint_real (pld_pma_internal_clk2_hioint[idx_aib_total]),
		      
                     .adapt_rx_data_link                (adapt_rx_data_link[idx_sys_cop][idx_aib_per_sys]),
                     .avmm1_link                        (avmm1_link[idx_sys_cop][idx_aib_per_sys])
                   );
	        end

		if (l_tx_enable) begin:tx_aib
		  bb_m_aib_tx
                   #(
                       .silicon_rev  (m_silicon_revision),
                       .sup_mode  ("USER_MODE")
                   )
                   x_bb_m_aib_tx
                   (
                                  .aib_tx_data_link(aib_tx_data_link[idx_sys_cop][idx_aib_per_sys]),
                                  .adapt_tx_data_link(adapt_tx_data_link[idx_sys_cop][idx_aib_per_sys]),
                                  .avmm1_link(avmm1_link[idx_sys_cop][idx_aib_per_sys])
                   );

                   bb_m_hdpldadapt_tx
                   #(
                       .silicon_rev  (m_silicon_revision),
                       .duplex_mode  (local_bb_m_hdpldadapt_tx_duplex_mode),
                       .fifo_mode  (bb_m_hdpldadapt_tx_fifo_mode),
                       .fifo_width  (bb_m_hdpldadapt_tx_fifo_width),
                       .hdpldadapt_pld_tx_clk1_dcm_hz  (bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz),
                       .hdpldadapt_pld_tx_clk1_rowclk_hz  (bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk1_rowclk_hz),
                       .hdpldadapt_pld_tx_clk2_dcm_hz  (bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk2_dcm_hz),
                       .hdpldadapt_pld_tx_clk2_rowclk_hz  (bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk2_rowclk_hz),
                       //.hdpldadapt_speed_grade  (bb_m_hdpldadapt_tx_hdpldadapt_speed_grade),
                       .pld_clk1_sel  (bb_m_hdpldadapt_tx_pld_clk1_sel),
                       .pld_clk2_sel  ("PLD_CLK2_DCM"),
                       .tx_datapath_tb_sel  (bb_m_hdpldadapt_tx_tx_datapath_tb_sel),
                       .txfifo_pempty  (bb_m_hdpldadapt_tx_txfifo_pempty),
                       .txfifo_pfull  (bb_m_hdpldadapt_tx_txfifo_pfull)
                   )
                   x_bb_m_hdpldadapt_tx
                   (
                     .hip_aib_fsr_in_real  ( hip_aib_fsr_in[4*idx_aib_per_sys+:4] ),
                     .hip_aib_fsr_out_real  ( hip_aib_fsr_out[4*idx_aib_per_sys+:4] ),
                     .hip_aib_ssr_in_real  ( hip_aib_ssr_in[40*idx_aib_per_sys+:40] ),
                     .hip_aib_ssr_out_real  ( hip_aib_ssr_out[8*idx_aib_per_sys+:8] ),
                     //.pld_10g_tx_bitslip_real  ( pld_10g_tx_bitslip[7*idx_aib_per_sys+:7] ),
                     .pld_8g_tx_boundary_sel_real  ( pld_8g_tx_boundary_sel[5*idx_aib_per_sys+:5] ),
                     .pld_krfec_tx_alignment_real  ( pld_krfec_tx_alignment[idx_aib_per_sys] ),
                     .pld_pma_csr_test_dis_real  ( pld_pma_csr_test_dis[idx_aib_per_sys] ),
                    // removed for PMA direct SR .pld_pma_fpll_clk0bad_real  ( pld_pma_fpll_clk0bad[idx_aib_per_sys] ),
                    // .pld_pma_fpll_clk1bad_real  ( pld_pma_fpll_clk1bad[idx_aib_per_sys] ),
                    // .pld_pma_fpll_clksel_real  ( pld_pma_fpll_clksel[idx_aib_per_sys] ),
                    //TODO remove UX signals from MAIBs .pld_pma_fpll_cnt_sel_real  ( pld_pma_fpll_cnt_sel[4*idx_aib_per_sys+:4] ),
                   //TODO remove UX signals from MAIBS  .pld_pma_fpll_extswitch_real  ( pld_pma_fpll_extswitch[idx_aib_per_sys] ),
                     .pld_pma_fpll_num_phase_shifts_real  ( pld_pma_fpll_num_phase_shifts[3*idx_aib_per_sys+:3] ),
                     .pld_pma_fpll_pfden_real  ( pld_pma_fpll_pfden[idx_aib_per_sys] ),
                    // removed for  PMA direct SR  .pld_pma_fpll_phase_done_real  ( pld_pma_fpll_phase_done[idx_aib_per_sys] ),
                     .pld_pma_fpll_up_dn_lc_lf_rstn_real  ( pld_pma_fpll_up_dn_lc_lf_rstn[idx_aib_per_sys] ),
                     .pld_pma_nrpi_freeze_real  ( pld_pma_nrpi_freeze[idx_aib_per_sys] ),
                     .pld_pma_tx_bitslip_real  ( pld_pma_tx_bitslip[idx_aib_per_sys] ),
                     .pld_pma_tx_qpi_pulldn_real  ( pld_pma_tx_qpi_pulldn[idx_aib_per_sys] ),
                     .pld_pma_tx_qpi_pullup_real  ( pld_pma_tx_qpi_pullup[idx_aib_per_sys] ),
                     .pld_pmaif_mask_tx_pll_real  ( pld_pmaif_mask_tx_pll[idx_aib_per_sys] ),
                     .pld_polinv_tx_real  ( pld_polinv_tx[idx_aib_per_sys] ),
                     .pld_tx_hssi_fifo_empty_real  ( pld_tx_hssi_fifo_empty[idx_aib_per_sys] ),
                     .pld_tx_hssi_fifo_full_real  ( pld_tx_hssi_fifo_full[idx_aib_per_sys] ),
                     .pld_txelecidle_real  ( pld_txelecidle[idx_aib_per_sys] ),

                     .pld_tx_fabric_data_in_real        (sync_data_to_aib[idx_aib_total*80+:80]),

                     .pld_pcs_tx_clk_out1_dcm_real      (    pld_pcs_tx_clk_out1_dcm[idx_aib_total] ), 
                     .pld_pcs_tx_clk_out1_hioint_real   ( pld_pcs_tx_clk_out1_hioint[idx_aib_total] ),
                     .pld_pcs_tx_clk_out2_dcm_real      (    pld_pcs_tx_clk_out2_dcm[idx_aib_total] ),
                     .pld_pcs_tx_clk_out2_hioint_real   ( pld_pcs_tx_clk_out2_hioint[idx_aib_total] ), 
                     .pld_tx_clk1_dcm_real              (            pld_tx_clk1_dcm[idx_aib_total] ),
                     .pld_tx_clk1_rowclk_real           (         pld_tx_clk1_rowclk[idx_aib_total] ),
                     .pld_tx_clk2_dcm_real              (            pld_tx_clk2_dcm[idx_aib_total] ),
                     .pld_tx_clk2_rowclk_real           (         pld_tx_clk2_rowclk[idx_aib_total] ),

		     // Deterministic Latency Ports
		    // .pld_10g_tx_bitslip_real           ({5'h0, pld_10g_tx_bitslip_tx[idx_aib_total], pld_10g_tx_bitslip_rx[idx_aib_total]}),

                 //### MAIB status signals: 
                     .pld_aib_hssi_tx_dll_lock_real     ( tx_dll_lock[idx_aib_total]       ),
                     
                     .pld_tx_fabric_fifo_empty_real     ( tx_fifo_empty[idx_aib_total]     ),
                     .pld_tx_fabric_fifo_full_real      ( tx_fifo_full[idx_aib_total]      ),
                     .pld_tx_fabric_fifo_pempty_real    ( tx_fifo_pempty[idx_aib_total]    ),
                     .pld_tx_fabric_fifo_pfull_real     ( tx_fifo_pfull[idx_aib_total]     ),
                     
                 //### Ftile AIB status sidx_aib_totalnals: 
                 //  .pld_tx_hssi_fifo_empty_real       ( tx_pcs_fifo_empty[idx_aib_total] ),
                 //  .pld_tx_hssi_fifo_full_real        ( tx_pcs_fifo_full[idx_aib_total]  ),


                 //### Link ports connectivity:
                     .adapt_tx_data_link                (adapt_tx_data_link[idx_sys_cop][idx_aib_per_sys]),
                     .avmm1_link                        (avmm1_link[idx_sys_cop][idx_aib_per_sys])
                   );
	         end

               end
            
	    //link indexing for transceiver is in down below

              if (bb_f_ehip_xcvr_type!="XCVR_TYPE_UX") begin:fht
                //place is reserved for barak
		      
                  if (idx_xcvr_per_sys == 0) begin : mifgen_fht_primary_connection
                       assign mif_generation_link_fht[idx_sys_cop] = mif_generation_link_primary_fht[idx_xcvr_total];
                  end : mifgen_fht_primary_connection
                  else begin : mifgen_fht_secondary_connection
                       assign mif_generation_link_secondary_fht[idx_xcvr_total] = mif_generation_link_fht[idx_sys_cop];
                  end : mifgen_fht_secondary_connection
		     
                  bb_f_bk
                  #(
                  //ww46 snap workaround
                            .bk_pll_fullrate ("true"),

                  .bk_seq0_enable("SEQ0_EN"),
                  .bk_seq1_enable("SEQ1_EN"),
                  .bk_seq2_enable("SEQ2_EN"),
                  .bk_seq3_enable("SEQ3_EN"),
                  .bk_seq4_enable("SEQ4_EN"),
                  .bk_seq5_enable("SEQ5_EN"),
                  .bk_seq6_enable("SEQ6_EN"),
                  .bk_seq7_enable("SEQ7_EN"),
                  .bk_seq8_enable("SEQ8_EN"),
                  .bk_seq9_enable("SEQ9_EN"),
                  .bk_seq10_enable("SEQ10_EN"),

                  .bk_seq42_enable("SEQ42_EN"),
                  .bk_seq43_enable("SEQ43_EN"),
                  .bk_seq44_enable("SEQ44_EN"),
                  .bk_seq45_enable("SEQ45_EN"),
                  .bk_seq46_enable("SEQ46_EN"),
                  //end of ww46 snap workaround


                  //ww5 snap workaround
                  /*21.4.1 snap removal
                  .bk_seq15_enable("SEQ15_DIS"),
                  .bk_seq16_enable("SEQ16_DIS"),
                  .bk_seq17_enable("SEQ17_DIS"),
                  .bk_seq18_enable("SEQ18_DIS"),
                  .bk_seq19_enable("SEQ19_DIS"),
                  .bk_seq20_enable("SEQ20_DIS"),
                  .bk_seq21_enable("SEQ21_DIS"),
                  .bk_seq22_enable("SEQ22_DIS"),
                  .bk_seq23_enable("SEQ23_DIS"),
                  .bk_seq24_enable("SEQ24_DIS"),
                  .bk_seq25_enable("SEQ25_DIS"),
                  .bk_seq26_enable("SEQ26_DIS"),
                  .bk_seq27_enable("SEQ27_DIS"),
                  .bk_seq28_enable("SEQ28_DIS"),
                  .bk_seq29_enable("SEQ29_DIS"),
                  .bk_seq30_enable("SEQ30_DIS"),
                  */
                  //end of ww5 snap workaround
                   //pfe_ipse_attribute setting
                     .bk_bitprog_update_cfg  ("BK_BITPROG_NOUPDATE_CFG"),
                     .bti_protected          ("__BB_DONT_CARE__"),

                     .rx_precode_en                      (bb_f_bk_rx_precode_en),
                     .tx_precode_en                      (bb_f_bk_tx_precode_en),
                     .pll_n_counter                      (bb_f_bk_pll_n_counter),

                     .silicon_rev                        (silicon_revision),
                     .sup_mode                           (bb_f_bk_sup_mode),                           
		     .package_type                       (bb_f_bk_package_type),
                     .speed_grade                        (bb_f_bk_speed_grade),

                     .tx_bond_size                       (bb_f_bk_tx_bond_size),                     
                     .tx_line_rate                       (bb_f_bk_tx_line_rate),                     
                     .tx_protocol                        (bb_f_bk_tx_protocol),                     
                     .txrx_line_encoding_type            (bb_f_bk_txrx_line_encoding_type),       
		     .fec_used                           ((fec_on)? "TRUE" : "FALSE"),   
                                                                                                      
		     .txout_tristate_en                  (bb_f_bk_txout_tristate_en),
		     .tx_invert_p_and_n                  (bb_f_bk_tx_invert_p_and_n),

                     .refclk_source_lane_pll             (bb_f_bk_refclk_source_lane_pll),           
                     .pll_pcs3334_ratio                  (bb_f_bk_pll_pcs3334_ratio),                
                     .pll_rx_pcs3334_ratio               (bb_f_bk_pll_rx_pcs3334_ratio),                
                     .rx_user_clk1_en                    (bb_f_bk_rx_user_clk1_en ),        
                     .rx_user_clk2_en                    (bb_f_bk_rx_user_clk2_en ),        
                     .tx_user_clk1_en                    (bb_f_bk_tx_user_clk1_en ),        
                     .tx_user_clk2_en                    (bb_f_bk_tx_user_clk2_en ),        
                     .rx_user_clk1_sel                   (bb_f_bk_rx_user_clk1_sel),        
                     .rx_user_clk2_sel                   (bb_f_bk_rx_user_clk2_sel),        
                     .tx_user_clk1_sel                   (bb_f_bk_tx_user_clk1_sel),        
                     .tx_user_clk2_sel                   (bb_f_bk_tx_user_clk2_sel),        
                                                           
                     .an_mode                            (bb_f_bk_an_mode),                          
                     .bk_dl_enable                       (bb_f_bk_bk_dl_enable),                     
                     .loopback_mode                      (bb_f_bk_loopback_mode),                    
                     .bti_protected                      (bb_f_bk_bti_protected),

                     .bk_sel_tx_user_data                ("TX_USRDATA_DIS"), 
		     .rx_prbs_common_en                  ("RX_PRBS_COMMON_EN_DISABLE"),
		     .tx_prbs_en                         ("TX_PRBS_EN_DISABLE"),
		     .bk_car_tx_clk_src_sel              ("BK_CAR_TX_CLK_SRC_SEL_DISABLE"),

                     .pam4_rxgrey_code                   (bb_f_bk_pam4_rxgrey_code),                
		     .rx_invert_p_and_n                  (bb_f_bk_rx_invert_p_and_n),
                     .bk_en_rxdat_profile                (bb_f_bk_bk_en_rxdat_profile),              
                                                                                                      
                     .bk_lnx_txovf_rxbdstb_inten         (bb_f_bk_bk_lnx_txovf_rxbdstb_inten),       
                     .bk_lnx_txudf_pldrstb_inten         (bb_f_bk_bk_lnx_txudf_pldrstb_inten),     
                     .bk_tx_lnx_ovf_inten_dirsignal      (bb_f_bk_bk_tx_lnx_ovf_inten_dirsignal),    
                     .bk_tx_lnx_rxbadst_inten_dirsignal  (bb_f_bk_bk_tx_lnx_rxbadst_inten_dirsignal),
                     .bk_tx_lnx_udf_inten_dirsignal      (bb_f_bk_bk_tx_lnx_udf_inten_dirsignal),    
                                                          
                     .bk_rx_lat_bit_for_async            (bb_f_bk_bk_rx_lat_bit_for_async),
                     .bk_rxbit_cntr_pma                  (bb_f_bk_bk_rxbit_cntr_pma),                
                     .bk_rxbit_rollover                  (bb_f_bk_bk_rxbit_rollover)

                   )
                  x_bb_f_bk
                   (
                    .pll_link  (  tx_pll_refclk_link[idx_xcvr_total]),
                     // TBD:EH
		    .i_rx_async_pulse_sel_real(),
                    .i_tx_async_pulse_sel_real(),
                    .i_txfifo_rd_side_master_pcs_lock_indication_real(),
                    .i_txfifo_rd_side_master_rx_lane_enable_real(),
                    .i_txfifo_rd_side_master_tx_lane_enable_real(),


                    .i_gdr_xcvr_data_rx_tx__b_rx_p_in_srds_pad_lv_lane_real( rx_serial_data[idx_xcvr_total]),
                    .i_gdr_xcvr_data_rx_tx__b_rx_n_in_srds_pad_lv_lane_real( rx_serial_data_n[idx_xcvr_total]),
                    .o_gdr_xcvr_data_rx_tx__b_tx_out_p_srds_pad_lv_lane_real(tx_serial_data[idx_xcvr_total]),
                    .o_gdr_xcvr_data_rx_tx__b_tx_out_n_srds_pad_lv_lane_real(tx_serial_data_n[idx_xcvr_total]),

		    //  latency pulse
                    .o_xcvrrc_clkrst_latency_pulse_real(fht_latency_pulse[idx_xcvr_total]),

		    // brk direct ctrl/st signals
 // TODO: resume this after removing the maib_pma ssr                    .ibrk_ingress_direct_real(fht_ingress_direct[idx_xcvr_total*8+:8]),
                    .obrk_rx_direct_real(fht_rx_direct[idx_xcvr_total*8+:8]),
                    .obrk_rxsrds_rdy_real(fht_rxsrds_rdy[idx_xcvr_total]),

                    // link/virtual
                    .xcvr_data0_link(xcvr_tx_data_link[idx_m_data0link][idx_n_data0link]),
                    .xcvr_data1_link(xcvr_tx_data_link[idx_m_data1link][idx_n_data1link]),
                    .xcvr_data2_link(xcvr_tx_data_link[idx_m_data23link][idx_n_data2link]),
                    .xcvr_data3_link(xcvr_tx_data_link[idx_m_data23link][idx_n_data3link]),

		    .next_bonding_link(bk_bonding_link[idx_sys_cop][idx_xcvr_per_sys+1]),
                    .prev_bonding_link(bk_bonding_link[idx_sys_cop][idx_xcvr_per_sys]),
                     .avmm2_link(avmm2_link[idx_sys_cop][idx_xcvr_per_sys]),
 
                     .src_rx_master_virtual(mif_generation_link_primary_fht[idx_xcvr_total]),
                     .src_rx_slave_virtual (mif_generation_link_secondary_fht[idx_xcvr_total]),
		     .placement_virtual (placement_virtual_fht_xcvr[idx_xcvr_total])
                   );
              end else begin:fgt
                if (1) begin //there needs to be a condition to check for UX1.0 vs UX2.0

                    //### FGT PLL Cascades:
                      localparam l_bb_f_ux_tx_pll                           = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_tx_pll                          : bb_f_ux_tx_pll                          ;
                      localparam l_bb_f_ux_tx_pll_bw_sel                    = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_tx_pll_bw_sel                   : bb_f_ux_tx_pll_bw_sel                   ;
                  
                      localparam l_bb_f_ux_synth_lc_fast_f_out_hz           = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_fast_f_out_hz          : bb_f_ux_synth_lc_fast_f_out_hz          ;
                      localparam l_bb_f_ux_synth_lc_fast_f_vco_hz           = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_fast_f_vco_hz          : bb_f_ux_synth_lc_fast_f_vco_hz          ;
                      localparam l_bb_f_ux_synth_lc_fast_f_ref_hz           = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_fast_f_ref_hz          : bb_f_ux_synth_lc_fast_f_ref_hz          ;
                      localparam l_bb_f_ux_synth_lc_fast_fractional_en      = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_fast_fractional_en     : bb_f_ux_synth_lc_fast_fractional_en     ;
                      localparam l_bb_f_ux_synth_lc_fast_k_counter          = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_fast_k_counter         : bb_f_ux_synth_lc_fast_k_counter         ;
                      localparam l_bb_f_ux_synth_lc_fast_l_counter          = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_fast_l_counter         : bb_f_ux_synth_lc_fast_l_counter         ;
                      localparam l_bb_f_ux_synth_lc_fast_m_counter          = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_fast_m_counter         : bb_f_ux_synth_lc_fast_m_counter         ;
                      localparam l_bb_f_ux_synth_lc_fast_n_counter          = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_fast_n_counter         : bb_f_ux_synth_lc_fast_n_counter         ;
                      localparam l_bb_f_ux_synth_lc_fast_primary_use        = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_fast_primary_use       : bb_f_ux_synth_lc_fast_primary_use       ;
                  
                      localparam l_bb_f_ux_synth_lc_med_f_out_hz            = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_med_f_out_hz           : bb_f_ux_synth_lc_med_f_out_hz           ;
                      localparam l_bb_f_ux_synth_lc_med_f_vco_hz            = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_med_f_vco_hz           : bb_f_ux_synth_lc_med_f_vco_hz           ;
                      localparam l_bb_f_ux_synth_lc_med_f_ref_hz            = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_med_f_ref_hz           : bb_f_ux_synth_lc_med_f_ref_hz           ;
                      localparam l_bb_f_ux_synth_lc_med_fractional_en       = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_med_fractional_en      : bb_f_ux_synth_lc_med_fractional_en      ;
                      localparam l_bb_f_ux_synth_lc_med_k_counter           = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_med_k_counter          : bb_f_ux_synth_lc_med_k_counter          ;
                      localparam l_bb_f_ux_synth_lc_med_l_counter           = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_med_l_counter          : bb_f_ux_synth_lc_med_l_counter          ;
                      localparam l_bb_f_ux_synth_lc_med_m_counter           = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_med_m_counter          : bb_f_ux_synth_lc_med_m_counter          ;
                      localparam l_bb_f_ux_synth_lc_med_n_counter           = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_med_n_counter          : bb_f_ux_synth_lc_med_n_counter          ;
                      localparam l_bb_f_ux_synth_lc_med_primary_use         = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_med_primary_use        : bb_f_ux_synth_lc_med_primary_use        ;
                  
                      localparam l_bb_f_ux_synth_lc_slow_f_out_hz           = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_slow_f_out_hz          : bb_f_ux_synth_lc_slow_f_out_hz          ;
                      localparam l_bb_f_ux_synth_lc_slow_f_vco_hz           = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_slow_f_vco_hz          : bb_f_ux_synth_lc_slow_f_vco_hz          ;
                      localparam l_bb_f_ux_synth_lc_slow_f_ref_hz           = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_slow_f_ref_hz          : bb_f_ux_synth_lc_slow_f_ref_hz          ;
                      localparam l_bb_f_ux_synth_lc_slow_fractional_en      = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_slow_fractional_en     : bb_f_ux_synth_lc_slow_fractional_en     ;
                      localparam l_bb_f_ux_synth_lc_slow_k_counter          = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_slow_k_counter         : bb_f_ux_synth_lc_slow_k_counter         ;
                      localparam l_bb_f_ux_synth_lc_slow_l_counter          = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_slow_l_counter         : bb_f_ux_synth_lc_slow_l_counter         ;
                      localparam l_bb_f_ux_synth_lc_slow_m_counter          = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_slow_m_counter         : bb_f_ux_synth_lc_slow_m_counter         ;
                      localparam l_bb_f_ux_synth_lc_slow_n_counter          = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_slow_n_counter         : bb_f_ux_synth_lc_slow_n_counter         ;
                      localparam l_bb_f_ux_synth_lc_slow_primary_use        = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_synth_lc_slow_primary_use       : bb_f_ux_synth_lc_slow_primary_use       ;
					  localparam l_bb_f_ux_tx_fb_div_emb_mult_counter       = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? targettype_bb_f_ux_tx_fb_div_emb_mult_counter      : bb_f_ux_tx_fb_div_emb_mult_counter       ;

                      localparam l_bb_f_ux_synth_lc_fast_rx_postdiv_counter = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? "__BB_DONT_CARE__" :
                                                                                          (bb_f_ux_synth_lc_fast_rx_postdiv_counter!=0) ? bb_f_ux_synth_lc_fast_rx_postdiv_counter : "__BB_DONT_CARE__";
                      localparam l_bb_f_ux_synth_lc_med_rx_postdiv_counter  = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? "__BB_DONT_CARE__" :
                                                                                          (bb_f_ux_synth_lc_med_rx_postdiv_counter !=0) ? bb_f_ux_synth_lc_med_rx_postdiv_counter  : "__BB_DONT_CARE__";
                      localparam l_bb_f_ux_synth_lc_slow_rx_postdiv_counter = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? "__BB_DONT_CARE__" :
                                                                                          (bb_f_ux_synth_lc_slow_rx_postdiv_counter!=0) ? bb_f_ux_synth_lc_slow_rx_postdiv_counter : "__BB_DONT_CARE__";


                      localparam l_bb_f_ux_synth_lc_fast_f_rx_postdiv_hz    = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? 0 : bb_f_ux_synth_lc_fast_f_rx_postdiv_hz;
                      localparam l_bb_f_ux_synth_lc_med_f_rx_postdiv_hz     = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? 0 : bb_f_ux_synth_lc_med_f_rx_postdiv_hz;
                      localparam l_bb_f_ux_synth_lc_slow_f_rx_postdiv_hz    = ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? 0 : bb_f_ux_synth_lc_slow_f_rx_postdiv_hz;
		      
                  if (l_rx_enable) begin:rx_ux
		     if (idx_xcvr_per_sys == 0) begin : make_primary_connection
			assign mif_generation_link_rx[idx_sys_cop] = mif_generation_link_primary_rx[idx_xcvr_total];
		     end : make_primary_connection
		     else begin : make_secondary_connection
			assign mif_generation_link_secondary_rx[idx_xcvr_total] = mif_generation_link_rx[idx_sys_cop];
		     end : make_secondary_connection
		     
                     // CDR Clockout

                     localparam l_bb_f_ux_cdr_clkdiv_en = (   ((enable_port_fgt_rx_cdr_divclk_link0) && (fgt_rx_cdr_divclk_link0_sel==idx_xcvr_total)) ||
                                                              ((enable_port_fgt_rx_cdr_divclk_link1) && (fgt_rx_cdr_divclk_link1_sel==idx_xcvr_total))     ) ? "ENABLE" : "DISABLE";

	            bb_f_ux_rx
                  #(
                     .silicon_rev    (silicon_revision),
                            .synth_lc_fb_div_n_frac_mode (1),
                             .vsr_mode                          ("__BB_DONT_CARE__"),
                            .rx_protocol_hard_pcie_lowloss    (local_protocol_hard_pcie_lowloss),
             //        .enable_port_control_of_cdr_ltr_ltd ("disable"),
                 //### FGT XCVR RX PLL attributes:  controlled by computation code.
                     .cdr_bw_sel     (local_bb_f_ux_cdr_bw_sel),
                     .cdr_f_out_hz   (local_bb_f_ux_cdr_f_out_hz),
                     .cdr_f_vco_hz   (local_bb_f_ux_cdr_f_vco_hz),
                     .cdr_f_ref_hz   (local_bb_f_ux_cdr_f_ref_hz),
                     .cdr_l_counter  (local_bb_f_ux_cdr_l_counter),
                     .cdr_m_counter  (local_bb_f_ux_cdr_m_counter),
                     .cdr_n_counter  (local_bb_f_ux_cdr_n_counter),
                    
                        //### PFE_IPSE_SYNC up changes
                     .dpma_refclk_source                ("__BB_DONT_CARE__"),
		     .external_dpma_f_ref_hz            ("__BB_DONT_CARE__"),
                     .master_pll_pair_mode              ("__BB_DONT_CARE__"),
                     .ux_q_10_to_1_ckmux_0_en_attr      ("__BB_DONT_CARE__"),
                     .ux_q_10_to_1_ckmux_1_en_attr      ("__BB_DONT_CARE__"),    
                     .dynamic_pcie_speed_choice         ("DYNAMIC_PCIE_SPEED_CHOICE_DISABLED"),
		     .full_quad_master_pll_mode         ("__BB_DONT_CARE__"),
		     .primary_use                       ("PRIMARY_USE_DISABLED"),
		     .quad_pcie_mode                    ("FALSE"),
                     
                 //### FGT XCVR RX PLL attributes: User-clk related
                     .cdr_clkdiv_en              (l_bb_f_ux_cdr_clkdiv_en),
                     .cdr_postdiv_counter        (bb_f_ux_cdr_postdiv_counter),
                     .cdr_postdiv_fractional_en  (bb_f_ux_cdr_postdiv_fractional_en),

                     .cdr_ppm_driftcount  (local_bb_f_ux_cdr_ppm_driftcount),
                     .core_pll  (bb_f_ux_core_pll),
                     .dl_enable  (local_bb_f_ux_dl_enable),
                     .enable_static_refclk_network  (local_bb_f_ux_enable_static_refclk_network),
                     .engineered_link_mode  (bb_f_ux_engineered_link_mode),
                     .rx_tuning_hint  (bb_f_ux_rx_tuning_hint),
                     .force_cdr_ltd  (bb_f_ux_force_cdr_ltd),
                     .force_cdr_ltr  (bb_f_ux_force_cdr_ltr),
                     .enable_port_control_of_cdr_ltr_ltd (bb_f_ux_enable_port_control_of_cdr_ltr_ltd),
                     .force_refclk_power_to_specific_value  (local_bb_f_ux_force_refclk_power_to_specific_value),
                     .flux_mode(bb_f_ux_flux_mode),
                     .loopback_mode  (bb_f_ux_loopback_mode),
                     .master_sup_mode  ("MASTER_SUP_MODE_USER_MODE"),
                     .prbs_mon_en  (bb_f_ux_prbs_mon_en),
                     .prbs_pattern  (bb_f_ux_prbs_pattern),
                     //.q_dl_cfg_rx_lat_bit_for_async_attr  (local_bb_f_ux_q_dl_cfg_rx_lat_bit_for_async_attr),
                     .q_dl_cfg_rxbit_cntr_pma_attr  (local_bb_f_ux_q_dl_cfg_rxbit_cntr_pma_attr),
                     .q_dl_cfg_rxbit_rollover_attr  (local_bb_f_ux_q_dl_cfg_rxbit_rollover_attr),
                     .rx_bond_size  (local_bb_f_ux_rx_bond_size),
                     //### added RX polarity attribute
                     .rx_invert_p_and_n("DISABLE"),
                     .fw_clearing_regsiter_attr("ENABLE"),
                   //.rx_over_sample  (local_bb_f_ux_rx_over_sample), creates issues with simplex pma4style, why?
                     .rx_pam4_graycode_en  (bb_f_ux_rx_pam4_graycode_en),
                     .rx_pam4_precode_en  (bb_f_ux_rx_pam4_precode_en),
                     .rx_protocol  (bb_f_ux_rx_protocol),
                     .rx_user_clk_en  (bb_f_ux_rx_user_clk_en),
                     .rx_width  (bb_f_ux_rx_width),
                     .squelch_detect  (bb_f_ux_squelch_detect),
                     .sup_mode  ("SUP_MODE_USER_MODE"),
                     .sr_custom ("DISABLE"), //leaving all other relevant attributes (sv_*, ur_en_*, ur_ov_*) at don't care, this override feature is debug/advanced mode only

                 //### FGT XCVR Datarate: RBC-related to computation code.
                     .rx_line_rate_bps  (bin_bb_f_ux_rx_line_rate_bps),

                     .txrx_channel_operation  (bb_f_ux_txrx_channel_operation),
                     .txrx_line_encoding_type  (bb_f_ux_txrx_line_encoding_type),
                     .txrx_xcvr_speed_bucket  (bb_f_ux_txrx_xcvr_speed_bucket),
// ww 46 snap		    
		     .sim_mode (local_bb_f_ux_sim_mode),
		     .rx_adapt_mode(bb_f_ux_rx_adapt_mode)
//snap44                     .ux_q_ckmux_cpu_attr  (local_bb_f_ux_ux_q_ckmux_cpu_attr),
//snap46                     .ux_q_e_rx_dp_pipe_attr  (local_bb_f_ux_ux_q_e_rx_dp_pipe_attr)
                  )
                  x_bb_f_ux_rx
                  (
                    .duplex_bond_link(duplex_bond_ux_rx[idx_xcvr_total]),
                    .rx_cdr_divclk_link  (  cdrdiv_clkout[idx_xcvr_total]),
                     .rx_cdr_refclk_link  ( (fgt_tx_pll_cascade_enable==1)   ? lc_cascade_out_link[num_xcvr_per_sys*idx_sys_cop] : ( fgt_tx_pll_frac_mode_enable == 1) ? 0 : rx_cdr_refclk_link[idx_xcvr_total]    ),
 
                    .i_gdr_xcvr_data_rx_tx__b_rx_p_in_srds_pad_lv_lane_real( rx_serial_data[idx_xcvr_total]),
                    .i_gdr_xcvr_data_rx_tx__b_rx_n_in_srds_pad_lv_lane_real( rx_serial_data_n[idx_xcvr_total]),
                 
                    .oct_pcs_rxsignaldetect_lx_a_real(oct_pcs_rxsignaldetect_lx_a[idx_xcvr_total]),
                    .octl_pcs_rxsignaldetect_lfps_lx_a_real(octl_pcs_rxsignaldetect_lfps_lx_a[idx_xcvr_total]),
                    .oct_pcs_rxcdrlock2data_lx_a_real(oct_pcs_rxcdrlock2data_lx_a[idx_xcvr_total]),          
                    .oct_pcs_rxcdrlockstatus_lx_a_real(oct_pcs_rxcdrlockstatus_lx_a[idx_xcvr_total]),    
                    .ictl_pcs_rxovrcdrlock2dataen_lx_a_real(ictl_pcs_rxovrcdrlock2dataen_lx_a[idx_xcvr_total]),
                    .ictl_pcs_rxovrcdrlock2data_lx_a_real(ictl_pcs_rxovrcdrlock2data_lx_a[idx_xcvr_total]),
                    .octl_pcs_rxstatus_lx_a_real(octl_pcs_rxstatus_lx_a[idx_xcvr_total]),
                    .flux_top__iflux_ingress_direct__231_real(flux_top__iflux_ingress_direct__231[idx_xcvr_total]),
		    .ictl_pcs_rxeiosdetectstat_lx_a_real(ictl_pcs_rxeiosdetectstat_lx_a[idx_xcvr_total]),
			.i_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t_ssr_real(i_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t[idx_xcvr_total]),
       
                    .xcvr_data0_link(xcvr_rx_data_link[idx_m_data0link_rx][idx_n_data0link_rx]),
                    .xcvr_data1_link(xcvr_rx_data_link[idx_m_data1link_rx][idx_n_data1link_rx]),
                   // .next_bonding_link(ux_bonding_link_rx[idx_sys_cop][idx_xcvr_per_sys+1]),
                   // .prev_bonding_link(ux_bonding_link_rx[idx_sys_cop][idx_xcvr_per_sys]),
                    .avmm2_link(avmm2_link[idx_sys_cop][idx_xcvr_per_sys]),

		    // Deterministic Latency ports
		    .i_det_lat_sclk_real(dl_sclk[idx_xcvr_total]),
		    .rx_lane0_async_sync_dl_path_real(rx_dl_measure_sel[idx_xcvr_total]),
		    .o_rx_sclk_return_real(rx_dl_async_pulse[idx_xcvr_total]),

                    .placement_virtual(placement_virtual_rx_xcvr[idx_xcvr_total]),
                    .src_rx_master_virtual(mif_generation_link_primary_rx[idx_xcvr_total]),
                    .src_rx_slave_virtual(mif_generation_link_secondary_rx[idx_xcvr_total])
                  );
                  end

		if (l_tx_enable) begin:tx_ux

		     if (idx_xcvr_per_sys == 0) begin : make_primary_connection
			assign mif_generation_link_tx[idx_sys_cop] = mif_generation_link_primary_tx[idx_xcvr_total];
		     end : make_primary_connection
		     else begin : make_secondary_connection
			assign mif_generation_link_secondary_tx[idx_xcvr_total] = mif_generation_link_tx[idx_sys_cop];
		     end : make_secondary_connection
 
		   bb_f_ux_tx
                  #(
                     .silicon_rev    (silicon_revision),
                           .synth_lc_fb_div_n_frac_mode (1),
			    .synth_lc_fb_div_emb_mult_counter (l_bb_f_ux_tx_fb_div_emb_mult_counter),
                            .tx_protocol_hard_pcie_lowloss   (local_protocol_hard_pcie_lowloss),
                     .core_pll  (bb_f_ux_core_pll),
                     .dl_enable  (local_bb_f_ux_dl_enable),
                     .enable_static_refclk_network  (local_bb_f_ux_enable_static_refclk_network),
                     .engineered_link_mode  (bb_f_ux_engineered_link_mode),
                     .tx_tuning_hint  (bb_f_ux_tx_tuning_hint),
					 .tx_spread_spectrum_en (bb_f_ux_tx_spread_spectrum_en),
                     .force_refclk_power_to_specific_value  (local_bb_f_ux_force_refclk_power_to_specific_value),
                     //.flux_mode(bb_f_ux_flux_mode),
                     .loopback_mode  (bb_f_ux_loopback_mode),
                     .master_sup_mode  ("MASTER_SUP_MODE_USER_MODE"),
                     .prbs_gen_en  (bb_f_ux_prbs_gen_en),
                     .prbs_pattern  (bb_f_ux_prbs_pattern),
                     //.q_dl_cfg_rx_lat_bit_for_async_attr  (local_bb_f_ux_q_dl_cfg_rx_lat_bit_for_async_attr),
                     .q_dl_cfg_rxbit_cntr_pma_attr  (local_bb_f_ux_q_dl_cfg_rxbit_cntr_pma_attr),
                     .q_dl_cfg_rxbit_rollover_attr  (local_bb_f_ux_q_dl_cfg_rxbit_rollover_attr),
                     .sup_mode  ("SUP_MODE_USER_MODE"),
                     .sr_custom ("DISABLE"), //leaving all other relevant attributes (sv_*, ur_en_*, ur_ov_*) at don't care, this override feature is debug/advanced mode only

                      //### PFE_IPSE_SYNC up changes
                     .dpma_refclk_source              ("__BB_DONT_CARE__"),
		     .external_dpma_f_ref_hz          ("__BB_DONT_CARE__"),
                     .master_pll_pair_mode            ("__BB_DONT_CARE__"),
                     .ux_q_10_to_1_ckmux_0_en_attr    ("__BB_DONT_CARE__"),
                     .ux_q_10_to_1_ckmux_1_en_attr    ("__BB_DONT_CARE__"),    
                     .dynamic_pcie_speed_choice       ("DYNAMIC_PCIE_SPEED_CHOICE_DISABLED"),
		     .full_quad_master_pll_mode       ("__BB_DONT_CARE__"),
		     .primary_use                     ("PRIMARY_USE_DISABLED"),
		     .quad_pcie_mode                  ("FALSE"),
                     
			 
                    


                 //### FGT XCVR Datarate: RBC-related to computation code.
                     .tx_line_rate_bps  ( (bb_f_ux_core_pll=="CORE_PLL_DISABLED") ? bin_bb_f_ux_tx_line_rate_bps : 0),

                 //### FGT XCVR TX PLL attributes:  controlled by computation code.
                     .tx_pll         (l_bb_f_ux_tx_pll),
                     .tx_pll_bw_sel  (l_bb_f_ux_tx_pll_bw_sel),

                     .synth_lc_fast_f_out_hz       (str_2_bin_alt_xcvr_native_gdr(l_bb_f_ux_synth_lc_fast_f_out_hz) ),
                     .synth_lc_fast_f_vco_hz       (str_2_bin_alt_xcvr_native_gdr(l_bb_f_ux_synth_lc_fast_f_vco_hz) ),
                     .synth_lc_fast_f_ref_hz       (l_bb_f_ux_synth_lc_fast_f_ref_hz),
                     .synth_lc_fast_fractional_en  (l_bb_f_ux_synth_lc_fast_fractional_en),
                     .synth_lc_fast_k_counter      (l_bb_f_ux_synth_lc_fast_k_counter),
                     .synth_lc_fast_l_counter      (l_bb_f_ux_synth_lc_fast_l_counter),
                     .synth_lc_fast_m_counter      (l_bb_f_ux_synth_lc_fast_m_counter),
                     .synth_lc_fast_n_counter      (l_bb_f_ux_synth_lc_fast_n_counter),
                     .synth_lc_fast_primary_use    (l_bb_f_ux_synth_lc_fast_primary_use),

                     .synth_lc_med_f_out_hz        (str_2_bin_alt_xcvr_native_gdr(l_bb_f_ux_synth_lc_med_f_out_hz) ),
                     .synth_lc_med_f_vco_hz        (str_2_bin_alt_xcvr_native_gdr(l_bb_f_ux_synth_lc_med_f_vco_hz) ),
                     .synth_lc_med_f_ref_hz        (l_bb_f_ux_synth_lc_med_f_ref_hz),
                     .synth_lc_med_fractional_en   (l_bb_f_ux_synth_lc_med_fractional_en),
                     .synth_lc_med_k_counter       (l_bb_f_ux_synth_lc_med_k_counter),
                     .synth_lc_med_l_counter       (l_bb_f_ux_synth_lc_med_l_counter),
                     .synth_lc_med_m_counter       (l_bb_f_ux_synth_lc_med_m_counter),
                     .synth_lc_med_n_counter       (l_bb_f_ux_synth_lc_med_n_counter),
                     .synth_lc_med_primary_use     (l_bb_f_ux_synth_lc_med_primary_use),

                     .synth_lc_slow_f_out_hz       (str_2_bin_alt_xcvr_native_gdr(l_bb_f_ux_synth_lc_slow_f_out_hz) ),
                     .synth_lc_slow_f_vco_hz       (str_2_bin_alt_xcvr_native_gdr(l_bb_f_ux_synth_lc_slow_f_vco_hz) ),
                     .synth_lc_slow_f_ref_hz       (l_bb_f_ux_synth_lc_slow_f_ref_hz),
                     .synth_lc_slow_fractional_en  (l_bb_f_ux_synth_lc_slow_fractional_en),
                     .synth_lc_slow_k_counter      (l_bb_f_ux_synth_lc_slow_k_counter),
                     .synth_lc_slow_l_counter      (l_bb_f_ux_synth_lc_slow_l_counter),
                     .synth_lc_slow_m_counter      (l_bb_f_ux_synth_lc_slow_m_counter),
                     .synth_lc_slow_n_counter      (l_bb_f_ux_synth_lc_slow_n_counter),
                     .synth_lc_slow_primary_use    (l_bb_f_ux_synth_lc_slow_primary_use),

                     .synth_lc_fast_f_rx_postdiv_hz           (l_bb_f_ux_synth_lc_fast_f_rx_postdiv_hz),
                     .synth_lc_med_f_rx_postdiv_hz            (l_bb_f_ux_synth_lc_med_f_rx_postdiv_hz),
                     .synth_lc_slow_f_rx_postdiv_hz           (l_bb_f_ux_synth_lc_slow_f_rx_postdiv_hz),

                     .synth_lc_fast_rx_postdiv_counter        (l_bb_f_ux_synth_lc_fast_rx_postdiv_counter),
                     .synth_lc_med_rx_postdiv_counter         (l_bb_f_ux_synth_lc_med_rx_postdiv_counter),
                     .synth_lc_slow_rx_postdiv_counter        (l_bb_f_ux_synth_lc_slow_rx_postdiv_counter),


                 //### FGT XCVR TX PLL attributes: User-clk related
                     .synth_lc_fast_f_tx_postdiv_hz           (bb_f_ux_synth_lc_fast_f_tx_postdiv_hz),
                     .synth_lc_fast_tx_postdiv_counter        (bb_f_ux_synth_lc_fast_tx_postdiv_counter),
                     .synth_lc_fast_tx_postdiv_fractional_en  (bb_f_ux_synth_lc_fast_tx_postdiv_fractional_en),

                     .synth_lc_med_f_tx_postdiv_hz            (bb_f_ux_synth_lc_med_f_tx_postdiv_hz),
                     .synth_lc_med_tx_postdiv_counter         (bb_f_ux_synth_lc_med_tx_postdiv_counter),
                     .synth_lc_med_tx_postdiv_fractional_en   (bb_f_ux_synth_lc_med_tx_postdiv_fractional_en),

                     .synth_lc_slow_f_tx_postdiv_hz           (bb_f_ux_synth_lc_slow_f_tx_postdiv_hz),
                     .synth_lc_slow_tx_postdiv_counter        (bb_f_ux_synth_lc_slow_tx_postdiv_counter),
                     .synth_lc_slow_tx_postdiv_fractional_en  (bb_f_ux_synth_lc_slow_tx_postdiv_fractional_en),

                     .tx_bond_size  (bb_f_ux_tx_bond_size),
                    //### added TX polarity attribute
                    .tx_invert_p_and_n("DISABLE"), 
                   //.tx_over_sample  (local_bb_f_ux_tx_over_sample), creates issues with simplex pma4style, why?
                     .tx_pam4_graycode_en  (bb_f_ux_tx_pam4_graycode_en),
                     .tx_pam4_precode_en  (bb_f_ux_tx_pam4_precode_en),
                     .tx_protocol  ( (bb_f_ux_core_pll=="CORE_PLL_DISABLED") ? bb_f_ux_tx_protocol : "TX_PROTOCOL_DISABLED"),
                     .tx_user_clk1_en  (bb_f_ux_tx_user_clk1_en),
                     .tx_user_clk1_mux  (bb_f_ux_tx_user_clk1_mux),
                     .tx_user_clk2_en  (bb_f_ux_tx_user_clk2_en),
                     .tx_user_clk2_mux  (bb_f_ux_tx_user_clk2_mux),
                     .tx_width                ( (bb_f_ux_core_pll=="CORE_PLL_DISABLED") ? bb_f_ux_tx_width : "TX_WIDTH_16"),
                     .txrx_channel_operation  ( bb_f_ux_txrx_channel_operation),
                     .txrx_line_encoding_type (  bb_f_ux_txrx_line_encoding_type),
                     .txrx_xcvr_speed_bucket  ( (bb_f_ux_core_pll=="CORE_PLL_DISABLED") ? bb_f_ux_txrx_xcvr_speed_bucket : "TXRX_XCVR_SPEED_BUCKET_DISABLED"),
// ww 46 snap		    
		     .sim_mode (local_bb_f_ux_sim_mode)
		     
//snap44                     .ux_q_ckmux_cpu_attr  (local_bb_f_ux_ux_q_ckmux_cpu_attr),
//snap46                     .ux_q_e_tx_dp_pipe_attr  (local_bb_f_ux_ux_q_e_tx_dp_pipe_attr)
                  )
                  x_bb_f_ux_tx
                  (
                    .duplex_bond_link(duplex_bond_ux_tx[idx_xcvr_total]),                

                    .tx_pll_refclk_link  ( ((fgt_tx_pll_cascade_enable==1) && (idx_xcvr_per_sys!=0)) ? lc_cascade_out_link[num_xcvr_per_sys*idx_sys_cop] : tx_pll_refclk_link[idx_xcvr_total] ),
                    .lc_cascade_out_link (  lc_cascade_out_link[idx_xcvr_total]),
					.cpi_cmn_busy_real   (cpi_cmn_busy_real[idx_xcvr_total]),


                    .o_gdr_xcvr_data_rx_tx__b_tx_out_p_srds_pad_lv_lane_real(tx_serial_data[idx_xcvr_total]),
                    .o_gdr_xcvr_data_rx_tx__b_tx_out_n_srds_pad_lv_lane_real(tx_serial_data_n[idx_xcvr_total]),

                    .oct_pcs_all_synthlockstatus_real(oct_pcs_all_synthlockstatus[idx_xcvr_total]),
                    .octl_pcs_txstatus_lx_a_real(octl_pcs_txstatus_lx_a[idx_xcvr_total]),
                    .ictl_pcs_txbeacon_lx_a_real(ictl_pcs_txbeacon_lx_a[idx_xcvr_total]),
					
                    .xcvr_data0_link(xcvr_tx_data_link[idx_m_data0link][idx_n_data0link]),
                    .xcvr_data1_link(xcvr_tx_data_link[idx_m_data1link][idx_n_data1link]),
                    .next_bonding_link(ux_bonding_link_tx[idx_sys_cop][idx_xcvr_per_sys+1]),
                    .prev_bonding_link(ux_bonding_link_tx[idx_sys_cop][idx_xcvr_per_sys]),
                    .avmm2_link(avmm2_link[idx_sys_cop][idx_xcvr_per_sys]),

		     // Deterministic Latency ports
		    .i_det_lat_sclk_real(dl_sclk[idx_xcvr_total]),
		    .tx_lane0_async_sync_dl_path_real(tx_dl_measure_sel[idx_xcvr_total]),
		    .o_tx_sclk_return_real(tx_dl_async_pulse[idx_xcvr_total]),

                    .placement_virtual(placement_virtual_tx_xcvr[idx_xcvr_total]),
                    .src_tx_master_virtual(mif_generation_link_primary_tx[idx_xcvr_total]),
                    .src_tx_slave_virtual(mif_generation_link_secondary_tx[idx_xcvr_total])
                  );
                 end
                end else begin
                  // need to instantiate UX2.0 
                end
              end

	      if (l_av2_enable) begin:av2_en
                 //   avmm2 bb inst
                 bb_m_hdpldadapt_avmm2 #(
                        .silicon_rev  (m_silicon_revision),
                        .auto_profile_id  (avmm_profile_id),
                        .hdpldadapt_pld_avmm2_clk_rowclk_hz(local_bb_m_hdpldadapt_avmm2_hdpldadapt_pld_avmm2_clk_rowclk_hz )
                     )

                 x_bb_f_avmm2   (
                  .hip_avmm_read_real                                (hip_avmm_read[idx_xcvr_total]       ),
		  .hip_avmm_readdata_real                            (hip_avmm_readdata[8*idx_xcvr_total+:8]  ),
                  .hip_avmm_readdatavalid_real                       (hip_avmm_readdatavalid[idx_xcvr_total]       ),
                  .hip_avmm_reg_addr_real                            (hip_avmm_reg_addr[21*idx_xcvr_total+:21]),
                  .hip_avmm_reserved_out_real                        (hip_avmm_reserved_out[5*idx_xcvr_total+:5]  ),
                  .hip_avmm_write_real                               (hip_avmm_write[idx_xcvr_total]       ),
                  .hip_avmm_writedata_real                           (hip_avmm_writedata[8*idx_xcvr_total+:8]  ),
                  .hip_avmm_writedone_real                           (hip_avmm_writedone[idx_xcvr_total]       ),
                  .pld_avmm2_busy_real                               (pld_avmm2_busy[idx_xcvr_total]       ),
                  .pld_avmm2_clk_rowclk_real                         (pld_avmm2_clk_rowclk[idx_xcvr_total]       ),
                  .pld_avmm2_cmdfifo_wr_full_real                    (pld_avmm2_cmdfifo_wr_full[idx_xcvr_total]       ),
                  .pld_avmm2_cmdfifo_wr_pfull_real                   (pld_avmm2_cmdfifo_wr_pfull[idx_xcvr_total]       ),
                  .pld_avmm2_request_real                            (pld_avmm2_request[idx_xcvr_total]       ),
                   //                                                                                            
                 // removed for  PMA direct SR   .pld_pll_cal_done_real                             (pld_pll_cal_done[idx_xcvr_total]       ),
                  .pld_avmm2_write_real                              (pld_avmm2_write[idx_xcvr_total]       ),
                  .pld_avmm2_read_real                               (pld_avmm2_read[idx_xcvr_total]       ),
                  .pld_avmm2_reg_addr_real                           (pld_avmm2_reg_addr[9*idx_xcvr_total+:9]  ),
                  .pld_avmm2_readdata_real                           (pld_avmm2_readdata[8*idx_xcvr_total+:8]  ),
                  .pld_avmm2_writedata_real                          (pld_avmm2_writedata[8*idx_xcvr_total+:8]  ),
                  .pld_avmm2_readdatavalid_real                      (pld_avmm2_readdatavalid[idx_xcvr_total]       ),
                  .pld_avmm2_reserved_in_real                        (pld_avmm2_reserved_in[6*idx_xcvr_total+:6]),
                  .pld_avmm2_reserved_out_real                       (pld_avmm2_reserved_out[idx_xcvr_total]  ),
		  .avmm2_link                                        (avmm2_link[idx_sys_cop][idx_xcvr_per_sys]       ) 
	         );
              end 
            end          
      end
    endgenerate
  
`else
   assign cdrdiv_clkout = 0;
`endif

endmodule










