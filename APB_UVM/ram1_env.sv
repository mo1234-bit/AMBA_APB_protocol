package ram1_env;
	import ram1_agent::*;
	import ram1_scoreboard::*;
	import ram1_coverage::*;
	import uvm_pkg::*;
`include "uvm_macros.svh";
class ram1_env extends  uvm_env;
	`uvm_component_utils(ram1_env);
    ram1_agent agt;
    ram1_scoreboard sb;
    ram1_coverage covr;
    function  new(string name="ram1_env",uvm_component parent=null);
    	super.new(name,parent);
    endfunction 
    function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	agt=ram1_agent::type_id::create("agt",this);
    	sb=ram1_scoreboard::type_id::create("sb",this);
    	covr=ram1_coverage::type_id::create("covr",this);
    endfunction 

    function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
    	agt.agt_ap.connect(sb.sb_export);
    	agt.agt_ap.connect(covr.covr_export);
    endfunction 
endclass : ram1_env
endpackage : ram1_env