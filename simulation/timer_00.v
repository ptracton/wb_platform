//                              -*- Mode: Verilog -*-
// Filename        : dtree_00.v
// Description     : Initial DTREE Test Case
// Author          : Philip Tracton
// Created On      : Wed May  1 20:39:48 2019
// Last Modified By: Philip Tracton
// Last Modified On: Wed May  1 20:39:48 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

module test_case (/*AUTOARG*/ ) ;
   //
   // Test Configuration
   // These parameters need to be set for each test case
   //
   parameter simulation_name = "multiply_00";
   parameter number_of_tests = 7;

   integer i;
   reg [31:0] input0;
   reg [31:0] input1;
   reg [31:0] input3;

   reg [31:0] daq_read;
   reg [31:0] cpu_read;
   reg [31:0] debug_reg;

   time       time_ms;
   reg        valid_time_ms;

   time       time_100ms;
   reg        valid_time_100ms;

   time       time_250ms;
   reg        valid_time_250ms;

   time       time_second;
   reg        valid_time_second;

   always @(posedge `SYSCON.ms_edge or posedge `SYSCON.wb_rst_o)
     if (`SYSCON.wb_rst_o) begin
        time_ms <= $time;
        valid_time_ms <= 0;
     end else begin
        if (valid_time_ms) begin
           //`TEST_RANGE("MS Timing", 1000000-1, 1000001, $time-time_ms);
        end
        valid_time_ms <= 1;
        time_ms <= $time;
     end

   always @(posedge `SYSCON.tenth_second_edge or posedge `SYSCON.wb_rst_o)
     if (`SYSCON.wb_rst_o) begin
        time_100ms <= $time;
        valid_time_100ms <= 0;
     end else begin
        if (valid_time_100ms) begin
           `TEST_RANGE("100MS Timing", 100000000-1, 100000001, $time-time_100ms);
        end
        valid_time_100ms <= 1;
        time_100ms <= $time;
     end

   always @(posedge `SYSCON.quarter_second_edge or posedge `SYSCON.wb_rst_o)
     if (`SYSCON.wb_rst_o) begin
        time_250ms <= $time;
        valid_time_250ms <= 0;
     end else begin
        if (valid_time_250ms) begin
           `TEST_RANGE("250MS Timing", 250000000-1, 250000001, $time-time_250ms);
        end
        valid_time_250ms <= 1;
        time_250ms <= $time;
     end

   always @(posedge `SYSCON.second_edge or posedge `SYSCON.wb_rst_o)
     if (`SYSCON.wb_rst_o) begin
        time_second <= $time;
        valid_time_second <= 0;
     end else begin
        if (valid_time_second) begin
           `TEST_RANGE("SECOND Timing", 1000000000-1, 1000000001, $time-time_second);
        end
        valid_time_second <= 1;
        time_second <= $time;
     end

   initial begin
      daq_read = 0;
      input0 = 0;
      input1 = 0;
      input3 = 0;


      @(negedge `WB_RST);
      `TEST_COMPARE("TIMER 00 TEST CASE",0,0);

      //@(posedge `SYSCON.ms_edge);
      //$display("1 ms = %d @ %d", ($realtime-time1), $time);


      repeat (5) @(posedge `SYSCON.second_edge) begin
         //$display("Quarter Second @ %d", $time);
      end


      `TEST_COMPLETE;
   end // initial begin

endmodule // test
