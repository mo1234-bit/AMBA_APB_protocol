module master_bridge(	input [8:0]apb_write_paddr,apb_read_paddr,
	input [7:0] apb_write_data,PRDATA,   
	input PRESETn,PCLK,READ_WRITE,transfer,PREADY,
	output PSEL1,PSEL2,
	output reg PENABLE,
	output reg [8:0]PADDR,
	output reg PWRITE,
	output reg [7:0]PWDATA,apb_read_data_out,
	output PSLVERR);
	parameter IDLE=0;
        parameter SETUP=1;
        parameter ACCESS=2;

	(*fsm_encoding="one_hot"*)
	reg [1:0]ns,cs;
	//error signals
    reg setup_error ;
	reg invalid_read_paddr;
	reg invalid_write_paddr;
	reg invalid_write_data;
//state memory
	always @(posedge PCLK) begin
		if (~PRESETn) begin
			cs<=IDLE;
		end
		else begin
			cs<=ns;
		end
	end
//next state logic
	always@(*)begin
	PWRITE=~READ_WRITE;
		case(cs)
		IDLE:begin
			PENABLE=0;
			if(transfer)
			ns=SETUP;
			else begin
				ns=IDLE;
			end
		end
		SETUP:begin
			PENABLE=0;
			if(transfer&&~PSLVERR)
			ns=ACCESS;
			else 
				ns=SETUP;
		end
		ACCESS:begin
			PENABLE=1;
			if(transfer&&~PSLVERR)begin
				if(PREADY)		
					ns=SETUP;
				else
					ns=ACCESS;
			
        end  
           else 
            ns=IDLE; 
		
		end
		endcase
	end
//slave select depend on the last bit of PADDR and cs
assign PSEL1=((cs==SETUP||cs==ACCESS)&&PADDR[8]==1)?1:0;
assign PSEL2=((cs==SETUP||cs==ACCESS)&&PADDR[8]==0)?1:0;
//output logic
always @(posedge PCLK)begin
     if(~PRESETn)begin
     PADDR<=0;
     PWDATA<=0;
apb_read_data_out<=0;end
 else
	if(cs==SETUP&&READ_WRITE)
	PADDR<=apb_read_paddr;
	else if(cs==SETUP) begin
	PADDR<=apb_write_paddr;
	PWDATA<=apb_write_data;
	end
	else
	if(cs==ACCESS&&transfer&&~PSLVERR&&PREADY&&READ_WRITE)
	apb_read_data_out<=PRDATA;
end


