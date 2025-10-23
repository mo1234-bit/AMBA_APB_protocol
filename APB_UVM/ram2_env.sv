package ram2_env;
	import ram2_agent::*;
	import ram2_scoreboard::*;
	import ram2_coverage::*;
	import uvm_pkg::*;
`include "uvm_macros.svh";
class ram2_env extends  uvm_env;
	`uvm_component_utils(ram2_env);
    ram2_agent agt;
    ram2_scoreboard sb;
    ram2_coverage covr;
    function  new(string name="ram2_env",uvm_component parent=null);
    	super.new(name,parent);
    endfunction 
    function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	agt=ram2_agent::type_id::create("agt",this);
    	sb=ram2_scoreboard::type_id::create("sb",this);
    	covr=ram2_coverage::type_id::create("covr",this);
    endfunction 

    function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
    	agt.agt_ap.connect(sb.sb_export);
    	agt.agt_ap.connect(covr.covr_export);
    endfunction 
endclass : ram2_env
endpackage : ram2_env