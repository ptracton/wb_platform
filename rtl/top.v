//                              -*- Mode: Verilog -*-
// Filename        : top.v
// Description     : Simpler DSP/ML Testing Modules
// Author          : Phil Tracton
// Created On      : Mon Apr 15 15:39:03 2019
// Last Modified By: Phil Tracton
// Last Modified On: Mon Apr 15 15:39:03 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

//`include "timescale.v"
`timescale 1ns/1ns 
`include "platform_includes.vh"
module top (/*AUTOARG*/
   // Outputs
   leds, test_bus, tx,
   // Inputs
   clk_pad_i, rst_pad_i, switches, rx
   ) ;

   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;

   input clk_pad_i;
   input rst_pad_i;
   input [15:0] switches;
   output [15:0] leds;
   output [7:0] test_bus;

   input         rx;
   output        tx;

   wire [aw-1:0]   cpu_address;
   wire            cpu_start;
   wire [3:0]      cpu_selection;
   wire            cpu_write;
   wire [dw-1:0]   cpu_data_wr;
   wire [dw-1:0]   cpu_data_rd;
   wire            cpu_active;

   wire [15:0]     leds_gpio;
   wire [15:0]     leds_pc;
   wire [1:0]      control_leds;


   assign leds = (control_leds == `B_CONTROL_LEDS_GPIO) ? leds_gpio :
                 (control_leds == `B_CONTROL_LEDS_PC)   ? leds_pc   : leds_gpio;


   /*AUTOWIRE*/
