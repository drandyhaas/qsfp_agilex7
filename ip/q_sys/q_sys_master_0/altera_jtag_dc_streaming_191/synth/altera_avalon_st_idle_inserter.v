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


// --------------------------------------------------------------------------------
//| Avalon ST Idle Inserter 
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module altera_avalon_st_idle_inserter (

      // Interface: clk
      input              clk,
      input              reset_n,
      // Interface: ST in
      output reg         in_ready,
      input              in_valid,
      input      [7: 0]  in_data,

      // Interface: ST out 
      input              out_ready,
      output reg         out_valid,
      output reg [7: 0]  out_data
);

   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------

   reg  received_esc;
   wire escape_char, idle_char;

   // ---------------------------------------------------------------------
   //| Thingofamagick
   // ---------------------------------------------------------------------

   assign idle_char = (in_data == 8'h4a);
   assign escape_char = (in_data == 8'h4d);

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         received_esc <= 0; 
      end else begin
         if (in_valid & out_ready) begin
            if ((idle_char | escape_char) & ~received_esc & out_ready) begin
                 received_esc <= 1;
            end else begin
                 received_esc <= 0;
            end
         end
      end
   end

   always @* begin
      //we are always valid
      out_valid = 1'b1;
      in_ready = out_ready & (~in_valid | ((~idle_char & ~escape_char) | received_esc));
      out_data = (~in_valid) ? 8'h4a :    //if input is not valid, insert idle
                 (received_esc) ? in_data ^ 8'h20 : //escaped once, send data XOR'd
                 (idle_char | escape_char) ? 8'h4d : //input needs escaping, send escape_char
                 in_data; //send data
   end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "NfLz/HKHQO+0dAYBBSVVZCvTQHDsESFklT6hBUO138Bqzk0f3c425fBx01SOob7/nZM1i7TPRrW06sdGCM8Dh5Ol9p2W3jmKVyMRQY4qQey6AMG+xaaIS4ItKm377Dq7ktcxRxNe8vweZnr5AE1kD/lBQ9/GAp2nSiPWxdchloYvF6hN9/HLXa8mt/XtGHSpdAC70PLkRZvBS9lVOYzhVpjfEcs+0ilRD8nxTpLdUY2PID4epNU37GZvYzcQ1D1vYT8kwFwkblmKaMGbEOHxcgja6qc/F5Ur/r/zI+JqnvlcKrVcK81nPJdFJfUevFpk4irOafyzd78BxEvME6p984LpVJfKiktrnle49kZCzxWTrtiat8V/+6t9J6rPYsf7XP+RZf91lwLnslAYlmVW5swV1ijOCaMSU11qwXYFf96tMrdhokKakEXXD02v2adAQ9CJBbsBocn9BbioltJa0RGp5XhriSYQy17tbAcAiTTTaTZVuL8slzdpGqT3FuUjZJVwbCPR9hmCS1BAxGpVPTY1JRoVCf8HdTe/+ZOYzfV9NNBrAl6QyzccgNchSA3nzHCIf75/hwafKpyosPA9jPp6neyKoKgxqjQsjezSpZhvdjzekhq0TkL1G362iI/cZB1Z9IRHIrSVkXUh8Qqxu+HEDQC8U5yrf6n0HojxB0yMkr6mLGrLrw8/EiMBz+FDxNnpgVvw9Pdx26QbNoexEyXO1nUpJ5oFJkIcgft9Gqq1BY/3D1U+dj9VZGpFLoIdY20CZzttSBndDPjAZPoKaQWT+buG5ApZuigoH3nAGlabbrkeGEs6RyGBWbQFA2cd5BWbYGwGPb3pJ6mZUDbOC2gZKxd3uvA17PrMTUm5H3WODR5o6hPqoWTkgmeIcRoJm+5HcUgYwx6+vrNy/i7CMzis8WXAKjon6OEcWLnWrNA+qUAaHKjOus9uCyJE1ol6v/mPRvuG+NwpWdTlXMWK7T8QvVXyC7dqfOcToDxSMZ9wBMdjoZZQ6HFUgVd3SXun"
`endif