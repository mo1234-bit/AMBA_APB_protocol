import uvm_pkg::*;
`include "uvm_macros.svh";
import ram1_test::*;
module top ();
bit PCLK;
initial begin
	forever
	#1 PCLK=~PCLK;
end

ram1_if ram1if(PCLK);

Slave1 dut(PCLK,ram1if.PRESETn,ram1if.PSEL,ram1if.PENABLE,ram1if.PWRITE,ram1if.PADDR,ram1if.PWDATA,ram1if.PRDATA1,ram1if.PREADY );
Slave1_ref dut1(PCLK,ram1if.PRESETn,ram1if.PSEL,ram1if.PENABLE,ram1if.PWRITE,ram1if.PADDR,ram1if.PWDATA,ram1if.PRDATA1_ref,ram1if.PREADY_ref );
bind Slave1 ram1_sva sva(PCLK,ram1if.PRESETn,ram1if.PSEL,ram1if.PENABLE,ram1if.PWRITE,ram1if.PADDR,ram1if.PWDATA,ram1if.PRDATA1,ram1if.PREADY );
initial begin
	uvm_config_db#(virtual ram1_if)::set(null,"uvm_test_top","ram1_if",ram1if);
	run_test("ram1_test");
end

endmodule : top
