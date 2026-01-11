class apb_agent_top extends uvm_env;
	`uvm_component_utils(apb_agent_top)
	apb_agent apb_agnth;
	
	extern function new(string name = "apb_agent_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass : apb_agent_top


function apb_agent_top :: new(string name = "apb_agent_top", uvm_component parent);
	super.new(name,parent);
endfunction

function void apb_agent_top :: build_phase(uvm_phase phase);

	super.build_phase(phase);
	apb_agnth = apb_agent :: type_id :: create("apb_agnth",this);
endfunction
