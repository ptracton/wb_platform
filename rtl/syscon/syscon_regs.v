//                              -*- Mode: Verilog -*-
// Filename        : syscon_regs.v
// Description     : Syscon Registers
// Author          : Phil Tracton
// Created On      : Wed Jul 10 14:17:45 2019
// Last Modified By: Phil Tracton
// Last Modified On: Wed Jul 10 14:17:45 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "platform_includes.vh"

module syscon_regs (/*AUTOARG*/
   // Outputs
   wb_dat_o, wb_ack_o, wb_err_o, wb_rty_o, control_leds,
   // Inputs
   wb_clk, wb_rst, wb_cyc_i, wb_adr_i, wb_dat_i, wb_sel_i, wb_we_i,
   wb_stb_i, locked
   ) ;

   parameter SLAVE_ADDRESS = 32'h0000_0000;
   parameter dw = 32;
   parameter aw = 32;

   //
   // WISHBONE Interface
   //
   input             wb_clk;	// Clock
   input             wb_rst;	// Reset
   input             wb_cyc_i;	// cycle valid input
   input [aw-1:0]    wb_adr_i;	// address bus inputs
   input [dw-1:0]    wb_dat_i;	// input data bus
   input [3:0]       wb_sel_i;	// byte select inputs
   input             wb_we_i;	// indicates write transfer
   input             wb_stb_i;	// strobe input
   output reg [dw-1:0] wb_dat_o;	// output data bus
   output reg        wb_ack_o;	// normal termination
   output reg        wb_err_o;	// termination w/ error
   output reg        wb_rty_o;  // re-try
   output [1:0]      control_leds;

   input             locked;

   wire [31:0]       identification;
   assign identification[`F_IDENTIFICATION_PLATFORM]  = 8'hA; //`B_IDENTIFICATION_FPGA;
   assign identification[`F_IDENTIFICATION_RESERVED]  = 0;
   assign identification[`F_IDENTIFICATION_MINOR_REV] = 8'hB; //`B_IDENTIFICATION_MINOR_REV;
   assign identification[`F_IDENTIFICATION_MAJOR_REV] = 8'hC; //`B_IDENTIFICATION_MAJOR_REV;


   wire [31:0]       status;
   assign status[`F_STATUS_LOCKED] = locked;
   assign status[`F_STATUS_UNUSED] = 0;

   reg [31:0]        control;

   assign control_leds = control[`F_CONTROL_LEDS];


   wire              write_registers = wb_cyc_i & wb_stb_i & wb_we_i;
   wire              read_registers = wb_cyc_i & wb_stb_i;

   //
   // Bus Cycle Logic
   //
   always @(posedge wb_clk)
     if (wb_rst) begin
        wb_ack_o <= 1'b0;
        wb_err_o <= 1'b0;
        wb_rty_o <= 1'b0;
     end else begin
        if (wb_cyc_i & wb_stb_i) begin
           wb_ack_o <= 1;
        end else begin
           wb_ack_o <= 0;
        end
     end // else: !if(wb_rst)

   //
   // Register Write Logic
   //
   always @(posedge wb_clk)
     if (wb_rst) begin
        control <= 32'h0;
     end else begin // if (wb_rst)
        if (write_registers) begin
           /* verilator lint_off CASEINCOMPLETE */
           case (wb_adr_i[7:0])
             `WB_SYSCON_R_CONTROL_OFFSET: begin
                control[07:00] <= wb_sel_i[0] ? wb_dat_i[07:00] : control[07:00];
                control[15:08] <= wb_sel_i[1] ? wb_dat_i[15:08] : control[15:08];
                control[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : control[23:16];
                control[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : control[31:24];
             end
             default: begin
             end
           endcase // case (wb_adr_i[7:0])
           /* verilator lint_on CASEINCOMPLETE */

        end // else: !if(write_registers)
     end // else: !if(wb_rst)


   //
   // Register Read Logic
   //
   always @(posedge wb_clk)
     if (wb_rst) begin
        wb_dat_o <= 32'b0;
     end else begin
        if (read_registers) begin
           /* verilator lint_off CASEINCOMPLETE */
           case (wb_adr_i[7:0])
             `WB_SYSCON_R_IDENTIFICATION_OFFSET : wb_dat_o <= identification;
             `WB_SYSCON_R_STATUS_OFFSET : wb_dat_o <= status;
             `WB_SYSCON_R_CONTROL_OFFSET:  wb_dat_o <= control;
           endcase // case (wb_adr_i[7:0])
           /* verilator lint_on CASEINCOMPLETE */
        end
     end // else: !if(wb_rst)


endmodule // syscon_regs
