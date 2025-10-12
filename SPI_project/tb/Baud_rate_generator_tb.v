module baud_rate_generator_tb;

        // Inputs
        reg PCLK;
        reg PRESET_n;
        reg cpol_i;
        reg spiswai_i;
        reg [1:0] spi_mode_i;
        reg [2:0] spr_i;
        reg [2:0] sppr_i;
        reg ss_i;
        reg cphase_i;

        // Outputs
        wire sclk_o;
        wire [11:0] BaudRateDivisor_o;
        wire miso_receive_sclk_o;
        wire miso_receive_sclk0_o;
        wire mosi_send_sclk_o;
        wire mosi_send_sclk0_o;

        // Instantiate the Unit Under Test (UUT)
        baud_rate_generator uut (
                .PCLK(PCLK),
                .PRESET_n(PRESET_n),
                .cpol_i(cpol_i),
                .spiswai_i(spiswai_i),
                .spi_mode_i(spi_mode_i),
                .spr_i(spr_i),
                .sppr_i(sppr_i),
                .ss_i(ss_i),
                .sclk_o(sclk_o),
                .BaudRateDivisor_o(BaudRateDivisor_o),
                .cphase_i(cphase_i),
                .miso_receive_sclk_o(miso_receive_sclk_o),
                .miso_receive_sclk0_o(miso_receive_sclk0_o),
                .mosi_send_sclk_o(mosi_send_sclk_o),
                .mosi_send_sclk0_o(mosi_send_sclk0_o)
        );


        task initialize; begin
                // Initialize Inputs



                cpol_i = 0;
                spiswai_i = 0;
                spi_mode_i = 0;
                //spr_i = 1;
                //sppr_i = 0;
                ss_i = 0;
                cphase_i = 0;

                // Wait 100 ns for global reset to finish
                #10;
                end
                endtask
                //clk generation
                always begin
                        forever #10 PCLK=~PCLK;
                end

                task reset; begin
                        @(negedge PCLK);
                        PRESET_n=1'b0;
                        @(negedge PCLK);
                        PRESET_n=1'b1;
                end
        endtask
                task spimode ;input [1:0] i; begin
                        @(negedge PCLK);
                        spi_mode_i=i;
                        //spiswai_i=1'b0;
                end
        endtask
    initial begin
                PCLK = 0;
                initialize;
                        reset;
                        //{cpol_i,cphase_i}=2'b00;
                //      {cpol_i,cphase_i}=2'b01;
                //      {cpol_i,cphase_i}=2'b10;
                        {cpol_i,cphase_i}=2'b11;

                        sppr_i=3'b000;
                        spr_i=3'b010;
                        spimode (2'b00);
                end
                endmodule


