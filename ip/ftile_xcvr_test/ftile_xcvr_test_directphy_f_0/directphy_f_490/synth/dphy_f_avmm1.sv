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
module dphy_f_avmm1 #(
    parameter          num_sys_cop                                              = 1,
    parameter   [4:0]  num_xcvr_per_sys                                         = 1,
    parameter          l_num_aib_per_xcvr                                       = 1,
    parameter   [4:0]  l_sys_aibs                                               = 1,
    parameter          l_tx_enable                                              = 1,
    parameter          l_rx_enable                                              = 1,
    parameter          fec_enable                                               = 1'b0,
    parameter          l_soft_csr_enable                                        = 0,
    parameter [11:0]   l_line_rate_p1ghz                                        = 12'd250,
    parameter          xcvr_type                                                = 1'b0,
    parameter          modulation_type                                          = 1'b0,
    parameter          avmm1_split                                              = 0,
    parameter          avmm1_readdv_enable                                      = 0,
    parameter          l_av1_enable                                             = 0,
    parameter          l_av1_aib_enable                                         = 0,
    parameter          l_num_avmm1                                              = 1,
    parameter          l_av1_ifaces                                             = 1,
    parameter          l_av1_addr_bits                                          = 14,
    parameter          DATA_WIDTH                                               = 32
    ) (  

  input   [l_av1_ifaces-1:0]                  reconfig_pdp_clk,         //   reconfig_pdp_clk.clk
  input   [l_av1_ifaces-1:0]                  reconfig_pdp_reset,       // reconfig_pdp_reset.reset
  input   [l_av1_ifaces-1:0]                  reconfig_pdp_write,       //  reconfig_pdp_avmm.write
  input   [l_av1_ifaces-1:0]                  reconfig_pdp_read,        //                   .read
  input   [l_av1_addr_bits*l_av1_ifaces-1:0]  reconfig_pdp_address,     //                   .address
  input   [l_av1_ifaces*DATA_WIDTH/8-1:0]     reconfig_pdp_byteenable,  //                   .byteenable
  input   [l_av1_ifaces*DATA_WIDTH-1:0]       reconfig_pdp_writedata,   //                   .writedata
  output  [l_av1_ifaces*DATA_WIDTH-1:0]       reconfig_pdp_readdata,    //                   .readdata
  output  [l_av1_ifaces-1:0]                  reconfig_pdp_waitrequest, //                   .waitrequest
  output  [l_av1_ifaces-1:0]                  reconfig_pdp_readdatavalid, //                 .readdatavalid

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

  // ctrl and status signals
  output   [num_sys_cop-1:0]                     dphy_reset_soft_tx_rst,
  output   [num_sys_cop-1:0]                     dphy_reset_soft_rx_rst,
  output   [num_sys_cop-1:0]                     dphy_reset_tx_rst_ovr,
  output   [num_sys_cop-1:0]                     dphy_reset_rx_rst_ovr,
  input    [num_sys_cop-1:0]                     dphy_reset_status_tx_rst_ack_n_i,
  input    [num_sys_cop-1:0]                     dphy_reset_status_rx_rst_ack_n_i,
  input    [num_sys_cop-1:0]                     dphy_reset_status_tx_ready_i,
  input    [num_sys_cop-1:0]                     dphy_reset_status_rx_ready_i,
  input    [num_sys_cop*num_xcvr_per_sys-1:0]    phy_tx_pll_locked_tx_pll_locked_i,
  input    [num_sys_cop*num_xcvr_per_sys-1:0]    phy_rx_cdr_locked_rx_cdr_locked_i,
  input    [num_sys_cop*num_xcvr_per_sys-1:0]    phy_rx_cdr_locked_rx_cdr_locked2data_i,
  output   [num_sys_cop-1:0]                     src_ctrl_rx_ignore_locked2data,
  output   [num_sys_cop-1:0] 					 reset_swcwbin,
  input    [num_sys_cop*32-1:0] 			     cwbin0_stat_block_A_i,
  input    [num_sys_cop*32-1:0] 				 cwbin1_stat_block_A_i,
  input    [num_sys_cop*32-1:0] 				 cwbin2_stat_block_A_i,
  input    [num_sys_cop*32-1:0] 				 cwbin3_stat_block_A_i,
  input    [num_sys_cop*32-1:0] 				 cwbin0_stat_block_B_i,
  input    [num_sys_cop*32-1:0] 			     cwbin1_stat_block_B_i,
  input    [num_sys_cop*32-1:0] 			     cwbin2_stat_block_B_i,
  input    [num_sys_cop*32-1:0] 				 cwbin3_stat_block_B_i,
  output   [num_sys_cop*32-1:0]					 cwbin_timer_timeout

);




  //\TODO  TEMPORARILY COPIED FUNCTION UNTIL TILE_IP HANDLES PACKAGES PROPERLY
    localparam integer MAX_CHARS_ALT_XCVR_NATIVE_S10 = 86; // To accomodate LONG parameter lists.
  ////////////////////////////////////////////////////////////////////
  // Convert an integer to a string
  function [MAX_CHARS_ALT_XCVR_NATIVE_S10*8-1:0] int2str_alt_xcvr_native_s10(
    input integer in_int
  );
    integer i;
    integer this_char;
    i = 0;
    int2str_alt_xcvr_native_s10 = "";
    do
    begin
      this_char = (in_int % 10) + 48;
      int2str_alt_xcvr_native_s10[i*8+:8] = this_char[7:0];
      i=i+1;
      in_int = in_int / 10; 
    end
    while(in_int > 0);
  endfunction

    localparam integer MAX_BIT_MASK_LENTGH = 32; 
  ////////////////////////////////////////////////////////////////////
  //  Count previouly marked bits before index 
  function integer pre_marked_count_dphy_f(
    input bit [MAX_BIT_MASK_LENTGH-1:0] bit_mask,
    input integer index
  );
    pre_marked_count_dphy_f = 0;
    for (integer i = 0; i<index; i++) if (bit_mask[i]) pre_marked_count_dphy_f = pre_marked_count_dphy_f + 1;
  endfunction

