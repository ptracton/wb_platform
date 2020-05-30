     +incdir+../testbench
      +incdir+../behavioral/
      +incdir+../behavioral/wb_common/
      +incdir+../rtl/bus_matrix/
      +incdir+../behavioral/wb_master/
      +incdir+../behavioral/wb_uart
      +incdir+../rtl/gpio
      +define+VERBOSE
      +define+SIM
      +define+RTL
      
      ../rtl/top.v
      ../rtl/cpu/cpu_top.v
      ../rtl/syscon/syscon.v
      ../rtl/syscon/syscon_regs.v
      ../rtl/syscon/syscon_top.v
      ../rtl/daq/daq_slave.v
      ../rtl/daq/daq_top.v
      ../rtl/daq/daq_sm.v
      ../rtl/dsp/dsp_slave.v
      ../rtl/dsp/dsp_top.v
      ../rtl/dsp/dsp_sm.v
      ../rtl/dsp/dsp_equations_top.v
      ../rtl/dsp/dsp_equation_sum.v
      ../rtl/dsp/dsp_equation_multiply.v
      ../rtl/dsp/dsp_equation_dtree.v
      ../rtl/dsp/priority_encoder.v

      ../rtl/display/display.v
      ../rtl/display/timer.v
      
      ../rtl/wb_master_interface/arbiter.v
      ../rtl/wb_master_interface/wb_master_interface.v
      ../rtl/bus_matrix/bus_matrix.v

      ../rtl/pc_interface/pc_interface.v
      ../rtl/pc_interface/packet_decode.v
      ../rtl/uart/uart.v

      ../rtl/gpio/gpio_top.v

      ../behavioral/wb_ram/wb_ram.v
      ../behavioral/wb_ram/wb_ram_generic.v

      ../behavioral/wb_master/wb_mast_model.v

      ../behavioral/wb_intercon/wb_arbiter.v
      ../behavioral/wb_intercon/wb_data_resize.v
      ../behavioral/wb_intercon/wb_mux.v

      ../behavioral/wb_uart/raminfr.v
      ../behavioral/wb_uart/uart_debug_if.v
      ../behavioral/wb_uart/uart_receiver.v
      ../behavioral/wb_uart/uart_regs.v
      ../behavioral/wb_uart/uart_rfifo.v
      ../behavioral/wb_uart/uart_sync_flops.v
      ../behavioral/wb_uart/uart_tfifo.v
      ../behavioral/wb_uart/uart_top.v
      ../behavioral/wb_uart/uart_transmitter.v
      ../behavioral/wb_uart/uart_wb.v

      //      ../behavioral/wb_common/wb_common.v
      //      ../behavioral/wb_common/wb_common_params.v

      ../testbench/testbench.v
      ../testbench/test_tasks.v
      ../testbench/dsp_tasks.v
      ../testbench/uart_tasks.v
      ../testbench/dump.v
      ../testbench/data_file_manager.v
      ../testbench/data_file_monitor.v
      ../testbench/daq_injector.v
