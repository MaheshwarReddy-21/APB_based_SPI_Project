
/********************************************************************************************

Copyright 2024 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename                :       spi_core.v   

module Name             :       spi core

Description             :       Top Module for APB based SPI Core Design


*********************************************************************************************/
  `define APB_DATA_WIDTH 8
  `define SPI_REG_WIDTH 8
  `define APB_ADDR_WIDTH 3

 module spi_core(input PCLK,
	         input PRESETn,
		 input [`APB_ADDR_WIDTH-1:0] PADDR,
		 input PWRITE,
		 input PSEL,
		 input PENABLE,
		 input [`APB_DATA_WIDTH-1:0] PWDATA,
		 output [`APB_DATA_WIDTH-1:0] PRDATA,
		 output PREADY,
		 output PSLVERR,
		 input miso,
		 output ss,
		 output sclk,
		 output spi_interrupt_request,
		 output mosi);

  wire [`APB_DATA_WIDTH-1:0] miso_data;
  wire [`APB_DATA_WIDTH-1:0] mosi_data;
	
  wire send_data;
  wire receive_data;
  wire tip;
  wire [1:0] spi_mode;

  wire mstr;
  wire cpol;
  wire cpha;
  wire lsbfe;
  wire spiswai;
  wire [2:0] sppr;
  wire [2:0] spr;
  wire [11:0] BaudRateDivisor;

  apb_slave APB_INTERFACE(.PCLK(PCLK), .PRESETn(PRESETn), .PADDR(PADDR), .PWRITE(PWRITE),
	 		  .PSEL(PSEL), .PENABLE(PENABLE), .PWDATA(PWDATA), .PRDATA(PRDATA),
			  .PREADY(PREADY), .PSLVERR(PSLVERR), .ss(ss), .miso_data(miso_data),
			  .send_data(send_data), .receive_data(receive_data), .tip(tip), 
			  .mosi_data(mosi_data), .spi_mode(spi_mode), .mstr(mstr), .cpol(cpol), 
			  .cpha(cpha), .lsbfe(lsbfe), .spiswai(spiswai), .sppr(sppr), .spr(spr), 
			  .spi_interrupt_request(spi_interrupt_request));

  
  baud_generator BAUD_GEN(.PCLK(PCLK), .PRESETn(PRESETn), .spi_mode(spi_mode), .spiswai(spiswai), 
	  		  .sppr(sppr), .spr(spr), .ss(ss), .cpol(cpol), 
			  .sclk(sclk), .BaudRateDivisor(BaudRateDivisor));


  spi_slave_select SLAVE_SELECT(.PCLK(PCLK), .PRESETn(PRESETn), .spi_mode(spi_mode), .mstr(mstr), 
	  			.spiswai(spiswai), .send_data(send_data), .BaudRateDivisor(BaudRateDivisor), 
				.ss(ss), .receive_data(receive_data), .tip(tip));


  shifter SHIFTER(.PCLK(PCLK), .sclk(sclk), .PRESETn(PRESETn), .ss(ss), .send_data(send_data), 
	  	  .lsbfe(lsbfe), .cpha(cpha), .cpol(cpol), .data_mosi(mosi_data), .miso(miso), 
		  .receive_data(receive_data), .data_miso(miso_data), .mosi(mosi));

 endmodule

