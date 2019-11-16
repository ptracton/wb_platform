//                              -*- Mode: Verilog -*-
// Filename        : syscon_regs00.v
// Description     : Basic Interface Testing
// Author          : Philip Tracton
// Created On      : Thu May 16 17:30:39 2019
// Last Modified By: Philip Tracton
// Last Modified On: Thu May 16 17:30:39 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!


module test_case (/*AUTOARG*/ ) ;
`include "platform_includes.vh"
   
   //
   // Test Configuration
   // These parameters need to be set for each test case
   //
   parameter simulation_name = "syscon_regs00";
   parameter number_of_tests = 3;

   reg [31:0] cpu_read;
   reg [31:0] identification;
   reg [31:0] control;

   initial begin
      $display("UART 00 TEST CASE");
      @(negedge `WB_RST);
      cpu_read = 0;
      identification = 0;
      control = 0;

      @(posedge `TB.UART_VALID);

      `TEST_COMPARE("SYSCON REGS 00 BEGIN", 0,0);
      repeat (100) @(posedge `WB_CLK);

      identification[`F_IDENTIFICATION_PLATFORM]  = `B_IDENTIFICATION_FPGA;
      identification[`F_IDENTIFICATION_MINOR_REV] = `B_IDENTIFICATION_MINOR_REV;
      identification[`F_IDENTIFICATION_MAJOR_REV] = `B_IDENTIFICATION_MAJOR_REV;

      `CPU_READS(`WB_SYSCON_R_STATUS, 4'hF,  32'h0000_0001, cpu_read);

      control = 32'ha5a5_1234;
      `CPU_WRITES(`WB_SYSCON_R_CONTROL, 4'hF, control);
      `CPU_READS(`WB_SYSCON_R_CONTROL, 4'hF, control, cpu_read);

      repeat (600) @(posedge `WB_CLK);

      `TEST_COMPARE("TEST COMPLETE", 0,0);
      `TEST_COMPLETE;
   end

endmodule // test_case
