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
//| Avalon ST Idle Remover 
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module altera_avalon_st_idle_remover (

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
         if (in_valid & in_ready) begin
            if (escape_char & ~received_esc) begin
                 received_esc <= 1;
            end else if (out_valid) begin
                 received_esc <= 0;
            end
         end
      end
   end

   always @* begin
      in_ready = out_ready;
      //out valid when in_valid.  Except when we get idle or escape
      //however, if we have received an escape character, then we are valid
      out_valid = in_valid & ~idle_char & (received_esc | ~escape_char);
      out_data = received_esc ? (in_data ^ 8'h20) : in_data;
   end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "NfLz/HKHQO+0dAYBBSVVZCvTQHDsESFklT6hBUO138Bqzk0f3c425fBx01SOob7/nZM1i7TPRrW06sdGCM8Dh5Ol9p2W3jmKVyMRQY4qQey6AMG+xaaIS4ItKm377Dq7ktcxRxNe8vweZnr5AE1kD/lBQ9/GAp2nSiPWxdchloYvF6hN9/HLXa8mt/XtGHSpdAC70PLkRZvBS9lVOYzhVpjfEcs+0ilRD8nxTpLdUY0UtZ5dVuHge777xpg/24K59wLuzRnQZ+5DR4VuH+R4NHmczn5oMbLJMI9e3aqn6wM7JxFrBEIuHq6rjooIvRnfWXxpx4WQrhdcVdVcRGfemPwaCQOS8gi1TUR/G1b0WiA7PB3p9jChv2iEpR2nf8ZGCUZDwu3FouEQFezFOFXNciwQPUDSHaA1Fr7E5eFyyd6oYHVLp2GQu8/rWjCYt1ye+COaxhtp4eshnszVFLAyXLNsftILl56XLaRZ/jvw6vlQ/4mZRfu1AA9oraGQezWQvtpPNH4Qgu/v5aSRmRO6xmq9Vh8eCVhr9Or6GUmKbTkxH9qrNvgr6TjbXtKSBH3RVrkG4PZr2Uji0xKaVgST+BM8VDd2l4HK6Pg9WGONY2kzHo87fn0tTTrs22yPBpcYsO2JfQbToBONbhQQ8CbXkzIn3++9hwBtC1jHwDdd7rJeYasJs3xBpNc4Z2BVPQlYRbjunu8nmUregsDl9yz3iwM5212Y5fsbUXdIstSHgQ63225zCq3AyBmsmg88TwnOfiEcgodI5z28Gc+0n9WWz/KER1SWuVD0RfwM17aWXhM94rMFqSXoCfmA2VYaOUiDdPGYi9yjXLNp3yAh1pGtk2yv70KDGu1HLcKi6ORx0dhNvxW62CfdljCdDBPD51FpCoeM//q3xE75nDDj1eNXDRfZfKUw5axvtN0phM8eJDH4RHfcyXtIFNbvHRyO1qXeNDpwlocfm3n2QB06ViMrY/o2JIUrV0Dkslj6Ui5x6LBT1v9SE3Fb80CwVLD+Ni+w"
`endif