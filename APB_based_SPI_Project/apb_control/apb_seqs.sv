class apb_seqs extends uvm_sequence #(apb_xtn);
	`uvm_object_utils(apb_seqs)


//	spi_reg_block spi_reg_blk;
	env_config m_cfg;

	uvm_status_e status;

	function new(string name ="apb_seqs");
		super.new(name);
	endfunction

	extern task body();

endclass

	
task apb_seqs :: body();
	if(!uvm_config_db #(env_config) :: get(null,get_full_name(),"env_config",m_cfg))	
		`uvm_error(get_type_name(),"error occured while getting m_cfg");
//	spi_reg_blk = m_cfg.spi_reg_blk;

endtask



class apb_reset_seqs extends apb_seqs;
	`uvm_object_utils(apb_reset_seqs)
	
	
	function new(string name ="reset_seqs");
		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(1) begin
			 $display("i am in reset seqs");

			req = apb_xtn :: type_id :: create("apb_xtn");
			$display("before start item");
			start_item(req);
			$display("after start item");	
			assert(req.randomize() with {PRESETn ==1'b1; PWRITE == 1'b0; PADDR == 3'd0;});
			finish_item(req);
			$display("after finish item");

			start_item(req);	
			assert(req.randomize() with {PRESETn ==1'b1; PWRITE == 1'b0; PADDR == 3'd1;});
			finish_item(req);

			start_item(req);	
			assert(req.randomize() with {PRESETn ==1'b1; PWRITE == 1'b0; PADDR == 3'd2;});
			finish_item(req);



			start_item(req);	
			assert(req.randomize() with {PRESETn ==1'b1; PWRITE == 1'b0; PADDR == 3'd3;});
			finish_item(req);



			start_item(req);	
			assert(req.randomize() with {PRESETn ==1'b1; PWRITE == 1'b0; PADDR == 3'd5;});
			finish_item(req);

		
		end
	endtask

endclass

//cpol=1, cphase =1, lsbfe =1;

class apb_cpol1_cpha1_lsb1 extends apb_seqs;
	`uvm_object_utils(apb_cpol1_cpha1_lsb1)
	bit [7:0] ctrl;
	bit [7:0] data1,data2,data3;
	
	function new(string name ="apb_cpol1_cpha1_lsb1");
		super.new(name);
	endfunction

	task body();	
		super.body();
		uvm_config_db #(bit[7:0]) :: get(null,get_full_name(),"bit",ctrl);
		repeat(1) begin
			$display("copl =1 , cpahse =1, lsbfe =1 ");
			req = apb_xtn :: type_id :: create("req");
			data1 = ctrl;
			data2 = 8'b00011001;//modfault and bidirectional bits are enabled
			data3 = 8'b00010001;//for BR register
			start_item(req);
			assert(req.randomize() with{PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;}); //performs dummy read operation for any registers except data register
			finish_item(req);
			//SPI CONFIG via RAL all writes use backdoor access (bypass APB) 
			//register map reference, parent context for transaction linking
	
		//	this.spi_reg_blk.cntr_reg1.write(status,data1, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.cntr_reg2.write(status,data2, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.baud_reg.write(status,data3, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
			

		//--------------with out ral -------------------------------//
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b000; PWDATA == data1;});
			finish_item(req);
			
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b001; PWDATA == data2;});
			finish_item(req);
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b010; PWDATA == data3;});
			finish_item(req);

			//----------------------------------//
		//	if(req.PWRITE && req.PADDR == 3'b000) $display("cr 1 %0d ",req.PWDATA);
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		end
	endtask
endclass


//cpol =1 , cphase =0, lsbfe =1;

