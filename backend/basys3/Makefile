
SYNTH_DIR = synthesis
IMPL_DIR  = implementation
BIT_DIR   = bitgen

MAKE_DIRS = $(SYNTH_DIR) $(IMPL_DIR) $(BIT_DIR)

all: DIRS BIT_GEN

DIRS:
	@echo "Making Directories $(MAKE_DIRS)"
	@mkdir -p $(MAKE_DIRS)

SYNTHESIS: DIRS
	@echo "Synthesis"
	vivado -mode batch -source synthesis.tcl > $(SYNTH_DIR)/basys3_synthesis.log

IMPLEMENTATION: SYNTHESIS
	@echo "Implement Design"
	vivado -mode batch -source implementation.tcl > $(IMPL_DIR)/basys3_implementation.log

BIT_GEN:IMPLEMENTATION
	@echo "Generating Bit File"
	vivado -mode batch -source bitgen.tcl > $(BIT_DIR)/basys3_bitgen.log

PROGRAM:
	@echo "Programming FPGA"
	vivado -mode batch -source program.tcl > $(BIT_DIR)/basys3_program.log

TEST:
	@echo "TESTING"
	vivado -mode batch -source test.tcl > test.log

clean:
	rm -rf *jou *log *.os *.dcp *~ .Xil *.pb *.rpt *html *xml test.log
	rm -rf $(MAKE_DIRS) basys3.cache basys3.hw basys3.xpr basys3.ip_user_files
	rm -rf ip/clk_wiz_0/doc/ ip/clk_wiz_0/mmcm_pll_drp_func_* ip/clk_wiz_0/*.v ip/clk_wiz_0/*vhdl ip/clk_wiz_0/*xdc ip/clk_wiz_0/*veo ip/clk_wiz_0/*dcp ip/clk_wiz_0/*xml
	rm -rf .cache/
	find . -name "*~" | xargs rm -rf
