set_property design_mode GateLvl [current_fileset]
set_property parent.project_path basys3.xpr [current_project]
open_checkpoint implementation/basys3_routed.dcp
write_bitstream -force bitgen/basys3.bit
#write_bmm -force bitgen/basys3.bmm
#write_hwdef -force -file bitgen/basys3.hwdef
#write_sysdef  -hwdef bitgen/basys3.hwdef -bitfile bitgen/basys3.bit -meminfo bitgen/basys3.mmi  
