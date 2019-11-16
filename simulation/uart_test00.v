//                              -*- Mode: Verilog -*-
// Filename        : uart_test00.v
// Description     : Basic Interface Testing
// Author          : Philip Tracton
// Created On      : Thu May 16 17:30:39 2019
// Last Modified By: Philip Tracton
// Last Modified On: Thu May 16 17:30:39 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "platform_includes.vh"

module test_case (/*AUTOARG*/ ) ;
   //
   // Test Configuration
   // These parameters need to be set for each test case
   //
   parameter simulation_name = "uart_test00";
   parameter number_of_tests = 5;
   reg [31:0] uart_read;

   initial begin
      $display("UART 00 TEST CASE");
      @(negedge `WB_RST);
      uart_read = 0;
      `TEST_COMPARE("UART TEST 00 BEGIN", 0,0);
      repeat (100) @(posedge `WB_CLK);

      `UART_WRITE_BYTE(`PKT_PREAMBLE);                     // Preamble
      `UART_WRITE_BYTE(8'hF0 | `PKT_COMMAND_CPU_WRITE);    // Size and Command
      `UART_WRITE_BYTE(8'h6);                              // Length
      `UART_WRITE_WORD(32'h9000_6000);                     // Start Address
      `UART_WRITE_WORD(32'h1234_5678);                     // Data[0]
      `UART_WRITE_WORD(32'h9ABC_DEF0);                     // Data[1]
      `UART_WRITE_WORD(32'hDEAD_BEEF);                     // Data[2]
      `UART_WRITE_WORD(32'h5A5A_A5A5);                     // Data[3]
      `UART_WRITE_WORD(32'hB6C7_D8E9);                     // Data[4]
      `UART_WRITE_WORD(32'hFEED_C77C);                     // Data[5]

      `TEST_COMPARE("Wait to Complete", 0,0);

      repeat (6000) @(posedge `WB_CLK);


      `CPU_WRITES(`WB_RAM2,   4'hF, 32'h1234_5678);
      `CPU_WRITES(`WB_RAM2+4, 4'hF, 32'h3333_4444);
      `CPU_WRITES(`WB_RAM2+8, 4'hF, 32'h5555_6666);



      `CPU_READS(`WB_RAM2,   4'hF, 32'h1234_5678, uart_read);
      `CPU_READS(`WB_RAM2+4, 4'hF, 32'h3333_4444, uart_read);
      `CPU_READS(`WB_RAM2+8, 4'hF, 32'h5555_6666, uart_read);

      repeat (6000) @(posedge `WB_CLK);


      `TEST_COMPARE("TEST COMPLETE", 0,0);
      `TEST_COMPLETE;
   end

endmodule // test_case
