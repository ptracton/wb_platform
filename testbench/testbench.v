//                              -*- Mode: Verilog -*-
// Filename        : testbench.v
// Description     : Wishbone DSP Testbench
// Author          : Philip Tracton
// Created On      : Wed Dec  2 13:12:45 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec  2 13:12:45 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "timescale.v"
`include "platform_includes.vh"

module testbench (/*AUTOARG*/ ) ;

   //
   // Creates a clock, reset, a timeout in case the sim never stops,
   // and pass/fail managers
   //
`include "test_management.v"

   //
   // Free running system clock originally 2.8MHz but FPGA requires at least 4.67 MHZ, so
   // this was doubled to 5.6MHz
   //
   reg wb_clk;
   initial begin
      wb_clk <= 0;
      forever begin
         #(5) wb_clk <= ~wb_clk;
      end
   end

   //
   // System reset
   //
   reg wb_rst;
   initial begin
      wb_rst <= 0;
      #200 wb_rst <= 1;
      #600 wb_rst <= 0;
   end

   wire [15:0] leds;
   reg [15:0]  switches;

   wire        tx;
   wire        rx;

   top dut(
           // Outputs
           .leds(leds),
           .tx(tx),

           // Inputs
           .clk_pad_i(wb_clk),
           .rst_pad_i(wb_rst),
           .switches(switches),
           .rx(rx)


           ) ;


   /****************************************************************************
    UART 0 -- This is used for CLI Interfacing

    The WB UART16550 from opencores is used here to simulate a UART on the other end
    of the cable.  It will allow us to send/receive characters to the NGMCU firmware
    ***************************************************************************/

   //
   // Free Running 50 MHz Clock
   //
   reg clk_tb;

   parameter   _clk_50mhz_high = 10,
     _clk_50mhz_low  = 10,
     _clk_50mhz_period = _clk_50mhz_high + _clk_50mhz_low;

   initial
     begin
        clk_tb <= 'b0;
        forever
          begin
             #(_clk_50mhz_low)  clk_tb = 1;
             #(_clk_50mhz_high) clk_tb = 0;
          end
     end

   //
   // Asynch. Reset to device
   //
   reg reset_tb;
   initial
     begin
        reset_tb = 0;
        #1    reset_tb = 1;
        #200  reset_tb = 0;
     end


   wire [31:0] uart0_adr;
   wire [31:0] uart0_dat_o;
   wire [31:0] uart0_dat_i;
   wire [3:0]  uart0_sel;
   wire        uart0_cyc;
   wire        uart0_stb;
   wire        uart0_we;
   wire        uart0_ack;
   wire        uart0_int;
   reg [31:0]  read_word;
   reg         test_failed;


   initial begin
      read_word <= 0;
      test_failed <= 0;
      switches <= 0;
   end


   assign      uart0_dat_o[31:8] = 'b0;



   uart_top uart0(
                  .wb_clk_i(clk_tb),
                  .wb_rst_i(reset_tb),

                  .wb_adr_i(uart0_adr[4:0]),
                  .wb_dat_o(uart0_dat_o),
                  .wb_dat_i(uart0_dat_i),
                  .wb_sel_i(uart0_sel),
                  .wb_cyc_i(uart0_cyc),
                  .wb_stb_i(uart0_stb),
                  .wb_we_i(uart0_we),
                  .wb_ack_o(uart0_ack),
                  .int_o(uart0_int),
                  .stx_pad_o(rx),
                  .srx_pad_i(tx),

                  .rts_pad_o(),
                  .cts_pad_i(1'b0),
                  .dtr_pad_o(),
                  .dsr_pad_i(1'b0),
                  .ri_pad_i(1'b0),
                  .dcd_pad_i(1'b0),

                  .baud_o()
                  );


   wb_mast uart_master0(
                        .clk (clk_tb),
                        .rst (reset_tb),
                        .adr (uart0_adr),
                        .din (uart0_dat_o),
                        .dout(uart0_dat_i),
                        .cyc (uart0_cyc),
                        .stb (uart0_stb),
                        .sel (uart0_sel),
                        .we  (uart0_we ),
                        .ack (uart0_ack),
                        .err (1'b0),
                        .rty (1'b0)
                        );


   //
   // UART Support Tasks
   //
   reg UART_VALID;
   uart_tasks uart_tasks();
   initial begin
      UART_VALID = 0;
      @(negedge reset_tb);
      repeat(100) @(posedge clk_tb);
      `UART_CONFIG;
      repeat(10) @(posedge clk_tb);
      UART_VALID = 1;
      $display("UART VALID @ %d", $time);

   end

   //
   // Platform Support Tasks
   //
   platform_tasks platform_tasks();


   //
   // Tasks used to help test cases
   //
   test_tasks test_tasks();

   //
   // The actual test cases that are being tested
   //
   test_case test_case();

endmodule // testbench
