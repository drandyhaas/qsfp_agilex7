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


// Clocked priority encoder with state
//
// On each clock cycle, updates state to show which request is granted.
// Most recent grant holder is always the highest priority.
// If current grant holder is not making a request, while others are, 
// then new grant holder is always the requester with lowest bit number.
// If no requests, current grant holder retains grant state

// $Header$

// Same as  ../../../altera_xcvr_generic/ctrl/alt_xcvr_arbiter.sv without timescale

//altera message_off 16753
module alt_xcvr_arbiter #(
	parameter width = 2
) (
	input  wire clock,
	input  wire [width-1:0] req,	// req[n] requests for this cycle
	output reg  [width-1:0] grant	// grant[n] means requester n is grantee in this cycle
);

	wire idle;	// idle when no requests
	wire [width-1:0] keep;	// keep[n] means requester n is requesting, and already has the grant
							// Note: current grantee is always highest priority for next grant
	wire [width-1:0] take;	// take[n] means requester n is requesting, and there are no higher-priority requests

	assign keep = req & grant;	// current grantee is always highest priority for next grant
	assign idle = ~| req;		// idle when no requests

	initial begin
		grant = 0;
	end

	// grant next state depends on current grant and take priority
	always @(posedge clock) begin
		grant <= 
// synthesis translate_off
                    (grant === {width{1'bx}})? {width{1'b0}} :
// synthesis translate_on
				keep				// if current grantee is requesting, gets to keep grant
				 | ({width{idle}} & grant)	// if no requests, grant state remains unchanged
				 | take;			// take applies only if current grantee is not requesting
	end

	// 'take' bus encodes priority.  Request with lowest bit number wins when current grantee not requesting
	assign take[0] = req[0]
					 & (~| (keep & ({width{1'b1}} << 1)));	// no 'keep' from lower-priority inputs
	genvar i;
	generate
	for (i=1; i < width; i = i + 1) begin : arb
		assign take[i] = req[i]
						 & (~| (keep & ({width{1'b1}} << (i+1))))	// no 'keep' from lower-priority inputs
						 & (~| (req & {i{1'b1}}));	// no 'req' from higher-priority inputs
	end
	endgenerate
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "nCGwL7lzt/m/WFAQ4QXqLmRPfF6Wj21Jefe5fFK0n7gcuQNsHh2sBlqZ+11PNPjyxzwa+Hdd2O8YzEqxZzn+6F74S48UVBL9uy9Ohhks30vbMRe+/DTi+iSns1i4S/m9zb8v2lhQA6neHZSR/UmkHyUfCynOxtPr8NM8DW9SLTFfXq+AHUYajfgL0rKI5GqzNkeq/32NLBgNbCQWeSEYhRPhOba7zuhfHJ3odOJRP8qsloAj+vsyGSUoyC2wT+RGAvinpiODTfgogX5PeNZLq/TiXCpWRMC7Wg0P4SCTBY9Pm7s2H06wcVCXAlywU+dQfBnWa2dw5ccdHAJAcTT+EMFP525FWyPmB77mk8rU25+Q4R6LWBfc++SnLSluU+70UURgNQw6Lt7hoHDqBau9d3HPANfcBy5kL/HdAHyEf0LG+jDNWplP2028wyomAnRjabdmeUvSlKD002asR8J5kUc7R7dt4bWAZEn6e0ZxChfHwhrvHXtILgczrDcfJRKk+gpM0Nre98E5hXxCESITINxcLDx+0FZL8YyjWeU2XyWn8rEe+XvAhv7BTvBxO/Vsmj08kg04W+RhzSokLJOMZluMYeMsv9X45iMnBSgrom9waP6knwoQUh/CTCgCVNJVSpVucSe9vkrtRJhwibYcbhK6hD7AtHKyiOUAG5E9WrF9vUJNiUxrXKS114P9bHFY4WJLCuLGgEZHy1nrFgSXprreQ1mO0hOm+bnosLbbW4vbhAarDfFWUgrDKsmgKPPQHAMjCvelKWBDL3w7IAQ4ATQGQxUeiPrwV+Tpk2NKBllfsdBH0FdpPO3SkFGfzi/LZnh7CnsttW2v5unDl0ve9X0oOyw+LCAHWfR6tMyTERvC8Bb98TmazonlBzMPg4yYADDXtGa2SwIQLM/glpdl7YJNXL+uXqZzrtzGNbwqUSXGqQPdSp3/ftgoNPQVIpgII58ld/irWPp4lDqb+LW8drL6EXlOyzzNHSjrRJ43B5Xg/Dzv/16iBoYsYyjmVM8Y"
`endif