package ram2_driver;
	import ram2_seq_item::*;
			import uvm_pkg::*;
`include "uvm_macros.svh";
class ram2_driver extends  uvm_driver #(ram2_seq_item);
	`uvm_component_utils(ram2_driver);
	ram2_seq_item seq_item;
	virtual ram2_if ram2_if;
	function  new(string name="ram2_driver",uvm_component parent=null);
		super.new(name,parent);
	endfunction 

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			seq_item=ram2_seq_item::type_id::create("seq_item");
			seq_item_port.get_next_item(seq_item);
			ram2_if.PRESETn =seq_item.PRESETn ;
			ram2_if.PENABLE=seq_item.PENABLE;
			ram2_if.PWRITE=seq_item.PWRITE;
			ram2_if.PSEL=seq_item.PSEL;
			ram2_if.PADDR=seq_item.PADDR;
			ram2_if.PWDATA=seq_item.PWDATA;
			@(negedge ram2_if.PCLK);
			seq_item_port.item_done();
		end
	endtask : run_phase
endclass : ram2_driver
endpackage : ram2_driver
