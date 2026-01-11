class apb_config extends uvm_object;
	`uvm_object_utils(apb_config)
	

	virtual apb_intf apb_if;

	uvm_active_passive_enum is_active;
	
	extern function new(string name ="apb_config");
endclass : apb_config

function apb_config :: new(string name = "apb_config");
	super.new(name);
endfunction
