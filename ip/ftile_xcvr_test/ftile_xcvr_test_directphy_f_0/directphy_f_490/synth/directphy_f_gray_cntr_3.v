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


`timescale 1ps/1ps

module directphy_f_gray_cntr_3 #(
	parameter INIT_VAL = 4'h0
)(
	input clk,
	input ena,
	input aclr,
	output reg [2:0] cntr
);

initial cntr = INIT_VAL;

always @(posedge clk or posedge aclr) begin
	if (aclr) cntr <= INIT_VAL;
	else begin
		if (ena) begin
			case (cntr) 
				3'h0 : cntr <= 3'h1;
				3'h1 : cntr <= 3'h3;
				3'h2 : cntr <= 3'h6;
				3'h3 : cntr <= 3'h2;
				3'h4 : cntr <= 3'h0;
				3'h5 : cntr <= 3'h4;
				3'h6 : cntr <= 3'h7;
				3'h7 : cntr <= 3'h5;
			endcase
		end
	end
end

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "8qH9cVo09pAnWALEE6z2BDKrWVWnFI5Ou7hormZ79E/tGSVBCgNfmxFQvE9t3s7klXY5XdvnpByaQgBfCHF6Dbm9WN2svsxXF/zx5b/8CDkcUDB41PZNmNdUWNx7xDY3xJ7IgPTPwkMgtDelSr2aywj5LSl0zROc68MOmTBSsO9a1S9TDRa9h5E5qBo+fLmPNkMltB0gOqPF4aO4OqQAye1NWS4OsbZ9+NLF8RRMveBLrC+CJEQ9hetBB7DglJ4+4CXCTsyCpFheiZwVMOm/yowXkkznGAUiW0aTkkrk8RI1nUhD+dhkNtQC6kyFsRXH6ZezlGLuHxH9YasCaiVRYDlCmJPiqkjTW8o8LGp1soxSLw77nX/FRO9E1haFxKiL52BNdzt15m6y2aNTsc0lp8BCLJg2vmo+S5wFMG7gGEHbvDfmlNilC88viuBehpdsysiWvBOrsnHWjp0GupTQBTTZCqvHqhCdQmz96WfgcWZV0vW7NAorgyT5c72eQ97cziFm2lrpbNZ7IuwwN0nUySl4w7BzOqpEyPrTrogBNMpxf9puEviUOrO/l1ca304tZCYqASEf81Xwb9ItYtDs8Uedfkk3JCsHVUv9tuyl5/zTRLpk4jpz7Cvlshwpjcp3YC+XTEVe41xIVyo3Y8FgcnoMuKZBt5u2uDe9I+jO8Nu209eidYBl4o3kmQdGgLQw4IU1N/1FrpIfbBq73r0Op5Z+hbtugJMGj4FH8+MpjVC2EZlizzss7zKRnvLCw/5ysr15AFIP79tLMc7CtKHBiRn/cIGbGPcEYi4dTj/96/+750qC3AI+2IHBiLXnLDSwZJk+5BnlpD/I/sHaLboujVbBCO3ADoXpSc8aYnKtLptWPuC1GPutua5Q8oXYOxkxfFy60fp4/m14kqt44IOcGTF7HW41Oy1E6nloYIEn896x/4x8bsiv6bLTxbL4h1EI8UrH8mgiar0sp57aDgzRIiJjZmtkhgJDwCuyhzUrdaF3BMVZlUf3r2OnHrUj+F1Y"
`endif