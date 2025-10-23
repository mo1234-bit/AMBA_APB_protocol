package ram1_test;
	import ram1_env::*;
	import ram1_config::*;
	import ram1_reset_sequence::*;
	import ram1_write_sequence::*;
	import ram1_read_sequence::*;
	import ram1_write_read_sequence::*;
	import uvm_pkg::*;
`include "uvm_macros.svh";
class ram1_test extends  uvm_test;
	`uvm_component_utils(ram1_test);
	ram1_config conf;
	ram1_env env;
	ram1_reset_sequence reset_seq;
	ram1_write_sequence write_seq;
	ram1_read_sequence read_seq;
	ram1_write_read_sequence wr_rd_seq;
	function  new(string name="uvm_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		conf=ram1_config::type_id::create("conf");
		env=ram1_env::type_id::create("env",this);
		reset_seq=ram1_reset_sequence::type_id::create("reset_seq");
		write_seq=ram1_write_sequence::type_id::create("write_seq");
		read_seq=ram1_read_sequence::type_id::create("read_seq");
		wr_rd_seq=ram1_write_read_sequence::type_id::create("wr_rd_seq");
		if(!uvm_config_db#(virtual ram1_if)::get(this,"","ram1_if",conf.ram1_if))begin
			`uvm_fatal("build_phase","unable to get interface in test")
		end
		uvm_config_db#(ram1_config)::set(this,"*","CFG",conf);
	endfunction 
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		reset_seq.start(env.agt.sqr);
		write_seq.start(env.agt.sqr);
		read_seq.start(env.agt.sqr);
		wr_rd_seq.start(env.agt.sqr);
		phase.drop_objection(this);
	endtask : run_phase
endclass : ram1_test
endpackage : ram1_test