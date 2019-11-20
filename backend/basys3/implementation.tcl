set_property design_mode GateLvl [current_fileset]
set_property parent.project_path basys3.xpr [current_project]
add_files -quiet synthesis/basys3.dcp
read_xdc basys3.xdc
link_design -top basys3 -part xc7a35tcpg236-3

opt_design 
write_checkpoint -force implementation/basys3_opt.dcp
catch {report_drc -file implementation/basys3_drc_opted.rpt}

place_design 
write_checkpoint -force implementation/basys3_placed.dcp
catch { report_io -file implementation/basys3_io_placed.rpt }
catch { report_utilization -file implementation/basys3_utilization_placed.rpt -pb implementation/basys3_utilization_placed.pb }
catch { report_control_sets -verbose -file implementation/basys3_control_sets_placed.rpt }

route_design 
write_checkpoint -force implementation/basys3_routed.dcp
catch { report_drc -file implementation/basys3_drc_routed.rpt -pb implementation/basys3_drc_routed.pb }
catch { report_timing_summary -warn_on_violation -max_paths 10 -file implementation/basys3_timing_summary_routed.rpt -rpx implementation/basys3_timing_summary_routed.rpx }
catch { report_power -file implementation/basys3_power_routed.rpt -pb implementation/basys3_power_summary_routed.pb }
catch { report_route_status -file implementation/basys3_route_status.rpt -pb implementation/basys3_route_status.pb }
catch { report_clock_utilization -file implementation/basys3_clock_utilization_routed.rpt }

open_checkpoint implementation/basys3_routed.dcp
write_verilog -force -mode timesim -sdf_anno true implementation/top_timesim.v
write_sdf -force implementation/top_timesim.sdf
