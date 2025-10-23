package Master_main_sequence;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	import Master_seq_item::*;
	class Master_main_sequence extends  uvm_sequence #(Master_seq_item);
		`uvm_object_utils(Master_main_sequence)
	     Master_seq_item seq_item;
	     function  new(string name="Master_main_sequence");
	     	super.new(name);
	     endfunction 

	     task body();
	     	repeat(10000)begin
	     	seq_item=Master_seq_item::type_id::create("seq_item");
	     	start_item(seq_item);
		   assert(seq_item.randomize());
		   finish_item(seq_item);
            end
	     endtask 

	endclass : Master_main_sequence
endpackage : Master_main_sequence