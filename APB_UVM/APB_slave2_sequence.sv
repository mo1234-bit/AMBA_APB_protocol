package APB_slave2_sequence;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	import APB_seq_item::*;
	class APB_slave2_sequence extends  uvm_sequence #(APB_seq_item);
		`uvm_object_utils(APB_slave2_sequence)
	     APB_seq_item seq_item;
	     function  new(string name="APB_slave2_sequence");
	     	super.new(name);
	     endfunction 

	     task body();
	     	repeat(10000)begin
	     	seq_item=APB_seq_item::type_id::create("seq_item");
	     	start_item(seq_item);
	     	seq_item.addr_type=3'b001;
	     	seq_item.PRESETn=1'b1;
		   assert(seq_item.randomize());
		   finish_item(seq_item);
            end
	     endtask 

	endclass : APB_slave2_sequence
endpackage : APB_slave2_sequence