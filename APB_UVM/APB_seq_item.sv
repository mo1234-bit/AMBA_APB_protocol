package APB_seq_item;
		import uvm_pkg::*;
`include "uvm_macros.svh";
class APB_seq_item extends  uvm_sequence_item;
	`uvm_object_utils(APB_seq_item)
	function  new(string name ="APB_seq_item");
		super.new(name);
container=0;
	endfunction 
rand logic PRESETn,transfer,READ_WRITE;
rand logic [8:0] apb_write_paddr;
rand logic [7:0]apb_write_data;
rand logic [8:0] apb_read_paddr;
logic PSLVERR,PSLVERR_ref;
logic [7:0] apb_read_data_out,apb_read_data_out_ref;

constraint a {
	transfer dist {1:=80,0:=20};
}

constraint rst {
	PRESETn dist {1:=98,0:=2};
}

constraint READ_WRITE1 {
	READ_WRITE dist {1:=50,0:=50};
}



function string convert2string();
	return $sformatf("%s transfer=%0b PRESETn=%0b READ_WRITE=%0b  apb_write_paddr=%0b apb_write_data=%0b apb_read_paddr=%0b",super.convert2string(),transfer,PRESETn,READ_WRITE,apb_write_paddr,apb_read_paddr,apb_write_data );
endfunction 

endclass : APB_seq_item
endpackage : APB_seq_item