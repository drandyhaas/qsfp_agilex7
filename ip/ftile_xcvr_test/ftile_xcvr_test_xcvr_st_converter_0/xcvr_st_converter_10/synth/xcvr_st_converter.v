/*
This module is to convert XCVR native PHY signals to Qsys capable signals.
Converts conduit to Avalon-Streaming signals.



*/

module  xcvr_st_converter( 
	
	//local side
	input  [DATAWIDTH*4/5-1 : 0]tx_data_a,
	output [DATAWIDTH*4/5-1 : 0]rx_data_a,
	output tx_clkout_a,
	output rx_clkout_a,
	output tx_clkout_sample,
	output tx_clkout_a_output,
	output rx_clkout_a_output,
	
	//XCVR side
	input [NUM_OF_CH-1:0]tx_clkout,
	output [DATAWIDTH * NUM_OF_CH-1 : 0]tx_parallel_data, // For each 80 bit word  the 64 active data bits are tx_parallel_data[63:0];
	input [NUM_OF_CH-1:0]rx_clkout,
	input [DATAWIDTH * NUM_OF_CH-1 : 0]rx_parallel_data // For each 80 bit word  the 64 active data bits are rx_parallel_data[63:0];
	
);
	parameter DATAWIDTH = 40;
	parameter NUM_OF_CH = 1;

	assign tx_parallel_data[DATAWIDTH-1:0] = {{(DATAWIDTH*1/10){1'b0}},tx_data_a[DATAWIDTH*8/10-1:DATAWIDTH*2/5],1'b0,1'b1,6'd0, tx_data_a[DATAWIDTH*2/5-1:0]}; // [71:40],[31:0],64-bit active
	assign rx_data_a = {rx_parallel_data[DATAWIDTH*9/10-1:DATAWIDTH*1/2],rx_parallel_data[DATAWIDTH*2/5-1:0]}; // [71:40],[31:0],64-bit active
	
	assign tx_clkout_a = tx_clkout[0];
	assign rx_clkout_a = rx_clkout[0];
	assign tx_clkout_sample = tx_clkout[0];
	assign tx_clkout_a_output = tx_clkout[0];
	assign rx_clkout_a_output = rx_clkout[0];

	
endmodule


