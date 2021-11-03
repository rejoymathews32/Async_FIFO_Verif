// Author - Rejoy Roy Mathews
// This module defines a FIFO write driver

class c_async_fifo_write_drv extends uvm_driver#(c_async_fifo_write_trans);

  virtual async_fifo_write_if write_vif;
  c_async_fifo_write_trans write_tr;
  
  extern function new(string name = "c_async_fifo_write_drv", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  
  `uvm_component_utils(c_async_fifo_write_drv)

endclass // c_async_fifo_write_drv

function c_async_fifo_write_drv::new(string name = "c_async_fifo_write_drv", uvm_component parent = null);
  super.new(name, parent);
  
endfunction // new

function void c_async_fifo_write_drv::build_phase(uvm_phase phase);  
  if(!uvm_config_db#(virtual async_fifo_write_if)::get(this,"","write_vif",write_vif))
    `uvm_fatal(get_type_name(), "Write driver does not have access to write_vif")

  `uvm_info(get_type_name(), $sformatf("build phase completed"), UVM_LOW)

endfunction // build_phase

task c_async_fifo_write_drv::run_phase(uvm_phase phase);
  write_tr = c_async_fifo_write_trans::type_id::create("c_async_fifo_write_trans");

  forever begin
    // Get the next item from the sequencer
    seq_item_port.get_next_item(write_tr);
    `uvm_info(get_type_name(), $sformatf("Next item received"), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Received item fifo_push : 0x%x write_data : 0x%08x", write_tr.write_fifo_push, write_tr.write_data), UVM_LOW)
    
    
    @(posedge write_vif.write_clk);

    // Driver signals on the virtual interface
    write_vif.write_fifo_push <= write_tr.write_fifo_push;
    write_vif.write_data <= write_tr.write_data;

    // Update the sequencer that the driver has completed current item    
    seq_item_port.item_done();
  end
  
endtask // run_phase

