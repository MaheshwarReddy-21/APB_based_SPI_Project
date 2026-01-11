class env extends uvm_env;
	`uvm_component_utils(env)
	apb_agent_top apb_agntoph;
	spi_agent_top spi_agntoph;
	scoreboard sb;

	vseqr vseqrh;
	
	env_config m_cfg;
	extern function new(string name = "env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);	
	extern function void connect_phase(uvm_phase phase);
endclass : env

function env :: new(string name = "env", uvm_component parent);
	super.new(name,parent);
endfunction

function void env:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(env_config) :: get(this,"","env_config",m_cfg))
		`uvm_error(get_full_name(),"error while getting the env_config");
	if(m_cfg.has_apb_agent) begin
	uvm_config_db #(apb_config) :: set(this,"*","apb_config",m_cfg.apb_cfg);
	apb_agntoph = apb_agent_top :: type_id :: create("apb_agntoph",this);
	end
	if(m_cfg.has_spi_agent) begin
	uvm_config_db #(spi_config) :: set(this,"*","spi_config",m_cfg.spi_cfg);
	spi_agntoph = spi_agent_top :: type_id :: create("spi_agntoph",this);
	end
	if(m_cfg.has_sb) 
		sb = scoreboard :: type_id :: create("sb",this);
	if(m_cfg.has_virtual_seqr)
		vseqrh = vseqr :: type_id :: create("vseqrh",this);
endfunction

function void env :: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(m_cfg.has_virtual_seqr) begin
		vseqrh.spi_seqrh = spi_agntoph.spi_agnth.spi_seqrh;
		vseqrh.apb_seqrh = apb_agntoph.apb_agnth.apb_seqrh;
	end

	

	if(m_cfg.has_sb) begin
	apb_agntoph.apb_agnth.apb_monh.apb_mon_port.connect(sb.fifo_apb.analysis_export);
	spi_agntoph.spi_agnth.spi_monh.spi_mon_port.connect(sb.fifo_spi.analysis_export);
	end
endfunction
