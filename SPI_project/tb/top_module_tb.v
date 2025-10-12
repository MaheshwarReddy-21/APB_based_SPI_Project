module top_module_tb;

        // Inputs
        reg PCLK;
        reg PRESET_n;
        reg PWRITE_i;
        reg PSEL_i;
        reg PENABLE_i;
        reg miso_i;
        reg [2:0] PADDR_i;
        reg [7:0] PWDATA_i;

        // Outputs
        wire ss_o;
        wire sclk_o;
        wire spi_interrupt_request_o;
        wire mosi_o;
        wire PREADY_o;
        wire PSLVERR_o;
        wire [7:0] PRDATA_o;

        // Instantiate the Unit Under Test (UUT)
        top_module uut (
                .PCLK(PCLK),
                .PRESET_n(PRESET_n),
                .PWRITE_i(PWRITE_i),
                .PSEL_i(PSEL_i),
                .PENABLE_i(PENABLE_i),
                .miso_i(miso_i),
                .PADDR_i(PADDR_i),
                .PWDATA_i(PWDATA_i),
                .ss_o(ss_o),
                .sclk_o(sclk_o),
                .spi_interrupt_request_o(spi_interrupt_request_o),
                .mosi_o(mosi_o),
                .PREADY_o(PREADY_o),
                .PSLVERR_o(PSLVERR_o),
                .PRDATA_o(PRDATA_o)
        );
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
 PRESET_n= 0;
 @(negedge PCLK);
 PRESET_n= 1;
 end
 endtask
 //--------------------------------------
 // APB Write Task
 //--------------------------------------
 task apb_write(input [3:0] addr, input [7:0] data);
 begin
// @(negedge PCLK);
 PSEL_i = 1;
 PWRITE_i = 1;
 PADDR_i = addr;
 PWDATA_i = data;
 PENABLE_i = 0;
 @(negedge PCLK);
 PENABLE_i = 1;
 @(negedge PCLK);
 $display("Write @ addr=%d = data=%d", addr, data);
 PENABLE_i = 0;
 end
 endtask
//--------------------------------------
 // APB Read Task
 //--------------------------------------
 task apb_read(input [3:0] addr);
 begin
 //@(negedge PCLK);
 PSEL_i = 1;
 PWRITE_i = 0;
 PADDR_i = addr;
 PENABLE_i = 0;
 @(negedge PCLK);
 PENABLE_i = 1;
 @(negedge PCLK);
 $display("Read @ addr=%d = data=%d", addr, PRDATA_o);
 PENABLE_i = 0;
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
                // Initialize Inputs
                PCLK = 0;
                PRESET_n = 0;
                PWRITE_i = 0;
                PSEL_i = 0;
                PENABLE_i = 0;
                miso_i = 1;
                PADDR_i = 0;
                PWDATA_i = 0;
reset();
 // Configure Registers
 @(negedge PCLK);
 apb_write(4'h0, 8'b1111_1111); // CR1
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
// test_spi_interrupt();
 repeat (10) @(negedge PCLK);
 //$finish;
end
endmodule
