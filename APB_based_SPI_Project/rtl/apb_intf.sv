
/********************************************************************************************

Copyright 2024 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename                :       apb_intf.sv   

module Name             :       apb intf

Description             :       APB Interface for SPI Core Testbench


*********************************************************************************************/

 interface apb_intf(input bit clock);
   bit PCLK;
   logic PRESETn;
   logic PWRITE;
   logic PSEL;
   logic PENABLE;
   logic [2:0] PADDR;
   logic [7:0] PWDATA;
   logic [7:0] PRDATA;
   logic PREADY;
   logic PSLVERR;

   assign PCLK = clock;//Connects TB clock to APB protocol signal //In APB, TB owns the clock → needs assign PCLK = clock;

   //APB Driver Clocking Block
   clocking apb_drv_cb @(posedge clock);
     default input #1 output #1;
     output PRESETn;
     output PWRITE;
     output PSEL;
     output PENABLE;
     output PADDR;
     output PWDATA;
     input PRDATA;
     input PREADY;
     input PSLVERR;
   endclocking

   //APB Monitor Clocking Block
   clocking apb_mon_cb @(posedge clock);
     default input #1 output #1;
     input PRESETn;
     input PWRITE;
     input PSEL;
     input PENABLE;
     input PADDR;
     input PWDATA;
     input PRDATA; 
     input PREADY;
     input PSLVERR;
   endclocking

   modport APB_DRV_MP (clocking apb_drv_cb);
   modport APB_MON_MP (clocking apb_mon_cb);

/*   //-------------- Assertions -------------
   property signals_stable;
     @(posedge clock) $rose(PSEL)|-> ($stable(PWRITE) && 
					$stable(PADDR) &&
					$stable(PWDATA)) until PREADY[->1];
   endproperty

   property penable_stable;
     @(posedge clock) $rose(PENABLE)|->($stable(PSEL) && 
			$stable(PENABLE)) until PREADY [->1];
   endproperty

   property psel_to_pready;
     @(posedge clock) (PSEL && PENABLE ) |->##[0:$] PREADY;
   endproperty

   property address_reserved;
     @(posedge clock) PSEL |-> ((PADDR!=3'b100) || (PADDR !=3'b110)||(PADDR!=3'b111)); 
   endproperty

   property penable_deassert;
     @(posedge clock) (!PSEL) |-> (!PENABLE);
   endproperty

   property valid_write_data_transfer;
     @(posedge clock) (PSEL && PENABLE && PWRITE) |->(PWDATA !== 'hx);
   endproperty

   property valid_read_data_transfer;
     @(posedge clock) (PSEL && PENABLE && (!PWRITE)) |-> (PRDATA !== 'hx);
   endproperty

   property pready_low_at_start;
     @(posedge clock) (PSEL && (!PENABLE))|-> (!PREADY);
   endproperty

   property pready_deassert;
     @(posedge clock) (!PSEL) |-> (!PREADY);
   endproperty

   SIGNAL_STABLE	: assert property(signals_stable)
				$info("signal stablity is verified");
			  else 
                                $error("signal stablity is not verified");

   PENABLE_STABLE	: assert property(penable_stable)
				$info("Penable is stable until Pready is high");
			  else 
				$error("Penable is not stable");
   PSEL_TO_PREADY	: assert property(psel_to_pready)
			  	$info("Psel&Penable to Pready is verified ");
			  else 
				$error("Psel&Pneable is not verified");

   ADDRESS_RESERVED	: assert property(address_reserved)
				$info("reserved addresses are verified");
			  else 
				$error("Reserved addresses are not verified");

   PENABLE_DEASSERT	: assert property(penable_deassert)
			        $info("When Psel goes low even Penable should go low is verified");
			  else 
				$error("When Psel goes low even Penable should go low is verified");
   PWDATA_TRANSFER	: assert property(valid_write_data_transfer)
			        $info("Valid Write Data Transfer");
			  else
				$error("Valid write Data Transfer Failed");
   PRDATA_TRANSFER	: assert property(valid_read_data_transfer)
				$info("valid read data transfer");
		          else
				$error("valid read data transfer failed");
   PREADY_START		: assert property(pready_low_at_start)
			        $info("Pready is low at the start");
			  else
				$error("Pready is not low at the start");	
   PREADY_DEASSERT	: assert property(pready_deassert)
				$info("Pready is low when Psel goes low");
			  else
				$error("Pready is not low when Psel is low");*/
 endinterface
