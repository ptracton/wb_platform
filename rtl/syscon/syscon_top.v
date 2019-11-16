//                              -*- Mode: Verilog -*-
// Filename        : syscon_top.v
// Description     : Syscon Top Level Module
// Author          : Phil Tracton
// Created On      : Wed Jul 10 14:14:51 2019
// Last Modified By: Phil Tracton
// Last Modified On: Wed Jul 10 14:14:51 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!


module syscon_top (/*AUTOARG*/
   // Outputs
   wb_dat_o, wb_ack_o, wb_err_o, wb_rty_o, control_leds, wb_clk_o,
   wb_rst_o, clk_10MHZ, locked,
   // Inputs
   wb_cyc_i, wb_adr_i, wb_dat_i, wb_sel_i, wb_we_i, wb_stb_i,
   clk_pad_i, rst_pad_i
   ) ;

   parameter SLAVE_ADDRESS = 32'h0000_0000;
   parameter dw = 32;
   parameter aw = 32;

   //
   // WISHBONE Interface
   //
   input             wb_cyc_i;	// cycle valid input
   input [aw-1:0]    wb_adr_i;	// address bus inputs
   input [dw-1:0]    wb_dat_i;	// input data bus
   input [3:0]       wb_sel_i;	// byte select inputs
   input             wb_we_i;	// indicates write transfer
   input             wb_stb_i;	// strobe input
   output [dw-1:0]   wb_dat_o;	// output data bus
   output            wb_ack_o;	// normal termination
   output            wb_err_o;	// termination w/ error
   output            wb_rty_o;  // re-try
   output [1:0]      control_leds;

   input             clk_pad_i;
   input             rst_pad_i;
   output            wb_clk_o;
   output            wb_rst_o;
   output            clk_10MHZ;

   output wire       locked;


   syscon syscon0(
                  // Outputs
                  .wb_clk_o             (wb_clk_o),
                  .wb_rst_o             (wb_rst_o),
                  .clk_10MHZ            (clk_10MHZ),
                  .locked               (locked),
                  // Inputs
                  .clk_pad_i            (clk_pad_i),
                  .rst_pad_i            (rst_pad_i));


   syscon_regs #(.SLAVE_ADDRESS(SLAVE_ADDRESS), .aw(aw), .dw(dw))
   regs(
        // Outputs
        .wb_dat_o                       (wb_dat_o[dw-1:0]),
        .wb_ack_o                       (wb_ack_o),
        .wb_err_o                       (wb_err_o),
        .wb_rty_o                       (wb_rty_o),
        .control_leds                   (control_leds),
        // Inputs
        .wb_clk                         (wb_clk_o),
        .wb_rst                         (wb_rst_o),
        .wb_cyc_i                       (wb_cyc_i),
        .wb_adr_i                       (wb_adr_i[aw-1:0]),
        .wb_dat_i                       (wb_dat_i[dw-1:0]),
        .wb_sel_i                       (wb_sel_i[3:0]),
        .wb_we_i                        (wb_we_i),
        .wb_stb_i                       (wb_stb_i),
        .locked                         (locked));

endmodule // syscon_top