`include "bus_matrix.vh"


   // Beginning of automatic regs (for this module's undeclared outputs)
   wire            active;
   wire [dw-1:0]   data_rd;
   wire [31:0]     dtb_pad;
   // End of automatics
   wire            locked;
   wire            clk_10MHZ;

   syscon_top #(.SLAVE_ADDRESS(`WB_SYSCON_BASE_ADDRESS))
   syscon(
          // Outputs
          .wb_dat_o(wb_s2m_syscon_dat),
          .wb_ack_o(wb_s2m_syscon_ack),
          .wb_err_o(wb_s2m_syscon_err),
          .wb_clk_o(wb_clk),
          .wb_rst_o(wb_rst),
          .clk_10MHZ(clk_10MHZ),
          .locked(locked),
          .control_leds(control_leds),
          // Inputs
          .wb_cyc_i(wb_m2s_syscon_cyc),
          .wb_adr_i(wb_m2s_syscon_adr),
          .wb_dat_i(wb_m2s_syscon_dat),
          .wb_sel_i(wb_m2s_syscon_sel),
          .wb_we_i(wb_m2s_syscon_we),
          .wb_stb_i(wb_m2s_syscon_stb),
          .clk_pad_i(clk_pad_i),
          .rst_pad_i(rst_pad_i)
          ) ;
   assign wb_s2m_syscon_rty = 1'b0;

   pc_interface interface(
                          .tx(tx),
                          .rx(rx),
                          .wb_clk(wb_clk),
                          .wb_rst(wb_rst),
                          .leds(leds_pc),

                          // CPU Bus Interface
                          .cpu_data_rd(cpu_data_rd),
                          .cpu_active(cpu_active),
                          .cpu_start(cpu_start),
                          .cpu_address(cpu_address),
                          .cpu_selection(cpu_selection),
                          .cpu_write(cpu_write),
                          .cpu_data_wr(cpu_data_wr)
                          ) ;

   assign wb_s2m_gpio_rty = 0;
   gpio_top gpio(
	             // WISHBONE Interface
	             .wb_clk_i(wb_clk),
                 .wb_rst_i(wb_rst),
                 .wb_cyc_i(wb_m2s_gpio_cyc),
                 .wb_adr_i(wb_m2s_gpio_adr[7:0]),
                 .wb_dat_i(wb_m2s_gpio_dat),
                 .wb_sel_i(wb_m2s_gpio_sel),
                 .wb_we_i(wb_m2s_gpio_we),
                 .wb_stb_i(wb_m2s_gpio_stb),

	             .wb_dat_o(wb_s2m_gpio_dat),
                 .wb_ack_o(wb_s2m_gpio_ack),
                 .wb_err_o(wb_s2m_gpio_err),
                 .wb_inta_o(),

	             // External GPIO Interface
	             .ext_pad_i({15'b0, switches}),
                 .ext_pad_o(leds_gpio),
                 .ext_padoe_o()

                 );

   cpu_top cpu (
                // Outputs
                .wb_m_adr_o(wb_m2s_cpu_master_adr),
                .wb_m_dat_o(wb_m2s_cpu_master_dat),
                .wb_m_sel_o(wb_m2s_cpu_master_sel),
                .wb_m_we_o(wb_m2s_cpu_master_we),
                .wb_m_cyc_o(wb_m2s_cpu_master_cyc),
                .wb_m_stb_o(wb_m2s_cpu_master_stb),
                .wb_m_cti_o(wb_m2s_cpu_master_cti),
                .wb_m_bte_o(wb_m2s_cpu_master_bte),
                .data_rd(cpu_data_rd),
                .active(cpu_active),

                // Inputs
                .wb_clk(wb_clk),
                .wb_rst(wb_rst),
                .wb_m_dat_i(wb_s2m_cpu_master_dat),
                .wb_m_ack_i(wb_s2m_cpu_master_ack),
                .wb_m_err_i(wb_s2m_cpu_master_err),
                .wb_m_rty_i(wb_s2m_cpu_master_rty),
                .start(cpu_start),
                .address(cpu_address),
                .selection(cpu_selection),
                .write(cpu_write),
                .data_wr(cpu_data_wr)
                ) ;

   //
   // Undriven by SRAMs, ground them so they don't float and inject X's into simulation
   //
   assign wb_s2m_ram0_rty = 0;
   assign wb_s2m_ram1_rty = 0;
   assign wb_s2m_ram2_rty = 0;
   assign wb_s2m_ram3_rty = 0;

   wb_ram
     #(.depth(8192))
   ram0
     (	   .wb_clk_i(wb_clk),
           .wb_rst_i(wb_rst),

           .wb_adr_i(wb_m2s_ram0_adr[12:0]),
           .wb_dat_i(wb_m2s_ram0_dat),
           .wb_sel_i(wb_m2s_ram0_sel),
           .wb_we_i(wb_m2s_ram0_we),
           .wb_bte_i(wb_m2s_ram0_bte),
           .wb_cti_i(wb_m2s_ram0_cti),
           .wb_cyc_i(wb_m2s_ram0_cyc),
           .wb_stb_i(wb_m2s_ram0_stb),

           .wb_ack_o(wb_s2m_ram0_ack),
           .wb_err_o(wb_s2m_ram0_err),
           .wb_dat_o(wb_s2m_ram0_dat)
           );

   wb_ram
     #(.depth(8192))
   ram1
     (	   .wb_clk_i(wb_clk),
           .wb_rst_i(wb_rst),

           .wb_adr_i(wb_m2s_ram1_adr[12:0]),
           .wb_dat_i(wb_m2s_ram1_dat),
           .wb_sel_i(wb_m2s_ram1_sel),
           .wb_we_i(wb_m2s_ram1_we),
           .wb_bte_i(wb_m2s_ram1_bte),
           .wb_cti_i(wb_m2s_ram1_cti),
           .wb_cyc_i(wb_m2s_ram1_cyc),
           .wb_stb_i(wb_m2s_ram1_stb),

           .wb_ack_o(wb_s2m_ram1_ack),
           .wb_err_o(wb_s2m_ram1_err),
           .wb_dat_o(wb_s2m_ram1_dat)
           );

   wb_ram
     #(.depth(8192))
   ram2
     (	   .wb_clk_i(wb_clk),
           .wb_rst_i(wb_rst),

           .wb_adr_i(wb_m2s_ram2_adr[12:0]),
           .wb_dat_i(wb_m2s_ram2_dat),
           .wb_sel_i(wb_m2s_ram2_sel),
           .wb_we_i(wb_m2s_ram2_we),
           .wb_bte_i(wb_m2s_ram2_bte),
           .wb_cti_i(wb_m2s_ram2_cti),
           .wb_cyc_i(wb_m2s_ram2_cyc),
           .wb_stb_i(wb_m2s_ram2_stb),

           .wb_ack_o(wb_s2m_ram2_ack),
           .wb_err_o(wb_s2m_ram2_err),
           .wb_dat_o(wb_s2m_ram2_dat)
           );

   wb_ram
     #(.depth(8192))
   ram3
     (	   .wb_clk_i(wb_clk),
           .wb_rst_i(wb_rst),

           .wb_adr_i(wb_m2s_ram3_adr[12:0]),
           .wb_dat_i(wb_m2s_ram3_dat),
           .wb_sel_i(wb_m2s_ram3_sel),
           .wb_we_i(wb_m2s_ram3_we),
           .wb_bte_i(wb_m2s_ram3_bte),
           .wb_cti_i(wb_m2s_ram3_cti),
           .wb_cyc_i(wb_m2s_ram3_cyc),
           .wb_stb_i(wb_m2s_ram3_stb),

           .wb_ack_o(wb_s2m_ram3_ack),
           .wb_err_o(wb_s2m_ram3_err),
           .wb_dat_o(wb_s2m_ram3_dat)
           );


   //
   // TEST BUS to PMOD
   //
   assign test_bus[00] = wb_clk;
   assign test_bus[01] = locked;
   assign test_bus[02] = wb_rst;
   assign test_bus[03] = tx;
   assign test_bus[04] = rx;
   assign test_bus[05] = clk_pad_i;
   assign test_bus[06] = clk_10MHZ;
   assign test_bus[07] = cpu_write;




endmodule // top
