
/********************************************************************************************

Copyright 2024 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename                :       shifter.v   

module Name             :       shifter

Description             :       Shifter Module for APB based SPI Core Design


*********************************************************************************************/
  `define APB_DATA_WIDTH 8
  `define SPI_REG_WIDTH 8
  `define APB_ADDR_WIDTH 3

 module shifter(
  input PCLK,
  input sclk,
  input PRESETn,
  input ss,
  input send_data,
  input lsbfe,
  input cpha,
  input cpol, 
  input [`APB_DATA_WIDTH-1:0] data_mosi,
  input miso,
  input receive_data,
  output [`APB_DATA_WIDTH-1:0] data_miso,
  output  mosi);

  reg [`APB_DATA_WIDTH-1:0] shift_register;

  reg [`APB_DATA_WIDTH-1:0] temp_reg1;
  reg [`APB_DATA_WIDTH-1:0] temp_reg2;

  reg [3:0] count;
  reg [3:0] count1;
  reg [3:0] count2;
  reg [3:0] count3;
  reg [3:0] count4;
  reg [3:0] count5;
  reg [3:0] count6;
  reg [3:0] count7;
  reg [3:0] count8;
  reg [3:0] count9;
  reg [3:0] count10;
  reg [3:0] count11;

  reg mosi1;
  reg mosi2;
  reg mosi3;
  reg mosi4;


	
  always@(posedge PCLK or negedge PRESETn)
    begin
      if(!PRESETn)
        begin
          shift_register <= 8'b0;
        end
      else if(send_data)
	shift_register <= data_mosi;
    end


  assign mosi = cpha?(cpol?mosi4:mosi3):(cpol?mosi2:mosi1);
  assign data_miso=receive_data?(((cpha&&cpol)||( !cpha && !cpol))?temp_reg1:temp_reg2):8'b0000_0000;

 
