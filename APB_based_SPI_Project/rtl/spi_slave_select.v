
/********************************************************************************************

Copyright 2024 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename                :       spi_slave_select.v   

module Name             :       spi slave select

Description             :       spi slave select module for APB based SPI Core Design


*********************************************************************************************/

 module spi_slave_select(input PRESETn,
 		         input [1:0] spi_mode,
  			 input mstr,
  			 input spiswai,
  			 input PCLK,
  			 input send_data,
  			 input [11:0] BaudRateDivisor,
                         output reg ss,
  			 output reg receive_data,
  			 output tip);

  reg[15:0] count;//
  wire [15:0] target;//
  reg rcv;//

  assign target=BaudRateDivisor*5'd16;//doubt
  assign tip = (~ss);

  // Logic to generate the ss as low when new data is received to Data
  // Register through PWDATA Bus(send_data signal will become high)
  always@(negedge PRESETn or posedge PCLK)
    begin
      if(!PRESETn)
        begin
          count<=16'hffff;
	  ss<=1'b1;
	  rcv<=1'b0;
	end
      else if(mstr && (spi_mode == 2'b00 || (spi_mode == 2'b01 && (~spiswai)))) //Checking whether spi is in run mode or wait mode
	begin
          if(send_data)
	    begin
	      ss <= 1'b0;
	      count<= 16'h0;
	    end
	  else if(count <= (target-1'b1))
	    begin
	      ss<=1'b0;
	      count <= count +1'b1;
	      if(count==(target-1'b1))
	      	rcv<=1'b1;
	    end
	  else
            begin
	      ss <= 1'b1;
	      rcv<=1'b0;
	      count <= 16'hffff;
	    end
	end
      else
        begin
          ss<=1'b1;
	  rcv<=1'b0;
	  count <= 16'hffff;
	end	
    end

 
  // generate receive_data after one clock cycle so all it will to make sure
  // MISO is collected proprly. 
  always@(posedge PCLK or negedge PRESETn)
    begin
      if(!PRESETn)
        receive_data <= 1'b0;
      else
	receive_data <= rcv;
    end

 endmodule

