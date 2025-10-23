package ram2_read_sequence;
	import ram2_seq_item::*;
		import uvm_pkg::*;
`include "uvm_macros.svh";
class ram2_read_sequence extends  uvm_sequence #(ram2_seq_item);
	`uvm_object_utils(ram2_read_sequence)
	ram2_seq_item seq_item;
	function  new(string name="ram2_read_sequence");
		super.new(name);
	endfunction 
	task body();
		repeat(10000)begin
			seq_item=ram2_seq_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.wr.constraint_mode(0);
			seq_item.wr_rd.constraint_mode(0);
			assert(seq_item.randomize());
			finish_item(seq_item);
		end
	endtask : body
endclass : ram2_read_sequence
endpackage : ram2_read_sequence