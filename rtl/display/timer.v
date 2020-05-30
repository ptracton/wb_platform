`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2015 05:46:30 PM
// Design Name: 
// Module Name: timer
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


module timer(/*AUTOARG*/
   // Outputs
   timer_interrupt, timer_count_running,
   // Inputs
   clk, reset, timer_count, timer_enable, timer_interrupt_clear
   );
   
   input        clk;
   input        reset;
   input [31:0] timer_count;
   input        timer_enable;
   input        timer_interrupt_clear;
   
   output       timer_interrupt;
   output [31:0] timer_count_running;

   /*AUTOWIRE*/
   /*AUTOREG*/
   // Beginning of automatic regs (for this module's undeclared outputs)
   reg [31:0]           timer_count_running;
   reg                  timer_interrupt;
   // End of automatics
   

   //
   // timer_count_done goes high if we have a running count that is greater
   // or equal to the specified count and we are enabled.
   //
   wire         timer_count_done = timer_enable & (timer_count_running >= (timer_count-1));

   //
   // On every clock edge, if we are done, reset the counter, because we have reached
   // the specified count.
   // If we are not done, but we are enabled, we are counting and witing until we are done
   //
   always @(posedge clk) 
      if (reset) begin
         timer_count_running <= 16'b0;      
      end else if (timer_count_done) begin
         timer_count_running <= 16'b0;      
      end else if (timer_enable) begin
         timer_count_running <= timer_count_running +1;
      end else begin
         timer_count_running <= 16'b0;      
      end
   
   //
   // If the system indicated clear the interrupt, clear it.
   // else if we are enabled and the timer_count is done, assert the interrupt.
   // else if neither, keep the interrupt low since it is not time yet.
   //
   always @(posedge clk)
     if (reset) begin
        timer_interrupt <= 1'b0;        
     end else if (timer_interrupt_clear) begin
        timer_interrupt <= 1'b0;           
     end else if (timer_enable) begin
        timer_interrupt <= timer_count_done;           
     end else begin
        timer_interrupt <= 1'b0;
     end                         
   
endmodule
