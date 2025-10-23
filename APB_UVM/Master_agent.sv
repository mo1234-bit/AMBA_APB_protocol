package Master_agent;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	import Master_monitor::*;
	import Master_driver::*;
	import Master_config::*;
	import Master_sequencer::*;
	import Master_seq_item::*;
	class Master_agent extends  uvm_agent;
		`uvm_component_utils(Master_agent)
		Master_monitor mon;
		Master_driver dri;
		Master_config conf;
		Master_sequencer sqr;
		Master_seq_item seq_item;
		uvm_analysis_port#(Master_seq_item)agt_ap;
		function  new(string name="Master_agent",uvm_component parent=null);
			super.new(name,parent);
		endfunction 
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			if(!uvm_config_db#(Master_config)::get(this,"","CFG",conf))
				`uvm_fatal("build_phase","unable to get interface in agent")
			mon=Master_monitor::type_id::create("mon",this);
			if(conf.is_active==UVM_ACTIVE)begin
			dri=Master_driver::type_id::create("dri",this);
			sqr=Master_sequencer::type_id::create("seqr",this);
		end
            agt_ap=new("agt_ap",this);
			

		endfunction 

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			if(conf.is_active==UVM_ACTIVE)begin
			dri.Master_IF=conf.Master_IF;
			dri.seq_item_port.connect(sqr.seq_item_export);
		end
			mon.Master_IF=conf.Master_IF;
			mon.mon_ap.connect(agt_ap);
			
		endfunction 
	endclass : Master_agent
endpackage : Master_agent