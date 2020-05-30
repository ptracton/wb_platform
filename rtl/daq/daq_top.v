//                              -*- Mode: Verilog -*-
// Filename        : daq_top.v
// Description     : Data Acquisition
// Author          : Phil Tracton
// Created On      : Mon Apr 15 16:01:33 2019
// Last Modified By: Phil Tracton
// Last Modified On: Mon Apr 15 16:01:33 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

module daq_top (/*AUTOARG*/
   // Outputs
   wb_m_adr_o, wb_m_dat_o, wb_m_sel_o, wb_m_we_o, wb_m_cyc_o,
   wb_m_stb_o, wb_m_cti_o, wb_m_bte_o, data_rd, active, wb_s_dat_o,
   wb_s_ack_o, wb_s_err_o, wb_s_rty_o, file_read_data, file_active,
   // Inputs
   wb_clk, wb_rst, wb_m_dat_i, wb_m_ack_i, wb_m_err_i, wb_m_rty_i,
   start, address, selection, write, data_wr, wb_s_adr_i, wb_s_dat_i,
   wb_s_sel_i, wb_s_we_i, wb_s_cyc_i, wb_s_stb_i, wb_s_cti_i,
   wb_s_bte_i, file_num, file_write, file_read, file_write_data
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

   input wire [aw-1:0]  wb_s_adr_i;
   input wire [dw-1:0]  wb_s_dat_i;
   input wire [3:0]     wb_s_sel_i;
   input wire           wb_s_we_i ;
   input wire           wb_s_cyc_i;
   input wire           wb_s_stb_i;
   input wire [2:0]     wb_s_cti_i;
   input wire [1:0]     wb_s_bte_i;

   output wire [dw-1:0] wb_s_dat_o;
   output wire          wb_s_ack_o;
   output wire          wb_s_err_o;
   output wire          wb_s_rty_o;

   input [7:0]          file_num;
   input                file_write;
   input                file_read;
   input [31:0]         file_write_data;
   output [31:0]        file_read_data;
   output               file_active;

   wire                sm_start;
   wire [aw-1:0]       sm_address;
   wire [3:0]          sm_selection;
   wire                sm_write;
   wire [dw-1:0]       sm_data_wr;

   wire                master_start;
   wire [aw-1:0]       master_address;
   wire [3:0]          master_selection;
   wire                master_write;
   wire [dw-1:0]       master_data_wr;

   assign master_start = start | sm_start;
   assign master_address = address | sm_address;
   assign master_selection = selection | sm_selection;
   assign master_write = write | sm_write;
   assign master_data_wr = data_wr | sm_data_wr;


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

                              // .start(start),
                              // .address(address),
                              // .selection(selection),
                              // .write(write),
                              // .data_wr(data_wr)

                              .start(sm_start),
                              .address(sm_address),
                              .selection(sm_selection),
                              .write(sm_write),
                              .data_wr(sm_data_wr)

                              // .start(master_start),
                              // .address(master_address),
                              // .selection(master_selection),
                              // .write(master_write),
                              // .data_wr(master_data_wr)


                              ) ;

   daq_slave slave(
                   // Outputs
                   .wb_dat_o(wb_s_dat_o),
                   .wb_ack_o(wb_s_ack_o),
                   .wb_err_o(wb_s_err_o),
                   .wb_rty_o(wb_s_rty_o),
                   // Inputs
                   .wb_clk(wb_clk),
                   .wb_rst(wb_rst),
                   .wb_adr_i(wb_s_adr_i),
                   .wb_dat_i(wb_s_dat_i),
                   .wb_sel_i(wb_s_sel_i),
                   .wb_we_i(wb_s_we_i),
                   .wb_cyc_i(wb_s_cyc_i),
                   .wb_stb_i(wb_s_stb_i),
                   .wb_cti_i(wb_s_cti_i),
                   .wb_bte_i(wb_s_bte_i)
                   ) ;


   daq_sm state_machine(
                        // Outputs
                        .file_read_data(file_read_data),
                        .address(sm_address),
                        .start(sm_start),
                        .selection(sm_selection),
                        .write(sm_write),
                        .data_wr(sm_data_wr),
                        .file_active(file_active),

                        // Inputs
                        .wb_clk(wb_clk),
                        .wb_rst(wb_rst),
                        .file_num(file_num),
                        .file_write(file_write),
                        .file_read(file_read),
                        .file_write_data(file_write_data),
                        .data_rd(data_rd),
                        .active(active)
                        ) ;

endmodule // daq_top
