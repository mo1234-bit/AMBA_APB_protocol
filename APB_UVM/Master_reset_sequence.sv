package Master_reset_sequence;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	import Master_seq_item::*;
	class Master_reset_sequence extends  uvm_sequence #(Master_seq_item);
		`uvm_object_utils(Master_reset_sequence)
	     Master_seq_item seq_item;
	     function  new(string name="Master_reset_sequence");
	     	super.new(name);
	     endfunction 

	     task body();
	     	seq_item=Master_seq_item::type_id::create("seq_item");
	     	start_item(seq_item);
		    seq_item.constraint_mode(0);
		    seq_item.PRESETn =0;
		   finish_item(seq_item);

	     endtask 

	endclass : Master_reset_sequence
endpackage : Master_reset_sequence