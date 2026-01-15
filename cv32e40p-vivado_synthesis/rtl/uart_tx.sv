`timescale 1ns/1ps

module uart_tx (
    input  logic clk_i,
    input  logic rst_ni,

    input  logic [7:0] tx_data_i,
    input  logic       tx_valid_i,
    output logic       tx_ready_o,

    output logic       uart_tx_o
);
    
      `ifdef SIMULATION
        // 20 MHz 
        localparam int BAUD_DIV = 173;
    `else
        // 100 MHz 
        localparam int BAUD_DIV = 868;
    `endif
    
    logic [7:0]  shift_reg;
    logic [3:0]  bit_cnt;
    logic [15:0] baud_cnt;
    logic        busy;

    logic tx_valid_d;

    assign tx_ready_o = ~busy;

    // detect rising edge of tx_valid
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni)
            tx_valid_d <= 1'b0;
        else
            tx_valid_d <= tx_valid_i;
    end

    wire tx_fire = tx_valid_i & ~tx_valid_d & tx_ready_o;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            uart_tx_o <= 1'b1;
            busy      <= 1'b0;
            bit_cnt   <= 0;
            baud_cnt  <= 0;
            shift_reg <= 0;
        end else begin
            if (!busy) begin
                if (tx_fire) begin
                    busy      <= 1'b1;
                    shift_reg <= tx_data_i;
                    bit_cnt   <= 0;
                    baud_cnt  <= BAUD_DIV - 1;
                    uart_tx_o <= 1'b0;   // start bit
                end
            end else begin
                if (baud_cnt == 0) begin
                    baud_cnt <= BAUD_DIV - 1;

                    if (bit_cnt < 8) begin
                        uart_tx_o <= shift_reg[0];
                        shift_reg <= shift_reg >> 1;
                        bit_cnt   <= bit_cnt + 1;
                    end else if (bit_cnt == 8) begin
                        uart_tx_o <= 1'b1; // stop bit
                        bit_cnt   <= bit_cnt + 1;
                    end else begin
                        busy <= 1'b0;
                    end
                end else begin
                    baud_cnt <= baud_cnt - 1;
                end
            end
        end
    end

endmodule
