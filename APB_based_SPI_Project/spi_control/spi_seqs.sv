class spi_seqs extends uvm_sequence #(spi_xtn);
	`uvm_object_utils(spi_seqs)

	env_config m_cfg;
//	spi_reg_block spi_reg_blk;


	function new(string name ="spi_seqs");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db #(env_config) :: get(null,get_full_name(),"env_config",m_cfg))	
			`uvm_error(get_type_name(),"error occured while getting m_cfg");
	//	spi_reg_blk = m_cfg.spi_reg_blk;
	//	req = spi_xtn :: type_id :: create("req");
	//	start_item(req);
	//	req.randomize();
	//	finish_item(req);
	endtask
endclass


class spi_seq1 extends spi_seqs;
	`uvm_object_utils(spi_seq1)
	
	function new(string name ="spi_seq1");
		super.new(name);
	endfunction

	task body();
		super.body();			
		repeat(1) begin
			req = spi_xtn :: type_id :: create("req");
			start_item(req);
			assert(req.randomize() );
			finish_item(req);
		end
	endtask
endclass



	
