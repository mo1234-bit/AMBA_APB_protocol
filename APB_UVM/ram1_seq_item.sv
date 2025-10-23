package ram1_seq_item;
	import uvm_pkg::*;
`include "uvm_macros.svh";
class ram1_seq_item extends  uvm_sequence_item;
	`uvm_object_utils(ram1_seq_item);
	function  new(string name="ram1_seq_item");
		super.new(name);
	endfunction 

rand logic PRESETn,PENABLE,PWRITE,PSEL;
rand logic[7:0]PADDR,PWDATA;

logic[7:0]PRDATA1,PRDATA1_ref;
logic PREADY,PREADY_ref;

constraint PRESETn1  {
	PRESETn dist {1:=98,0:=2};
}
constraint PENABLE1 {
	PENABLE dist{1:=90,0:=10};
	
}

constraint psel1 {
	PSEL dist {1:=90,0:=10};
}
constraint wr {
	PWRITE==1;
}

constraint rd {
	PWRITE==0;
}

constraint wr_rd {
	PWRITE dist {1:=50,0:=50};
}


function string convert2string(); 
    return $sformatf("%s PRESETn =%0b PENABLE=%0h PWRITE =%0b PSEL =%0b PADDR=%0b PWDATA=%0b ",super.convert2string(),PRESETn ,PENABLE,PWRITE,PSEL,PADDR, PWDATA); 
endfunction  

endclass : ram1_seq_item
endpackage : ram1_seq_item