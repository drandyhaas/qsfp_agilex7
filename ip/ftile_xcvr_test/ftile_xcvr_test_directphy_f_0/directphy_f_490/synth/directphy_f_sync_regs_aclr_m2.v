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
// a particular purpose, are Intel disclaimed.  By making this reference
// design file available, Intel expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Intel.
/////////////////////////////////////////////////////////////////////////////


`timescale 1 ps / 1 ps

// baeckler - 01-08-2012

module directphy_f_sync_regs_aclr_m2 #(
	parameter WIDTH = 32,
	parameter DEPTH = 2		// minimum of 2
)(
	input clk,
	input aclr,
	input [WIDTH-1:0] din,
	output [WIDTH-1:0] dout
);

reg [WIDTH-1:0] din_meta = 0;

reg [WIDTH*(DEPTH-1)-1:0] sync_sr = 0;


always @(posedge clk or posedge aclr) begin
	if (aclr) begin 
		din_meta <= {WIDTH{1'b0}};
		sync_sr <= {(WIDTH*(DEPTH-1)){1'b0}};
	end
	else begin
		din_meta <= din;
		sync_sr <= (DEPTH==2)? din_meta : (sync_sr << WIDTH) | din_meta;
	end
end
assign dout = sync_sr[WIDTH*(DEPTH-1)-1:WIDTH*(DEPTH-2)];

endmodule

// BENCHMARK INFO :  5SGXEA7N2F45C2
// BENCHMARK INFO :  Max depth :  0.0 LUTs
// BENCHMARK INFO :  Total registers : 64
// BENCHMARK INFO :  Total pins : 66
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :                         ; 1               ;       ;
// BENCHMARK INFO :  ALMs : 17 / 234,720 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.702 ns, From din_meta[22], To sync_sr[22]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.705 ns, From din_meta[13], To sync_sr[13]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.708 ns, From din_meta[13], To sync_sr[13]}
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "8qH9cVo09pAnWALEE6z2BDKrWVWnFI5Ou7hormZ79E/tGSVBCgNfmxFQvE9t3s7klXY5XdvnpByaQgBfCHF6Dbm9WN2svsxXF/zx5b/8CDkcUDB41PZNmNdUWNx7xDY3xJ7IgPTPwkMgtDelSr2aywj5LSl0zROc68MOmTBSsO9a1S9TDRa9h5E5qBo+fLmPNkMltB0gOqPF4aO4OqQAye1NWS4OsbZ9+NLF8RRMveCninQQ+huUu9hLw5p7bPoWoWSj75fubRTZi8ACMk0VuFfxDgFO+2drdRVRLeDz6CetwPa1zYiohlP06UMn8XChuXkkFWVIu7Awr1irLZL5r90t2HqFRkKDlpqg8iGRFhAJMha7JjlWjJsAI7+VkNO64ts+d3IqXsb+KpLG7T6EiuKfp9pgey2V8U+ZCqqQ+M5ZvdpfTd878r8mZeY6RlMxYVB5RU4GP1FotH7ehNOI361IMPJ7EgGbmj4xTAK0ojKUMDyKG/9BUFGXCl5v0GIJP+0TXVSVndm8R/2gmnqDvvVpIDD2+Ud0Fz14EU/tNS8Fyc0HdFaFe8quEDKogfxpPRYJG+ewCbRG+hg4Gxhc0OEPk1ljh4C1BcmPIKdSyF9FacWTSYL8uLoZp7UK9vs9p2qubSZxVlWbFcZ0dtx5Ggv2DFYu6Ct0c7FPCCoSmPBUA5dB75GhEVMre08w8Z3sC4DXMX9/MHY9b3/0whGBOOJHZpdB3+2aG0byXa0HoYJ2yDTrBRVxiqnYkTkwmkHXdzfcM3J0dB2xLZL5Nbvx+A7SnAGW9eenm2Kwz5elyGtPTPG14NrQCMyN3RMcRkHLh7DEOP7mBb/Csb7Ez+bOYKiBN9Cp2Gct+8dqSV/2m4Jxj+z9mW3xOClFWmuctcdJ/m8fHWUKSLTLeUKIq5n7PW/+2XVIRp9+2p1nkIy2n72iNxiaIt12JKacLmr+xrhCwRvj/PpxR7gX1NgD3ltAbjUz+67P9euWhYdpQ1rtsmhjYeB2AYUh38VusSmbJ25c"
`endif