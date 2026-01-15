//------------------------------------------------------------------------------
// Generic Clock Gate
//------------------------------------------------------------------------------
// Implements standard latch-based clock gating:
//   - Latches enable on the *inactive* phase of the clock
//   - ANDs the latched enable with clock to produce gated clock
//   - scan_cg_en_i forces clock ON during scan/test
//
// Notes:
//   * Safe for synthesis (all major tools infer a clock-gating cell)
//   * Recommended style for ASIC flows
//------------------------------------------------------------------------------

module cv32e40p_clock_gate (
    input  logic clk_i,        // Ungated clock
    input  logic en_i,         // Functional clock enable
    input  logic scan_cg_en_i, // Scan/test override (forces enable = 1)
    output logic clk_o         // Gated clock
);

    logic en_latched;

    // Latch the enable when clock is low (transparent latch)
    always_latch begin
        if (!clk_i) begin
            // When scan is enabled, force clock on
            en_latched <= en_i | scan_cg_en_i;
        end
    end

    // Gate the clock
    assign clk_o = clk_i & en_latched;

endmodule
