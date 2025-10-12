module APB_slave_interface(input PCLK,
 input Presetn,
 input Psel,
input [2:0]Paddr,
input [7:0]Pwdata,
 input Penable,
 input Pwrite,
 input ss,
input tip,
input [7:0]data_miso,
input receive_data,
 output reg [7:0]Prdata,
output Pready,
output Pslverr,
 output mstr,
output cpol,
output cpha,
output lsbfe,
 output spiswai,
 output [2:0]sppr,
output [2:0]spr,
 output reg spi_interrupt_request,
output reg send_data,
output reg[7:0]data_mosi,
output [1:0]spi_mode);
//-----------------------Parameters------------------------------------//
parameter cr2_mask = 8'b0001_0010,
 br_mask = 8'b0111_0111,
 APB_IDLE = 2'b00,
 APB_SETUP = 2'b01,
 APB_ENABLE = 2'b10,
 SPI_RUN = 2'b00,
 SPI_WAIT = 2'b01,
 SPI_STOP = 2'b10;
wire spie,spe,sptie,ssoe,modfen;
//-------------------------APB_STATES--------------------------------//
reg [1:0]APB_PRE_STATE,APB_NXT_STATE;
always@(posedge PCLK or negedge Presetn)
begin
 if(!Presetn)
 begin
 APB_PRE_STATE <= APB_IDLE;
 end
 else
 begin
 APB_PRE_STATE <= APB_NXT_STATE;
 end
end
always@(*)
begin
 case(APB_PRE_STATE)
 APB_IDLE : if(Psel && !Penable)
 APB_NXT_STATE = APB_SETUP;
 else if(Psel && Penable)
 APB_NXT_STATE = APB_ENABLE;
 else if(!Psel && !Penable)
 APB_NXT_STATE = APB_IDLE;
 else
 APB_NXT_STATE = APB_IDLE;
 APB_SETUP :
 if(Psel && Penable)
 APB_NXT_STATE = APB_ENABLE;
 else if(Psel && !Penable)
 APB_NXT_STATE =APB_SETUP;
 else
 APB_NXT_STATE = APB_IDLE;
 APB_ENABLE :
 if(Psel && !Penable)
 APB_NXT_STATE =APB_SETUP;
 else if(!Psel && !Penable)
 APB_NXT_STATE = APB_IDLE;
 else
 APB_NXT_STATE = APB_ENABLE;
default : APB_NXT_STATE = APB_IDLE;
endcase
end
//...............................SPI_STATE..........................//
reg[1:0]SPI_PRE_STATE,SPI_NXT_STATE;
always@(posedge PCLK or negedge Presetn)
begin
 if(!Presetn)
 begin
 SPI_PRE_STATE <= SPI_RUN;
 end
 else
 begin
 SPI_PRE_STATE <= SPI_NXT_STATE;
 end
end
always@(*)
begin
 case(SPI_PRE_STATE)
 SPI_RUN:
 if (~spe && spiswai)
 SPI_NXT_STATE = SPI_STOP;
 else if (~spe)
 SPI_NXT_STATE = SPI_WAIT;
 else
 SPI_NXT_STATE = SPI_RUN;
 SPI_WAIT:
 if(~spe && spiswai)
 SPI_NXT_STATE = SPI_STOP;
 else if(spe)
 SPI_NXT_STATE = SPI_RUN;
 else
 SPI_NXT_STATE = SPI_WAIT;

 SPI_STOP:
 if(~spe && ~spiswai)
 SPI_NXT_STATE = SPI_WAIT;
else if(spe)
 SPI_NXT_STATE = SPI_RUN;
 else
 SPI_NXT_STATE = SPI_STOP;
default : SPI_NXT_STATE = SPI_RUN;
 endcase
