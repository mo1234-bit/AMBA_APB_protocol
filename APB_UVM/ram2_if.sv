interface ram2_if (PCLK);
input PCLK;
logic PRESETn,PENABLE,PWRITE,PSEL;
logic[7:0]PADDR,PWDATA;
logic[7:0]PRDATA2,PRDATA2_ref;
logic PREADY,PREADY_ref;
endinterface 