class apb_monitor extends uvm_monitor;
	`uvm_component_utils(apb_monitor)

	uvm_analysis_port #(apb_xtn) apb_mon_port;
		apb_xtn xtn;

	virtual apb_intf.APB_MON_MP apb_mon_if;
	apb_config apb_cfg;


	extern function new(string name = "apb_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect();

endclass : apb_monitor


function apb_monitor :: new(string name = "apb_monitor", uvm_component parent);
	super.new(name,parent);
	apb_mon_port = new("apb_mon_port",this);
endfunction


function void apb_monitor :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(apb_config) :: get(this,"","apb_config",apb_cfg))
		`uvm_error(get_full_name(),"error while getting the apb_config");
endfunction


function void apb_monitor :: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	apb_mon_if = apb_cfg.apb_if;
endfunction

task apb_monitor :: run_phase(uvm_phase phase);
	super.run_phase(phase);
	
	forever 
	//	apb_xtn xtn;
		 //xtn = apb_xtn :: type_id :: create("xtn");
		collect();
	
endtask	

task apb_monitor :: collect();
	apb_xtn xtn;
	xtn = apb_xtn :: type_id :: create("xtn");

	$display("i am in monitor collect method");
	@(apb_mon_if.apb_mon_cb);

	// wait( xtn.PENABLE === 1 &&  xtn.PREADY === 1)// begin
	 wait( apb_mon_if.apb_mon_cb.PENABLE == 1 &&  apb_mon_if.apb_mon_cb.PREADY == 1)// begin
	//	$display("enable and ready values are %0d, %0d",apb_mon_if.apb_mon_cb.PENABLE,apb_mon_if.apb_mon_cb.PREADY);
		xtn.PRESETn = apb_mon_if.apb_mon_cb.PRESETn;
		xtn.PADDR = apb_mon_if.apb_mon_cb.PADDR;
		xtn.PWRITE = apb_mon_if.apb_mon_cb.PWRITE;
		xtn.PSEL = apb_mon_if.apb_mon_cb.PSEL;
		xtn.PENABLE = apb_mon_if.apb_mon_cb.PENABLE;
		xtn.PREADY = apb_mon_if.apb_mon_cb.PREADY;
		xtn.PSLVERR = apb_mon_if.apb_mon_cb.PSLVERR;
		if(apb_mon_if.apb_mon_cb.PWRITE)
			 xtn.PWDATA = apb_mon_if.apb_mon_cb.PWDATA;
		else 
			xtn.PRDATA = apb_mon_if.apb_mon_cb.PRDATA;
		`uvm_info(get_type_name(),$sformatf("the transaction from dut to apb_monitdor is \n %s",xtn.sprint()), UVM_LOW)
		apb_mon_port.write(xtn);
	//end
endtask
