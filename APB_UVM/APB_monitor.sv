package APB_monitor;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	import APB_seq_item::*;
	class APB_monitor extends  uvm_monitor;
		`uvm_component_utils(APB_monitor)
		APB_seq_item seq_item;
		virtual APB_if APB_IF;
		uvm_analysis_port #(APB_seq_item)mon_ap;
		function  new(string name="APB_monitor",uvm_component parent=null);
			super.new(name,parent);
		endfunction 
         
         function void build_phase(uvm_phase phase);
         	super.build_phase(phase);
         	mon_ap=new("mon_ap",this);
         endfunction 


		task run_phase(uvm_phase phase);
		 	super.run_phase(phase);
            forever begin
            	seq_item=APB_seq_item::type_id::create("seq_item");
            	@(negedge APB_IF.PCLK);
                seq_item.apb_write_paddr=APB_IF.apb_write_paddr;
                seq_item.apb_read_paddr=APB_IF.apb_read_paddr;
                seq_item.apb_write_data=APB_IF.apb_write_data;
                seq_item.PRESETn=APB_IF.PRESETn;
                seq_item.READ_WRITE=APB_IF.READ_WRITE;
                seq_item.transfer=APB_IF.transfer;
                seq_item.apb_read_data_out=APB_IF.apb_read_data_out;
                seq_item.PSLVERR_ref=APB_IF.PSLVERR_ref;
                seq_item.apb_read_data_out_ref=APB_IF.apb_read_data_out_ref;
                seq_item.PSLVERR=APB_IF.PSLVERR;

                mon_ap.write(seq_item);
            end
		 endtask : run_phase 
	endclass : APB_monitor
endpackage : APB_monitor