localparam  AV1_UNIT_AW = 14;       // AVMM1 user unit interface word Address Width    
localparam  ifs_psys    = (!avmm1_split)? 1 : (l_av1_aib_enable)? num_xcvr_per_sys*l_num_aib_per_xcvr : (fec_enable)? 1 : num_xcvr_per_sys ;
localparam  aib_pif     = (!avmm1_split)? num_xcvr_per_sys*l_num_aib_per_xcvr: (l_av1_aib_enable)? 1 :
                          (fec_enable)? num_xcvr_per_sys*l_num_aib_per_xcvr : l_num_aib_per_xcvr ;
localparam  ch_sel_bits = l_av1_addr_bits-AV1_UNIT_AW;
// to calculate number of enabled and disabled aibs per system
localparam  num_aib_ena_pif = (l_av1_aib_enable)? aib_pif : 1;
localparam  num_aib_dis_pif = aib_pif - num_aib_ena_pif;
localparam  BE_WIDTH    = DATA_WIDTH/8;
localparam  [15:0] aib_used_flag = (l_av1_aib_enable)? 16'hffff : (fec_enable)? 16'h0001 : (l_num_aib_per_xcvr==4)? 16'h1111 : (l_num_aib_per_xcvr==2)? 16'h5555 : 16'hffff;
localparam  [1:0] duplex_mode = (l_tx_enable)? ( l_rx_enable? 2'b11: 2'b10) : (l_rx_enable? 2'b01 : 2'b00);


wire    [DATA_WIDTH-1:0]      m32_mux_readdata    [l_av1_ifaces-1:0];
wire    [l_av1_ifaces-1:0]    m32_mux_waitrequest;
wire    [l_av1_ifaces-1:0]    m32_mux_readdatavalid;

logic   [num_sys_cop-1:0]     soft_csr_select;
logic   [num_sys_cop-1:0]     soft_csr_select_reg;
wire    [DATA_WIDTH-1:0]      soft_csr_readdata    [num_sys_cop-1:0];
wire    [num_sys_cop-1:0]     soft_csr_readdatavalid;
wire    [num_sys_cop-1:0]     soft_csr_waitrequest;

logic   [l_av1_ifaces-1:0]    m32_maib_select;
logic   [l_av1_ifaces-1:0]    m32_gdr_select;

