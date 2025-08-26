package APB_main_sequence;
		import APB_seq_item::*;
			import uvm_pkg::*;
`include "uvm_macros.svh";
class APB_main_sequence extends uvm_sequence #(APB_seq_item);
	`uvm_object_utils(APB_main_sequence)
	APB_seq_item seq_item;
	function  new(string name="APB_main_sequence");
		super.new(name);
	endfunction 

	task body();
		repeat(10000)begin
			seq_item=APB_seq_item::type_id::create("seq_item");
			start_item(seq_item);
			assert(seq_item.randomize());
			finish_item(seq_item);
		end
	endtask : body
endclass : APB_main_sequence
endpackage : APB_main_sequence