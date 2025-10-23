package ram2_agent;
	import ram2_sequencer::*;
	import ram2_driver::*;
	import ram2_config::*;
	import ram2_monitor::*;
	import ram2_seq_item::*;
			import uvm_pkg::*;
`include "uvm_macros.svh";
class ram2_agent extends  uvm_agent;
	`uvm_component_utils(ram2_agent)
	ram2_sequencer sqr;
	ram2_driver dri;
	ram2_config conf;
	ram2_monitor mon;
	uvm_analysis_port #(ram2_seq_item) agt_ap;
	function  new(string name="ram2_agent",uvm_component parent=null);
		super.new(name,parent);
	endfunction 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(ram2_config)::get(this,"","CFG",conf))begin
			`uvm_fatal("build_phase","unable to get interface in agent")
		end
		if(conf.is_active==UVM_ACTIVE)begin
		sqr=ram2_sequencer::type_id::create("sqr",this);
		dri=ram2_driver::type_id::create("dri",this);
	end
		mon=ram2_monitor::type_id::create("mon",this);
		agt_ap=new("agt_ap",this);
		
	endfunction 

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(conf.is_active==UVM_ACTIVE)begin
		dri.ram2_if=conf.ram2_if;
		dri.seq_item_port.connect(sqr.seq_item_export);
	end
		mon.mon_ap.connect(agt_ap);
		mon.ram2_if=conf.ram2_if;
	endfunction 
endclass : ram2_agent
endpackage : ram2_agent