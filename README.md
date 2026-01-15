In this project i run the simulation through these commands on the tcl console :

Bellow are the two testbench 
the tb_top is for simulation 
the tb_top2 is for implementation 

**tb\_top**


**SIMULATION**


cd C:/Users/mpakasa/Desktop/cv32e40p\_project/cv32e40p-vivado\_synthesis/example\_tb/

xvlog -prj files.prj

xelab -debug typical -top tb\_top -snapshot tb\_top\_sim

xsim tb\_top\_sim -testplusarg firmware=./core/custom/hello.mem


**WAVEFORM**

create\_wave\_config

...
...
...
...

// it ends at 1140 ns !!!











**tb\_top2**


**Simulation**


cd C:/Users/mpakasa/Desktop/cv32e40p\_project/cv32e40p-vivado\_synthesis/example\_tb/

exec rm -rf xsim.dir

foreach f \[glob -nocomplain \*.wdb] { file delete -force $f }

exec xvlog -sv -d SIMULATION -prj files_tb_top2.prj


exec xelab -debug typical \
    -timescale 1ns/1ps \
    -top tb_top2 \
    -snapshot tb_top2_sim \
    -L xpm \
    -L xil_defaultlib



exec xsim tb_top2_sim -testplusarg firmware=./core/custom/hello.mem -gui




exec xsim tb\_top2\_sim -gui





**Waveform**

add_wave /tb_top2/core_memory/cv32e40p_memory_i/uart_tx_o


create\_wave\_config


add\_wave /tb\_top2/clk

add\_wave /tb\_top2/rst\_n

add\_wave -radix hex /tb\_top2/core\_memory/core\_i/instr\_req\_o

add\_wave -radix hex /tb\_top2/core\_memory/core\_i/instr\_gnt\_i

add\_wave -radix hex /tb\_top2/core\_memory/core\_i/instr\_rvalid\_i

add\_wave -radix hex /tb\_top2/core\_memory/core\_i/instr\_rdata\_i

add\_wave -radix hex /tb\_top2/core\_memory/core\_i/if\_stage\_i/pc\_if\_o

add\_wave -radix hex /tb\_top2/core\_memory/core\_i/if\_stage\_i/pc\_id\_o
add\_wave -radix hex /tb\_top2/core\_memory/core\_i/data\_addr\_o

add\_wave -radix hex /tb\_top2/core\_memory/core\_i/data\_wdata\_o

add\_wave -radix hex /tb\_top2/core\_memory/core\_i/data\_rdata\_i

add\_wave /tb\_top2/core\_memory/core\_i/data\_req\_o

add\_wave /tb\_top2/core\_memory/core\_i/data\_we\_o

add\_wave /tb\_top2/core\_memory/core\_i/data\_gnt\_i

add\_wave /tb\_top2/core\_memory/core\_i/data\_rvalid\_i

add\_wave /tb\_top2/tests\_passed

add\_wave /tb\_top2/tests\_failed

add\_wave /tb\_top2/exit\_valid

add\_wave -radix hex /tb\_top2/exit\_value





// it ends at 5300 ns !!!
