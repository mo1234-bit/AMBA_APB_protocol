package Master_env;
	import Master_agent::*;
	import Master_scoreboard::*;
	import Master_coverage::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	class Master_env extends  uvm_env;
	`uvm_component_utils(Master_env)
	Master_agent agt;
	Master_scoreboard sb;
	Master_coverage covr;
	function new(string name="Master_env",uvm_component parent=null);
		super.new(name,parent);
        endfunction : new
        function void build_phase(uvm_phase phase);
        	super.build_phase(phase);
        	agt=Master_agent::type_id::create("agt",this);
        	sb=Master_scoreboard::type_id::create("sb",this);
        	covr=Master_coverage::type_id::create("cov",this);        	
        endfunction 

        function void connect_phase(uvm_phase phase);
        	super.connect_phase(phase);
        	agt.agt_ap.connect(sb.sb_export);
        	agt.agt_ap.connect(covr.covr_export);
        endfunction : connect_phase
	endclass : Master_env
endpackage : Master_env