class spi_agent extends uvm_agent;
	`uvm_component_utils(spi_agent)
	spi_driver spi_drvh;
	spi_monitor spi_monh;
	spi_sequencer spi_seqrh;
	spi_config spi_cfg;
	extern function new(string name = "spi_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass : spi_agent


function spi_agent :: new(string name = "spi_agent", uvm_component parent);
	super.new(name,parent);
endfunction

function void spi_agent :: build_phase(uvm_phase phase);
	if(!uvm_config_db #(spi_config) :: get(this,"","spi_config",spi_cfg))
		`uvm_error(get_full_name(),"error while getting spi_cfg ");
	super.build_phase(phase);
	spi_monh = spi_monitor :: type_id :: create("spi_monh",this);	
	if(spi_cfg.is_active == UVM_ACTIVE) begin
		spi_drvh = spi_driver :: type_id :: create("spi_drvh",this);
		spi_seqrh = spi_sequencer :: type_id :: create("spi_seqrh",this);
	end
endfunction

function void spi_agent :: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(spi_cfg.is_active == UVM_ACTIVE)
	spi_drvh.seq_item_port.connect(spi_seqrh.seq_item_export);
endfunction

	
