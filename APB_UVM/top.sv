import APB_test::*;
import ram_test::*;
import uvm_pkg::*;
`include "uvm_macros.svh";
module top1 ();
bit PCLK;
initial begin
	forever 
	#2 PCLK=~PCLK;
end 

APB_if APBif(PCLK);
ram_if ramif(PCLK);
APB dut(PCLK,APBif.PRESETn,APBif.transfer,APBif.READ_WRITE,APBif.apb_write_paddr,APBif.apb_write_data,APBif.apb_read_paddr,APBif.PSLVERR,APBif.apb_read_data_out);
APB dut1(PCLK,APBif.PRESETn,APBif.transfer,APBif.READ_WRITE,APBif.apb_write_paddr,APBif.apb_write_data,APBif.apb_read_paddr,APBif.PSLVERR_ref,APBif.apb_read_data_out_ref);
initial begin
	uvm_config_db#(virtual APB_if)::set(null,"uvm_test_top","APB_if",APBif);
	uvm_config_db#(virtual ram_if)::set(null,"uvm_test_top","ram_if",ramif);
	run_test("APB_test");
end

assign ramif.PRSTn=APBif.PRSTn;
assign ramif.PENABLE=dut.PENABLE;
assign ramif.PWRITE=dut.PWRITE;
assign ramif.PSEL=dut.PSEL;
assign ramif.PADDR=dut.PADDR;
assign ramif.PWDATA=dut.PWDATA;


endmodule 