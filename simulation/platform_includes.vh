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
`define CLK_1MS     `TB.clk_1ms
`define DUT         `TB.dut
`define SYSCON      `DUT.syscon0
`define DSP         `DUT.dsp
`define DAQ         `DUT.daq
`define DSP_TASKS   `TB.dsp_tasks
`define DSP_EQUATIONS `DSP.equations
`define DSP_EQUATION_DTREE  `DSP_EQUATIONS.dtree
//testbench.dut.dsp.equations.dtree.dtree_output[31:0]

`define RUN_DTREE `DSP_TASKS.RUN_DTREE

`define DAQ_READS   `DSP_TASKS.DAQ_READ
`define DAQ_WRITES  `DSP_TASKS.DAQ_WRITE
`define DAQ_WRITES_FILE `DSP_TASKS.DAQ_WRITES_FILE
`define DAQ_WRITES_BUSY `DSP_TASKS.daq_writes_busy

`define DO_SUM `DSP_TASKS.DO_SUM
`define CPU_READS   `DSP_TASKS.CPU_READ
`define CPU_WRITES  `DSP_TASKS.CPU_WRITE
`define CPU_WRITE_FILE_CONFIG `DSP_TASKS.CPU_WRITE_FILE_CONFIG

`define DAQ_START   `TB.daq_start
`define DAQ_ADDR    `TB.daq_address
`define DAQ_SEL     `TB.daq_selection
`define DAQ_WRITE   `TB.daq_write
`define DAQ_DATA_WR `TB.daq_data_wr
`define DAQ_DATA_RD `TB.daq_data_rd
`define DAQ_ACTIVE  `TB.daq_active

`define CPU_START   `TB.cpu_start
`define CPU_ADDR    `TB.cpu_address
`define CPU_SEL     `TB.cpu_selection
`define CPU_WRITE   `TB.cpu_write
`define CPU_DATA_WR `TB.cpu_data_wr
`define CPU_DATA_RD `TB.cpu_data_rd
`define CPU_ACTIVE  `TB.cpu_active

`define FILE_NUM     `TB.file_num
`define FILE_WRITE   `TB.file_write
`define FILE_READ   `TB.file_read
`define FILE_WRITE_DATA   `TB.file_write_data
`define FILE_READ_DATA   `TB.file_read_data
`define FILE_ACTIVE   `TB.file_active

`define RAM0        `DUT.ram0
`define RAM00       `RAM0.ram0
`define MEMORY0     `RAM00.mem


`define RAM1        `DUT.ram1
`define RAM10       `RAM1.ram0
`define MEMORY1     `RAM10.mem


`define RAM2        `DUT.ram2
`define RAM20       `RAM2.ram0
`define MEMORY2     `RAM20.mem


`define RAM3        `DUT.ram3
`define RAM30       `RAM3.ram0
`define MEMORY3     `RAM30.mem

`define TEST_CASE       `TB.test_case
`define SIMULATION_NAME `TEST_CASE.simulation_name
//`define RAM_IMAGE       `TEST_CASE.ram_image
`define NUMBER_OF_TESTS `TEST_CASE.number_of_tests

`define WB_RAM0 32'h2000_0000
`define WB_RAM1 32'h2000_2000
`define WB_RAM2 32'h2000_4000
`define WB_RAM3 32'h2000_6000

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

/*******************************************************************************
 Linked List Data Structure
 
 typedef struct {
 uint32_t configuration;
 NODE_TypeDef * next;
 } NODE_TypeDef;
 
 Feed the address of the first node to input2 register when starting the Decision
 tree so the hardware knows where to start pulling in the linked list
 
 ******************************************************************************/
`define F_LL_SPLIT_FILE      07:00
`define F_LL_OUTPUT_FILE     23:16
`define F_LL_FORCE_RD_PTR    31

/*******************************************************************************

 FILE Data Structure

 typedef struct{
 uint32_t start_address;   // offset 00
 uint32_t end_address;     // offset 04
 uint32_t rd_ptr;          // offset 08
 uint32_t wr_ptr;          // offset 0c
 uint32_t status;          // offset 10
     #define EMPTY   0x00000001
     #define FULL    0x00000002
     #define WRAP    0x00000004
     #define ERROR   0x00000008
 uint32_t control;         // offset 14
     #define DATA_SIZE   00/11=32 bits, 01 is 8 bits, 10 is 16 bits

 uint32_t reserved0        // offset 18
 uint32_t reserved1        // offset 1C
 } FILE_TypeDef

This is a 32*8 = 256 bit structure

 ******************************************************************************/

`define FILE_START_ADDRESS_OFFSET 32'h0000_0000
`define FILE_END_ADDRESS_OFFSET   32'h0000_0004
`define FILE_RD_PTR_OFFSET        32'h0000_0008
`define FILE_WR_PTR_OFFSET        32'h0000_000C
`define FILE_STATUS_OFFSET        32'h0000_0010
`define FILE_CONTROL_OFFSET       32'h0000_0014
`define FILE_RESERVED0_OFFSET     32'h0000_0018
`define FILE_RESERVED1_OFFSET     32'h0000_001C

`define F_STATUS_WRAP_AROUND      0
`define F_STATUS_FULL             1
`define F_STATUS_EMPTY            2
`define F_STATUS_WRAP             3
`define F_STATUS_ERROR            4

`define F_CONTROL_DATA_SIZE           1:0
`define B_CONTROL_DATA_SIZE_WORD      2'b00
`define B_CONTROL_DATA_SIZE_HWORD     2'b01
`define B_CONTROL_DATA_SIZE_BYTE      2'b10
`define B_CONTROL_DATA_SIZE_UNDEFINED 2'b11


`define WB_DSP_SLAVE_BASE_ADDRESS       32'h7000_0000