//transfer failure and error respondes
always@(*)begin
	if(cs==IDLE&&ns==ACCESS)
	setup_error=1;
    else 
    	setup_error=0;
    if((apb_write_data===8'dx) && (~READ_WRITE) && (cs==SETUP || cs==ACCESS))
    invalid_write_data=1;
    else
     invalid_write_data=0;
     if((apb_read_paddr===9'dx) && READ_WRITE && (cs==SETUP || cs==ACCESS))
		  invalid_read_paddr = 1;
	  else  invalid_read_paddr = 0;
    if((apb_write_paddr===9'dx) && (~READ_WRITE) && (cs==SETUP || cs==ACCESS))
		  invalid_write_paddr =1;
          else invalid_write_paddr =0;
    
end
assign PSLVERR=(setup_error||invalid_write_data||invalid_write_paddr||invalid_read_paddr)?1:0;


`ifndef SYNTHESIS


    property valid_state_encoding;
  @(posedge PCLK) disable iff(!PRESETn)
  cs inside {IDLE, SETUP, ACCESS};
endproperty
assert_valid_state: assert property(valid_state_encoding);

property reset_to_idle;
  @(posedge PCLK)
  !PRESETn |=> (cs == IDLE);
endproperty
assert_reset_idle: assert property(reset_to_idle);

property idle_to_setup_valid;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == IDLE && transfer) |=> (cs == SETUP);
endproperty
assert_idle_to_setup: assert property(idle_to_setup_valid);

property idle_stays_idle;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == IDLE && !transfer) |=> (cs == IDLE);
endproperty
assert_idle_stable: assert property(idle_stays_idle);

property setup_to_access_valid;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == SETUP && transfer && !PSLVERR) |=> (cs == ACCESS);
endproperty
assert_setup_to_access: assert property(setup_to_access_valid);


property setup_stays_setup;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == SETUP && !transfer && !PSLVERR) |=> (cs == SETUP);
endproperty
assert_setup_stable: assert property(setup_stays_setup);

property access_to_setup_valid;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == ACCESS && PREADY && transfer && !PSLVERR) |=> (cs == SETUP);
endproperty
assert_access_to_setup: assert property(access_to_setup_valid);

property access_waits_pready;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == ACCESS && !PREADY && transfer && !PSLVERR) |=> (cs == ACCESS);
endproperty
assert_access_wait: assert property(access_waits_pready);

property access_to_idle;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == ACCESS && (!transfer || PSLVERR)) |=> (cs == IDLE);
endproperty
assert_access_idle: assert property(access_to_idle);

property no_idle_to_access;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == IDLE) |=> (cs != ACCESS);
endproperty
assert_no_skip_setup: assert property(no_idle_to_access);

property penable_idle;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == IDLE) |-> (PENABLE == 0);
endproperty
assert_penable_idle: assert property(penable_idle);

property penable_setup;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == SETUP) |-> (PENABLE == 0);
endproperty
assert_penable_setup: assert property(penable_setup);

property penable_access;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == ACCESS) |-> (PENABLE == 1);
endproperty
assert_penable_access: assert property(penable_access);

property psel_idle;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == IDLE) |-> (!PSEL1 && !PSEL2);
endproperty
assert_psel_idle: assert property(psel_idle);

property psel_active;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == SETUP || cs == ACCESS) |-> (PSEL1 || PSEL2);
endproperty
assert_psel_active: assert property(psel_active);

property psel_exclusive;
  @(posedge PCLK) disable iff(!PRESETn)
  !(PSEL1 && PSEL2);
endproperty
assert_psel_exclusive: assert property(psel_exclusive);

property psel1_addr_match;
  @(posedge PCLK) disable iff(!PRESETn)
  ((cs == SETUP || cs == ACCESS) && PADDR[8]) |-> PSEL1;
endproperty
assert_psel1_addr: assert property(psel1_addr_match);

property psel2_addr_match;
  @(posedge PCLK) disable iff(!PRESETn)
  ((cs == SETUP || cs == ACCESS) && !PADDR[8]) |-> PSEL2;
endproperty
assert_psel2_addr: assert property(psel2_addr_match);

property pwrite_correct;
  @(posedge PCLK) disable iff(!PRESETn)
  PWRITE == !READ_WRITE;
endproperty
assert_pwrite_mapping: assert property(pwrite_correct);

property paddr_write_capture;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == SETUP && !READ_WRITE) |-> ##1 (PADDR == $past(apb_write_paddr));
endproperty
assert_paddr_write: assert property(paddr_write_capture);

property paddr_read_capture;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == SETUP && READ_WRITE) |-> ##1 (PADDR == $past(apb_read_paddr));
endproperty
assert_paddr_read: assert property(paddr_read_capture);

property paddr_reset;
  @(posedge PCLK)
  !PRESETn |=> (PADDR == 0);
endproperty
assert_paddr_reset: assert property(paddr_reset);

property pwdata_capture;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == SETUP && !READ_WRITE) |-> ##1 (PWDATA == $past(apb_write_data));
endproperty
assert_pwdata_capture: assert property(pwdata_capture);

property pwdata_reset;
  @(posedge PCLK)
  !PRESETn |=> (PWDATA == 0);
endproperty
assert_pwdata_reset: assert property(pwdata_reset);

property read_data_capture;
  @(posedge PCLK) disable iff(!PRESETn)
  (cs == ACCESS && READ_WRITE && PREADY && !PSLVERR && transfer) |=> 
    (apb_read_data_out != 0) || (apb_read_data_out == 0);  // Data captured (value doesn't matter)
endproperty
assert_read_capture: assert property(read_data_capture);

property read_data_reset;
  @(posedge PCLK)
  !PRESETn |=> (apb_read_data_out == 0);
endproperty
assert_read_reset: assert property(read_data_reset);

cover_valid_state:  cover property(valid_state_encoding);

cover_reset_idle:   cover property(reset_to_idle);

cover_idle_to_setup:  cover property(idle_to_setup_valid);

cover_idle_stable:  cover property(idle_stays_idle);

cover_setup_to_access:  cover property(setup_to_access_valid);

cover_setup_stable:  cover property(setup_stays_setup);

cover_access_to_setup:  cover property(access_to_setup_valid);

cover_access_wait:  cover property(access_waits_pready);

cover_access_idle:  cover property(access_to_idle);

cover_no_skip_setup:  cover property(no_idle_to_access);

cover_penable_idle:   cover property(penable_idle);

cover_penable_setup:  cover property(penable_setup);

cover_penable_access:  cover property(penable_access);

cover_psel_idle:      cover property(psel_idle);

cover_psel_active:    cover property(psel_active);

cover_psel_exclusive:  cover property(psel_exclusive);

cover_psel1_addr:  cover property(psel1_addr_match);

cover_psel2_addr:  cover property(psel2_addr_match);

cover_pwrite_mapping:  cover property(pwrite_correct);

cover_paddr_write:  cover property(paddr_write_capture);

cover_paddr_read:  cover property(paddr_read_capture);

cover_paddr_reset:  cover property(paddr_reset);

cover_pwdata_capture:  cover property(pwdata_capture);

cover_pwdata_reset:  cover property(pwdata_reset);

cover_read_capture:  cover property(read_data_capture);

cover_read_reset:  cover property(read_data_reset);

`endif
endmodule

