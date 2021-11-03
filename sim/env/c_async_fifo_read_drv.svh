// Author - Rejoy Roy Mathews
// This module defines a FIFO read driver

class c_async_fifo_read_drv extends uvm_driver#(c_async_fifo_read_trans);

  virtual async_fifo_read_if read_vif;
  c_async_fifo_read_trans read_tr;
  
  extern function new(string name = "c_async_fifo_read_drv", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  
  `uvm_component_utils(c_async_fifo_read_drv)

endclass // c_async_fifo_read_drv

function c_async_fifo_read_drv::new(string name = "c_async_fifo_read_drv", uvm_component parent = null);
  super.new(name, parent);
  
endfunction // new

function void c_async_fifo_read_drv::build_phase(uvm_phase phase);  
  if(!uvm_config_db#(virtual async_fifo_read_if)::get(this,"","read_vif",read_vif))
    `uvm_fatal(get_type_name(), "Read driver does not have access to read_vif")
endfunction // build_phase

task c_async_fifo_read_drv::run_phase(uvm_phase phase);
  read_tr = c_async_fifo_read_trans::type_id::create("c_async_fifo_read_trans");

  forever begin
    // Get the next item from the sequencer
    seq_item_port.get_next_item(read_tr);
    
    @(posedge read_vif.read_clk);

    // Driver signals on the virtual interface
    read_vif.read_fifo_pop <= read_tr.read_fifo_pop;

    // Update the sequencer that the driver has completed current item    
    seq_item_port.item_done();
  end
  
endtask // run_phase