`define WB_DSP_SLAVE_INPUT0_OFFSET      8'h00
`define F_DSP_SLAVE_EQUATION_NUMBER     7:0
`define B_DSP_EQUATION_NONE             8'h01
`define B_DSP_EQUATION_SUM              8'h01
`define B_DSP_EQUATION_MULTIPLY         8'h02
`define B_DSP_EQUATION_DTREE            8'h03

`define F_DSP_SLAVE_DATA_SIZE           9:8
`define F_DSP_SLAVE_DATA_SIGNED         10
`define F_DSP_SLAVE_ENABLE_MAC          11
`define F_DSP_SLAVE_SCALAR_MULTIPLY     12
`define F_DSP_SLAVE_EQUATION_START      31

`define F_DSP_DTREE_OUTPUT              07:00
`define F_DSP_DTREE_SENSOR_NODE         15:08
`define F_DSP_DTREE_LEAF                31

`define WB_DSP_SLAVE_INPUT1_OFFSET      8'h04
`define F_DSP_SLAVE_INPUT_FILE0         07:00
`define F_DSP_SLAVE_INPUT_FILE1         15:08
`define F_DSP_SLAVE_INPUT_FILE2         23:16
`define F_DSP_SLAVE_INPUT_FILE3         31:24

`define WB_DSP_SLAVE_INPUT2_OFFSET      8'h08
`define F_DSP_SLAVE_INPUT_FILE4         07:00
`define F_DSP_SLAVE_INPUT_FILE5         15:08
`define F_DSP_SLAVE_INPUT_FILE6         23:16
`define F_DSP_SLAVE_INPUT_FILE7         31:24

`define WB_DSP_SLAVE_INPUT3_OFFSET      8'h0C
`define F_DSP_SLAVE_OUTPUT_FILE0        07:00
`define F_DSP_SLAVE_OUTPUT_FILE1        15:08
`define F_DSP_SLAVE_OUTPUT_FILE2        23:16
`define F_DSP_SLAVE_OUTPUT_FILE3        31:24


`define WB_DSP_SLAVE_INPUT4_OFFSET      8'h10
`define F_DSP_SLAVE_INPUT2_FILE4        07:00
`define F_DSP_SLAVE_INPUT2_FILE5        15:08
`define F_DSP_SLAVE_INPUT2_FILE6        23:16
`define F_DSP_SLAVE_INPUT2_FILE7        31:24

`define WB_DSP_SLAVE_OUTPUT0_OFFSET     8'h14
`define WB_DSP_SLAVE_OUTPUT1_OFFSET     8'h18
`define WB_DSP_SLAVE_OUTPUT2_OFFSET     8'h1C
`define WB_DSP_SLAVE_OUTPUT3_OFFSET     8'h20
`define WB_DSP_SLAVE_OUTPUT4_OFFSET     8'h24

`define WB_DSP_SLAVE_STATUS             8'h28  //READ ONLY
`define F_DSP_SLAVE_STATUS_DONE         0


`define WB_DSP_SLAVE_WRITE_ADDR0        8'h30
`define WB_DSP_SLAVE_WRITE_DATA0        8'h34
`define WB_DSP_SLAVE_WRITE_ADDR1        8'h38
`define WB_DSP_SLAVE_WRITE_DATA1        8'h3C
`define WB_DSP_SLAVE_WRITE_ADDR2        8'h40
`define WB_DSP_SLAVE_WRITE_DATA2        8'h44
`define WB_DSP_SLAVE_WRITE_ADDR3        8'h48
`define WB_DSP_SLAVE_WRITE_DATA3        8'h4C
`define WB_DSP_SLAVE_WRITE_ADDR4        8'h50
`define WB_DSP_SLAVE_WRITE_DATA4        8'h54
`define WB_DSP_SLAVE_WRITE_ADDR5        8'h58
`define WB_DSP_SLAVE_WRITE_DATA5        8'h5C
`define WB_DSP_SLAVE_WRITE_ADDR6        8'h60
`define WB_DSP_SLAVE_WRITE_DATA6        8'h64
`define WB_DSP_SLAVE_WRITE_ADDR7        8'h68
`define WB_DSP_SLAVE_WRITE_DATA7        8'h6C
`define WB_DSP_SLAVE_WRITE_ADDR8        8'h70
`define WB_DSP_SLAVE_WRITE_DATA8        8'h74
`define WB_DSP_SLAVE_WRITE_ADDR9        8'h78
`define WB_DSP_SLAVE_WRITE_DATA9        8'h7C
`define WB_DSP_SLAVE_WRITE_ADDRA        8'h80
`define WB_DSP_SLAVE_WRITE_DATAA        8'h84



`define DSP_EQUATIONS_MAX     4

`define WB_DAQ_SLAVE_BASE_ADDRESS       32'h8000_0000

`define test_failed       `TB.test_failed
`define UART_MASTER0      `TB.uart_master0
`define UART_MASTER1      `TB.uart_master1
`define UART_CLK          `TB.clk_tb
`define UART_CONFIG       `TB.uart_tasks.uart_config
`define UART_WRITE_BYTE   `TB.uart_tasks.uart_write_byte
`define UART_READ_BYTE    `TB.uart_tasks.uart_read_byte
`define UART_WRITE_WORD   `TB.uart_tasks.uart_write_word
`define UART_READ_WORD    `TB.uart_tasks.uart_read_word
`define UART_BUSY         `TB.uart_tasks.uart_busy
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
`define TEST_COMPARE  `TEST_TASKS.compare_values
`define TEST_RANGE  `TEST_TASKS.compare_range
`define TEST_COMPLETE `TEST_TASKS.all_tests_completed
