module slave_select_generator_tb;

        // Inputs
        reg PCLK;
        reg PRESET_n;
        reg mstr_i;
        reg send_data_i;
        reg spiwai_i;
        reg [1:0] spi_mode_i;
        reg [11:0] baudratedivisor_i;

        // Outputs
        wire ss_o;
        wire tip_o;
        wire receive_data_o;

        // Instantiate the Unit Under Test (UUT)
        slave_select_generator uut (
                .PCLK(PCLK),
                .PRESET_n(PRESET_n),
                .mstr_i(mstr_i),
                .send_data_i(send_data_i),
                .spiwai_i(spiwai_i),
                .spi_mode_i(spi_mode_i),
                .ss_o(ss_o),
                .baudratedivisor_i(baudratedivisor_i),
                .tip_o(tip_o),
                .receive_data_o(receive_data_o)
        );
        //clock generation
        always begin
                forever #5 PCLK=~PCLK;
        end

 //reset task
        task reset; begin
                @(negedge PCLK);
                PRESET_n=1'b0;
                @(negedge PCLK);
                PRESET_n=1'b1;
        end
endtask

        //stimulus task
        task stimulus; input i; begin
                @(negedge PCLK);
                mstr_i=1'b1;
                send_data_i=1;
                @(negedge PCLK);
                send_data_i=1'b0;
        end
endtask




        initial begin
                // Initialize Inputs
                PCLK = 0;
                reset;
                spiwai_i=1'b0;
                baudratedivisor_i = 8;
                spi_mode_i=2'b00;
                stimulus(1);

        end

endmodule