// Sending the MOSI Data - (CPHA 0 & CPOL 0) 
//
  always @(negedge sclk or negedge ss or negedge PRESETn or posedge receive_data)
    begin
      if(!PRESETn)
        begin
	  count <=4'd0;
	  count1<=4'd7;
        end
      else if(receive_data)
	begin
          count <= 4'd0;
	  count1<= 4'd7;
	end
      else
	begin
	  if(!ss)
            begin
	      if((!cpha) && (!cpol))
	        begin
		  if(lsbfe)
		    begin
		      if(count <= 4'd7)
		        begin
			  mosi1 <= shift_register[count];
			  count <= count +1'b1;
			end
		      else
		        begin
			  mosi1<= 1'b0;
			  count<= 4'd8;
		        end
		    end
		  else
	            begin
		      if(count1>= 4'd0)
		        begin
			  mosi1 <= shift_register[count1];
			  count1 <= count1 -1'b1;
		        end
		      else
		        begin
			  mosi1<= 1'b0;
			  count1<= 4'd15;
		        end
		    end
	        end
	      else
	        begin
		  mosi1<= 1'b0;
		  count<= 4'd8;
		  count1 <= 4'd15;
	        end
	    end
	  else
	    begin
	      mosi1<=1'b0;
	      count <= 4'd8;
	      count1<=4'd15;
	    end
        end
    end


    // Sending the MOSI Data - (CPHA 0 & CPOL 1) 
//
  always @(posedge sclk or negedge PRESETn or posedge receive_data)
    begin
      if(!PRESETn)
        begin
	  count2 <=4'd0;
	  count3<=4'd7;
        end
      else if(receive_data)
	begin
	  count2 <=4'd0;
	  count3<=4'd7;
	end
      else
	begin
	  if(!ss)
            begin
	      if((!cpha) && (cpol))
	        begin
		  if(lsbfe)
		    begin
		      if(count2 <= 4'd7)
		        begin
			  mosi2 <= shift_register[count2];
			  count2 <= count2 +1'b1;
			end
		      else
			begin
			  mosi2<=1'b0;
			  count2 <= 4'd8;
			end
		    end
		  else
	            begin
		      if(count3 >= 4'd0)
		        begin
			  mosi2 <= shift_register[count3];
			  count3 <= count3 -1'b1;
		        end
		      else
		        begin
			  mosi2<= 1'b0;
			  count3<= 4'd15;
		        end
		    end
	        end
	      else
	        begin
		  mosi2<= 1'b0;
		  count2<= 4'd8;
		  count3 <= 4'd15;
	        end
	    end
	  else
	    begin
	      mosi2<=1'b0;
	      count2 <= 4'd8;
	      count3<=4'd15;
	    end
        end
    end



// Sending the MOSI Data -(CPHA 1 or CPOL 0)
  always @(posedge sclk or negedge PRESETn or posedge receive_data)
    begin
      if(!PRESETn)
        begin
	  count4 <=4'd0;
	  count5 <=4'd7;
        end
      else if(receive_data)
        begin
	  count4 <=4'd0;
	  count5 <=4'd7;
        end
      else
	begin
	  if(!ss)
            begin
	      if (cpha && (!cpol))
	        begin
		  if(lsbfe)
		    begin
		      if(count4 <= 4'd7)
		        begin
			  mosi3 <= shift_register[count4];
			  count4 <= count4 +1'b1;
			end
		      else
		        begin
			  mosi3 <= 1'b0;
			  count4 <= 4'd8;
			end
		    end
		  else
	            begin
		      if(count5 >= 4'd0)
		        begin
			  mosi3 <= shift_register[count5];
			  count5 <= count5 -1'b1;
		        end
		      else
		        begin
			  mosi3<= 1'b0;
			  count5<= 4'd15;
		        end
		    end
	        end
	      else
	        begin
		  mosi3<= 1'b0;
		  count4<= 4'd8;
		  count5 <= 4'd15;
	        end
	    end
	  else
	    begin
	      mosi3<=1'b0;
	      count4 <= 4'd8;
	      count5<=4'd15;
	    end
        end
    end

    // Sending the MOSI Data -(CPHA 1 or CPOL 1)
  always @(negedge sclk or negedge PRESETn or posedge receive_data)
    begin
      if(!PRESETn)
        begin
	  count6 <=4'd0;
	  count7 <=4'd7;
        end
      else if(receive_data)
        begin
	  count6 <=4'd0;
	  count7 <=4'd7;
        end
      else
	begin
	  if(!ss)
            begin
	      if (cpha && cpol)
	        begin
		  if(lsbfe)
		    begin
		      if(count6 <= 4'd7)
		        begin
			  mosi4 <= shift_register[count6];
			  count6 <= count6 +1'b1;
			end
		      else
		        begin
			  mosi4 <= 1'b0;
			  count6<=4'd8;
		        end
		    end
		  else
	            begin
		      if(count7 >= 4'd0)
		        begin
			  mosi4 <= shift_register[count7];
			  count7 <= count7 -1'b1;
		        end
		      else
		        begin
			  mosi4<= 1'b0;
			  count7<= 4'd15;
		        end
		    end
	        end
	      else
	        begin
		  mosi4<= 1'b0;
		  count6<= 4'd8;
		  count7 <= 4'd15;
	        end
	    end
	  else
	    begin
	      mosi4<=1'b0;
	      count6 <= 4'd8;
	      count7<=4'd15;
	    end
        end
    end


// Logic for Receiving the MISO Data 
// for (CPHA 0 & CPOL 0) or (CPHA1 & CPOL 1)
  always @(posedge sclk or negedge PRESETn or posedge receive_data)
    begin
      if(!PRESETn)
	begin
	  count8<=4'd0;
	  count9<=4'd7;
	end
      else if(receive_data)
	begin
	  count8<=4'd0;
	  count9<=4'd7;
	end
      else
	begin
          if(!ss)
	    begin
	      if(( (!cpha) && (!cpol) ) || (cpha && cpol))
	        begin
		  if(lsbfe)
		    begin
		      if(count8 <= 4'd7)
		        begin
			  temp_reg1[count8]<=miso;
			  count8 <= count8+1'b1;
			end
	            end
		  else
		    begin
		      if(count9>= 4'd0)
		        begin
			  temp_reg1[count9]<= miso;
			  count9 <= count9-1'b1;
			end
		    end
		end
	      end
        end
    end

 // for (CPHA 1 & CPOL 0) or (CPHA0 & CPOL 1)
  always @(negedge sclk or negedge PRESETn or posedge receive_data)
    begin
      if(!PRESETn)
	begin
	  count10<=4'd0;
	  count11<=4'd7;
	end
     else if(receive_data)
	begin
	  count10<=4'd0;
	  count11<=4'd7;
	end
      else
	begin
          if(!ss)
	    begin
	      if(( cpha && (!cpol) ) || ((!cpha) && cpol))
	        begin
		  if(lsbfe)
		    begin
		      if(count10 <= 4'd7)
		        begin
			  temp_reg2[count10]<=miso;
			  count10 <= count10+1'b1;
			end
	            end
		  else
		    begin
		      if(count11>= 4'd0)
		        begin
			  temp_reg2[count11]<= miso;
			  count11 <= count11-1'b1;
			end
		    end
		end
	      end

        end
    end

endmodule

