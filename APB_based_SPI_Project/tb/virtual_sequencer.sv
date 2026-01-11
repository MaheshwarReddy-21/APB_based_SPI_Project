class vseqr extends uvm_sequencer #(uvm_sequence_item);
	`uvm_component_utils(vseqr)
	spi_sequencer spi_seqrh;
	apb_sequencer apb_seqrh;

	extern function new(string name = "vseqr", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass

function vseqr :: new(string name ="vseqr", uvm_component parent);
	super.new(name,parent);
endfunction

function void vseqr :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	//spi_seqrh = new("spi_seqrh",this);
	//apb_seqrh = new("apb_seqrh",this);
endfunction


