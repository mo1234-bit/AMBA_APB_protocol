package Master_monitor;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	import Master_seq_item::*;
	class Master_monitor extends  uvm_monitor;
		`uvm_component_utils(Master_monitor)
		Master_seq_item seq_item;
		virtual Master_if Master_IF;
		uvm_analysis_port #(Master_seq_item)mon_ap;
		function  new(string name="Master_monitor",uvm_component parent=null);
			super.new(name,parent);
		endfunction 
         
         function void build_phase(uvm_phase phase);
         	super.build_phase(phase);
         	mon_ap=new("mon_ap",this);
         endfunction 


		task run_phase(uvm_phase phase);
		 	super.run_phase(phase);
            forever begin
            	seq_item=Master_seq_item::type_id::create("seq_item");
            	@(negedge Master_IF.PCLK);
                seq_item.apb_write_paddr=Master_IF.apb_write_paddr;
                seq_item.apb_read_paddr=Master_IF.apb_read_paddr;
                seq_item.apb_write_data=Master_IF.apb_write_data;
                seq_item.PRDATA=Master_IF.PRDATA;
                seq_item.PRESETn=Master_IF.PRESETn;
                seq_item.READ_WRITE=Master_IF.READ_WRITE;
                seq_item.transfer=Master_IF.transfer;
                seq_item.PREADY=Master_IF.PREADY;
                seq_item.PSEL1=Master_IF.PSEL1;
                seq_item.PSEL2=Master_IF.PSEL2;
                seq_item.PENABLE=Master_IF.PENABLE;
                seq_item.PADDR=Master_IF.PADDR;
                seq_item.PWRITE=Master_IF.PWRITE;
                seq_item.PWDATA=Master_IF.PWDATA;
                seq_item.apb_read_data_out=Master_IF.apb_read_data_out;
                seq_item.PSLVERR_ref=Master_IF.PSLVERR_ref;
                seq_item.PSEL1_ref=Master_IF.PSEL1_ref;
                seq_item.PSEL2_ref=Master_IF.PSEL2_ref;
                seq_item.PENABLE_ref=Master_IF.PENABLE_ref;
                seq_item.PADDR_ref=Master_IF.PADDR_ref;
                seq_item.PWRITE_ref=Master_IF.PWRITE_ref;
                seq_item.PWDATA_ref=Master_IF.PWDATA_ref;
                seq_item.apb_read_data_out_ref=Master_IF.apb_read_data_out_ref;
                seq_item.PSLVERR=Master_IF.PSLVERR;

                mon_ap.write(seq_item);
            end
		 endtask : run_phase 
	endclass : Master_monitor
endpackage : Master_monitor
