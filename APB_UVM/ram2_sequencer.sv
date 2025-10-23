package ram2_sequencer;
	import ram2_seq_item::*;
			import uvm_pkg::*;
`include "uvm_macros.svh";
class ram2_sequencer extends  uvm_sequencer #(ram2_seq_item);
	`uvm_component_utils(ram2_sequencer);
		function  new(string name="ram2_sequencer",uvm_component parent=null);
		super.new(name,parent);
	endfunction 
endclass : ram2_sequencer
endpackage : ram2_sequencer