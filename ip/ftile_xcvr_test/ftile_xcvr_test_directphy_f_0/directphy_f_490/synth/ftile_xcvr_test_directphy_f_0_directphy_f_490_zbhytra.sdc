# (C) 2001-2024 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


## SDC ##

set dir_name [file dirname [info script]] 
set module_name ftile_xcvr_test_directphy_f_0_directphy_f_490_zbhytra
source "${dir_name}/ftile_xcvr_test_directphy_f_0_directphy_f_490_zbhytra_ip_parameters.tcl"

 ## get current IP instance 
 set ip_inst_name [get_current_instance]
 
 
 ## set global variables
 global ::global_corename
 set global_var $global_corename
 
 #if {![info exists ip_sdc_debug]} {
   global ::ip_sdc_debug
 #}
 
 set ip_sdc_debug 0
 # -------------------------------------------------------------- #
 # --- Iterate over the profiles                              --- #
 # -------------------------------------------------------------- #
  set profile_cnt [dict get $phy_ip_params profile_cnt]
  for {set i 0} {$i < $profile_cnt} {incr i} {
 
 set xcvr_type                    [dict get $phy_ip_params xcvr_type_profile$i]
 set num_sys_cop                  [dict get $phy_ip_params num_sys_cop_profile$i]
 set pma_datarate                 [dict get $phy_ip_params pma_data_rate_profile$i]
 set pma_if_width                 [dict get $phy_ip_params pma_width_profile$i]
 set clocking_mode                [dict get $phy_ip_params clocking_mode_profile$i]
 set pma_outclk_freq_mhz          [dict get $phy_ip_params pma_outclk_freq_mhz_profile$i]
 set syspll_outclk_freq_mhz       [dict get $phy_ip_params syspll_outclk_freq_mhz_profile$i]
 set duplex_mode                  [dict get $phy_ip_params duplex_mode_profile$i]


 ## UX TX user clock 
 set ux_tx_user_clk_div     [dict get $phy_ip_params fgt_tx_pll_txuserclk_div_profile$i]
 set ux_tx_user_clk1_en     [dict get $phy_ip_params fgt_tx_pll_txuserclk1_enable_profile$i]
 set ux_tx_user_clk2_en     [dict get $phy_ip_params fgt_tx_pll_txuserclk2_enable_profile$i]
 
 ## UX RX user clock
 set ux_rx_user_clk_div     [dict get $phy_ip_params fgt_rx_cdr_rxuserclk_div_profile$i]
 set ux_rx_user_clk_en      [dict get $phy_ip_params fgt_rx_cdr_rxuserclk_enable_profile$i]

 ## BK TX user clock
 set bk_pll_pcs_ratio        [dict get $phy_ip_params bk_pll_pcs3334_ratio_profile$i]
 set bk_tx_user_clk1_en      [dict get $phy_ip_params bk_tx_user_clk1_en_profile$i]
 set bk_tx_user_clk2_en      [dict get $phy_ip_params bk_tx_user_clk2_en_profile$i]
 set bk_tx_user_clk1_sel     [dict get $phy_ip_params bk_tx_user_clk1_sel_profile$i]
 set bk_tx_user_clk2_sel     [dict get $phy_ip_params bk_tx_user_clk2_sel_profile$i]
 
 ## BK RX user clock
 set bk_rx_user_clk1_en      [dict get $phy_ip_params bk_rx_user_clk1_en_profile$i]
 set bk_rx_user_clk2_en      [dict get $phy_ip_params bk_rx_user_clk2_en_profile$i]
 set bk_rx_user_clk1_sel     [dict get $phy_ip_params bk_rx_user_clk1_sel_profile$i]
 set bk_rx_user_clk2_sel     [dict get $phy_ip_params bk_rx_user_clk2_sel_profile$i]
 
 ## TX_CLKOUT and TX_CLKOUT2
 set tx_clkout_freq          [dict get $phy_ip_params pldif_tx_clkout_freq_mhz_profile$i]
 set tx_clkout2_freq         [dict get $phy_ip_params pldif_tx_clkout2_freq_mhz_profile$i]
 set tx_clkout2_sel          [dict get $phy_ip_params pldif_tx_clkout2_sel_profile$i]  ;# TODO: Cleanup

 ## RX_CLKOUT and RX_CLKOUT2
 set rx_clkout_freq          [dict get $phy_ip_params pldif_rx_clkout_freq_mhz_profile$i]
 set rx_clkout2_freq         [dict get $phy_ip_params pldif_rx_clkout2_freq_mhz_profile$i]
 set rx_clkout2_sel          [dict get $phy_ip_params pldif_rx_clkout2_sel_profile$i]  ;# TODO: Cleanup
 

 ## depends on clocking mode, parallel frequency can be transceiver clock freq or syspll clock freq
 if {$clocking_mode == "xcvr"} {
     set tx_parallel_freq [expr double (round(10000*$pma_outclk_freq_mhz))/10000]
     set rx_parallel_freq [expr double (round(10000*$pma_outclk_freq_mhz))/10000]

 } elseif {$clocking_mode == "syspll"} {
     set tx_parallel_freq [expr double (round(10000*$syspll_outclk_freq_mhz))/10000]
     set rx_parallel_freq [expr double (round(10000*$syspll_outclk_freq_mhz))/10000]

 }
 
 # ----------------------------------------------------------------------------- #
 # --- Print out the IP parameters when debug is enabled                     --- #
 # --- tx/rx_clkout_sel and tx/rx_clkout2_sel:                               --- # 
 # ---                                  Word Clock: TX/RX_WORD_CLK           --- #
 # ---                                  Bond Clock: TX/RX_BOND_CLK           --- #
 # ---                                  User Clock1: TX/RX_USER_CLK1         --- #
 # ---                                  User Clock2: TX/RX_USER_CLK2         --- #
 # ---                                  Sys PLL Clock: PLL_DIV1              --- #
 # ---                                  Sys PLL Clock Div2: PLL_DVI2         --- #
 # --- tx/rx_clkout2_div: 1/2/4                                              --- #            
 # --- clocking_mode: xcvr:Transceiver                                       --- #
 # ---                syspll: Systerm PLL                                    --- #
 # ----------------------------------------------------------------------------- #
   if {$ip_sdc_debug == 1} {
     post_message -type info "IP SDC: The pma datarate is $pma_datarate"
     post_message -type info "IP SDC: The pma if width is $pma_if_width"
     post_message -type info "IP SDC: The clocking mode is $clocking_mode"
     post_message -type info "IP SDC: The TX pma parallel frequency is $tx_parallel_freq"
     post_message -type info "IP SDC: The RX pma parallel frequency is $rx_parallel_freq"
     post_message -type info "IP SDC: The TX_CLKOUT  frequency is $tx_clkout_freq"
     post_message -type info "IP SDC: The TX_CLKOUT2 frequency is $tx_clkout2_freq"
     post_message -type info "IP SDC: The RX_CLKOUT  frequency is $rx_clkout_freq"
     post_message -type info "IP SDC: The RX_CLKOUT2 frequency is $rx_clkout2_freq"
   }

##--------------------------------------------------------------------------------------------------------##
##---- Calculate tx_user_clk_div and rx_user_clk_div                                                  ----##
##----                                                                                                ----## 
##---- (FGT)UX -> tx/rx_user_clk_div = ux_tx/rx_user_clk_div                                          ----##
##---- (FHT)BK -> tx/rx_user_clk_div = bk_tx/rx_user_clk_div                                          ----##
##----       TX_USER_CLK1: bk_tx_user_clk1_sel = 0(DIV3334)                                           ----##
##----                         bk_pll_pcs_ratio = DIV_33(DIV33) -> bk_tx/rx_user_clk_div = 33         ----##
##----                         bk_pll_pcs_ratio = DIV_34(DIV34) -> bk_tx/rx_user_clk_div = 34         ----##
##----                         bk_pll_pcs_ratio = DIV_33_BY_2(DIV66) -> bk_tx/rx_user_clk_div = 66    ----##
##----                         bk_pll_pcs_ratio = DIV_34_BY_2(DIV68) -> bk_tx/rx_user_clk_div = 68    ----##
##----                     bk_tx_user_clk1_sel = 1(DIV40) -> bk_tx/rx_user_clk_div = 40               ----##
##---- default -> tx/rx_user_clk_div = 100                                                            ----##
##--------------------------------------------------------------------------------------------------------##
 if {$xcvr_type == "FGT"} {
    set tx_user_clk_div $ux_tx_user_clk_div
 } elseif {$xcvr_type == "FHT" && $tx_clkout2_sel == "TX_USER_CLK1"} {
          if {$bk_tx_user_clk1_sel == 0} {
            if {$bk_pll_pcs_ratio == "DIV_33"} {
                set tx_user_clk_div 33
            } elseif {$bk_pll_pcs_ratio == "DIV_34"} {
                set tx_user_clk_div 34
            } elseif {$bk_pll_pcs_ratio == "DIV_33_BY_2"} {
                set tx_user_clk_div 66
            } else {
                set tx_user_clk_div 68
            }
        } else {
             set tx_user_clk_div 40
        }
 } elseif {$xcvr_type == "FHT" && $tx_clkout2_sel == "TX_USER_CLK2"} {
         if {$bk_tx_user_clk2_sel == 0} {
          if {$bk_pll_pcs_ratio == "DIV_33"} {
              set tx_user_clk_div 33
          } elseif {$bk_pll_pcs_ratio == "DIV_34"} {
              set tx_user_clk_div 34
          } elseif {$bk_pll_pcs_ratio == "DIV_33_BY_2"} {
              set tx_user_clk_div 66
          } else {
              set tx_user_clk_div 68
          }
         } else {
           set tx_user_clk_div 40
         }
 } else {
   set tx_user_clk_div 100
 }


if {$xcvr_type == "FGT"} {
    set rx_user_clk_div $ux_rx_user_clk_div
 } elseif {$xcvr_type == "FHT" && $rx_clkout2_sel == "RX_USER_CLK1"} {
          if {$bk_rx_user_clk1_sel == 0} {
            if {$bk_pll_pcs_ratio == "DIV_33"} {
                set rx_user_clk_div 33
            } elseif {$bk_pll_pcs_ratio == "DIV_34"} {
                set rx_user_clk_div 34
            } elseif {$bk_pll_pcs_ratio == "DIV_33_BY_2"} {
                set rx_user_clk_div 66
            } else {
                set rx_user_clk_div 68
            }
        } else {
             set rx_user_clk_div 40
        }
 } elseif {$xcvr_type == "FHT" && $rx_clkout2_sel == "RX_USER_CLK2"} {
         if {$bk_rx_user_clk2_sel == 0} {
          if {$bk_pll_pcs_ratio == "DIV_33"} {
              set rx_user_clk_div 33
          } elseif {$bk_pll_pcs_ratio == "DIV_34"} {
              set rx_user_clk_div 34
          } elseif {$bk_pll_pcs_ratio == "DIV_33_BY_2"} {
              set rx_user_clk_div 66
          } else {
              set rx_user_clk_div 68
          }
         } else {
           set rx_user_clk_div 40
         }
 } else {
   set rx_user_clk_div 100
 }

 
 ## create new dictionary 
 set active_chnl_nodes [dict create]
 set active_chnl_clks [dict create]
 set active_chnl_clks_names [dict create]
 set active_chnl_clks_freq [dict create]
 set active_chnl_multiply_by_factors [dict create]
 set active_chnl_divide_by_factors [dict create]

 ## set frequency for base clocks
 dict set active_chnl_clks_freq tx_pld_pcs_clk_ref $tx_clkout_freq
 dict set active_chnl_clks_freq tx_user_clk_ref    $tx_clkout2_freq

 dict set active_chnl_clks_freq rx_pld_pcs_clk_ref $rx_clkout_freq
 dict set active_chnl_clks_freq rx_user_clk_ref    $rx_clkout2_freq
 
 dict set active_chnl_clks_freq tx_pma_aib_clk_ref [dict get $active_chnl_clks_freq tx_pld_pcs_clk_ref]
 dict set active_chnl_clks_freq rx_transfer_clk_ref [dict get $active_chnl_clks_freq rx_pld_pcs_clk_ref]

 dict set active_chnl_clks_freq pld_pma_hclk_ref 100 


 ## set multiple_by and divide_by for gernerated clocks
 dict set active_chnl_multiply_by_factors     tx_pld_pcs_clk_reg    1
 dict set active_chnl_divide_by_factors       tx_pld_pcs_clk_reg    1
 
 dict set active_chnl_multiply_by_factors     rx_pld_pcs_clk_reg    1
 dict set active_chnl_divide_by_factors       rx_pld_pcs_clk_reg    1
 
 dict set active_chnl_multiply_by_factors     tx_pma_aib_clk_reg    1
 dict set active_chnl_divide_by_factors       tx_pma_aib_clk_reg    1
 
 dict set active_chnl_multiply_by_factors     rx_transfer_clk_reg    1
 dict set active_chnl_divide_by_factors       rx_transfer_clk_reg    1
 
 dict set active_chnl_multiply_by_factors     tx_user_clk_reg    1
 dict set active_chnl_divide_by_factors       tx_user_clk_reg    1
 
 dict set active_chnl_multiply_by_factors     rx_user_clk_reg    1
 dict set active_chnl_divide_by_factors       rx_user_clk_reg    1
 
 dict set active_chnl_multiply_by_factors     pld_pma_hclk_reg    1
 dict set active_chnl_divide_by_factors       pld_pma_hclk_reg    1

 dict set active_chnl_multiply_by_factors     tx_clkout    1
 dict set active_chnl_divide_by_factors       tx_clkout    1
 
 dict set active_chnl_multiply_by_factors     rx_clkout    1
 dict set active_chnl_divide_by_factors       rx_clkout    1
 
 dict set active_chnl_multiply_by_factors     tx_clkout2    1
 dict set active_chnl_divide_by_factors       tx_clkout2    1
 
 dict set active_chnl_multiply_by_factors     rx_clkout2    1
 dict set active_chnl_divide_by_factors       rx_clkout2    1
 
 
 ## find active clocks through tx_clkout
 set dummy_ff_in_sip [get_nodes -nowarn $ip_inst_name|dummy_out_for_timing*|clk]
 
 ## find active channels through tx_clkout
 if {[get_collection_size $dummy_ff_in_sip] > 0} {
    foreach_in_collection dummy_ff_in_sip_node $dummy_ff_in_sip {
          set dummy_ff_in_sip_node_name [get_node_info -name $dummy_ff_in_sip_node]
          set dummy_ff_in_sip_fanin [get_fanins $dummy_ff_in_sip_node_name]
          ## get dummy ff fanin node name 
          set dummy_ff_in_sip_fanin_node_name [get_node_info -name $dummy_ff_in_sip_fanin]
          
          ## find active channel numbers 
          ## get index for ".reg"
          set reg_index [string last .reg $dummy_ff_in_sip_fanin_node_name] 
    
          # get active chnl number according to it's single bit or two bits, index-2 is digit means two bits(10~23), otherwise it's single bit(0~9) 
          if { [string is digit [string index $dummy_ff_in_sip_fanin_node_name $reg_index-2]] } {
              set chnl [string range $dummy_ff_in_sip_fanin_node_name $reg_index-2 $reg_index-1]
          } else {
              set chnl [string index $dummy_ff_in_sip_fanin_node_name $reg_index-1]
          }

          # get instance name of top_auto_tiles in tile part 
          set top_tile_index [string last ~aib_hssi $dummy_ff_in_sip_fanin_node_name] 
          set top_tile_inst_name [string range $dummy_ff_in_sip_fanin_node_name 0 $top_tile_index]
          # get instance name of top_auto_tiles in fabric part
          set top_fab_index [string last | $dummy_ff_in_sip_fanin_node_name]
          set top_fab_inst_name [string range $dummy_ff_in_sip_fanin_node_name 0 $top_fab_index]
          
           if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: instance name of top_tiles in tile part is $top_tile_inst_name"
                post_message -type info "IP SDC: instance name of top_tiles in fab part is $top_fab_inst_name"
             }


            ## set *ref node and *reg node to dictionary
          if {$duplex_mode == "duplex" || $duplex_mode == "tx"} { 
          set tx_pld_pcs_ref_nodes_col aib_hssi_pld_pcs_tx_clk_out_ch${chnl}_ref
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$tx_pld_pcs_ref_nodes_col]] > 0} {
              dict lappend active_chnl_clks tx_pld_pcs_clk_ref [get_node_info -name $top_tile_inst_name$tx_pld_pcs_ref_nodes_col]
              ## sorting 
              dict set active_chnl_clks tx_pld_pcs_clk_ref [lsort -dictionary [dict get $active_chnl_clks tx_pld_pcs_clk_ref]]
              if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: TX pld pcs clk ref node info: [dict get $active_chnl_clks tx_pld_pcs_clk_ref]"
              }
          }

          set tx_pld_pcs_reg_nodes_col aib_hssi_pld_pcs_tx_clk_out_ch${chnl}.reg 
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$tx_pld_pcs_reg_nodes_col]] > 0} {
              dict lappend active_chnl_clks tx_pld_pcs_clk_reg [get_node_info -name $top_tile_inst_name$tx_pld_pcs_reg_nodes_col]
              ## sorting
              dict set active_chnl_clks tx_pld_pcs_clk_reg [lsort -dictionary [dict get $active_chnl_clks tx_pld_pcs_clk_reg]]
              if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: TX pld pcs clk reg node info: [dict get $active_chnl_clks tx_pld_pcs_clk_reg]"
              }
          }

            set tx_pma_aib_ref_nodes_col aib_hssi_pma_aib_tx_clk_ch${chnl}_ref 
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$tx_pma_aib_ref_nodes_col]] > 0} {
             dict lappend active_chnl_clks tx_pma_aib_clk_ref [get_node_info -name $top_tile_inst_name$tx_pma_aib_ref_nodes_col]
             ## sorting 
             dict set active_chnl_clks tx_pma_aib_clk_ref [lsort -dictionary [dict get $active_chnl_clks tx_pma_aib_clk_ref]]
             if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: TX pma aib clk ref node info: [dict get $active_chnl_clks tx_pma_aib_clk_ref]"
             }
          }
   
          set tx_pma_aib_reg_nodes_col aib_hssi_pma_aib_tx_clk_ch${chnl}.reg
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$tx_pma_aib_reg_nodes_col]] > 0} {
             dict lappend active_chnl_clks tx_pma_aib_clk_reg [get_node_info -name $top_tile_inst_name$tx_pma_aib_reg_nodes_col]
            ## sorting
             dict set active_chnl_clks tx_pma_aib_clk_reg [lsort -dictionary [dict get $active_chnl_clks tx_pma_aib_clk_reg]]
             if {$ip_sdc_debug == 1} {
                 post_message -type info "IP SDC: TX pma aib clk reg node info: [dict get $active_chnl_clks tx_pma_aib_clk_reg]"
             }
          }
   set grp_freq [dict get $active_chnl_clks_freq "tx_user_clk_ref"]
	  if { $grp_freq != "Disabled" } { 
         set tx_user_ref_nodes_col aib_hssi_pld_pma_clkdiv_tx_user_ch${chnl}_ref
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$tx_user_ref_nodes_col]] > 0} {
            dict lappend active_chnl_clks tx_user_clk_ref [get_node_info -name $top_tile_inst_name$tx_user_ref_nodes_col]
            ## sorting
            dict set active_chnl_clks tx_user_clk_ref [lsort -dictionary [dict get $active_chnl_clks tx_user_clk_ref]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: TX user clk ref node info: [dict get $active_chnl_clks tx_user_clk_ref]"
            }
          }

          set tx_user_reg_nodes_col aib_hssi_pld_pma_clkdiv_tx_user_ch${chnl}.reg
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$tx_user_reg_nodes_col]] > 0} {
            dict lappend active_chnl_clks tx_user_clk_reg [get_node_info -name $top_tile_inst_name$tx_user_reg_nodes_col]
            ## sorting
            dict set active_chnl_clks tx_user_clk_reg [lsort -dictionary [dict get $active_chnl_clks tx_user_clk_reg]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: TX user clk reg node info: [dict get $active_chnl_clks tx_user_clk_reg]"
            }
          }
       }
          set tx_pld_pcs_out1_dcm_nodes_col hdpldadapt_tx_chnl_${chnl}|pld_pcs_tx_clk_out1_dcm  
          if {[get_collection_size [get_nodes -nowarn $top_fab_inst_name$tx_pld_pcs_out1_dcm_nodes_col]] > 0} {
            dict lappend active_chnl_clks tx_clkout [get_node_info -name $top_fab_inst_name$tx_pld_pcs_out1_dcm_nodes_col]
            ## sorting
            dict set active_chnl_clks tx_clkout [lsort -dictionary [dict get $active_chnl_clks tx_clkout]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: PLD PCS TX OUT1 DCM CLK node info: [dict get $active_chnl_clks tx_clkout]"
            }
          } 

       if { $grp_freq != "Disabled" } { 
          set tx_pld_pcs_out2_dcm_nodes_col hdpldadapt_tx_chnl_${chnl}|pld_pcs_tx_clk_out2_dcm 
          if {[get_collection_size [get_nodes -nowarn $top_fab_inst_name$tx_pld_pcs_out2_dcm_nodes_col]] > 0} {
             dict lappend active_chnl_clks tx_clkout2 [get_node_info -name $top_fab_inst_name$tx_pld_pcs_out2_dcm_nodes_col]
            ## sorting
             dict set active_chnl_clks tx_clkout2 [lsort -dictionary [dict get $active_chnl_clks tx_clkout2]]
             if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: PLD PCS TX OUT2 DCM CLK node info: [dict get $active_chnl_clks tx_clkout2]"
             }
          } 
        }
      }; ## end of TX simplex

 
          if {$duplex_mode == "duplex" || $duplex_mode == "rx"} {
          set rx_pld_pcs_ref_nodes_col aib_hssi_pld_pcs_rx_clk_out_ch${chnl}_ref 
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$rx_pld_pcs_ref_nodes_col]] > 0} {
              dict lappend active_chnl_clks rx_pld_pcs_clk_ref [get_node_info -name $top_tile_inst_name$rx_pld_pcs_ref_nodes_col]
              ## sorting 
              dict set active_chnl_clks rx_pld_pcs_clk_ref [lsort -dictionary [dict get $active_chnl_clks rx_pld_pcs_clk_ref]]
              if {$ip_sdc_debug == 1} {
               post_message -type info "IP SDC: RX pld pcs clk ref node info: [dict get $active_chnl_clks rx_pld_pcs_clk_ref]"
              }
          }

          set rx_pld_pcs_reg_nodes_col aib_hssi_pld_pcs_rx_clk_out_ch${chnl}.reg 
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$rx_pld_pcs_reg_nodes_col]] > 0} {
             dict lappend active_chnl_clks rx_pld_pcs_clk_reg [get_node_info -name $top_tile_inst_name$rx_pld_pcs_reg_nodes_col] 
             ## sorting
             dict set active_chnl_clks rx_pld_pcs_clk_reg [lsort -dictionary [dict get $active_chnl_clks rx_pld_pcs_clk_reg]]
             if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: RX pld pcs clk reg node info: [dict get $active_chnl_clks rx_pld_pcs_clk_reg]"
             }
          }
                
          set rx_transfer_ref_nodes_col aib_hssi_rx_transfer_clk_ch${chnl}_ref
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$rx_transfer_ref_nodes_col]] > 0} {
            dict lappend active_chnl_clks rx_transfer_clk_ref [get_node_info -name $top_tile_inst_name$rx_transfer_ref_nodes_col]
            ## sorting 
            dict set active_chnl_clks rx_transfer_clk_ref [lsort -dictionary [dict get $active_chnl_clks rx_transfer_clk_ref]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: RX transfer clk ref node info: [dict get $active_chnl_clks rx_transfer_clk_ref]"
            }
          }
   
          set rx_transfer_reg_nodes_col aib_hssi_rx_transfer_clk_ch${chnl}.reg
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$rx_transfer_reg_nodes_col]] > 0} {
            dict lappend active_chnl_clks rx_transfer_clk_reg [get_node_info -name $top_tile_inst_name$rx_transfer_reg_nodes_col]
            ## sorting
            dict set active_chnl_clks rx_transfer_clk_reg [lsort -dictionary [dict get $active_chnl_clks rx_transfer_clk_reg]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: RX transfer clk reg node info: [dict get $active_chnl_clks rx_transfer_clk_reg]"
            }
          }         
 
      set grp_freq [dict get $active_chnl_clks_freq "rx_user_clk_ref"]
	  if { $grp_freq != "Disabled" } { 
          set rx_user_ref_nodes_col aib_hssi_pld_pma_clkdiv_rx_user_ch${chnl}_ref
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$rx_user_ref_nodes_col]] > 0} {
            dict lappend active_chnl_clks rx_user_clk_ref [get_node_info -name $top_tile_inst_name$rx_user_ref_nodes_col]
            ## sorting
            dict set active_chnl_clks rx_user_clk_ref [lsort -dictionary [dict get $active_chnl_clks rx_user_clk_ref]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: RX user clk ref node info: [dict get $active_chnl_clks rx_user_clk_ref]"
            }
          }

          set rx_user_reg_nodes_col aib_hssi_pld_pma_clkdiv_rx_user_ch${chnl}.reg
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$rx_user_reg_nodes_col]] > 0} {
            dict lappend active_chnl_clks rx_user_clk_reg [get_node_info -name $top_tile_inst_name$rx_user_reg_nodes_col]
            ## sorting
            dict set active_chnl_clks rx_user_clk_reg [lsort -dictionary [dict get $active_chnl_clks rx_user_clk_reg]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: RX user clk reg node info: [dict get $active_chnl_clks rx_user_clk_reg]"
             }
           }
         }           
          set rx_pld_pcs_out1_dcm_nodes_col hdpldadapt_rx_chnl_${chnl}|pld_pcs_rx_clk_out1_dcm  
          if {[get_collection_size [get_nodes -nowarn $top_fab_inst_name$rx_pld_pcs_out1_dcm_nodes_col]] > 0} {
              dict lappend active_chnl_clks rx_clkout [get_node_info -name $top_fab_inst_name$rx_pld_pcs_out1_dcm_nodes_col]
             ## sorting
             dict set active_chnl_clks rx_clkout [lsort -dictionary [dict get $active_chnl_clks rx_clkout]]
             if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: PLD PCS RX OUT1 DCM CLK node info: [dict get $active_chnl_clks rx_clkout]"
             }
          } 
         
		 if { $grp_freq != "Disabled" } {  
          set rx_pld_pcs_out2_dcm_nodes_col hdpldadapt_rx_chnl_${chnl}|pld_pcs_rx_clk_out2_dcm  
          if {[get_collection_size [get_nodes -nowarn $top_fab_inst_name$rx_pld_pcs_out2_dcm_nodes_col]] > 0} {
            dict lappend active_chnl_clks rx_clkout2 [get_node_info -name $top_fab_inst_name$rx_pld_pcs_out2_dcm_nodes_col]
            ## sorting
            dict set active_chnl_clks rx_clkout2 [lsort -dictionary [dict get $active_chnl_clks rx_clkout2]]
            if {$ip_sdc_debug == 1} {
               post_message -type info "IP SDC: PLD PCS RX OUT2 DCM CLK node info: [dict get $active_chnl_clks rx_clkout2]"
              }
            }
          }
        }; ## end of RX simplex   
 
          set pld_pma_hclk_ref_nodes_col aib_hssi_pld_pma_hclk_ch${chnl}_ref
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$pld_pma_hclk_ref_nodes_col]] > 0} {
            dict lappend active_chnl_clks pld_pma_hclk_ref [get_node_info -name $top_tile_inst_name$pld_pma_hclk_ref_nodes_col]
            ## sorting
            dict set active_chnl_clks pld_pma_hclk_ref [lsort -dictionary [dict get $active_chnl_clks pld_pma_hclk_ref]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: pld pma hclk ref node info: [dict get $active_chnl_clks pld_pma_hclk_ref]"
            }
          }

          set pld_pma_hclk_reg_nodes_col aib_hssi_pld_pma_hclk_ch${chnl}.reg
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$pld_pma_hclk_reg_nodes_col]] > 0} {
            dict lappend active_chnl_clks pld_pma_hclk_reg [get_node_info -name $top_tile_inst_name$pld_pma_hclk_reg_nodes_col]
            ## sorting
            dict set active_chnl_clks pld_pma_hclk_reg [lsort -dictionary [dict get $active_chnl_clks pld_pma_hclk_reg]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: pld pma hclk reg node info: [dict get $active_chnl_clks pld_pma_hclk_reg]"
            }
          }
       
    }; # end of foreach_in_collection dummy ff
 } else {
    if {$ip_sdc_debug == 1} {
       post_message -type info "IP SDC: Could not find active CLKOUT ports for user facing clocks"
    }
 
 }
 
  
  proc native_prepare_to_create_clocks_all_ch {clks_grp clks active_chnl_clks_freq active_chnl_multiply_by_factors active_chnl_divide_by_factors ip_inst_name top_tile_inst_name master_clocks source_nodes} {
    ## call global variable 
    global ::ip_sdc_debug
  
        foreach clk $clks {
                if {$clks_grp == "tx_pld_pcs_clk_ref" || $clks_grp == "rx_pld_pcs_clk_ref" || $clks_grp == "tx_pma_aib_clk_ref" || $clks_grp == "rx_transfer_clk_ref" || $clks_grp == "tx_user_clk_ref" || $clks_grp == "rx_user_clk_ref" || $clks_grp == "pld_pma_hclk_ref"} {
                     ## get active chnl number according to it's single bit or two bits, index-2 is digit means two bits(10~23), otherwise it's single bit(0~9)
                     set chnl_index [string last _ref $clk]
                     if { [string is digit [string index $clk $chnl_index-2]] } {
                          set chnl [string range $clk $chnl_index-2 $chnl_index-1]
                        } else {
                          set chnl [string index $clk $chnl_index-1]
                        }
  
                     set grp_freq [dict get $active_chnl_clks_freq $clks_grp]
                    
                     ## create clock name based on clock group and channel 
                     set clk_name $ip_inst_name|$clks_grp|ch$chnl
                     dict lappend active_chnl_clks_names tx_pld_pcs_clks_ref_name $clk_name
                     
				 if { $grp_freq  != "Disabled" } {
                          ## create_clock  
                          create_clock \
                                       -name $clk_name \
                                       -period "$grp_freq MHz" \
                                       -add    $clk
                           if {$ip_sdc_debug == 1} {
                                 post_message -type info "IP SDC: Creating base clock: $clk_name, period $grp_freq MHz, at node $clk"
                                 post_message -type info "IP SDC: Creating base clock: period is $grp_freq MHz"
                                 post_message -type info "IP SDC: Creating base clock: at node $clk"
                           } 
                   }						   
                } elseif {$clks_grp == "tx_pld_pcs_clk_reg" || $clks_grp == "rx_pld_pcs_clk_reg" || $clks_grp == "tx_pma_aib_clk_reg" || $clks_grp == "rx_transfer_clk_reg" || $clks_grp == "tx_user_clk_reg" || $clks_grp == "rx_user_clk_reg" || $clks_grp == "pld_pma_hclk_reg" || $clks_grp == "tx_clkout" || $clks_grp == "rx_clkout" || $clks_grp == "tx_clkout2" || $clks_grp == "rx_clkout2"} {
                         ## get active chnl number according to it's single bit or two bits, index-2 is digit means two bits(10~23), otherwise it's single bit(0~9)
                         if {$clks_grp == "tx_pld_pcs_clk_reg" || $clks_grp == "rx_pld_pcs_clk_reg" || $clks_grp == "tx_pma_aib_clk_reg" || $clks_grp == "rx_transfer_clk_reg" || $clks_grp == "tx_user_clk_reg" || $clks_grp == "rx_user_clk_reg" || $clks_grp == "pld_pma_hclk_reg"} {
                            set chnl_index [string last .reg $clk]
                         } elseif {$clks_grp == "tx_clkout" || $clks_grp == "rx_clkout" || $clks_grp == "tx_clkout2" || $clks_grp == "rx_clkout2"} {
                            set chnl_index [string last |pld_pcs_ $clk]
                         }
  
                         if { [string is digit [string index $clk $chnl_index-2]] } {
                               set chnl [string range $clk $chnl_index-2 $chnl_index-1]
                         } else {
                               set chnl [string index $clk $chnl_index-1]
                         }
   
                         set multiply_by [dict get $active_chnl_multiply_by_factors $clks_grp]
                         set divide_by [dict get $active_chnl_divide_by_factors $clks_grp]
                         set clk_name $ip_inst_name|$clks_grp|ch$chnl
       
                          set master_clock [lsearch -inline -regexp $master_clocks .*ch$chnl.*]
                          set source_node  [lsearch -inline -regexp $source_nodes .*ch$chnl.*]
       
                         ## create_generated_clock  
                         create_generated_clock \
                                      -name $clk_name \
                                      -source $source_node \
                                      -master_clock $master_clock \
                                      -multiply_by $multiply_by \
                                      -divide_by $divide_by \
                                      -duty_cycle 50 \
                                      -add    $clk
                           if {$ip_sdc_debug == 1} {
                                 post_message -type info "IP SDC: Creating generated clock: $clk_name"
                                 post_message -type info "IP SDC: Creating generated clock: at node $clk"
                                 post_message -type info "IP SDC: Creating generated clock: source node is $source_node"
                                 post_message -type info "IP SDC: Creating generated clock: master clock is $master_clock"
                                 post_message -type info "IP SDC: Creating generated clock: multiply_by factor is $multiply_by"
                                 post_message -type info "IP SDC: Creating generated clock: divide_by factor is $divide_by"
                           }         
            }; ## end of if-elseif condition
        }; ## end of foreach clk
  
  }; ## end of proc {native_prepare_to_create_clocks_all_ch}
  
  
  
  ## iterate through each clock group, set master clock and source node
  foreach {clks_grp clks} $active_chnl_clks {
    ## call global variable 
    global ::ip_sdc_debug
  
        foreach clk $clks {
              if {$clks_grp == "tx_pld_pcs_clk_ref" || $clks_grp == "rx_pld_pcs_clk_ref" || $clks_grp == "tx_pma_aib_clk_ref" || $clks_grp == "rx_transfer_clk_ref" || $clks_grp == "tx_user_clk_ref" || $clks_grp == "rx_user_clk_ref" || $clks_grp == "pld_pma_hclk_ref"} {
                  ## get active chnl number according to it's single bit or two bits, index-2 is digit means two bits(10~23), otherwise it's single bit(0~9)
                  set chnl_index [string last _ref $clk]
                  if { [string is digit [string index $clk $chnl_index-2]] } {
                        set chnl [string range $clk $chnl_index-2 $chnl_index-1]
                     } else {
                        set chnl [string index $clk $chnl_index-1]
                     }
                  
                  set clk_name $ip_inst_name|$clks_grp|ch$chnl
                  dict lappend active_chnl_clks_names $clks_grp $clk_name
                  set master_clocks ""
                  set source_nodes ""
              } elseif {$clks_grp == "tx_pld_pcs_clk_reg" || $clks_grp == "rx_pld_pcs_clk_reg" || $clks_grp == "tx_pma_aib_clk_reg" || $clks_grp == "rx_transfer_clk_reg" || $clks_grp == "tx_user_clk_reg" || $clks_grp == "rx_user_clk_reg" || $clks_grp == "pld_pma_hclk_reg" || $clks_grp == "tx_clkout" || $clks_grp == "rx_clkout" || $clks_grp == "tx_clkout2" || $clks_grp == "rx_clkout2"} {
                        ## get active chnl number according to it's single bit or two bits, index-2 is digit means two bits(10~23), otherwise it's single bit(0~9)
                        if {$clks_grp == "tx_pld_pcs_clk_reg" || $clks_grp == "rx_pld_pcs_clk_reg" || $clks_grp == "tx_pma_aib_clk_reg" || $clks_grp == "rx_transfer_clk_reg" || $clks_grp == "tx_user_clk_reg" || $clks_grp == "rx_user_clk_reg" || $clks_grp == "pld_pma_hclk_reg"} {
                            set chnl_index [string last .reg $clk]
                        } elseif {$clks_grp == "tx_clkout" || $clks_grp == "rx_clkout" || $clks_grp == "tx_clkout2" || $clks_grp == "rx_clkout2"} {
                            set chnl_index [string last |pld_pcs $clk]
                        }
  
                        if { [string is digit [string index $clk $chnl_index-2]] } {
                             set chnl [string range $clk $chnl_index-2 $chnl_index-1]
                        } else {
                             set chnl [string index $clk $chnl_index-1]
                        }
   
                        set clk_name $ip_inst_name|$clks_grp|ch$chnl
                        dict lappend active_chnl_clks_names $clks_grp $clk_name
              }; ## end of if-elseif condition
  
        }; ## end of foreach clk 
       
         
      if {$clks_grp == "tx_pld_pcs_clk_reg"} {
              set master_clocks [dict get $active_chnl_clks_names tx_pld_pcs_clk_ref]
              set source_nodes  [dict get $active_chnl_clks tx_pld_pcs_clk_ref]
             } elseif {$clks_grp == "rx_pld_pcs_clk_reg"} {
              set master_clocks [dict get $active_chnl_clks_names rx_pld_pcs_clk_ref]
              set source_nodes  [dict get $active_chnl_clks rx_pld_pcs_clk_ref]
             } elseif {$clks_grp == "tx_pma_aib_clk_reg"} {
              set master_clocks [dict get $active_chnl_clks_names tx_pma_aib_clk_ref]
              set source_nodes  [dict get $active_chnl_clks tx_pma_aib_clk_ref]
             } elseif {$clks_grp == "rx_transfer_clk_reg"} {
              set master_clocks [dict get $active_chnl_clks_names rx_transfer_clk_ref]
              set source_nodes  [dict get $active_chnl_clks rx_transfer_clk_ref]
             }  elseif {$clks_grp == "tx_user_clk_reg"} {
              set master_clocks [dict get $active_chnl_clks_names tx_user_clk_ref]
              set source_nodes  [dict get $active_chnl_clks tx_user_clk_ref]
             } elseif {$clks_grp == "rx_user_clk_reg"} {
              set master_clocks [dict get $active_chnl_clks_names rx_user_clk_ref]
              set source_nodes  [dict get $active_chnl_clks rx_user_clk_ref]
             } elseif {$clks_grp == "pld_pma_hclk_reg"} {
              set master_clocks [dict get $active_chnl_clks_names pld_pma_hclk_ref]
              set source_nodes  [dict get $active_chnl_clks pld_pma_hclk_ref]
             } elseif {$clks_grp == "tx_clkout"} {
              set master_clocks [dict get $active_chnl_clks_names tx_pld_pcs_clk_reg]
              set source_nodes  [dict get $active_chnl_clks tx_pld_pcs_clk_reg]
             } elseif {$clks_grp == "rx_clkout"} {
              set master_clocks [dict get $active_chnl_clks_names rx_pld_pcs_clk_reg]
              set source_nodes  [dict get $active_chnl_clks rx_pld_pcs_clk_reg]
             } elseif {$clks_grp == "tx_clkout2"} {
              set master_clocks [dict get $active_chnl_clks_names tx_user_clk_reg]
              set source_nodes  [dict get $active_chnl_clks tx_user_clk_reg]
             } elseif {$clks_grp == "rx_clkout2"} {
              set master_clocks [dict get $active_chnl_clks_names rx_user_clk_reg]
              set source_nodes  [dict get $active_chnl_clks rx_user_clk_reg]
             }


        ## call proc to create clocks 
        native_prepare_to_create_clocks_all_ch $clks_grp $clks $active_chnl_clks_freq $active_chnl_multiply_by_factors $active_chnl_divide_by_factors $ip_inst_name $top_tile_inst_name $master_clocks $source_nodes
  }; ## end of dict for
 

