module shift_register_tb;

        // Inputs
        reg PCLK;
        reg PRESET_n;
        reg ss_i;
        reg receive_data_i;
        reg send_data_i;
        reg miso_i;
        reg cpol_i;
        reg cphase_i;
        reg lsbfe_i;
        reg miso_receive_sclk_o;
        reg miso_receive_sclk0_o;
        reg mosi_send_sclk_o;
        reg mosi_send_sclk0_o;
        reg [7:0] data_mosi_i;

        // Outputs
        wire mosi_i;
        wire [7:0] data_miso_i;

        // Instantiate the Unit Under Test (UUT)
        shift_register uut (
                .PCLK(PCLK),
                .PRESET_n(PRESET_n),
                .ss_i(ss_i),
                .receive_data_i(receive_data_i),
                .send_data_i(send_data_i),
                .miso_i(miso_i),
                .cpol_i(cpol_i),
                .cphase_i(cphase_i),
                .lsbfe_i(lsbfe_i),
                .miso_receive_sclk_o(miso_receive_sclk_o),
                .miso_receive_sclk0_o(miso_receive_sclk0_o),
                .mosi_send_sclk_o(mosi_send_sclk_o),
                .mosi_send_sclk0_o(mosi_send_sclk0_o),
                .data_mosi_i(data_mosi_i),
                .mosi_i(mosi_i),
                .data_miso_i(data_miso_i)
        );

        //clock generation
        always #5 PCLK=~PCLK;
 //data input through data_mosi to shift_register
        task send_spi_data(input [7:0] spi_data, input lsb_first); begin
                send_data_i =1;
                data_mosi_i= spi_data;
                lsbfe_i=lsb_first;
                #10;
                send_data_i=0;
                end
        endtask

        //task data transfer
        task spi_transfer(input ss,a,b,c,d); begin
                ss_i=ss;
                mosi_send_sclk0_o=a;
                mosi_send_sclk_o=b;
                miso_receive_sclk0_o=c;
                miso_receive_sclk_o=d;
                #300;
                ss_i=1;
                end
        endtask
  initial begin
                // Initialize Inputs
                PCLK = 0;
                PRESET_n = 0;
                ss_i = 1;
                receive_data_i = 0;
                send_data_i = 0;
                miso_i = 0;
                cpol_i = 0;
                cphase_i = 0;
                lsbfe_i = 0;
                miso_receive_sclk_o = 0;
                miso_receive_sclk0_o = 0;
                mosi_send_sclk_o = 0;
                mosi_send_sclk0_o = 0;
                data_mosi_i = 0;
                #10;
                PRESET_n=1;
                send_spi_data(8'hA5,1);
                receive_data_i=0; miso_i=1; cpol_i=0; cphase_i=1;
                spi_transfer(0,1,1,1,0);
                receive_data_i=1;


                // Wait 100 ns for global reset to finish
                //#100;

                // Add stimulus here

        end

endmodule