end
assign spi_mode = SPI_PRE_STATE;
wire wr_enb,rd_enb;
//-----------------------------------Pready-------------------------------------//
assign Pready = (APB_PRE_STATE == APB_ENABLE)?1'b1:1'b0;
//----------------------------------WRITE_ENABLE--------------------------------//
assign wr_enb = (APB_PRE_STATE == APB_ENABLE & Pwrite)? 1'b1:1'b0;
//---------------------------------Read_ENABLE----------------------------------//
assign rd_enb = (APB_PRE_STATE == APB_ENABLE & ~Pwrite)?1'b1:1'b0;
//----------------------------------Pslverr------------------------------------//
assign Pslverr = (APB_PRE_STATE == APB_ENABLE)?~tip:1'b0;
reg [7:0] spi_cr1, spi_cr2, spi_br, spi_dr,spi_sr;
//---------------------------------SPI_CR1-------------------------------------//
always @(posedge PCLK or negedge Presetn)
begin
 if (!Presetn)
 spi_cr1 <= 8'd4;
 else if (wr_enb && Paddr == 3'b000 )
 spi_cr1 <= Pwdata;
 else
 spi_cr1 <= spi_cr1;
end
assign lsbfe = spi_cr1[0];
assign ssoe = spi_cr1[1];
assign cpha = spi_cr1[2];
assign cpol = spi_cr1[3];
assign mstr = spi_cr1[4];
assign sptie = spi_cr1[5];
assign spe = spi_cr1[6];
assign spie = spi_cr1[7];
//------------------------------SPI_CR2---------------------------------------//
always @(posedge PCLK or negedge Presetn)
begin
 if (!Presetn)
 spi_cr2 <= 8'd0;
 else if (wr_enb && Paddr == 3'b001)
 spi_cr2 <= (Pwdata & cr2_mask);
 else
 spi_cr2 <= spi_cr2;
end
assign spiswai = spi_cr2[1];
assign modfen = spi_cr2[4];
//-----------------------------SPI_BR-----------------------------------------//
always @(posedge PCLK or negedge Presetn)
begin
 if (!Presetn)
 spi_br <= 8'd0;
 else if (wr_enb && Paddr == 3'b010)
 spi_br <= Pwdata & br_mask;
 else
 spi_br <= spi_br;
end
assign spr = spi_br[2:0];
assign sppr = spi_br[6:4];
//--------------------------------SPI_DR----------------------------------------//
always @(posedge PCLK or negedge Presetn)
begin
 if (!Presetn)
 begin
 spi_dr <= 8'd0;
 end
 else if (wr_enb)
 begin
 if (Paddr == 3'b101)
 spi_dr <= Pwdata;
 else if (((spi_mode == SPI_RUN) || (spi_mode == SPI_WAIT)) &&
receive_data)
 spi_dr <= data_miso;
 else
spi_dr <= spi_dr;
 end
 else
 begin
 if ((spi_dr == Pwdata) && (spi_dr != data_miso) && ((spi_mode ==
SPI_RUN) || (spi_mode == SPI_WAIT)))
 spi_dr <= 8'd0;
 else if (((spi_mode == SPI_RUN) || (spi_mode == SPI_WAIT)) &&
receive_data)
 spi_dr <= data_miso;
 else
 spi_dr <= spi_dr;
 end
end
//-----------------------SEND_DATA-------------------------------//
always @(posedge PCLK or negedge Presetn)
begin
 if (!Presetn)
 send_data <= 1'b0;
 else if (wr_enb)
 send_data <= send_data; // retain previous value
 else if ((spi_dr == Pwdata) && (spi_dr != data_miso) && ((spi_mode == SPI_RUN) || (spi_mode == SPI_WAIT)))
  //else if ((spi_dr == Pwdata) & ((spi_mode == SPI_RUN) || (spi_mode == SPI_WAIT)))

 send_data <= 1'b1;
 else
 send_data <= 1'b0;
end
//-----------------------mosi_data-------------------------------//
always @(posedge PCLK or negedge Presetn)
begin
 if (!Presetn)
 data_mosi <= 1'b0;
 else if ((spi_dr == Pwdata) && (spi_dr != data_miso) && ((spi_mode ==
SPI_RUN) || (spi_mode == SPI_WAIT)) && ~wr_enb)
 data_mosi <= spi_dr;
end
//------------------------ PRDATA (APB Read Mux) ------------------------
//
always @(posedge PCLK)
begin
 if (rd_enb)
 begin
 case (Paddr)
 3'b000: Prdata <= spi_cr1;
 3'b001: Prdata <= spi_cr2;
 3'b010: Prdata <= spi_br;
 3'b011: Prdata <= spi_sr;
 3'b101: Prdata <= spi_dr;
 default: Prdata <= 8'd0;
 endcase
 end
 else
 Prdata <= 8'd0;
end
wire sptef,spif,modf;
assign sptef = (spi_dr == 8'd0)?1'b1:1'b0;
assign spif = (spi_dr != 8'd0)?1'b1:1'b0;
assign modf = (~ss && mstr && modfen && ~ssoe);
//----------------------------SPI_SR-------------------------------------------//
always @(posedge PCLK or negedge Presetn)
begin
 if (!Presetn)
 spi_sr <= 8'b0010_0000;
 else
 spi_sr <= {spif, 1'b0, sptef, modf, 4'd0};
end
//---------------------------SPI_INTERRUPT_REQUEST------------------//
always @(*) begin
 if (~spie && ~sptie)
 spi_interrupt_request = 1'b0;
 else if (spie && ~sptie)
 spi_interrupt_request = (modf && spif);
 else if (~spie && sptie)
 spi_interrupt_request = sptef;
 else
 spi_interrupt_request = (spif && modf && sptef);
end
endmodule
