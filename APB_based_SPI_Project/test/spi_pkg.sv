package spi_pkg;


//import uvm_pkg.sv
	import uvm_pkg::*;
//include uvm_macros.sv
`include "uvm_macros.svh"


//`include "spi_registers.sv"
//`include "spi_registers_block.sv"


`include "apb_xtn.sv"
`include "spi_config.sv"
`include "apb_config.sv"
`include "env_config.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "apb_sequencer.sv"
`include "apb_agent.sv"
`include "apb_agent_top.sv"
`include "apb_seqs.sv"

`include "spi_xtn.sv"
`include "spi_driver.sv"
`include "spi_monitor.sv"
`include "spi_sequencer.sv"
`include "spi_agent.sv"
`include "spi_agent_top.sv"
`include "spi_seqs.sv"

`include "virtual_sequencer.sv"
`include "virtual_sequence.sv"
`include "scoreboard.sv"

`include "environment.sv"


`include "test_lib.sv"
endpackage : spi_pkg
