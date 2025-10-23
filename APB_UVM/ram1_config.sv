package ram1_config;
	import uvm_pkg::*;
`include "uvm_macros.svh";
class ram1_config extends uvm_object;
	`uvm_object_utils(ram1_config)
	virtual ram1_if ram1_if;
	uvm_active_passive_enum is_active;
	function  new(string name="ram1_config");
		super.new(name);
	endfunction 
endclass : ram1_config
endpackage : ram1_config