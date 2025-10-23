package ram1_sequencer;
	import ram1_seq_item::*;
			import uvm_pkg::*;
`include "uvm_macros.svh";
class ram1_sequencer extends  uvm_sequencer #(ram1_seq_item);
	`uvm_component_utils(ram1_sequencer);
		function  new(string name="ram1_sequencer",uvm_component parent=null);
		super.new(name,parent);
	endfunction 
endclass : ram1_sequencer
endpackage : ram1_sequencer