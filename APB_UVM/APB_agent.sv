package APB_agent;
	import APB_config::*;
	import APB_seq_item::*;
	import APB_sequencer::*;
	import APB_monitor::*;
	import APB_driver::*;
	import uvm_pkg::*;
`include "uvm_macros.svh";
class APB_agent extends  uvm_agent;
	`uvm_component_utils(APB_agent)
	APB_config conf;
	APB_sequencer sqr;
	APB_monitor mon;
	APB_driver dri;
	uvm_analysis_port #(APB_seq_item) agt_ap;
	function  new(string name="APB_agent",uvm_component parent=null);
		super.new(name,parent);
	endfunction 
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(APB_config)::get(this,"","CFG",conf))begin
			`uvm_fatal("build_phase","unable to get interface in agent");
		end
		if(conf.is_active==UVM_ACTIVE)begin
		sqr=APB_sequencer::type_id::create("sqr",this);
         dri=APB_driver::type_id::create("dri",this);
	end
	mon=APB_monitor::type_id::create("mon",this);
		agt_ap=new("agt_ap",this);
		

	endfunction
	function void connect_phase(uvm_phase phase);
	 	super.connect_phase(phase);
	 	if(conf.is_active==UVM_ACTIVE)begin
	 	dri.APB_if=conf.APB_if;
	 	dri.seq_item_port.connect(sqr.seq_item_export);
	 end
	 	mon.APB_if=conf.APB_if;
	 	mon.mon_ap.connect(agt_ap);
	 		 endfunction  
endclass : APB_agent
endpackage : APB_agent