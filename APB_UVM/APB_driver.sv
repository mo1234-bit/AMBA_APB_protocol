package APB_driver;
	import APB_seq_item::*;
		import uvm_pkg::*;
`include "uvm_macros.svh";
class APB_driver extends  uvm_driver #(APB_seq_item);
	`uvm_component_utils(APB_driver)
	APB_seq_item seq_item;
	virtual APB_if APB_if;
	function  new(string name ="APB_driver",uvm_component parent=null);
		super.new(name,parent);
	endfunction 

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			seq_item=APB_seq_item::type_id::create("seq_item");
			seq_item_port.get_next_item(seq_item);
			 
             APB_if.PRESETn=seq_item.PRESETn;
             APB_if.transfer=seq_item.transfer;
             APB_if.READ_WRITE=seq_item.READ_WRITE;
             APB_if.apb_write_paddr=seq_item.apb_write_paddr;
              APB_if.apb_write_data=seq_item.apb_write_data;
             APB_if.apb_read_paddr=seq_item.apb_read_paddr;
              @(negedge APB_if.PCLK);
             seq_item_port.item_done();
		end
	endtask : run_phase
endclass : APB_driver
endpackage : APB_driver