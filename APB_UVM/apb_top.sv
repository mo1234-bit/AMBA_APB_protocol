import uvm_pkg::*;
`include "uvm_macros.svh";
import APB_test::*;
import ram1_test::*;
import ram2_test::*;
import Master_test::*;
module top12 ();
bit PCLK;
initial begin
	PCLK=0;
	forever #1 PCLK=~PCLK;
end
  APB_if  apbif(PCLK);
  Master_if Masterif(PCLK);
  ram1_if ram1if(PCLK);
  ram2_if ram2if(PCLK);

  APB APB_DUT(PCLK,apbif.PRESETn,apbif.transfer,apbif.READ_WRITE,apbif.apb_write_paddr,apbif.apb_write_data,
    apbif.apb_read_paddr,apbif.PSLVERR,apbif.apb_read_data_out);

APB_ref APB_DUT_ref(PCLK,apbif.PRESETn,apbif.transfer,apbif.READ_WRITE,apbif.apb_write_paddr,apbif.apb_write_data,
    apbif.apb_read_paddr,apbif.PSLVERR_ref,apbif.apb_read_data_out_ref);


 master_bridge master_dut(Masterif.apb_write_paddr, Masterif.apb_read_paddr,Masterif.apb_write_data, Masterif.PRDATA, 
  Masterif.PRESETn, PCLK, Masterif.READ_WRITE, Masterif.transfer,Masterif.PREADY,Masterif.PSEL1,Masterif.PSEL2,
  Masterif.PENABLE, Masterif.PADDR,Masterif.PWRITE,Masterif.PWDATA,Masterif.apb_read_data_out, Masterif.PSLVERR
     );


 master_bridge_ref master_ref_DUT(Masterif.apb_write_paddr,Masterif.apb_read_paddr,Masterif.apb_write_data,Masterif.PRDATA,Masterif.PRESETn,
    PCLK,Masterif.READ_WRITE,Masterif.transfer,Masterif.PREADY,Masterif.PSEL1_ref,
    Masterif.PSEL2_ref,Masterif.PENABLE_ref,Masterif.PADDR_ref,Masterif.PWRITE_ref,Masterif.PWDATA_ref,
    Masterif.apb_read_data_out_ref,Masterif.PSLVERR_ref );


 Slave1 slave1_dut(PCLK,ram1if.PRESETn,ram1if.PSEL,ram1if.PENABLE,ram1if.PWRITE,ram1if.PADDR,ram1if.PWDATA,ram1if.PRDATA1,ram1if.PREADY );


Slave1_ref slave1_ref_dut(PCLK,ram1if.PRESETn,ram1if.PSEL,ram1if.PENABLE,ram1if.PWRITE,ram1if.PADDR,ram1if.PWDATA,ram1if.PRDATA1_ref,ram1if.PREADY_ref );


bind Slave1 ram1_sva sva1(PCLK,ram1if.PRESETn,ram1if.PSEL,ram1if.PENABLE,ram1if.PWRITE,ram1if.PADDR,ram1if.PWDATA,ram1if.PRDATA1,ram1if.PREADY );


Slave2 slave2_dut(PCLK,ram2if.PRESETn,ram2if.PSEL,ram2if.PENABLE,ram2if.PWRITE,ram2if.PADDR,ram2if.PWDATA,ram2if.PRDATA2,ram2if.PREADY );


Slave2_ref slave2_ref_dut(PCLK,ram2if.PRESETn,ram2if.PSEL,ram2if.PENABLE,ram2if.PWRITE,ram2if.PADDR,ram2if.PWDATA,ram2if.PRDATA2_ref,ram2if.PREADY_ref );


bind Slave2 ram1_sva sva2(PCLK,ram2if.PRESETn,ram2if.PSEL,ram2if.PENABLE,ram2if.PWRITE,ram2if.PADDR,ram2if.PWDATA,ram2if.PRDATA2,ram2if.PREADY );


      
  initial begin
  	uvm_config_db#(virtual APB_if)::set(null,"uvm_test_top","apb_if",apbif);
    uvm_config_db#(virtual Master_if)::set(null,"uvm_test_top","Master_if",Masterif);
    uvm_config_db#(virtual ram1_if)::set(null,"uvm_test_top","ram1_if",ram1if);
    uvm_config_db#(virtual ram2_if)::set(null,"uvm_test_top","ram2_if",ram2if);
  	run_test("APB_test");
  end    

assign Masterif.PRESETn=apbif.PRESETn;
assign ram1if.PRESETn=apbif.PRESETn;
assign ram2if.PRESETn=apbif.PRESETn;
assign Masterif.apb_read_paddr=apbif.apb_read_paddr;
assign Masterif.apb_write_paddr=apbif.apb_write_paddr;
assign Masterif.apb_write_data=apbif.apb_write_data;
assign Masterif.PRDATA=APB_DUT.PRDATA;
assign Masterif.READ_WRITE=apbif.READ_WRITE;
assign Masterif.transfer=apbif.transfer;
assign Masterif.PREADY=APB_DUT.PREADY;
assign ram1if.PSEL=APB_DUT.PSEL1;
assign ram2if.PSEL=APB_DUT.PSEL2;
assign ram1if.PENABLE=APB_DUT.PENABLE;
assign ram2if.PENABLE=APB_DUT.PENABLE;
assign ram1if.PWRITE=APB_DUT.PWRITE;
assign ram2if.PWRITE=APB_DUT.PWRITE;
assign ram1if.PADDR=APB_DUT.PADDR[7:0];
assign ram2if.PADDR=APB_DUT.PADDR[7:0];
assign ram1if.PWDATA=APB_DUT.PWDATA;
assign ram2if.PWDATA=APB_DUT.PWDATA;


endmodule : top12  
