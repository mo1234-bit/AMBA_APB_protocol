package ram_monitor;
	import ram_seq_item::*;
			import uvm_pkg::*;
`include "uvm_macros.svh";
class ram_monitor extends  uvm_monitor;
	`uvm_component_utils(ram_monitor);
	ram_seq_item seq_item;
	virtual ram_if ram_if;
	uvm_analysis_port #(ram_seq_item)mon_ap;
	function  new(string name="ram_monitor",uvm_component parent=null);
		super.new(name,parent);
	endfunction 

    function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	mon_ap=new("mon_ap",this);
    endfunction

    task run_phase(uvm_phase phase);
    	super.run_phase(phase);
    	forever begin
    		seq_item=ram_seq_item::type_id::create("seq_item");
    		@(negedge  ram_if.PCLK);
    		seq_item.PRSTn=ram_if.PRSTn;
    		seq_item.PENABLE=ram_if.PENABLE;
    		seq_item.PADDR=ram_if.PADDR;
    		seq_item.PWDATA=ram_if.PWDATA;
    		seq_item.PRDATA1=ram_if.PRDATA1;
    		seq_item.PREADY=ram_if.PREADY;
    		mon_ap.write(seq_item);
    		

    	end
    endtask : run_phase

endclass : ram_monitor
endpackage : ram_monitor