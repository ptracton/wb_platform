onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TESTBENCH /testbench/clk
add wave -noupdate -expand -group TESTBENCH /testbench/rx
add wave -noupdate -expand -group TESTBENCH /testbench/tx
add wave -noupdate -group {TEST CASE} /testbench/test_case/data_out
add wave -noupdate -group {TEST CASE} /testbench/test_case/cpu_read
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/clk
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/rst
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/rx_byte
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/received
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/recv_error
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/is_transmitting
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/leds
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/cpu_address
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/cpu_start
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/cpu_selection
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/cpu_write
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/cpu_data_wr
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/transmit
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/tx_byte
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/cpu_data_rd
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/cpu_active
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/state
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/size
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/command
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/length
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/start_address
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/byte_count
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/samples_transferred
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/decode_cpu_command
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/decode_read_command
add wave -noupdate -group {PACKET DECODE} -radix hexadecimal /testbench/dut/interface/decode/decode_write_command
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/wb_clk
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/wb_rst
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/wb_adr_o
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/wb_dat_o
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/wb_sel_o
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/wb_we_o
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/wb_cyc_o
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/wb_stb_o
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/wb_cti_o
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/wb_bte_o
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/wb_dat_i
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/wb_ack_i
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/wb_err_i
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/wb_rty_i
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/start
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/address
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/selection
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/write
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/data_wr
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/data_rd
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/active
add wave -noupdate -group CPU -radix hexadecimal /testbench/dut/cpu/master/state
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/wb_clk_i
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/wb_rst_i
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/wb_adr_i
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/wb_dat_i
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/wb_sel_i
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/wb_we_i
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/wb_bte_i
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/wb_cti_i
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/wb_cyc_i
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/wb_stb_i
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/wb_ack_o
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/wb_err_o
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/wb_dat_o
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/adr_r
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/next_adr
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/valid
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/valid_r
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/is_last_r
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/new_cycle
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/adr
add wave -noupdate -group {RAM 3} -radix hexadecimal /testbench/dut/ram3/ram_we
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/clk
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/rst
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/rx
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/tx
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/transmit
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/tx_byte
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/received
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/rx_byte
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/is_receiving
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/is_transmitting
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/recv_error
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/rx_clk_divider
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/tx_clk_divider
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/recv_state
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/rx_countdown
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/rx_bits_remaining
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/rx_data
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/tx_out
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/tx_state
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/tx_countdown
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/tx_bits_remaining
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/dut/interface/uart0/tx_data
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/wb_clk_i
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/wb_rst_i
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/wb_adr_i
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/wb_dat_i
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/wb_dat_o
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/wb_we_i
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/wb_stb_i
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/wb_cyc_i
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/wb_sel_i
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/wb_ack_o
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/int_o
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/srx_pad_i
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/stx_pad_o
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/rts_pad_o
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/cts_pad_i
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/dtr_pad_o
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/dsr_pad_i
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/ri_pad_i
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/dcd_pad_i
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/baud_o
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/wb_dat8_i
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/wb_dat8_o
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/wb_dat32_o
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/wb_adr_int
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/we_o
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/re_o
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/ier
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/iir
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/fcr
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/mcr
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/lcr
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/msr
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/lsr
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/rf_count
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/tf_count
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/tstate
add wave -noupdate -expand -group {TB UART} -radix hexadecimal /testbench/uart0/rstate
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4252865000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 355
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {3707153997 ps} {4810983757 ps}
