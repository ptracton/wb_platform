//                              -*- Mode: Verilog -*-
// Filename        : syscon.v
// Description     : System Clock and Reset Controller
// Author          : Philip Tracton
// Created On      : Fri Nov 27 13:42:16 2015
// Last Modified By: Philip Tracton
// Last Modified On: Fri Nov 27 13:42:16 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ns/1ns
module syscon (/*AUTOARG*/
   // Outputs
   wb_clk_o, wb_rst_o, locked, clk_10MHZ,
   // Inputs
   clk_pad_i, rst_pad_i
   ) ;
   input clk_pad_i;
   input rst_pad_i;
   output wb_clk_o;
   output wb_rst_o;
   output clk_10MHZ;

   output wire   locked;


   //
   // Reset generation for wishbone
   //
   // This will keep reset asserted until we get 16 clocks
   // of the PLL/Clock Tile being locked
   //
   reg [31:0] wb_rst_shr;

   always @(posedge wb_clk_o or posedge rst_pad_i)
	 if (rst_pad_i)
	   wb_rst_shr <= 32'hffff_ffff;
	 else
	   wb_rst_shr <= {wb_rst_shr[30:0], ~(locked)};

   assign wb_rst_o = wb_rst_shr[31] | ~locked | rst_pad_i;

`ifdef SIM
   reg        wb_clk;

   assign wb_clk_o = wb_clk;
   assign locked = 1'b1;


   initial begin
      wb_clk <= 0;
      forever begin
         #(178/2) wb_clk <= ~wb_clk;
      end
   end

`else
   wire   clk_10MHZ;

   reg foo;
      initial begin
      foo <= 1;
      forever begin
         #(178/2) foo <= ~foo;
      end
   end
   
   // Put technology specific clocking here, things like Xilinx DCM, etc...
   clk_wiz_0 clk_wiz(
                     .wb_clk(wb_clk_o),
                     .clk_100ns(clk_10MHZ),
                     .reset(rst_pad_i),
                     .locked(locked),
                     .clk_in1(clk_pad_i)
                     );
`endif


endmodule // syscon
