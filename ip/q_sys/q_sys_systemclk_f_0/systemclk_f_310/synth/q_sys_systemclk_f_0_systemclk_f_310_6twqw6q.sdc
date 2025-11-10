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

## The SDC is added as a ENTITY_SDC_FILE, hence paths are relative to the ip_inst_name this is associated with
set ip_inst_name [get_current_instance]


foreach_in_collection node1 [get_nodes $ip_inst_name|x_sip|gen_systempll[0].enabled.ctrl_pll_aibrc_clock_top__pll_slice1_clk_sdc|clk] {
    foreach edge [get_node_info -synch_edges $node1] {
        set clk_name  [get_node_info -name [get_edge_info -src $edge]]
        set freq [expr 390625000 / 1000000.0]
        create_clock -period "$freq MHz" -name $clk_name $clk_name
    }
}