class apb_cpol1_cpha0_lsb1 extends apb_seqs;
	`uvm_object_utils(apb_cpol1_cpha0_lsb1)
	bit [7:0] ctrl;
	bit [7:0] data1,data2,data3;
	
	function new(string name ="apb_cpol1_cpha0_lsb1");
		super.new(name);
	endfunction

	task body();	
		super.body();
		uvm_config_db #(bit[7:0]) :: get(null,get_full_name(),"bit",ctrl);
		repeat(1) begin
			$display("copl =1 , cpahse =0, lsbfe =1 ");
			req = apb_xtn :: type_id :: create("req");
			data1 = ctrl;
			data2 = 8'b00011000;//modfault and bidirectional bits are enabled
			data3 = 8'b00010001;//for BR register
			start_item(req);
			assert(req.randomize() with{PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;}); //performs dummy read operation for any registers except data register
			finish_item(req);
			//SPI CONFIG via RAL all writes use backdoor access (bypass APB) 
			//register map reference, parent context for transaction linking
	
		//	this.spi_reg_blk.cntr_reg1.write(status,data1, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.cntr_reg2.write(status,data2, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.baud_reg.write(status,data3, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));

			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b000; PWDATA == data1;});
			finish_item(req);
			
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b001; PWDATA == data2;});
			finish_item(req);
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b010; PWDATA == data3;});
			finish_item(req);

			

			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		end
	endtask
endclass





//cpol =0, cphase =1, lsbfe =1;

class apb_cpol0_cpha1_lsb1 extends apb_seqs;
	`uvm_object_utils(apb_cpol0_cpha1_lsb1)
	bit [7:0] ctrl;
	bit [7:0] data1,data2,data3;
	
	function new(string name ="apb_cpol0_cpha1_lsb1");
		super.new(name);
	endfunction

	task body();	
		super.body();
		uvm_config_db #(bit[7:0]) :: get(null,get_full_name(),"bit",ctrl);
		repeat(1) begin
			$display("copl =0 , cpahse =1, lsbfe =1 ");
			req = apb_xtn :: type_id :: create("req");
			data1 = ctrl;
			data2 = 8'b00011000;//modfault and bidirectional bits are enabled
			data3 = 8'b00010001;//for BR register
			start_item(req);
			assert(req.randomize() with{PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;}); //performs dummy read operation for any registers except data register
			finish_item(req);
			//SPI CONFIG via RAL all writes use backdoor access (bypass APB) 
			//register map reference, parent context for transaction linking
	
		//	this.spi_reg_blk.cntr_reg1.write(status,data1, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.cntr_reg2.write(status,data2, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.baud_reg.write(status,data3, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));


			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b000; PWDATA == data1;});
			finish_item(req);
			
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b001; PWDATA == data2;});
			finish_item(req);
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b010; PWDATA == data3;});
			finish_item(req);


			

			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		end
	endtask
endclass





//cpol =0 , cphase =0, lsbfe =1;

