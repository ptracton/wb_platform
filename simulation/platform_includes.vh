//                              -*- Mode: Verilog -*-
// Filename        : wb_dsp_includes.vh
// Description     : Include file for WB DSP Testing
// Author          : Philip Tracton
// Created On      : Wed Dec  2 13:38:15 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec  2 13:38:15 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!


`define TB          testbench
`define WB_RST      `TB.wb_rst
`define WB_CLK      `TB.wb_clk
`define DUT         `TB.dut
`define SYSCON      `DUT.syscon
`define PLATFORM_TASKS   `TB.platform_tasks

`define UART_MASTER0      `TB.uart_master0
`define UART_MASTER1      `TB.uart_master1
`define UART_CLK          `TB.clk_tb
`define UART_CONFIG       `TB.uart_tasks.uart_config
`define UART_WRITE_BYTE   `TB.uart_tasks.uart_write_byte
`define UART_READ_BYTE    `TB.uart_tasks.uart_read_byte
`define UART_WRITE_WORD   `TB.uart_tasks.uart_write_word
`define UART_READ_WORD   `TB.uart_tasks.uart_read_word


`define CPU_READS   `PLATFORM_TASKS.CPU_READ
`define CPU_WRITES  `PLATFORM_TASKS.CPU_WRITE
`define CPU_WRITE_FILE_CONFIG `PLATFORM_TASKS.CPU_WRITE_FILE_CONFIG

`define CPU_START   `TB.cpu_start
`define CPU_ADDR    `TB.cpu_address
`define CPU_SEL     `TB.cpu_selection
`define CPU_WRITE   `TB.cpu_write
`define CPU_DATA_WR `TB.cpu_data_wr
`define CPU_DATA_RD `TB.cpu_data_rd
`define CPU_ACTIVE  `TB.cpu_actives

`define RAM0        `TB.ram0
`define RAM00       `RAM.ram0
`define MEMORY0     `RAM0.mem


`define RAM1        `TB.ram1
`define RAM10       `RAM.ram0
`define MEMORY1     `RAM0.mem


`define RAM2        `TB.ram2
`define RAM20       `RAM.ram0
`define MEMORY2     `RAM0.mem


`define RAM3        `TB.ram3
`define RAM30       `RAM.ram0
`define MEMORY3     `RAM0.mem

`define TEST_CASE       `TB.test_case
`define SIMULATION_NAME `TEST_CASE.simulation_name
`define NUMBER_OF_TESTS `TEST_CASE.number_of_tests

`define WB_RAM0 32'h9000_0000
`define WB_RAM1 32'h9000_2000
`define WB_RAM2 32'h9000_4000
`define WB_RAM3 32'h9000_6000

`define WB_GPIO 32'h4000_0000
`define WB_GPIO_R_IN    `WB_GPIO + 32'h0    // Read inputs
`define WB_GPIO_R_OUT   `WB_GPIO + 32'h4    // Write outptus
`define WB_GPIO_R_OE    `WB_GPIO + 32'h8    // Output Enable
`define WB_GPIO_R_INTE  `WB_GPIO + 32'hC    // Interrupt Enable
`define WB_GPIO_R_PTRIG `WB_GPIO + 32'h10   // Trigger
`define WB_GPIO_R_AUX   `WB_GPIO + 32'h14   // Aux inputs
`define WB_GPIO_R_CTRL  `WB_GPIO + 32'h18   // Control
`define WB_GPIO_F_CTRL_INTE 0
`define WB_GPIO_B_CTRL_INTE (1 << `WB_GPIO_F_CTRL_INTE)
`define WB_GPIO_F_CTRL_INTS 1
`define WB_GPIO_B_CTRL_INTS (1 << `WB_GPIO_F_CTRL_INTS)
`define WB_GPIO_R_INTS  `WB_GPIO + 32'h1C   // Interrupt Status
`define WB_GPIO_R_ECLK  `WB_GPIO + 32'h20   // Enable GPIO E-Clk
`define WB_GPIO_R_NEC   `WB_GPIO + 32'h24   // Select active edge of e-clk

`define WB_SYSCON_BASE_ADDRESS 32'h4000_1000
`define WB_SYSCON_R_IDENTIFICATION_OFFSET 0
`define WB_SYSCON_R_IDENTIFICATION `WB_SYSCON_BASE_ADDRESS + `WB_SYSCON_R_IDENTIFICATION_OFFSET  //Identificaton
`define F_IDENTIFICATION_PLATFORM  07:00
`define B_IDENTIFICATION_FPGA      8'h01

`define F_IDENTIFICATION_RESERVED  15:08

`define F_IDENTIFICATION_MINOR_REV 23:16
`define B_IDENTIFICATION_MINOR_REV 8'h01

`define F_IDENTIFICATION_MAJOR_REV 31:24
`define B_IDENTIFICATION_MAJOR_REV 8'h00

`define WB_SYSCON_R_STATUS_OFFSET 4
`define WB_SYSCON_R_STATUS `WB_SYSCON_BASE_ADDRESS + `WB_SYSCON_R_STATUS_OFFSET  //System Status
`define F_STATUS_LOCKED  0
`define F_STATUS_UNUSED  31:1

`define WB_SYSCON_R_CONTROL_OFFSET 8
`define WB_SYSCON_R_CONTROL `WB_SYSCON_BASE_ADDRESS + `WB_SYSCON_R_CONTROL_OFFSET  //System Control
`define F_CONTROL_LEDS   1:0
`define B_CONTROL_LEDS_GPIO 2'b00
`define B_CONTROL_LEDS_PC   2'b01
`define B_CONTROL_LEDS_DSP  2'b10
`define B_CONTROL_LEDS_TBD  2'b11



// general defines
`define mS *1000000
`define nS *1
`define uS *1000
`define Wait #
`define wait #
`define khz *1000

// Taken from http://asciitable.com/
//
`define LINE_FEED       8'h0A
`define CARRIAGE_RETURN 8'h0D
`define SPACE_CHAR      8'h20
`define NUMBER_0        8'h30
`define NUMBER_9        8'h39
`define LETTER_A        8'h41
`define LETTER_Z        8'h5A
`define LETTER_a        8'h61
`define LETTER_f        8'h66
`define LETTER_z        8'h7a

`define PKT_PREAMBLE    8'hCA
`define PKT_COMMAND_CPU_WRITE 4'h1
`define PKT_COMMAND_CPU_READ  4'h2
`define PKT_COMMAND_DAQ_WRITE 4'h3
`define PKT_COMMAND_DAQ_READ  4'h4


`define TEST_TASKS  `TB.test_tasks
`define TEST_PASSED `TEST_TASKS.test_passed
`define TEST_FAILED `TEST_TASKS.test_failed
`define test_failed       `TB.test_failed
`define TEST_COMPARE  `TEST_TASKS.compare_values
`define TEST_RANGE  `TEST_TASKS.compare_range
`define TEST_COMPLETE `TEST_TASKS.all_tests_completed
