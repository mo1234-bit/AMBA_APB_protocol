package Master_coverage;
	import Master_seq_item::*;
	import uvm_pkg::*;
`include "uvm_macros.svh";
class Master_coverage extends  uvm_component;
	`uvm_component_utils(Master_coverage);
	Master_seq_item seq_item;
    uvm_analysis_export #(Master_seq_item)covr_export;
    uvm_tlm_analysis_fifo #(Master_seq_item)covr_fifo; 
    
   covergroup cg();
    PRESETn:coverpoint seq_item.PRESETn ;
    PENABLE:coverpoint seq_item.PENABLE;
    PSEL1:coverpoint seq_item.PSEL1;
    PADDR:coverpoint seq_item.PADDR;
    PWDATA:coverpoint seq_item.PWDATA;
    Master_write_paddr:coverpoint seq_item.apb_write_paddr;
    PREADY:coverpoint seq_item.PREADY;
    Master_read_paddr:coverpoint seq_item.apb_read_paddr;
    Master_write_data:coverpoint seq_item.apb_write_data;
    READ_WRITE:coverpoint seq_item.READ_WRITE;
    transfer:coverpoint seq_item.transfer;
    PSEL2:coverpoint seq_item.PSEL2;
    PWRITE:coverpoint seq_item.PWRITE;
    Master_read_data_out:coverpoint seq_item.apb_read_data_out;

    
   
    endgroup : cg

    function  new(string name="Master_coverage",uvm_component parent=null);
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
endclass : Master_coverage
endpackage : Master_coverage