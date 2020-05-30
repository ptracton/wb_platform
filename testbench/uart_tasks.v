//                              -*- Mode: Verilog -*-
// Filename        : uart_tasks.v
// Description     : UART Tasks
// Author          : Philip Tracton
// Created On      : Mon Apr 20 16:12:43 2015
// Last Modified By: Philip Tracton
// Last Modified On: Mon Apr 20 16:12:43 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!


`timescale 1ns/1ns
`include "platform_includes.vh"

module uart_tasks;

   reg uart_busy;
   initial uart_busy = 0;


   // Configure WB UART in testbench
   // 115200, 8N1
   //
   task uart_config;
      begin
`ifdef MODELSIM
         $display("TASK: UART Configure");
`else
         $display("\033[93mTASK: UART Configure\033[0m");
`endif

         @(posedge `UART_CLK);
         //Turn on receive data interrupt
         `UART_MASTER0.wb_wr1(32'hFFFF0001,    4'h4, 32'h00010000);

         @(posedge `UART_CLK);
         //FIFO Control, interrupt for each byte, clear fifos and enable
         `UART_MASTER0.wb_wr1(32'hFFFF0002,    4'h2, 32'h00000700);

         @(posedge `UART_CLK);
         //Line Control, enable writting to the baud rate registers
         `UART_MASTER0.wb_wr1(32'hFFFF0003,    4'h1, 32'h00000080);

         @(posedge `UART_CLK);
         //Baud Rate LSB
         `UART_MASTER0.wb_wr1(32'hFFFF0000,    4'h0, 32'h0000001A); //115200bps from 50 MHz

         @(posedge `UART_CLK);
         //Baud Rate MSB
         `UART_MASTER0.wb_wr1(32'hFFFF0001,    4'h4, 32'h00000000);

         @(posedge `UART_CLK);
         //Line Control, 8 bits data, 1 stop bit, no parity
         `UART_MASTER0.wb_wr1(32'hFFFF0003,    4'h1, 32'h00000003);
      end
   endtask // uart_config


   //
   // Write a character to WB UART and catch with FPGA UART
   //
   task uart_write_byte;
      input [7:0] char;
      begin

         //
         // Write the character to the WB UART to send to FPGA UART
         //

         @(posedge `UART_CLK);
//         $display("TASK: UART Write = 0x%h @ %d", char, $time);
         `UART_MASTER0.wb_wr1(32'hFFFF0000,    4'h0, {24'h000000, char});
      end
   endtask // uart_write_char

   task uart_write_word;
      input [31:0] word;
      begin
         uart_busy = 1;

//         $display("UART WRITE WORD 0x%x @ %d", word, $time);
         uart_write_byte(word [07:00]);
         uart_write_byte(word [15:08]);
         uart_write_byte(word [23:16]);
         uart_write_byte(word [31:24]);

         while (testbench.uart0.regs.lsr[6] == 1'b0) begin
            #100;
         end
         uart_busy = 0;
      end
   endtask // uart_write_word



   //
   // Read a character with WB UART that was sent from FPGA UART
   //
   task uart_read_byte;
      input [7:0] expected;
      begin
         //$display("Reading 0x%x @ %d", expected, $time);

      if (!testbench.uart0_int)
        @(posedge testbench.uart0_int);

      `UART_MASTER0.wb_rd1(32'hFFFF0000,    4'h0, testbench.read_word);
      //$display("TASK: UART Read = 0x%x @ %d", testbench.read_word, $time);
      if (testbench.read_word !== expected)
        begin
`ifdef MODELSIM
           $display("FAIL: UART Read = 0x%h NOT 0x%h @ %d", testbench.read_word[7:0], expected, $time);
`else
           $display("\033[1;31mFAIL: UART Read = 0x%h NOT 0x%h @ %d\033[0m", testbench.read_word[7:0], expected, $time);
`endif
           `test_failed <= 1;
        end
         @(posedge testbench.clk_tb);
      end
   endtask // uart_read_char


   task uart_read_word;
      input [31:0] expected;
      output [31:0] value;

      begin
         //$display("UART Read Word 0x%x @ %d", expected, $time);
         uart_read_byte(expected[07:00]);
         value[07:00] = `TB.read_word[07:00];

         uart_read_byte(expected[15:08]);
         value[15:08] = `TB.read_word[07:00];

         uart_read_byte(expected[23:16]);
         value[23:16] = `TB.read_word[07:00];

         uart_read_byte(expected[31:24]);
         value[31:24] = `TB.read_word[07:00];

      end
   endtask // uart_read_word



endmodule // uart_tasks
