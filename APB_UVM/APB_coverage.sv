package APB_coverage;
	import APB_seq_item::*;
			import uvm_pkg::*;
`include "uvm_macros.svh";
class APB_coverage extends  uvm_component;
	`uvm_component_utils(APB_coverage);
	APB_seq_item seq_item;
	uvm_analysis_export #(APB_seq_item)covr_export;
	uvm_tlm_analysis_fifo #(APB_seq_item)covr_fifo;

	covergroup cg();
		a:coverpoint seq_item.PRESETn;
		b:coverpoint seq_item.transfer;
		r:coverpoint seq_item.READ_WRITE;
		y:coverpoint seq_item.apb_write_paddr;
		c:coverpoint seq_item.apb_write_data;
		d:coverpoint seq_item.apb_read_paddr;
		p:coverpoint seq_item.PSLVERR;
		m:coverpoint seq_item.apb_read_data_out;
	endgroup : cg
		function  new(string name="APB_coverage",uvm_component parent=null);
		super.new(name,parent);
		cg=new();
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
endclass : APB_coverage
endpackage : APB_coverage