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


// $File: //acds/prototype/mm_s10/ip/avalon_st/altera_avalon_st_handshake_clock_crosser/altera_avalon_st_clock_crosser.v $
// $Revision: #4 $
// $Date: 2015/06/18 $
// $Author: nkrueger $
//------------------------------------------------------------------------------
 
`timescale 1ns / 1ns
`default_nettype none

module alt_hiconnect_clock_crosser (
                                 in_clk,
                                 in_reset,
                                 in_ready,
                                 in_valid,
                                 in_data,
                                 out_clk,
                                 out_reset,
                                 out_ready,
                                 out_valid,
                                 out_data
                                );

  parameter  SYMBOLS_PER_BEAT    = 1;
  parameter  BITS_PER_SYMBOL     = 8;
  parameter  FORWARD_SYNC_DEPTH  = 2;
  parameter  BACKWARD_SYNC_DEPTH = 2;
  parameter  USE_OUTPUT_PIPELINE = 1;
 
  localparam  DATA_WIDTH = SYMBOLS_PER_BEAT * BITS_PER_SYMBOL;
  localparam DRC_WAIVER_CDC_50005 = {"-name DESIGN_ASSISTANT_EXCLUDE \"CDC-50005\" "};
  localparam DRC_WAIVER_CDC_50006 = {"-name DESIGN_ASSISTANT_EXCLUDE \"CDC-50006\" "};
  localparam DRC_WAIVER_OUT_DATA_BUFFER = { DRC_WAIVER_CDC_50005,";",DRC_WAIVER_CDC_50006}; 

  input wire                  in_clk;
  input wire                  in_reset;
  output wire                 in_ready;
  input wire                  in_valid;
  input wire [DATA_WIDTH-1:0] in_data;

  input wire                   out_clk;
  input wire                   out_reset;
  input wire                   out_ready;
  output wire                  out_valid;
  output wire [DATA_WIDTH-1:0] out_data;

  // Data is guaranteed valid by control signal clock crossing.  Cut data
  // buffer false path.
(* altera_attribute = {"-name SUPPRESS_DA_RULE_INTERNAL \"D101,D102\""}*) reg [DATA_WIDTH-1:0] in_data_buffer;
(* altera_attribute = DRC_WAIVER_OUT_DATA_BUFFER *) reg [DATA_WIDTH-1:0] out_data_buffer;


  reg                     in_data_toggle;
  wire                    in_data_toggle_returned;
  wire                    out_data_toggle;
  reg                     out_data_toggle_flopped, out_data_toggle_1, out_data_toggle_flopped_n;

  wire                    take_in_data;
  wire                    out_data_taken;

  wire                    out_valid_internal;
  wire                    out_ready_internal;   
 
  // Synchronous resets
  reg                     internal_out_sclr;
  reg                     internal_in_sclr;
  wire                    reset_merged;
  wire                    in_reset_merged;
  wire                    out_reset_merged;
 
  assign in_ready = (in_data_toggle_returned ^ in_data_toggle);
  assign take_in_data = in_valid & in_ready;
  assign out_valid_internal = (out_data_toggle_1 ^ out_data_toggle_flopped);
  assign out_data_taken = out_ready_internal & out_valid_internal;
  
 
   
   always @(posedge out_clk) begin
      internal_out_sclr <= out_reset;
   end
    
   always @(posedge in_clk) begin
      internal_in_sclr  <= in_reset;
   end
 
 assign reset_merged  = internal_in_sclr  | internal_out_sclr;
 
        altera_reset_synchronizer
        #(
            .DEPTH      (2),
            .ASYNC_RESET(1'b1)
        )
        alt_rst_req_sync_in_rst
        (
            .clk        (in_clk),
            .reset_in   (reset_merged),
            .reset_out  (in_reset_merged)
        );
 
        altera_reset_synchronizer
        #(
            .DEPTH      (2),
            .ASYNC_RESET(1'b1)
        )
        alt_rst_req_sync_out_rst
        (
            .clk        (out_clk),
            .reset_in   (reset_merged),
            .reset_out  (out_reset_merged)
        );
 
  always @(posedge in_clk) begin
    if (in_reset_merged) begin
      in_data_toggle <= 1'b0;
    end else begin
      if (take_in_data) begin
        in_data_toggle <= ~in_data_toggle;
      end
    end //internal_in_sclr
  end //in_clk always block
  
 
  always @(posedge in_clk) begin
    if (take_in_data) begin
        in_data_buffer <= in_data;
    end
  end
  
  always @(posedge out_clk) begin
    out_data_buffer <= in_data_buffer;
  end
 
