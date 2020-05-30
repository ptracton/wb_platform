//                              -*- Mode: Verilog -*-
// Filename        : dsp_sm.v
// Description     : DSP State Machine
// Author          : Phil Tracton
// Created On      : Mon Apr 22 16:38:34 2019
// Last Modified By: Phil Tracton
// Last Modified On: Mon Apr 22 16:38:34 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "platform_includes.vh"

module dsp_sm (/*AUTOARG*/
   // Outputs
   file_read_data, ram_active, ram_read_data, address, start,
   selection, write, data_wr, file_active, rd_ptr, wr_ptr, leds,
   write_addr0, write_data0, write_addr1, write_data1, write_addr2,
   write_data2, write_addr3, write_data3, write_addr4, write_data4,
   write_addr5, write_data5, write_addr6, write_data6, write_addr7,
   write_data7, write_addr8, write_data8, write_addr9, write_data9,
   write_addrA, write_dataA,
   // Inputs
   wb_clk, wb_rst, file_num, file_write, file_read, file_reset,
   file_write_data, file_rd_ptr_offset, ram_read, ram_address,
   hold_rd_ptr, data_rd, active, dsp_input0_reg, dsp_input1_reg,
   dsp_input2_reg, dsp_input3_reg, dsp_input4_reg
   ) ;
   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;

   input wb_clk;
   input wb_rst;

   input [7:0] file_num;
   input       file_write;
   input       file_read;
   input       file_reset;

   input [31:0] file_write_data;
   output reg [31:0] file_read_data;
   input [31:0]      file_rd_ptr_offset;
   
   // reading a single location from RAM, assume 32 bits
   input             ram_read;
   input [aw-1:0]    ram_address;
   output reg        ram_active;   
   output reg [dw-1:0]   ram_read_data;
      
   output reg [aw-1:0] address;
   output reg          start;
   output reg [3:0]    selection;
   output reg          write;
   output reg [dw-1:0] data_wr;
   output reg          file_active;
   input               hold_rd_ptr;
   

   input [dw-1:0]      data_rd;
   input               active;

   //
   // Read Write Registers
   //
   input [dw-1:0]      dsp_input0_reg;
   input [dw-1:0]      dsp_input1_reg;
   input [dw-1:0]      dsp_input2_reg;
   input [dw-1:0]      dsp_input3_reg;
   input [dw-1:0]      dsp_input4_reg;

   //
   // Read Only Registers
   //