################################################
set freq_chk [get_registers -nowarn *resync_chains*.synchronizer_nocut|din_s1**]
if {[get_collection_size $freq_chk] > 0} {
    set_false_path -to [get_registers -nowarn *resync_chains*.synchronizer_nocut|din_s1*]
}
set freq_chk1 [get_registers -nowarn *resync_chains*.synchronizer_nocut|dreg**]
if {[get_collection_size $freq_chk1] > 0} {
  set_false_path -to [get_registers -nowarn *resync_chains*.synchronizer_nocut|dreg*]

}
###gpon timing issue
set cpi_cmn_busy_real_reg_din_s1 [get_registers -nowarn *|dphy_sip_inst|cpi_cmn_busy_real_reg]
 if {[get_collection_size $cpi_cmn_busy_real_reg_din_s1 ] > 0} {
     set_false_path -to $cpi_cmn_busy_real_reg_din_s1
  }

  #-------------------------------------------------- #
  #---                                            --- #
  #--- DISABLE MIN_PULSE_WIDTH CHECK              --- #
  #---                                            --- #
  #-------------------------------------------------- #
  ## Disable min_pulse_width for TX source clocks
  set tx_source_clks_list [list]
  if {[dict exists $active_chnl_clks_names tx_pld_pcs_clk_ref]} {
    set tx_source_clks_list [dict get $active_chnl_clks_names tx_pld_pcs_clk_ref]
  }
  if {[dict exists $active_chnl_clks_names tx_pma_aib_clk_ref]} {
    set tx_source_clks_list [concat $tx_source_clks_list  [dict get $active_chnl_clks_names tx_pma_aib_clk_ref]]
  }
  if {[dict exists $active_chnl_clks_names tx_user_clk_ref]} {
    set tx_source_clks_list [concat $tx_source_clks_list [dict get $active_chnl_clks_names tx_user_clk_ref]]
  }

  
  foreach tx_src_clk $tx_source_clks_list {
    disable_min_pulse_width $tx_src_clk
  }
  
  
  ## Disable min_pulse_width for RX source clocks
  set rx_source_clks_list [list]
  if {[dict exists $active_chnl_clks_names rx_pld_pcs_clk_ref]} {
    set rx_source_clks_list [dict get $active_chnl_clks_names rx_pld_pcs_clk_ref]
  }
  if {[dict exists $active_chnl_clks_names rx_transfer_clk_ref]} {
    set rx_source_clks_list [concat $rx_source_clks_list  [dict get $active_chnl_clks_names rx_transfer_clk_ref]]
  }
  if {[dict exists $active_chnl_clks_names rx_user_clk_ref]} {
    set rx_source_clks_list [concat $rx_source_clks_list [dict get $active_chnl_clks_names rx_user_clk_ref]]
  }
  

  foreach rx_src_clk $rx_source_clks_list {
    disable_min_pulse_width $rx_src_clk
  }
  
  ## Disable min_pulse_width for HCLK 
  if {[dict exists $active_chnl_clks_names pld_pma_hclk_ref]} {
    disable_min_pulse_width [dict get $active_chnl_clks_names pld_pma_hclk_ref] 
  }
 
  
  }; ## end of profile cnt iteration

