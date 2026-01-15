# Copyright 2020 Silicon Labs, Inc.
#
# This file, and derivatives thereof are licensed under the
# Solderpad License, Version 2.0 (the "License").
#
# Use of this file means you agree to the terms and conditions
# of the license and are in full compliance with the License.
#
# You may obtain a copy of the License at:
#
#     https://solderpad.org/licenses/SHL-2.0/
#
# Unless required by applicable law or agreed to in writing, software
# and hardware implementations thereof distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS
# OF ANY KIND, EITHER EXPRESSED OR IMPLIED.
#
# See the License for the specific language governing permissions and
# limitations under the License.

#//////////////////////////////////////////////////////////////////////////////
# Engineer:       Arjan Bink - arjan.bink@silabs.com                         //
#                                                                            //
# Project Name:   CV32E40P                                                   //
#                                                                            //
# Description:    Example synthesis constraints.                             //
#                                                                            //
#                 The clock period and input/output delays are technology    //
#                 and project dependent and are expected to be adjusted as   //
#                 needed.                                                    //
#                                                                            //
#                 OBI related bus inputs arrive late on purpose and OBI      //
#                 related outputs are available earlier (as they shall not   //
#                 combinatorially depend on the OBI inputs)                  //
#                                                                            //
#//////////////////////////////////////////////////////////////////////////////

# 20MHz
set clock_period 50.0

# Input delays for interrupts
set in_delay_irq          [expr $clock_period * 0.50] 
# Output delays for interrupt related signals
set out_delay_irq         [expr $clock_period * 0.25] 

# Input delays for early signals
set in_delay_early [expr $clock_period * 0.10] 

# OBI inputs delays
set in_delay_instr_gnt    [expr $clock_period * 0.80]
set in_delay_instr_rvalid [expr $clock_period * 0.80]
set in_delay_instr_rdata  [expr $clock_period * 0.80]

set in_delay_data_gnt     [expr $clock_period * 0.80]
set in_delay_data_rvalid  [expr $clock_period * 0.80]
set in_delay_data_rdata   [expr $clock_period * 0.80]

# OBI outputs delays
set out_delay_instr_req  [expr $clock_period * 0.60]
set out_delay_instr_addr [expr $clock_period * 0.60]

set out_delay_data_req   [expr $clock_period * 0.60]
set out_delay_data_we    [expr $clock_period * 0.60]
set out_delay_data_be    [expr $clock_period * 0.60]
set out_delay_data_addr  [expr $clock_period * 0.60]
set out_delay_data_wdata [expr $clock_period * 0.60]

# I/O delays for non RISC-V Bus Interface ports
set in_delay_other       [expr $clock_period * 0.10]
set out_delay_other      [expr $clock_period * 0.60]

# core_sleep_o output delay
set out_delay_core_sleep [expr $clock_period * 0.25]

# All clocks
set clock_ports [list \
    clk_i \
]

# IRQ Input ports
##set irq_input_ports [remove_from_collection [get_ports irq_i*] [get_ports irq_id_o*]]
##set irq_input_ports "irq_i[31] irq_i[30] irq_i[29] irq_i[28] irq_i[27] irq_i[26] irq_i[25] irq_i[24] irq_i[23] irq_i[22] irq_i[21] irq_i[20] irq_i[19] irq_i[18] irq_i[17] irq_i[16] irq_i[15] irq_i[14] irq_i[13] irq_i[12] irq_i[11] irq_i[10] irq_i[9] irq_i[8] irq_i[7] irq_i[6] irq_i[5] irq_i[4] irq_i[3] irq_i[2] irq_i[1] irq_i[0]"

# IRQ Output ports
##set irq_output_ports [list \
##  irq_ack_o \
##  irq_id_o* \
##]

# Early Input ports (ideally from register)
##set early_input_ports [list \
##  debug_req_i \
##]

# RISC-V OBI Input ports
##set obi_input_ports [list \
##  instr_gnt_i \
##  instr_rvalid_i \
##  instr_rdata_i* \
##  data_gnt_i \
##  data_rvalid_i \
##  data_rdata_i* \
##]

# RISC-V OBI Output ports
##set obi_output_ports [list \
##  instr_req_o \
##  instr_addr_o* \
##  data_req_o \
##  data_we_o \
##  data_be_o* \
##  data_addr_o* \
##  data_wdata_o* \
##]

# RISC-V Sleep Output ports
##set sleep_output_ports [list \
##  core_sleep_o \
##]

############## Defining default clock definitions ##############

