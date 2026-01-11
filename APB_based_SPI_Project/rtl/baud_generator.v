
/********************************************************************************************

Copyright 2024 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename                :       baud_generator.v

module Name             :       Baud Generator

Description             :       Baud generator module for APB based SPI Core Design


*********************************************************************************************/

 module baud_generator(input PCLK,
		      input PRESETn,
		      input [1:0] spi_mode, // indicates run_mode, wait_mode and stop_mode
	              input spiswai,
	              input [2:0] sppr, // SPI Baud Rate Preselection Bits
	              input [2:0] spr, // SPI Baud Rate Selection Bits
	              input cpol, // 0 - Idle Low, 1- Idle High
	              input ss, // Slave Selection 
		      output reg sclk,
	              output  [11:0]BaudRateDivisor);

  wire pre_sclk;
  reg[11:0] count;

  // Baud Rate Divisor
  assign BaudRateDivisor=((sppr+1)*(2**(spr+1)));
	  
	
  // Logic to generate pre_sclk based on the cpol
  assign pre_sclk=cpol? 1'b1 : 1'b0;

  // Logic to generate the Sclk
  always@(posedge PCLK or negedge PRESETn)
    begin
      if(!PRESETn)
        begin
	  count<=12'b0;
	  sclk<=pre_sclk;
	end
      else if((~ss) && (spi_mode == 2'b00 || (spi_mode == 2'b01 && (~spiswai))) )
	    begin
	      if(count==(BaudRateDivisor-1'b1))
	        begin
		  count<=12'b0;
		  sclk<=~sclk;
		end
	      else
	        count <= count+1'b1;
            end
       else
	    begin
	      sclk <= pre_sclk;
	      count<=12'b0;
	    end
    end
	  
 endmodule