##----------------------------------------------------------------------------------------------##
##----                          Hard IP Timing HCLK fix                                     ----##
##----                          HCLK is not being used in DPHY                              ----##
##---- solution: create HCLK if it's in timing netlist and then set_false_path from/to it   ----##
##----------------------------------------------------------------------------------------------##
set aib_fabric_pld_pma_hclk_reg_col [get_registers -nowarn *hdpldadapt_rx_chnl_*~aib_fabric_pld_pma_hclk.reg]
set aib_fabric_pma_aib_tx_clk_reg_col [get_registers -nowarn *hdpldadapt_tx_chnl_*~aib_fabric_pma_aib_tx_clk.reg]
set pld_rx_clk1_dcm_reg_col [get_registers -nowarn *hdpldadapt_rx_chnl_*~pld_rx_clk1_dcm.reg]
set pld_rx_clk1_rowclk_reg_clk [get_registers -nowarn *hdpldadapt_rx_chnl_*~pld_rx_clk1_rowclk.reg]


if {[get_collection_size $aib_fabric_pld_pma_hclk_reg_col] > 0 && [get_collection_size $aib_fabric_pma_aib_tx_clk_reg_col] > 0} {
    set_false_path -from $aib_fabric_pld_pma_hclk_reg_col -to $aib_fabric_pma_aib_tx_clk_reg_col
  }

