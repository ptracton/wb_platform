`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/01/2015 10:44:30 PM
// Design Name: 
// Module Name: display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module display (/*AUTOARG*/
   // Outputs
   anode, cathode,
   // Inputs
   clk, reset, segment0, segment1, segment2, segment3
   ) ;
   input clk;
   input reset;
   
   input [3:0]  segment0;
   input [3:0]  segment1;
   input [3:0]  segment2;
   input [3:0]  segment3;

   output [3:0] anode;
   output [7:0] cathode;
   
   //
   // Registers
   //
   reg [3:0]    anode   = 4'hF;
   reg [7:0]    cathode = 8'h00;

   //
   // Timer
   //
   // Assert timer_expired every milisecond.  This is when we switch
   // the ANODE and CATHODE values.
   //
   wire timer_expired;
   
   timer ms_timer(
                  // Outputs
                  .timer_interrupt(timer_expired), 
                  .timer_count_running(),
                  // Inputs
                  .clk(clk), 
                  .reset(reset), 
//                  .timer_count(32'd100_000), //For 100MHz
                  .timer_count(32'd10000), //For 5.6MHz
                  .timer_enable(1'b1), 
                  .timer_interrupt_clear(timer_expired)                  
                  );
   
   
   //
   // Translation Function
   //
   // Take in 4 bit input and map to 8 bit output for use by
   // cathode for 7 segment display
   //
   function [7:0] map_segments;
      input [3:0] data_in;
      begin
         case (data_in)
           //                   8'bpGFEDCBA
           4'h0: map_segments = 8'b11000000;
           4'h1: map_segments = 8'b11111001;
           4'h2: map_segments = 8'b10100100;
           4'h3: map_segments = 8'b10110000;
           4'h4: map_segments = 8'b10011001;
           4'h5: map_segments = 8'b10010010;           
           4'h6: map_segments = 8'b10000010;
           4'h7: map_segments = 8'b11111000;
           4'h8: map_segments = 8'b10000000;
           4'h9: map_segments = 8'b10011000;
           default map_segments = 8'b10000000;           
         endcase // case (data_in)
      end      
   endfunction // case   
   
   //
   // State Machine
   //
   reg [1:0] state      = 2'b00;
   reg [1:0] next_state = 2'b00;

   //
   // Synchronous state change
   //
   always @(posedge clk)
     if (reset)
       state <= 2'b00;
     else
       state <= next_state;

   //
   // Asynchronous actions
   //
   always @(*) begin
      case (state)
        2'b00 : begin
           anode = 4'b1110;
           cathode = map_segments(segment0);  
           next_state = (timer_expired) ? 2'b01: 2'b00;           
        end
        2'b01 : begin
           anode = 4'b1101;
           cathode = map_segments(segment1);
           next_state = (timer_expired) ? 2'b10: 2'b01;           
        end
        2'b10 : begin
           anode = 4'b1011;
           cathode = map_segments(segment2);
           next_state = (timer_expired) ? 2'b11: 2'b10;           
        end
        2'b11 : begin
           anode = 4'b0111;
           cathode = map_segments(segment3);
           next_state = (timer_expired) ? 2'b00: 2'b11;           
        end
      endcase // case (state)      
   end
     
   
endmodule // display
