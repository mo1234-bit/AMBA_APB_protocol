interface APB_if (PCLK);
input bit PCLK;
logic PRESETn,transfer,READ_WRITE;
logic [8:0] apb_write_paddr;
logic [7:0]apb_write_data;
logic [8:0] apb_read_paddr;
logic PSLVERR;
logic [7:0] apb_read_data_out;
logic PSLVERR_ref;
logic [7:0] apb_read_data_out_ref;

endinterface : APB_if