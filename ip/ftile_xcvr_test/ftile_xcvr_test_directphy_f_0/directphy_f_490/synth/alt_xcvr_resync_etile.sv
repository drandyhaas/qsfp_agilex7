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


// (C) 2001-2019 Intel Corporation. All rights reserved.
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


// Module: alt_xcvr_resync_etile
//
// Description:
//  A general purpose resynchronization module that uses the recommended altera_std_synchronizer 
//  and altera_std_synchronizer_nocut synchronizer
//  
//  Parameters:
//    SYNC_CHAIN_LENGTH
//      - Specifies the length of the synchronizer chain for metastability
//        retiming.
//    WIDTH
//      - Specifies the number of bits you want to synchronize. Controls the width of the
//        d and q ports.
//    SLOW_CLOCK - USE WITH CAUTION. 
//      - Leaving this setting at its default will create a standard resynch circuit that
//        merely passes the input data through a chain of flip-flops. This setting assumes
//        that the input data has a pulse width longer than one clock cycle sufficient to
//        satisfy setup and hold requirements on at least one clock edge.
//      - By setting this to 1 (USE CAUTION) you are creating an asynchronous
//        circuit that will capture the input data regardless of the pulse width and 
//        its relationship to the clock. However it is more difficult to apply static
//        timing constraints as it ties the data input to the clock input of the flop.
//        This implementation assumes the data rate is slow enough
//    INIT_VALUE
//      - Specifies the initial values of the synchronization registers.
//	  NO_CUT
//		- Specifies whether to apply embedded false path timing constraint. 
//		  0: Apply the constraint 1: Not applying the constraint
//

`timescale 1ps/1ps 

module alt_xcvr_resync_etile #(
    parameter SYNC_CHAIN_LENGTH = 2,  // Number of flip-flops for retiming. Must be >1
    parameter WIDTH             = 1,  // Number of bits to resync
    parameter SLOW_CLOCK        = 0,  // See description above
    parameter INIT_VALUE        = 0,
    parameter NO_CUT		= 1	  // See description above
  ) (
  input   wire              clk,
  input   wire              reset,
  input   wire  [WIDTH-1:0] d,
  output  wire  [WIDTH-1:0] q
  );

localparam  INT_LEN       = (SYNC_CHAIN_LENGTH > 1) ? SYNC_CHAIN_LENGTH : 2;
localparam  L_INIT_VALUE  = (INIT_VALUE == 1) ? 1'b1 : 1'b0;

genvar ig;

// Generate a synchronizer chain for each bit
generate for(ig=0;ig<WIDTH;ig=ig+1) begin : resync_chains
	wire                d_in;   // Input to sychronization chain.
	wire				sync_d_in;
	wire		        sync_q_out;
	
	// Adding inverter to the input of first sync register and output of the last sync register to implement power-up high for INIT_VALUE=1
	assign sync_d_in = (INIT_VALUE == 1) ? ~d_in : d_in;
	assign q[ig] = (INIT_VALUE == 1)  ? ~sync_q_out : sync_q_out;
	
	if (NO_CUT == 0) begin		
		altera_std_synchronizer #(
			.depth(INT_LEN)				
		) synchronizer (
			.clk		(clk),
			.reset_n	(~reset),
			.din		(sync_d_in),
			.dout		(sync_q_out)
		);
		
		//synthesis translate_off			
		initial begin
			synchronizer.dreg = {(INT_LEN-1){1'b0}};
			synchronizer.din_s1 = 1'b0;
		end
		//synthesis translate_on
				
	end else begin
		altera_std_synchronizer_nocut_etile #(
			.depth(INT_LEN)				
		) synchronizer_nocut (
			.clk		(clk),
			.reset_n	(~reset),
			.din		(sync_d_in),
			.dout		(sync_q_out)
		);
				
		//synthesis translate_off
		initial begin
			synchronizer_nocut.dreg = {(INT_LEN-1){1'b0}};
			synchronizer_nocut.din_s1 = 1'b0;
		end
		//synthesis translate_on	
	end
	
    // Generate asynchronous capture circuit if specified.
    if(SLOW_CLOCK == 0) begin
      assign  d_in = d[ig];
    end else begin
      wire  d_clk;
      reg   d_r = L_INIT_VALUE;
      wire  clr_n;

      assign  d_clk = d[ig];
      assign  d_in  = d_r;
      assign  clr_n = ~q[ig] | d_clk; // Clear when output is logic 1 and input is logic 0

      // Asynchronously latch the input signal.
      always @(posedge d_clk or negedge clr_n)
        if(!clr_n)      d_r <= 1'b0;
        else if(d_clk)  d_r <= 1'b1;
    end // SLOW_CLOCK
  end // for loop
endgenerate

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "zwUrMtkzDN2UDbcYeGjDRmtIz4xd5DvPGFnA+mEcOmzjaoEi2bC2Gl+MmCzBWiiGf78N12ivlZqsvRWpcpZKc84L/ahDa/4tPwhhgBZ4raGiZDcumbXYVQuhRyFlx4js4lmD0mD2CYjhgk6IxzySt9Lxh0rMD4TEbts9gt0fiD2A+ug+6jZNAixWGAUmJTbqe+Mso77Eos7PaWcPu2bZnySgfzLncYgAp9oHZ//M2nbDTt/X6EP6sTMdb+OdxGuh2QfutX+iFrt1T+0xmv45Yy+oMwT0mI9e09N4shLOIqdWJYSOvRZNBv7OxDCd2E37/C4iqTNG11YpyShO34VV3i7ccpipSZdhYtw6frSrqtwDJCk8ujW6FRd2AgUDon62uYGeZh32YKiLio/vO3Mvoe0GB1/Kr5o0ooc3h8Sz0E3oq5kHaP6LJel8VUE6OCBGNZL5sP/LcODti8SimFTHYyTBzeEH2vSKZMZRyi84tZlpfct+HPK7DCA51+h8ZoxGT7JXhyGuGAJ6bAsH+z6LzDEfrTLGx6LOUDaz7wa27VlalkaUrnuG3/vID9Ykg6tZ2kjfRaYS1xxSa4ZG40Z/+8g4ZPkttDWfFKYyjdvUnkQTilj3RikXQGM3saTjIg+6ZthjyKPJzjVKJmOf5CJ/RyEHkwnyFToIbPQSu1Tc4NjHyxKaGZvUhQgjQFpeZUwDNe5PNY4unRuI4pW4HQEQ3ap0b2M4i7bMU7+9RWmNDKUK60VqNUiqHLlieaS0Qluy5xW669bmnz8k9qrt7of0iyhtlE9RWaVLKxRawlz7z1KYaE9veTL9fYmrLg482mn0GXN5xSQ6MyY5RbPD8fRbrDcbtMrK2iytJDt2vE6I057+xQYESwzxIt8mBAXraRSvb/hEB8M8Vtnh8ysoG1+QjGwrr3n2Y44Xo3HnltxYVBhMItpUqfV6cYXgc9O4xPOGUfdoEikiCOHlde5cHt5XbZ9aArM4Q08Dg4yoQlcOgSz3FiujXrPfZ9qZI9MX1ba1"
`endif