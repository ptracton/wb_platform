//
// Free Running 100 MHz clock with a 50/50 duty cycle
//
   reg clk;
   initial begin
      clk <= 1'b0;
      forever begin
         #178 clk <= ~clk;
      end
   end

   //
   // Reset button -- Just after the design starts, assert
   // reset to the device.
   //
   reg reset;
   initial begin
      reset <= 1'b0;
      #130 reset <= 1'b1;
      #350 reset <= 1'b0;
   end
