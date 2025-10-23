package ram1_reset_sequence;
	import ram1_seq_item::*;
		import uvm_pkg::*;
`include "uvm_macros.svh";
class ram1_reset_sequence extends  uvm_sequence #(ram1_seq_item);
	`uvm_object_utils(ram1_reset_sequence)
	ram1_seq_item seq_item;
	function  new(string name="ram1_reset_sequence");
		super.new(name);
	endfunction
	task body();
		seq_item=ram1_seq_item::type_id::create("seq_item");
		start_item(seq_item);
		seq_item.constraint_mode(0);
		seq_item.PRESETn =0;
		finish_item(seq_item);
	endtask : body
endclass : ram1_reset_sequence
endpackage : ram1_reset_sequence