//                              -*- Mode: Verilog -*-
// Filename        : wb_master_interface.v
// Description     : Wishbone Bus Master
// Author          : Philip Tracton
// Created On      : Fri Nov 27 16:22:45 2015
// Last Modified By: Philip Tracton
// Last Modified On: Fri Nov 27 16:22:45 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "platform_includes.vh"

module wb_master_interface (/*AUTOARG*/
                            // Outputs
                            wb_adr_o, wb_dat_o, wb_sel_o, wb_we_o, wb_cyc_o, wb_stb_o,
                            wb_cti_o, wb_bte_o, data_rd, active,
                            // Inputs
                            wb_clk, wb_rst, wb_dat_i, wb_ack_i, wb_err_i, wb_rty_i, start,
                            address, selection, write, data_wr
                            ) ;

   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;

   input 		wb_clk;
   input 		wb_rst;
   output reg [aw-1:0] wb_adr_o;
   output reg [dw-1:0] wb_dat_o;
   output reg [3:0]    wb_sel_o;
   output reg          wb_we_o ;
   output reg          wb_cyc_o;
   output reg          wb_stb_o;
   output reg [2:0]    wb_cti_o;
   output reg [1:0]    wb_bte_o;
   input [dw-1:0]      wb_dat_i;
   input               wb_ack_i;
   input               wb_err_i;
   input               wb_rty_i;

   input               start;
   input [aw-1:0]      address;
   input [3:0]         selection;
   input               write;
   input [dw-1:0]      data_wr;
   output reg [dw-1:0] data_rd;
   output wire         active;

//   reg [dw-1:0]        data_reg;

   reg [1:0]           state;
   parameter STATE_IDLE         = 2'h0;
   parameter STATE_WAIT_ACK     = 2'h1;
   parameter STATE_ERROR        = 2'h3;

   assign active = state != STATE_IDLE;

/* -----\/----- EXCLUDED -----\/-----
   always @(posedge wb_clk)
     if (wb_rst) begin
        state <= STATE_IDLE;
     end else begin
        state <= next_state;
     end
 -----/\----- EXCLUDED -----/\----- */

   always @(posedge wb_clk)
     if (wb_rst) begin
        state = STATE_IDLE;
        wb_adr_o = `WB_RAM0;
        wb_dat_o = 0;
        wb_sel_o = 0;
        wb_we_o  = 0;
        wb_cyc_o = 0;
        wb_stb_o = 0;
        wb_cti_o = 1;
        wb_bte_o = 0;
        data_rd  = 0;

     end else begin // if (wb_rst)
        case (state)
          STATE_IDLE: begin
             wb_adr_o = `WB_RAM0;
             wb_dat_o = 0;
             wb_sel_o = 0;
             wb_we_o  = 0;
             wb_cyc_o = 0;
             wb_stb_o = 0;
             wb_cti_o = 1;
             wb_bte_o = 0;
             if (start) begin
                state = STATE_WAIT_ACK;
                wb_adr_o = address;
                wb_dat_o = data_wr;
                wb_sel_o = selection;
                wb_we_o  = write;
                wb_cyc_o = 1;
                wb_stb_o = 1;
                wb_cti_o = 1;
                wb_bte_o = 0;
                data_rd  =0;

             end else begin
                state = STATE_IDLE;
             end
          end // case: STATE_IDLE
          STATE_WAIT_ACK: begin
             wb_cyc_o = 1;
             wb_stb_o = 1;
             wb_cti_o = 1;
             wb_bte_o = 0;

             if (wb_err_i || wb_rty_i) begin
                state = STATE_ERROR;
             end else if (wb_ack_i) begin
		        if (!write) begin
		           data_rd = wb_dat_i;
		        end
                state = STATE_IDLE;
                wb_stb_o = 0;
                wb_cyc_o = 0;
             end else begin
                state = STATE_WAIT_ACK;
             end

          end // case: STATE_WAIT_ACK
          STATE_ERROR: begin
             state = STATE_IDLE;
          end
          default: begin
             state = STATE_IDLE;
          end

        endcase // case (state)

     end


`ifdef SIM
   reg [32*8-1:0] state_name;
   always @(*)
     case (state)
       STATE_IDLE: state_name         = "IDLE";
       STATE_WAIT_ACK: state_name     = "WAIT ACK";
       STATE_ERROR:state_name         = "ERROR";
       default: state_name            = "DEFAULT";
     endcase // case (state)

`endif

endmodule // testing_wb_master
