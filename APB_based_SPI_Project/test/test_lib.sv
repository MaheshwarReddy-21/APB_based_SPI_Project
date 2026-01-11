class base_test extends uvm_test;
	`uvm_component_utils(base_test)
	env envh;
	env_config m_cfg;
	apb_config apb_cfg;
	spi_config spi_cfg;
	vseqs vseqsh;
	
	bit reset_test;
	bit [1:0] low_pwr_case;
	
//	spi_reg_block spi_reg_blk;

	bit [7:0] ctrl;// = 8'b1111_1111;

	bit has_apb_agent =1;
	bit has_spi_agent =1;
	extern function new(string name = "base_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
//	extern task run_phase(uvm_phase phase);
	extern function void config_env;
endclass

function base_test :: new(string name = "base_test", uvm_component parent);
	super.new(name, parent);
endfunction


function void base_test :: config_env ;
	if(has_apb_agent) begin
		apb_cfg = apb_config :: type_id :: create("apb_cfg");
		if(!uvm_config_db #(virtual apb_intf) :: get(this,"","apb_intf",apb_cfg.apb_if))
			`uvm_error(get_full_name(),"error while getting apb virtual interface");
		m_cfg.apb_cfg = apb_cfg;
	end
	if(has_spi_agent) begin
		spi_cfg = spi_config :: type_id :: create("spi_cfg");
		if(!uvm_config_db #(virtual spi_intf) :: get(this,"","spi_intf",spi_cfg.spi_if))
			`uvm_error(get_full_name(),"error while getting spi virtual interface");
		m_cfg.spi_cfg = spi_cfg;
	end
	m_cfg.has_apb_agent = has_apb_agent;
	m_cfg.has_spi_agent = has_spi_agent;
	m_cfg.is_active = UVM_ACTIVE;
	apb_cfg.is_active = m_cfg.is_active;
	spi_cfg.is_active = m_cfg.is_active;
endfunction

	


function void base_test :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	envh = env :: type_id :: create("envh",this);
	m_cfg = env_config :: type_id :: create("m_cfg");
	//uvm_reg :: include_coverage("*",UVM_CVR_ALL);//static function to enable coverage collection for all the registers includes fields, registers, maps etc...
	config_env;

//	spi_reg_blk = spi_reg_block :: type_id :: create("spi_reg_blk");
//	spi_reg_blk.build();
//	m_cfg.spi_reg_blk = spi_reg_blk;
		
	uvm_config_db #(env_config) :: set(this,"*","env_config",m_cfg);
	
	
endfunction

function void base_test :: end_of_elaboration_phase(uvm_phase phase);
//	super.end_of_elaboratoin_phase(phase);
	uvm_top.print_topology();
endfunction







class resett_test extends base_test;
	`uvm_component_utils(resett_test)

	reset_vseqs rst_seqsh;
//	apb_reset_seqs reset_seqh;
	extern function new(string name ="resett_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase (uvm_phase phase);

	
endclass


	function resett_test :: new(string name ="resett_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void resett_test :: build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b1111_1111;
		reset_test = 1'b1;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
		uvm_config_db #(bit) :: set(this,"*","bit_reset",reset_test);
	endfunction
task resett_test :: run_phase(uvm_phase phase);
	
	super.run_phase(phase);
	$display("hey i am in test");
	phase.raise_objection(this);
	$display("after raise objection");
	rst_seqsh = reset_vseqs :: type_id :: create("rst_seqsh");
	$display("before starting the virtual sequence");
	rst_seqsh.start(envh.vseqrh);
	// reset_seqh = apb_reset_seqs :: type_id :: create("reset_seqh");
	// $display("before starting normal sequence");
	// reset_seqh.start(envh.vseqrh.apb_seqrh);
	$display("after starting the virtual sequence");
	phase.drop_objection(this);
	$display("after drop objection");
endtask

//cpol=1, cphase=1, lsbfe=1;
class cpol1_cpha1_lsb1 extends base_test;
	`uvm_component_utils(cpol1_cpha1_lsb1)
	cpol1_cpha1_lsb1_vseq cpol1_cpha1_lsb1_vseq_h;





	function new(string name ="cpol1_cpha1_lsb1", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11111111;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol1_cpha1_lsb1_vseq_h = cpol1_cpha1_lsb1_vseq :: type_id :: create("cpol1_cpha1_lsb1_vseq_h");
		cpol1_cpha1_lsb1_vseq_h.start(envh.vseqrh);
	

	
	

	phase.drop_objection(this);
	endtask
endclass



//cpol=1, cpahse=0, lsbfe=1;
class cpol1_cpha0_lsb1 extends base_test;
	`uvm_component_utils(cpol1_cpha0_lsb1)
	cpol1_cpha0_lsb1_vseq cpol1_cpha0_lsb1_vseq_h;
	

	function new(string name ="cpol1_cpha0_lsb1", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11111011;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol1_cpha0_lsb1_vseq_h = cpol1_cpha0_lsb1_vseq :: type_id :: create("cpol1_cpha0_lsb1_vseq_h");
		repeat(3)
		cpol1_cpha0_lsb1_vseq_h.start(envh.vseqrh);
		phase.drop_objection(this);
		endtask
endclass	



//cpol=0, cpahse=1, lsbfe=1;
class cpol0_cpha1_lsb1 extends base_test;
	`uvm_component_utils(cpol0_cpha1_lsb1)
	cpol0_cpha1_lsb1_vseq cpol0_cpha1_lsb1_vseq_h;
	

	function new(string name ="cpol0_cpha1_lsb1", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11110111;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol0_cpha1_lsb1_vseq_h = cpol0_cpha1_lsb1_vseq :: type_id :: create("cpol0_cpha1_lsb1_vseq_h");
		cpol0_cpha1_lsb1_vseq_h.start(envh.vseqrh);
		phase.drop_objection(this);
	endtask
endclass	
	
	

//cpol=0, cpahse=0, lsbfe=1;
class cpol0_cpha0_lsb1 extends base_test;
	`uvm_component_utils(cpol0_cpha0_lsb1)
	cpol0_cpha0_lsb1_vseq cpol0_cpha0_lsb1_vseq_h;
	

	function new(string name ="cpol0_cpha0_lsb1", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11110011;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol0_cpha0_lsb1_vseq_h = cpol0_cpha0_lsb1_vseq :: type_id :: create("cpol0_cpha0_lsb1_vseq_h");
		cpol0_cpha0_lsb1_vseq_h.start(envh.vseqrh);
		phase.drop_objection(this);
	endtask
endclass	
	
	




//cpol=1, cphase=1, lsbfe=0;
class cpol1_cpha1_lsb0 extends base_test;
	`uvm_component_utils(cpol1_cpha1_lsb0)
	cpol1_cpha1_lsb0_vseq cpol1_cpha1_lsb0_vseq_h;
	

	function new(string name ="cpol1_cpha1_lsb0", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11111110;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol1_cpha1_lsb0_vseq_h = cpol1_cpha1_lsb0_vseq :: type_id :: create("cpol1_cpha1_lsb0_vseq_h");
		cpol1_cpha1_lsb0_vseq_h.start(envh.vseqrh);
		phase.drop_objection(this);
	endtask
endclass



//cpol=1, cpahse=0, lsbfe=0;
class cpol1_cpha0_lsb0 extends base_test;
	`uvm_component_utils(cpol1_cpha0_lsb0)
	cpol1_cpha0_lsb0_vseq cpol1_cpha0_lsb0_vseq_h;
	

	function new(string name ="cpol1_cpha0_lsb0", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11111010;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol1_cpha0_lsb0_vseq_h = cpol1_cpha0_lsb0_vseq :: type_id :: create("cpol1_cpha0_lsb0_vseq_h");
		cpol1_cpha0_lsb0_vseq_h.start(envh.vseqrh);
		phase.drop_objection(this);
	endtask
endclass	



//cpol=0, cpahse=1, lsbfe=0;
class cpol0_cpha1_lsb0 extends base_test;
	`uvm_component_utils(cpol0_cpha1_lsb0)
	cpol0_cpha1_lsb0_vseq cpol0_cpha1_lsb0_vseq_h;
	

	function new(string name ="cpol0_cpha1_lsb0", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11110110;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol0_cpha1_lsb0_vseq_h = cpol0_cpha1_lsb0_vseq :: type_id :: create("cpol0_cpha1_lsb0_vseq_h");
		cpol0_cpha1_lsb0_vseq_h.start(envh.vseqrh);
		phase.drop_objection(this);
	endtask
endclass	
	
	

//cpol=0, cpahse=0, lsbfe=0;
class cpol0_cpha0_lsb0 extends base_test;
	`uvm_component_utils(cpol0_cpha0_lsb0)
	cpol0_cpha0_lsb0_vseq cpol0_cpha0_lsb0_vseq_h;
	

	function new(string name ="cpol0_cpha0_lsb0", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11110010;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol0_cpha0_lsb0_vseq_h = cpol0_cpha0_lsb0_vseq :: type_id :: create("cpol0_cpha0_lsb0_vseq_h");
		cpol0_cpha0_lsb0_vseq_h.start(envh.vseqrh);
		phase.drop_objection(this);
	endtask
endclass		
	

//low power mode seq
class low_power_mode extends base_test;
	`uvm_component_utils(low_power_mode)
	low_power_mode_vseq low_power_mode_vseq_h;
	

	function new(string name ="low_power_mode_vseq_h", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b10110010;
		low_pwr_case = 2'b01;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
		uvm_config_db #(bit[1:0]) :: set(this,"*","bit[1:0]",low_pwr_case);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		low_power_mode_vseq_h = low_power_mode_vseq :: type_id :: create("low_power_mode_vseq_h");
		low_power_mode_vseq_h.start(envh.vseqrh);
		phase.drop_objection(this);
	endtask
endclass		
	

