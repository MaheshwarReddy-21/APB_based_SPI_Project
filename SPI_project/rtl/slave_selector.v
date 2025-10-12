module slave_select_generator(PCLK, PRESET_n, mstr_i, send_data_i, spiwai_i, spi_mode_i, ss_o, baudratedivisor_i, tip_o, receive_data_o);
input PCLK, PRESET_n, mstr_i, send_data_i, spiwai_i;
input [1:0] spi_mode_i;
input [11:0] baudratedivisor_i;
output reg ss_o, receive_data_o;
output tip_o;

reg [15:0] count_s;
wire [15:0] target_s;
reg rcv_s;

//assigning spi_modes to spi_run for 00 and spi_wait for 01
parameter spi_run=2'b00, spi_wait=2'b01;

//instantiating baudrate_generator
//baud_rate_generator B1(.BaudRateDivisor_o(baudratedivisor_i), .spiswai_i(spiwai_i), .spi_mode_i(spi_mode_i), .PCLK(PCLK),.PRESET_n(PRESET_n), .ss_i(ss_o));


assign tip_o=~ss_o;
assign target_s = 16*(baudratedivisor_i/2);


//logic for receive_data_o
always @(posedge PCLK or negedge PRESET_n) begin
        if(!PRESET_n)
                receive_data_o <= 1'b0;
        else
                receive_data_o <= rcv_s;
end
//logic for rcv that is present in receive_data_o logic
always @(posedge PCLK or negedge PRESET_n) begin
        if(!PRESET_n) rcv_s <= 1'b0;
        else begin
                if(!spiwai_i && mstr_i && (spi_mode_i == spi_run || spi_mode_i == spi_wait)) begin
                        if(send_data_i) rcv_s <= 1'b0;
                        else begin
                                if(count_s <= (target_s-1'b1)) begin
                                       if(count_s == (target_s-1'b1))   rcv_s <= 1'b1;
                                       else rcv_s <= 1'b0;
                               end
                                else rcv_s <= 1'b0;
                        end
                end
                else rcv_s <= 1'b0;

        end
end


//logic for ss_o
always @(posedge PCLK or negedge PRESET_n) begin
        if(!PRESET_n) ss_o <= 1'b1;
        else begin
                if(!spiwai_i & mstr_i & (spi_mode_i == spi_run | spi_mode_i == spi_wait)) begin
                        if(send_data_i) ss_o <= 1'b0;
                        else begin
                                if(count_s <=(target_s-1'b1)) ss_o <= 1'b0;
                                else ss_o <= 1'b1;
                        end
                end
                else ss_o <= 1'b1;
        end
end
//logic for count_s
always @(posedge PCLK or negedge PRESET_n) begin
        if(!PRESET_n) count_s <= 16'hffff;
        else begin
                if(!spiwai_i && mstr_i && (spi_mode_i == spi_run || spi_mode_i == spi_wait)) begin
                        if(send_data_i) count_s <= 16'h0;
                        else begin
                                if(count_s <= target_s-1'b1) count_s <= count_s+1'b1;
                                else count_s <= 16'hffff;
                        end
                end
                else count_s <= 16'hffff;
        end
end

endmodule
