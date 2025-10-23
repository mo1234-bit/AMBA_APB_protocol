package Master_sequencer;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	import Master_seq_item::*;
	class Master_sequencer extends  uvm_sequencer#(Master_seq_item);
		`uvm_component_utils(Master_sequencer)
		function  new(string name="Master_sequencer",uvm_component parent=null);
			super.new(name,parent);
		endfunction 
	endclass : Master_sequencer
endpackage : Master_sequencer