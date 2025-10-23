import uvm_pkg::*;
`include "uvm_macros.svh";
import ram2_test::*;
module top1 ();
bit PCLK;
initial begin
	forever
	#1 PCLK=~PCLK;
end

ram2_if ram2if(PCLK);

Slave2 dut(PCLK,ram2if.PRESETn,ram2if.PSEL,ram2if.PENABLE,ram2if.PWRITE,ram2if.PADDR,ram2if.PWDATA,ram2if.PRDATA2,ram2if.PREADY );
Slave2_ref dut1(PCLK,ram2if.PRESETn,ram2if.PSEL,ram2if.PENABLE,ram2if.PWRITE,ram2if.PADDR,ram2if.PWDATA,ram2if.PRDATA2_ref,ram2if.PREADY_ref );
 bind Slave2 ram2_sva sva(PCLK,ram2if.PRESETn,ram2if.PSEL,ram2if.PENABLE,ram2if.PWRITE,ram2if.PADDR,ram2if.PWDATA,ram2if.PRDATA2,ram2if.PREADY );
initial begin
	uvm_config_db#(virtual ram2_if)::set(null,"uvm_test_top","ram2_if",ram2if);
	run_test("ram2_test");
end

endmodule : top1
