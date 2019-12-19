# AIRI5C
RISC-V softcore

This implementation of the RISC-V ISA was inspired by 
vscale/ri5cy and others and is meant to be part of a 
low-power ASIC design.

The core is a three-stage (IF,DE/EX,WB) implementation, 
including external debug support, support for the 
RCPI coprocessor interface and a JTAG transport module.

The repository includes a Vivado project for the 
NexysVideo FPGA-Board.

It has been testet with the following setup:
Eclipse MCU <-> OpenOCD <-> Olimex ARM-USB-TINY-H JTAG-adapter <-> Nexys Video FPGA-Board.

A hardware multiplier is included, implemented as a 
coprocessor on the RCPI interface.

A simple GPIO and UART (TX only) peripheral is included in 
the FPGA design.




