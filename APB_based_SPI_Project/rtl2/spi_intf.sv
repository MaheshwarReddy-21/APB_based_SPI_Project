
/********************************************************************************************

Copyright 2024 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename                :       spi_intf.sv   

module Name             :       spi intf

Description             :       SPI Interface for SPI Core Testbench


*********************************************************************************************/
  interface spi_intf(input bit clock);//In SPI, DUT owns the clock (SCLK) → testbench just listens → no assignment needed
   logic ss;
   logic sclk;
   logic mosi;
   logic miso;
   logic spi_inpt_req;

   clocking spi_drv_cb@(posedge clock);
     default input #1 output #1;
     input ss;
     input sclk;
     input mosi;
     output miso;
     input spi_inpt_req;
   endclocking

   clocking spi_mon_cb@(posedge clock);
     default input #1 output #1;
     input ss;
     input sclk;
     input mosi;
     input miso;
     input spi_inpt_req;
   endclocking 

   modport SPI_DRV_MP (clocking spi_drv_cb);
   modport SPI_MON_MP (clocking spi_mon_cb);
 endinterface
