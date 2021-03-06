// THIS FILE IS AUTOGENERATED BY wb_intercon_gen
// ANY MANUAL CHANGES WILL BE LOST
module wb_intercon
   (input         wb_clk_i,
    input         wb_rst_i,
    input  [31:0] wb_cpu_master_adr_i,
    input  [31:0] wb_cpu_master_dat_i,
    input   [3:0] wb_cpu_master_sel_i,
    input         wb_cpu_master_we_i,
    input         wb_cpu_master_cyc_i,
    input         wb_cpu_master_stb_i,
    input   [2:0] wb_cpu_master_cti_i,
    input   [1:0] wb_cpu_master_bte_i,
    output [31:0] wb_cpu_master_dat_o,
    output        wb_cpu_master_ack_o,
    output        wb_cpu_master_err_o,
    output        wb_cpu_master_rty_o,
    output [31:0] wb_gpio_adr_o,
    output [31:0] wb_gpio_dat_o,
    output  [3:0] wb_gpio_sel_o,
    output        wb_gpio_we_o,
    output        wb_gpio_cyc_o,
    output        wb_gpio_stb_o,
    output  [2:0] wb_gpio_cti_o,
    output  [1:0] wb_gpio_bte_o,
    input  [31:0] wb_gpio_dat_i,
    input         wb_gpio_ack_i,
    input         wb_gpio_err_i,
    input         wb_gpio_rty_i,
    output [31:0] wb_syscon_adr_o,
    output [31:0] wb_syscon_dat_o,
    output  [3:0] wb_syscon_sel_o,
    output        wb_syscon_we_o,
    output        wb_syscon_cyc_o,
    output        wb_syscon_stb_o,
    output  [2:0] wb_syscon_cti_o,
    output  [1:0] wb_syscon_bte_o,
    input  [31:0] wb_syscon_dat_i,
    input         wb_syscon_ack_i,
    input         wb_syscon_err_i,
    input         wb_syscon_rty_i,
    output [31:0] wb_ram0_adr_o,
    output [31:0] wb_ram0_dat_o,
    output  [3:0] wb_ram0_sel_o,
    output        wb_ram0_we_o,
    output        wb_ram0_cyc_o,
    output        wb_ram0_stb_o,
    output  [2:0] wb_ram0_cti_o,
    output  [1:0] wb_ram0_bte_o,
    input  [31:0] wb_ram0_dat_i,
    input         wb_ram0_ack_i,
    input         wb_ram0_err_i,
    input         wb_ram0_rty_i,
    output [31:0] wb_ram1_adr_o,
    output [31:0] wb_ram1_dat_o,
    output  [3:0] wb_ram1_sel_o,
    output        wb_ram1_we_o,
    output        wb_ram1_cyc_o,
    output        wb_ram1_stb_o,
    output  [2:0] wb_ram1_cti_o,
    output  [1:0] wb_ram1_bte_o,
    input  [31:0] wb_ram1_dat_i,
    input         wb_ram1_ack_i,
    input         wb_ram1_err_i,
    input         wb_ram1_rty_i,
    output [31:0] wb_ram2_adr_o,
    output [31:0] wb_ram2_dat_o,
    output  [3:0] wb_ram2_sel_o,
    output        wb_ram2_we_o,
    output        wb_ram2_cyc_o,
    output        wb_ram2_stb_o,
    output  [2:0] wb_ram2_cti_o,
    output  [1:0] wb_ram2_bte_o,
    input  [31:0] wb_ram2_dat_i,
    input         wb_ram2_ack_i,
    input         wb_ram2_err_i,
    input         wb_ram2_rty_i,
    output [31:0] wb_ram3_adr_o,
    output [31:0] wb_ram3_dat_o,
    output  [3:0] wb_ram3_sel_o,
    output        wb_ram3_we_o,
    output        wb_ram3_cyc_o,
    output        wb_ram3_stb_o,
    output  [2:0] wb_ram3_cti_o,
    output  [1:0] wb_ram3_bte_o,
    input  [31:0] wb_ram3_dat_i,
    input         wb_ram3_ack_i,
    input         wb_ram3_err_i,
    input         wb_ram3_rty_i);

