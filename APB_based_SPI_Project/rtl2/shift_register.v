

module shift_register(input PCLK,PRESET_n,ss_i,receive_data_i,send_data_i,miso_i,cpol_i,cphase_i,lsbfe_i,miso_receive_sclk_o,miso_receive_sclk0_o,
mosi_send_sclk_o,mosi_send_sclk0_o, input [7:0] data_mosi_i, output reg mosi_i, output [7:0] data_miso_i);

reg [7:0] shift_reg, temp_reg;
reg [2:0] count,count1,count2,count3;


//assigning temp_reg data to data_miso when receive_data is asserted
assign data_miso_i = receive_data_i?temp_reg:8'b00;


//shift register logic (shifting data from data_mosi to shift register)
always @(posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n) shift_reg <= 8'b0;
	else if(send_data_i) shift_reg <= data_mosi_i;
	else shift_reg <= shift_reg;
end


//count & count1 logic with shifting of 8 bit data of shift regiser to mosi
//line i.e., parallel to serial
always @(posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n) begin
		count <= 3'b0;
		count1 <= 3'b111;
		mosi_i <= 1'b0;
	end
	else begin
		if(ss_i) begin 
			count <= count;
			count1 <= count1;
			mosi_i <= mosi_i;
		end
		else begin
			if((!cpol_i && cphase_i) || (!cphase_i && cpol_i)) begin
				if(lsbfe_i) begin
					if(count<=3'b111) begin
						if(mosi_send_sclk0_o) begin
							count <= count+1'b1;
							mosi_i <= shift_reg[count];
						end
						else begin
							count <= count;
							mosi_i <= mosi_i;
						end	
					end
					else begin
						count <= 3'b0;	
						mosi_i <= 1'b0;
					end
				end
				else begin
					if(count1 >= 3'b0) begin
						if(mosi_send_sclk0_o) begin
							count1 <= count1-1'b1;
							mosi_i <= shift_reg[count1];
						end
						else begin
							count1 <= count1;
							mosi_i <= mosi_i;
						end
					end
					else begin
						count1 <= 3'b111;
						mosi_i <= 1'b0;
					end
				end
			end
			else begin
				if(lsbfe_i) begin
					if(count<=3'b111) begin
						if(mosi_send_sclk_o) begin
							count <= count+1'b1;
							mosi_i <= shift_reg[count];
						end
						else begin
							count <= count;
							mosi_i <= mosi_i;
						end	
					end
					else begin
						count <= 3'b0;	
						mosi_i <= 1'b0;
					end
				end
				else begin
					if(count1 >= 3'b0) begin
						if(mosi_send_sclk_o) begin
							count1 <= count1-1'b1;
							mosi_i <= shift_reg[count1];
						end
						else begin
							count1 <= count1;
							mosi_i <= mosi_i;
						end
					end
					else begin
						count1 <= 3'b111;
						mosi_i <= 1'b0;
					end
				end

			end
		end

	end
end


//count2 & count3 along with 1 bit miso data transfer to 8 bit temp reg
//serially as this temp is assigned to data_mosi(8bit)
always @(posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n) begin
		count2 <= 3'b0;
		count3 <= 3'b111;
		temp_reg <= 8'b0;
	end
	else begin
		if(ss_i) begin 
			count2 <= count;
			count3 <= count1;
			temp_reg[count2] <= temp_reg[count2];
			temp_reg[count3] <= temp_reg[count3];
		end
		else begin
			if((!cpol_i && cphase_i) || (!cphase_i && cpol_i)) begin
				if(lsbfe_i) begin
					if(count2<=3'b111) begin
						if(miso_receive_sclk0_o) begin
							count2 <= count2+1'b1;
							temp_reg[count2] <= miso_i;
						end
						else begin
							count2 <= count2;
							temp_reg[count2] <= temp_reg[count2];
						end	
					end
					else begin
						count2 <= 3'b0;	
						temp_reg[count2] <= 1'b0;
					end
				end
				else begin
					if(count3 >= 3'b0) begin
						if(miso_receive_sclk0_o) begin
							count3 <= count3-1'b1;
							temp_reg[count3] <= miso_i;
						end
						else begin
							count3 <= count3;
							temp_reg[count3] <= temp_reg[count3];
						end
					end
					else begin
						count3 <= 3'b111;
						temp_reg[count3] <=1'b0;
					end
				end
			end
			else begin
				if(lsbfe_i) begin
					if(count2<=3'b111) begin
						if(miso_receive_sclk_o) begin
							count2 <= count2+1'b1;
							temp_reg[count2] <= miso_i;
						end
						else begin
							count2 <= count2;
							temp_reg[count2] <= temp_reg[count2];
						end	
					end
					else begin
						count2 <= 3'b0;	
						temp_reg[count2] <= 1'b0;
					end
				end
				else begin
					if(count3 >= 3'b0) begin
						if(miso_receive_sclk_o) begin
							count3 <= count3-1'b1;
							temp_reg[count3] <= miso_i;
						end
						else begin
							count3 <= count3;
							temp_reg[count3] <= temp_reg[count3];
						end
					end
					else begin
						count3 <= 3'b111;
						temp_reg[count3] <=1'b0;
					end
				end

			end
		end

	end
end


endmodule
