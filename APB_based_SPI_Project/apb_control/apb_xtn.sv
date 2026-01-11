class apb_xtn extends uvm_sequence_item;
	`uvm_object_utils(apb_xtn)
	rand bit PRESETn;
	rand bit PWRITE;
	bit PSEL;
	bit PENABLE;
	rand bit [2:0] PADDR; // spi have 5 regesters so to represent 5 ... 3 bits are sufficient
	rand bit [7:0] PWDATA;
	bit [7:0] PRDATA;
	bit PREADY;
	bit PSLVERR;

	constraint valid_address {if(!PWRITE)
					PADDR inside {[0:3],5};
				  else
					PADDR inside {[0:2],5};}

	extern function new(string name = "apb_xtn");
	extern function void do_print(uvm_printer printer);
	extern function void post_randomize();
endclass : apb_xtn


function apb_xtn :: new(string name ="apb_xtn");
	super.new(name);
endfunction


function void apb_xtn :: do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("PRESETn",this.PRESETn,$bits(PRESETn),UVM_DEC);
	printer.print_field("PWRITE",this.PWRITE,$bits(PWRITE),UVM_DEC);
	printer.print_field("PSEL",this.PSEL,$bits(PSEL),UVM_DEC);
	printer.print_field("PENABLE",this.PENABLE, $bits(PENABLE),UVM_DEC);
	printer.print_field("PADDR",this.PADDR,$bits(PADDR),UVM_DEC);
	printer.print_field("PWDATA",this.PWDATA,$bits(PWDATA),UVM_DEC);
	printer.print_field("PRDATA",this.PRDATA,$bits(PRDATA),UVM_DEC);
	printer.print_field("PREADY",this.PREADY,$bits(PREADY),UVM_DEC);
	printer.print_field("PSLVERR",this.PSLVERR,$bits(PSLVERR),UVM_DEC);
endfunction


function void apb_xtn :: post_randomize();
//mask to defint which bits can be updated
	bit[7:0] cntr1_reg_mask = 8'b1111_1111;
	bit[7:0] cntr2_reg_mask = 8'b0001_1011;
	bit[7:0] baud_reg_mask = 8'b0111_0111;
	bit[7:0] status_reg_mask = 8'b0000_0000; // write is not allowed for this status reg.. all bits are not editable ... so masked with all 0's
	bit[7:0] data_reg_mask = 8'b1111_1111;


//for a write transaction depending on PADDR the randomized data will be added with masks to porduce a meaningful data
	if(PWRITE) begin
		case(PADDR)
			000 : PWDATA = cntr1_reg_mask & PWDATA; //SPICR1 register
			001 : PWDATA = cntr2_reg_mask & PWDATA; //SPICR2 register
			010 : PWDATA = baud_reg_mask & PWDATA; // Baud register
			011 : PWDATA = status_reg_mask & PWDATA; //status regiser
			101 : PWDATA = data_reg_mask & PWDATA; // data register
		endcase
	end
endfunction


	
	