create_clock \
      -name clk_i \
      -period $clock_period \
      [get_ports clk_i] 


########### Defining Default I/O constraints ###################

set all_clock_ports $clock_ports

##set all_other_input_ports  [remove_from_collection [all_inputs]  [get_ports "$all_clock_ports $obi_input_ports $irq_input_ports $early_input_ports"]]
##set all_other_input_ports "apu_flags_i[0] apu_flags_i[1] apu_flags_i[2] apu_flags_i[3] apu_flags_i[4] apu_gnt_i apu_result_i[0] apu_result_i[10] apu_result_i[11] apu_result_i[12] apu_result_i[13] apu_result_i[14] apu_result_i[15] apu_result_i[16] apu_result_i[17] apu_result_i[18] apu_result_i[19] apu_result_i[1] apu_result_i[20] apu_result_i[21] apu_result_i[22] apu_result_i[23] apu_result_i[24] apu_result_i[25] apu_result_i[26] apu_result_i[27] apu_result_i[28] apu_result_i[29] apu_result_i[2] apu_result_i[30] apu_result_i[31] apu_result_i[3] apu_result_i[4] apu_result_i[5] apu_result_i[6] apu_result_i[7] apu_result_i[8] apu_result_i[9] apu_rvalid_i fetch_enable_i pulp_clock_en_i rst_ni scan_cg_en_i"
##set all_other_output_ports [remove_from_collection [all_outputs] [get_ports "$all_clock_ports $obi_output_ports $sleep_output_ports $irq_output_ports"]]
##set all_other_output_ports "apu_flags_o[0] apu_flags_o[10] apu_flags_o[11] apu_flags_o[12] apu_flags_o[13] apu_flags_o[14] apu_flags_o[1] apu_flags_o[2] apu_flags_o[3] apu_flags_o[4] apu_flags_o[5] apu_flags_o[6] apu_flags_o[7] apu_flags_o[8] apu_flags_o[9] apu_op_o[0] apu_op_o[1] apu_op_o[2] apu_op_o[3] apu_op_o[4] apu_op_o[5] apu_operands_o[0][0] apu_operands_o[0][10] apu_operands_o[0][11] apu_operands_o[0][12] apu_operands_o[0][13] apu_operands_o[0][14] apu_operands_o[0][15] apu_operands_o[0][16] apu_operands_o[0][17] apu_operands_o[0][18] apu_operands_o[0][19] apu_operands_o[0][1] apu_operands_o[0][20] apu_operands_o[0][21] apu_operands_o[0][22] apu_operands_o[0][23] apu_operands_o[0][24] apu_operands_o[0][25] apu_operands_o[0][26] apu_operands_o[0][27] apu_operands_o[0][28] apu_operands_o[0][29] apu_operands_o[0][2] apu_operands_o[0][30] apu_operands_o[0][31] apu_operands_o[0][3] apu_operands_o[0][4] apu_operands_o[0][5] apu_operands_o[0][6] apu_operands_o[0][7] apu_operands_o[0][8] apu_operands_o[0][9] apu_operands_o[1][0] apu_operands_o[1][10] apu_operands_o[1][11] apu_operands_o[1][12] apu_operands_o[1][13] apu_operands_o[1][14] apu_operands_o[1][15] apu_operands_o[1][16] apu_operands_o[1][17] apu_operands_o[1][18] apu_operands_o[1][19] apu_operands_o[1][1] apu_operands_o[1][20] apu_operands_o[1][21] apu_operands_o[1][22] apu_operands_o[1][23] apu_operands_o[1][24] apu_operands_o[1][25] apu_operands_o[1][26] apu_operands_o[1][27] apu_operands_o[1][28] apu_operands_o[1][29] apu_operands_o[1][2] apu_operands_o[1][30] apu_operands_o[1][31] apu_operands_o[1][3] apu_operands_o[1][4] apu_operands_o[1][5] apu_operands_o[1][6] apu_operands_o[1][7] apu_operands_o[1][8] apu_operands_o[1][9] apu_operands_o[2][0] apu_operands_o[2][10] apu_operands_o[2][11] apu_operands_o[2][12] apu_operands_o[2][13] apu_operands_o[2][14] apu_operands_o[2][15] apu_operands_o[2][16] apu_operands_o[2][17] apu_operands_o[2][18] apu_operands_o[2][19] apu_operands_o[2][1] apu_operands_o[2][20] apu_operands_o[2][21] apu_operands_o[2][22] apu_operands_o[2][23] apu_operands_o[2][24] apu_operands_o[2][25] apu_operands_o[2][26] apu_operands_o[2][27] apu_operands_o[2][28] apu_operands_o[2][29] apu_operands_o[2][2] apu_operands_o[2][30] apu_operands_o[2][31] apu_operands_o[2][3] apu_operands_o[2][4] apu_operands_o[2][5] apu_operands_o[2][6] apu_operands_o[2][7] apu_operands_o[2][8] apu_operands_o[2][9] apu_req_o debug_halted_o debug_havereset_o debug_running_o"


