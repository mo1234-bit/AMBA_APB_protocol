package ram2_monitor;
	import ram2_seq_item::*;
			import uvm_pkg::*;
`include "uvm_macros.svh";
class ram2_monitor extends  uvm_monitor;
	`uvm_component_utils(ram2_monitor);
	ram2_seq_item seq_item;
	virtual ram2_if ram2_if;
	uvm_analysis_port #(ram2_seq_item)mon_ap;
	function  new(string name="ram2_monitor",uvm_component parent=null);
		super.new(name,parent);
	endfunction 

    function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	mon_ap=new("mon_ap",this);
    endfunction

    task run_phase(uvm_phase phase);
    	super.run_phase(phase);
    	forever begin
    		seq_item=ram2_seq_item::type_id::create("seq_item");
    		@(negedge  ram2_if.PCLK);
    		seq_item.PRESETn =ram2_if.PRESETn ;
    		seq_item.PENABLE=ram2_if.PENABLE;
    		seq_item.PSEL=ram2_if.PSEL;
    		seq_item.PADDR=ram2_if.PADDR;
    		seq_item.PWDATA=ram2_if.PWDATA;
    		seq_item.PRDATA2=ram2_if.PRDATA2;
    		seq_item.PREADY=ram2_if.PREADY;
    		seq_item.PRDATA2_ref=ram2_if.PRDATA2_ref;
    		seq_item.PREADY_ref=ram2_if.PREADY_ref;
    		mon_ap.write(seq_item);
    		

    	end
    endtask : run_phase

endclass : ram2_monitor
endpackage : ram2_monitor