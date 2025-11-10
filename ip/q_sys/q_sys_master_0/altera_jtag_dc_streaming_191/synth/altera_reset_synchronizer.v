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


// $Id: //acds/rel/24.2/ip/iconnect/merlin/altera_reset_controller/altera_reset_synchronizer.v#1 $
// $Revision: #1 $
// $Date: 2024/05/02 $

// -----------------------------------------------
// Reset Synchronizer
// -----------------------------------------------
`timescale 1 ns / 1 ns

module altera_reset_synchronizer
#(
    parameter ASYNC_RESET = 1,
    parameter DEPTH       = 2
)
(
    input   reset_in /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R101" */,

    input   clk,
    output  reset_out
);

    // -----------------------------------------------
    // Synchronizer register chain. We cannot reuse the
    // standard synchronizer in this implementation 
    // because our timing constraints are different.
    //
    // Instead of cutting the timing path to the d-input 
    // on the first flop we need to cut the aclr input.
    // 
    // We omit the "preserve" attribute on the final
    // output register, so that the synthesis tool can
    // duplicate it where needed.
    // -----------------------------------------------
    (*preserve*) reg [DEPTH-1:0] altera_reset_synchronizer_int_chain;
    reg altera_reset_synchronizer_int_chain_out;

    generate if (ASYNC_RESET) begin

        // -----------------------------------------------
        // Assert asynchronously, deassert synchronously.
        // -----------------------------------------------
        always @(posedge clk or posedge reset_in) begin
            if (reset_in) begin
                altera_reset_synchronizer_int_chain <= {DEPTH{1'b1}};
                altera_reset_synchronizer_int_chain_out <= 1'b1;
            end
            else begin
                altera_reset_synchronizer_int_chain[DEPTH-2:0] <= altera_reset_synchronizer_int_chain[DEPTH-1:1];
                altera_reset_synchronizer_int_chain[DEPTH-1] <= 0;
                altera_reset_synchronizer_int_chain_out <= altera_reset_synchronizer_int_chain[0];
            end
        end

        assign reset_out = altera_reset_synchronizer_int_chain_out;
     
    end else begin

        // -----------------------------------------------
        // Assert synchronously, deassert synchronously.
        // -----------------------------------------------
        always @(posedge clk) begin
            altera_reset_synchronizer_int_chain[DEPTH-2:0] <= altera_reset_synchronizer_int_chain[DEPTH-1:1];
            altera_reset_synchronizer_int_chain[DEPTH-1] <= reset_in;
            altera_reset_synchronizer_int_chain_out <= altera_reset_synchronizer_int_chain[0];
        end

        assign reset_out = altera_reset_synchronizer_int_chain_out;
 
    end
    endgenerate

endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "NfLz/HKHQO+0dAYBBSVVZCvTQHDsESFklT6hBUO138Bqzk0f3c425fBx01SOob7/nZM1i7TPRrW06sdGCM8Dh5Ol9p2W3jmKVyMRQY4qQey6AMG+xaaIS4ItKm377Dq7ktcxRxNe8vweZnr5AE1kD/lBQ9/GAp2nSiPWxdchloYvF6hN9/HLXa8mt/XtGHSpdAC70PLkRZvBS9lVOYzhVpjfEcs+0ilRD8nxTpLdUY1OSPyANys8yT+MdkA3YRWFINvkmJUn1FKDuLUjUgXwuB8Mq+6hm4CPjVLHa7b/pg1sdYx5Gsa47riRjJIYAUtxb4//+LRd6MUuEtNBh7BmFP6jb1kaBOZLExcaaG2xIhS6kJ98/E/BBNI/m4JKvw0vM8W7pKuK/K+XHrEtmkc4irEwKpp0MLHFcupXrWyoTyrEZU0p+3B38gSMpfE035gFTb87p/ksbedmzTolLhihwNAl2Q2ikC3fPyuf0vdLIYUm24rTvY8AirZ61/QiGQv+HNfOkZIWoVIkXK4dXAXB9wDaSQKyNUHSlV0qax++8PpwgsxG7JLmkkPj1SJbLe/rITY/OwLPFZblsNytRRY9A2lI828HHbO9ve0gtFjtBkKQDra23g0Z1ZrLZvOt0SdDae/uWACcswdvHVlaXIKGHrIF/yfAEYxiscB8bn7fxWZ7a8Rm9RVjJRQRwCMYY0REXM62KLaJh41bVoM8m0thejIK9hzxc/DgboVViQi2t9iQ8iCS+MQgmrXzVG2vAAvhLRZYm+XzQZrkdtIo76Qq3fMALKux4hX9JAwcUWzq4YTrnxj6be3hwnChZATXQEa3tQeG+TVmen2ReHBmWLWkkIIAMgH75tUgFbx7uSfl5sKw7vlRrXo9mXdt0zrWIjcIwVAFmIMAb7gVXDGWYwzKYc2esWeFz2xTyWVLik8KFqBSA0RyMcoxpJxH1zjiGHWvGBQytdip1+FfjojxUCY8whXV3LhmC1x0CTerIfBh1jdLBOnAhE8r4rUZTPC6l2ti"
`endif