class apb_cpol0_cpha0_lsb1 extends apb_seqs;
	`uvm_object_utils(apb_cpol0_cpha0_lsb1)
	bit [7:0] ctrl;
	bit [7:0] data1,data2,data3;
	
	function new(string name ="apb_cpol0_cpha0_lsb1");
		super.new(name);
	endfunction

	task body();	
		super.body();
		uvm_config_db #(bit[7:0]) :: get(null,get_full_name(),"bit",ctrl);
		repeat(1) begin
			$display("copl =0 , cpahse =0, lsbfe =1 ");
			req = apb_xtn :: type_id :: create("req");
			data1 = ctrl;
			data2 = 8'b00011000;//modfault and bidirectional bits are enabled
			data3 = 8'b00010001;//for BR register
			start_item(req);
			assert(req.randomize() with{PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;}); //performs dummy read operation for any registers except data register
			finish_item(req);
			//SPI CONFIG via RAL all writes use backdoor access (bypass APB) 
			//register map reference, parent context for transaction linking
	
		//	this.spi_reg_blk.cntr_reg1.write(status,data1, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.cntr_reg2.write(status,data2, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.baud_reg.write(status,data3, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));


			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b000; PWDATA == data1;});
			finish_item(req);
			
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b001; PWDATA == data2;});
			finish_item(req);
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b010; PWDATA == data3;});
			finish_item(req);


			

			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		end
	endtask
endclass















//cpol=1, cphase =1, lsbfe =0;

class apb_cpol1_cpha1_lsb0 extends apb_seqs;
	`uvm_object_utils(apb_cpol1_cpha1_lsb0)
	bit [7:0] ctrl;
	bit [7:0] data1,data2,data3;
	
	function new(string name ="apb_cpol1_cpha1_lsb0");
		super.new(name);
	endfunction

	task body();	
		super.body();
		uvm_config_db #(bit[7:0]) :: get(null,get_full_name(),"bit",ctrl);
		repeat(1) begin
			$display("copl =1 , cpahse =1, lsbfe =0 ");
			req = apb_xtn :: type_id :: create("req");
			data1 = ctrl;
			data2 = 8'b00011000;//modfault and bidirectional bits are enabled
			data3 = 8'b00010001;//for BR register
			start_item(req);
			assert(req.randomize() with{PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;}); //performs dummy read operation for any registers except data register
			finish_item(req);
			//SPI CONFIG via RAL all writes use backdoor access (bypass APB) 
			//register map reference, parent context for transaction linking
	
		//	this.spi_reg_blk.cntr_reg1.write(status,data1, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.cntr_reg2.write(status,data2, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.baud_reg.write(status,data3, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));

			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b000; PWDATA == data1;});
			finish_item(req);
			
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b001; PWDATA == data2;});
			finish_item(req);
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b010; PWDATA == data3;});
			finish_item(req);


			

			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		end
	endtask
endclass


//cpol =1 , cphase =0, lsbfe =0;

class apb_cpol1_cpha0_lsb0 extends apb_seqs;
	`uvm_object_utils(apb_cpol1_cpha0_lsb0)
	bit [7:0] ctrl;
	bit [7:0] data1,data2,data3;
	
	function new(string name ="apb_cpol1_cpha0_lsb0");
		super.new(name);
	endfunction

	task body();	
		super.body();
		uvm_config_db #(bit[7:0]) :: get(null,get_full_name(),"bit",ctrl);
		repeat(1) begin
			$display("copl =1 , cpahse =0, lsbfe =0 ");
			req = apb_xtn :: type_id :: create("req");
			data1 = ctrl;
			data2 = 8'b00011000;//modfault and bidirectional bits are enabled
			data3 = 8'b00010001;//for BR register
			start_item(req);
			assert(req.randomize() with{PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;}); //performs dummy read operation for any registers except data register
			finish_item(req);
			//SPI CONFIG via RAL all writes use backdoor access (bypass APB) 
			//register map reference, parent context for transaction linking
	
		//	this.spi_reg_blk.cntr_reg1.write(status,data1, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.cntr_reg2.write(status,data2, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.baud_reg.write(status,data3, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));


			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b000; PWDATA == data1;});
			finish_item(req);
			
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b001; PWDATA == data2;});
			finish_item(req);
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b010; PWDATA == data3;});
			finish_item(req);

			

			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		end
	endtask
endclass





//cpol =0, cphase =1, lsbfe =0;

class apb_cpol0_cpha1_lsb0 extends apb_seqs;
	`uvm_object_utils(apb_cpol0_cpha1_lsb0)
	bit [7:0] ctrl;
	bit [7:0] data1,data2,data3;
	
	function new(string name ="apb_cpol0_cpha1_lsb0");
		super.new(name);
	endfunction

	task body();	
		super.body();
		uvm_config_db #(bit[7:0]) :: get(null,get_full_name(),"bit",ctrl);
		repeat(1) begin
			$display("copl =0 , cpahse =1, lsbfe =0 ");
			req = apb_xtn :: type_id :: create("req");
			data1 = ctrl;
			data2 = 8'b00011000;//modfault and bidirectional bits are enabled
			data3 = 8'b00010001;//for BR register
			start_item(req);
			assert(req.randomize() with{PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;}); //performs dummy read operation for any registers except data register
			finish_item(req);
			//SPI CONFIG via RAL all writes use backdoor access (bypass APB) 
			//register map reference, parent context for transaction linking
	
		//	this.spi_reg_blk.cntr_reg1.write(status,data1, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.cntr_reg2.write(status,data2, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.baud_reg.write(status,data3, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));



			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b000; PWDATA == data1;});
			finish_item(req);
			
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b001; PWDATA == data2;});
			finish_item(req);
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b010; PWDATA == data3;});
			finish_item(req);


			

			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		end
	endtask
