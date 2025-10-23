package ram2_reset_sequence;
	import ram2_seq_item::*;
		import uvm_pkg::*;
`include "uvm_macros.svh";
class ram2_reset_sequence extends  uvm_sequence #(ram2_seq_item);
	`uvm_object_utils(ram2_reset_sequence)
	ram2_seq_item seq_item;
	function  new(string name="ram2_reset_sequence");
		super.new(name);
	endfunction
	task body();
		seq_item=ram2_seq_item::type_id::create("seq_item");
		start_item(seq_item);
		seq_item.constraint_mode(0);
		seq_item.PRESETn =0;
		finish_item(seq_item);
	endtask : body
endclass : ram2_reset_sequence
endpackage : ram2_reset_sequence