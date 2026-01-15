`timescale 1ns/1ps


(* keep_hierarchy = "yes" *)
module fpga_tdp_ram
    #(parameter ADDR_WIDTH = 17,
      parameter DATA_WIDTH = 32)
    (
     input logic                       clk_i,
     input logic                       rst_ni,
     
     input logic                       en_a_i,
     input logic  [ADDR_WIDTH-1:0]     addr_a_i,
     input logic  [DATA_WIDTH-1:0]     wdata_a_i,
     output logic [DATA_WIDTH-1:0]     rdata_a_o,
     input logic                       we_a_i,
     input logic  [(DATA_WIDTH/8)-1:0] be_a_i,

     input logic                       en_b_i,
     input logic  [ADDR_WIDTH-1:0]     addr_b_i,
     input logic  [DATA_WIDTH-1:0]     wdata_b_i,
     output logic [DATA_WIDTH-1:0]     rdata_b_o,
     input logic                       we_b_i,
     input logic  [(DATA_WIDTH/8)-1:0] be_b_i);


    logic [(DATA_WIDTH/8)-1:0] wea_int;
    assign wea_int = we_a_i ? be_a_i : '0;

    logic [(DATA_WIDTH/8)-1:0] web_int;
    assign web_int = we_b_i ? be_b_i : '0;

    logic [ADDR_WIDTH-1:0]           addr_a_int;
    logic [ADDR_WIDTH-1:0]           addr_b_int;

    always_comb addr_a_int = addr_a_i[ADDR_WIDTH-1:2];
    always_comb addr_b_int = addr_b_i [ADDR_WIDTH-1:2];
    

/*localparam words = 2**(ADDR_WIDTH+$clog2(DATA_WIDTH/8));
logic [7:0] mem[words-1:0];

always_ff @(negedge rst_ni, posedge clk_i)
begin
    if(rst_ni == 1'b0)
    begin
        rdata_a_o <= '0;
    end
    else if(en_a_i)
    begin
        if(we_a_i)
        begin
            for(int i = 0; i < DATA_WIDTH/8; ++i)
            begin
                if(be_a_i[i])
                begin
                    mem[addr_a_i + i] <= wdata_a_i[8*i+:8];
                end
            end
        end else begin
            for(int i = 0; i < DATA_WIDTH/8; ++i)
            begin
                rdata_a_o[8*i+:8] <= mem[addr_a_i + i];
            end
        end
    end
end
always_ff @(negedge rst_ni, posedge clk_i)
begin
    if(rst_ni == 1'b0)
    begin
        rdata_b_o <= '0;
    end
    else if(en_b_i)
    begin
        if(we_b_i)
        begin
            for(int i = 0; i < DATA_WIDTH/8; ++i)
            begin
                if(be_b_i[i])
                begin
                    mem[addr_b_i + i] <= wdata_b_i[8*i+:8];
                end
            end
        end else begin
            for(int i = 0; i < DATA_WIDTH/8; ++i)
            begin
                rdata_b_o[8*i+:8] <= mem[addr_b_i + i];
            end
        end
    end
end*/

// taken from https://docs.xilinx.com/r/en-US/ug953-vivado-7series-libraries/BRAM_TDP_MACRO
/*BRAM_TDP_MACRO #(
   .BRAM_SIZE("36Kb"), // Target BRAM: "18Kb" or "36Kb"
   .DEVICE("7SERIES"), // Target device: "7SERIES"
   .DOA_REG(1),        // Optional port A output register (0 or 1)
   .DOB_REG(1),        // Optional port B output register (0 or 1)
   .INIT_A(36'h00000000), // Initial values on port A output port
   .INIT_B(36'h00000000), // Initial values on port B output port
   .INIT_FILE ("/home/egloffv/work/riscv/hard/risc-v-fault-injection/cv32e40p/example_tb/core/custom/hello_world.hex"),
   .READ_WIDTH_A (32),   // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
   .READ_WIDTH_B (32),   // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
   .SIM_COLLISION_CHECK ("ALL"), // Collision check enable "ALL", "WARNING_ONLY",
                                 //   "GENERATE_X_ONLY" or "NONE"
   .SRVAL_A(36'h00000000), // Set/Reset value for port A output
   .SRVAL_B(36'h00000000), // Set/Reset value for port B output
   .WRITE_MODE_A("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE"
   .WRITE_MODE_B("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE"
   .WRITE_WIDTH_A(32), // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
   .WRITE_WIDTH_B(32)  // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
) BRAM_TDP_MACRO_inst (
   .DOA(rdata_a_o),       // Output port-A data, width defined by READ_WIDTH_A parameter
   .DOB(rdata_b_o),       // Output port-B data, width defined by READ_WIDTH_B parameter
   .ADDRA(addr_a_i),   // Input port-A address, width defined by Port A depth
   .ADDRB(addr_b_i),   // Input port-B address, width defined by Port B depth
   .CLKA(clk_i),     // 1-bit input port-A clock
   .CLKB(clk_i),     // 1-bit input port-B clock
   .DIA(wdata_a_i),       // Input port-A data, width defined by WRITE_WIDTH_A parameter
   .DIB(wdata_b_i),       // Input port-B data, width defined by WRITE_WIDTH_B parameter
   .ENA(en_a_i),       // 1-bit input port-A enable
   .ENB(en_b_i),       // 1-bit input port-B enable
   .REGCEA(en_a_i), // 1-bit input port-A output register enable
   .REGCEB(en_b_i), // 1-bit input port-B output register enable
   .RSTA('0),     // 1-bit input port-A reset
   .RSTB('0),     // 1-bit input port-B reset
   .WEA(be_a_i),       // Input port-A write enable, width defined by Port A depth
   .WEB(be_b_i)        // Input port-B write enable, width defined by Port B depth
);*/
// Parameter usage table, organized as follows:
// +---------------------------------------------------------------------------------------------------------------------+
// | Parameter name       | Data type          | Restrictions, if applicable                                             |
// |---------------------------------------------------------------------------------------------------------------------|
// | Description                                                                                                         |
// +---------------------------------------------------------------------------------------------------------------------+
// +---------------------------------------------------------------------------------------------------------------------+
// | ADDR_WIDTH_A         | Integer            | Range: 1 - 20. Default value = 6.                                       |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the width of the port A address port addra, in bits.                                                        |
// | Must be large enough to access the entire memory from port A, i.e. &gt;= $clog2(MEMORY_SIZE/[WRITE|READ]_DATA_WIDTH_A).|
// +---------------------------------------------------------------------------------------------------------------------+
// | ADDR_WIDTH_B         | Integer            | Range: 1 - 20. Default value = 6.                                       |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the width of the port B address port addrb, in bits.                                                        |
// | Must be large enough to access the entire memory from port B, i.e. &gt;= $clog2(MEMORY_SIZE/[WRITE|READ]_DATA_WIDTH_B).|
// +---------------------------------------------------------------------------------------------------------------------+
// | AUTO_SLEEP_TIME      | Integer            | Range: 0 - 15. Default value = 0.                                       |
// |---------------------------------------------------------------------------------------------------------------------|
// | Number of clk[a|b] cycles to auto-sleep, if feature is available in architecture                                    |
// | 0 - Disable auto-sleep feature                                                                                      |
// | 3-15 - Number of auto-sleep latency cycles                                                                          |
// | Do not change from the value provided in the template instantiation                                                 |
// +---------------------------------------------------------------------------------------------------------------------+
// | BYTE_WRITE_WIDTH_A   | Integer            | Range: 1 - 4608. Default value = 32.                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | To enable byte-wide writes on port A, specify the byte width, in bits-                                              |
// | 8- 8-bit byte-wide writes, legal when WRITE_DATA_WIDTH_A is an integer multiple of 8                                |
// | 9- 9-bit byte-wide writes, legal when WRITE_DATA_WIDTH_A is an integer multiple of 9                                |
// | Or to enable word-wide writes on port A, specify the same value as for WRITE_DATA_WIDTH_A.                          |
// +---------------------------------------------------------------------------------------------------------------------+
// | BYTE_WRITE_WIDTH_B   | Integer            | Range: 1 - 4608. Default value = 32.                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | To enable byte-wide writes on port B, specify the byte width, in bits-                                              |
// | 8- 8-bit byte-wide writes, legal when WRITE_DATA_WIDTH_B is an integer multiple of 8                                |
// | 9- 9-bit byte-wide writes, legal when WRITE_DATA_WIDTH_B is an integer multiple of 9                                |
// | Or to enable word-wide writes on port B, specify the same value as for WRITE_DATA_WIDTH_B.                          |
// +---------------------------------------------------------------------------------------------------------------------+
// | CASCADE_HEIGHT       | Integer            | Range: 0 - 64. Default value = 0.                                       |
// |---------------------------------------------------------------------------------------------------------------------|
// | 0- No Cascade Height, Allow Vivado Synthesis to choose.                                                             |
// | 1 or more - Vivado Synthesis sets the specified value as Cascade Height.                                            |
// +---------------------------------------------------------------------------------------------------------------------+
// | CLOCKING_MODE        | String             | Allowed values: common_clock, independent_clock. Default value = common_clock.|
// |---------------------------------------------------------------------------------------------------------------------|
// | Designate whether port A and port B are clocked with a common clock or with independent clocks-                     |
// | "common_clock"- Common clocking; clock both port A and port B with clka                                             |
// | "independent_clock"- Independent clocking; clock port A with clka and port B with clkb                              |
// +---------------------------------------------------------------------------------------------------------------------+
// | ECC_BIT_RANGE        | String             | Default value = 7:0.                                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | This parameter is only used by synthesis. Specify the ECC bit range on the provided data.                           |
// | "7:0" - it specifies lower 8 bits are ECC bits.                                                                     |
// +---------------------------------------------------------------------------------------------------------------------+
// | ECC_MODE             | String             | Allowed values: no_ecc, both_encode_and_decode, decode_only, encode_only. Default value = no_ecc.|
// |---------------------------------------------------------------------------------------------------------------------|
// |                                                                                                                     |
// |   "no_ecc" - Disables ECC                                                                                           |
// |   "encode_only" - Enables ECC Encoder only                                                                          |
// |   "decode_only" - Enables ECC Decoder only                                                                          |
// |   "both_encode_and_decode" - Enables both ECC Encoder and Decoder                                                   |
// +---------------------------------------------------------------------------------------------------------------------+
// | ECC_TYPE             | String             | Allowed values: none, ECCHSIAO32-7, ECCHSIAO64-8, ECCHSIAO128-9, ECCH32-7, ECCH64-8. Default value = none.|
// |---------------------------------------------------------------------------------------------------------------------|
// | This parameter is only used by synthesis. Specify the algorithm used to generate the ecc bits outside the XPM Memory.|
// | XPM Memory does not performs ECC operation with this parameter.                                                     |
// |                                                                                                                     |
// |   "none" - No ECC                                                                                                   |
// |   "ECCH32-7" - 32 bit ECC Hamming algorithm is used                                                                 |
// |   "ECCH64-8" - 64 bit ECC Hamming algorithm is used                                                                 |
// |   "ECCHSIAO32-7" - 32 bit ECC HSIAO algorithm is used                                                               |
// |   "ECCHSIAO64-8" - 64 bit ECC HSIAO algorithm is used                                                               |
// |   "ECCHSIAO128-9" - 128 bit ECC HSIAO algorithm is used                                                             |
// +---------------------------------------------------------------------------------------------------------------------+
// | IGNORE_INIT_SYNTH    | Integer            | Range: 0 - 1. Default value = 0.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | 0 - Initiazation file if specified will applies for both simulation and synthesis                                   |
// | 1 - Initiazation file if specified will applies for only simulation and will ignore for synthesis                   |
// +---------------------------------------------------------------------------------------------------------------------+
// | MEMORY_INIT_FILE     | String             | Default value = none.                                                   |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify "none" (including quotes) for no memory initialization, or specify the name of a memory initialization file-|
// | Enter only the name of the file with .mem extension, including quotes but without path (e.g. "my_file.mem").        |
// | File format must be ASCII and consist of only hexadecimal values organized into the specified depth by              |
// | narrowest data width generic value of the memory. Initialization of memory happens through the file name specified only when parameter|
// | MEMORY_INIT_PARAM value is equal to "". |                                                                           |
// | When using XPM_MEMORY in a project, add the specified file to the Vivado project as a design source.                |
// +---------------------------------------------------------------------------------------------------------------------+
// | MEMORY_INIT_PARAM    | String             | Default value = 0.                                                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify "" or "0" (including quotes) for no memory initialization through parameter, or specify the string          |
// | containing the hex characters. Enter only hex characters with each location separated by delimiter (,).             |
// | Parameter format must be ASCII and consist of only hexadecimal values organized into the specified depth by         |
// | narrowest data width generic value of the memory.For example, if the narrowest data width is 8, and the depth of    |
// | memory is 8 locations, then the parameter value should be passed as shown below.                                    |
// | parameter MEMORY_INIT_PARAM = "AB,CD,EF,1,2,34,56,78"                                                               |
// | Where "AB" is the 0th location and "78" is the 7th location.                                                        |
// +---------------------------------------------------------------------------------------------------------------------+
// | MEMORY_OPTIMIZATION  | String             | Allowed values: true, false. Default value = true.                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify "true" to enable the optimization of unused memory or bits in the memory structure. Specify "false" to      |
// | disable the optimization of unused memory or bits in the memory structure.                                          |
// +---------------------------------------------------------------------------------------------------------------------+
// | MEMORY_PRIMITIVE     | String             | Allowed values: auto, block, distributed, mixed, ultra. Default value = auto.|
// |---------------------------------------------------------------------------------------------------------------------|
// | Designate the memory primitive (resource type) to use-                                                              |
// | "auto"- Allow Vivado Synthesis to choose                                                                            |
// | "distributed"- Distributed memory                                                                                   |
// | "block"- Block memory                                                                                               |
// | "ultra"- Ultra RAM memory                                                                                           |
// | "mixed"- Mixed memory                                                                                               |
// | NOTE: There may be a behavior mismatch if Block RAM or Ultra RAM specific features, like ECC or Asymmetry, are selected with MEMORY_PRIMITIVE set to "auto".|
// +---------------------------------------------------------------------------------------------------------------------+
// | MEMORY_SIZE          | Integer            | Range: 2 - 150994944. Default value = 2048.                             |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the total memory array size, in bits.                                                                       |
// | For example, enter 65536 for a 2kx32 RAM.                                                                           |
// | When ECC is enabled and set to "encode_only", then the memory size has to be multiples of READ_DATA_WIDTH_[A|B]     |
// | When ECC is enabled and set to "decode_only", then the memory size has to be multiples of WRITE_DATA_WIDTH_[A|B].   |
// +---------------------------------------------------------------------------------------------------------------------+
// | MESSAGE_CONTROL      | Integer            | Range: 0 - 1. Default value = 0.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify 1 to enable the dynamic message reporting such as collision warnings, and 0 to disable the message reporting|
// +---------------------------------------------------------------------------------------------------------------------+
// | RAM_DECOMP           | String             | Allowed values: auto, area, power. Default value = auto.                |
// |---------------------------------------------------------------------------------------------------------------------|
// |  Specifies the decomposition of the memory.                                                                         |
// |  "auto" - Synthesis selects default.                                                                                |
// |  "power" - Synthesis selects a strategy to reduce switching activity of RAMs and maps using widest configuration possible.|
// |  "area" - Synthesis selects a strategy to reduce RAM resource count.                                                |
// +---------------------------------------------------------------------------------------------------------------------+
// | READ_DATA_WIDTH_A    | Integer            | Range: 1 - 4608. Default value = 32.                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the width of the port A read data output port douta, in bits.                                               |
// | The values of READ_DATA_WIDTH_A and WRITE_DATA_WIDTH_A must be equal.                                               |
// | When ECC is enabled and set to "encode_only", then READ_DATA_WIDTH_A has to be multiples of 72-bits                 |
// | When ECC is enabled and set to "decode_only" or "both_encode_and_decode", then READ_DATA_WIDTH_A has to be          |
// | multiples of 64-bits.                                                                                               |
// +---------------------------------------------------------------------------------------------------------------------+
// | READ_DATA_WIDTH_B    | Integer            | Range: 1 - 4608. Default value = 32.                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the width of the port B read data output port doutb, in bits.                                               |
// | The values of READ_DATA_WIDTH_B and WRITE_DATA_WIDTH_B must be equal.                                               |
// | When ECC is enabled and set to "encode_only", then READ_DATA_WIDTH_B has to be multiples of 72-bits                 |
// | When ECC is enabled and set to "decode_only" or "both_encode_and_decode", then READ_DATA_WIDTH_B has to be          |
// | multiples of 64-bits.                                                                                               |
// +---------------------------------------------------------------------------------------------------------------------+
// | READ_LATENCY_A       | Integer            | Range: 0 - 100. Default value = 2.                                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the number of register stages in the port A read data pipeline. Read data output to port douta takes this   |
// | number of clka cycles.                                                                                              |
// | To target block memory, a value of 1 or larger is required- 1 causes use of memory latch only; 2 causes use of      |
// | output register. To target distributed memory, a value of 0 or larger is required- 0 indicates combinatorial output.|
// | Values larger than 2 synthesize additional flip-flops that are not retimed into memory primitives.                  |
// +---------------------------------------------------------------------------------------------------------------------+
// | READ_LATENCY_B       | Integer            | Range: 0 - 100. Default value = 2.                                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the number of register stages in the port B read data pipeline. Read data output to port doutb takes this   |
// | number of clkb cycles (clka when CLOCKING_MODE is "common_clock").                                                  |
// | To target block memory, a value of 1 or larger is required- 1 causes use of memory latch only; 2 causes use of      |
// | output register. To target distributed memory, a value of 0 or larger is required- 0 indicates combinatorial output.|
// | Values larger than 2 synthesize additional flip-flops that are not retimed into memory primitives.                  |
// +---------------------------------------------------------------------------------------------------------------------+
// | READ_RESET_VALUE_A   | String             | Default value = 0.                                                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the reset value of the port A final output register stage in response to rsta input port is assertion.      |
// | As this parameter is a string, please specify the hex values inside double quotes. As an example,                   |
// | If the read data width is 8, then specify READ_RESET_VALUE_A = "EA";                                                |
// | When ECC is enabled, then reset value is not supported.                                                             |
// +---------------------------------------------------------------------------------------------------------------------+
// | READ_RESET_VALUE_B   | String             | Default value = 0.                                                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the reset value of the port B final output register stage in response to rstb input port is assertion.      |
// | As this parameter is a string, please specify the hex values inside double quotes. As an example,                   |
// | If the read data width is 8, then specify READ_RESET_VALUE_B = "EA";                                                |
// | When ECC is enabled, then reset value is not supported.                                                             |
// +---------------------------------------------------------------------------------------------------------------------+
// | RST_MODE_A           | String             | Allowed values: SYNC, ASYNC. Default value = SYNC.                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Describes the behaviour of the reset                                                                                |
// |                                                                                                                     |
// |   "SYNC" - when reset is applied, synchronously resets output port douta to the value specified by parameter READ_RESET_VALUE_A|
// |   "ASYNC" - when reset is applied, asynchronously resets output port douta to zero                                  |
// +---------------------------------------------------------------------------------------------------------------------+
// | RST_MODE_B           | String             | Allowed values: SYNC, ASYNC. Default value = SYNC.                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Describes the behaviour of the reset                                                                                |
// |                                                                                                                     |
// |   "SYNC" - when reset is applied, synchronously resets output port doutb to the value specified by parameter READ_RESET_VALUE_B|
// |   "ASYNC" - when reset is applied, asynchronously resets output port doutb to zero                                  |
// +---------------------------------------------------------------------------------------------------------------------+
// | SIM_ASSERT_CHK       | Integer            | Range: 0 - 1. Default value = 0.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | 0- Disable simulation message reporting. Messages related to potential misuse will not be reported.                 |
// | 1- Enable simulation message reporting. Messages related to potential misuse will be reported.                      |
// +---------------------------------------------------------------------------------------------------------------------+
// | USE_EMBEDDED_CONSTRAINT| Integer            | Range: 0 - 1. Default value = 0.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify 1 to enable the set_false_path constraint addition between clka of Distributed RAM and doutb_reg on clkb    |
// +---------------------------------------------------------------------------------------------------------------------+
// | USE_MEM_INIT         | Integer            | Range: 0 - 1. Default value = 1.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify 1 to enable the generation of below message and 0 to disable generation of the following message completely.|
// | "INFO - MEMORY_INIT_FILE and MEMORY_INIT_PARAM together specifies no memory initialization.                         |
// | Initial memory contents will be all 0s."                                                                            |
// | NOTE: This message gets generated only when there is no Memory Initialization specified either through file or      |
// | Parameter.                                                                                                          |
// +---------------------------------------------------------------------------------------------------------------------+
// | USE_MEM_INIT_MMI     | Integer            | Range: 0 - 1. Default value = 0.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify 1 to expose this memory information to be written out in the MMI file.                                      |
// +---------------------------------------------------------------------------------------------------------------------+
// | WAKEUP_TIME          | String             | Allowed values: disable_sleep, use_sleep_pin. Default value = disable_sleep.|
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify "disable_sleep" to disable dynamic power saving option, and specify "use_sleep_pin" to enable the           |
// | dynamic power saving option                                                                                         |
// +---------------------------------------------------------------------------------------------------------------------+
// | WRITE_DATA_WIDTH_A   | Integer            | Range: 1 - 4608. Default value = 32.                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the width of the port A write data input port dina, in bits.                                                |
// | The values of WRITE_DATA_WIDTH_A and READ_DATA_WIDTH_A must be equal.                                               |
// | When ECC is enabled and set to "encode_only" or "both_encode_and_decode", then WRITE_DATA_WIDTH_A has to be         |
// | multiples of 64-bits                                                                                                |
// | When ECC is enabled and set to "decode_only", then WRITE_DATA_WIDTH_A has to be multiples of 72-bits.               |
// +---------------------------------------------------------------------------------------------------------------------+
// | WRITE_DATA_WIDTH_B   | Integer            | Range: 1 - 4608. Default value = 32.                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the width of the port B write data input port dinb, in bits.                                                |
// | The values of WRITE_DATA_WIDTH_B and READ_DATA_WIDTH_B must be equal.                                               |
// | When ECC is enabled and set to "encode_only" or "both_encode_and_decode", then WRITE_DATA_WIDTH_B has to be         |
// | multiples of 64-bits                                                                                                |
// | When ECC is enabled and set to "decode_only", then WRITE_DATA_WIDTH_B has to be multiples of 72-bits.               |
// +---------------------------------------------------------------------------------------------------------------------+
// | WRITE_MODE_A         | String             | Allowed values: no_change, read_first, write_first. Default value = no_change.|
// |---------------------------------------------------------------------------------------------------------------------|
// | Write mode behavior for port A output data port, douta.                                                             |
// +---------------------------------------------------------------------------------------------------------------------+
// | WRITE_MODE_B         | String             | Allowed values: no_change, read_first, write_first. Default value = no_change.|
// |---------------------------------------------------------------------------------------------------------------------|
// | Write mode behavior for port B output data port, doutb.                                                             |
// +---------------------------------------------------------------------------------------------------------------------+
// | WRITE_PROTECT        | Integer            | Range: 0 - 1. Default value = 1.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | Default value is 1, means write is protected through enable and write enable and hence the LUT is placed before the memory. This is the default behaviour to access memory.|
// | When 0, disables write protection. Write enable (WE) directly connected to memory.                                  |
// | NOTE: Disable this option only if the advanced users can guarantee that the write enable (WE) cannot be given without enable (EN).|
// +---------------------------------------------------------------------------------------------------------------------+

   xpm_memory_tdpram #(
      .ADDR_WIDTH_A(ADDR_WIDTH),      // DECIMAL
      .ADDR_WIDTH_B(ADDR_WIDTH),      // DECIMAL
      .AUTO_SLEEP_TIME(0),            // DECIMAL
      .BYTE_WRITE_WIDTH_A(8),// DECIMAL
      .BYTE_WRITE_WIDTH_B(8),// DECIMAL
      .CASCADE_HEIGHT(0),             // DECIMAL
      .CLOCKING_MODE("common_clock"), // String
      //.ECC_BIT_RANGE("7:0"),          // String
      .ECC_MODE("no_ecc"),            // String
      //.ECC_TYPE("none"),              // String
      //.IGNORE_INIT_SYNTH(0),          // DECIMAL
      .MEMORY_INIT_FILE ("core/custom/hello.mem"),      // String
      //.MEMORY_INIT_FILE("none"),
      .MEMORY_INIT_PARAM("0"),        // String
      .MEMORY_OPTIMIZATION("true"),   // String
      .MEMORY_PRIMITIVE("block"),      // String: Allowed values: auto, block, distributed, mixed, ultra. Default value = auto.
      .MEMORY_SIZE((2**ADDR_WIDTH) * DATA_WIDTH),           // DECIMAL: Specify the total memory array size, in bits. For example, enter 65536 for a 2kx32 RAM.
      .MESSAGE_CONTROL(0),            // DECIMAL
      //.RAM_DECOMP("auto"),            // String
      .READ_DATA_WIDTH_A(DATA_WIDTH),         // DECIMAL
      .READ_DATA_WIDTH_B(DATA_WIDTH),         // DECIMAL
      .READ_LATENCY_A(1),             // DECIMAL
      .READ_LATENCY_B(1),             // DECIMAL
      .READ_RESET_VALUE_A("0"),       // String
      .READ_RESET_VALUE_B("0"),       // String
      .RST_MODE_A("SYNC"),            // String
      .RST_MODE_B("SYNC"),            // String
      .SIM_ASSERT_CHK(1),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
      .USE_MEM_INIT(1),               // DECIMAL
     // .USE_MEM_INIT_MMI(0),           // DECIMAL
      .WAKEUP_TIME("disable_sleep"),  // String
      .WRITE_DATA_WIDTH_A(DATA_WIDTH),        // DECIMAL
      .WRITE_DATA_WIDTH_B(DATA_WIDTH),        // DECIMAL
      .WRITE_MODE_A("read_first"),     // String: Allowed values: no_change, read_first, write_first. Default value = no_change.
      .WRITE_MODE_B("read_first")     // String
      //.WRITE_PROTECT(1)               // DECIMAL
   )
   xpm_memory_tdpram_inst (
      .dbiterra(),             // 1-bit output: Status signal to indicate double bit error occurrence
                                       // on the data output of port A.

      .dbiterrb(),             // 1-bit output: Status signal to indicate double bit error occurrence
                                       // on the data output of port A.

      .douta(rdata_a_o),                   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
      .doutb(rdata_b_o),                   // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
      .sbiterra(),             // 1-bit output: Status signal to indicate single bit error occurrence
                                       // on the data output of port A.

      .sbiterrb(),             // 1-bit output: Status signal to indicate single bit error occurrence
                                       // on the data output of port B.

      .addra(addr_a_int),                   // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
      .addrb(addr_b_int),                   // ADDR_WIDTH_B-bit input: Address for port B write and read operations.
      .clka(clk_i),                     // 1-bit input: Clock signal for port A. Also clocks port B when
                                       // parameter CLOCKING_MODE is "common_clock".

      .clkb(clk_i),                     // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
                                       // "independent_clock". Unused when parameter CLOCKING_MODE is
                                       // "common_clock".

      .dina(wdata_a_i),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      .dinb(wdata_b_i),                     // WRITE_DATA_WIDTH_B-bit input: Data input for port B write operations.
      .ena(en_a_i),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
                                       // cycles when read or write operations are initiated. Pipelined
                                       // internally.

      .enb(en_b_i),                       // 1-bit input: Memory enable signal for port B. Must be high on clock
                                       // cycles when read or write operations are initiated. Pipelined
                                       // internally.

      .injectdbiterra('0), // 1-bit input: Controls double bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .injectdbiterrb('0), // 1-bit input: Controls double bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .injectsbiterra('0), // 1-bit input: Controls single bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .injectsbiterrb('0), // 1-bit input: Controls single bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .regcea(en_a_i),                 // 1-bit input: Clock Enable for the last register stage on the output
                                       // data path.

      .regceb(en_b_i),                 // 1-bit input: Clock Enable for the last register stage on the output
                                       // data path.

      .rsta('0),                     // 1-bit input: Reset signal for the final port A output register stage.
                                       // Synchronously resets output port douta to the value specified by
                                       // parameter READ_RESET_VALUE_A.

      .rstb('0),                     // 1-bit input: Reset signal for the final port B output register stage.
                                       // Synchronously resets output port doutb to the value specified by
                                       // parameter READ_RESET_VALUE_B.

      .sleep('0),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
      .wea(wea_int),                       // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
                                       // for port A input data port dina. 1 bit wide when word-wide writes are
                                       // used. In byte-wide write configurations, each bit controls the
                                       // writing one byte of dina to address addra. For example, to
                                       // synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A
                                       // is 32, wea would be 4'b0010.

      .web(web_int)                        // WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B-bit input: Write enable vector
                                       // for port B input data port dinb. 1 bit wide when word-wide writes are
                                       // used. In byte-wide write configurations, each bit controls the
                                       // writing one byte of dinb to address addrb. For example, to
                                       // synchronously write only bits [15-8] of dinb when WRITE_DATA_WIDTH_B
                                       // is 32, web would be 4'b0010.

   );

   // End of xpm_memory_tdpram_inst instantiation
				


endmodule
