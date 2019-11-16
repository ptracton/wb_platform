//                              -*- Mode: Verilog -*-
// Filename        : cpu.v
// Description     : CPU Stub
// Author          : Phil Tracton
// Created On      : Tue Apr 16 16:54:56 2019
// Last Modified By: Phil Tracton
// Last Modified On: Tue Apr 16 16:54:56 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!
//`include "timescale.v"
`timescale 1ns/1ns 
module cpu_top (/*AUTOARG*/
   // Outputs
   wb_m_adr_o, wb_m_dat_o, wb_m_sel_o, wb_m_we_o, wb_m_cyc_o,
   wb_m_stb_o, wb_m_cti_o, wb_m_bte_o, data_rd, active,
   // Inputs
   wb_clk, wb_rst, wb_m_dat_i, wb_m_ack_i, wb_m_err_i, wb_m_rty_i,
   start, address, selection, write, data_wr
   ) ;
   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;

   input 		wb_clk;
   input 		wb_rst;
   output wire [aw-1:0] wb_m_adr_o;
   output wire [dw-1:0] wb_m_dat_o;
   output wire [3:0]    wb_m_sel_o;
   output wire          wb_m_we_o ;
   output wire          wb_m_cyc_o;
   output wire          wb_m_stb_o;
   output wire [2:0]    wb_m_cti_o;
   output wire [1:0]    wb_m_bte_o;
   input [dw-1:0]       wb_m_dat_i;
   input                wb_m_ack_i;
   input                wb_m_err_i;
   input                wb_m_rty_i;

   input                start;
   input [aw-1:0]       address;
   input [3:0]          selection;
   input                write;
   input [dw-1:0]       data_wr;
   output wire [dw-1:0] data_rd;
   output wire          active;


   wb_master_interface master(
                              // Outputs
                              .wb_adr_o(wb_m_adr_o),
                              .wb_dat_o(wb_m_dat_o),
                              .wb_sel_o(wb_m_sel_o),
                              .wb_we_o(wb_m_we_o),
                              .wb_cyc_o(wb_m_cyc_o),
                              .wb_stb_o(wb_m_stb_o),
                              .wb_cti_o(wb_m_cti_o),
                              .wb_bte_o(wb_m_bte_o),

                              .data_rd(data_rd),
                              .active(active),

                              // Inputs
                              .wb_clk(wb_clk),
                              .wb_rst(wb_rst),
                              .wb_dat_i(wb_m_dat_i),
                              .wb_ack_i(wb_m_ack_i),
`ifdef ICARUS
                              .wb_err_i(1'b0),
`else
                              .wb_err_i(wb_m_err_i),
`endif
                              .wb_rty_i(wb_m_rty_i),

                              .start(start),
                              .address(address),
                              .selection(selection),
                              .write(write),
                              .data_wr(data_wr)
                              ) ;

endmodule // cpu