/* -----\/----- EXCLUDED -----\/-----
   output reg [dw-1:0] dsp_output0_reg;
   output reg [dw-1:0] dsp_output1_reg;
   output reg [dw-1:0] dsp_output2_reg;
   output reg [dw-1:0] dsp_output3_reg;
   output reg [dw-1:0] dsp_output4_reg;
 -----/\----- EXCLUDED -----/\----- */


   reg [4:0]           state;
   localparam STATE_IDLE                  = 5'h00;
   localparam STATE_READ_START            = 5'h01;
   localparam STATE_READ_START_DONE       = 5'h02;
   localparam STATE_READ_END              = 5'h03;
   localparam STATE_READ_END_DONE         = 5'h04;
   localparam STATE_READ_RD_PTR           = 5'h05;
   localparam STATE_READ_RD_PTR_DONE      = 5'h06;
   localparam STATE_READ_WR_PTR           = 5'h07;
   localparam STATE_READ_WR_PTR_DONE      = 5'h08;
   localparam STATE_READ_STATUS           = 5'h09;
   localparam STATE_READ_STATUS_DONE      = 5'h0A;
   localparam STATE_READ_CONTROL          = 5'h0B;
   localparam STATE_READ_CONTROL_DONE     = 5'h0C;
   localparam STATE_READ_FILE_DATA        = 5'h0D;
   localparam STATE_READ_FILE_DATA_DONE   = 5'h0E;
   localparam STATE_WRITE_FILE_DATA       = 5'h0F;
   localparam STATE_WRITE_FILE_DATA_DONE  = 5'h10;
   localparam STATE_WRITE_STATUS          = 5'h11;
   localparam STATE_WRITE_STATUS_DONE     = 5'h12;
   localparam STATE_WRITE_RD_PTR          = 5'h13;
   localparam STATE_WRITE_RD_PTR_DONE     = 5'h14;
   localparam STATE_WRITE_WR_PTR          = 5'h15;
   localparam STATE_WRITE_WR_PTR_DONE     = 5'h16;
   localparam STATE_RESET_FILE            = 5'h17;
   localparam STATE_READ_RAM              = 5'h18;
   localparam STATE_READ_RAM_DONE         = 5'h19;

   reg [31:0]          file_base_address;
   reg [31:0]          start_address;
   reg [31:0]          end_address;
   output reg [31:0]   rd_ptr;
   output reg [31:0]   wr_ptr;
   reg [31:0]          control;
   reg [31:0]          file_write_data_reg;
   reg [31:0]          status;
   reg                 reset_file;


   // DEBUG REGISTERS
   output reg [15:0]   leds;   
   output reg [dw-1:0]      write_addr0;
   output reg [dw-1:0]      write_data0;
   output reg [dw-1:0]      write_addr1;
   output reg [dw-1:0]      write_data1;
   output reg [dw-1:0]      write_addr2;
   output reg [dw-1:0]      write_data2;
   output reg [dw-1:0]      write_addr3;
   output reg [dw-1:0]      write_data3;
   output reg [dw-1:0]      write_addr4;
   output reg [dw-1:0]      write_data4;
   output reg [dw-1:0]      write_addr5;
   output reg [dw-1:0]      write_data5;
   output reg [dw-1:0]      write_addr6;
   output reg [dw-1:0]      write_data6;
   output reg [dw-1:0]      write_addr7;
   output reg [dw-1:0]      write_data7;
   output reg [dw-1:0]      write_addr8;
   output reg [dw-1:0]      write_data8;
   output reg [dw-1:0]      write_addr9;
   output reg [dw-1:0]      write_data9;
   output reg [dw-1:0]      write_addrA;
   output reg [dw-1:0]      write_dataA;
   reg [3:0]                debug_count;
   reg                      debug_capture;
   reg [dw-1:0]             debug_addr;
   
   wire [1:0]          data_size = control[`F_CONTROL_DATA_SIZE];
   wire [2:0]          data_size_increment = (data_size == `B_CONTROL_DATA_SIZE_WORD) ? 3'h4 :
                       (data_size == `B_CONTROL_DATA_SIZE_HWORD) ? 3'h2 :
                       (data_size == `B_CONTROL_DATA_SIZE_BYTE) ? 3'h1 :
                       (data_size == `B_CONTROL_DATA_SIZE_UNDEFINED) ? 3'h0 : 3'h0;
   wire [3:0]          data_selection = (data_size == `B_CONTROL_DATA_SIZE_WORD) ? 4'hF :
                       (data_size == `B_CONTROL_DATA_SIZE_HWORD) & wr_ptr[1]==0 ? 4'h3 :
                       (data_size == `B_CONTROL_DATA_SIZE_HWORD) & wr_ptr[1]==1? 4'hC :
                       (data_size == `B_CONTROL_DATA_SIZE_BYTE)  & wr_ptr[1:0] ==0 ? 4'h1 :
                       (data_size == `B_CONTROL_DATA_SIZE_BYTE)  & wr_ptr[1:0] ==1 ? 4'h2 :
                       (data_size == `B_CONTROL_DATA_SIZE_BYTE)  & wr_ptr[1:0] ==2 ? 4'h4 :
                       (data_size == `B_CONTROL_DATA_SIZE_BYTE)  & wr_ptr[1:0] ==3 ? 4'h8 :
                       (data_size == `B_CONTROL_DATA_SIZE_UNDEFINED) ? 4'h0 : 4'h0;

   wire [31:0]         data_write = (data_selection == 4'hf) ? file_write_data_reg[31:0] :
                       (data_selection == 4'hc) ? {file_write_data_reg[31:16], 16'b0} :
                       (data_selection == 4'h3) ? {16'b0, file_write_data_reg[15:0]} :
                       (data_selection == 4'h8) ? {file_write_data_reg[31:24], 24'b0} :
                       (data_selection == 4'h4) ? {8'b0, file_write_data_reg[23:16], 16'b0} :
                       (data_selection == 4'h2) ? {16'b0, file_write_data_reg[15:08], 8'b0} :
                       (data_selection == 4'h1) ? {24'b0, file_write_data_reg[07:00]} : 0;

   reg                 srm;
   reg                 read_not_write;

   function start_read_memory;
      input [31:0]     srm_address;
      input [3:0]      srm_selection;
      begin
         address = srm_address;
         start = 1;
         selection = srm_selection;
         write =0;
         data_wr = 0;
      end
   endfunction // start_read_memory


   function start_write_memory;
      input [31:0] swm_address;
      input [31:0] swm_data;
      input [3:0]  swm_selection;
      begin
         address = swm_address;
         start = 1;
         selection = swm_selection;
         write = 1;
         data_wr = swm_data;
      end
   endfunction // start_write_memory

   always @(posedge wb_clk) begin
      if (wb_rst) begin
         file_read_data <=0;
         address <=0;
         start <=0;
         selection <=0;
         write <=0;
         data_wr <=0;
         state <= STATE_IDLE;
         file_base_address <= 0;
         start_address <= 0;
         end_address <=0;
         rd_ptr <=0;
         wr_ptr <=0;
         control <=0;
         file_write_data_reg <= 0;
         status <= 0;
         file_active <=0;
         srm <= 0;
         ram_read_data <= 0;    
         ram_active <=0;         
/* -----\/----- EXCLUDED -----\/-----
         dsp_output0_reg <= 0;
         dsp_output1_reg <= 0;
         dsp_output2_reg <= 0;
         dsp_output3_reg <= 0;
         dsp_output4_reg <= 0;
 -----/\----- EXCLUDED -----/\----- */
         read_not_write <= 0;
         reset_file <= 0;
         debug_capture <= 0;
         debug_addr <= 0;   
      end else begin
         case (state)
           STATE_IDLE: begin
              file_read_data <=0;
              address <=0;
              start <=0;
              selection <=0;
              write <=0;
              data_wr <=0;
              file_active <= 0;
              read_not_write <= 0;
              reset_file <= file_reset;
              ram_active <=0; 
              // Don't clear these in case ew do another of the same file and we can skip stuff
              // file_base_address <= 0;
              // start_address <= 0;
              // end_address <=0;
              // rd_ptr <=0;
              // wr_ptr <=0;
              // control <=0;
              //  ram_read_data <= 0;    
              if (file_read | file_write | file_reset) begin
                 read_not_write <= file_read;
                 file_active <= 1;
                 state <= STATE_READ_START;
                 file_base_address <= `WB_RAM0 + 'h20*file_num;
                 file_write_data_reg <= file_write_data;
              end else if (ram_read) begin
                 state <= STATE_READ_RAM;   
                 file_active <= 0;   
                 ram_read_data <= 0;           
              end
           end // case: STATE_IDLE

           STATE_READ_RAM: begin
              srm <= start_read_memory(ram_address , 4'hF);
              if (active) begin
                 ram_active <= 1;                 
                 state <= STATE_READ_RAM_DONE;
              end
           end

           STATE_READ_RAM_DONE: begin
              start <= 0;
              if (!active) begin
                 state <= STATE_IDLE;
                 ram_read_data <= data_rd;
                 ram_active <= 0;                 
              end              
           end           
           
           STATE_READ_START: begin
              srm <= start_read_memory(file_base_address+`FILE_START_ADDRESS_OFFSET , 4'hF);
              if (active) begin
                 state <= STATE_READ_START_DONE;
              end
           end

           STATE_READ_START_DONE: begin
              start <= 0;
              if (!active) begin
                 state <= STATE_READ_END;
                 start_address <= data_rd;
              end
           end

           STATE_READ_END: begin
              srm <= start_read_memory(file_base_address+`FILE_END_ADDRESS_OFFSET , 4'hF);
              if (active) begin
                 state <= STATE_READ_END_DONE;
              end
           end

           STATE_READ_END_DONE: begin
              start <= 0;
              if (!active) begin
                 state <= STATE_READ_RD_PTR;
                 end_address <= data_rd;
              end
           end

           STATE_READ_RD_PTR: begin
              srm <= start_read_memory(file_base_address+`FILE_RD_PTR_OFFSET , 4'hF);
              if (active) begin
                 state <= STATE_READ_RD_PTR_DONE;
              end
           end

           STATE_READ_RD_PTR_DONE: begin
              start <= 0;
              if (!active) begin
                 state <= STATE_READ_WR_PTR;
                 rd_ptr <= data_rd;
              end
           end

           STATE_READ_WR_PTR: begin
              srm <= start_read_memory(file_base_address+`FILE_WR_PTR_OFFSET , 4'hF);
              if (active) begin
                 state <= STATE_READ_WR_PTR_DONE;
              end
           end

           STATE_READ_WR_PTR_DONE: begin
              start <= 0;
              if (!active) begin
                 state <= STATE_READ_STATUS;
                 wr_ptr <= data_rd;
              end
           end

           STATE_READ_STATUS: begin
              srm <= start_read_memory(file_base_address+`FILE_STATUS_OFFSET , 4'hF);
              if (active) begin
                 state <= STATE_READ_STATUS_DONE;
              end
           end

           STATE_READ_STATUS_DONE: begin
              start <= 0;
              if (!active) begin
                 state <= STATE_READ_CONTROL;
                 status <= data_rd;
              end
           end

           STATE_READ_CONTROL: begin
              srm <= start_read_memory(file_base_address+`FILE_CONTROL_OFFSET , 4'hF);
              if (active) begin
                 state <= STATE_READ_CONTROL_DONE;
              end
           end

           STATE_READ_CONTROL_DONE: begin
              start <= 0;
              if (!active) begin
                 if (read_not_write) begin
                    if (reset_file) begin
                       state <= STATE_RESET_FILE;
                    end else begin
                       state <= STATE_READ_FILE_DATA;
                    end
                 end else begin
                    if (reset_file) begin
                       state <= STATE_RESET_FILE;
                    end else begin
                       state <= STATE_WRITE_FILE_DATA;
                    end
                 end
                 control <= data_rd;
              end
           end // case: STATE_READ_CONTROL_DONE

           STATE_READ_FILE_DATA : begin
             // $display("DSP SM READ FILE DATA 0x%x @ %d", rd_ptr, $time);

              if (file_rd_ptr_offset !== 32'h0) begin
                 srm <= start_read_memory(start_address+file_rd_ptr_offset, data_selection);
              end else begin
                 srm <= start_read_memory(rd_ptr, data_selection);
              end
              if (active) begin
                 write <=0;
                 state <= STATE_READ_FILE_DATA_DONE;
                 // increment pointer and deal with wrap around
                 if (file_rd_ptr_offset == 0) begin
                    rd_ptr <= rd_ptr + {29'b0, data_size_increment};
                    if (rd_ptr >= end_address) begin
                       rd_ptr <= start_address;
                       status[`F_STATUS_WRAP_AROUND] <= 1;
                    end
                 end
              end // if (active)
           end // case: STATE_READ_FILE_DATA


           STATE_READ_FILE_DATA_DONE: begin
              start <= 0;
              if (!active) begin
                 state <= STATE_WRITE_STATUS;
                 file_read_data <= data_rd;
              end
           end

           STATE_WRITE_FILE_DATA : begin
              // srm <= start_write_memory(wr_ptr, file_write_data_reg, data_selection);
              srm <= start_write_memory(wr_ptr, file_write_data_reg, data_selection);
              if (active) begin
                 write <=0;
                 state <= STATE_WRITE_FILE_DATA_DONE;
                 debug_capture <= 1;
                 debug_addr <= wr_ptr;                 
                 // increment pointer and deal with wrap around
                 wr_ptr <= wr_ptr + {29'b0, data_size_increment};
                 if (wr_ptr >= end_address) begin
                    wr_ptr <= start_address;
                    status[`F_STATUS_WRAP_AROUND] <= 1;
                 end
              end
           end // case: STATE_WRITE_FILE_DATA


           STATE_WRITE_FILE_DATA_DONE: begin
              start <= 0;
              debug_capture <= 0;                 
              if (!active) begin
                 state <= STATE_WRITE_STATUS;
              end
           end

           STATE_WRITE_STATUS : begin
              srm <= start_write_memory(file_base_address+`FILE_STATUS_OFFSET, status, 4'hF);
              if (active) begin
                 write <=0;
                 state <= STATE_WRITE_STATUS_DONE;
              end
           end

           STATE_WRITE_STATUS_DONE: begin
              start <= 0;
              if (!active) begin
                 if (read_not_write) begin
                    if (hold_rd_ptr) begin
                       state <= STATE_IDLE;
                    end else begin
                       state <= STATE_WRITE_RD_PTR;
                    end
                 end else begin
                    state <= STATE_WRITE_WR_PTR;
                 end
              end
           end

           STATE_WRITE_RD_PTR : begin
              srm <= start_write_memory(file_base_address+`FILE_RD_PTR_OFFSET, rd_ptr, 4'hF);
              if (active) begin
                 write <=0;
                 state <= STATE_IDLE;
              end
           end

           STATE_WRITE_WR_PTR : begin
              srm <= start_write_memory(file_base_address+`FILE_WR_PTR_OFFSET, wr_ptr, 4'hF);
              if (active) begin
                 write <=0;
                 state <= STATE_WRITE_WR_PTR_DONE;
              end
           end

           STATE_WRITE_WR_PTR_DONE: begin
              start <= 0;
              if (!active) begin
                 state <= STATE_IDLE;
              end
           end

           STATE_RESET_FILE: begin
              rd_ptr <= start_address;
              wr_ptr <= start_address;
              state <= STATE_WRITE_RD_PTR;
           end

           default: begin
              state <= STATE_IDLE;
           end

         endcase // case (state)
      end // else: !if(wb_rst)
   end // always @ (posedge wb_clk)


   always @(posedge wb_clk)
     if (wb_rst) begin
        write_addr0 <= 0;
        write_data0 <= 0;
        write_addr1 <= 0;
        write_data1 <= 0;
        write_addr2 <= 0;
        write_data2 <= 0;
        write_addr3 <= 0;
        write_data3 <= 0;
        write_addr4 <= 0;
        write_data4 <= 0;
        write_addr5 <= 0;
        write_data5 <= 0;
        write_addr6 <= 0;
        write_data6 <= 0;
        write_addr7 <= 0;
        write_data7 <= 0;
        write_addr8 <= 0;
        write_data8 <= 0;
        write_addr9 <= 0;
        write_data9 <= 0;
        write_addrA <= 0;
        write_dataA <= 0;
        debug_count <= 0;   
        leds <= 0;    
     end else begin // if (wb_rst)
        if (debug_capture) begin
           leds <= leds + 1;                      
           case (debug_count)
             4'h00 : begin
                write_addr0 <= debug_addr;
                write_data0 <= file_write_data_reg;
                debug_count <= debug_count + 1;             
             end
             4'h01 : begin
                write_addr1 <= debug_addr;
                write_data1 <= file_write_data_reg;
                debug_count <= debug_count + 1;             
             end
             4'h02 : begin
                write_addr2 <= debug_addr;
                write_data2 <= file_write_data_reg;
                debug_count <= debug_count + 1;             
             end
             4'h03 : begin
                write_addr3 <= debug_addr;
                write_data3 <= file_write_data_reg;
                debug_count <= debug_count + 1;             
             end           
             4'h04 : begin
                write_addr4 <= debug_addr;
                write_data4 <= file_write_data_reg;
                debug_count <= debug_count + 1;             
             end
             4'h05 : begin
                write_addr5 <= debug_addr;
                write_data5 <= file_write_data_reg;
                debug_count <= debug_count + 1;             
             end
             4'h06 : begin
                write_addr6 <= debug_addr;
                write_data6 <= file_write_data_reg;
                debug_count <= debug_count + 1;             
             end
             4'h07 : begin
                write_addr7 <= debug_addr;
                write_data7 <= file_write_data_reg;
                debug_count <= debug_count + 1;             
             end
             4'h08 : begin
                write_addr8 <= debug_addr;
                write_data8 <= file_write_data_reg;
                debug_count <= debug_count + 1;             
             end
             4'h09 : begin
                write_addr9 <= debug_addr;
                write_data9 <= file_write_data_reg;
                debug_count <= debug_count + 1;             
             end
             4'h0A : begin
                write_addrA <= debug_addr;
                write_dataA <= file_write_data_reg;
                debug_count <= 0;             
             end             
           endcase // case (debug_count)           
        end
     end // else: !if(wb_rst)
   
   

`ifdef SIM
   reg [32*8-1:0] state_name;
   always @(*)
     case (state)
       STATE_IDLE:           state_name     = "IDLE";
       STATE_READ_START:     state_name     = "READ START";
       STATE_READ_START_DONE:state_name     = "READ START DONE";
       STATE_READ_END:     state_name     = "READ END";
       STATE_READ_END_DONE:state_name     = "READ END DONE";
       STATE_READ_RD_PTR:     state_name     = "READ RD_PTR";
       STATE_READ_RD_PTR_DONE:state_name     = "READ RD_PTR DONE";
       STATE_READ_WR_PTR:     state_name     = "READ WR_PTR";
       STATE_READ_WR_PTR_DONE:state_name     = "READ WR_PTR DONE";
       STATE_READ_STATUS:     state_name     = "READ STATUS";
       STATE_READ_STATUS_DONE:state_name     = "READ STATUS DONE";
       STATE_READ_CONTROL:     state_name     = "READ CONTROL";
       STATE_READ_CONTROL_DONE:state_name     = "READ CONTROL DONE";
       STATE_READ_FILE_DATA:     state_name     = "READ DATA";
       STATE_READ_FILE_DATA_DONE:state_name     = "READ DATA DONE";
       STATE_WRITE_FILE_DATA:     state_name     = "WRITE FILE DATA";
       STATE_WRITE_FILE_DATA_DONE:state_name     = "WRITE FILE DATA DONE";
       STATE_WRITE_STATUS:     state_name     = "WRITE STATUS";
       STATE_WRITE_STATUS_DONE:state_name     = "WRITE STATUS DONE";
       STATE_WRITE_RD_PTR:     state_name     = "WRITE RD PTR";
       STATE_WRITE_RD_PTR_DONE:state_name     = "WRITE RD PTR DONE";
       STATE_WRITE_WR_PTR:     state_name     = "WRITE WR PTR";
       STATE_WRITE_WR_PTR_DONE:state_name     = "WRITE WR PTR DONE";
       STATE_RESET_FILE:state_name     = "RESET FILE";


       default:              state_name     = "DEFAULT";
     endcase // case (state)

`endif

endmodule // dsp_sm
