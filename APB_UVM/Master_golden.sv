module master_bridge_ref(   input [8:0]apb_write_paddr,apb_read_paddr,
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
            else if(~transfer) begin
                ns=SETUP;
            end
            else begin
            ns=IDLE;
            end
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
endmodule : master_bridge_ref