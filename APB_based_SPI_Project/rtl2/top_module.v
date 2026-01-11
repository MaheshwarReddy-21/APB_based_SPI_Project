

module top_module(
	input PCLK,PRESET_n,PWRITE_i,PSEL_i,PENABLE_i,miso_i,
	input [2:0] PADDR_i,
	input [7:0] PWDATA_i,
	output ss_o,sclk_o,spi_interrupt_request_o,mosi_o,PREADY_o,PSLVERR_o,
	output [7:0] PRDATA_o);


//baudrate generator 
wire cpol,cphase,spiswai,miso_receive_sclk,miso_receive_sclk0,mosi_send_sclk,mosi_send_sclk0;
wire [11:0] baud_rate_divisor;
wire [1:0] spi_mode;
wire [2:0] spr,sppr;
baud_rate_generator baud_generator(.PCLK(PCLK), .PRESET_n(PRESET_n), .cpol_i(cpol), 
.spi_mode_i(spi_mode), .spiswai_i(spiswai), .sppr_i(sppr), .spr_i(spr), .cphase_i(cphase), 
.ss_i(ss_o), .sclk_o(sclk_o), .miso_receive_sclk_o(miso_receive_sclk), .miso_receive_sclk0_o(miso_receive_sclk0),
 .mosi_send_sclk_o(mosi_send_sclk), .mosi_send_sclk0_o(mosi_send_sclk0), .BaudRateDivisor_o(baud_rate_divisor));


//slave select
wire mstr,send_data,receive_data,tip;
slave_select_generator slave_control(.PCLK(PCLK), .PRESET_n(PRESET_n), .mstr_i(mstr), .spiwai_i(spiswai),
 .spi_mode_i(spi_mode), .send_data_i(send_data), .baudratedivisor_i(baud_rate_divisor), 
 .receive_data_o(receive_data), .ss_o(ss_o), .tip_o(tip));

//shift register
wire lsbfe;
wire [7:0] data_mosi,data_miso;
shift_register shifter(.PCLK(PCLK), .PRESET_n(PRESET_n), .ss_i(ss_o), .send_data_i(send_data), 
.lsbfe_i(lsbfe), .cphase_i(cphase), .cpol_i(cpol), .miso_receive_sclk_o(miso_receive_sclk), 
.miso_receive_sclk0_o(miso_receive_sclk0), .mosi_send_sclk_o(mosi_send_sclk), .mosi_send_sclk0_o(mosi_send_sclk0), 
.data_mosi_i(data_mosi), .miso_i(miso_i), .receive_data_i(receive_data), .mosi_i(mosi_o), .data_miso_i(data_miso));


//slave interface

APB_slave_interface apb_slave(.PCLK(PCLK), .Presetn(PRESET_n), .Paddr(PADDR_i), .Pwrite(PWRITE_i), .Psel(PSEL_i), 
.Penable(PENABLE_i), .Pwdata(PWDATA_i), .ss(ss_o), .data_miso(data_miso), .receive_data(receive_data), .tip(tip),
 .Prdata(PRDATA_o), .mstr(mstr), .cpol(cpol), .cpha(cphase), .lsbfe(lsbfe), .spiswai(spiswai), .sppr(sppr), 
 .spr(spr), .spi_interrupt_request(spi_interrupt_request_o), .Pready(PREADY_o), .Pslverr(PSLVERR_o), .send_data(send_data), 
 .data_mosi(data_mosi), .spi_mode(spi_mode));


endmodule