wb_mux
  #(.num_slaves (6),
    .MATCH_ADDR ({32'h90000000, 32'h90002000, 32'h90004000, 32'h90006000, 32'h40000000, 32'h40001000}),
    .MATCH_MASK ({32'hffffe000, 32'hffffe000, 32'hffffe000, 32'hffffe000, 32'hffffffd8, 32'hffffffe0}))
 wb_mux_cpu_master
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i (wb_cpu_master_adr_i),
    .wbm_dat_i (wb_cpu_master_dat_i),
    .wbm_sel_i (wb_cpu_master_sel_i),
    .wbm_we_i  (wb_cpu_master_we_i),
    .wbm_cyc_i (wb_cpu_master_cyc_i),
    .wbm_stb_i (wb_cpu_master_stb_i),
    .wbm_cti_i (wb_cpu_master_cti_i),
    .wbm_bte_i (wb_cpu_master_bte_i),
    .wbm_dat_o (wb_cpu_master_dat_o),
    .wbm_ack_o (wb_cpu_master_ack_o),
    .wbm_err_o (wb_cpu_master_err_o),
    .wbm_rty_o (wb_cpu_master_rty_o),
    .wbs_adr_o ({wb_ram0_adr_o, wb_ram1_adr_o, wb_ram2_adr_o, wb_ram3_adr_o, wb_gpio_adr_o, wb_syscon_adr_o}),
    .wbs_dat_o ({wb_ram0_dat_o, wb_ram1_dat_o, wb_ram2_dat_o, wb_ram3_dat_o, wb_gpio_dat_o, wb_syscon_dat_o}),
    .wbs_sel_o ({wb_ram0_sel_o, wb_ram1_sel_o, wb_ram2_sel_o, wb_ram3_sel_o, wb_gpio_sel_o, wb_syscon_sel_o}),
    .wbs_we_o  ({wb_ram0_we_o, wb_ram1_we_o, wb_ram2_we_o, wb_ram3_we_o, wb_gpio_we_o, wb_syscon_we_o}),
    .wbs_cyc_o ({wb_ram0_cyc_o, wb_ram1_cyc_o, wb_ram2_cyc_o, wb_ram3_cyc_o, wb_gpio_cyc_o, wb_syscon_cyc_o}),
    .wbs_stb_o ({wb_ram0_stb_o, wb_ram1_stb_o, wb_ram2_stb_o, wb_ram3_stb_o, wb_gpio_stb_o, wb_syscon_stb_o}),
    .wbs_cti_o ({wb_ram0_cti_o, wb_ram1_cti_o, wb_ram2_cti_o, wb_ram3_cti_o, wb_gpio_cti_o, wb_syscon_cti_o}),
    .wbs_bte_o ({wb_ram0_bte_o, wb_ram1_bte_o, wb_ram2_bte_o, wb_ram3_bte_o, wb_gpio_bte_o, wb_syscon_bte_o}),
    .wbs_dat_i ({wb_ram0_dat_i, wb_ram1_dat_i, wb_ram2_dat_i, wb_ram3_dat_i, wb_gpio_dat_i, wb_syscon_dat_i}),
    .wbs_ack_i ({wb_ram0_ack_i, wb_ram1_ack_i, wb_ram2_ack_i, wb_ram3_ack_i, wb_gpio_ack_i, wb_syscon_ack_i}),
    .wbs_err_i ({wb_ram0_err_i, wb_ram1_err_i, wb_ram2_err_i, wb_ram3_err_i, wb_gpio_err_i, wb_syscon_err_i}),
    .wbs_rty_i ({wb_ram0_rty_i, wb_ram1_rty_i, wb_ram2_rty_i, wb_ram3_rty_i, wb_gpio_rty_i, wb_syscon_rty_i}));

endmodule
