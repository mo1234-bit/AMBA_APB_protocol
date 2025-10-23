package ram1_agent;
	import ram1_sequencer::*;
	import ram1_driver::*;
	import ram1_config::*;
	import ram1_monitor::*;
	import ram1_seq_item::*;
			import uvm_pkg::*;
`include "uvm_macros.svh";
class ram1_agent extends  uvm_agent;
	`uvm_component_utils(ram1_agent)
	ram1_sequencer sqr;
	ram1_driver dri;
	ram1_config conf;
	ram1_monitor mon;
	uvm_analysis_port #(ram1_seq_item) agt_ap;
	function  new(string name="ram1_agent",uvm_component parent=null);
		super.new(name,parent);
	endfunction 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(ram1_config)::get(this,"","CFG",conf))begin
			`uvm_fatal("build_phase","unable to get interface in agent")
		end
		if(conf.is_active==UVM_ACTIVE)begin
		sqr=ram1_sequencer::type_id::create("sqr",this);
		dri=ram1_driver::type_id::create("dri",this);
	end
		mon=ram1_monitor::type_id::create("mon",this);
		agt_ap=new("agt_ap",this);
		
	endfunction 

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(conf.is_active==UVM_ACTIVE)begin
		dri.ram1_if=conf.ram1_if;
		dri.seq_item_port.connect(sqr.seq_item_export);
	end 
		mon.mon_ap.connect(agt_ap);
		mon.ram1_if=conf.ram1_if;
	endfunction 
endclass : ram1_agent
endpackage : ram1_agent