always @(posedge out_clk) begin
    if (out_reset_merged) begin
      out_data_toggle_1 <= 1'b0;
    end else begin
       out_data_toggle_1 <= out_data_toggle;
     end //internal_out_sclr
  end //out_clk always block
 
  always @(posedge out_clk) begin
    if (out_reset_merged) begin
      out_data_toggle_flopped <= 1'b0;
    end else begin
      if (out_data_taken) begin
        out_data_toggle_flopped <= out_data_toggle_1;
      end
    end //internal_out_sclr
  end //out_clk always block


  always @(posedge out_clk) begin //for in_ready
    if (out_reset_merged) begin
      out_data_toggle_flopped_n <= 1'b0;
    end else begin
      out_data_toggle_flopped_n <= ~out_data_toggle_flopped;
      end 
  end 

  altera_std_synchronizer #(.depth(FORWARD_SYNC_DEPTH+1)) in_to_out_synchronizer (
				     .clk(out_clk),
				     .reset_n(~out_reset_merged),
				     .din(in_data_toggle),
				     .dout(out_data_toggle)
				     );
  
  altera_std_synchronizer #(.depth(BACKWARD_SYNC_DEPTH+1)) out_to_in_synchronizer (
				     .clk(in_clk),
				     .reset_n(~in_reset_merged),
				     .din(out_data_toggle_flopped_n),
				     .dout(in_data_toggle_returned)
				     );

  generate if (USE_OUTPUT_PIPELINE == 1) begin

      alt_hiconnect_pipeline_base 
      #(
         .BITS_PER_SYMBOL(BITS_PER_SYMBOL),
         .SYMBOLS_PER_BEAT(SYMBOLS_PER_BEAT)
      ) output_stage (
         .clk(out_clk),
         .reset(out_reset_merged),
         .in_ready(out_ready_internal),
         .in_valid(out_valid_internal),
         .in_data(out_data_buffer),
         .out_ready(out_ready),
         .out_valid(out_valid),
         .out_data(out_data)
      );

  end else begin

      assign out_valid = out_valid_internal;
      assign out_ready_internal = out_ready;
      assign out_data = out_data_buffer;

  end

  endgenerate

endmodule

`default_nettype wire
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "RmaAh1StljrApYzWv8itpp3Kax6pmg9DJ1HeKtpktmqliKzgA3WTF0m++4sKRYFRyXSrnXDP3HinFDCcIhiN2PwjH7qJJqQtqRdZYwZkk5wvGYDnnRLzg9DQgYLzgzUeEBb2G0WqjN+Q2xpTXSulSGtPc3MQBfkZKJfQmTxV4WfJ9loGgofYufkH1I3ACw6EjclUPIKuE85y+vKzDKyCBVOzRHsITDlGvPNOARaMkn8IJUp9L+9J3Wj4iP5HWg2zE7EFzQx6LlTOU3BzGtTztwvpBnoZ5Iy/aJv+ouRjDBN4+W6KxdN0Eu2xjtCd7KAEZQQv/B7X8eUXpNflJ4ER6aXPXsBrk9iuZ4ZIAYotY8ddQbT5QS0FtYS5RJWTchE8OqYKx0Cf/a/0RmpeuweXqDvbnvhYdEXtfub1OMHp14QHWvzN3IAxrVVnlpTphHApiRi+OXIcx7s+mHieewvJYsEtH1ElfvaKkVva3p6OP+4jN2mwgxQADl6F0bK8dyDtovklRW8xBBMYmBb6sBUuCf52CsHHZ3jkztqjA6ow9MrcQ106O1FDt7FYcE9FCIuaG4DsFWjLlctkp0l5w+2efxTj6QtuFu4A/2pj8D9pin3i49uo5ph/csjhxkK3C2xpFOKLQAEyU4TztPzeclpKl+WxCDpaqPvgoRKj5/eJS9AfBgtW6E7IKlE6/dEyZCd38Q5e3CR/v8kW6EgJqvNI8WaN+s4/Aas4sgmku12IZd5/XlMAPN6YesYiCxnKHC2gqVt4swG25z4RA9Hco/UjiRGLC9l3uFRZ2R+4CoH9NPPwImRqfiIivEfU45SdMiVIprvwhOUcjsLYrk1fSv5v75Vjg+uOVJjh7O9UQuiWOOxpyXhOW4uUHeq5B2D4fcDPtYmZRn/rcPcpSDLqW2xJxLW6ymYf8n6pTIGEfAJTgoNptVyOG5/PbiGlUKcpW+HZsKGyBoxBba/qycA233xYVMpAl0IG3LGLcZMYRpOkeruzjrTvdzTXOliYW5UhLgsI"
`endif