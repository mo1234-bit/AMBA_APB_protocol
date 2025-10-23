module Slave2(PCLK,PRESETn ,PSEL,PENABLE,PWRITE,PADDR,PWDATA,PRDATA2,PREADY);
input PCLK,PRESETn ,PENABLE,PWRITE,PSEL;
input [7:0]PADDR,PWDATA;
output logic[7:0]PRDATA2;
output  logic PREADY;
reg [7:0]mem[255:0];
always @(posedge PCLK) begin
	if (~PRESETn ) begin
	PREADY<=0;
	PRDATA2<=7'd0;
	for (int i = 0; i < 256; i++) begin
		mem[i]<=8'd0;
	end
	end
	else if ( PENABLE && PSEL && PWRITE)begin
	PREADY<=1;
    mem[PADDR]<=PWDATA;	
	end
	else if( PENABLE && PSEL )begin
		PREADY<=1;
		PRDATA2<=mem[PADDR];
	end
	else
	PREADY<=0;
end
endmodule