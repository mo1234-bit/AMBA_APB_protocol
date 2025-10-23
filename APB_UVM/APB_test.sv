package APB_test;
import uvm_pkg::*;
import APB_env::*;
import Master_env::*;
import Master_config::*;
import ram1_config::*;
import ram2_config::*;
import ram1_env::*;
import ram2_env::*;
import APB_config::*;
import APB_reset_sequence::*;
import APB_slave1_sequence::*;
import APB_slave2_sequence::*;
import APB_random_sequence::*;
`include "uvm_macros.svh";
class APB_test extends uvm_test;
`uvm_component_utils(APB_test)
APB_env env;
Master_env master_env;
ram1_env r1_env;
ram2_env r2_env;
ram1_config ram1_conf;
ram2_config ram2_conf;
APB_config conf;
Master_config master_conf;
APB_reset_sequence reset;
APB_slave1_sequence slave1_seq;
APB_slave2_sequence slave2_seq;
APB_random_sequence rand_seq;

function  new(string name="APB_test", uvm_component parent=null);
	super.new(name,parent);
endfunction 

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	env=APB_env::type_id::create("env",this);
	master_env=Master_env::type_id::create("master_env",this);
	r1_env=ram1_env::type_id::create("r1_env",this);
	r2_env=ram2_env::type_id::create("r2_env",this);
	conf=APB_config::type_id::create("conf");
	master_conf=Master_config::type_id::create("master_conf");
	ram1_conf=ram1_config::type_id::create("ram1_conf");
	ram2_conf=ram2_config::type_id::create("ram2_conf");
	reset=APB_reset_sequence::type_id::create("reset");
	slave1_seq=APB_slave1_sequence::type_id::create("slave1_seq");
	slave2_seq=APB_slave2_sequence::type_id::create("slave2_seq");
	rand_seq=APB_random_sequence::type_id::create("rand_seq");

	if(!uvm_config_db#(virtual APB_if)::get(this,"","apb_if",conf.APB_IF))
		`uvm_fatal("build_phase","unable to get APB interface in test")

	uvm_config_db#(APB_config)::set(this,"*","CFG",conf);

	if(!uvm_config_db#(virtual Master_if)::get(this,"","Master_if",master_conf.Master_IF))
		`uvm_fatal("build_phase","unable to get Master interface in test")

	uvm_config_db#(Master_config)::set(this,"*","CFG",master_conf);

	if(!uvm_config_db#(virtual ram1_if)::get(this,"","ram1_if",ram1_conf.ram1_if))begin
			`uvm_fatal("build_phase","unable to get ram1 interface in test")
		end
		uvm_config_db#(ram1_config)::set(this,"*","CFG",ram1_conf);

		if(!uvm_config_db#(virtual ram2_if)::get(this,"","ram2_if",ram2_conf.ram2_if))begin
			`uvm_fatal("build_phase","unable to get ram2 interface in test")
		end
		uvm_config_db#(ram2_config)::set(this,"*","CFG",ram2_conf);
ram1_conf.is_active=UVM_PASSIVE;
ram2_conf.is_active=UVM_PASSIVE;
master_conf.is_active=UVM_PASSIVE;
conf.is_active=UVM_ACTIVE;

endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
         phase.raise_objection(this);
		reset.start(env.agt.sqr);
		slave1_seq.start(env.agt.sqr);
		slave2_seq.start(env.agt.sqr);
		rand_seq.start(env.agt.sqr);

		phase.drop_objection(this);
endtask
endclass : APB_test
endpackage : APB_test