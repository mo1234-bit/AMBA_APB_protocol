interface Master_if (PCLK);
	input bit PCLK;
     logic [8:0]apb_write_paddr,apb_read_paddr;
	logic [7:0] apb_write_data,PRDATA; 
	logic PRESETn,READ_WRITE,transfer,PREADY;
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

endinterface : Master_if