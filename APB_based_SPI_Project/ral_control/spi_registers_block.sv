class spi_reg_block extends uvm_reg_block;
    `uvm_object_utils(spi_reg_block)
    uvm_reg_map spi_reg_map;
    //spi_reg_access_wrapper spi_reg_cg; //for front door
    rand spi_reg_file_control_register1 cntr_reg1;
    rand spi_reg_file_control_register2 cntr_reg2;
    rand spi_reg_file_baud_register baud_reg;
    rand spi_reg_file_status_register status_reg;
    rand spi_reg_file_data_register data_reg;

    function new(string name ="spi_reg_block");
        super.new(name,build_coverage(UVM_CVR_ALL));
    endfunction

    function void build();
     /*   if(has_coverage(UVM_CVR_ALL)) //checks whether coverage is enabled and creates a covergroup wrapper to sample data combination
        begin
            spi_reg_cg = spi_reg_access_wrapper :: type_id :: create("spi_reg_cg");//creates an instance of a covergroup wrapper class, 
            //which typically wraps a covergroup to track data combinations field access..
            set_coverage(UVM_CVR_ALL); //enable full register level coverage collection
        end*/
        cntr_reg1 = spi_reg_file_control_register1 :: type_id :: create("cntr_reg1");
        cntr_reg2 = spi_reg_file_control_register2 :: type_id :: create("cntr_reg2");
        baud_reg =  spi_reg_file_baud_register :: type_id :: create("baud_reg");
        status_reg = spi_reg_file_status_register :: type_id :: create("status_reg");
        data_reg = spi_reg_file_data_register :: type_id :: create("data_reg");


        cntr_reg1.configure(this,null,"");
        //this - parent register block (here it is spi_reg_block)
        //null - skips setting a static hdl path path used in back door access
        //"" - sets the default name of the register instance (useful in backdoor path building or printing)
        cntr_reg2.configure(this,null,"");
        baud_reg.configure(this,null,"");
        status_reg.configure(this,null,"");
        data_reg.configure(this,null,"");

        //to create and configure fields
        cntr_reg1.build();
        cntr_reg2.build();
        baud_reg.build();
        status_reg.build();
        data_reg.build();
        

        add_hdl_path("top.DUT","RTL"); //binds register fields to rtl signal paths for backdoor access
        //it tells the register block (via uvm _reg_block) where in the hierarchy the DUT's registers are located ..
        //"top.DUT" is the base path under which all teh registers live.top
        //"RTL" is the just used to indicate that the path correspondins to the RTL view -DUT-->APB_INTERFACE
        cntr_reg1.add_hdl_path_slice("APB_INTERFACE.SPI_CR_1",0,8); //maps a register field to a specific slice of an HDL path
        //syntax : add_hdl_path_slice(<signal_path>,<lsb_position>,<number_of_bits>);
        cntr_reg2.add_hdl_path_slice("APB_INTERFACE.SPI_CR_2",0,8);
        baud_reg.add_hdl_path_slice("APB_INTERFACE.SPI_BR",0,8);
        status_reg.add_hdl_path_slice("APB_INTERFACE.SPI_SR",0,8);
        data_reg.add_hdl_path_slice("APB_INTERFACE.SPI_DR",0,8);






/*
	add_hdl_path("top.DUT","RTL"); //binds register fields to rtl signal paths for backdoor access
        //it tells the register block (via uvm _reg_block) where in the hierarchy the DUT's registers are located ..
        //"top.DUT" is the base path under which all teh registers live.top
        //"RTL" is the just used to indicate that the path correspondins to the RTL view -DUT-->APB_INTERFACE
        cntr_reg1.add_hdl_path_slice("apb_slave.spi_cr1",0,8); //maps a register field to a specific slice of an HDL path
        //syntax : add_hdl_path_slice(<signal_path>,<lsb_position>,<number_of_bits>);
        cntr_reg2.add_hdl_path_slice("apb_slave.spi_cr2",0,8);
        baud_reg.add_hdl_path_slice("apb_slave.spi_br",0,8);
        status_reg.add_hdl_path_slice("apb_slave.spi_sr",0,8);
        data_reg.add_hdl_path_slice("apb_slave.spi_dr",0,8);

*/





        //associates logical address mapping for front door access .. not required for back door - without create map also we can still do write to DUT registers.
        //0 no special byte lane policy (normal/default behaviour).
        spi_reg_map = create_map("spi_reg_map",'h0,1,UVM_LITTLE_ENDIAN,0);
        //spi_reg_map - name of the register map,
        //'h0 - base address of the map is 0x0,
        //1 - addressing is byte_wise (each address steps by 1 byte)
        //0 - normal/default behaviour
        
        //add a register to a register map - required for front door access

        spi_reg_map.add_reg(cntr_reg1,8'h0,"RW");
        spi_reg_map.add_reg(cntr_reg2,8'h1,"RW");
        spi_reg_map.add_reg(baud_reg,8'h2,"RW");
        spi_reg_map.add_reg(status_reg,8'h3,"RO");
        spi_reg_map.add_reg(data_reg,8'h5,"RW");


        //no register bit bash test
        //all writable bits can be written correctly , all readable bits reflect what was written , bits marked as read_only or reserved behave correctly
        //for data register and status register bit bash test will not be performed

	lock_model();

	endfunction

endclass
