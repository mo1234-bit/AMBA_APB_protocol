package Master_driver;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	import Master_seq_item::*;
	class Master_driver extends  uvm_driver #(Master_seq_item);
		`uvm_component_utils(Master_driver)
		Master_seq_item seq_item;
		virtual Master_if Master_IF;
		function  new(string name="Master_driver",uvm_component parent=null);
			super.new(name,parent);
		endfunction 
		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				seq_item=Master_seq_item::type_id::create("seq_item",this);
				seq_item_port.get_next_item(seq_item);
				Master_IF.apb_write_paddr=seq_item.apb_write_paddr;
                Master_IF.apb_read_paddr=seq_item.apb_read_paddr;
                Master_IF.PRDATA=seq_item.PRDATA;
                Master_IF.apb_write_data=seq_item.apb_write_data;
                Master_IF.PRESETn=seq_item.PRESETn;
                Master_IF.READ_WRITE=seq_item.READ_WRITE;
                Master_IF.transfer=seq_item.transfer;
                Master_IF.PREADY=seq_item.PREADY;
                @(negedge Master_IF.PCLK);
                seq_item_port.item_done();
			end
		endtask : run_phase
	endclass : Master_driver
endpackage : Master_driver