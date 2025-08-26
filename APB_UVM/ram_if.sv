import pkg::*;
interface ram_if (PCLK);
input PCLK;
logic PRSTn,PENABLE,PWRITE,PSEL;
logic[7:0]PADDR,PWDATA;
logic[7:0]PRDATA1;
logic PREADY;
endinterface 