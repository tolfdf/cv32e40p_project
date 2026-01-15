`timescale 1ns/1ps

(* keep_hierarchy = "yes" *)
module cv32e40p_memory
    #(parameter ADDR_WIDTH = 17,
      parameter DATA_WIDTH = 32)
    (input logic                       clk_i,
     input logic                       rst_ni,

     input logic                       instr_req_i,      // en_a_i
     input logic  [ADDR_WIDTH-1:0]     instr_addr_i,
     output logic [DATA_WIDTH-1:0]     instr_rdata_o,
     output logic                      instr_rvalid_o,
     output logic                      instr_gnt_o,      // instr_req_i

     input logic                       data_req_i,
     input logic  [DATA_WIDTH-1:0]     data_addr_i,
     input logic                       data_we_i,
     input logic  [(DATA_WIDTH/8)-1:0] data_be_i,
     input logic  [DATA_WIDTH-1:0]     data_wdata_i,
     output logic [DATA_WIDTH-1:0]     data_rdata_o,
     output logic                      data_rvalid_o,
     output logic                      data_gnt_o,

     input logic [4:0]                 irq_id_i,
     input logic                       irq_ack_i,

     output logic                      irq_software_o,
     output logic                      irq_timer_o,
     output logic                      irq_external_o,
     output logic [15:0]               irq_fast_o,
     
     output logic                      uart_tx_o,

     output logic                      tests_passed_o,
     output logic                      tests_failed_o,
    `ifdef SIMULATION
        output logic [31:0]            exit_value_o,
     `else
        logic [31:0]                   exit_value_o,
    `endif
     output logic                      exit_valid_o);
    
    logic uart_tx_ready;
    logic uart_tx_fire;
    localparam FIFO_DEPTH = 16;
    localparam FIFO_W = 4; // log2(16)
    
    logic [7:0] uart_fifo [0:FIFO_DEPTH-1];
    logic [FIFO_W-1:0] wr_ptr, rd_ptr;
    logic [FIFO_W:0]   fifo_count;
    
        
    logic [ADDR_WIDTH-1:0] aligned_instr_addr;
    logic [ADDR_WIDTH-1:0] aligned_data_addr;
    assign aligned_instr_addr = instr_addr_i[ADDR_WIDTH-1:2];
    assign aligned_data_addr = data_addr_i[ADDR_WIDTH-1:2];
    
    //assert property (@(posedge clk_i) disable iff (~rst_ni) instr_addr_i[1:0] == 2'b0);
    //assert property (@(posedge clk_i) disable iff (~rst_ni) data_addr_i[1:0] == 2'b0);

    logic data_rvalid_q;
    logic instr_rvalid_q;
    logic data_rvalid_q1;
    logic instr_rvalid_q1;
 
    assign instr_gnt_o    = instr_req_i;
    assign data_gnt_o     = data_req_i;
    assign instr_rvalid_o = instr_rvalid_q;
    assign data_rvalid_o  = data_rvalid_q;


    logic uart_tx_fire_r;
    assign uart_tx_fire = ((fifo_count != 0) & uart_tx_ready) & ~uart_tx_fire_r;
    
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni)
            uart_tx_fire_r <= 1'b0;
        else
            uart_tx_fire_r <= (fifo_count != 0) & uart_tx_ready;
    end
    

       wire cpu_uart_wr =
        data_req_i & data_we_i & (data_addr_i == 32'h1000_0000);
    
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            wr_ptr     <= 0;
            rd_ptr     <= 0;
            fifo_count <= 0;
        end else begin
            // CPU writes
            if (cpu_uart_wr && fifo_count < FIFO_DEPTH) begin
                uart_fifo[wr_ptr] <= data_wdata_i[7:0];
                wr_ptr <= wr_ptr + 1;
                fifo_count <= fifo_count + 1;
            end
    
            // UART consumes
            if (uart_tx_fire) begin
                rd_ptr <= rd_ptr + 1;
                fifo_count <= fifo_count - 1;
            end
        end
    end
    
    uart_tx uart_tx_i (
    .clk_i      (clk_i),
    .rst_ni     (rst_ni),
    .tx_data_i  (uart_fifo[rd_ptr]),
    .tx_valid_i (uart_tx_fire),
    .tx_ready_o (uart_tx_ready),
    .uart_tx_o  (uart_tx_o)
);


    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (~rst_ni) begin
            data_rvalid_q  <= '0;
            instr_rvalid_q <= '0;
        end else begin
            data_rvalid_q  <= data_req_i;
            instr_rvalid_q <= instr_req_i;
        end
    end

 //FOR simulation
//    always_comb
//    begin
//        tests_passed_o      = '0;
//        tests_failed_o      = '0;
//        exit_value_o        = '0;
//        exit_valid_o        = '0;
//        // taken from example_tb/core/mm_ram.sv
//        if (data_req_i && data_we_i) begin
//            if (data_addr_i == 32'h2000_0000)
//            begin
//                if (data_wdata_i == 123456789)
//                    tests_passed_o = '1;
//                else if (data_wdata_i == 1)
//                    tests_failed_o = '1;
//            end
//            else if (data_addr_i == 32'h2000_0004)
//            begin
//                exit_valid_o = '1;
//                exit_value_o = data_wdata_i;
//            end
//            /*else if (data_addr_i == 32'h1000_0000) 
//            begin
//                //$display("data_addr_i == 32'h1000_0000 %t", $time);
//                $write("%c", data_wdata_i[7:0]);  
//                $fflush();  
//            end*/
//        end
//    end 


//        // For the .bit 
//        always_ff @(posedge clk_i or negedge rst_ni) begin
//          if (!rst_ni) begin
//            exit_valid_o   <= 1'b1; // LED OFF (active-low)
//            exit_value_o   <= 32'b0;
//            tests_passed_o <= 1'b0;
//            tests_failed_o <= 1'b0;
//          end else if (data_req_i && data_we_i) begin
//            case (data_addr_i)
//              32'h2000_0000: begin
//                if (data_wdata_i == 32'd123456789)
//                  tests_passed_o <= 1'b1;
//                else if (data_wdata_i == 32'd1)
//                  tests_failed_o <= 1'b1;
//              end
        
//              32'h2000_0004: begin
//                exit_valid_o <= 1'b0;       // LED ON forever
//                exit_value_o <= data_wdata_i;
//          end
//        endcase
//      end
//    end
 
        `ifdef SIMULATION
      // =========================
      // SIMULATION behavior
      // =========================
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          exit_valid_o   <= 1'b0;
          exit_value_o   <= 32'b0;
          tests_passed_o <= 1'b0;
          tests_failed_o <= 1'b0;
        end else if (data_req_i && data_we_i) begin
          case (data_addr_i)
            32'h2000_0000: begin
              if (data_wdata_i == 32'd123456789)
                tests_passed_o <= 1'b1;
              else if (data_wdata_i == 32'd1)
                tests_failed_o <= 1'b1;
            end
    
            32'h2000_0004: begin
              exit_valid_o <= 1'b1;      // ONE-CYCLE PULSE
              exit_value_o <= data_wdata_i;
            end
    
            default: exit_valid_o <= 1'b0;
          endcase
        end else begin
          exit_valid_o <= 1'b0;          // auto-clear pulse
        end
      end
    
    `else
      // =========================
      // FPGA behavior
      // =========================
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          exit_valid_o   <= 1'b1;        // LED ON after reset
          exit_value_o   <= 32'b0;
          tests_passed_o <= 1'b0;
          tests_failed_o <= 1'b0;
        end else if (data_req_i && data_we_i) begin
          case (data_addr_i)
            32'h2000_0000: begin
              if (data_wdata_i == 32'd123456789)
                tests_passed_o <= 1'b1;
              else if (data_wdata_i == 32'd1)
                tests_failed_o <= 1'b1;
            end
    
            32'h2000_0004: begin
              exit_valid_o <= 1'b0;       // LED OFF = done
              exit_value_o <= data_wdata_i;
            end
          endcase
        end
      end
    `endif
    
    
    fpga_tdp_ram
        #(.ADDR_WIDTH (ADDR_WIDTH),
          .DATA_WIDTH(DATA_WIDTH))
    fpga_tdp_ram_i
        (
         .clk_i     ( clk_i         ),
    
         .en_a_i    ( instr_req_i   ),      //instr_req_i
         .addr_a_i  ( instr_addr_i ),      //aligned_instr_addr    instr_addr_i
    
         .wdata_a_i ( '0            ),       // Not writing so ignored
         .rdata_a_o ( instr_rdata_o ),    //instr_rdata_o
         .we_a_i    ( '0            ),
         .be_a_i    ( 4'b1111       ),       // Always want 32-bits
    
         .en_b_i    ( data_req_i    ),      //data_req_i
         .addr_b_i  ( data_addr_i),       //aligned_data_addr    data_addr_i
         .wdata_b_i ( data_wdata_i  ),
         .rdata_b_o ( data_rdata_o  ),      //data_rdata_o
         .we_b_i    ( data_we_i     ),
         .be_b_i    ( data_be_i     ));

endmodule