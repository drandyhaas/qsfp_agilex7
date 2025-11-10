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
`pragma questa_oem_00 "VDv2IgOtJR/SzaNQHg+9Aj8qwqlbyn1iYmKkvNucn5FHJMjMkfS3AgH3z2i0/HkOyMwM+z5BL/SYvDvEKmtuZxptGigdDe+ODv8OoSpBvsMB/+HP4NuWtAS91oaQlEAdUyKaNG2U0fnTP4HAr5lNOksHZh5PuznRc5HXeYLjad9yv208jxxU6tMpz7cP9Px6Mhk8uIhYFUBqQHGVYNKrLT3DISJNiLBVA9TFCvN/R2kzTXE0FQsBcmTTLytIY8o6R3kc2MAsNdtl+c7Et36WMezO4X2OuZ7+NPEc3BIXGjjkMR4JFHavUlFq/oyxZu6mVwVwrpVw5sMC+5C/T/kWYqwG7lHm144wrWy/ELCSy4RpRJYgczpAy/fdnnFfGp/wNWExnGgcVSvqFqoDKASV5bZuirGLynXxjY836bGcBFujxBl3e5ethnQZ8ELL8EsaKIO6vDMVEKc15Jnoau0xjwyKlnudTF7gQUkM3DOZaK9XFDyuORFAbxFsTBqAOZkgj1tDr3j68Urv9YlCSLgtN2xhpvudHO733BDXC3ERyU2WmWCxc1ff34eEbw4O3Wveol3RO0yRcrhVJe5lRksllku8un8l67yNEjMciir8URTnSGwTcl+HlkBo7FnTu4G6nbpvCugDT1h5ZjAchv4HJ0gMyaCLOh85Guy4Tj7w4v6cb7Slb9m0+5tTKv35D77olkNb/YS/7CIpX998pRntRlUfwy9G8BnUCueLbdjFrK2j2bZ8XQMwSTGHrUKuIj7hXUbVvZYjG1T41aFtv4brDpiwNyDI5kWDMbBzgPlqgJSmaS58fawtCKLs3fy8jMmETObFDPbHlDasfnW/4DdRdSwGT/xfezb2EO7rJnH2Faem+I+wpmJp8Y/4mr2JtyVRy3lSdejFhE/TzXusgzfHp4wrdsiTDMWX9D93SDBUO71MCVyIICPCW8KZjoG/XVvUz58A/rEC0g4bSK76eKx3XwHfyk/JIvox0gk7mUR+Et44/9UqzkprCns6qrYJJ97a"
`endif