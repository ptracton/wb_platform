//                              -*- Mode: Verilog -*-
// Filename        : dsp_top.v
// Description     : DSP Top
// Author          : Phil Tracton
// Created On      : Mon Apr 15 16:46:09 2019
// Last Modified By: Phil Tracton
// Last Modified On: Mon Apr 15 16:46:09 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

module dsp_top (/*AUTOARG*/
   // Outputs
   wb_m_adr_o, wb_m_dat_o, wb_m_sel_o, wb_m_we_o, wb_m_cyc_o,
   wb_m_stb_o, wb_m_cti_o, wb_m_bte_o, wb_s_dat_o, wb_s_ack_o,
   wb_s_err_o, wb_s_rty_o, leds, interrupt, anode, cathode,
   // Inputs
   wb_clk, wb_rst, wb_m_dat_i, wb_m_ack_i, wb_m_err_i, wb_m_rty_i,
   wb_s_adr_i, wb_s_dat_i, wb_s_sel_i, wb_s_we_i, wb_s_cyc_i,
   wb_s_stb_i, wb_s_cti_i, wb_s_bte_i
   ) ;
   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;
   parameter SLAVE_ADDRESS = 32'h00000000;


   input 		wb_clk;
   input 		wb_rst;
   output wire [aw-1:0] wb_m_adr_o;
   output wire [dw-1:0] wb_m_dat_o;
   output wire [3:0]    wb_m_sel_o;
   output wire          wb_m_we_o ;
   output wire          wb_m_cyc_o;
   output wire          wb_m_stb_o;
   output wire [2:0]    wb_m_cti_o;
   output wire [1:0]    wb_m_bte_o;
   input [dw-1:0]       wb_m_dat_i;
   input                wb_m_ack_i;
   input                wb_m_err_i;
   input                wb_m_rty_i;


   input wire [aw-1:0]  wb_s_adr_i;
   input wire [dw-1:0]  wb_s_dat_i;
   input wire [3:0]     wb_s_sel_i;
   input wire           wb_s_we_i ;
   input wire           wb_s_cyc_i;
   input wire           wb_s_stb_i;
   input wire [2:0]     wb_s_cti_i;
   input wire [1:0]     wb_s_bte_i;

   output wire [dw-1:0] wb_s_dat_o;
   output wire          wb_s_ack_o;
   output wire          wb_s_err_o;
   output wire          wb_s_rty_o;
   output wire [15:0]   leds;
   output wire          interrupt;

   output wire [3:0]    anode;
   output wire [7:0]    cathode;   
   
   wire [7:0]           file_num;
   wire                 file_write;
   wire                 file_read;
   wire [31:0]          file_write_data;
   wire [31:0]          file_read_data;
   wire [31:0]          file_rd_ptr_offset;
   wire                 start;
   wire [31:0]          rd_ptr;
   wire [31:0]          wr_ptr;

   //
   // Read Write Registers
   //
   wire [dw-1:0]        dsp_input0_reg;
   wire [dw-1:0]        dsp_input1_reg;
   wire [dw-1:0]        dsp_input2_reg;
   wire [dw-1:0]        dsp_input3_reg;
   wire [dw-1:0]        dsp_input4_reg;

   //
   // Read Only Registers
   //
   wire [dw-1:0]        dsp_output0_reg ; // 32'h0123_4567;
   wire [dw-1:0]        dsp_output1_reg ; // 32'h89ab_cdef;
   wire [dw-1:0]        dsp_output2_reg ; // 32'h1122_3344;
   wire [dw-1:0]        dsp_output3_reg ; // 32'h5566_7788;
   wire [dw-1:0]        dsp_output4_reg ; // 32'h99aa_bbcc;

   wire [31:0]          data_rd;
   wire [31:0]          address;
   wire [3:0]           selection;
   wire [31:0]          data_wr;
   wire                 active;
   wire                 write;
   wire                 done;
   wire                 file_active;
   wire                 file_reset;
   
   wire                 ram_read;
   wire [aw-1:0]        ram_address;
   wire                 ram_active;   
   wire [dw-1:0]        ram_read_data;

   // Debug Registers
   wire [dw-1:0]      write_addr0;
   wire [dw-1:0]      write_data0;
   wire [dw-1:0]      write_addr1;
   wire [dw-1:0]      write_data1;
   wire [dw-1:0]      write_addr2;
   wire [dw-1:0]      write_data2;
   wire [dw-1:0]      write_addr3;
   wire [dw-1:0]      write_data3;
   wire [dw-1:0]      write_addr4;
   wire [dw-1:0]      write_data4;
   wire [dw-1:0]      write_addr5;
   wire [dw-1:0]      write_data5;
   wire [dw-1:0]      write_addr6;
   wire [dw-1:0]      write_data6;
   wire [dw-1:0]      write_addr7;
   wire [dw-1:0]      write_data7;
   wire [dw-1:0]      write_addr8;
   wire [dw-1:0]      write_data8;
   wire [dw-1:0]      write_addr9;
   wire [dw-1:0]      write_data9;
   wire [dw-1:0]      write_addrA;
   wire [dw-1:0]      write_dataA;
   

   wb_master_interface master(
                              // Outputs
                              .wb_adr_o(wb_m_adr_o),
                              .wb_dat_o(wb_m_dat_o),
                              .wb_sel_o(wb_m_sel_o),
                              .wb_we_o(wb_m_we_o),
                              .wb_cyc_o(wb_m_cyc_o),
                              .wb_stb_o(wb_m_stb_o),
                              .wb_cti_o(wb_m_cti_o),
                              .wb_bte_o(wb_m_bte_o),
                              .data_rd(data_rd),
                              .active(active),                             
                              // Inputs
                              .wb_clk(wb_clk),
                              .wb_rst(wb_rst),
                              .wb_dat_i(wb_m_dat_i),
                              .wb_ack_i(wb_m_ack_i),
                              .wb_err_i(wb_m_err_i),
                              .wb_rty_i(wb_m_rty_i),                            
                              .start(start),
                              .address(address),
                              .selection(selection),
                              .write(write),
                              .data_wr(data_wr)
                              ) ;

   dsp_slave #(.SLAVE_ADDRESS(SLAVE_ADDRESS))
   slave(
         // Outputs
         .wb_dat_o(wb_s_dat_o),
         .wb_ack_o(wb_s_ack_o),
         .wb_err_o(wb_s_err_o),
         .wb_rty_o(wb_s_rty_o),
         .dsp_input0_reg(dsp_input0_reg),
         .dsp_input1_reg(dsp_input1_reg),
         .dsp_input2_reg(dsp_input2_reg),
         .dsp_input3_reg(dsp_input3_reg),
         .dsp_input4_reg(dsp_input4_reg),

         .write_addr0(write_addr0),
         .write_data0(write_data0),
         .write_addr1(write_addr1),
         .write_data1(write_data1),
         .write_addr2(write_addr2),
         .write_data2(write_data2),
         .write_addr3(write_addr3),
         .write_data3(write_data3),
         .write_addr4(write_addr4),
         .write_data4(write_data4),
         .write_addr5(write_addr5),
         .write_data5(write_data5),
         .write_addr6(write_addr6),
         .write_data6(write_data6),
         .write_addr7(write_addr7),
         .write_data7(write_data7),
         .write_addr8(write_addr8),
         .write_data8(write_data8),
         .write_addr9(write_addr9),
         .write_data9(write_data9),
         .write_addrA(write_addrA),
         .write_dataA(write_dataA),
         
         // Inputs
         .start(start),
         .done(done),
         .dsp_output0_reg(dsp_output0_reg),
         .dsp_output1_reg(dsp_output1_reg),
         .dsp_output2_reg(dsp_output2_reg),
         .dsp_output3_reg(dsp_output3_reg),
         .dsp_output4_reg(dsp_output4_reg),
         .wb_clk(wb_clk),
         .wb_rst(wb_rst),
         .wb_adr_i(wb_s_adr_i),
         .wb_dat_i(wb_s_dat_i),
         .wb_sel_i(wb_s_sel_i),
         .wb_we_i(wb_s_we_i),
         .wb_cyc_i(wb_s_cyc_i),
         .wb_stb_i(wb_s_stb_i),
         .wb_cti_i(wb_s_cti_i),
         .wb_bte_i(wb_s_bte_i)
         ) ;

   dsp_sm
     sm(
        // Outputs
        .address(address),
        .start(start),
        .selection(selection),
        .write(write),
        .data_wr(data_wr),
        .file_active(file_active),
        .ram_active(ram_active),
        .ram_read_data(ram_read_data),
/* -----\/----- EXCLUDED -----\/-----
        .dsp_output0_reg(dsp_output0_reg),
        .dsp_output1_reg(dsp_output1_reg),
        .dsp_output2_reg(dsp_output2_reg),
        .dsp_output3_reg(dsp_output3_reg),
        .dsp_output4_reg(dsp_output4_reg),
 -----/\----- EXCLUDED -----/\----- */
        .rd_ptr(rd_ptr),
        .wr_ptr(wr_ptr),
        
        .leds(leds),
        .write_addr0(write_addr0),
        .write_data0(write_data0),
        .write_addr1(write_addr1),
        .write_data1(write_data1),
        .write_addr2(write_addr2),
        .write_data2(write_data2),
        .write_addr3(write_addr3),
        .write_data3(write_data3),
        .write_addr4(write_addr4),
        .write_data4(write_data4),
        .write_addr5(write_addr5),
        .write_data5(write_data5),
        .write_addr6(write_addr6),
        .write_data6(write_data6),
        .write_addr7(write_addr7),
        .write_data7(write_data7),
        .write_addr8(write_addr8),
        .write_data8(write_data8),
        .write_addr9(write_addr9),
        .write_data9(write_data9),
        .write_addrA(write_addrA),
        .write_dataA(write_dataA),
        
        // Inputs
        .wb_clk(wb_clk),
        .wb_rst(wb_rst),
        .ram_read(ram_read),
        .ram_address(ram_address), 
        .hold_rd_ptr(hold_rd_ptr),       
        .data_rd(data_rd),
        .active(active),
        .file_num(file_num),
        .file_write(file_write),
        .file_read(file_read),
        .file_reset(file_reset),
        .file_rd_ptr_offset(file_rd_ptr_offset),
        .file_write_data(file_write_data),
        .file_read_data(file_read_data),
        .dsp_input0_reg(dsp_input0_reg),
        .dsp_input1_reg(dsp_input1_reg),
        .dsp_input2_reg(dsp_input2_reg),
        .dsp_input3_reg(dsp_input3_reg),
        .dsp_input4_reg(dsp_input4_reg)
        ) ;


   dsp_equations_top
     equations(
               // Outputs
               .file_num(file_num),
               .file_write(file_write),
               .file_read(file_read),
               .file_reset(file_reset),
               .file_rd_ptr_offset(file_rd_ptr_offset),
               .file_write_data(file_write_data),
               .dsp_output0_reg(dsp_output0_reg),
               .dsp_output1_reg(dsp_output1_reg),
               .dsp_output2_reg(dsp_output2_reg),
               .dsp_output3_reg(dsp_output3_reg),
               .dsp_output4_reg(dsp_output4_reg),
               .done(done),
//               .leds(leds),
               .interrupt(interrupt),
               .ram_read(ram_read),
               .ram_address(ram_address),
               .hold_rd_ptr(hold_rd_ptr),
               .cathode(cathode),
               .anode(anode),
               
               // Inputs
               .wb_clk(wb_clk),
               .wb_rst(wb_rst),
               .ram_active(ram_active),
               .ram_read_data(ram_read_data),               
               .rd_ptr(rd_ptr),
               .wr_ptr(wr_ptr),
               .file_active(file_active),
               .dsp_input0_reg(dsp_input0_reg),
               .dsp_input1_reg(dsp_input1_reg),
               .dsp_input2_reg(dsp_input2_reg),
               .dsp_input3_reg(dsp_input3_reg),
               .dsp_input4_reg(dsp_input4_reg),
               .file_read_data(file_read_data)
               ) ;


endmodule // dsp_top
