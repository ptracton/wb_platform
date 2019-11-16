//                              -*- Mode: Verilog -*-
// Filename        : pc_interface.v
// Description     : PC Interface
// Author          : Philip Tracton
// Created On      : Thu May 16 16:51:00 2019
// Last Modified By: Philip Tracton
// Last Modified On: Thu May 16 16:51:00 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

module pc_interface (/*AUTOARG*/
   // Outputs
   tx, leds, cpu_address, cpu_start, cpu_selection, cpu_write,
   cpu_data_wr,
   // Inputs
   wb_clk, wb_rst, rx, cpu_data_rd, cpu_active
   ) ;

   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;

   input wb_clk;
   input wb_rst;
   input rx;
   output tx;
   output wire [15:0] leds;

   output [aw-1:0] cpu_address;
   output          cpu_start;
   output [3:0]    cpu_selection;
   output          cpu_write;
   output [dw-1:0] cpu_data_wr;


   input [dw-1:0] cpu_data_rd;
   input          cpu_active;

   //
   // UART Instance
   //

   wire       transmit;
   wire [7:0] tx_byte;
   wire       received;
   wire [7:0] rx_byte;
   wire       is_receiving;
   wire       is_transmitting;
   wire       recv_error;


   uart #(.CLOCK_DIVIDE(12))
   uart0(
	     .clk(wb_clk), // The master clock for this module
	     .rst(wb_rst), // Synchronous reset.
	     .rx(rx), // Incoming serial line
	     .tx(tx), // Outgoing serial line
	     .transmit(transmit), // Signal to transmit
	     .tx_byte(tx_byte), // Byte to transmit
	     .received(received), // Indicated that a byte has been received.
	     .rx_byte(rx_byte), // Byte received
	     .is_receiving(is_receiving), // Low when receive line is idle.
	     .is_transmitting(is_transmitting), // Low when transmit line is idle.
	     .recv_error(recv_error) // Indicates error in receiving packet.
         );


   packet_decode decode(
                        // Inputs
                        .clk(wb_clk),
                        .rst(wb_rst),
                        .leds(leds),

                        // UART
                        .rx_byte(rx_byte),
                        .received(received),
                        .recv_error(recv_error),
                        .is_transmitting(is_transmitting),
                        .tx_byte(tx_byte), // Byte to transmit
                        .transmit(transmit), // Signal to transmit

                        // CPU Bus Interface
                        .cpu_data_rd(cpu_data_rd),
                        .cpu_active(cpu_active),
                        .cpu_start(cpu_start),
                        .cpu_address(cpu_address),
                        .cpu_selection(cpu_selection),
                        .cpu_write(cpu_write),
                        .cpu_data_wr(cpu_data_wr)
                        ) ;


endmodule // pc_interface
