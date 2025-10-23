import uvm_pkg::*;
`include "uvm_macros.svh";
import Master_test::*;
module top3 ();
bit PCLK;
initial begin
	PCLK=0;
	forever #1 PCLK=~PCLK;
end
  
  Master_if Masterif(PCLK);

  master_bridge dut(
    Masterif.apb_write_paddr,
    Masterif.apb_read_paddr,
    Masterif.apb_write_data,
    Masterif.PRDATA,
    Masterif.PRESETn,
    PCLK,
    Masterif.READ_WRITE,
    Masterif.transfer,
    Masterif.PREADY,
    Masterif.PSEL1,
    Masterif.PSEL2,
    Masterif.PENABLE,
    Masterif.PADDR,
    Masterif.PWRITE,
    Masterif.PWDATA,
    Masterif.apb_read_data_out,
    Masterif.PSLVERR
     );

  master_bridge_ref DUT1(Masterif.apb_write_paddr,Masterif.apb_read_paddr,Masterif.apb_write_data,Masterif.PRDATA,Masterif.PRESETn,
    PCLK,Masterif.READ_WRITE,Masterif.transfer,Masterif.PREADY,Masterif.PSEL1_ref,
    Masterif.PSEL2_ref,Masterif.PENABLE_ref,Masterif.PADDR_ref,Masterif.PWRITE_ref,Masterif.PWDATA_ref,
    Masterif.apb_read_data_out_ref,Masterif.PSLVERR_ref );

  
      
  initial begin
  	uvm_config_db#(virtual Master_if)::set(null,"uvm_test_top","Master_if",Masterif);
  	run_test("Master_test");
  end    

endmodule : top3   
