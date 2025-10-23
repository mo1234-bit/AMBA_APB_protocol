package APB_random_sequence;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	import APB_seq_item::*;
	class APB_random_sequence extends  uvm_sequence #(APB_seq_item);
		`uvm_object_utils(APB_random_sequence)
	     APB_seq_item seq_item;
	     function  new(string name="APB_random_sequence");
	     	super.new(name);
	     endfunction 

	     task body();
	     	repeat(10000)begin
	     	seq_item=APB_seq_item::type_id::create("seq_item");
	     	start_item(seq_item);
	     	seq_item.addr_type=3'b111;
	     	seq_item.PRESETn=1'b1;
		   assert(seq_item.randomize());
		   finish_item(seq_item);
            end
	     endtask 

	endclass : APB_random_sequence
endpackage : APB_random_sequence