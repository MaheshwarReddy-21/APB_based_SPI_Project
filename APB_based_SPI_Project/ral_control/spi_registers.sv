//control register 1...
class spi_reg_file_control_register1 extends uvm_reg;
	`uvm_object_utils(spi_reg_file_control_register1)
	rand uvm_reg_field lsbfe;
	rand uvm_reg_field ssoe;
	rand uvm_reg_field cpha;
	rand uvm_reg_field cpol;
	rand uvm_reg_field mstr;
	rand uvm_reg_field sptie;
	rand uvm_reg_field spe;
	rand uvm_reg_field spie;

function new(string name = "spi_reg_file_control_register1");
	super.new(name,8,UVM_CVR_ALL);
endfunction

function void build();
	lsbfe = uvm_reg_field :: type_id :: create("lsbfe");
	ssoe = uvm_reg_field :: type_id :: create("ssoe");
	cpha = uvm_reg_field :: type_id :: create("cpha");
	cpol = uvm_reg_field :: type_id :: create("cpol");
	mstr = uvm_reg_field :: type_id :: create("mstr");
	sptie = uvm_reg_field :: type_id :: create("sptie");
	spe = uvm_reg_field :: type_id :: create("spe");
	spie = uvm_reg_field :: type_id :: create("spie");


//9 arguments //configure(parent,size,lsb_position, access, volatile, reset, has_reset, is_rand ,cover_on) .//volatile 0 means --> only changes through software access --> once fixed we cannot change ..

	lsbfe.configure(this,1,0,"RW",0,1'b0,1,1,1);
	ssoe.configure(this,1,1,"RW",0,1'b0,1,1,1);
	cpha.configure(this,1,2,"RW",0,1'b1,1,1,1);
	cpol.configure(this,1,3,"RW",0,1'b0,1,1,1);
	mstr.configure(this,1,4,"RW",0,1'b0,1,1,1);
	sptie.configure(this,1,5,"RW",0,1'b0,1,1,1);
	spe.configure(this,1,6,"RW",0,1'b0,1,1,1);
	spie.configure(this,1,7,"RW",0,1'b0,1,1,1);
//Ram value will be lost(volatile(1)) Rom - non volatile(0) 

endfunction
endclass
//for reserved fields we cann't use rand



//control register 2....
class spi_reg_file_control_register2 extends uvm_reg;
	`uvm_object_utils(spi_reg_file_control_register2)
	uvm_reg_field reserved1;
	uvm_reg_field reserved2;
	rand uvm_reg_field spco;
	rand uvm_reg_field spiswai;
	rand uvm_reg_field bidiroe;
	rand uvm_reg_field modfe;

function new(string name = "spi_reg_file_control_register2");
	super.new(name,8,UVM_CVR_ALL);
endfunction

function void build();
	reserved1 = uvm_reg_field :: type_id :: create("reserved1");
	reserved2 = uvm_reg_field :: type_id :: create("reserved2");
	spco = uvm_reg_field :: type_id :: create("spco");
	spiswai = uvm_reg_field :: type_id :: create("spiswai");
	bidiroe = uvm_reg_field :: type_id :: create("bidiroe");
	modfe = uvm_reg_field :: type_id :: create("modfe");



	spco.configure(this,1,0,"RW",0,1'b0,1,1,1);
	spiswai.configure(this,1,1,"RW",0,1'b0,1,1,1);
	reserved1.configure(this,1,2,"RO",0,1'b0,0,0,0);
	bidiroe.configure(this,1,3,"RW",0,1'b0,1,1,1);
	modfe.configure(this,1,4,"RW",0,1'b0,1,1,1);
	reserved2.configure(this,3,5,"RO",0,3'b0,0,0,0);
endfunction
endclass


//baud register

class spi_reg_file_baud_register extends uvm_reg;
	`uvm_object_utils(spi_reg_file_baud_register)
	uvm_reg_field reserved1;
	uvm_reg_field reserved2;
	rand uvm_reg_field spr;
	rand uvm_reg_field sppr;
	

function new(string name = "spi_reg_file_baud_register");
	super.new(name,8,UVM_CVR_ALL);
endfunction

function void build();

	reserved1 = uvm_reg_field :: type_id :: create("reserved1");
	reserved2 = uvm_reg_field :: type_id :: create("reserved2");
	spr = uvm_reg_field :: type_id :: create("spr");
	sppr = uvm_reg_field :: type_id :: create("sppr");



	reserved1.configure(this,1,3,"RO",0,1'b0,0,0,0);
	reserved2.configure(this,1,7,"RO",0,1'b0,0,0,0);
	spr.configure(this,3,0,"RW",0,3'b0,1,1,1);
	sppr.configure(this,3,4,"RW",0,3'b0,1,1,1);
endfunction
endclass


//status register

class spi_reg_file_status_register extends uvm_reg;
	`uvm_object_utils(spi_reg_file_status_register)
	uvm_reg_field reserved1;
	uvm_reg_field reserved2;
	uvm_reg_field modf;
	uvm_reg_field sptef;
	uvm_reg_field spif;
	function new(string name ="spi_reg_file_status_register");
		super.new(name,8,UVM_CVR_ALL);
	endfunction

	function void build();
		reserved1 = uvm_reg_field :: type_id :: create("reserved1");
		reserved2 = uvm_reg_field :: type_id :: create("reserved2");
		modf = uvm_reg_field :: type_id :: create("modf");
		sptef = uvm_reg_field :: type_id :: create("sptef");
		spif = uvm_reg_field ::type_id :: create("spid");


		reserved1.configure(this,4,0,"RO",0,4'b0,0,0,0);
		reserved2.configure(this,1,6,"RO",0,1'b0,0,0,0);
		modf.configure(this,1,4,"RO",0,1'b0,1,0,0);
		sptef.configure(this,1,5,"RO",0,1'b1,0,0,0);
		spif.configure(this,1,7,"RO",0,1'b1,0,0,0);
	endfunction
endclass


//data register
class spi_reg_file_data_register extends uvm_reg;
	`uvm_object_utils(spi_reg_file_data_register)
	rand uvm_reg_field data;
	function new(string name ="spi_reg_file_data_register");
		super.new(name,8,UVM_CVR_ALL);
	endfunction

	function void build();
		data = uvm_reg_field :: type_id :: create("data");

		data.configure(this,8,0,"RW",0,8'b0,1,1,1);
	endfunction

	
endclass







