class spi_driver extends uvm_driver #(spi_xtn);
	`uvm_component_utils(spi_driver)
	
	virtual spi_intf.SPI_DRV_MP spi_drv_if;
	spi_config spi_cfg;

	bit [7:0] ctrl;
	bit cpol;
	bit cphase;
	bit lsbfe;
	
	extern function new(string name = "spi_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(spi_xtn xtn);
endclass : spi_driver


function spi_driver :: new(string name = "spi_driver", uvm_component parent);
	super.new(name,parent);
endfunction

function void spi_driver :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(spi_config) :: get(this,"","spi_config",spi_cfg))
		`uvm_error(get_full_name(),"error while getting the spi_config");

	if(!uvm_config_db #(bit[7:0]) :: get(this,"*","bit",ctrl))
		`uvm_error (get_type_name(),"error while getting ctrl bit");

	
endfunction


function void spi_driver :: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	spi_drv_if = spi_cfg.spi_if;

	cpol = ctrl[3];
	cphase = ctrl[2];
	lsbfe = ctrl[0];
endfunction

task spi_driver :: run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		`uvm_info("SPI DRV","PRINTING FOPRM SPI DRIVER",UVM_LOW)
		req.print;
		seq_item_port.item_done();
	end
endtask

task spi_driver ::send_to_dut(spi_xtn xtn);
	
	$display("spi driver ss = %0d",spi_drv_if.spi_drv_cb.ss);
	wait(~spi_drv_if.spi_drv_cb.ss)
	


	if(lsbfe) begin
		if((!cpol)&&(!cphase)) begin
			//spi_drv_if.spi_drv_cb.miso <= xtn.miso[0];
			for(int i =0;i<8;i++) begin
				spi_drv_if.spi_drv_cb.miso <= xtn.miso[i];
				@(negedge spi_drv_if.spi_drv_cb.sclk);
			end
		end
		else if((!cpol)&&(cphase)) begin
		//	@(posedge spi_drv_if.spi_drv_cb)
		//	spi_drv_if.spi_drv_cb.miso <= xtn.miso[0];
			for(int i =0;i<8;i++) begin
				@(posedge spi_drv_if.spi_drv_cb.sclk)
				spi_drv_if.spi_drv_cb.miso <= xtn.miso[i];
			end
		end
		else if((cpol)&&(!cphase)) begin

		//	spi_drv_if.spi_drv_cb.miso <= xtn.miso[0];
			for(int i =0;i<8;i++) begin
				spi_drv_if.spi_drv_cb.miso <= xtn.miso[i];

				@(posedge spi_drv_if.spi_drv_cb.sclk);

			end
		end
		else if((cpol)&&(cphase)) begin
		//	@(negedge spi_drv_if.spi_drv_cb);
		//	spi_drv_if.spi_drv_cb.miso <= xtn.miso[0];
			for(int i =0;i<8;i++) begin
				@(negedge spi_drv_if.spi_drv_cb.sclk)
				spi_drv_if.spi_drv_cb.miso <= xtn.miso[i];
			end
		end
	end

	else begin
		if((!cpol)&&(!cphase)) begin
			//spi_drv_if.spi_drv_cb.miso <= xtn.miso[7];
			for(int i =7;i>=0;i--) begin
				spi_drv_if.spi_drv_cb.miso <= xtn.miso[i];
				@(negedge spi_drv_if.spi_drv_cb.sclk);
			end
		end
		else if((!cpol)&&(cphase)) begin
		//	@(posedge spi_drv_if.spi_drv_cb);
		//	spi_drv_if.spi_drv_cb.miso <= xtn.miso[7];
			for(int i =7;i>=0;i--) begin
				@(posedge spi_drv_if.spi_drv_cb.sclk)
				spi_drv_if.spi_drv_cb.miso <= xtn.miso[i];
			end
		end
		else if((cpol)&&(!cphase)) begin
		//	spi_drv_if.spi_drv_cb.miso <= xtn.miso[7];
			for(int i =7;i>=0;i--) begin
				spi_drv_if.spi_drv_cb.miso <= xtn.miso[i];
				@(posedge spi_drv_if.spi_drv_cb.sclk);
			end
		end
		else if((cpol)&&(cphase)) begin
		//	@(negedge spi_drv_if.spi_drv_cb)
		//	spi_drv_if.spi_drv_cb.miso <= xtn.miso[7];
			for(int i =7;i>=0;i--) begin
				@(negedge spi_drv_if.spi_drv_cb.sclk)
				spi_drv_if.spi_drv_cb.miso <= xtn.miso[i];
			end
		end
	end

endtask





	

