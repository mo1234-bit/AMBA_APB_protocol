package ram1_driver;
	import ram1_seq_item::*;
			import uvm_pkg::*;
`include "uvm_macros.svh";
class ram1_driver extends  uvm_driver #(ram1_seq_item);
	`uvm_component_utils(ram1_driver);
	ram1_seq_item seq_item;
	virtual ram1_if ram1_if;
	function  new(string name="ram1_driver",uvm_component parent=null);
		super.new(name,parent);
	endfunction 

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			seq_item=ram1_seq_item::type_id::create("seq_item");
			seq_item_port.get_next_item(seq_item);
			ram1_if.PRESETn =seq_item.PRESETn ;
			ram1_if.PENABLE=seq_item.PENABLE;
			ram1_if.PWRITE=seq_item.PWRITE;
			ram1_if.PSEL=seq_item.PSEL;
			ram1_if.PADDR=seq_item.PADDR;
			ram1_if.PWDATA=seq_item.PWDATA;
			@(negedge ram1_if.PCLK);
			seq_item_port.item_done();
		end
	endtask : run_phase
endclass : ram1_driver
endpackage : ram1_driver
