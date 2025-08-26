module Slave2(PCLK,PRSTn,PSEL,PENABLE,PWRITE,PADDR,PWDATA,PRDATA2,PREADY);
input PCLK,PRSTn,PENABLE,PWRITE,PSEL;
input [7:0]PADDR,PWDATA;
output [7:0]PRDATA2;
output reg PREADY;
reg [7:0]adder;
reg [7:0]mem2[255:0];
always @(posedge PCLK) begin
	if (~PRSTn) begin
	PREADY<=0;
	end
	else if (PENABLE&&PSEL&&PWRITE)begin
	PREADY<=1;
    mem2[PADDR]<=PWDATA;	
	end
	else if(PENABLE&&PSEL&&~PWRITE)begin
		PREADY<=1;
		adder<=PADDR;
	end
	else
	PREADY<=0;
end
assign PRDATA2=mem2[adder];
endmodule