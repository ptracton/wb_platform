//                              -*- Mode: Verilog -*-
// Filename        : daq_slave.v
// Description     : Data Acquisition Slave
// Author          : Phil Tracton
// Created On      : Mon Apr 15 16:11:29 2019
// Last Modified By: Phil Tracton
// Last Modified On: Mon Apr 15 16:11:29 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

module daq_slave (/*AUTOARG*/
   // Outputs
   wb_dat_o, wb_ack_o, wb_err_o, wb_rty_o,
   // Inputs
   wb_clk, wb_rst, wb_adr_i, wb_dat_i, wb_sel_i, wb_we_i, wb_cyc_i,
   wb_stb_i, wb_cti_i, wb_bte_i
   ) ;

   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;

   input wb_clk;
   input wb_rst;

   input wire [aw-1:0] wb_adr_i;
   input wire [dw-1:0] wb_dat_i;
   input wire [3:0]    wb_sel_i;
   input wire          wb_we_i ;
   input wire          wb_cyc_i;
   input wire          wb_stb_i;
   input wire [2:0]    wb_cti_i;
   input wire [1:0]    wb_bte_i;

   output reg [dw-1:0] wb_dat_o;
   output reg          wb_ack_o;
   output reg          wb_err_o;
   output reg          wb_rty_o;

   initial begin
      wb_dat_o <= 0;
      wb_ack_o <= 0;
      wb_err_o <= 0;
      wb_rty_o <= 0;
   end

endmodule // daq_slave
