package APB_sequencer;
	import APB_seq_item::*;
			import uvm_pkg::*;
`include "uvm_macros.svh";
class APB_sequencer extends uvm_sequencer #(APB_seq_item);
	`uvm_component_utils(APB_sequencer)
	function  new(string name="APB_sequencer",uvm_component parent=null);
		super.new(name,parent);
	endfunction 
endclass : APB_sequencer
endpackage : APB_sequencer