set all_other_input_ports ""
set all_other_output_ports "tests_passed_o  exit_valid_o tests_failed_o exit_value_o"  
##

# IRQs
##set_input_delay  $in_delay_irq          [ get_ports $irq_input_ports        ] -clock clk_i
##set_output_delay $out_delay_irq         [ get_ports $irq_output_ports       ] -clock clk_i

### OBI input/output delays
##set_input_delay  $in_delay_instr_gnt    [ get_ports instr_gnt_i             ] -clock clk_i
##set_input_delay  $in_delay_instr_rvalid [ get_ports instr_rvalid_i          ] -clock clk_i
##set_input_delay  $in_delay_instr_rdata  [ get_ports instr_rdata_i*          ] -clock clk_i

##set_input_delay  $in_delay_data_gnt     [ get_ports data_gnt_i              ] -clock clk_i
##set_input_delay  $in_delay_data_rvalid  [ get_ports data_rvalid_i           ] -clock clk_i
##set_input_delay  $in_delay_data_rdata   [ get_ports data_rdata_i*           ] -clock clk_i

##set_output_delay $out_delay_instr_req   [ get_ports instr_req_o             ] -clock clk_i
##set_output_delay $out_delay_instr_addr  [ get_ports instr_addr_o*           ] -clock clk_i

##set_output_delay $out_delay_data_req    [ get_ports data_req_o              ] -clock clk_i
##set_output_delay $out_delay_data_we     [ get_ports data_we_o               ] -clock clk_i
##set_output_delay $out_delay_data_be     [ get_ports data_be_o*              ] -clock clk_i
##set_output_delay $out_delay_data_addr   [ get_ports data_addr_o*            ] -clock clk_i
##set_output_delay $out_delay_data_wdata  [ get_ports data_wdata_o*           ] -clock clk_i

### Misc
##set_input_delay  $in_delay_early        [ get_ports $early_input_ports      ] -clock clk_i
##set_input_delay  $in_delay_other        [ get_ports $all_other_input_ports  ] -clock clk_i

set_output_delay $out_delay_other       [ get_ports $all_other_output_ports ] -clock clk_i
##set_output_delay $out_delay_core_sleep  [ get_ports core_sleep_o            ] -clock clk_i


## https://digilent.com/reference/programmable-logic/arty-z7/reference-manual
## https://github.com/Digilent/digilent-xdc/blob/master/Arty-Z7-20-Master.xdc
set_property IOSTANDARD LVCMOS33 [get_ports "clk_i" ]
set_property PACKAGE_PIN H16 [get_ports "clk_i" ]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_i]
#set_property ASYNC_REG TRUE [get_cells -hierarchical -filter {NAME =~ *sync*}]
## BTN_0
set_property IOSTANDARD LVCMOS33 [get_ports "rst_ni" ]
set_property PACKAGE_PIN R1 [get_ports "rst_ni" ]
##set_property IOSTANDARD LVCMOS33 [get_ports $all_other_input_ports ]
set_property IOSTANDARD LVCMOS33 [get_ports $all_other_output_ports ]
## LED 0
set_property IOSTANDARD LVCMOS33 [get_ports "tests_passed_o"  ]
set_property PACKAGE_PIN T2 [get_ports "tests_passed_o" ]
## LED 1
set_property IOSTANDARD LVCMOS33 [get_ports "tests_failed_o" ]
set_property PACKAGE_PIN T3 [get_ports "tests_failed_o" ]
## LED 2
set_property IOSTANDARD LVCMOS33 [get_ports "exit_valid_o" ]
set_property PACKAGE_PIN T4 [get_ports "exit_valid_o" ]
## LED 3
##set_property IOSTANDARD LVCMOS33 [get_ports "exit_value_o" ]
##set_property PACKAGE_PIN M14 [get_ports "exit_value_o" ]

# UART TX output to CW305 JP3 IO5 / FPGA pin A12
set_property PACKAGE_PIN A12 [get_ports uart_tx_o]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx_o]
set_property DRIVE 8 [get_ports uart_tx_o]
set_property SLEW SLOW [get_ports uart_tx_o]

