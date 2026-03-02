module Slave1 (
    PCLK, PRSTn,
    PSEL, PENABLE, PWRITE,
    PADDR, PWDATA, PSTRB,
    PRDATA1, PREADY, PSLVERR
);

    input        PCLK, PRSTn;
    input        PSEL, PENABLE, PWRITE;
    input  [7:0] PADDR;
    input  [31:0] PWDATA;
    input  [3:0]  PSTRB;

    output reg [31:0] PRDATA1;
    output reg        PREADY;
    output reg        PSLVERR;

    // 256-entry × 32-bit memory
    reg [31:0] mem [0:255];

    integer i;

    always @(posedge PCLK or negedge PRSTn) begin
        if (~PRSTn) begin
            PREADY  <= 1'b0;
            PSLVERR <= 1'b0;
            PRDATA1 <= 32'd0;
            for (i = 0; i < 256; i = i + 1)
                mem[i] <= 32'd0;
        end
        else begin
            
            PREADY  <= 1'b0;
            PSLVERR <= 1'b0;

            if (PSEL && PENABLE) begin
                if (PWRITE) begin
                    PREADY <= 1'b1;
                    if (PSTRB[0]) mem[PADDR][ 7: 0] <= PWDATA[ 7: 0];
                    if (PSTRB[1]) mem[PADDR][15: 8] <= PWDATA[15: 8];
                    if (PSTRB[2]) mem[PADDR][23:16] <= PWDATA[23:16];
                    if (PSTRB[3]) mem[PADDR][31:24] <= PWDATA[31:24];
                end else begin
                    // --------------- Read ---------------
                    PREADY  <= 1'b1;
                    PRDATA1 <= mem[PADDR];  // registered read data
                end
            end
        end
    end

endmodule
