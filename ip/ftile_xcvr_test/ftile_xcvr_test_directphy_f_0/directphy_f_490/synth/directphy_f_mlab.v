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


`timescale 1 ps / 1 ps //RG commented
// baeckler - 07-12-2014
// DESCRIPTION
// Wrapper for MLAB hardware cells in typical arrangement

module directphy_f_mlab #(
	parameter WIDTH = 20,
	parameter ADDR_WIDTH = 5,
	parameter SIM_EMULATE = 1'b0   // this may not be exactly the same at the fine grain timing level 
)
(
	input wclk,
	input wena,
	input [ADDR_WIDTH-1:0] waddr_reg,
	input [WIDTH-1:0] wdata_reg,
	input [ADDR_WIDTH-1:0] raddr,
	output [WIDTH-1:0] rdata		
);

genvar i;
generate
	if (!SIM_EMULATE) begin
        /////////////////////////////////////////////
        // hardware cells

        // the fourteen nm only (the Stratix 10) needs another data register
       // reg [WIDTH-1:0] wdata_reg_2 /* synthesis preserve */;
       // always @(posedge wclk) wdata_reg_2 <= wdata_reg;


		for (i=0; i<WIDTH; i=i+1)  begin : ml
			wire wclk_w = wclk;  // workaround strange modelsim warning due to cell model tristate
            // Note: the stratix 5 cell is the same other than timing
			//stratixv_mlab_cell lrm (
                        tennm_mlab_cell lrm (
				.clk0(wclk_w),
				.ena0(wena),
				
				// synthesis translate_off
				.clk1(1'b0),
				.ena1(1'b1),
				//.ena2(1'b1),
				.clr(1'b0),
				.devclrn(1'b1),
				.devpor(1'b1),
				// synthesis translate_on			

				.portabyteenamasks(1'b1),
				//.portadatain(wdata_reg_2[i]),
				.portadatain(wdata_reg[i]),
				.portaaddr(waddr_reg),
				.portbaddr(raddr),
				.portbdataout(rdata[i])			
				
			);

			defparam lrm .mixed_port_feed_through_mode = "dont_care";
			defparam lrm .logical_ram_name = "lrm";
			defparam lrm .logical_ram_depth = 1 << ADDR_WIDTH;
			defparam lrm .logical_ram_width = WIDTH;
			defparam lrm .first_address = 0;
			defparam lrm .last_address = (1 << ADDR_WIDTH)-1;
			defparam lrm .first_bit_number = i;
			defparam lrm .data_width = 1;
			defparam lrm .address_width = ADDR_WIDTH;
		end
	end
	else begin
		/////////////////////////////////////////////
		// sim equivalent

		localparam NUM_WORDS = (1 << ADDR_WIDTH);
		reg [WIDTH-1:0] storage [0:NUM_WORDS-1];
		integer k = 0;
		initial begin
			for (k=0; k<NUM_WORDS; k=k+1) begin
				storage[k] = 0;
			end
		end

		always @(posedge wclk) begin
			if (wena) storage [waddr_reg] <= wdata_reg;	
		end

		reg [WIDTH-1:0] rdata_b = 0;
		always @(*) begin
			rdata_b = storage[raddr];
		end
		
		assign rdata = rdata_b;
	end
	
endgenerate

endmodule	

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "8qH9cVo09pAnWALEE6z2BDKrWVWnFI5Ou7hormZ79E/tGSVBCgNfmxFQvE9t3s7klXY5XdvnpByaQgBfCHF6Dbm9WN2svsxXF/zx5b/8CDkcUDB41PZNmNdUWNx7xDY3xJ7IgPTPwkMgtDelSr2aywj5LSl0zROc68MOmTBSsO9a1S9TDRa9h5E5qBo+fLmPNkMltB0gOqPF4aO4OqQAye1NWS4OsbZ9+NLF8RRMveAK0cBJffBHHVhB0YFBgKbPXqQmzQpIEQY2J9w+/Bbywlam0fq9BQsizujbJzUxCQk9RqbD3QxRl+Ui6g33D59FfS7r2SZTTpJhcxZRPKNTtftHCgalavh5iPbbTTLSw6XgGQ7JTiDxrd2K4K1gPliCHrpTKjIb71xruE4a4RGtWYPGkqqm5D977esG4OoTE5wi97Le4p4MrK5G0/PAuhjSNrQK5hkYhDQKlaNX7xsd05nw/0hE4oxIFP/waPELlF0KxruL8V3uLBYfwUZlQ+08GT4yAe6d6R00u8XD1FBKxn7jG01b0soVOjsBlOnarPh54Oz2d2WLXVh6S0+U+uO0x8zfNGPrJyM+tGUV1ZS/PwdIVS5TvYqCDyT5QwDXuJaZUM3C6oEiXXMOz9UlcmIMQZWnL1D07RzTjFdLcvep4Ee4jkR7QjLY3lyklsIFSP1bMnA+D3GTQW72ZOx3Q+916wS0jRe/Er1gf7xR6rA0jWGXRhjrnYnBrc5AxF/NuBDb9aQnQosR3hRLLBJiSCQCmJiKEnTCLDQSDr4psbjxWuy2zHnba7Kuo9pcevLuCMXqxO+pyxUw65doeUxp9Y+QAPIJYzynGnxrgVr0oUG2BSojPHY8f4x1uagySrKRROOnV/gN3iM8mdw2HOIAi9xelWR6oDx5nlZN/LYztg+4t8YcfarCZ0Ghmtnrhi06J3vOUEBr3WpVC8t+GOf+qSI2MFgiA9GhJNvjGaZDLDFwEWGb52JYzLjclpQfwuvnfSbyeeoYC+uplWYFeDhZ+7nG"
`endif