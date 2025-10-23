package Master_test;
import uvm_pkg::*;
import Master_env::*;
import Master_config::*;
import Master_reset_sequence::*;
import Master_main_sequence::*;
`include "uvm_macros.svh";
class Master_test extends uvm_test;
`uvm_component_utils(Master_test)
Master_env env;
Master_config conf;
Master_reset_sequence reset;
Master_main_sequence main;

function  new(string name="Master_test", uvm_component parent=null);
	super.new(name,parent);
endfunction 

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	env=Master_env::type_id::create("env",this);
	conf=Master_config::type_id::create("conf");
	reset=Master_reset_sequence::type_id::create("reset");
	main=Master_main_sequence::type_id::create("main");
	if(!uvm_config_db#(virtual Master_if)::get(this,"","Master_if",conf.Master_IF))
		`uvm_fatal("build_phase","unable to get interface in test")
	uvm_config_db#(Master_config)::set(this,"*","CFG",conf);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
         phase.raise_objection(this);
		reset.start(env.agt.sqr);
		main.start(env.agt.sqr);
		phase.drop_objection(this);
endtask
endclass : Master_test
endpackage : Master_test