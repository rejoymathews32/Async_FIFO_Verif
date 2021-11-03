// Author - Rejoy Roy Mathews
// This module defines a FIFO write monitor

class c_async_fifo_write_mon extends uvm_monitor;

  virtual async_fifo_write_if write_vif;
  uvm_analysis_port #(c_async_fifo_write_trans) write_ap;
  c_async_fifo_write_trans write_tr;
  
  extern function new (string name = "c_async_fifo_write_mon", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  `uvm_component_utils(c_async_fifo_write_mon)
  
endclass // c_async_fifo_write_mon

function c_async_fifo_write_mon::new(string name = "c_async_fifo_write_mon", uvm_component parent = null);
  super.new(name,parent);  
endfunction // new

function void c_async_fifo_write_mon::build_phase(uvm_phase phase);
  write_ap = new("async_fifo_write_mon_ap", this);
  
  if(!uvm_config_db#(virtual async_fifo_write_if)::get(this,"","write_vif",write_vif))
    `uvm_fatal(get_type_name(), "Write montior does not have access to write_vif")

  `uvm_info(get_type_name(), $sformatf("build phase completed"), UVM_LOW)

endfunction // build_phase

task c_async_fifo_write_mon::run_phase(uvm_phase phase);
  write_tr = c_async_fifo_write_trans::type_id::create("c_async_fifo_write_trans");  
  forever begin
    @(posedge write_vif.write_clk);
    write_tr.write_fifo_push = write_vif.write_fifo_push;
    write_tr.write_data      = write_vif.write_data;
    write_tr.write_fifo_full = write_vif.write_fifo_full;

    write_ap.write(write_tr);    
  end
endtask // run_phase