if {[get_collection_size $aib_fabric_pld_pma_hclk_reg_col] > 0 && [get_collection_size $pld_rx_clk1_dcm_reg_col] > 0} {
    set_false_path -from $aib_fabric_pld_pma_hclk_reg_col -to $pld_rx_clk1_dcm_reg_col
  }

if {[get_collection_size $aib_fabric_pld_pma_hclk_reg_col] > 0 && [get_collection_size $pld_rx_clk1_rowclk_reg_clk] > 0} {
    set_false_path -from $aib_fabric_pld_pma_hclk_reg_col -to $pld_rx_clk1_rowclk_reg_clk
  }

if {[get_collection_size $aib_fabric_pld_pma_hclk_reg_col] > 0} {
   set_false_path -to $aib_fabric_pld_pma_hclk_reg_col
}

##-----------------------------------------------------------------------------------------------##
##----  frequency dependent clock min pulse width violations                                 ----##
##----  solution: disable min pulse width check to that specific node                        ----##
##-----------------------------------------------------------------------------------------------##
set tx_pma_aib_clk_reg_col_minpulse [get_registers -nowarn *hdpldadapt_tx_chnl*~aib_fabric_pma_aib_tx_clk.reg]
set tx_pma_aib_clk_reg_col_minpulse [add_to_collection $tx_pma_aib_clk_reg_col_minpulse [get_registers -nowarn *xtxdatapath_tx*~aib_fabric_tx_transfer_clk.reg]]
 if {[get_collection_size $tx_pma_aib_clk_reg_col_minpulse] > 0} {
         disable_min_pulse_width $tx_pma_aib_clk_reg_col_minpulse
 }

