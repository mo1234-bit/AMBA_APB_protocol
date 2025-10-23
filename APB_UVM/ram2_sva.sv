module ram_sva (PCLK,PRESETn ,PSEL,PENABLE,PWRITE,PADDR,PWDATA,PRDATA2,PREADY);
input PCLK,PRESETn ,PENABLE,PWRITE,PSEL;
input [7:0]PADDR,PWDATA;
input [7:0]PRDATA2;
input  PREADY;
    property a;
    	@(posedge PCLK) disable iff(!PRESETn ) ( PENABLE && PWRITE && PSEL )|=>PREADY;
    endproperty

    	property b;
      @(posedge PCLK) disable iff(!PRESETn ) ( PENABLE && ~PWRITE && PSEL )|=>PREADY;
    endproperty

     property c;
      @(posedge PCLK) disable iff(!PRESETn ) (!PSEL )|=>~PREADY;
    endproperty
     	property d;
      @(posedge PCLK) disable iff(!PRESETn ) (~PENABLE)|=>~PREADY;
    endproperty

 property e;
      @(posedge PCLK) ( !PRESETn)|=>!(PREADY) && (PRDATA2==7'd0);
    endproperty

  property valid_write_data;
  @(posedge PCLK) disable iff(!PRESETn ) (PSEL && PWRITE) |-> !$isunknown(PWDATA);
endproperty

assert property(a);
assert property(b);
assert property(c);
assert property(d);
assert property(e);
assert property(valid_write_data);

cover property(a);
cover property(b);
cover property(c);
cover property(d);
cover property(e);
cover property(valid_write_data);
endmodule : ram_sva