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
module dphy_f_avmm2 #(
    parameter          num_sys_cop                                              = 1,
    parameter          num_xcvr_per_sys                                         = 1,
    parameter          l_num_aib_per_xcvr                                       = 1,
    parameter          l_sys_xcvrs                                              = 1,
    parameter          l_tx_enable                                              = 1,
    parameter          l_rx_enable                                              = 1,
    parameter          avmm2_split                                              = 0,

    parameter          avmm2_readdv_enable                                      = 0,
    parameter          l_av2_enable                                             = 0,
    parameter          l_num_avmm2                                              = 1,
    parameter          l_av2_ifaces                                             = 1,
    parameter          l_av2_addr_bits                                          = 18,
    parameter          DATA_WIDTH                                               = 32

    ) (  

  input   [l_av2_ifaces-1:0]                  reconfig_clk,             //       reconfig_clk.clk
  input   [l_av2_ifaces-1:0]                  reconfig_reset,           //     reconfig_reset.reset
  input   [l_av2_ifaces-1:0]                  reconfig_write,           //      reconfig_avmm.write
  input   [l_av2_ifaces-1:0]                  reconfig_read,            //                   .read
  input   [l_av2_addr_bits*l_av2_ifaces-1:0]  reconfig_address,         //                   .address
  input   [l_av2_ifaces*4-1:0]                reconfig_byteenable,       //                   .byteenable
  input   [l_av2_ifaces*DATA_WIDTH-1:0]       reconfig_writedata,       //                   .writedata
  output  [l_av2_ifaces*DATA_WIDTH-1:0]       reconfig_readdata,        //                   .readdata
  output  [l_av2_ifaces-1:0]                  reconfig_waitrequest,     //                   .waitrequest
  output  [l_av2_ifaces-1:0]                  reconfig_readdatavalid,   //                   .readdatavalid

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
  input   wire  [l_num_avmm2-1:0]      pld_avmm2_reserved_out

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

localparam  ifs_psys    = (avmm2_split)? num_xcvr_per_sys : 1;
localparam  xcvr_pif    = (avmm2_split)? 1 : num_xcvr_per_sys;
localparam  ch_sel_bits = l_av2_addr_bits-18;
localparam  BE_WIDTH    = DATA_WIDTH/8;

wire    [l_av2_ifaces-1:0]    m32_read;
wire    [l_av2_ifaces-1:0]    m32_write;
wire    [DATA_WIDTH-1:0]      m32_writedata   [l_av2_ifaces-1:0];
wire    [DATA_WIDTH-1:0]      m32_readdata    [l_av2_ifaces-1:0];
wire    [l_av2_ifaces-1:0]    m32_waitrequest;
wire    [l_av2_ifaces-1:0]    m32_readdatavalid;
wire    [l_av2_addr_bits-1:0] m32_address     [l_av2_ifaces-1:0];
wire    [3:0]                 m32_byteenable  [l_av2_ifaces-1:0];

wire    [l_av2_ifaces-1:0]    m8_read;
wire    [l_av2_ifaces-1:0]    m8_write;
wire    [7:0]                 m8_writedata   [l_av2_ifaces-1:0];
wire    [7:0]                 m8_readdata    [l_av2_ifaces-1:0];
wire    [l_av2_ifaces-1:0]    m8_waitrequest;
wire    [l_av2_addr_bits+2:0] m8_addr        [l_av2_ifaces-1:0];  // from coverter, as <Dword Access>, <ch_sel>, [19:0]
wire    [l_av2_addr_bits+2:0] m8_addr_av2    [l_av2_ifaces-1:0];  // arranged as <ch_sel>, <Dword Access>,  [19:0]


genvar ig, ifs_idx, xcvr_idx;
generate
  if (l_av2_enable) begin: av2_ena
    for(ig=0;ig<num_sys_cop;ig=ig+1) begin: av2_sys 
      for (ifs_idx=0; ifs_idx<ifs_psys; ifs_idx=ifs_idx+1) begin: av2_ifs
	localparam  av2_idx     = ig*num_xcvr_per_sys+ifs_idx*xcvr_pif;
	localparam  sys_ifs_idx = ig*ifs_psys + ifs_idx;
	// per xcvr read/write signals for soft csr and avmm port
	wire [xcvr_pif-1:0] ch_write, ch_read, ch_waitrequest;
	wire [xcvr_pif-1:0] csr_write, csr_read, csr_waitrequest;
	wire [xcvr_pif-1:0] [7:0] ch_readdata, csr_readdata ;

	assign reconfig_readdata[sys_ifs_idx*DATA_WIDTH+:DATA_WIDTH] = m32_readdata[sys_ifs_idx];

        assign reconfig_waitrequest[sys_ifs_idx]  = m32_waitrequest[sys_ifs_idx];
        assign m32_read[sys_ifs_idx]         = reconfig_read[sys_ifs_idx];
        assign m32_write[sys_ifs_idx]        = reconfig_write[sys_ifs_idx];
        assign m32_address[sys_ifs_idx]      = reconfig_address[sys_ifs_idx*l_av2_addr_bits+:l_av2_addr_bits];
        assign m32_byteenable[sys_ifs_idx]   = reconfig_byteenable[sys_ifs_idx*BE_WIDTH+:BE_WIDTH];
        assign m32_writedata[sys_ifs_idx]    = reconfig_writedata[sys_ifs_idx*DATA_WIDTH+:DATA_WIDTH];
	assign reconfig_readdatavalid[sys_ifs_idx] = m32_readdatavalid[sys_ifs_idx];


    	    // 32 to 8 conversion
        ft_avmm_32to8_bridge 
             #(   .ADDR_WIDTH ( l_av2_addr_bits ),
	          .READ_PIPELINE_ENABLE ( avmm2_readdv_enable )
	     )
          avmm_32to8_inst (
           // AVMM slave Port
           .i_clk                   ( reconfig_clk[sys_ifs_idx] ), 
           .i_rst                   ( reconfig_reset[sys_ifs_idx] ),
           
           .i_avmm_s32_addr         ( m32_address[sys_ifs_idx] ),  
           .i_avmm_s32_wdata        ( m32_writedata[sys_ifs_idx] ), 
           .i_avmm_s32_write        ( m32_write[sys_ifs_idx] ), 
           .i_avmm_s32_read         ( m32_read[sys_ifs_idx] ), 
           .i_avmm_s32_byte_enable  ( m32_byteenable[sys_ifs_idx] ),
           .o_avmm_s32_readdata     ( m32_readdata[sys_ifs_idx] ), 
           .o_avmm_s32_waitrequest  ( m32_waitrequest[sys_ifs_idx] ),
           .o_avmm_s32_readdatavalid ( m32_readdatavalid[sys_ifs_idx] ),

           // Master Port
           .o_avmm_m8_addr          ( m8_addr[sys_ifs_idx] ),
           .o_avmm_m8_wdata         ( m8_writedata[sys_ifs_idx] ), 
           .o_avmm_m8_write         ( m8_write[sys_ifs_idx] ), 
           .o_avmm_m8_read          ( m8_read[sys_ifs_idx] ), 
           .i_avmm_m8_readdata      ( m8_readdata[sys_ifs_idx] ), 
           .i_avmm_m8_waitrequest   ( m8_waitrequest[sys_ifs_idx] )   
          );
	
        //  form the hip_avmm2_addr
	//  decoding multi-xcvr 
        if (ch_sel_bits==0)  begin: sin
             assign m8_addr_av2[sys_ifs_idx] = m8_addr[sys_ifs_idx] ;
	     assign ch_write     [0]                          = m8_write[sys_ifs_idx];
             assign ch_read      [0]                          = m8_read[sys_ifs_idx] ;
	     assign m8_readdata[sys_ifs_idx]                  = ch_readdata[0];
	     assign m8_waitrequest[sys_ifs_idx]               = ch_waitrequest[0];
	end   else begin: mul
             wire [ch_sel_bits-1:0]             ch_sel;
             assign m8_addr_av2[sys_ifs_idx] = {m8_addr[sys_ifs_idx][l_av2_addr_bits+1:20], m8_addr[sys_ifs_idx][l_av2_addr_bits+2], m8_addr[sys_ifs_idx][19:0]};

	     assign ch_sel  = m8_addr_av2[sys_ifs_idx][l_av2_addr_bits+2-:ch_sel_bits];

	     for(xcvr_idx=0;xcvr_idx<xcvr_pif; xcvr_idx=xcvr_idx+1) begin: g_xcvr
	             assign ch_write     [xcvr_idx]                   = m8_write[sys_ifs_idx] & (ch_sel == xcvr_idx);
                     assign ch_read      [xcvr_idx]                   = m8_read[sys_ifs_idx]  & (ch_sel == xcvr_idx);
             end

	     assign m8_readdata[sys_ifs_idx]                  = ch_readdata[ch_sel];
	     assign m8_waitrequest[sys_ifs_idx]               = ch_waitrequest[ch_sel];
	end     // mul

	// connect to avmm2 port soft logic 
        ctfb_avmm2_soft_logic
        #(  .avmm_interfaces       (xcvr_pif),                 //Number of AVMM ports required - one for each xcvr channel or PCIe HIP
            .rcfg_enable           (l_av2_enable)               //Enable/disable reconfig interface in the XCVR PMA or PCIe IPs
         ) avmm2_cl_inst   (
        // AVMM slave interface signals (user)
         .avmm_clk                 ( {xcvr_pif{reconfig_clk[sys_ifs_idx]}} ) ,
         .avmm_reset               ( {xcvr_pif{reconfig_reset[sys_ifs_idx]}} ),
         .avmm_writedata           ( {xcvr_pif{m8_writedata[sys_ifs_idx]}}), 
         .avmm_address             ( {xcvr_pif{m8_addr_av2[sys_ifs_idx][0+:21]}} ), 
         .avmm_write               ( ch_write ),
         .avmm_read                ( ch_read ),
         .avmm_readdata            ( ch_readdata ), 
         .avmm_waitrequest         ( ch_waitrequest ),
        //AVMM interface busy with calibration
         .avmm_busy (),
           
        // Expose clkchnl to wire up with pld_adapt avmmclk for Place and Route in Fitter
         .avmm_clkchnl (),

        // ports to/from hip ports of building block
         .hip_avmm_read_real             ( hip_avmm_read[av2_idx+:xcvr_pif] ),
         .hip_avmm_readdata_real         ( hip_avmm_readdata[av2_idx*8+:xcvr_pif*8] ),
         .hip_avmm_readdatavalid_real    ( hip_avmm_readdatavalid[av2_idx+:xcvr_pif] ),
         .hip_avmm_reg_addr_real         ( hip_avmm_reg_addr[av2_idx*21+:xcvr_pif*21] ),
         .hip_avmm_reserved_out_real     ( hip_avmm_reserved_out[av2_idx*5+:xcvr_pif*5] ),
         .hip_avmm_write_real            ( hip_avmm_write[av2_idx+:xcvr_pif] ),
         .hip_avmm_writedata_real        ( hip_avmm_writedata[av2_idx*8+:xcvr_pif*8] ),
         .hip_avmm_writedone_real        ( hip_avmm_writedone[av2_idx+:xcvr_pif] ),
         .pld_avmm2_busy_real            ( pld_avmm2_busy[av2_idx+:xcvr_pif] ),
         .pld_avmm2_clk_rowclk_real      ( pld_avmm2_clk_rowclk[av2_idx+:xcvr_pif] ),
         .pld_avmm2_cmdfifo_wr_full_real ( pld_avmm2_cmdfifo_wr_full[av2_idx+:xcvr_pif] ),
         .pld_avmm2_cmdfifo_wr_pfull_real( pld_avmm2_cmdfifo_wr_pfull[av2_idx+:xcvr_pif] ),
         .pld_avmm2_request_real         ( pld_avmm2_request[av2_idx+:xcvr_pif] ),
         .pld_pll_cal_done_real          ( pld_pll_cal_done[av2_idx+:xcvr_pif] ),
        // below are unused ports in hip mode
         .pld_avmm2_write_real           ( pld_avmm2_write[av2_idx+:xcvr_pif] ),
         .pld_avmm2_read_real            ( pld_avmm2_read[av2_idx+:xcvr_pif] ),
         .pld_avmm2_reg_addr_real        ( pld_avmm2_reg_addr[av2_idx*9+:xcvr_pif*9] ),
         .pld_avmm2_readdata_real        ( pld_avmm2_readdata[av2_idx*8+:xcvr_pif*8] ),
         .pld_avmm2_writedata_real       ( pld_avmm2_writedata[av2_idx*8+:xcvr_pif*8] ),
         .pld_avmm2_readdatavalid_real   ( pld_avmm2_readdatavalid[av2_idx+:xcvr_pif] ),
         .pld_avmm2_reserved_in_real     ( pld_avmm2_reserved_in[av2_idx*6+:xcvr_pif*6] ),
         .pld_avmm2_reserved_out_real    ( pld_avmm2_reserved_out[av2_idx+:xcvr_pif] )
         );


      end  // av2_ifs
    end   // av2_sys
  end   // av2_ena
  else begin: av2_dis
      assign  reconfig_readdata           = 'h0;
      assign  reconfig_waitrequest        = 'h0;
      assign  reconfig_readdatavalid      = 'h0;
      assign  hip_avmm_read               = 'h0;
      assign  hip_avmm_reg_addr           = 'h0;
      assign  hip_avmm_write              = 'h0;
      assign  hip_avmm_writedata          = 'h0; 
      assign  pld_avmm2_clk_rowclk        = 'h0;
      assign  pld_avmm2_request           = 'h0;
      assign  pld_avmm2_reserved_in       = 'h0;
      assign  pld_avmm2_read              = 'h0;
      assign  pld_avmm2_reg_addr          = 'h0;
      assign  pld_avmm2_write             = 'h0;
      assign  pld_avmm2_writedata         = 'h0; 
  end                                      