set rx_transfer_clk_reg_col_minpulse [get_registers -nowarn *hdpldadapt_rx_chnl*~aib_fabric_rx_transfer_clk.reg]
 if {[get_collection_size $rx_transfer_clk_reg_col_minpulse] > 0} {
         disable_min_pulse_width $rx_transfer_clk_reg_col_minpulse
 }

##set tx_user_clk_reg_col [get_pins -compatibility_mode -nowarn *hdpldadapt_tx_chnl_*aib_fabric_pld_pma_clkdiv_tx_user]
## if {[get_collection_size $tx_user_clk_reg_col] > 0} {
##         disable_min_pulse_width $tx_user_clk_reg_col
## }
##
#
##-----------------------------------------------------------------------------------------------##
##----  RX de-skew reset resync false paths                                                   ----##
##-----------------------------------------------------------------------------------------------##
set rx_dsk_rst_resync_din_s1 [get_registers -nowarn *directphy_rx_deskew.persys[*].per_rx_dsk_inst[*].U_rst_resync_inst|resync_chains[*].synchronizer_nocut|din_s1]
 if {[get_collection_size $rx_dsk_rst_resync_din_s1] > 0} {
     set_false_path -to $rx_dsk_rst_resync_din_s1
  }

##-----------------------------------------------------------------------------------------------##
##----  CSR Wrap reset resync false/loosen paths                                             ----##
##-----------------------------------------------------------------------------------------------##

