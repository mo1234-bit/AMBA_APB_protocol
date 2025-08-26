package ram_driver;
	import ram_seq_item::*;
			import uvm_pkg::*;
`include "uvm_macros.svh";
class ram_driver extends  uvm_driver #(ram_seq_item);
	`uvm_component_utils(ram_driver);
	ram_seq_item seq_item;
	virtual ram_if ram_if;
	function  new(string name="ram_driver",uvm_component parent=null);
		super.new(name,parent);
	endfunction 

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			seq_item=ram_seq_item::type_id::create("seq_item");
			seq_item_port.get_next_item(seq_item);
			ram_if.din=seq_item.din;
			ram_if.PRSTn=seq_item.PRSTn;
			ram_if.PENABLE=seq_item.PENABLE;
			ram_if.PWRITE=seq_item.PWRITE;
			ram_if.PSEL=seq_item.PSEL;
			ram_if.PADDR=seq_item.PADDR;
			ram_if.PWDATA=seq_item.PWDATA;
			@(negedge ram_if.PCLK);
			seq_item_port.item_done();
		end
	endtask : run_phase
endclass : ram_driver
endpackage : ram_driver