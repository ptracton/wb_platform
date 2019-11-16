
create_project -force basys3  -part xc7a35tcpg236-3

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property verilog_dir {
    ../../testbench
    ../../simulation
    ../../behavioral/wb_common
    ../../behavioral/wb_intercon
    ../../behavioral/verilog_utils
    ../../behavioral/
    ../../rtl/gpio
    ../../rtl/bus_matrix/
} [current_fileset]
read_verilog -library xil_defaultlib {
    basys.v
    ../../rtl/top.v
    ../../rtl/cpu/cpu_top.v
    ../../rtl/syscon/syscon_top.v
    ../../rtl/syscon/syscon_regs.v
    ../../rtl/syscon/syscon.v

    ../../rtl/wb_master_interface/arbiter.v
    ../../rtl/wb_master_interface/wb_master_interface.v
    ../../rtl/bus_matrix/bus_matrix.v

    ../../rtl/pc_interface/pc_interface.v
    ../../rtl/pc_interface/packet_decode.v
    ../../rtl/uart/uart.v

    ../../rtl/gpio/gpio_top.v

    ../../behavioral/wb_ram/wb_ram.v
    ../../behavioral/wb_ram/wb_ram_generic.v

    ../../behavioral/wb_master/wb_mast_model.v

    ../../behavioral/wb_intercon/wb_arbiter.v
    ../../behavioral/wb_intercon/wb_data_resize.v
    ../../behavioral/wb_intercon/wb_mux.v

    ../../behavioral/wb_uart/raminfr.v
    ../../behavioral/wb_uart/uart_debug_if.v
    ../../behavioral/wb_uart/uart_receiver.v
    ../../behavioral/wb_uart/uart_regs.v
    ../../behavioral/wb_uart/uart_rfifo.v
    ../../behavioral/wb_uart/uart_sync_flops.v
    ../../behavioral/wb_uart/uart_tfifo.v
    ../../behavioral/wb_uart/uart_top.v
    ../../behavioral/wb_uart/uart_transmitter.v
    ../../behavioral/wb_uart/uart_wb.v
}

read_ip ./ip/clk_wiz_0/clk_wiz_0.xci
upgrade_ip [get_ips *]
generate_target -force {All} [get_ips *]
synth_ip [get_ips *]

read_xdc basys3.xdc
set_property used_in_implementation false [get_files basys3.xdc]

synth_design -top top -part xc7a35tcpg236-3
write_checkpoint -noxdef -force synthesis/basys3.dcp
catch { report_utilization -file synthesis/basys3_utilization_synth.rpt -pb synthesis/basys3_utilization_synth.pb }

open_checkpoint synthesis/basys3.dcp
write_verilog -mode funcsim -sdf_anno true synthesis/top_funcsim.v
write_sdf synthesis/top_funcsim.sdf
