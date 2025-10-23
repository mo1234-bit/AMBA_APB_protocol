package Master_config;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	class Master_config extends  uvm_object;
		`uvm_object_utils(Master_config);
		virtual Master_if Master_IF;
		uvm_active_passive_enum is_active;
		function  new(string name="Master_config");
			super.new(name);
		endfunction 
	endclass : Master_config
endpackage : Master_config