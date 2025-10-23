package APB_config;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	class APB_config extends  uvm_object;
		`uvm_object_utils(APB_config);
		virtual APB_if APB_IF;
		uvm_active_passive_enum is_active;
		function  new(string name="APB_config");
			super.new(name);
		endfunction 
	endclass : APB_config
endpackage : APB_config