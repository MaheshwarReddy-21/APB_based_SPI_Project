module APB_slave_interface_tb;
 // Clock & Reset
 reg PCLK;
 reg Presetn;
 // APB interface
 reg Psel;
 reg Penable;
 reg Pwrite;
 reg [3:0] Paddr;
 reg [7:0] Pwdata;
 // SPI interface
 reg ss;
 reg tip;
 reg [7:0] data_miso;
 reg receive_data;
 // Outputs
 wire [7:0] Prdata;
 wire Pready;
 wire Pslverr;
 wire mstr;
 wire cpol;
 wire cpha;
 wire lsbfe;
 wire spiswai;
 wire [2:0] sppr;
 wire [2:0] spr;
 wire spi_interrupt_request;
 wire send_data;
 wire [7:0] data_mosi;
 wire [1:0] spi_mode;
 //--------------------------------------
 // Clock Generation
 //--------------------------------------
 always #5 PCLK = ~PCLK;
 //--------------------------------------
 // Reset Task
 //--------------------------------------
 task reset;
 begin
 @(negedge PCLK);
 Presetn = 0;
 repeat (2) @(negedge PCLK);
 Presetn = 1;
 end
 endtask
//--------------------------------------
 // APB Write Task
 //--------------------------------------
 task apb_write(input [3:0] addr, input [7:0] data);
 begin
 @(negedge PCLK);
 Psel = 1;
 Pwrite = 1;
 Paddr = addr;
 Pwdata = data;
 Penable = 0;
 @(negedge PCLK);
 Penable = 1;
 @(negedge PCLK);
 $display("Write @ addr=%d = data=%d", addr, data);
 Penable = 0;
 end
 endtask
 //--------------------------------------
 // APB Read Task
 //--------------------------------------
 task apb_read(input [3:0] addr);
 begin
 @(negedge PCLK);
 Psel = 1;
 Pwrite = 0;
 Paddr = addr;
 Penable = 0;
 @(negedge PCLK);
 Penable = 1;
 @(negedge PCLK);
 $display("Read @ addr=%d = data=%d", addr, Prdata);
 Penable = 0;
 end
 endtask
 //--------------------------------------
 // Test SPI Interrupt Request
 //--------------------------------------
 task test_spi_interrupt();
 begin
 // Clear DR for spif/sptef
 apb_write(4'h5, 8'h00);

 // Case 1: spie = 0, sptie = 0
 apb_write(4'h0, 8'b0000_0111);
 // Case 2: spie = 1, sptie = 0
 apb_write(4'h0, 8'b1000_0111);
 // Case 3: spie = 0, sptie = 1
 apb_write(4'h0, 8'b0100_0111);
 // Case 4: spie = 1, sptie = 1
 apb_write(4'h0, 8'b1100_0111);
 end
 endtask
//--------------------------------------
 // Stimulus
 //--------------------------------------
 initial begin
 // Initial values
 PCLK = 0;
 Presetn = 1;
 Psel = 0;
 Paddr = 0;
 Pwdata = 0;
 Penable = 0;
 Pwrite = 0;
 ss = 1;
 tip = 0;
 data_miso = 8'h00;
 receive_data = 0;
 reset();
 // Configure Registers
 @(negedge PCLK);
 apb_write(4'h0, 8'b1111_0111); // CR1
 @(negedge PCLK);
 apb_write(4'h1, 8'b0001_0000); // CR2
 @(negedge PCLK);
 apb_write(4'h2, 8'b0000_0001); // BR
 @(negedge PCLK);
 apb_write(4'h5, 8'b0011_0011); // DR
 // Test Reads
 @(negedge PCLK);
 apb_read(4'h0); // CR1
 @(negedge PCLK);
 apb_read(4'h1); // CR2
 @(negedge PCLK);
 apb_read(4'h2); // BR
 @(negedge PCLK);
 apb_read(4'h5); // DR
 // Test SPI interrupt generation
 test_spi_interrupt();
 repeat (10) @(negedge PCLK);
 $finish;
 end
endmodule