set rst_rxpll_xfr_resync_din_s1 [get_registers -nowarn *dphy_sip_inst|dphy_avmm1_inst|*dphy_f_csr_wrap*|rx_enabled.rst_rxpll_xfr_sync_inst|resync_chains[*].synchronizer_nocut|din_s1]
 if {[get_collection_size $rst_rxpll_xfr_resync_din_s1] > 0} {
     set_false_path -to $rst_rxpll_xfr_resync_din_s1
  }

set rst_txpll_xfr_resync_din_s1 [get_registers -nowarn *dphy_sip_inst|dphy_avmm1_inst|*dphy_f_csr_wrap*|tx_enabled.rst_txpll_xfr_sync_inst|resync_chains[*].synchronizer_nocut|din_s1]
 if {[get_collection_size $rst_txpll_xfr_resync_din_s1] > 0} {
     set_false_path -to $rst_txpll_xfr_resync_din_s1
  }

set rst_resync_din_s1 [get_registers -nowarn *dphy_sip_inst|dphy_avmm1_inst|*dphy_f_csr_wrap*|reset_sync_inst|resync_chains[*].synchronizer_nocut|din_s1]
 if {[get_collection_size $rst_resync_din_s1] > 0} {
     set_multicycle_path  -end -to $rst_resync_din_s1 -setup 2
     set_false_path  -hold -to $rst_resync_din_s1
  }

