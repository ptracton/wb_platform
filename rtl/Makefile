
TOPTARGETS := clean sim xrun modelsim synthesis lint


SUBDIRS = fifo fifo_to_sram wb_master_interface wb_daq_channel wb_daq_data_aggregation


$(TOPTARGETS): $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: $(TOPTARGETS) $(SUBDIRS)
