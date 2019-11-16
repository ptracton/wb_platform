//                              -*- Mode: Verilog -*-
// Filename        : basic_00.v
// Description     : Basic Function Test Case
// Author          : Phil Tracton
// Created On      : Mon Apr 15 17:10:49 2019
// Last Modified By: Phil Tracton
// Last Modified On: Mon Apr 15 17:10:49 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!
module test_case (/*AUTOARG*/ ) ;
`include "platform_includes.vh"

   //
   // Test Configuration
   // These parameters need to be set for each test case
   //
   parameter simulation_name = "basic_00";
   parameter number_of_tests = 4;

   reg  err;
   reg [31:0] data_out;
   integer    i;
   reg [31:0] daq_read;
   reg [31:0] cpu_read;
   reg [31:0] debug_reg;

   initial begin
      daq_read = 0;

      $display("Basic Test Case");
      @(negedge `WB_RST);
      @(posedge `TB.UART_VALID);
      repeat (100) @(posedge `WB_CLK);


      `CPU_WRITES(`WB_RAM3,    4'hF, 32'h0123_4567);
      `CPU_WRITES(`WB_RAM3+4,  4'hF, 32'h89AB_CDEF);
      `CPU_WRITES(`WB_RAM3+8,  4'hF, 32'hAA55_CC77);
      `CPU_WRITES(`WB_RAM3+12, 4'hF, 32'hBB66_DD99);



      repeat (500) @(posedge `WB_CLK);

      `CPU_READS(`WB_RAM3,    4'hF, 32'h0123_4567, cpu_read);
      `CPU_READS(`WB_RAM3+8,  4'hF, 32'hAA55_CC77, cpu_read);
      `CPU_READS(`WB_RAM3+12, 4'hF, 32'hBB66_DD99, cpu_read);
      `CPU_READS(`WB_RAM3+4,  4'hF, 32'h89AB_CDEF, cpu_read);

      repeat (50) @(posedge `WB_CLK);
      `TEST_COMPLETE;
   end

endmodule // test_case
