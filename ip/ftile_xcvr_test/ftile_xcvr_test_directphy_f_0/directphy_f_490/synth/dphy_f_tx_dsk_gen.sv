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
module dphy_f_tx_dsk_gen 
  #(
    parameter WIDTH         = 64,
    parameter LANES         = 2,
 //   parameter SYS_COP       = 1,
    parameter FEC_ON       = 1,
    parameter FEC_MODE       = "IEEE 802.3 RS(528,514) (CL 91,KR)",
    parameter DOUBLE_WIDTH_ON   = 1,
    parameter tuning_hint  ="TX_TUNING_HINT_DISABLED",
    parameter pma_lanes  = 1,
    parameter pma_width  = 32
    )(
      input logic 		     i_clk,
 //   input   logic [SYS_COP-1:0]        i_reset,
      input logic [LANES*WIDTH-1:0]  i_data,
      input logic tx_ready,
      output logic [LANES*WIDTH-1:0] o_data
      );

logic [LANES*WIDTH-1:0] o_data_reg;
logic tx_ready_sync;

generate
if ( DOUBLE_WIDTH_ON!=1 && pma_lanes>1 ) begin: resync
alt_xcvr_resync_etile #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (1)
      //.INIT_VALUE         (0)
  ) tx_ready_sync_inst (
      .clk                (i_clk),
      .reset              (1'b0),
      .d                  (tx_ready),
      .q                  (tx_ready_sync)
  );
 end : resync
 endgenerate

//For RSFEC patterns, tx deskew pulses are matching with the valid counts for
//each RSFEC mode. It's either 32 or 16 based on modes.
// 16 -> LLFEC or KP(544,514), tx deskew pulses are toggling every 16 cycles
// 32 -> KR(528,514),tx deskew pulses are toggling every 32 cycles.
// 16 means counter counts up to 15, so [3:0], WIDTH_CNT = 4.
// 32 means counter counts up to 31, so [4:0], WIDTH_CNT = 5
//
// For PMA patterns, tx deskew pulses are generated every 32 cycles.
   localparam WIDTH_CNT = FEC_ON ? 
			  (((FEC_MODE == "IEEE 802.3 RS(528,514) (CL 91,KR)") || 
	                    (FEC_MODE == "Ethernet Consortium RS(528,514)") || 
		            (FEC_MODE == "FC RS(528,514)") ||
		            (FEC_MODE == "FlexO RS(528,514)")) ? 5 : 4)
     : 5;
   
   logic [WIDTH_CNT-1:0] 	     counter = 'b0;
   logic 			     tx_dsk_pulse_reg;
   logic 			     tx_dsk_pulse;
   
   assign tx_dsk_pulse_reg = &counter;
   always @ (posedge i_clk) begin : increment_deskew_counter
      counter <= counter + 1'b1;
   end : increment_deskew_counter
 
   always @ (posedge i_clk) begin : deskew_pulse
      tx_dsk_pulse <= tx_dsk_pulse_reg;
   end : deskew_pulse



generate
   genvar l;
   for(l=0;l<LANES;l=l+1)  begin:lane
      assign o_data_reg[l*80+:80] = DOUBLE_WIDTH_ON ? {i_data[l*80+79], tx_dsk_pulse, i_data[l*80+:78]} : ((tuning_hint == "TX_TUNING_HINT_GPON" )&& (pma_lanes == 1) && (pma_width <=32)) ? {i_data[l*80+79 : l*80+37], 1'b0, i_data[l*80+:36]} : ((!tx_ready_sync)&&(pma_lanes>1)) ? {i_data[l*80+79 : l*80+40], 1'b1, 1'b1, i_data[((l*80)+37)], tx_dsk_pulse, i_data[l*80+:36]}  : {i_data[l*80+79 : l*80+37], tx_dsk_pulse, i_data[l*80+:36]};
    end : lane

endgenerate

always @ (posedge i_clk) begin : synchronizer
      o_data <= o_data_reg;
   end : synchronizer

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "GCmaWWfu8/z90U1Cmo5rPCMDlKlyM0GNy39hltItZu8hjp+ConPPnsllU0R3HQGDlHAZ73evWKdnQ3lDsZKXjvyxG/vMsJGlHhUjn18rLQtcWxIJVkzmz4DRGHUc79xjE5Ra6dXiFrovOM0nWa82j0WjiYv6AoXMP1ztF/irbbWTqsqUcTOLaKJT5ueWX0R9FbNv77cBFyzVTW5v/1dofdTWdWqd6lTx+9/Vzmh/0Y4QmsrPFDlkNUkiY8zaFgItCqFRPmQvCjuk6psL4cVNaTAnYHzRt+NkHKd7lNfB+vv5PX8gLUH3WylpfCy88EKmy9tbNM+M3511moZ4UHEYBWvVGx0PskBhQxwxF3Rg+EGYQb/bn55F1KLhOlaaxuQ14P0Tnpc5+YA+kbzyS846j30KU6YN4H1V7lHLRa6mVIocJ2/MqoEfhMiOYFbczWsMtaOx7VQT4pIZrzskwSIunN6mHYWVjVsZb/8+XFPTl/QxQWCWSnYPPrbp3Rd0jUw5EkFE+hYFWIWTIRHntazKUrS5BdKI1aF+t5vXGmw1TSapF4Mi2cgSwyvAgtqUHDhT7Pj9CKSzJL7VB69fYIL1hqTS+ddrJGuhcgitt3DLI1KAocH++/SrmxHzjRw7JpauuIMIWMoCgeKMnYIhRmCAYJ7tg4NVdskMsI1xv6qdd9q8mo496Sn55yMEshoIzcV/PeRfrfhH95YV1GZof4c9dK/EiNRMHXPAR+++68HjFNpAVbGs5T1VBf6etY9foji+haFrlyJzLVnJ3T5T4z0Xp03cjyjd4vXycEn9utaMquAu9/bHUfhLepj+vRyQosRx6lCUdr4NV4rNWob2uOHeqQ2m0KfZGMVa7jvVb0IuS7T6nxQV+kL32AIUASw/E/kJJhSvk3NMahvAMsf7Fs0usy0JnsJU58HFXfH7rpuX3/a8vnDEGqOGi7/vFrorHlVu9zgKtl2Qc4lZ8T5+QplvMpCRil+EZ2aypPQ6gAsUug1Qo78Lmv7/zfJP1QpotTxc"
`endif