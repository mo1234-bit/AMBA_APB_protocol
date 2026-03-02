module master_bridge (
    // Non-APB control inputs
    apb_write_paddr, apb_read_paddr, apb_write_data,
    PRESETn, PCLK, READ_WRITE, transfer,
    pprot_in, pstrb_in,

    // APB slave-side inputs
    PRDATA, PREADY,

    // APB slave-side outputs
    PSEL1, PSEL2, PENABLE,
    PADDR, PWRITE, PWDATA,
    PPROT, PSTRB,

    // Result outputs
    apb_read_data_out, PSLVERR
);

    // -------------------------------------------------------------------------
    // Parameters
    // -------------------------------------------------------------------------
    parameter IDLE   = 2'd0;
    parameter SETUP  = 2'd1;
    parameter ACCESS = 2'd2;

    // -------------------------------------------------------------------------
    // Ports
    // -------------------------------------------------------------------------
    input  [31:0] apb_write_paddr, apb_read_paddr;
    input  [31:0] apb_write_data;
    input  [31:0] PRDATA;
    input         PRESETn, PCLK, READ_WRITE, transfer, PREADY;
    input  [2:0]  pprot_in;   // Protection type from requester
    input  [3:0]  pstrb_in;   // Write strobes from requester

    output        PSEL1, PSEL2;
    output reg    PENABLE;
    output reg [31:0] PADDR;
    output reg    PWRITE;
    output reg [31:0] PWDATA;
    output [2:0]  PPROT;
    output [3:0]  PSTRB;
    output reg [31:0] apb_read_data_out;
    output        PSLVERR;

    // -------------------------------------------------------------------------
    // Internal signals
    // -------------------------------------------------------------------------
    (* fsm_encoding = "one_hot" *)
    reg [1:0] ns, cs;

    // Error / PSLVERR detection
    reg setup_error;
    reg invalid_read_paddr;
    reg invalid_write_paddr;
    reg invalid_write_data;

    // APB4: PPROT and PSTRB pass-through (driven by requester)
    assign PPROT = pprot_in;
    // PSTRB only valid during write; zero during reads per spec
    assign PSTRB = PWRITE ? pstrb_in : 4'b0000;

    // =========================================================================
    // State register
    // =========================================================================
    always @(posedge PCLK or negedge PRESETn) begin
        if (~PRESETn)
            cs <= IDLE;
        else
            cs <= ns;
    end

    // =========================================================================
    // Next-state + combinatorial output logic
    // =========================================================================
    always @(*) begin
        // Defaults
        ns      = cs;
        PENABLE = 1'b0;

        case (cs)
            // -----------------------------------------------------------------
            IDLE: begin
                PENABLE = 1'b0;
                if (transfer && !PSLVERR)
                    ns = SETUP;
                else
                    ns = IDLE;
            end

           
            SETUP: begin
                PENABLE = 1'b0;
                if (PSLVERR)
                    ns = IDLE;
                else
                    ns = ACCESS;  
            end

        
            ACCESS: begin
                PENABLE = 1'b1;
                if (PSLVERR) begin
                    ns = IDLE;
                end else if (PREADY) begin
                    // Transfer complete
                    if (transfer)
                        ns = SETUP;  // Back-to-back transfer
                    else
                        ns = IDLE;
                end else begin
                    ns = ACCESS;     // Wait state — slave not ready
                end
            end

            // -----------------------------------------------------------------
            default: begin
                ns      = IDLE;
                PENABLE = 1'b0;
            end
        endcase
    end

   
    always @(posedge PCLK or negedge PRESETn) begin
        if (~PRESETn)
            PWRITE <= 1'b0;
        else if (cs == IDLE && ns == SETUP)  // About to enter SETUP
            PWRITE <= ~READ_WRITE;
        // Hold value through ACCESS (stable per APB spec)
    end

    // =========================================================================
    // Address / data capture — registered in SETUP
    // =========================================================================
    always @(posedge PCLK or negedge PRESETn) begin
        if (~PRESETn) begin
            PADDR              <= 32'd0;
            PWDATA             <= 32'd0;
            apb_read_data_out  <= 32'd0;
        end else begin
            // Latch address/data when entering SETUP
            if (cs == SETUP) begin
                if (READ_WRITE) begin
                    // Read transfer
                    PADDR <= apb_read_paddr;
                end else begin
                    // Write transfer
                    PADDR  <= apb_write_paddr;
                    PWDATA <= apb_write_data;
                end
            end

            // Capture read data when transfer completes
            if (cs == ACCESS && PREADY && READ_WRITE && !PSLVERR)
                apb_read_data_out <= PRDATA;
        end
    end

   
    assign PSEL1 = ((cs == SETUP || cs == ACCESS) && PADDR[8] == 1'b1) ? 1'b1 : 1'b0;
    assign PSEL2 = ((cs == SETUP || cs == ACCESS) && PADDR[8] == 1'b0) ? 1'b1 : 1'b0;


    always @(*) begin
        // Illegal state transition: skipped SETUP (should never happen with
        // corrected FSM, but kept as a safety net)
        setup_error = (cs == IDLE && ns == ACCESS);

        // Write with X data
        invalid_write_data  = (apb_write_data === 32'dx) &&
                               (~READ_WRITE) &&
                               (cs == SETUP || cs == ACCESS);

        // Read with X address
        invalid_read_paddr  = (apb_read_paddr === 32'dx) &&
                               READ_WRITE &&
                               (cs == SETUP || cs == ACCESS);

        // Write with X address
        invalid_write_paddr = (apb_write_paddr === 32'dx) &&
                               (~READ_WRITE) &&
                               (cs == SETUP || cs == ACCESS);
    end

    assign PSLVERR = (setup_error | invalid_write_data |
                      invalid_write_paddr | invalid_read_paddr) ? 1'b1 : 1'b0;

endmodule
