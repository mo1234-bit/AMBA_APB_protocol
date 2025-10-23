package APB_seq_item;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	class APB_seq_item extends  uvm_sequence_item;
		`uvm_object_utils(APB_seq_item);
		function  new(string name="APB_seq_item");
			super.new(name);
			endfunction 
		rand logic transfer,READ_WRITE;
    rand logic [8:0] apb_write_paddr;
    rand logic [7:0]apb_write_data;
    rand logic [8:0] apb_read_paddr;
logic PSLVERR;
logic [7:0] apb_read_data_out;
logic PSLVERR_ref,PRESETn;
logic [7:0] apb_read_data_out_ref;
logic [1:0]addr_type;
	    constraint trans {
    transfer dist {1 := 90, 0 := 10};
  }

  constraint read_write {
    READ_WRITE dist {1 := 50, 0 := 50};  
  }
  
  constraint write_addr_c {
    if (addr_type == 0) {
      // Slave1: bit[8] = 1
      apb_write_paddr[8] == 1;
      apb_write_paddr[7:0] dist {
        8'h00 := 5,          
        8'hFF := 5,           
        [8'h01:8'hFE] := 90 
      };
    }
    else if (addr_type == 1) {
      // Slave2: bit[8] = 0
      apb_write_paddr[8] == 0;
      apb_write_paddr[7:0] dist {
        8'h00 := 5,
        8'hFF := 5,
        [8'h01:8'hFE] := 90
      };
    }
    else if (addr_type == 2) {
      // Boundary addresses for slave selection
      apb_write_paddr inside {9'h0FF, 9'h100, 9'h000, 9'h1FF};
    }
  }
  
 constraint read_addr_c {
    if (addr_type == 0) {
      apb_read_paddr[8] == 1;
      apb_read_paddr[7:0] dist {
        8'h00 := 5,
        8'hFF := 5,
        [8'h01:8'hFE] := 90
      };
    }
    else if (addr_type == 1) {
      apb_read_paddr[8] == 0;
      apb_read_paddr[7:0] dist {
        8'h00 := 5,
        8'hFF := 5,
        [8'h01:8'hFE] := 90
      };
    }
    else if (addr_type == 2) {
      apb_read_paddr inside {9'h0FF, 9'h100, 9'h000, 9'h1FF};
    }
  }


function string convert2string(); 
    return $sformatf("%s PRESETn =%0b transfer=%0h READ_WRITE =%0b apb_write_paddr =%0b apb_write_data =%0b apb_read_paddr=%0b PSLVERR=%0b apb_read_data_out=%0h ",super.convert2string(),PRESETn ,transfer,READ_WRITE,apb_write_paddr,apb_write_data,apb_read_paddr, PSLVERR, apb_read_data_out); 
endfunction  




	endclass : APB_seq_item
endpackage : APB_seq_item