//                              -*- Mode: Verilog -*-
// Filename        : dsp_equations_top.v
// Description     : DSP Equations Top
// Author          : Phil Tracton
// Created On      : Tue Apr 23 16:39:41 2019
// Last Modified By: Phil Tracton
// Last Modified On: Tue Apr 23 16:39:41 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!
`include "platform_includes.vh"

module dsp_equations_top (/*AUTOARG*/
   // Outputs
   dsp_output0_reg, dsp_output1_reg, dsp_output2_reg, dsp_output3_reg,
   dsp_output4_reg, done, leds, interrupt, file_num, file_write,
   file_read, file_reset, file_rd_ptr_offset, file_write_data,
   ram_address, ram_read, hold_rd_ptr, anode, cathode,
   // Inputs
   wb_clk, wb_rst, rd_ptr, wr_ptr, dsp_input0_reg, dsp_input1_reg,
   dsp_input2_reg, dsp_input3_reg, dsp_input4_reg, file_read_data,
   file_active, ram_active, ram_read_data
   ) ;

   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;

   input wb_clk;
   input wb_rst;
   input [31:0] rd_ptr;
   input [31:0] wr_ptr;

   input [dw-1:0] dsp_input0_reg;
   input [dw-1:0] dsp_input1_reg;
   input [dw-1:0] dsp_input2_reg;
   input [dw-1:0] dsp_input3_reg;
   input [dw-1:0] dsp_input4_reg;

   output wire [dw-1:0] dsp_output0_reg;
   output wire [dw-1:0] dsp_output1_reg;
   output wire [dw-1:0] dsp_output2_reg;
   output wire [dw-1:0] dsp_output3_reg;
   output wire [dw-1:0] dsp_output4_reg;
   output wire          done;
   output wire [15:0]   leds;
   output wire          interrupt;

   output wire [7:0] file_num;
   output wire       file_write;
   output wire       file_read;
   output wire       file_reset;
   output wire [31:0] file_rd_ptr_offset;
   output wire [31:0] file_write_data;
   input [31:0]      file_read_data;
   input             file_active;
   wire              error;
   
   output wire [aw-1:0] ram_address;
   output wire          ram_read;
   input                ram_active;   
   input [dw-1:0]       ram_read_data;
   output wire          hold_rd_ptr;

   output wire [3:0]    anode;
   output wire [7:0]    cathode;
   
   wire              interrupt_sum;
   wire              error_sum;
   wire [7:0]        file_num_sum;
   wire              file_write_sum;
   wire              file_read_sum;
   wire [31:0]       file_write_data_sum;
   wire              done_sum;

   wire              interrupt_multiply;
   wire              error_multiply;
   wire [7:0]        file_num_multiply;
   wire              file_write_multiply;
   wire              file_read_multiply;
   wire [31:0]       file_write_data_multiply;
   wire              done_multiply;
   
   wire  equation_enable_sum = (dsp_input0_reg[`F_DSP_SLAVE_EQUATION_NUMBER] == `B_DSP_EQUATION_SUM);
   wire  equation_enable_multiply = (dsp_input0_reg[`F_DSP_SLAVE_EQUATION_NUMBER] == `B_DSP_EQUATION_MULTIPLY);

   assign ram_read = 0;   
   assign ram_address = 0;
   
   assign file_reset = 0;
   assign file_rd_ptr_offset = 0;

   assign interrupt = (equation_enable_sum) ? interrupt_sum :
                      (equation_enable_multiply) ? interrupt_multiply :
                      0;

   assign error = (equation_enable_sum) ? error_sum :
                  (equation_enable_multiply) ? error_multiply:
                  0;

   assign file_num = (equation_enable_sum) ? file_num_sum :
                     (equation_enable_multiply) ? file_num_multiply:
                     0;

   assign file_write = (equation_enable_sum) ? file_write_sum :
                       (equation_enable_multiply) ? file_write_multiply:
                       0;

   assign file_read = (equation_enable_sum) ? file_read_sum :
                      (equation_enable_multiply) ? file_read_multiply:
                      0;

   assign file_write_data = (equation_enable_sum) ? file_write_data_sum :
                            (equation_enable_multiply) ? file_write_data_multiply:
                            0;

   assign done = (equation_enable_sum) ? done_sum :
                 (equation_enable_multiply) ? done_multiply:
                 0;

   wire [31:0] dsp_output0_sum, dsp_output0_mult;
   assign dsp_output0_reg = (equation_enable_sum) ? dsp_output0_sum :
                            (equation_enable_multiply) ? dsp_output0_mult 
                            : 0;

   wire [31:0] dsp_output1_sum, dsp_output1_mult, dsp_output1_forest;
   assign dsp_output1_reg = (equation_enable_multiply) ? dsp_output1_mult 
                            : 0;

   assign dsp_output2_reg = 0;
   assign dsp_output3_reg = 0;
   assign dsp_output4_reg = 0;
   wire [3:0]  segment0;
   wire [3:0]  segment1;
   wire [3:0]  segment2;
   wire [3:0]  segment3;

   display segment_display(
                           .anode(anode),
                           .cathode(cathode),
                           .clk(wb_clk),
                           .reset(wb_rst),
                           .segment0(segment0),
                           .segment1(segment1),
                           .segment2(segment2),
                           .segment3(segment3)
                           );
   
   
   dsp_equation_sum
     sum(
         // Outputs
         .interrupt(interrupt_sum),
         .error(error_sum),
         .file_num(file_num_sum),
         .file_write(file_write_sum),
         .file_read(file_read_sum),
         .file_write_data(file_write_data_sum),
         .equation_done(done_sum),
         .dsp_output0_reg(dsp_output0_sum),
//         .leds(leds),

         // Inputs
         .wb_clk(wb_clk),
         .wb_rst(wb_rst),
         .equation_enable(equation_enable_sum),
         .rd_ptr(rd_ptr),
         .wr_ptr(wr_ptr),
         .dsp_input0_reg(dsp_input0_reg),
         .dsp_input1_reg(dsp_input1_reg),
         .dsp_input3_reg(dsp_input3_reg),
         .file_read_data(file_read_data),
         .file_active(file_active)
         ) ;


   dsp_equation_multiply
     multiply (
               // Outputs
               .interrupt(interrupt_multiply),
               .error(error_multiply),
               .file_num(file_num_multiply),
               .file_write(file_write_multiply),
               .file_read(file_read_multiply),
               .file_write_data(file_write_data_multiply),
               .equation_done(done_multiply),
               .dsp_output0_reg(dsp_output0_mult),
               .dsp_output1_reg(dsp_output1_mult),
               // Inputs
               .wb_clk(wb_clk),
               .wb_rst(wb_rst),
               .equation_enable(equation_enable_multiply),
               .dsp_input0_reg(dsp_input0_reg),
               .dsp_input1_reg(dsp_input1_reg),
               .dsp_input2_reg(dsp_input2_reg),
               .dsp_input3_reg(dsp_input3_reg),
               .file_read_data(file_read_data),
               .file_active(file_active),
               .rd_ptr(rd_ptr),
               .wr_ptr(wr_ptr)
               );


   
endmodule // dsp_equations_top
