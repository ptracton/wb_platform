//                              -*- Mode: Verilog -*-
// Filename        : dsp_equation_sum.v
// Description     : DSP Equation Sum
// Author          : Phil Tracton
// Created On      : Tue Apr 23 17:04:29 2019
// Last Modified By: Phil Tracton
// Last Modified On: Tue Apr 23 17:04:29 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!
module dsp_equation_sum (/*AUTOARG*/
   // Outputs
   interrupt, error, leds, file_num, file_write, file_read,
   file_write_data, equation_done, dsp_output0_reg,
   // Inputs
   wb_clk, wb_rst, equation_enable, dsp_input0_reg, dsp_input1_reg,
   dsp_input3_reg, file_read_data, file_active, rd_ptr, wr_ptr
   ) ;

   `include "platform_includes.vh"

   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;

   input wb_clk;
   input wb_rst;
   input equation_enable;

   /* verilator lint_off SYMRSVDWORD */
   output reg interrupt;
   /* verilator lint_on SYMRSVDWORD */
   output reg error;
   output reg [15:0] leds;

   input [dw-1:0] dsp_input0_reg;
   input [dw-1:0] dsp_input1_reg;
   input [dw-1:0] dsp_input3_reg;

   output reg [7:0] file_num;
   output reg     file_write;
   output reg     file_read;
   output reg [31:0] file_write_data;
   input  [31:0] file_read_data;
   input         file_active;

   input [31:0]  rd_ptr;
   input [31:0]  wr_ptr;
   output reg    equation_done;
   output reg [31:0] dsp_output0_reg;


   localparam STATE_IDLE                    = 8'h00;
   localparam STATE_READ_INPUT_FILE         = 8'h01;
   localparam STATE_READ_INPUT_FILE_DONE    = 8'h02;
   localparam STATE_OPERATION               = 8'h03;
   localparam STATE_WRITE_READ_FILE         = 8'h04;
   localparam STATE_WRITE_READ_FILE_DONE    = 8'h05;
   localparam STATE_WRITE_RESULTS_FILE      = 8'h06;
   localparam STATE_WRITE_RESULTS_FILE_DONE = 8'h07;

   reg [7:0]     state;


   wire  equation_start = dsp_input0_reg[`F_DSP_SLAVE_EQUATION_START] & equation_enable;
   wire [1:0] data_size =dsp_input0_reg[`F_DSP_SLAVE_DATA_SIZE];
   wire       data_signed =dsp_input0_reg[`F_DSP_SLAVE_DATA_SIGNED] ;

   wire [7:0] input_file = dsp_input1_reg[`F_DSP_SLAVE_INPUT_FILE0];
   wire [7:0] output_file = dsp_input3_reg[`F_DSP_SLAVE_OUTPUT_FILE0];

   reg [31:0] sum;
   reg [31:0] sample_count;
   reg [31:0] file_data_in;
   reg        carry;


   always @(posedge wb_clk)
     if (wb_rst) begin
        state <= STATE_IDLE;
        interrupt <= 0;
        error <= 0;
        file_num <=0;
        file_write <= 0;
        file_read <=0;
        file_write_data <=0;
        sum <= 0;
        //sample_count <=0;
        file_data_in <=0;
        equation_done <= 0;
        dsp_output0_reg <= 0;
        carry <= 0;
        leds <= 0;
     end else begin
        case (state)
          STATE_IDLE: begin
             file_num <= input_file;
             file_write <= 0;
             file_read <=0;
             equation_done <= 0;
             interrupt <= 0;                
             if (equation_start) begin
                interrupt <= 0;                
                file_write_data <=0;
                dsp_output0_reg <=0;
                state <= STATE_READ_INPUT_FILE;
                sum <= 0;
                //sample_count <= 0;
                error <= 0;
                file_data_in <= 0;
                carry <= 0;
             end else begin
                state <= STATE_IDLE;
             end
          end // case: STATE_IDLE

          STATE_READ_INPUT_FILE: begin
             file_read <= 1;
             leds[0] <= 1;
             if (file_active) begin
                state <= STATE_READ_INPUT_FILE_DONE;
             end else begin
                state <= STATE_READ_INPUT_FILE;
             end
          end
          STATE_READ_INPUT_FILE_DONE:begin
             file_read <= 0;
             if (file_active) begin
                state <= STATE_READ_INPUT_FILE_DONE;
                file_data_in <= file_read_data;
             end else begin
                state <= STATE_OPERATION;
             end
          end

          STATE_OPERATION: begin
             leds[1] <= 1;
             if (data_size == `B_CONTROL_DATA_SIZE_WORD) begin
                {carry, sum} <= sum + file_data_in;
                //sample_count <= sample_count + 1;
                leds[2] <= 1;
             end else if (data_size == `B_CONTROL_DATA_SIZE_HWORD) begin
                {carry, sum} <= sum + {16'b0, file_data_in[31:16] + file_data_in[15:0]};
                //sample_count <= sample_count + 2;
                leds[3] <= 1;
             end else if (data_size == `B_CONTROL_DATA_SIZE_BYTE) begin
                {carry, sum} <= sum + {24'b0, file_data_in[31:24] + file_data_in[23:16] + file_data_in[15:8] + file_data_in[7:0]};
                //sample_count <= sample_count + 4;
                leds[4] <= 1;
             end else begin
                leds[5] <= 1;
                sum <= 0;
                //sample_count <=0;
                error <= 1;
             end
             if (carry) begin
                error <= 1;
             end
             if (wr_ptr != rd_ptr) begin
                leds[6] <= 1;
                state <= STATE_READ_INPUT_FILE;
             end else begin
                leds[7] <= 1;
                state <= STATE_WRITE_RESULTS_FILE;
                file_num <= output_file;
             end
          end // case: STATE_OPERATION

          STATE_WRITE_RESULTS_FILE: begin
             file_write <= 1;
             dsp_output0_reg <= sum;
             file_write_data <= sum;
             leds[8] <= 1;
             if (file_active) begin
                state <= STATE_WRITE_RESULTS_FILE_DONE;
             end else begin
                state <= STATE_WRITE_RESULTS_FILE;
             end
          end
          STATE_WRITE_RESULTS_FILE_DONE:begin
             file_write <= 0;
             leds[9] <= 1;
             if (file_active) begin
                state <= STATE_WRITE_RESULTS_FILE_DONE;
             end else begin
                interrupt <= 1;                
                state <= STATE_IDLE;
                equation_done <= 1;
             end
          end


          default:begin
             state <= STATE_IDLE;
          end
        endcase // case (state)

     end

endmodule // dsp_equation_sum
