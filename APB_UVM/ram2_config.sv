package ram2_config;
	import uvm_pkg::*;
`include "uvm_macros.svh";
class ram2_config extends uvm_object;
	`uvm_object_utils(ram2_config)
	virtual ram2_if ram2_if;
	uvm_active_passive_enum is_active;
	function  new(string name="ram2_config");
		super.new(name);
	endfunction 
endclass : ram2_config
endpackage : ram2_config