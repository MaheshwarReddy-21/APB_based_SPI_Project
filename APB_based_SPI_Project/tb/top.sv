module top;

	import uvm_pkg::*;
	import spi_pkg::*;
	bit clock;

	always #5 clock = ~clock;

		apb_intf apb_if(clock);
		spi_intf spi_if(clock);




	spi_core DUT(.PCLK(clock), .PRESETn(apb_if.PRESETn), .PADDR(apb_if.PADDR), .PWRITE(apb_if.PWRITE), .PSEL(apb_if.PSEL), .PENABLE(apb_if.PENABLE), .PSLVERR(apb_if.PSLVERR),
			.PREADY(apb_if.PREADY), .PWDATA(apb_if.PWDATA), .PRDATA(apb_if.PRDATA), .miso(spi_if.miso), .ss(spi_if.ss), .sclk(spi_if.sclk),
			 .spi_interrupt_request(spi_if.spi_inpt_req), .mosi(spi_if.mosi));


/*	top_module DUT(.PCLK(clock), .PRESET_n(apb_if.PRESETn), .PWRITE_i(apb_if.PWRITE), .PSEL_i(apb_if.PSEL), .PENABLE_i(apb_if.PENABLE), .miso_i(spi_if.miso), .PADDR_i(apb_if.PADDR),
		.PWDATA_i(apb_if.PWDATA), .ss_o(spi_if.ss), .sclk_o(spi_if.sclk), .spi_interrupt_request_o(spi_if.spi_inpt_req), .mosi_o(spi_if.mosi), .PREADY_o(apb_if.PREADY), 
		.PSLVERR_o(apb_if.PSLVERR), .PRDATA_o(apb_if.PRDATA));
*/


	initial begin
				


		uvm_config_db #(virtual apb_intf) :: set(null,"*","apb_intf",apb_if);
		uvm_config_db #(virtual spi_intf) :: set(null,"*","spi_intf",spi_if);
	

		run_test();
	end
endmodule
