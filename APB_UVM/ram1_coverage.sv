package ram1_coverage;
	import ram1_seq_item::*;
	import uvm_pkg::*;
`include "uvm_macros.svh";
class ram1_coverage extends  uvm_component;
	`uvm_component_utils(ram1_coverage);
	ram1_seq_item seq_item;
    uvm_analysis_export #(ram1_seq_item)covr_export;
    uvm_tlm_analysis_fifo #(ram1_seq_item)covr_fifo;

    covergroup cg();
    a:coverpoint seq_item.PRESETn ;
    b:coverpoint seq_item.PENABLE;
    c:coverpoint seq_item.PSEL;
    d:coverpoint seq_item.PADDR;
    o:coverpoint seq_item.PWDATA;
    t:coverpoint seq_item.PRDATA1;
    p:coverpoint seq_item.PREADY;
    
   
    endgroup : cg

    function  new(string name="ram1_coverage",uvm_component parent=null);
    	super.new(name,parent);
    	cg=new;
    endfunction 

    function void build_phase(uvm_phase phase);
     	super.build_phase(phase);
     	covr_export=new("covr_export",this);
     	covr_fifo=new("covr_fifo",this);
    endfunction 

    function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
    	covr_export.connect(covr_fifo.analysis_export);
    endfunction 

    task run_phase(uvm_phase phase);
    	super.run_phase(phase);
    	forever begin
    		covr_fifo.get(seq_item);
    		cg.sample();
    	end
    endtask : run_phase
endclass : ram1_coverage
endpackage : ram1_coverage