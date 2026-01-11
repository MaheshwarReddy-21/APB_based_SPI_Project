class spi_agent_top extends uvm_env;
	`uvm_component_utils(spi_agent_top)
	spi_agent spi_agnth;

	extern function new(string name = "spi_agent_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass : spi_agent_top


function spi_agent_top :: new(string name = "spi_agent_top", uvm_component parent);
	super.new(name,parent);
endfunction

function void spi_agent_top :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	spi_agnth = spi_agent :: type_id :: create("spi_agnth",this);
endfunction
