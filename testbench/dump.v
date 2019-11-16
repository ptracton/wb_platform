


module dump;

   reg [(64*8)-1:0] test_name;

   initial
     begin
        test_name = `SIMULATION_NAME;

`ifdef NCVERILOG
        $display("DUMP: %s.shm", test_name);

        $shm_open({test_name,".shm"}, 0);
	    $shm_probe(testbench, "MAC");
`else
 `ifndef VIVADO
        $display("DUMP: %s.vcd", test_name);
        $dumpfile({test_name,".vcd"});
	    $dumpvars(0, testbench);
 `endif
`endif

     end // initial begin


endmodule // test_top