reg     [num_sys_cop-1:0]     dphy_reset_rx_rst_ovr_reg = 'h0;

wire    [l_av1_ifaces-1:0]    m32_read;
wire    [l_av1_ifaces-1:0]    m32_write;
wire    [DATA_WIDTH-1:0]      m32_writedata   [l_av1_ifaces-1:0];
wire    [DATA_WIDTH-1:0]      m32_readdata    [l_av1_ifaces-1:0];
wire    [l_av1_ifaces-1:0]    m32_waitrequest;
wire    [l_av1_ifaces-1:0]    m32_readdatavalid;
wire    [l_av1_addr_bits-1:0] m32_address     [l_av1_ifaces-1:0];
wire    [l_av1_addr_bits+2:0] m32_address_exp [l_av1_ifaces-1:0];  // add bit [16, 1:0] for physical(expanded) addr
wire    [3:0]                 m32_byteenable  [l_av1_ifaces-1:0];


wire    [l_av1_ifaces-1:0]    m8_read;
wire    [l_av1_ifaces-1:0]    m8_write;
wire    [7:0]                 m8_writedata   [l_av1_ifaces-1:0];
wire    [7:0]                 m8_readdata    [l_av1_ifaces-1:0];
wire    [l_av1_ifaces-1:0]    m8_waitrequest;
wire    [l_av1_addr_bits+3:0] m8_addr        [l_av1_ifaces-1:0];  // from coverter, as <Dword Access>, <ch_sel>, [16:0]
wire    [l_av1_ifaces-1:0]    m8_addr_av1_b9 ;                    // maib indication
wire    [l_av1_ifaces-1:0]    m8_addr_av1_b8 ;                    // maib or Dworad Access indication
wire    [l_av1_addr_bits+4:0] m8_addr_av1    [l_av1_ifaces-1:0];  // arranged as <ch_sel>, [16:8] <maib> <maib/da>, [7:0]