endclass





//cpol =0 , cphase =0, lsbfe =0;

class apb_cpol0_cpha0_lsb0 extends apb_seqs;
	`uvm_object_utils(apb_cpol0_cpha0_lsb0)
	bit [7:0] ctrl;
	bit [7:0] data1,data2,data3;
	
	function new(string name ="apb_cpol0_cpha0_lsb0");
		super.new(name);
	endfunction

	task body();	
		super.body();
		uvm_config_db #(bit[7:0]) :: get(null,get_full_name(),"bit",ctrl);
		repeat(1) begin
			$display("copl =0 , cpahse =0, lsbfe =0 ");
			req = apb_xtn :: type_id :: create("req");
			data1 = ctrl;
			data2 = 8'b00011000;//modfault and bidirectional bits are enabled
			data3 = 8'b00010001;//for BR register
			start_item(req);
			assert(req.randomize() with{PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;}); //performs dummy read operation for any registers except data register
			finish_item(req);
			//SPI CONFIG via RAL all writes use backdoor access (bypass APB) 
			//register map reference, parent context for transaction linking
	
		//	this.spi_reg_blk.cntr_reg1.write(status,data1, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.cntr_reg2.write(status,data2, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.baud_reg.write(status,data3, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));


			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b000; PWDATA == data1;});
			finish_item(req);
			
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b001; PWDATA == data2;});
			finish_item(req);
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b010; PWDATA == data3;});
			finish_item(req);


			

			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		end
	endtask
endclass


//low power mode

class low_power_mode_seq extends apb_seqs;
	`uvm_object_utils(low_power_mode_seq)
	bit [7:0] ctrl;
	bit [7:0] data1,data2,data3;
	
	function new(string name ="low_power_mode_seq");
		super.new(name);
	endfunction

	task body();	
		super.body();
		uvm_config_db #(bit[7:0]) :: get(null,get_full_name(),"bit",ctrl);
		repeat(1) begin
			$display("low_power_mode_seq");
			req = apb_xtn :: type_id :: create("req");
			data1 = ctrl;
			data2 = 8'b00011010;//modfault and bidirectional bits are enabled
			data3 = 8'b00010001;//for BR register
		//	start_item(req);
		//	assert(req.randomize() with{PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;}); //performs dummy read operation for any registers except data register
		//	finish_item(req);
			//SPI CONFIG via RAL all writes use backdoor access (bypass APB) 
			//register map reference, parent context for transaction linking
	
		//	this.spi_reg_blk.cntr_reg1.write(status,data1, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.cntr_reg2.write(status,data2, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
		//	this.spi_reg_blk.baud_reg.write(status,data3, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map), .parent(this));
			


			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b000; PWDATA == data1;});
			finish_item(req);
			
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b001; PWDATA == data2;});
			finish_item(req);
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b010; PWDATA == data3;});
			finish_item(req);



			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		end
	endtask
endclass











class apb_read extends apb_seqs;
	`uvm_object_utils(apb_read)
	
	function new(string name ="apb_read");		

		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(1) begin
		req = apb_xtn :: type_id :: create("req");
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR == 3'b101;});
		finish_item(req);
		end
	endtask
endclass
		
	



			

			

		
