/*
  Legal Notice: (C)2017 Intel Corporation. All rights reserved.  Your
  use of Intel Corporation's design tools, logic functions and other
  software and tools, and its AMPP partner logic functions, and any
  output files any of the foregoing (including device programming or
  simulation files), and any associated documentation or information are
  expressly subject to the terms and conditions of the Intel Program
  License Subscription Agreement or other applicable license agreement,
  including, without limitation, that your use is for the sole purpose
  of programming logic devices manufactured by Intel and sold by Intel
  or its authorized distributors.  Please refer to the applicable
  agreement for further details.
*/

/*
xcvr_conduit_ctrl.v

Description:  
This component is used to contrl conduits of TX Native PHY IP Core

Initial release 	1.0: 2017/12
*/

module  xcvr_conduit_ctrl
        (
        input  wire                 reset_n,
        input  wire                 clk,
        input  wire [3:0]           csr_address,
        input  wire                 csr_read,
        input  wire                 csr_write,
        output reg  [31:0]          csr_readdata,
        input  wire [31:0]          csr_writedata,

        input  wire                 tx_pll_locked,
        input  wire                 rx_is_lockedtoref,
        input  wire                 rx_is_lockedtodata,

        output wire                 tx_reset,
        input  wire                 tx_reset_ack,
        input  wire                 tx_ready,

        output wire                 rx_reset,
        input  wire                 rx_reset_ack,
        input  wire                 rx_ready
        );

    reg  [31:0] contrl;
    wire [31:0] tx_rx_status;

    assign tx_reset            = contrl[0];
    assign rx_reset            = contrl[1];

    assign tx_rx_status[0]     = tx_pll_locked;
    assign tx_rx_status[1]     = rx_is_lockedtoref;
    assign tx_rx_status[2]     = rx_is_lockedtodata;
    assign tx_rx_status[3]     = 1'b0;
    assign tx_rx_status[4]     = tx_reset_ack;
    assign tx_rx_status[5]     = tx_ready;
    assign tx_rx_status[6]     = 1'b0;
    assign tx_rx_status[7]     = 1'b0;
    assign tx_rx_status[8]     = rx_reset_ack;
    assign tx_rx_status[9]     = rx_ready;
    assign tx_rx_status[10]    = 1'b0;
    assign tx_rx_status[11]    = 1'b0;
    assign tx_rx_status[31:12] = 20'h00000;
	
    always @ (posedge clk or negedge reset_n)begin
        if (reset_n == 0)begin
            contrl <= 32'h00000000;
        end else if(csr_write == 1)begin
            case(csr_address)
                0:contrl <= csr_writedata;
                default:;
            endcase
        end
    end

    always @ (posedge clk or negedge reset_n)begin
        if (reset_n == 0)begin
            csr_readdata <= 0;
        end else if(csr_read == 1)begin
            case(csr_address)
                0:csr_readdata <= contrl;
                1:csr_readdata <= tx_rx_status;
                default:csr_readdata <= 0;
            endcase
        end
    end

endmodule