genvar ig, ifs_idx, aib_idx;
generate
  if (l_av1_enable) begin:av1_ena
    for(ig=0;ig<num_sys_cop;ig=ig+1) begin: av1_sys 
      for (ifs_idx=0; ifs_idx<ifs_psys; ifs_idx=ifs_idx+1) begin: av1_ifs
	localparam  av1_idx     = (ig*ifs_psys+ifs_idx)*aib_pif;
	localparam  av1_dis_idx = av1_idx + num_aib_ena_pif;
	localparam  sys_ifs_idx = ig*ifs_psys + ifs_idx;
	// per xcvr read/write signals for soft csr and avmm port
	wire [aib_pif-1:0] ch_write, ch_read, ch_waitrequest;
	wire [aib_pif-1:0] [7:0] ch_readdata;

	assign reconfig_pdp_readdata[sys_ifs_idx*DATA_WIDTH+:DATA_WIDTH] = m32_mux_readdata[sys_ifs_idx];

        assign reconfig_pdp_waitrequest[sys_ifs_idx]  = m32_mux_waitrequest[sys_ifs_idx];
	assign reconfig_pdp_readdatavalid[sys_ifs_idx]= m32_mux_readdatavalid[sys_ifs_idx];
        assign m32_read[sys_ifs_idx]         = reconfig_pdp_read[sys_ifs_idx];
        assign m32_write[sys_ifs_idx]        = reconfig_pdp_write[sys_ifs_idx];
        assign m32_address[sys_ifs_idx]      = reconfig_pdp_address[sys_ifs_idx*l_av1_addr_bits+:l_av1_addr_bits];
        assign m32_byteenable[sys_ifs_idx]   = reconfig_pdp_byteenable[sys_ifs_idx*BE_WIDTH+:BE_WIDTH];
        assign m32_writedata[sys_ifs_idx]    = reconfig_pdp_writedata[sys_ifs_idx*DATA_WIDTH+:DATA_WIDTH];


       // soft csr, only the 1st interface in a system has the soft CSR
	if (l_soft_csr_enable && (ifs_idx==0)) begin : w_scsr  
            assign m32_mux_waitrequest[sys_ifs_idx]   = (soft_csr_select[ig])? soft_csr_waitrequest[ig] : m32_waitrequest[sys_ifs_idx];
            assign m32_mux_readdatavalid[sys_ifs_idx] = ((avmm1_readdv_enable)? soft_csr_select_reg[ig] : soft_csr_select[ig])? soft_csr_readdatavalid[ig] : m32_readdatavalid[sys_ifs_idx];
            assign m32_mux_readdata[sys_ifs_idx]      = ((avmm1_readdv_enable)? soft_csr_select_reg[ig] : soft_csr_select[ig])? soft_csr_readdata[ig] : m32_readdata[sys_ifs_idx];

            always_comb begin
                soft_csr_select[ig]     = 1'b0;
		m32_maib_select[sys_ifs_idx] = 1'b0;
		m32_gdr_select[sys_ifs_idx]  = 1'b0;
		case (m32_address_exp[sys_ifs_idx][16:0]) inside 
                    [17'h00400:17'h007ff] : begin
			 if (l_av1_aib_enable) m32_maib_select[sys_ifs_idx] = 1'b1;
		       	 m32_gdr_select[sys_ifs_idx]  = 1'b1;
	            end
                    [17'h00800:17'h00fff] : soft_csr_select[ig] = 1'b1;
	            default: m32_gdr_select[sys_ifs_idx]  = 1'b1;
		endcase;
	    end

            always_ff @(posedge reconfig_pdp_clk[sys_ifs_idx]) begin
                soft_csr_select_reg[ig] <= soft_csr_select[ig];
	    end

            dphy_f_csr_wrap # (
               .enable_readdv              (avmm1_readdv_enable),
               .line_rate_p1ghz            (l_line_rate_p1ghz),
               .xcvr_type                  (xcvr_type),
               .modulation_type            (modulation_type),
               .num_xcvr                   (num_xcvr_per_sys),
               .num_aib                    (l_num_aib_per_xcvr*num_xcvr_per_sys),
               .fec_enable                 (fec_enable),
               .duplex_mode                (duplex_mode)  
               ) dphy_f_csr_wrap_inst (
               .dphy_reset_soft_tx_rst                             (dphy_reset_soft_tx_rst[ig]),
               .dphy_reset_soft_rx_rst                             (dphy_reset_soft_rx_rst[ig]),
               .dphy_reset_tx_rst_ovr                              (dphy_reset_tx_rst_ovr[ig]),
               .dphy_reset_rx_rst_ovr                              (dphy_reset_rx_rst_ovr[ig]),
               .dphy_reset_status_tx_rst_ack_n_i                   (dphy_reset_status_tx_rst_ack_n_i[ig]),
               .dphy_reset_status_rx_rst_ack_n_i                   (dphy_reset_status_rx_rst_ack_n_i[ig]),
               .dphy_reset_status_tx_ready_i                       (dphy_reset_status_tx_ready_i[ig]),
               .dphy_reset_status_rx_ready_i                       (dphy_reset_status_rx_ready_i[ig]),
               .dphy_reset_status_avmm_ready_i                     (~pld_avmm1_busy[av1_idx]),
               .phy_tx_pll_locked_tx_pll_locked_i                  (phy_tx_pll_locked_tx_pll_locked_i[ig*num_xcvr_per_sys+:num_xcvr_per_sys]),
               .phy_rx_cdr_locked_rx_cdr_locked_i                  (phy_rx_cdr_locked_rx_cdr_locked_i[ig*num_xcvr_per_sys+:num_xcvr_per_sys]),
	           .phy_rx_cdr_locked_rx_cdr_locked2data_i         (phy_rx_cdr_locked_rx_cdr_locked2data_i[ig*num_xcvr_per_sys+:num_xcvr_per_sys]),
               .src_ctrl_rx_ignore_locked2data                     (src_ctrl_rx_ignore_locked2data[ig]),
               .clk                                                (reconfig_pdp_clk[sys_ifs_idx]),
               .reset                                              (reconfig_pdp_reset[sys_ifs_idx]),
               .writedata                                          (m32_writedata[sys_ifs_idx]),
               .read                                               (m32_read[sys_ifs_idx] & soft_csr_select[ig]),
               .write                                              (m32_write[sys_ifs_idx] & soft_csr_select[ig]),
               .byteenable                                         (m32_byteenable[sys_ifs_idx]),
               .readdata                                           (soft_csr_readdata[ig]),
               .readdatavalid                                      (soft_csr_readdatavalid[ig]),
               .waitrequest                                        (soft_csr_waitrequest[ig]),
               .address                                            ({m32_address[sys_ifs_idx][9:0], 2'b00}),
               .reset_swcwbin                              	   (reset_swcwbin[ig]),
	       .cwbin0_stat_block_A_i	                           (cwbin0_stat_block_A_i[ig*32+:32]),
	       .cwbin1_stat_block_A_i		                   (cwbin1_stat_block_A_i[ig*32+:32]),
	       .cwbin2_stat_block_A_i		                   (cwbin2_stat_block_A_i[ig*32+:32]),
	       .cwbin3_stat_block_A_i		                   (cwbin3_stat_block_A_i[ig*32+:32]),
	       .cwbin0_stat_block_B_i			           (cwbin0_stat_block_B_i[ig*32+:32]),
	       .cwbin1_stat_block_B_i	                           (cwbin1_stat_block_B_i[ig*32+:32]),
	       .cwbin2_stat_block_B_i	                           (cwbin2_stat_block_B_i[ig*32+:32]),
	       .cwbin3_stat_block_B_i		                   (cwbin3_stat_block_B_i[ig*32+:32]),
               .cwbin_timer_timeout				   (cwbin_timer_timeout[ig*32+:32])			   

                );
	    // TODO : coonect ports, parameter, and data/valid, waitrequest
	    // back to main I/F
	end   else begin : no_scsr
            assign m32_maib_select[sys_ifs_idx] = ( l_av1_aib_enable && (m32_address_exp[sys_ifs_idx][16:0] >= 17'h00400) && (m32_address_exp[sys_ifs_idx][16:0]<=17'h007ff) )? 1'b1 : 1'b0;
	    assign m32_gdr_select[sys_ifs_idx] = 1'b1;
            assign m32_mux_waitrequest[sys_ifs_idx]   =  m32_waitrequest[sys_ifs_idx];
            assign m32_mux_readdatavalid[sys_ifs_idx] =  m32_readdatavalid[sys_ifs_idx];
            assign m32_mux_readdata[sys_ifs_idx]      =  m32_readdata[sys_ifs_idx];
	end

	// 32 to 8 conversion
        ft_avmm_32to8_bridge 
             #(   .ADDR_WIDTH ( l_av1_addr_bits+1 ),  // expand to 17-bit physical address
	          .READ_PIPELINE_ENABLE ( avmm1_readdv_enable )
	  )
          avmm_32to8_inst (
           // AVMM slave Port
           .i_clk                   ( reconfig_pdp_clk[sys_ifs_idx] ), 
           .i_rst                   ( reconfig_pdp_reset[sys_ifs_idx] ),
           
           .i_avmm_s32_addr         ( m32_address_exp[sys_ifs_idx][l_av1_addr_bits+2:2] ),  
           .i_avmm_s32_wdata        ( m32_writedata[sys_ifs_idx] ), 
           .i_avmm_s32_write        ( m32_write[sys_ifs_idx] & m32_gdr_select[sys_ifs_idx] ), 
           .i_avmm_s32_read         ( m32_read[sys_ifs_idx] & m32_gdr_select[sys_ifs_idx] ), 
           .i_avmm_s32_byte_enable  ( m32_byteenable[sys_ifs_idx] ),
           .o_avmm_s32_readdata     ( m32_readdata[sys_ifs_idx] ), 
           .o_avmm_s32_waitrequest  ( m32_waitrequest[sys_ifs_idx] ),
           .o_avmm_s32_readdatavalid( m32_readdatavalid[sys_ifs_idx] ),

           // Master Port
           .o_avmm_m8_addr          ( m8_addr[sys_ifs_idx] ),
           .o_avmm_m8_wdata         ( m8_writedata[sys_ifs_idx] ), 
           .o_avmm_m8_write         ( m8_write[sys_ifs_idx] ), 
           .o_avmm_m8_read          ( m8_read[sys_ifs_idx] ), 
           .i_avmm_m8_readdata      ( m8_readdata[sys_ifs_idx] ), 
           .i_avmm_m8_waitrequest   ( m8_waitrequest[sys_ifs_idx] )   
          );
	
        // form the address to avmm1 ports	  
	assign m8_addr_av1_b9[sys_ifs_idx]  = (l_av1_aib_enable & m32_maib_select[sys_ifs_idx])? 1'b1 : 1'b0;
	assign m8_addr_av1_b8[sys_ifs_idx]  = (l_av1_aib_enable)? (m32_maib_select[sys_ifs_idx] | m8_addr[sys_ifs_idx][l_av1_addr_bits+3]) :
	                                      m8_addr[sys_ifs_idx][l_av1_addr_bits+3];

        //  expand the avmm1 address to 17-bit for each AIB I/F from 14 bit 
	//  form maib pld_avmm1_addr
	//  decoding multi-aib 
        if (ch_sel_bits==0)  begin: sin
            assign m8_addr_av1[sys_ifs_idx] = {m8_addr[sys_ifs_idx][16:8], m8_addr_av1_b9[sys_ifs_idx], m8_addr_av1_b9[sys_ifs_idx], m8_addr[sys_ifs_idx][7:0]};
	    assign m32_address_exp[sys_ifs_idx] = {1'b0,m32_address[sys_ifs_idx], 2'b00};
	    assign ch_write     [0]                          = m8_write[sys_ifs_idx];
            assign ch_read      [0]                          = m8_read[sys_ifs_idx] ;
	    assign m8_readdata[sys_ifs_idx]                  = ch_readdata[0];
	    assign m8_waitrequest[sys_ifs_idx]               = ch_waitrequest[0];
	end   else begin: mul
            wire [ch_sel_bits-1:0]             ch_sel;
            assign m32_address_exp[sys_ifs_idx] = {m32_address[sys_ifs_idx][l_av1_addr_bits-1:AV1_UNIT_AW], 1'b0, m32_address[sys_ifs_idx][AV1_UNIT_AW-1:0], 2'b00};
            assign m8_addr_av1[sys_ifs_idx] = {m8_addr[sys_ifs_idx][l_av1_addr_bits+2-:ch_sel_bits], m8_addr[sys_ifs_idx][16:8], m8_addr_av1_b9[sys_ifs_idx], m8_addr_av1_b8[sys_ifs_idx], m8_addr[sys_ifs_idx][7:0]};
	    assign ch_sel  = m8_addr_av1[sys_ifs_idx][l_av1_addr_bits+4-:ch_sel_bits];
	    assign m8_readdata[sys_ifs_idx]                  = ch_readdata[ch_sel];
	    assign m8_waitrequest[sys_ifs_idx]               = ch_waitrequest[ch_sel];

	    for (aib_idx=0;aib_idx<aib_pif; aib_idx=aib_idx+1) begin: g_ch
	        localparam used_ch = pre_marked_count_dphy_f(.bit_mask(aib_used_flag), .index(aib_idx)); 
	        if (aib_used_flag[aib_idx]) begin: ch_en
	            assign ch_write     [used_ch]                   =  m8_write[sys_ifs_idx] & (ch_sel == used_ch);
                    assign ch_read      [used_ch]                   =  m8_read[sys_ifs_idx]  & (ch_sel == used_ch);
	        end
            end
	end     // mul
	
	// connect to avmm1 port soft logic 
	for (aib_idx=0;aib_idx<aib_pif; aib_idx=aib_idx+1) begin: g_aib
	    localparam used_ch = pre_marked_count_dphy_f(.bit_mask(aib_used_flag), .index(aib_idx)); 
	    localparam av1_cur_idx = av1_idx + aib_idx;
            if (aib_used_flag[aib_idx]) begin: g_aib_en
                ctfb_avmm1_soft_logic
                #(  .avmm_interfaces(1),                                    //Number of AVMM interfaces required - one for each AIB Adapter
                    .rcfg_enable (l_av1_enable)                             //Enable/disable reconfig interface 
                 ) avmm1_ena_inst   (
                // AVMM slave interface signals (user)
                 .avmm_clk (reconfig_pdp_clk[sys_ifs_idx]) ,
                 .avmm_reset (reconfig_pdp_reset[sys_ifs_idx]),
                 .avmm_writedata (m8_writedata[sys_ifs_idx]), 
                 .avmm_address (m8_addr_av1[sys_ifs_idx][9:0]), 
                 .avmm_reservedin ( m8_addr_av1[sys_ifs_idx][18:10] ),   
                 .avmm_write (ch_write[used_ch]),
                 .avmm_read (ch_read[used_ch]),
                 .avmm_readdata (ch_readdata[used_ch]), 
                 .avmm_waitrequest (ch_waitrequest[used_ch]),
                   
                // Signals from AVMM1 building block
                 .pld_avmm1_busy_real             ( pld_avmm1_busy[av1_cur_idx] ),
                 .pld_avmm1_cmdfifo_wr_full_real  ( pld_avmm1_cmdfifo_wr_full[av1_cur_idx]  ),
                 .pld_avmm1_cmdfifo_wr_pfull_real ( pld_avmm1_cmdfifo_wr_pfull[av1_cur_idx] ),
                 .pld_avmm1_readdata_real         ( pld_avmm1_readdata[av1_cur_idx*8+:8]     ),
                 .pld_avmm1_readdatavalid_real    ( pld_avmm1_readdatavalid[av1_cur_idx]    ),
                 .pld_avmm1_reserved_out_real     ( pld_avmm1_reserved_out[av1_cur_idx*3+:3] ),
                 .pld_chnl_cal_done_real          ( pld_chnl_cal_done[av1_cur_idx]  ),        
                 .pld_hssi_osc_transfer_en_real   ( pld_hssi_osc_transfer_en[av1_cur_idx]   ),
                // Signals to AVMM1 building block
                 .pld_avmm1_clk_rowclk_real       ( pld_avmm1_clk_rowclk[av1_cur_idx] ),
                 .pld_avmm1_read_real             ( pld_avmm1_read[av1_cur_idx] ),
                 .pld_avmm1_reg_addr_real         ( pld_avmm1_reg_addr[av1_cur_idx*10+:10] ),
                 .pld_avmm1_request_real          ( pld_avmm1_request[av1_cur_idx] ),
                 .pld_avmm1_reserved_in_real      ( pld_avmm1_reserved_in[av1_cur_idx*9+:9] ),
                 .pld_avmm1_write_real            ( pld_avmm1_write[av1_cur_idx] ),
                 .pld_avmm1_writedata_real        ( pld_avmm1_writedata[av1_cur_idx*8+:8] )

                );
	    end   else begin: g_aib_dis
                ctfb_avmm1_soft_logic
                #(  .avmm_interfaces(1),                                    //Number of AVMM interfaces required - one for each AIB Adapter
                    .rcfg_enable (1'b0)                                     //Enable/disable reconfig interface 
                ) avmm1_dis_inst1   (
               // AVMM slave interface signals (user)
                .avmm_clk (1'b0) ,
                .avmm_reset (1'b0 ),
                .avmm_writedata (8'h0), 
                .avmm_address (10'h0), 
                .avmm_reservedin ( 9'h0 ),
                .avmm_write (1'b0),
                .avmm_read (1'b0),
                .avmm_readdata (), 
                .avmm_waitrequest (),

               // Signals from AVMM1 building block
                .pld_avmm1_busy_real             ( 1'b0 ),
                .pld_avmm1_cmdfifo_wr_full_real  ( 1'b0 ),
                .pld_avmm1_cmdfifo_wr_pfull_real ( 1'b0 ),
                .pld_avmm1_readdata_real         ( 8'h0 ),
                .pld_avmm1_readdatavalid_real    ( 1'b0 ),
                .pld_avmm1_reserved_out_real     ( 3'h0 ),
                .pld_chnl_cal_done_real          ( 1'b0 ),
                .pld_hssi_osc_transfer_en_real   ( 1'b0 ),
               // Signals to AVMM1 building block
                .pld_avmm1_clk_rowclk_real       ( pld_avmm1_clk_rowclk[av1_cur_idx] ),
                .pld_avmm1_read_real             ( pld_avmm1_read[av1_cur_idx] ),
                .pld_avmm1_reg_addr_real         ( pld_avmm1_reg_addr[av1_cur_idx*10+:10] ),
                .pld_avmm1_request_real          ( pld_avmm1_request[av1_cur_idx] ),
                .pld_avmm1_reserved_in_real      ( pld_avmm1_reserved_in[av1_cur_idx*9+:9] ),
                .pld_avmm1_write_real            ( pld_avmm1_write[av1_cur_idx] ),
                .pld_avmm1_writedata_real        ( pld_avmm1_writedata[av1_cur_idx*8+:8] )
               );
	    end

        end   // g_aib

      end  // av1_ifs
    end   // av1_sys
  end   // av1_ena
  else begin:av1_dis
      assign  reconfig_pdp_readdata        = 'h0;
      assign  reconfig_pdp_waitrequest     = 'h0;
      assign  reconfig_pdp_readdatavalid   = 'h0;
      assign  pld_avmm1_clk_rowclk         = 'h0;
      assign  pld_avmm1_read               = 'h0;
      assign  pld_avmm1_reg_addr           = 'h0;
      assign  pld_avmm1_request            = 'h0;
      assign  pld_avmm1_reserved_in        = 'h0;
      assign  pld_avmm1_write              = 'h0;
      assign  pld_avmm1_writedata          = 'h0; 
  end                                      
                                           
    if (!l_av1_enable || !l_soft_csr_enable ) begin: g_nocsr
        assign  dphy_reset_soft_tx_rst = 'h0; 
        assign  dphy_reset_soft_rx_rst = 'h0; 
        assign  dphy_reset_tx_rst_ovr  = 'h0; 
        assign  dphy_reset_rx_rst_ovr  = dphy_reset_rx_rst_ovr_reg; 

        assign  src_ctrl_rx_ignore_locked2data = 'h0; 
    end

endgenerate

    
 

endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "8qH9cVo09pAnWALEE6z2BDKrWVWnFI5Ou7hormZ79E/tGSVBCgNfmxFQvE9t3s7klXY5XdvnpByaQgBfCHF6Dbm9WN2svsxXF/zx5b/8CDkcUDB41PZNmNdUWNx7xDY3xJ7IgPTPwkMgtDelSr2aywj5LSl0zROc68MOmTBSsO9a1S9TDRa9h5E5qBo+fLmPNkMltB0gOqPF4aO4OqQAye1NWS4OsbZ9+NLF8RRMveDIeZQ0Noni7MY0lt/5qVyLdH42tdWqt3C80GGeBz9PaQcQihAmlxgN8h90v9sXuOjp2S5CxpYxx8BYhS5YuxsRXuhZ7UGLfukMYF2Dn5gucPze+mJc8tTHH43+h2h/XNLlJ4X9QeSsiiM338O2Qyx9dHILmy4Eq7iyfVdnkCpJjKKbRrzBsOSE5szpKKsUZDxnUc6QaOymOonE9HyXHVU7o7qrhnNhPgClAMn8sYr+lH5KMT0d5sWKM+5k2EnvPLgbDEaBLnomluGX+WvklDJI/+m7QiUxQj9Ivr3vIOjIOrpOD2GPYnDgxmzC5hfGKSmXuCgnXw9d2h0juL0zdtAqjP2IiDkVB8kXbwnW1nDW1JIhEYpwhGKe14GOb4yO1I/69KYPmJGRvuIPN0dS20R6if/NB2OfqpBeamKIiMooZ9WWnDVawFfecs1/WBWmgHKC7DlKK1tbRPbs6H28FaPuBppeWKrndUdZKKqIJIwr6U8BXIf5O6YA1Dv/54eAbu54FG6iKxlzMxngMetFIp/4MGVxlPtOLOHWkrD9QrosqwuxGlkjtiT4C4RmthFJHrE0t4fpq55kmei8su4y+3omIrqHJb/ZW7hYMNnexMnweDrgWJ2fu/wQjHjpMUrqNWKNcLewP5MaQnG+9aJPtt2w6sIVPxgyo1Q4qu9XciGPtC6M5l5Ap54ioUcR75CQNRDVJzubaxB2ndDDowAaCPMmmuiHF2P1F9ssZVQXaHIcdt0ugzmxBTKWKkBG0m/hFNGlmhP5d9Ps2yFcIKQcmja/"
`endif