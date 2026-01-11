class spi_monitor extends uvm_monitor;
	`uvm_component_utils(spi_monitor)

	uvm_analysis_port #(spi_xtn) spi_mon_port;
	
	virtual spi_intf.SPI_MON_MP spi_mon_if;
	spi_config spi_cfg;
	
	bit cpol;
	bit cphase;
	bit lsbfe;
	bit [7:0] ctrl;


	extern function new(string name = "spi_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect();

endclass : spi_monitor


function spi_monitor :: new(string name = "spi_monitor", uvm_component parent);
	super.new(name,parent);
	spi_mon_port = new("spi_mon_port",this);
endfunction

function void spi_monitor :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(spi_config) :: get(this,"","spi_config",spi_cfg))
		`uvm_error(get_full_name(),"error while getting the spi_config");

	if(!uvm_config_db #(bit[7:0]) :: get(this,"*","bit",ctrl))
		`uvm_error(get_full_name(),"error while getting ctrl ");
endfunction


function void spi_monitor :: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	spi_mon_if = spi_cfg.spi_if;

	lsbfe = ctrl[0];
	cphase = ctrl[2];
	cpol = ctrl [3];
//	rst_seqsh = reset_vseqs :: type_id :: create("rst_seqsh");

endfunction

task spi_monitor :: run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
		collect();
	end
endtask

task spi_monitor :: collect();
	spi_xtn xtn = spi_xtn :: type_id :: create("xtn");
	$display("i am in spi monitor collect method");
//	@(spi_mon_if.spi_mon_cb.sclk);

	$display("spi monitor ss = %0d",spi_mon_if.spi_mon_cb.ss);

	wait(!spi_mon_if.spi_mon_cb.ss);
	if(lsbfe) begin
		for(int i=0;i<8;i++) begin
			if(((!cpol) && (!cphase)) || ((cpol) && (cphase))) begin
				@(posedge spi_mon_if.spi_mon_cb.sclk) begin
				xtn.mosi[i] = spi_mon_if.spi_mon_cb.mosi;
				xtn.miso[i] = spi_mon_if.spi_mon_cb.miso;
				xtn.ss = spi_mon_if.spi_mon_cb.ss;
				xtn.spi_inpt_req = spi_mon_if.spi_mon_cb.spi_inpt_req;
				end
			end
			else begin
				@(negedge spi_mon_if.spi_mon_cb.sclk) begin
				xtn.mosi[i] = spi_mon_if.spi_mon_cb.mosi;
				xtn.miso[i] = spi_mon_if.spi_mon_cb.miso;
				xtn.ss = spi_mon_if.spi_mon_cb.ss;
				xtn.spi_inpt_req = spi_mon_if.spi_mon_cb.spi_inpt_req;
				$display("IN THE SPI MONITOR %p",xtn.mosi[i]);
				end
			end
		end
	end
	else begin
		for(int i=7;i>=0;i--) begin
			if(((!cpol) && (!cphase)) || ((cpol) && (cphase))) begin
				@(posedge spi_mon_if.spi_mon_cb.sclk) begin
				xtn.mosi[i] = spi_mon_if.spi_mon_cb.mosi;
				xtn.miso[i] = spi_mon_if.spi_mon_cb.miso;
				xtn.ss = spi_mon_if.spi_mon_cb.ss;
				xtn.spi_inpt_req = spi_mon_if.spi_mon_cb.spi_inpt_req;
				end
			end
			else begin
				@(negedge spi_mon_if.spi_mon_cb.sclk) begin
				xtn.mosi[i] = spi_mon_if.spi_mon_cb.mosi;
				xtn.miso[i] = spi_mon_if.spi_mon_cb.miso;
				xtn.ss = spi_mon_if.spi_mon_cb.ss;
				xtn.spi_inpt_req = spi_mon_if.spi_mon_cb.spi_inpt_req;
				end
			end
		end
	end
	`uvm_info(get_type_name(),$sformatf("the transaction from dut to spi_monitdor is \n %s",xtn.sprint()), UVM_LOW)
	spi_mon_port.write(xtn);
	@(spi_mon_if.spi_mon_cb.sclk);
endtask



