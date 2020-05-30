//                              -*- Mode: Verilog -*-
// Filename        : dsp_equation_multiply.v
// Description     : DSP Equation Multiply
// Author          : Philip Tracton
// Created On      : Wed Apr 24 18:59:34 2019
// Last Modified By: Philip Tracton
// Last Modified On: Wed Apr 24 18:59:34 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

module dsp_equation_multiply (/*AUTOARG*/
   // Outputs
   interrupt, error, file_num, file_write, file_read, file_write_data,
   equation_done, dsp_output0_reg, dsp_output1_reg,
   // Inputs
   wb_clk, wb_rst, equation_enable, dsp_input0_reg, dsp_input1_reg,
   dsp_input2_reg, dsp_input3_reg, file_read_data, file_active,
   rd_ptr, wr_ptr
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

   input [dw-1:0] dsp_input0_reg;
   input [dw-1:0] dsp_input1_reg;
   input [dw-1:0] dsp_input2_reg;
   input [dw-1:0] dsp_input3_reg;

   output reg [7:0] file_num;
   output reg       file_write;
   output reg       file_read;
   output reg [31:0] file_write_data;
   input [31:0]      file_read_data;
   input             file_active;

   input [31:0]      rd_ptr;
   input [31:0]      wr_ptr;
   output reg        equation_done;
   output reg [31:0] dsp_output0_reg;
   output reg [31:0] dsp_output1_reg;


   wire              equation_start = dsp_input0_reg[`F_DSP_SLAVE_EQUATION_START] & equation_enable;
   wire [1:0]        data_size =dsp_input0_reg[`F_DSP_SLAVE_DATA_SIZE];
   wire              data_signed =dsp_input0_reg[`F_DSP_SLAVE_DATA_SIGNED];
   wire              enable_mac = dsp_input0_reg[`F_DSP_SLAVE_ENABLE_MAC];
   wire              scalar_multiply = dsp_input0_reg[`F_DSP_SLAVE_SCALAR_MULTIPLY];

   wire [7:0]        input_file0 = dsp_input1_reg[`F_DSP_SLAVE_INPUT_FILE0];
   wire [7:0]        input_file1 = dsp_input1_reg[`F_DSP_SLAVE_INPUT_FILE1];
   wire [7:0]        output_file = dsp_input3_reg[`F_DSP_SLAVE_OUTPUT_FILE0];
   reg [63:0]        multiply_output;
   reg [63:0]        mac_output;
   reg [31:0]        operand0;
   reg [31:0]        operand1;


   localparam STATE_IDLE                    = 8'h00;
   localparam STATE_READ_INPUT_FILE0        = 8'h01;
   localparam STATE_READ_INPUT_FILE0_DONE   = 8'h02;
   localparam STATE_READ_INPUT_FILE1        = 8'h03;
   localparam STATE_READ_INPUT_FILE1_DONE   = 8'h04;
   localparam STATE_OPERATION               = 8'h05;
   localparam STATE_WRITE_READ_FILE         = 8'h06;
   localparam STATE_WRITE_READ_FILE_DONE    = 8'h07;
   localparam STATE_WRITE_RESULTS_FILE      = 8'h08;
   localparam STATE_WRITE_RESULTS_FILE_DONE = 8'h09;

   reg [7:0]         state;
   //reg [31:0]        sample_count;
   //   reg [31:0]        file_data_in;

   always @(posedge wb_clk)
     if (wb_rst) begin
        state <= STATE_IDLE;
        interrupt <= 0;
        error <= 0;
        file_num <=0;
        file_write <= 0;
        file_read <=0;
        file_write_data <=0;
        multiply_output <= 0;
        mac_output <=0;
//        sample_count <=0;
//        file_data_in <=0;
        equation_done <= 0;
        dsp_output0_reg <= 0;
        dsp_output1_reg <= 0;

        operand0 <= 0;
        operand1 <= 0;

     end else begin
        case (state)
          STATE_IDLE: begin
             file_num <= input_file0;
             file_write <= 0;
             file_read <=0;
             equation_done <= 0;
             if (equation_start) begin
                multiply_output <= 0;
                mac_output <=0;
                file_write_data <=0;
                dsp_output0_reg <=0;
                state <= STATE_READ_INPUT_FILE0;

                //sample_count <= 0;
                error <= 0;
//                file_data_in <= 0;

             end else begin
                state <= STATE_IDLE;
             end
          end // case: STATE_IDLE

          STATE_READ_INPUT_FILE0: begin
             file_num <= input_file0;
             file_read <= 1;
             if (file_active) begin
                state <= STATE_READ_INPUT_FILE0_DONE;
             end else begin
                state <= STATE_READ_INPUT_FILE0;
             end
          end
          STATE_READ_INPUT_FILE0_DONE:begin
             file_read <= 0;
             if (file_active) begin
                state <= STATE_READ_INPUT_FILE0_DONE;
                operand0 <= file_read_data;
             end else begin
                if (scalar_multiply) begin
                   operand1 <= dsp_input2_reg;
                   state <= STATE_OPERATION;
                end else begin
                   file_num <= input_file1;
                   state <= STATE_READ_INPUT_FILE1;
                end
             end
          end // case: STATE_READ_INPUT_FILE0_DONE

          STATE_READ_INPUT_FILE1: begin
             file_read <= 1;
             if (file_active) begin
                state <= STATE_READ_INPUT_FILE1_DONE;
             end else begin
                state <= STATE_READ_INPUT_FILE1;
             end
          end
          STATE_READ_INPUT_FILE1_DONE:begin
             file_read <= 0;
             if (file_active) begin
                state <= STATE_READ_INPUT_FILE1_DONE;
                operand1 <= file_read_data;
             end else begin
                state <= STATE_OPERATION;
             end
          end

          STATE_OPERATION: begin
             multiply_output <= operand0 * operand1;
             //sample_count <= sample_count + 1;
             if (enable_mac) begin
                mac_output <= mac_output + (operand0 * operand1);
             end
             state <= STATE_WRITE_RESULTS_FILE;
             file_num <= output_file;
             equation_done <= (wr_ptr == rd_ptr);
          end // case: STATE_OPERATION

          STATE_WRITE_RESULTS_FILE: begin
             file_write <= 1;
             dsp_output0_reg <= multiply_output[31:0];
             if (enable_mac) begin
                dsp_output1_reg <= mac_output[31:0];
             end
             file_write_data <= multiply_output[31:0];
             if (file_active) begin
                state <= STATE_WRITE_RESULTS_FILE_DONE;
             end else begin
                state <= STATE_WRITE_RESULTS_FILE;
             end
          end
          STATE_WRITE_RESULTS_FILE_DONE:begin
             file_write <= 0;
             if (file_active) begin
                state <= STATE_WRITE_RESULTS_FILE_DONE;
             end else begin
                if (equation_done)
                  state <= STATE_IDLE;
                else
                  state <= STATE_READ_INPUT_FILE0;
             end
          end // case: STATE_WRITE_RESULTS_FILE_DONE


          default:begin
             state <= STATE_IDLE;
          end
        endcase // case (state)

     end

`ifdef SIM
   reg [(32*8)-1:0] state_name;
   always @(*) begin
      case (state)
        STATE_IDLE: state_name = "STATE_IDLE";
        STATE_READ_INPUT_FILE0 : state_name = "STATE_READ_INPUT_FILE0";
        STATE_READ_INPUT_FILE0_DONE: state_name = "STATE_READ_INPUT_FILE0_DONE";
        STATE_READ_INPUT_FILE1: state_name = "STATE_READ_INPUT_FILE1";
        STATE_READ_INPUT_FILE1_DONE: state_name = "STATE_READ_INPUT_FILE1_DONE";
        STATE_OPERATION: state_name = "STATE_OPERATION";
        STATE_WRITE_READ_FILE: state_name = "STATE_WRITE_READ_FILE";
        STATE_WRITE_READ_FILE_DONE: state_name = "STATE_WRITE_READ_FILE_DONE";
        STATE_WRITE_RESULTS_FILE: state_name = "STATE_WRITE_RESULTS_FILE";
        STATE_WRITE_RESULTS_FILE_DONE: state_name = "STATE_WRITE_RESULTS_FILE_DONE";
//        : state_name = "";

        default: state_name = "DEFAULT";
      endcase // case (state)
   end
`endif

endmodule // dsp_equation_multiply
