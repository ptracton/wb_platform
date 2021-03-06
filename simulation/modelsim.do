#exec make TARGET=${1}  clean
#exec make TARGET=${1} 

vlib work


vlog ${1}.v +incdir+../testbench +incdir+../simulation  +incdir+../testbench -timescale 1ns/1ns

      vlog ../rtl/top.v +incdir+../simulation +incdir+../rtl/bus_matrix/ +incdir+../testbench
      vlog ../rtl/cpu/cpu_top.v
      vlog ../rtl/syscon/syscon.v +define+SIM
      vlog ../rtl/syscon/syscon_top.v  
      vlog ../rtl/syscon/syscon_regs.v  +incdir+../simulation 

      vlog ../rtl/wb_master_interface/arbiter.v
      vlog ../rtl/wb_master_interface/wb_master_interface.v +incdir+../behavioral/wb_common/
      vlog ../rtl/bus_matrix/bus_matrix.v +incdir+../behavioral/wb_common/
      vlog ../behavioral/wb_master/wb_mast_model.v
 
      vlog ../rtl/pc_interface/pc_interface.v
      vlog ../rtl/pc_interface/packet_decode.v
      vlog ../rtl/uart/uart.v

      vlog ../rtl/gpio/gpio_top.v +incdir+../testbench

      vlog ../behavioral/wb_ram/wb_ram.v +incdir+../behavioral/wb_common/
      vlog ../behavioral/wb_ram/wb_ram_generic.v


      vlog ../behavioral/wb_uart/raminfr.v
      vlog ../behavioral/wb_uart/uart_debug_if.v
      vlog ../behavioral/wb_uart/uart_receiver.v
      vlog ../behavioral/wb_uart/uart_regs.v
      vlog ../behavioral/wb_uart/uart_rfifo.v
      vlog ../behavioral/wb_uart/uart_sync_flops.v
      vlog ../behavioral/wb_uart/uart_tfifo.v
      vlog ../behavioral/wb_uart/uart_top.v
      vlog ../behavioral/wb_uart/uart_transmitter.v
      vlog ../behavioral/wb_uart/uart_wb.v

      vlog ../behavioral/wb_intercon/wb_arbiter.v  +incdir+../behavioral/
      vlog ../behavioral/wb_intercon/wb_data_resize.v
      vlog ../behavioral/wb_intercon/wb_mux.v  +incdir+../behavioral/

      vlog ../testbench/testbench.v +incdir+../simulation
      vlog ../testbench/test_tasks.v +incdir+../simulation
      vlog ../testbench/platform_tasks.v +incdir+../simulation  +incdir+../testbench
      vlog ../testbench/uart_tasks.v  +incdir+../simulation  +incdir+../testbench


vsim -voptargs=+acc work.testbench  +define+RTL +define+SIM 

do wave.do
run -all
