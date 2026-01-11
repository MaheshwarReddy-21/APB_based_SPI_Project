class apb_driver extends uvm_driver #(apb_xtn);
	`uvm_component_utils(apb_driver)
	

	virtual apb_intf.APB_DRV_MP apb_drv_if;
	apb_config apb_cfg;


	extern function new(string name = "apb_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task reset();
	extern task send_to_dut(apb_xtn xtn);

endclass : apb_driver


function apb_driver :: new(string name = "apb_driver", uvm_component parent);
	super.new(name,parent);
endfunction

function void apb_driver :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(apb_config) :: get(this,"","apb_config",apb_cfg))
		`uvm_error(get_full_name(),"error while getting the apb_config");

endfunction


function void apb_driver :: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	apb_drv_if = apb_cfg.apb_if;
endfunction


task apb_driver :: run_phase(uvm_phase phase);
	super.run_phase(phase);
	reset();
	forever begin
		$display("i am in apb_driver");
		seq_item_port.get_next_item(req);
		$display("after get next item");
		send_to_dut(req);
		seq_item_port.item_done();
	end
endtask

task apb_driver ::  send_to_dut(apb_xtn xtn);
	@(apb_drv_if.apb_drv_cb);
	apb_drv_if.apb_drv_cb.PRESETn <= 1'b1;
	apb_drv_if.apb_drv_cb.PADDR <= xtn.PADDR;
	apb_drv_if.apb_drv_cb.PWRITE <= xtn.PWRITE;
	apb_drv_if.apb_drv_cb.PSEL <= 1'b1;
	apb_drv_if.apb_drv_cb.PENABLE <= 1'b0;

	//PSEL = 1, PENABLE = 0 setup phase
	//check for pwrite if true then send pwdata
	//else receive the prdata in next cycle

	if(xtn.PWRITE) 
	apb_drv_if.apb_drv_cb.PWDATA <= xtn.PWDATA;
	@(apb_drv_if.apb_drv_cb);
	apb_drv_if.apb_drv_cb.PENABLE <= 1'b1; //initiate enable phase

	wait(apb_drv_if.apb_drv_cb.PREADY == 1); //waiting for DUT to be ready
	if(xtn.PWRITE == 1'b0)
		 xtn.PRDATA = apb_drv_if.apb_drv_cb.PRDATA;

	//written to latch the data for adapter (for built in sequence)
	`uvm_info(get_type_name(),$sformatf("the transaction sent to dut is \n %s",xtn.sprint()), UVM_LOW)

	@(apb_drv_if.apb_drv_cb);	
	apb_drv_if.apb_drv_cb.PSEL <= 1'b0;
	apb_drv_if.apb_drv_cb.PENABLE <= 1'b0; //reset control signals
endtask

task apb_driver :: reset();
	@(apb_drv_if.apb_drv_cb);
		apb_drv_if.apb_drv_cb.PRESETn <= 1'b0;
//	repeat(3)
 @(apb_drv_if.apb_drv_cb);
	apb_drv_if.apb_drv_cb.PRESETn <= 1'b1;
endtask
