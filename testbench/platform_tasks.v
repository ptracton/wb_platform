//                              -*- Mode: Verilog -*-
// Filename        : dsp_tasks.v
// Description     : DSP Support Tasks
// Author          : Phil Tracton
// Created On      : Tue Apr 16 17:11:17 2019
// Last Modified By: Phil Tracton
// Last Modified On: Tue Apr 16 17:11:17 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "timescale.v"
`include "platform_includes.vh"

module platform_tasks (/*AUTOARG*/ ) ;   
   
   task CPU_READ;
      input [31:0] address;
      input [3:0]  selection;
      input [31:0] expected;

      output [31:0] data;
      begin
         data = 32'hFFFFFFFF;

         `UART_WRITE_BYTE(`PKT_PREAMBLE);                     // Preamble
         `UART_WRITE_BYTE(8'hF0 | `PKT_COMMAND_CPU_READ);     // Size and Command
         `UART_WRITE_BYTE(8'h1);                              // Length
         `UART_WRITE_WORD(address);                           // Start Address
         `UART_READ_WORD(expected, data);                     // Data[0]

         //$display("CPU READ addr = 0x%x data = 0x%x sel = 0x%x @ %d", address, data, selection, $time);
         `TEST_COMPARE("CPU READ", expected, data);
         repeat (1) @(posedge `WB_CLK);

      end
   endtask // CPU_READ

   task CPU_WRITE;
      input [31:0] address;
      input [3:0]  selection;
      input [31:0] data;
      begin
         @(posedge `WB_CLK);
         $display("CPU WRITE addr = 0x%x data = 0x%x sel = 0x%x @ %d", address, data, selection, $time);

         `UART_WRITE_BYTE(`PKT_PREAMBLE);                     // Preamble
         `UART_WRITE_BYTE(8'hF0 | `PKT_COMMAND_CPU_WRITE);    // Size and Command
         `UART_WRITE_BYTE(8'h1);                              // Length
         `UART_WRITE_WORD(address);                           // Start Address
         `UART_WRITE_WORD(data);                              // Data[0]
         repeat (1) @(posedge `WB_CLK);

      end
   endtask // CPU_WRITE


endmodule // dsp_tasks
