package Master_seq_item;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	class Master_seq_item extends  uvm_sequence_item;
		`uvm_object_utils(Master_seq_item);
		function  new(string name="Master_seq_item");
			super.new(name);
			endfunction 
		rand logic[8:0]apb_write_paddr,apb_read_paddr;
	    rand logic[7:0] apb_write_data,PRDATA;
	    rand logic PRESETn,READ_WRITE,transfer,PREADY;
	    rand bit [2:0] addr_type;  // 0=slave1, 1=slave2, 2=boundary, 3=random
	    logic PSEL1,PSEL2;
	    logic  PENABLE;
	    logic  [8:0]PADDR;
	    logic  PWRITE;
	    logic  [7:0]PWDATA,apb_read_data_out;
	    logic PSLVERR;
	    logic PSEL1_ref,PSEL2_ref;
	    logic  PENABLE_ref;
	    logic  [8:0]PADDR_ref;
	    logic  PWRITE_ref;
	    logic  [7:0]PWDATA_ref,apb_read_data_out_ref;
	    logic PSLVERR_ref;

	    constraint trans {
    transfer dist {1 := 90, 0 := 10};
  }

  constraint read_write {
    READ_WRITE dist {1 := 50, 0 := 50};  
  }

constraint type_addr {
    addr_type dist {0 := 40, 1 := 40, 2 := 10, 3 := 10};
  }
  
  constraint rst {
    PRESETn dist {0:=2,1:=98};
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
    return $sformatf("%s PRESETn =%0b PENABLE=%0h PWRITE =%0b PSEL1 =%0b PSEL2 =%0b PADDR=%0b PWDATA=%0b ",super.convert2string(),PRESETn ,PENABLE,PWRITE,PSEL1,PSEL2,PADDR, PWDATA); 
endfunction  




	endclass : Master_seq_item
endpackage : Master_seq_item