endgenerate

endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "GCmaWWfu8/z90U1Cmo5rPCMDlKlyM0GNy39hltItZu8hjp+ConPPnsllU0R3HQGDlHAZ73evWKdnQ3lDsZKXjvyxG/vMsJGlHhUjn18rLQtcWxIJVkzmz4DRGHUc79xjE5Ra6dXiFrovOM0nWa82j0WjiYv6AoXMP1ztF/irbbWTqsqUcTOLaKJT5ueWX0R9FbNv77cBFyzVTW5v/1dofdTWdWqd6lTx+9/Vzmh/0Y5IiDuDCkGWluY6KLX2FVw1RhvlN9ILhs/SSE7xzmUuGB/Snfo71Jp+hW74+KrEwY+n3lqNYMWDwsEM6bfoYtAhx76343Phz45P2wU0k48bQbUmkAuDK/EjUryzgT+IQiYh1GK67UumnVSPPGTyrdHzvqLQhSnbKbys4OYQXtsg4jYXpZDHzWRyQsMnFak5kxX5+/xI1mqi78FtLBgEKWYKMO7L/mbFsmZGBvX+ryy45Rk404FbzoHXU0/PBxotqQm0Y4QMjVxbvYzesQ4Q3xvHyl94X/i04xZSjgTUTXu6tvvMMbUD3MdQmwWY+yEwvVk3h5OYugYKmDudPy4uq0FdL33521V+NQWoVGk6P+zwVdef2OvvHRjr1+rSXsvSJFjCLupWI4biX2W+nREQRFg/oLh8WFEPioKc7HR0tsoYML7JdylTEbVRB9pyGOAFBWXDn8BqzMUcfyTUsPC2zTbgDM4wbLSEXQmtHmKISITEgCjB3cRWRy/6BLPrfidYBd3s3VByDVVohZ73TQD5dclQ0ID9SVPofziCHMXAYtAJl0T2AIkNpuo8g/JiBF5OKh6tsjRuEI09f90rsyjX4Us+d5M1JQybUn8IGTeSh1RdE+s6IjvvKKPGt1bvt+Ep1zJNO6ma3eDRdNu4RAJRz0iWPzkhSd7sJ03K0MQBW7Tsr2Ub6JW1c27H5Xxyz1LaAWTLA2JVZUoZBbzAYnme5iGuhHUvIGyyCEXZVwpl085T5IqDPCBP590kKxGgGzPXuqRkwN9iq403hJQIzxnOvzMN"
`endif