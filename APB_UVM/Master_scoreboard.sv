package Master_scoreboard;
	import Master_seq_item::*;
		import uvm_pkg::*;
`include "uvm_macros.svh";
class Master_scoreboard extends  uvm_scoreboard;
	`uvm_component_utils(Master_scoreboard)
	Master_seq_item seq_item;
	uvm_analysis_export #(Master_seq_item)sb_export;
	uvm_tlm_analysis_fifo #(Master_seq_item)sb_fifo;
	integer correct_count=0, error_count=0;
	function  new(string name="Master_scoreboard",uvm_component parent=null);
		super.new(name,parent);
	endfunction 
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sb_export=new("sb_export",this);
		sb_fifo=new("sb_fifo",this);
	endfunction 
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		sb_export.connect(sb_fifo.analysis_export);
	endfunction 

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			sb_fifo.get(seq_item);
			if(seq_item.PSEL1!==seq_item.PSEL1_ref||seq_item.PSEL2!==seq_item.PSEL2_ref||seq_item.PENABLE!==seq_item.PENABLE_ref
			||seq_item.PADDR!==seq_item.PADDR_ref||seq_item.PWRITE!==seq_item.PWRITE_ref||seq_item.PWDATA!==seq_item.PWDATA_ref
			||seq_item.apb_read_data_out!==seq_item.apb_read_data_out_ref||seq_item.PSLVERR!==seq_item.PSLVERR_ref)begin
				//`uvm_error("run_phase",$sformatf("%s PRDATA1=%0h and PRDATA1_ref=%0h",seq_item.convert2string(),seq_item.PRDATA1,seq_item.PRDATA1_ref ) );
                 error_count++;
             end 
             else 
             	correct_count++;
		end
	endtask 

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("report_phase",$sformatf("successful:%0d",correct_count),UVM_MEDIUM);
		`uvm_info("report_phase",$sformatf("faild:%0d",error_count),UVM_MEDIUM);
	endfunction 
	
endclass : Master_scoreboard
endpackage : Master_scoreboard