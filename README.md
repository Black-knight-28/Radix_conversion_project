# Radix Converter FPGA Project

This project implements a radix converter using SystemVerilog
and is designed to run on an FPGA.

## Features

- Supports radix conversion from 2 to 15
- Uses seven-segment displays for output
- Input is provided using FPGA buttons
- Implemented using SystemVerilog

## Project Files

- `radix_converter.sv` - Main radix conversion logic
- `input_controller.sv` - Handles button inputs
- `display_controller.sv` - Controls the seven-segment displays
- `input_to_integer.sv` - Convert the given number in decimal using the Horners' method
- `input_to_output.sv` - converts the number in the desired radix that was taken as an input
- `button_debouncer.sv` - prevents multiple clicks of the buttons that can happen accidentally

## Simulation

The testbench files are located in the `testbench` folder.

## FPGA Implementation

The design was developed and tested using Xilinx Vivado. The board that I am using is a Nexys 4 DDR/ Nexys A7 100t. The other thing is that I am using the CPU reset 
to reset the whole algorithm so if you are trying to do something in parallel to this that might get halted as well. 

## Limitations

- Radix values are supported from 2 through 15.
- Does not support fractional conversion
