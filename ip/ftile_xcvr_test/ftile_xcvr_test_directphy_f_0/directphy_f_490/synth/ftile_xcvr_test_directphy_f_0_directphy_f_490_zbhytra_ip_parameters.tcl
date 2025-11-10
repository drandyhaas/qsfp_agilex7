if {0} {
   unset phy_ip_params
}

set phy_ip_params [dict create]

dict set phy_ip_params profile_cnt "1"
set ::global_corename ftile_xcvr_test_directphy_f_0_directphy_f_490_zbhytra
# -------------------------------- #
# --- Default Profile settings --- #
# -------------------------------- #
dict set phy_ip_params xcvr_type_profile0 "FGT"
dict set phy_ip_params num_sys_cop_profile0 "1"
dict set phy_ip_params pma_data_rate_profile0 "25650.6"
dict set phy_ip_params pma_width_profile0 "32"
dict set phy_ip_params clocking_mode_profile0 "syspll"
dict set phy_ip_params duplex_mode_profile0 "duplex"
dict set phy_ip_params pma_outclk_freq_mhz_profile0 "801.58125"
dict set phy_ip_params syspll_outclk_freq_mhz_profile0 "801.58125"
dict set phy_ip_params fgt_tx_pll_txuserclk_div_profile0 "100"
dict set phy_ip_params fgt_tx_pll_txuserclk1_enable_profile0 "0"
dict set phy_ip_params fgt_tx_pll_txuserclk2_enable_profile0 "0"
dict set phy_ip_params fgt_rx_cdr_rxuserclk_div_profile0 "100"
dict set phy_ip_params fgt_rx_cdr_rxuserclk_enable_profile0 "0"
dict set phy_ip_params bk_pll_pcs3334_ratio_profile0 "DIV_33_BY_2"
dict set phy_ip_params bk_tx_user_clk1_en_profile0 "0"
dict set phy_ip_params bk_tx_user_clk2_en_profile0 "0"
dict set phy_ip_params bk_tx_user_clk1_sel_profile0 "0"
dict set phy_ip_params bk_tx_user_clk2_sel_profile0 "0"
dict set phy_ip_params bk_rx_user_clk1_en_profile0 "0"
dict set phy_ip_params bk_rx_user_clk2_en_profile0 "0"
dict set phy_ip_params bk_rx_user_clk1_sel_profile0 "0"
dict set phy_ip_params bk_rx_user_clk2_sel_profile0 "0"
dict set phy_ip_params pldif_rx_clkout_freq_mhz_profile0 "400.790625"
dict set phy_ip_params pldif_rx_clkout2_freq_mhz_profile0 "Disabled"
dict set phy_ip_params pldif_tx_clkout_freq_mhz_profile0 "400.790625"
dict set phy_ip_params pldif_tx_clkout2_freq_mhz_profile0 "Disabled"
dict set phy_ip_params pldif_tx_clkout2_sel_profile0 "TX_WORD_CLK"
dict set phy_ip_params pldif_rx_clkout2_sel_profile0 "RX_WORD_CLK"
