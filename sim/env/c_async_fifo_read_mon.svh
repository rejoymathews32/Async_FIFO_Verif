// Author - Rejoy Roy Mathews
// This module defines a FIFO read monitor

class c_async_fifo_read_mon extends uvm_monitor;

  virtual asyn_fifo_read_if read_vif;
  uvm_analysis_port #(c_async_fifo_read_trans) read_ap;
  c_async_fifo_read_trans read_tr;
  
  extern function new (string name = "c_async_fifo_read_mon", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);  
  extern task void run_phase(uvm_phase phase);

  `uvm_component_utils(c_async_fifo_read_mon)
  
endclass // c_async_fifo_read_mon

function c_async_fifo_read_mon::new(string name = "c_async_fifo_read_mon", uvm_component parent = null);
  super.new(name,parent);  
endfunction // new

function void c_async_fifo_read_mon::build_phase(uvm_phase phase);  
  if(!config_db#(virtual asyn_fifo_read_if)::get(this,"","read_vif",read_vif))
    `uvm_fatal(get_type_name(), "Read montior does not have access to read_vif")
endfunction // build_phase

task void c_async_fifo_read_mon::run_phase(uvm_phase phase);
  read_tr = c_async_fifo_read_trans::type_id::create("c_async_fifo_read_trans");  
  forever begin
    @(posedge read_vif.read_clk);
    read_tr.read_fifo_pop	= read_vif.read_fifo_pop;
    read_tr.read_data		= read_vif.read_data;
    read_tr.read_fifo_empty	= read_vif.read_fifo_empty;
  end
endtask // run_phase

