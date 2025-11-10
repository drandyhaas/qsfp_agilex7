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

// baeckler - 01-25-2012
// force the decomposition of 5 bit FIFO pointer compare with enable

module directphy_f_neq_5_ena #(
 	parameter TARGET_CHIP = 1   // 0 generic, 1 S4, 2 S5
)(
	input [4:0] da,
	input [4:0] db,
	input ena,
	output eq
);

wire w0_o;
directphy_f_wys_lut w0 (
	.a(da[0]),
	.b(da[1]),
	.c(da[2]),
	.d(db[0]),
	.e(db[1]),
	.f(db[2]),
	.out (w0_o)
);
defparam w0 .TARGET_CHIP = TARGET_CHIP;
defparam w0 .MASK = 64'h8040201008040201; // {a,b,c} == {d,e,f}
	
directphy_f_wys_lut w1 (
	.a(ena),
	.b(da[3]),
	.c(da[4]),
	.d(db[3]),
	.e(db[4]),
	.f(w0_o),
	.out (eq)
);
defparam w1 .TARGET_CHIP = TARGET_CHIP;
defparam w1 .MASK = 64'h2a8aa2a8aaaaaaaa; // (!({b,c} == {d,e}) || !f) && a;
	

endmodule
// BENCHMARK INFO :  10AX115R2F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 13.1a10.0 Build 343 10/23/2013 SJ Full Version
// BENCHMARK INFO :  Total registers : 0
// BENCHMARK INFO :  Total pins : 12
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  3              
// BENCHMARK INFO :  ALMs : 3 / 427,200 ( < 1 % )
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "8qH9cVo09pAnWALEE6z2BDKrWVWnFI5Ou7hormZ79E/tGSVBCgNfmxFQvE9t3s7klXY5XdvnpByaQgBfCHF6Dbm9WN2svsxXF/zx5b/8CDkcUDB41PZNmNdUWNx7xDY3xJ7IgPTPwkMgtDelSr2aywj5LSl0zROc68MOmTBSsO9a1S9TDRa9h5E5qBo+fLmPNkMltB0gOqPF4aO4OqQAye1NWS4OsbZ9+NLF8RRMveAJ15C0xiVnBS9ZAggsxmAftX269sSbNvMsiiAW9D3whA8tEB8rc/NJSOztHaYBuNvR8TiqkrQ6N9P5rAC1OpqqN4vuUdfVe64f4kPqlDzcqDMtQGaB/V8VCT1EP8koqyMs8HgeaVSHYXXPAjUaXJAHJoej8kS2jrnry1FWpKDzTy2IrsJRv01h/z2tQ7Grln7on2AEctfN0bWFfBc/HW7HcMMLwfLvnQHjrREB2Idw4pOUjPgOIdrBGUJG6XB/wDd+aHyo4JlkECedfYbQtHn6qCXTVViEdiDSjxk3028SFYpZepB7VfKAM8l91W6qNu7z9gjTkV5oYLlHPUU94ETUxSf52jiBYl83cbPYSGkrtYQdnlPGiIfjHtzHHlwySc8k/ZeQqWCogkSDijgCHuLrbCiwN8oRM1l7Xjhvw8qxbvbXiGHl7ub2MSDYBYt2NFaFwQXSvNlE6T7YmNo34F9Tcn0wqQVNqZI8uDt/h4q7dOPXwobdF7xmr+iz3RO9sW9b7t783XEBYF9zxL2+Nj5EyFcFEPT12/9O+1/ci59gaD7AGV6QSKDP0/h+t4t8kUP9qZafrQDF9Eml/iW2Shwre2Ye1EDoHPNbjsqaxebWhttAWNBF0jKr4+4h7TgvdXwB+4yvtu5wCL9717MfRDCN0aL0Mv5t06Nc6nRYhivLM68FB497azwOta4f63gruJ9tYoDkDZODxD5LoHpo+OguzvQbkl2xI9ZyqRJqPb/9V0kZaNxcDgFTcW5gL/C6oXG4z/b5va7wd0XTN4urVXZH"
`endif