##-----------------------------------------------------------------------------------------------##
##----  CCG cross clock false paths                                                          ----##
##-----------------------------------------------------------------------------------------------##
for {set i 0} {$i < $num_sys_cop} {incr i} {
     set raddr_g_completed [get_registers -nowarn $ip_inst_name|dphy_sip_inst|persystem[$i].ccg.ccg|raddr_g_completed*]
     set ccg_sr1_din_meta [get_registers -nowarn $ip_inst_name|dphy_sip_inst|persystem[$i].ccg.ccg|sr1|resync_chains*.synchronizer_nocut|din_s1]
     if {[get_collection_size $raddr_g_completed] > 0 && [get_collection_size $ccg_sr1_din_meta] > 0} {
       set_max_skew -from $raddr_g_completed -to $ccg_sr1_din_meta -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.8
        set_net_delay -from $raddr_g_completed -to $ccg_sr1_din_meta -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
        set_max_delay -from $raddr_g_completed -to $ccg_sr1_din_meta 100
        set_min_delay -from $raddr_g_completed -to $ccg_sr1_din_meta -100
     }
     
     
     set waddr_g_completed [get_registers -nowarn $ip_inst_name|dphy_sip_inst|persystem[$i].ccg.ccg|waddr_g_completed*]
     set ccg_sr0_din_meta [get_registers -nowarn $ip_inst_name|dphy_sip_inst|persystem[$i].ccg.ccg|sr0|resync_chains*.synchronizer_nocut|din_s1]
     if {[get_collection_size $waddr_g_completed] > 0 && [get_collection_size $ccg_sr0_din_meta] > 0} {
       set_max_skew -from $waddr_g_completed -to $ccg_sr0_din_meta -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.8
        set_net_delay -from $waddr_g_completed -to $ccg_sr0_din_meta -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
        set_max_delay -from $waddr_g_completed -to $ccg_sr0_din_meta 100
        set_min_delay -from $waddr_g_completed -to $ccg_sr0_din_meta -100
     }



     set rst_sync_tx_rd_clk_dreg [get_registers -nowarn $ip_inst_name|dphy_sip_inst|persystem[$i].ccg.ccg|rst_sync_tx_rd_clk|resync_chains[*].synchronizer_nocut|dreg[*]]
     set rst_sync_tx_rd_clk_dreg_clrn [get_pins -nowarn -compat $ip_inst_name|dphy_sip_inst|persystem[$i].ccg.ccg|rst_sync_tx_rd_clk|resync_chains[*].synchronizer_nocut|dreg[*]|clrn]
      if {[get_collection_size $rst_sync_tx_rd_clk_dreg_clrn] > 0 && [get_collection_size $rst_sync_tx_rd_clk_dreg] > 0} {
	  set_max_delay -through $rst_sync_tx_rd_clk_dreg_clrn -to $rst_sync_tx_rd_clk_dreg 100
	  set_min_delay -through $rst_sync_tx_rd_clk_dreg_clrn -to $rst_sync_tx_rd_clk_dreg -100
      }
	  
     set rst_sync_tx_rd_clk_din [get_registers -nowarn $ip_inst_name|dphy_sip_inst|persystem[$i].ccg.ccg|rst_sync_tx_rd_clk|resync_chains[*].synchronizer_nocut|din_s1]
     set rst_sync_tx_rd_clk_din_clrn [get_pins -nowarn -compat $ip_inst_name|dphy_sip_inst|persystem[$i].ccg.ccg|rst_sync_tx_rd_clk|resync_chains[*].synchronizer_nocut|din_s1|clrn]
      if {[get_collection_size $rst_sync_tx_rd_clk_din_clrn] > 0 && [get_collection_size $rst_sync_tx_rd_clk_din] > 0} {
	  set_max_delay -through $rst_sync_tx_rd_clk_din_clrn -to $rst_sync_tx_rd_clk_din 100
	  set_min_delay -through $rst_sync_tx_rd_clk_din_clrn -to $rst_sync_tx_rd_clk_din -100
      }

	  
     set rst_sync_tx_wr_clk_dreg [get_registers -nowarn $ip_inst_name|dphy_sip_inst|persystem[$i].ccg.ccg|rst_sync_tx_wr_clk|resync_chains[*].synchronizer_nocut|dreg[*]]
     set rst_sync_tx_wr_clk_dreg_clrn [get_pins -nowarn -compat $ip_inst_name|dphy_sip_inst|persystem[$i].ccg.ccg|rst_sync_tx_wr_clk|resync_chains[*].synchronizer_nocut|dreg[*]|clrn]
      if {[get_collection_size $rst_sync_tx_wr_clk_dreg_clrn] > 0 && [get_collection_size $rst_sync_tx_wr_clk_dreg] > 0} {
         set_max_delay -through $rst_sync_tx_wr_clk_dreg_clrn -to $rst_sync_tx_wr_clk_dreg 100
         set_min_delay -through $rst_sync_tx_wr_clk_dreg_clrn -to $rst_sync_tx_wr_clk_dreg -100
      }
	  
     set rst_sync_tx_wr_clk_din [get_registers -nowarn $ip_inst_name|dphy_sip_inst|persystem[$i].ccg.ccg|rst_sync_tx_wr_clk|resync_chains[*].synchronizer_nocut|din_s1]
     set rst_sync_tx_wr_clk_din_clrn [get_pins -nowarn -compat $ip_inst_name|dphy_sip_inst|persystem[$i].ccg.ccg|rst_sync_tx_wr_clk|resync_chains[*].synchronizer_nocut|din_s1|clrn]
      if {[get_collection_size $rst_sync_tx_wr_clk_din_clrn] > 0 && [get_collection_size $rst_sync_tx_wr_clk_din] > 0} {
	 set_max_delay -through $rst_sync_tx_wr_clk_din_clrn -to $rst_sync_tx_wr_clk_din 100
	 set_min_delay -through $rst_sync_tx_wr_clk_din_clrn -to $rst_sync_tx_wr_clk_din -100
      }




}





