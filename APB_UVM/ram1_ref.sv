module Slave1_ref(
    input PCLK,
    input PRESETn,
    input PSEL,
    input PENABLE,
    input PWRITE,
    input [7:0] PADDR,
    input [7:0] PWDATA,
    output reg [7:0] PRDATA1,
    output reg PREADY
);

    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;
    
    // Import DPI-C functions
    import "DPI-C" function void slave1_sim(
        input int PCLK,
        input int PRESETn,
        input int PSEL,
        input int PENABLE,
        input int PWRITE,
        input int PADDR,
        input int PWDATA
    );
    
    import "DPI-C" function int get_PRDATA1_int();
    import "DPI-C" function int get_PREADY_int();
    
    // Call C model on every clock edge
    always @(posedge PCLK) begin
        // Call the C simulation function
        slave1_sim(
            1'b1,                    // PCLK (always 1 in posedge context)
            int'(PRESETn),
            int'(PSEL),
            int'(PENABLE),
            int'(PWRITE),
            int'(PADDR),
            int'(PWDATA)
        );
        
        // Get outputs from C model
        PRDATA1 <= get_PRDATA1_int()[ADDR_SIZE-1:0];
        PREADY <= get_PREADY_int() ? 1'b1 : 1'b0;
    end

endmodule