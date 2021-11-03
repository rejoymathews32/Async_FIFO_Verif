// Author - Rejoy Roy Mathews

// This class defines that write agent that includes a driver, sequencer and a monitor
// The TLM connect between the driver and the sequencer is also performed in this model

class c_async_fifo_write_agt extends uvm_agent;

  c_async_fifo_write_drv write_drv;
  c_async_fifo_write_mon write_mon;
  c_async_fifo_write_sqr write_sqr;
  
  virtual async_fifo_write_if write_vif;
  
  extern function new(string name = "async_fifo_write_agt", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

  `uvm_component_utils(c_async_fifo_write_agt)
  
endclass // c_async_fifo_write_agt

function c_async_fifo_write_agt::new(string name = "async_fifo_write_agt", uvm_component parent = null);
  super.new(name,parent);
endfunction // new

// Build Phase
function void c_async_fifo_write_agt::build_phase(uvm_phase phase);
  // Create the driver and the monitor in the build phase
  write_drv = c_async_fifo_write_drv::type_id::create("async_fifo_write_drv", this);
  write_mon = c_async_fifo_write_mon::type_id::create("async_fifo_write_mon", this);
  write_sqr = c_async_fifo_write_sqr::type_id::create("async_fifo_write_sqr", this);
  
  // Get the virtual interfaces write interfaces and pass them down to the write driver and monitor  
  if(!uvm_config_db#(virtual async_fifo_write_if)::get(this,"","write_vif",write_vif))
    `uvm_fatal(get_type_name(),"Write agent does not have access to write_vif")

  uvm_config_db#(virtual async_fifo_write_if)::set(this,"write_drv","write_vif",write_vif);
  uvm_config_db#(virtual async_fifo_write_if)::set(this,"write_mon","write_vif",write_vif);
  uvm_config_db#(virtual async_fifo_write_if)::set(this,"write_sqr","write_vif",write_vif);
  
endfunction // build_phase


// Connect Phase
function void c_async_fifo_write_agt::connect_phase(uvm_phase phase);
  // Connect the driver and the sequencer
  write_drv.seq_item_port.connect(write_sqr.seq_item_export);  
endfunction // connect_phase


