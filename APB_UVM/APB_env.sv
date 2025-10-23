package APB_env;
	import APB_agent::*;
	import APB_scoreboard::*;
	import APB_coverage::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	class APB_env extends  uvm_env;
	`uvm_component_utils(APB_env)
	APB_agent agt;
	APB_scoreboard sb;
	APB_coverage covr;
	function new(string name="APB_env",uvm_component parent=null);
		super.new(name,parent);
        endfunction : new
        function void build_phase(uvm_phase phase);
        	super.build_phase(phase);
        	agt=APB_agent::type_id::create("agt",this);
        	sb=APB_scoreboard::type_id::create("sb",this);
        	covr=APB_coverage::type_id::create("cov",this);        	
        endfunction 

        function void connect_phase(uvm_phase phase);
        	super.connect_phase(phase);
        	agt.agt_ap.connect(sb.sb_export);
        	agt.agt_ap.connect(covr.covr_export);
        endfunction : connect_phase
	endclass : APB_env
endpackage : APB_env