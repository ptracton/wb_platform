//                              -*- Mode: Verilog -*-
// Filename        : gpio_00.v
// Description     : Basic GPIO test
// Author          : Phil Tracton
// Created On      : Thu May 23 10:02:06 2019
// Last Modified By: Phil Tracton
// Last Modified On: Thu May 23 10:02:06 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

module test_case (/*AUTOARG*/ ) ;
   //
   // Test Configuration
   // These parameters need to be set for each test case
   //
   parameter simulation_name = "gpio_00";
   parameter number_of_tests = 45;

   integer i;


   reg [31:0] daq_read;
   reg [31:0] cpu_read;
   reg [31:0] debug_reg;

   initial begin
      daq_read = 0;

      @(negedge `WB_RST);
      `TEST_COMPARE("GPIO 00 TEST CASE",0,0);
      @(posedge `TB.UART_VALID);
      `CPU_WRITES(`WB_GPIO_R_OUT,   4'hF, 32'h0000_0000);

      for (i =0 ; i<16; i= i +1) begin
         `CPU_WRITES(`WB_GPIO_R_OUT,   4'hF, 32'h0000_0000+ (1 <<i));
         #100000;

         `TEST_COMPARE("GPIO ASSERTED", (32'h0000_0000+ (1 <<i)), `TB.leds);
      end

      `CPU_WRITES(`WB_GPIO_R_OUT,   4'hF, 32'h0000_AAAA);
      #2000;
      `TEST_COMPARE("GPIO 0xAAAA", 32'h0000_AAAA, `TB.leds);


      `CPU_WRITES(`WB_GPIO_R_OUT,   4'hF, 32'h0000_5555);
      #2000;
      `TEST_COMPARE("GPIO 0x5555", 32'h0000_5555, `TB.leds);

      `CPU_WRITES(`WB_GPIO_R_OUT,   4'hF, 32'h0000_A5A5);
      #2000;
      `TEST_COMPARE("GPIO 0xA5A5", 32'h0000_A5A5, `TB.leds);

      `CPU_WRITES(`WB_GPIO_R_OUT,   4'hF, 32'h0000_5A5A);
      #2000;
      `TEST_COMPARE("GPIO 0x5A5A", 32'h0000_5A5A, `TB.leds);

      `CPU_WRITES(`WB_GPIO_R_OUT,   4'hF, 32'h0000_FFFF);
      #2000;
      `TEST_COMPARE("GPIO 0xFFFF", 32'h0000_FFFF, `TB.leds);

      `CPU_WRITES(`WB_GPIO_R_OUT,   4'hF, 32'h0000_0000);
      #2000;
      `TEST_COMPARE("GPIO Cleared and Done", 32'h0000_0000, `TB.leds);


      for (i=0; i< 16; i=i+1) begin
         `TB.switches <= 16'h0000 + (1 << i);
         `CPU_READS(`WB_GPIO_R_IN, 4'hF, 32'h0000_0000 + (1 << i), cpu_read);
      end

      `TB.switches <= 16'hAAAA;
      `CPU_READS(`WB_GPIO_R_IN, 4'hF, 32'h0000_AAAA, cpu_read);

      `TB.switches <= 16'h5555;
      `CPU_READS(`WB_GPIO_R_IN, 4'hF, 32'h0000_5555, cpu_read);

      `TB.switches <= 16'hA5A5;
      `CPU_READS(`WB_GPIO_R_IN, 4'hF, 32'h0000_A5A5, cpu_read);

      `TB.switches <= 16'h5A5A;
      `CPU_READS(`WB_GPIO_R_IN, 4'hF, 32'h0000_5A5A, cpu_read);

      `TB.switches <= 16'hFFFF;
      `CPU_READS(`WB_GPIO_R_IN, 4'hF, 32'h0000_FFFF, cpu_read);

      `TB.switches <= 16'h0000;
      `CPU_READS(`WB_GPIO_R_IN, 4'hF, 32'h0000_0000, cpu_read);


      repeat (300) @(posedge `WB_CLK);
      `TEST_COMPLETE;
   end

endmodule // test_case
