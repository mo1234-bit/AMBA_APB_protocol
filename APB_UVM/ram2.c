#include <stdio.h>
#include <stdint.h>

#define MEM_DEPTH 256

// Slave1 state
static uint8_t mem[MEM_DEPTH];
static uint8_t adder = 0;
static uint8_t PREADY = 0;
static uint8_t PRDATA2 = 0;

// DPI-C function for Slave1 simulation
void slave2_sim(int PCLK, int PRESETn, int PSEL, 
                int PENABLE, int PWRITE, int PADDR, 
                int PWDATA) {
    
    // Only execute on PCLK high (posedge handled by Verilog)
    if (PCLK) {
        if (!PRESETn) {
            // Reset
            PREADY = 0;
            PRDATA2 = 0;  // Clear on reset
        }
        else if (PENABLE && PSEL && PWRITE) {
            // Write operation
            PREADY = 1;
            if (PADDR < MEM_DEPTH) {
                mem[PADDR & 0xFF] = PWDATA & 0xFF;
            }
             
        }
        else if (PENABLE && PSEL && !PWRITE) {
            // Read operation
            PREADY = 1;
            adder = PADDR & 0xFF;
            PRDATA2 = mem[adder];  // Update PRDATA only during read
        }
        else {
            PREADY =0 ;
            PRDATA2 = PRDATA2;  // Clear when idle
        }
    }
}

// Getter function for PRDATA1
int get_PRDATA2_int() {
    return (int)PRDATA2;
}

// Getter function for PREADY
int get_PREADY2_int() {
    return (int)PREADY;
}

// Optional: Memory initialization (call once at start)
void slave2_init() {
    for (int i = 0; i < MEM_DEPTH; i++) {
        mem[i] = 0;
    }
    adder = 0;
    PREADY = 0;
    PRDATA2 = 0;
}