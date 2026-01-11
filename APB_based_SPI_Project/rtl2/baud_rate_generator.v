

module baud_rate_generator(PCLK,PRESET_n,cpol_i,spiswai_i,spi_mode_i,spr_i,sppr_i,ss_i,sclk_o,BaudRateDivisor_o,cphase_i,miso_receive_sclk_o,miso_receive_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o);
input PCLK,PRESET_n,cpol_i,spiswai_i,ss_i,cphase_i;
input [1:0] spi_mode_i;
input [2:0] spr_i,sppr_i;
output reg sclk_o,miso_receive_sclk_o,miso_receive_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o;
output [11:0] BaudRateDivisor_o;
wire pre_sclk;
reg [11:0] count;

//Baud rate calculation

assign BaudRateDivisor_o = (sppr_i+1)*2**(spr_i+1);
assign pre_sclk = cpol_i?1'b1:1'b0;


//count logic
always @ (posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n) begin
		count <= 12'b0;
		//sclk_o <= pre_sclk;
	end
	else if(!ss_i && !spiswai_i && (spi_mode_i == 2'b01 || spi_mode_i == 2'b00)) begin
		if(count == (BaudRateDivisor_o/2 -1'b1)) begin
			count <=12'b0;
		//	sclk_o <= ~sclk_o;
		end
		else begin
			count <= count+1'b1;
		//	sclk_o <= sclk_o;
		end	
 	end
	else begin
	       	count <= 12'b0;
	//	sclk_o <= pre_sclk;
	end
end


//sclk geneation using count values
always @ (posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n)
		sclk_o <= pre_sclk;
	else if (!ss_i && !spiswai_i && (spi_mode_i ==2'b01 || spi_mode_i == 2'b00)) begin
		if(count ==(BaudRateDivisor_o/2 -1'b1))
			sclk_o <= ~sclk_o;
		else
			sclk_o <= sclk_o;
	end
	else
		sclk_o <= pre_sclk;
end




//miso logic
always @(posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n) begin
		miso_receive_sclk_o <= 1'b0;
		miso_receive_sclk0_o <= 1'b0;
	end
	else begin
		if((!cphase_i && cpol_i) || (!cpol_i && cphase_i)) begin
			if(sclk_o) begin
				if(count == (BaudRateDivisor_o/2 -1'b1))
					miso_receive_sclk0_o <=1'b1;
				else
					miso_receive_sclk0_o <= 1'b0;
			end
			else
				miso_receive_sclk0_o <= 1'b0;
		end
		else begin
			if(!sclk_o) begin
				if(count ==(BaudRateDivisor_o/2 -1'b1))
					miso_receive_sclk_o <= 1'b1;
				else
					miso_receive_sclk_o <= 1'b0;
			end
			else
				miso_receive_sclk_o <= 1'b0;
		end
	end
end


//mosi logic
always @(posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n) begin
		mosi_send_sclk_o <= 1'b0;
		mosi_send_sclk0_o <= 1'b0;
	end
	else begin
		if((!cphase_i && cpol_i) || (!cpol_i && cphase_i)) begin
			if(sclk_o) begin
				if(count == (BaudRateDivisor_o/2 -2'b10))
					mosi_send_sclk0_o <=1'b1;
				else
					mosi_send_sclk0_o <= 1'b0;
			end
			else
				mosi_send_sclk0_o <= 1'b0;
		end
		else begin
			if(!sclk_o) begin
				if(count ==(BaudRateDivisor_o/2 -2'b10))
					mosi_send_sclk_o <= 1'b1;
				else
					mosi_send_sclk_o <= 1'b0;
			end
			else
				mosi_send_sclk_o <= 1'b0;
		end
	end
end


endmodule

