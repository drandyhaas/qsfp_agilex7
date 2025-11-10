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


// Copyright 2012 Intel Corporation. All rights reserved.  
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
 
`timescale 1ps/1ps
 
module directphy_f_gray_cntr_5_sl #(
	parameter SLD_VAL = 5'h0,
	parameter TARGET_CHIP = 2,
	parameter LOAD_IMPLIES_ENA = 1'b1
)(
	input clk,
	input ena,
	input sld,
	output [4:0] cntr
);
 
wire [5:0] din = {1'b1,cntr};
wire [4:0] dout_w;
 
directphy_f_wys_lut w0 (.a(din[5]),.b(din[4]),.c(din[3]),.d(din[2]),.e(din[1]),.f(din[0]),.out(dout_w[0]));
defparam w0 .MASK = 64'hc33c3cc3c33c3cc3;
defparam w0 .TARGET_CHIP = TARGET_CHIP;
 
directphy_f_wys_lut w1 (.a(din[5]),.b(din[4]),.c(din[3]),.d(din[2]),.e(din[1]),.f(din[0]),.out(dout_w[1]));
defparam w1 .MASK = 64'h3cc33cc3ffff0000;
defparam w1 .TARGET_CHIP = TARGET_CHIP;
 
directphy_f_wys_lut w2 (.a(din[5]),.b(din[4]),.c(din[3]),.d(din[2]),.e(din[1]),.f(din[0]),.out(dout_w[2]));
defparam w2 .MASK = 64'hff00ff00c3c3ff00;
defparam w2 .TARGET_CHIP = TARGET_CHIP;
 
directphy_f_wys_lut w3 (.a(din[5]),.b(din[4]),.c(din[3]),.d(din[2]),.e(din[1]),.f(din[0]),.out(dout_w[3]));
defparam w3 .MASK = 64'hf0f0f0f0f0f033f0;
defparam w3 .TARGET_CHIP = TARGET_CHIP;
 
directphy_f_wys_lut w4 (.a(din[5]),.b(din[4]),.c(din[3]),.d(din[2]),.e(din[1]),.f(din[0]),.out(dout_w[4]));
defparam w4 .MASK = 64'hccccccccccccccf0;
defparam w4 .TARGET_CHIP = TARGET_CHIP;
 
wire mod_ena = LOAD_IMPLIES_ENA ? (sld | ena) : ena;
 
genvar i;
 
generate
for (i=0; i<5; i=i+1) begin : rl
		if(i == 0) begin
		dffeas df (.d(dout_w[i]),
					.clk(clk),
					.ena(mod_ena),
					.sload(1'b0),
					.sclr(1'b0),
					.clrn(1'b1),
					.prn(~sld),
				// synthesis translate off
					.devclrn(1'b1),
					.devpor(1'b1),
				// synthesis translate on					
					.asdata(1'b0),
					.aload(1'b0),
					.q(cntr[i])
		);
		defparam df .power_up = "low";
		defparam df .is_wysiwyg = "false";					
		end else begin
		dffeas df (.d(dout_w[i]),
					.clk(clk),
					.ena(mod_ena),
					.sload(1'b0),
					.sclr(1'b0),
					.clrn(~sld),
					.prn(1'b1),
				// synthesis translate off
					.devclrn(1'b1),
					.devpor(1'b1),
				// synthesis translate on					
					.asdata(1'b0),
					.aload(1'b0),
					.q(cntr[i])
		);
		defparam df .power_up = "low";
		defparam df .is_wysiwyg = "false";
		end
end
endgenerate
 
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "8qH9cVo09pAnWALEE6z2BDKrWVWnFI5Ou7hormZ79E/tGSVBCgNfmxFQvE9t3s7klXY5XdvnpByaQgBfCHF6Dbm9WN2svsxXF/zx5b/8CDkcUDB41PZNmNdUWNx7xDY3xJ7IgPTPwkMgtDelSr2aywj5LSl0zROc68MOmTBSsO9a1S9TDRa9h5E5qBo+fLmPNkMltB0gOqPF4aO4OqQAye1NWS4OsbZ9+NLF8RRMveDBrFZTPLlBlEnzTW8XUYK+UOHBDk/7upfR/YXcZVAfNu5iXaRDgqDeh24xhQZiQeiFkw10EoDXfXOcw16CjYduyOVp2WTwPgcCEeLhprWFidZnQcexSuE7u5IbBkevqOB/UGSul6L/jK4QqJXwp2OjgVbYLyTPjbjFgYakn9+VjebzPivdNTmU3CGkXfnBc0OqW2F7xDjGboG3LGWuwpBqmDL83rxEQTIxEC1LzeDyMLCW64NvgGDCY8CoxLOPpssxLOYY7+M01baZVUCg9h+uRL9B1LAstODCfNt+6JNGko322txjcCp9mEp8KrEszweJCfXT8SgnoNJUhAjeUeXNUn4tjwedFxXnS6cTSDgpVS97s6ednsUAvSV0wLEJKce2bnsKTP7xzUpD2SzqOWbhMIrqz4lOP5TmmtENot5ptLNHeYHID3j27vwv9LZnJOeewgzDsh+70/HH+E886ADRrH19xdyMkCtscQisgFPmiYZX/QLLrVlTRVs4jbS8uFJCQLLjG9S4L9qR7ccvEIxQIMiqLy03iEQ8NJI2rm87nwrl0Ki3PIISPEqjiHoplzVWyRDfgMtQwaXcb7GiXJhGoalRquKVbGBmTR9sFgiF3un7/E02gyvEj9TeNW4nd7OMHRSfOA9PtdtmbTTtOvGJErLBOyZl+wbdxsBDibzExGKz/AM5NMhZdVuSvK1+MWhk5CdPjG+OygmNd4CigkZ6tB7gJ4V05Kr+io/YHLjJUxOErUwv5Qs+GFR7dagPTRAFxYnf4w4pxHKw1A28601+"
`endif