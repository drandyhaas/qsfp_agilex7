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
//   Generated with Magillem S.A. MRV generator.                                  
//   MRV generator version : 0.2
//   Protocol :  AVALON
//   Wait State : WS1_OUTPUT                                         
//   Date : Tue Dec 13 03:09:19 PST 2022           
//-----------------------------------------------------------------------------------------------//

`timescale 1 ps/1 ps 

//-----------------------------------------------------------------------------------------------//
//   Verilog Register Bank
//   Component Name: dphy_f_sip_csr
//   File Ref: /nfs/site/disks/swuser_work_kparane/directphy22.3/directphy22.3usb/p4/ip/alt_xcvr/altera_xcvr_native_phy/directphy_f/csr_gen/csrgen_output/_workspace_mrv_gen_py_/xmlProject/_local_copy_Vendor_Library_dphy_f_sip_csr_1.0.xml                                             
//   Magillem Version :   5.11.2.1                                                                         
//-----------------------------------------------------------------------------------------------//
// 
module dphy_f_sip_csr (
// register offset : 0x800, field offset : 0, access : RO, gui_option.line_rate_p1ghz
input  [11:0] gui_option_line_rate_p1ghz_i,
// register offset : 0x800, field offset : 12, access : RO, gui_option.xcvr_type
input   gui_option_xcvr_type_i,
// register offset : 0x800, field offset : 13, access : RO, gui_option.modulation_type
input   gui_option_modulation_type_i,
// register offset : 0x800, field offset : 14, access : RO, gui_option.duplex_mode
input  [1:0] gui_option_duplex_mode_i,
// register offset : 0x800, field offset : 16, access : RO, gui_option.num_xcvr
input  [4:0] gui_option_num_xcvr_i,
// register offset : 0x800, field offset : 21, access : RO, gui_option.fec_enable
input   gui_option_fec_enable_i,
// register offset : 0x800, field offset : 24, access : RO, gui_option.num_aib
input  [4:0] gui_option_num_aib_i,
// register offset : 0x804, field offset : 0, access : RW, dhpy_scratch.scratch
// register offset : 0x808, field offset : 0, access : RW, dphy_reset.soft_tx_rst
output  reg dphy_reset_soft_tx_rst,
// register offset : 0x808, field offset : 1, access : RW, dphy_reset.soft_rx_rst
output  reg dphy_reset_soft_rx_rst,
// register offset : 0x808, field offset : 4, access : RW, dphy_reset.tx_rst_ovr
output  reg dphy_reset_tx_rst_ovr,
// register offset : 0x808, field offset : 5, access : RW, dphy_reset.rx_rst_ovr
output  reg dphy_reset_rx_rst_ovr,
// register offset : 0x80c, field offset : 0, access : RO, dphy_reset_status.tx_rst_ack_n
input   dphy_reset_status_tx_rst_ack_n_i,
// register offset : 0x80c, field offset : 1, access : RO, dphy_reset_status.rx_rst_ack_n
input   dphy_reset_status_rx_rst_ack_n_i,
// register offset : 0x80c, field offset : 4, access : RO, dphy_reset_status.tx_ready
input   dphy_reset_status_tx_ready_i,
// register offset : 0x80c, field offset : 5, access : RO, dphy_reset_status.rx_ready
input   dphy_reset_status_rx_ready_i,
// register offset : 0x80c, field offset : 7, access : RO, dphy_reset_status.avmm_ready
input   dphy_reset_status_avmm_ready_i,
// register offset : 0x810, field offset : 0, access : RO, phy_tx_pll_locked.tx_pll_locked
input  [15:0] phy_tx_pll_locked_tx_pll_locked_i,
// register offset : 0x814, field offset : 0, access : RO, phy_rx_cdr_locked.rx_cdr_locked
input  [15:0] phy_rx_cdr_locked_rx_cdr_locked_i,
// register offset : 0x814, field offset : 16, access : RO, phy_rx_cdr_locked.rx_cdr_locked2data
input  [15:0] phy_rx_cdr_locked_rx_cdr_locked2data_i,
// register offset : 0x818, field offset : 0, access : RW, src_ctrl.rx_ignore_locked2data
output  reg src_ctrl_rx_ignore_locked2data,
// register offset : 0x900, field offset : 0, access : RW, cwbin_control_register.cwbin_control_register
output  reg cwbin_control_register_cwbin_control_register,
// register offset : 0x904, field offset : 0, access : RO, cwbin0_A.cwbin0_A
input  [31:0] cwbin0_A_cwbin0_A_i,
// register offset : 0x908, field offset : 0, access : RO, cwbin1_A.cwbin1_A
input  [31:0] cwbin1_A_cwbin1_A_i,
// register offset : 0x90c, field offset : 0, access : RO, cwbin2_A.cwbin2_A
input  [31:0] cwbin2_A_cwbin2_A_i,
// register offset : 0x910, field offset : 0, access : RO, cwbin3_A.cwbin3_A
input  [31:0] cwbin3_A_cwbin3_A_i,
// register offset : 0x914, field offset : 0, access : RO, cwbin0_B.cwbin0_B
input  [31:0] cwbin0_B_cwbin0_B_i,
// register offset : 0x918, field offset : 0, access : RO, cwbin1_B.cwbin1_B
input  [31:0] cwbin1_B_cwbin1_B_i,
// register offset : 0x91c, field offset : 0, access : RO, cwbin2_B.cwbin2_B
input  [31:0] cwbin2_B_cwbin2_B_i,
// register offset : 0x920, field offset : 0, access : RO, cwbin3_B.cwbin3_B
input  [31:0] cwbin3_B_cwbin3_B_i,
// register offset : 0x924, field offset : 0, access : RW, cwbin_timer.cwbin_timer
output  reg[31:0] cwbin_timer_cwbin_timer,

//Bus Interface
input clk,
input reset,
input [31:0] writedata,
input read,
input write,
input [3:0] byteenable,
output reg [31:0] readdata,
output reg readdatavalid,
input [11:0] address

);


wire reset_n = !reset;	
// Protocol management
// combinatorial read data signal declaration
reg [31:0] rdata_comb;

// synchronous process for the read
always @(posedge clk)  
   if (!reset_n) readdata[31:0] <= 32'h0; else readdata[31:0] <= rdata_comb[31:0];

// read data is always returned on the next cycle
always @( posedge clk)
   if (!reset_n) readdatavalid <= 1'b0; else readdatavalid <= read;
//
//  Protocol specific assignment to inside signals
//
wire  we = write;
wire  re = read;
wire [11:0] addr = address[11:0];
wire [31:0] din  = writedata [31:0];
// A write byte enable for each register
// register dhpy_scratch with  writeType: write
wire	[3:0]  we_dhpy_scratch		=	we  & (addr[11:0]  == 12'h804)	?	byteenable[3:0]	:	{4{1'b0}};
// register dphy_reset with  writeType: write
wire	  we_dphy_reset		=	we  & (addr[11:0]  == 12'h808)	?	byteenable[0]	:	1'b0;
// register src_ctrl with  writeType: write
wire	  we_src_ctrl		=	we  & (addr[11:0]  == 12'h818)	?	byteenable[0]	:	1'b0;
// register cwbin_control_register with  writeType: write
wire	  we_cwbin_control_register		=	we  & (addr[11:0]  == 12'h900)	?	byteenable[0]	:	1'b0;
// register cwbin_timer with  writeType: write
wire	[3:0]  we_cwbin_timer		=	we  & (addr[11:0]  == 12'h924)	?	byteenable[3:0]	:	{4{1'b0}};

// A read byte enable for each register

/* Definitions of REGISTER "gui_option" */

// gui_option_line_rate_p1ghz
// bitfield description: Line rate in 0.1GHz
// Line datarate in 0.1GHz per transceiver.
// customType:  RO
// hwAccess: WO 
// inputPort: gui_option_line_rate_p1ghz_i 
// outputPort:  "" 
// NO register generated




// gui_option_xcvr_type
// bitfield description: Xcvr type
// 0:FGT tranceiver,1:FHT tranceiver
// customType:  RO
// hwAccess: WO 
// inputPort: gui_option_xcvr_type_i 
// outputPort:  "" 
// NO register generated




// gui_option_modulation_type
// bitfield description: Modulation type
// 0:NRZ, 1:PAM-4
// customType:  RO
// hwAccess: WO 
// inputPort: gui_option_modulation_type_i 
// outputPort:  "" 
// NO register generated




// gui_option_duplex_mode
// bitfield description: Duplex mode
// 0:Not used, 1:RX simplex, 2:TX simplex, 3:TX/RX duplex
// customType:  RO
// hwAccess: WO 
// inputPort: gui_option_duplex_mode_i 
// outputPort:  "" 
// NO register generated




// gui_option_num_xcvr
// bitfield description: Number of transceivers
// Number of transceivers per system
// customType:  RO
// hwAccess: WO 
// inputPort: gui_option_num_xcvr_i 
// outputPort:  "" 
// NO register generated




// gui_option_fec_enable
// bitfield description: RSFEC Enabled?
// 0:RSFEC is disabled, 1:RSFEC is enabled
// customType:  RO
// hwAccess: WO 
// inputPort: gui_option_fec_enable_i 
// outputPort:  "" 
// NO register generated




// gui_option_num_aib
// bitfield description: Number of AIB channels
// Number of AIB channels per system
// customType:  RO
// hwAccess: WO 
// inputPort: gui_option_num_aib_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dhpy_scratch" */

// dhpy_scratch_scratch
// customType:  RW
// hwAccess: NA 
// reset value : 0x00000000 

reg [31:0] dhpy_scratch_scratch; // 

always @( posedge clk)
   if (!reset_n)  begin
      dhpy_scratch_scratch <= 32'h00000000;
   end
   else begin
   if (we_dhpy_scratch[0]) begin 
      dhpy_scratch_scratch[7:0]   <=  din[7:0];  //
   end
   if (we_dhpy_scratch[1]) begin 
      dhpy_scratch_scratch[15:8]   <=  din[15:8];  //
   end
   if (we_dhpy_scratch[2]) begin 
      dhpy_scratch_scratch[23:16]   <=  din[23:16];  //
   end
   if (we_dhpy_scratch[3]) begin 
      dhpy_scratch_scratch[31:24]   <=  din[31:24];  //
   end
end
/* Definitions of REGISTER "dphy_reset" */

// dphy_reset_soft_tx_rst
// bitfield description: Soft TX Reset
// 1:Reset the TX datapath if tx_rst_ovr is also set
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dphy_reset_soft_tx_rst <= 1'h0;
   end
   else begin
   if (we_dphy_reset) begin 
      dphy_reset_soft_tx_rst   <=  din[0];  //
   end
end

// dphy_reset_soft_rx_rst
// bitfield description: Soft RX Reset
// 1:Reset the RX datapath if tx_rst_ovr is also set
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dphy_reset_soft_rx_rst <= 1'h0;
   end
   else begin
   if (we_dphy_reset) begin 
      dphy_reset_soft_rx_rst   <=  din[1];  //
   end
end

// dphy_reset_tx_rst_ovr
// bitfield description: TX Reset Override
// 0:Use TX Reset from user interface, 1:use Soft TX Reset
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dphy_reset_tx_rst_ovr <= 1'h0;
   end
   else begin
   if (we_dphy_reset) begin 
      dphy_reset_tx_rst_ovr   <=  din[4];  //
   end
end

// dphy_reset_rx_rst_ovr
// bitfield description: RX Reset Override
// 0:Use RX Reset from user interface, 1:use Soft RX Reset
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dphy_reset_rx_rst_ovr <= 1'h0;
   end
   else begin
   if (we_dphy_reset) begin 
      dphy_reset_rx_rst_ovr   <=  din[5];  //
   end
end
/* Definitions of REGISTER "dphy_reset_status" */

// dphy_reset_status_tx_rst_ack_n
// bitfield description: TX Reset acknowledge. Active low (either the hard tx reset or the soft_tx_rst )
// 1:acknowledge the reset completed.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dphy_reset_status_tx_rst_ack_n_i 
// outputPort:  "" 
// NO register generated




// dphy_reset_status_rx_rst_ack_n
// bitfield description: RX Reset acknowledge. Active high (either the hard rx reset or the soft_rx_rst )
// 1:acknowledge the reset completed.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dphy_reset_status_rx_rst_ack_n_i 
// outputPort:  "" 
// NO register generated




// dphy_reset_status_tx_ready
// bitfield description: tx_ready state
// Current state of TX side:
// [0]: Not ready to accept user data
// [1]: Ready to send user data, indicates tx pll locked and data path reset done
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dphy_reset_status_tx_ready_i 
// outputPort:  "" 
// NO register generated




// dphy_reset_status_rx_ready
// bitfield description: rx_ready state
// Current state of RX side:
// [0]: Not ready to recover line data to paralell interface
// [1]: Ready to deliver recovered line data to parallel interface, indicates rx CDR locked and data path reset done
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dphy_reset_status_rx_ready_i 
// outputPort:  "" 
// NO register generated




// dphy_reset_status_avmm_ready
// bitfield description: Tile AVMM ports ready to accept user commands
// Current tie state for AVMM ports:
// [0]: Tile AVMM port is busy, not ready to accept user commands
// [1]: Tile enters user mode, AVMM ports ready to accept user commands
// If not fully in reset or out of reset, RX reset is currently transitioning
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dphy_reset_status_avmm_ready_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "phy_tx_pll_locked" */

// phy_tx_pll_locked_tx_pll_locked
// bitfield description: TX PLL Locked
// 1=TX PLL used by this lane physical lane is locked
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000 
// inputPort: phy_tx_pll_locked_tx_pll_locked_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "phy_rx_cdr_locked" */

// phy_rx_cdr_locked_rx_cdr_locked
// bitfield description: CDR PLL locked
// 1:Corresponding physical lane's CDR has locked to reference
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000 
// inputPort: phy_rx_cdr_locked_rx_cdr_locked_i 
// outputPort:  "" 
// NO register generated




// phy_rx_cdr_locked_rx_cdr_locked2data
// bitfield description: CDR PLL locked to data
// 1:Corresponding physical lane's CDR has locked to data
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000 
// inputPort: phy_rx_cdr_locked_rx_cdr_locked2data_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "src_ctrl" */

// src_ctrl_rx_ignore_locked2data
// bitfield description: Ignore RX CDR Locked2data status
// 1:ignore
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      src_ctrl_rx_ignore_locked2data <= 1'h0;
   end
   else begin
   if (we_src_ctrl) begin 
      src_ctrl_rx_ignore_locked2data   <=  din[0];  //
   end
end


/* Definitions of REGISTER "cwbin_control_register" */
 
// cwbin_control_register_cwbin_control_register
// bitfield description: Soft cwbin control register 
// 1 : resets the cwbin module
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 
 
 
always @( posedge clk)
   if (!reset_n)  begin
      cwbin_control_register_cwbin_control_register <= 1'h0;
   end
   else begin
   if (we_cwbin_control_register) begin 
      cwbin_control_register_cwbin_control_register   <=  din[0];  //
   end
end
/* Definitions of REGISTER "cwbin0_A" */
 
// cwbin0_A_cwbin0_A
// bitfield description: cwbin0_A 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 0 Errors are accumulated to 32 bit counter Block A
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin0_A_cwbin0_A_i 
// outputPort:  "" 
// NO register generated
 
 
 
/* Definitions of REGISTER "cwbin1_A" */
 
// cwbin1_A_cwbin1_A
// bitfield description: cwbin1_A 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 1 Errors are accumulated to 32 bit counter Block A
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin1_A_cwbin1_A_i 
// outputPort:  "" 
// NO register generated
 
 
 
/* Definitions of REGISTER "cwbin2_A" */
 
// cwbin2_A_cwbin2_A
// bitfield description: cwbin2_A 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 2 Errors are accumulated to 32 bit counter Block A
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin2_A_cwbin2_A_i 
// outputPort:  "" 
// NO register generated
 
 
 
/* Definitions of REGISTER "cwbin3_A" */
 
// cwbin3_A_cwbin3_A
// bitfield description: cwbin3_A 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 3 Errors are accumulated to 32 bit counter Block A
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin3_A_cwbin3_A_i 
// outputPort:  "" 
// NO register generated
 
 
 
/* Definitions of REGISTER "cwbin0_B" */
 
// cwbin0_B_cwbin0_B
// bitfield description: cwbin0_B 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 0 Errors are accumulated to 32 bit counter Block B
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin0_B_cwbin0_B_i 
// outputPort:  "" 
// NO register generated
 
 
 
/* Definitions of REGISTER "cwbin1_B" */
 
// cwbin1_B_cwbin1_B
// bitfield description: cwbin1_B 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 1 Errors are accumulated to 32 bit counter Block B
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin1_B_cwbin1_B_i 
// outputPort:  "" 
// NO register generated
 
 
 
/* Definitions of REGISTER "cwbin2_B" */
 
// cwbin2_B_cwbin2_B
// bitfield description: cwbin2_B 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 2 Errors are accumulated to 32 bit counter Block B
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin2_B_cwbin2_B_i 
// outputPort:  "" 
// NO register generated
 
 
 
/* Definitions of REGISTER "cwbin3_B" */
 
// cwbin3_B_cwbin3_B
// bitfield description: cwbin3_B 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 3 Errors are accumulated to 32 bit counter Block B
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin3_B_cwbin3_B_i 
// outputPort:  "" 
// NO register generated
 
 
 
/* Definitions of REGISTER "cwbin_timer" */
 
// cwbin_timer_cwbin_timer
// bitfield description: cwbin_timer 
// soft cwbin timer timeout value,in each loop the hard cwbin registers will be read and accumulated in soft 32bit registers
// customType:  RW
// hwAccess: RO 
// reset value : 0x00000000 
 
 
always @(  posedge clk)
   if (!reset_n)  begin
      cwbin_timer_cwbin_timer <= 32'h00000000;
   end
   else begin
   if (we_cwbin_timer[0]) begin 
      cwbin_timer_cwbin_timer[7:0]   <=  din[7:0];  //
   end
   if (we_cwbin_timer[1]) begin 
      cwbin_timer_cwbin_timer[15:8]   <=  din[15:8];  //
   end
   if (we_cwbin_timer[2]) begin 
      cwbin_timer_cwbin_timer[23:16]   <=  din[23:16];  //
   end
   if (we_cwbin_timer[3]) begin 
      cwbin_timer_cwbin_timer[31:24]   <=  din[31:24];  //
   end
end
 

// read process
always @ (*)
begin
rdata_comb = 32'h00000000;
   if(re) begin
      case (addr)  
	12'h800 : begin
		rdata_comb [11:0]	= gui_option_line_rate_p1ghz_i [11:0] ;		// readType = read   writeType =illegal
		rdata_comb [12]	= gui_option_xcvr_type_i  ;		// readType = read   writeType =illegal
		rdata_comb [13]	= gui_option_modulation_type_i  ;		// readType = read   writeType =illegal
		rdata_comb [15:14]	= gui_option_duplex_mode_i [1:0] ;		// readType = read   writeType =illegal
		rdata_comb [20:16]	= gui_option_num_xcvr_i [4:0] ;		// readType = read   writeType =illegal
		rdata_comb [21]	= gui_option_fec_enable_i  ;		// readType = read   writeType =illegal
		rdata_comb [28:24]	= gui_option_num_aib_i [4:0] ;		// readType = read   writeType =illegal
	end
	12'h804 : begin
		rdata_comb [31:0]	= dhpy_scratch_scratch [31:0] ;		// readType = read   writeType =write
	end
	12'h808 : begin
		rdata_comb [0]	= dphy_reset_soft_tx_rst  ;		// readType = read   writeType =write
		rdata_comb [1]	= dphy_reset_soft_rx_rst  ;		// readType = read   writeType =write
		rdata_comb [4]	= dphy_reset_tx_rst_ovr  ;		// readType = read   writeType =write
		rdata_comb [5]	= dphy_reset_rx_rst_ovr  ;		// readType = read   writeType =write
	end
	12'h80c : begin
		rdata_comb [0]	= dphy_reset_status_tx_rst_ack_n_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dphy_reset_status_rx_rst_ack_n_i  ;		// readType = read   writeType =illegal
		rdata_comb [4]	= dphy_reset_status_tx_ready_i  ;		// readType = read   writeType =illegal
		rdata_comb [5]	= dphy_reset_status_rx_ready_i  ;		// readType = read   writeType =illegal
		rdata_comb [7]	= dphy_reset_status_avmm_ready_i  ;		// readType = read   writeType =illegal
	end
	12'h810 : begin
		rdata_comb [15:0]	= phy_tx_pll_locked_tx_pll_locked_i [15:0] ;		// readType = read   writeType =illegal
	end
	12'h814 : begin
		rdata_comb [15:0]	= phy_rx_cdr_locked_rx_cdr_locked_i [15:0] ;		// readType = read   writeType =illegal
		rdata_comb [31:16]	= phy_rx_cdr_locked_rx_cdr_locked2data_i [15:0] ;		// readType = read   writeType =illegal
	end
	12'h818 : begin
		rdata_comb [0]	= src_ctrl_rx_ignore_locked2data  ;		// readType = read   writeType =write
	end
	12'h900 : begin
		rdata_comb [0]	= cwbin_control_register_cwbin_control_register  ;		// readType = read   writeType =write
	end
	12'h904 : begin
		rdata_comb [31:0]	= cwbin0_A_cwbin0_A_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h908 : begin
		rdata_comb [31:0]	= cwbin1_A_cwbin1_A_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h90c : begin
		rdata_comb [31:0]	= cwbin2_A_cwbin2_A_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h910 : begin
		rdata_comb [31:0]	= cwbin3_A_cwbin3_A_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h914 : begin
		rdata_comb [31:0]	= cwbin0_B_cwbin0_B_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h918 : begin
		rdata_comb [31:0]	= cwbin1_B_cwbin1_B_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h91c : begin
		rdata_comb [31:0]	= cwbin2_B_cwbin2_B_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h920 : begin
		rdata_comb [31:0]	= cwbin3_B_cwbin3_B_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h924 : begin
		rdata_comb [31:0]	= cwbin_timer_cwbin_timer [31:0] ;		// readType = read   writeType =write
	end
	default : begin
		rdata_comb = 32'h00000000;
	end
      endcase
   end
end

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "GCmaWWfu8/z90U1Cmo5rPCMDlKlyM0GNy39hltItZu8hjp+ConPPnsllU0R3HQGDlHAZ73evWKdnQ3lDsZKXjvyxG/vMsJGlHhUjn18rLQtcWxIJVkzmz4DRGHUc79xjE5Ra6dXiFrovOM0nWa82j0WjiYv6AoXMP1ztF/irbbWTqsqUcTOLaKJT5ueWX0R9FbNv77cBFyzVTW5v/1dofdTWdWqd6lTx+9/Vzmh/0Y6StGHdWjhbOFqil5nqLsrzpzXP//KBims+hLoyo7QqenACpkWXmptm68+MJw9CzPjPun4gwzf+ZFHXUU1ruohwiA2ahKBrtv1xptfHQx7g+YOaphXwsBBqhqO7YkO6hDyGahNtIPctTREFMRcmYRlI+Sj7vFNRiFcgl/rKEQdTav5oOY+ZAjVrXhV/Vk1n/f3K6/rrP/9oZcMwzBQTh5z0rllI0XnfiVHSJ8p8lLpohSC7nuDTffKhRv0D42E4p6jEKwd2jKuUhZO6OLJqmTdQRLn0E/vXP3ndh84IWpAp81kG1SmzwxfQj/tV3+xoHgAjyf6hA3f7n6Gxe8mXMCReUfnmVPYdlV8x0ZkAoqZMuxVpJiYwO95eQDG4nhbKlkzdAERozeLMkWFLo6qgMD9wQxG/wWVU3Twy+eOyytVNSTp8IKrm9wXheKpZmPvfYU87oupUoUqzWTjmV2FFwDgr82wKDPIFN8amb4VvAQL1dHJ4ew6GDmo3PkTwhkfyh2XZocZzzmSnUS1s5LES7HgPQ7IFWdJG/zvcd3tsQr5INmlNcoZ6v/IN2DJB5ma1xw9VVj0XZvrnLBc5sj62BnvmvUbdVbp2wOojLK8YGHHxMD99jCiROgaPB/K/SVnH6wy5Gcmg2UbZ/sEe1OxqW3rzlVpUIIfR0ZJfa9cd3IURlHHoqw0zMmLCk7GuaAFtsT7eETkEYF2+h+X23fNM1iGCh0Zrk45hcHy1QNbgxGjIkZn3UYfsqUfGW1n/fgsXeXWA+Rt85tVEvagBdfC0II2Z"
`endif