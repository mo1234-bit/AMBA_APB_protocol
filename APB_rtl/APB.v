// =============================================================================
// APB Top-Level Module
// =============================================================================
module APB(
    PCLK, PRESETn, transfer, READ_WRITE,
    apb_write_paddr, apb_write_data, apb_read_paddr,
    PSLVERR, apb_read_data_out
);

    input  PCLK, PRESETn, transfer, READ_WRITE;
    input  [31:0] apb_write_paddr;
    input  [31:0] apb_write_data;
    input  [31:0] apb_read_paddr;
    output PSLVERR;
    output [31:0] apb_read_data_out;

    // Internal wires
    wire [31:0] PRDATA;
    wire [31:0] PRDATA1, PRDATA2;
    wire [31:0] PWDATA;
    wire [31:0] PADDR;
    wire [2:0]  PPROT;              // APB3 protection signal
    wire [3:0]  PSTRB;             // APB4 write strobes
    wire        PREADY, PREADY1, PREADY2;
    wire        PENABLE;
    wire        PSEL1, PSEL2;
    wire        PWRITE;
    wire        PSLVERR1, PSLVERR2; // Slave error signals

    // Mux PREADY and PRDATA based on which slave is selected (bit[8] of PADDR)
    assign PREADY = PADDR[8] ? PREADY1 : PREADY2;
    assign PRDATA = PADDR[8] ? PRDATA1 : PRDATA2;

 
    // The master_bridge drives its own PSLVERR;
    wire PSLVERR_master;
    assign PSLVERR = PSLVERR_master | (PADDR[8] ? PSLVERR1 : PSLVERR2);

    // Master Bridge
    master_bridge dut (
        .apb_write_paddr  (apb_write_paddr),
        .apb_read_paddr   (apb_read_paddr),
        .apb_write_data   (apb_write_data),
        .PRDATA           (PRDATA),
        .PRESETn          (PRESETn),
        .PCLK             (PCLK),
        .READ_WRITE       (READ_WRITE),
        .transfer         (transfer),
        .PREADY           (PREADY),
        .PSEL1            (PSEL1),
        .PSEL2            (PSEL2),
        .PENABLE          (PENABLE),
        .PADDR            (PADDR),
        .PPROT            (PPROT),
        .PSTRB            (PSTRB),
        .PWRITE           (PWRITE),
        .PWDATA           (PWDATA),
        .apb_read_data_out(apb_read_data_out),
        .PSLVERR          (PSLVERR_master)
    );

    // Slave 1  
    Slave1 dut1 (
        .PCLK    (PCLK),
        .PRSTn   (PRESETn),   
        .PSEL    (PSEL1),
        .PENABLE (PENABLE),
        .PWRITE  (PWRITE),
        .PADDR   (PADDR[7:0]),
        .PWDATA  (PWDATA[7:0]),
        .PSTRB   (PSTRB),
        .PRDATA1 (PRDATA1),
        .PREADY  (PREADY1),
        .PSLVERR (PSLVERR1)
    );

    // Slave 2
    Slave2 dut2 (
        .PCLK    (PCLK),
        .PRSTn   (PRESETn),  
        .PSEL    (PSEL2),
        .PENABLE (PENABLE),
        .PWRITE  (PWRITE),
        .PADDR   (PADDR[7:0]),
        .PWDATA  (PWDATA[7:0]),
        .PSTRB   (PSTRB),
        .PRDATA2 (PRDATA2),
        .PREADY  (PREADY2),
        .PSLVERR (PSLVERR2)
    );

endmodule
