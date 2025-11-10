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


`timescale 1 ps / 1 ps
// Copyright 2013 Intel Corporation. All rights reserved.  
// Intel products are protected under numerous U.S. and foreign patents, 
// maskwork rights, copyrights and other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Intel Reference Design 
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Intel Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference 
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an 
// accommodation and therefore all warranties, representations or guarantees of 
// any kind (whether express, implied or statutory) including, without 
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Intel expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Intel.
/////////////////////////////////////////////////////////////////////////////

module directphy_f_wys_lut #(
	parameter MASK = 64'h6996966996696996, // xor6
	parameter TARGET_CHIP = 7 // 0 generic, 1=S4, 2=S5, 3=A5, 4=C5, 5=A10
)
(
	input a,b,c,d,e,f,
	output out
);

// Handy masks - 
// 64'h8040201008040201 {a,b,c} == {d,e,f}
// 64'h6996966996696996 xor 6
// 64'h8020080200000000 ({b,c} == {d,e}) && a && f

generate
	if (TARGET_CHIP == 0) begin : c0
		// family neutral / simulation version
		wire [5:0] addr = {f,e,d,c,b,a};
		wire [63:0] tmp = MASK >> addr;
		assign out = tmp[0];
	end
	else if (TARGET_CHIP == 1) begin : c1
		stratixiv_lcell_comb s4c (
		  .dataa (a),.datab (b),.datac (c),.datad (d),.datae (e),.dataf (f),.datag(1'b1),
		  .cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		  .combout(out));
		defparam s4c .lut_mask = MASK;
		defparam s4c .shared_arith = "off";
		defparam s4c .extended_lut = "off";

	end
	else if (TARGET_CHIP == 2) begin : c2
		stratixv_lcell_comb s5c (
		  .dataa (a),.datab (b),.datac (c),.datad (d),.datae (e),.dataf (f),.datag(1'b1),
		  .cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		  .combout(out));
		defparam s5c .lut_mask = MASK;
		defparam s5c .shared_arith = "off";
		defparam s5c .extended_lut = "off";
	end
	else if (TARGET_CHIP == 3) begin : c3
		arriavgz_lcell_comb a5c (
		  .dataa (a),.datab (b),.datac (c),.datad (d),.datae (e),.dataf (f),.datag(1'b1),
		  .cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		  .combout(out));
		defparam a5c .lut_mask = MASK;
		defparam a5c .shared_arith = "off";
		defparam a5c .extended_lut = "off";
	end
	else if (TARGET_CHIP == 4) begin : c4
		cyclonev_lcell_comb c5c (
		  .dataa (a),.datab (b),.datac (c),.datad (d),.datae (e),.dataf (f),.datag(1'b1),
		  .cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		  .combout(out));
		defparam c5c .lut_mask = MASK;
		defparam c5c .shared_arith = "off";
		defparam c5c .extended_lut = "off";
	end
	else if (TARGET_CHIP == 5) begin : a10
		twentynm_lcell_comb a10c (
		  .dataa (a),.datab (b),.datac (c),.datad (d),.datae (e),.dataf (f),.datag(1'b1),
		  .cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		  .combout(out));
		defparam a10c .lut_mask = MASK;
		defparam a10c .shared_arith = "off";
		defparam a10c .extended_lut = "off";
	end
	else if (TARGET_CHIP == 6) begin : s10
		fourteennm_lcell_comb s10c (
		  .dataa (a),.datab (b),.datac (c),.datad (d),.datae (e),.dataf (f),.datag(1'b1),.datah(1'b1),
		  .cin(1'b1),.sumout(),.cout(),.shareout(),
		  .combout(out));
		defparam s10c .lut_mask = MASK;
		defparam s10c .shared_arith = "off";
		defparam s10c .extended_lut = "off";
	end
	else if (TARGET_CHIP == 7) begin : s10
		tennm_lcell_comb s10c (
		  .dataa (a),.datab (b),.datac (c),.datad (d),.datae (e),.dataf (f),.datag(1'b1),.datah(1'b1),
		  .cin(1'b1),.sumout(),.cout(),.shareout(),
		  .combout(out));
		defparam s10c .lut_mask = MASK;
		defparam s10c .shared_arith = "off";
		defparam s10c .extended_lut = "off";
	end
	else begin
		// synthesis translate off
		initial begin
			$display ("ERROR: Illegal TARGET_CHIP");
			$stop();
		end
		// synthesis translate on
		assign out = 1'b0;
	end
endgenerate
	

endmodule

// BENCHMARK INFO :  10AX115R2F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 13.1a10.0 Build 343 10/23/2013 SJ Full Version
// BENCHMARK INFO :  Total registers : 0
// BENCHMARK INFO :  Total pins : 7
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  2              
// BENCHMARK INFO :  ALMs : 2 / 427,200 ( < 1 % )
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "8qH9cVo09pAnWALEE6z2BDKrWVWnFI5Ou7hormZ79E/tGSVBCgNfmxFQvE9t3s7klXY5XdvnpByaQgBfCHF6Dbm9WN2svsxXF/zx5b/8CDkcUDB41PZNmNdUWNx7xDY3xJ7IgPTPwkMgtDelSr2aywj5LSl0zROc68MOmTBSsO9a1S9TDRa9h5E5qBo+fLmPNkMltB0gOqPF4aO4OqQAye1NWS4OsbZ9+NLF8RRMveCGi/3KvA1gMgO8or2eeH38cx3EsAZM2vnw0oRCSwglM5p9M604pYIxD1zZEX3jaoOpa3WCAcehTg9W3AAaaKo6JIMt1YE9H9RwiYyODqp2VQ97RPj9zAowLVpeoy9jcspknUtaPvXsVZHuvPJQyDUmmc3gZtEZSHmAnqN7Tu+JBQ7R+POxf7zzgjKu1CoRBw5oGqeRmwost8vM4eWWdp5jKYnJ7lGWgVG1RHHdTpx+u69y/kA84xLkxx+KjfxX3EtnXtAZEvknot6G9ZeczW8hNy7iarQ4xCfo1crjPh9yXkRGkOdoUUhZNgY8Eu1oX35BLwd3UEW/f6je4oEdec53hH/DxIzkS8InDhkNRSjfwWHdXuHDw9ysj3wDlEFXdZLCeAiRIARP8mDp43qSf1QaDUPe60BokjT7fVAVfcxcPmh8M2g5tMFgxcMRX+ere73K0ldmH4MOo1vk8rfM0S3/9SX/3lZ5rTmBQmRVPo+8jnjV2ldUmXXVoY1M0HpU0pT9wF8reNFzgyKo3H8wEUd8pOwuhiXESXRwx4DKgwpa3YymnbI+FfDGfxM+10vmoMhyoSYRvNnizP1h98VdokvCpwteh9QVbM4P+mJVpzriCLudHSCbnxriCt3yDvN4DOpbS/eSEMX2jj8qWxkHynur124hS7QHbuSmV0nJDkHbYOGMoev0R7r3b1/327zx1QBB4404JfCe10juopztr/MUCOKgmSj/HYATj1s3jB74e8XtCBlw6Sdk9YCN3VF+ktHK4lshP8Kf+yhvKnPJjpFr"
`endif