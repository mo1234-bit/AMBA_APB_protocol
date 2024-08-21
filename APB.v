module APB(PCLK,PRESETn,transfer,READ_WRITE,apb_write_paddr,apb_write_data,apb_read_paddr,PSLVERR,apb_read_data_out);
input PCLK,PRESETn,transfer,READ_WRITE;
input [8:0] apb_write_paddr;
input [7:0]apb_write_data;
input [8:0] apb_read_paddr;
output PSLVERR;
output [7:0] apb_read_data_out;
 wire [7:0]PRDATA;
  wire [7:0]PWDATA,PRDATA1,PRDATA2;
wire [8:0]PADDR;
wire PREADY,PREADY1,PREADY2,PENABLE,PSEL1,PSEL2,PWRITE; 
assign PREADY = PADDR[8] ? PREADY1 : PREADY2 ;
assign PRDATA = READ_WRITE ? (PADDR[8] ? PRDATA1 : PRDATA2) : 8'd0 ;


master_bridge dut(apb_write_paddr,apb_read_paddr,apb_write_data,PRDATA,PRESETn,PCLK,READ_WRITE,
transfer,PREADY,PSEL1,PSEL2,PENABLE,PADDR,PWRITE,PWDATA,apb_read_data_out, PSLVERR); 
Slave1 dut1(  PCLK,PRESETn, PSEL1,PENABLE,PWRITE, PADDR[7:0],PWDATA, PRDATA1, PREADY1 );
Slave2 dut2(  PCLK,PRESETn, PSEL2,PENABLE,PWRITE, PADDR[7:0],PWDATA, PRDATA2, PREADY2 );
endmodule