class spi_xtn extends uvm_sequence_item;
	`uvm_object_utils(spi_xtn)
	bit ss;
	bit sclk;
	bit [7:0] mosi; // PWDATA[7:0]
	rand bit [7:0] miso; //PRDATA[7:0]
	bit spi_inpt_req;

	extern function new(string name = "spi_xtn");
	extern function void do_print(uvm_printer printer);
endclass : spi_xtn 


function spi_xtn :: new(string name ="spi_xtn");
	super.new(name);
endfunction

function void spi_xtn :: do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("ss",this.ss,$bits(ss),UVM_DEC);
	printer.print_field("sclk",this.sclk,$bits(sclk),UVM_DEC);
	printer.print_field("mosi",this.mosi,$bits(mosi),UVM_DEC);
	printer.print_field("miso",this.miso,$bits(miso),UVM_DEC);
	printer.print_field("spi_inpt_req",this.spi_inpt_req,$bits(spi_inpt_req),UVM_DEC);
endfunction
