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

module dsp_tasks (/*AUTOARG*/ ) ;

   task DO_SUM;
      input [31:0] INPUT0;
      input [31:0] INPUT1;
      input [31:0] INPUT3;

      begin
         $display("DO_SUM input0=0x%h input1=0x%h input3=0x%h @%d", INPUT0, INPUT1, INPUT3, $time);
         
         `CPU_WRITES(`WB_DSP_SLAVE_BASE_ADDRESS+`WB_DSP_SLAVE_INPUT1_OFFSET,   4'hF, INPUT1);
         `CPU_WRITES(`WB_DSP_SLAVE_BASE_ADDRESS+`WB_DSP_SLAVE_INPUT3_OFFSET,   4'hF, INPUT3);
         `CPU_WRITES(`WB_DSP_SLAVE_BASE_ADDRESS+`WB_DSP_SLAVE_INPUT0_OFFSET,   4'hF, INPUT0);
         
//         @(posedge `DUT.interrupt);
      end
      
   endtask // DO_SUM
   
   
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
         //$display("CPU WRITE addr = 0x%x data = 0x%x sel = 0x%x @ %d", address, data, selection, $time);

         `UART_WRITE_BYTE(`PKT_PREAMBLE);                     // Preamble
         `UART_WRITE_BYTE(8'hF0 | `PKT_COMMAND_CPU_WRITE);    // Size and Command
         `UART_WRITE_BYTE(8'h1);                              // Length
         `UART_WRITE_WORD(address);                           // Start Address
         `UART_WRITE_WORD(data);                              // Data[0]
         repeat (1) @(posedge `WB_CLK);

      end
   endtask // CPU_WRITE

   task CPU_WRITE_FILE_CONFIG;
      input [7:0] file_number;
      input [31:0] start_address;
      input [31:0] end_address;
      input [31:0] rd_ptr;
      input [31:0] wr_ptr;
      input [31:0] control;
      reg [31:0]   address;

      begin
         address = `WB_RAM0 + ('h20*file_number);
         $display("CPU WRITE CONFIG File=%d Table Address =0x%x@ %d", file_number, address, $time);
         $display("CPU WRITE CONFIG Start Address = 0x%x End Address = 0x%x", start_address, end_address);
         

         `UART_WRITE_BYTE(`PKT_PREAMBLE);                     // Preamble
         `UART_WRITE_BYTE(8'hF0 | `PKT_COMMAND_CPU_WRITE);    // Size and Command
         `UART_WRITE_BYTE(8'h6);                              // Length
         `UART_WRITE_WORD(address);                           // RAM Address of table
         `UART_WRITE_WORD(start_address);                     // Start Adress of file
         `UART_WRITE_WORD(end_address);                       // End Adress of file
         `UART_WRITE_WORD(rd_ptr);                            // Read Pointer
         `UART_WRITE_WORD(wr_ptr);                            // Write Pointer
         `UART_WRITE_WORD(1 << `F_STATUS_EMPTY);              // Status
         `UART_WRITE_WORD(control);                           // Control
         `UART_WRITE_WORD(32'h0);                             // Reserved 0
         `UART_WRITE_WORD(32'h0);                             // Reserved 1
      end
   endtask // CPU_WRITE_FILE_CONFIG




   task DAQ_READ;
      input [31:0] address;
      input [3:0]  selection;
      input [31:0] expected;

      output [31:0] data;
      begin
         data = 32'hFFFFFFFF;
         // @(posedge `WB_CLK);
         // `DAQ_ADDR = address;
         // `DAQ_SEL = selection;
         // `DAQ_WRITE = 0;
         // `DAQ_START = 1;

         // if (`DAQ_ACTIVE === 0)  begin
         //    @(posedge `DAQ_ACTIVE);
         //    @(negedge `DAQ_ACTIVE);
         // end else begin
         //    @(negedge `DAQ_ACTIVE);
         // end

         // @(posedge `WB_CLK);
         // `DAQ_WRITE = 0;
         // `DAQ_ADDR = $random;
         // `DAQ_SEL = $random;
         // `DAQ_START = 0;
         // data = `DAQ_DATA_RD;
         //$display("DAQ READ addr = 0x%x data = 0x%x sel = 0x%x @ %d", address, data, selection, $time);
         `TEST_COMPARE("DAQ READ", expected, data);
         repeat (1) @(posedge `WB_CLK);
      end
   endtask // DAQ_READ

   task DAQ_WRITE;
      input [31:0] address;
      input [3:0]  selection;
      input [31:0] data;
      begin
         @(posedge `WB_CLK);
         //$display("DAQ WRITE addr = 0x%x data = 0x%x sel = 0x%x @ %d", address, data, selection, $time);

         // `DAQ_ADDR = address;
         // `DAQ_DATA_WR = data;
         // `DAQ_SEL = selection;
         // `DAQ_WRITE = 1;
         // `DAQ_START = 1;

         // if (`DAQ_ACTIVE === 0) begin
         //    @(posedge `DAQ_ACTIVE);
         //    @(negedge `DAQ_ACTIVE);
         // end else begin
         //    @(negedge `DAQ_ACTIVE);
         // end

         // @(posedge `WB_CLK);
         // `DAQ_WRITE = 0;
         // `DAQ_ADDR = $random;
         // `DAQ_DATA_WR = $random;
         // `DAQ_SEL = $random;
         // `DAQ_START = 0;
         repeat (1) @(posedge `WB_CLK);
      end
   endtask // DAQ_WRITE

   reg daq_writes_busy;
   
   task DAQ_WRITES_FILE;
      input [7:0] file_num;
      input [31:0] data;
      begin
         $display("DAQ WRITES FILE File = %d Data = 0x%x @ %d", file_num, data, $time);
         daq_writes_busy <= 1'b1;         
         `UART_WRITE_BYTE(`PKT_PREAMBLE);                     // Preamble
         `UART_WRITE_BYTE(8'hF0 | `PKT_COMMAND_DAQ_WRITE);    // Size and Command
         `UART_WRITE_BYTE(8'h1);                              // Length
         `UART_WRITE_BYTE(file_num);                          // File Number
         `UART_WRITE_WORD(data);                              // Write Data
         
         while(`UART_BUSY == 1'b1) begin
            #100;            
         end
         daq_writes_busy <= 1'b0;
         
         // if (`FILE_ACTIVE) begin
         //    @(negedge `FILE_ACTIVE);
         // end

         // @(posedge `WB_CLK);

         // `FILE_NUM = file_num;
         // `FILE_WRITE = 1;
         // `FILE_WRITE_DATA = data;
         // @(posedge `WB_CLK);
         // `FILE_WRITE = 0;
         // `FILE_NUM = $random;
         // `FILE_WRITE_DATA = $random;

      end
   endtask // DAQ_WRITE_FILE


   task RUN_DTREE;
      input [7:0] split_file;
      input [7:0] output_file;
      reg [31:0]  input0;
      reg [31:0]  input1;
      reg [31:0]  input3;      
      begin
         input0 = 0;
         input1 = 0;
         input3 = 0;
         
         input0[`F_DSP_SLAVE_EQUATION_NUMBER] = `B_DSP_EQUATION_DTREE;
         input0[`F_DSP_SLAVE_EQUATION_START] = 1;
         input1[`F_DSP_SLAVE_INPUT_FILE0] = split_file;  
         input3[`F_DSP_SLAVE_OUTPUT_FILE0] = output_file;

         $display("\nDTREE START @ %d", $time);
         `CPU_WRITES(`WB_DSP_SLAVE_BASE_ADDRESS+`WB_DSP_SLAVE_INPUT1_OFFSET,   4'hF, input1);
         `CPU_WRITES(`WB_DSP_SLAVE_BASE_ADDRESS+`WB_DSP_SLAVE_INPUT3_OFFSET,   4'hF, input3);
         `CPU_WRITES(`WB_DSP_SLAVE_BASE_ADDRESS+`WB_DSP_SLAVE_INPUT0_OFFSET,   4'hF, input0);
         @(posedge `DSP_EQUATIONS.done);
         $display("DTREE DONE @ %d", $time);         
         `CPU_WRITES(`WB_DSP_SLAVE_BASE_ADDRESS+`WB_DSP_SLAVE_INPUT0_OFFSET,   4'hF, 0);
         `CPU_WRITES(`WB_DSP_SLAVE_BASE_ADDRESS+`WB_DSP_SLAVE_INPUT1_OFFSET,   4'hF, 0);
         `CPU_WRITES(`WB_DSP_SLAVE_BASE_ADDRESS+`WB_DSP_SLAVE_INPUT3_OFFSET,   4'hF, 0);
         
      end
   endtask // RUN_DTREE
   
   
endmodule // dsp_tasks
