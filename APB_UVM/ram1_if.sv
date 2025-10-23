interface ram1_if (PCLK);
input PCLK;
logic PRESETn,PENABLE,PWRITE,PSEL;
logic[7:0]PADDR,PWDATA;
logic[7:0]PRDATA1,PRDATA1_ref;
logic PREADY,PREADY_ref;
endinterface 