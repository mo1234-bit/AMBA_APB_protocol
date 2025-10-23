package ram1_monitor;
	import ram1_seq_item::*;
			import uvm_pkg::*;
`include "uvm_macros.svh";
class ram1_monitor extends  uvm_monitor;
	`uvm_component_utils(ram1_monitor);
	ram1_seq_item seq_item;
	virtual ram1_if ram1_if;
	uvm_analysis_port #(ram1_seq_item)mon_ap;
	function  new(string name="ram1_monitor",uvm_component parent=null);
		super.new(name,parent);
	endfunction 

    function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	mon_ap=new("mon_ap",this);
    endfunction

    task run_phase(uvm_phase phase);
    	super.run_phase(phase);
    	forever begin
    		seq_item=ram1_seq_item::type_id::create("seq_item");
    		@(negedge  ram1_if.PCLK);
    		seq_item.PRESETn =ram1_if.PRESETn ;
    		seq_item.PENABLE=ram1_if.PENABLE;
    		seq_item.PSEL=ram1_if.PSEL;
    		seq_item.PADDR=ram1_if.PADDR;
    		seq_item.PWDATA=ram1_if.PWDATA;
    		seq_item.PRDATA1=ram1_if.PRDATA1;
    		seq_item.PREADY=ram1_if.PREADY;
    		seq_item.PRDATA1_ref=ram1_if.PRDATA1_ref;
    		seq_item.PREADY_ref=ram1_if.PREADY_ref;
    		mon_ap.write(seq_item);
    		

    	end
    endtask : run_phase

endclass : ram1_monitor
endpackage : ram1_monitor