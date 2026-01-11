class env_config extends uvm_object;
	`uvm_object_utils(env_config);
	
	bit has_apb_agent = 1;
	bit has_spi_agent = 1;
//	int no_of_apb_agents =1;
//	int no_of_spi_agents =1;
	bit has_sb =1;
	bit has_virtual_seqr = 1;

	apb_config apb_cfg;
	spi_config spi_cfg;

//	spi_reg_block spi_reg_blk;

	uvm_active_passive_enum is_active;
	extern function new(string name ="env_config");

endclass : env_config

function env_config::new(string name ="env_config");
	super.new(name);
endfunction



