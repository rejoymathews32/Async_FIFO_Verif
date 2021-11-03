// Author - Rejoy Roy Mathews

// This class defines that read agent that includes a driver, sequencer and a monitor
// The TLM connect between the driver and the sequencer is also performed in this model

class c_async_fifo_read_agt extends uvm_agent;

  c_async_fifo_read_drv read_drv;
  c_async_fifo_read_mon read_mon;
  c_async_fifo_read_sqr read_sqr;
  
  virtual async_fifo_read_if read_vif;
  
  extern function new(string name = "async_fifo_read_agt", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

  `uvm_component_utils(c_async_fifo_read_agt)
  
endclass // c_async_fifo_read_agt

function c_async_fifo_read_agt::new(string name = "async_fifo_read_agt", uvm_component parent = null);
  super.new(name,parent);
endfunction // new

// Build Phase
function void c_async_fifo_read_agt::build_phase(uvm_phase phase);
  // Create the driver and the monitor in the build phase
  read_drv = c_async_fifo_read_drv::type_id::create("async_fifo_read_drv", this);
  read_mon = c_async_fifo_read_mon::type_id::create("async_fifo_read_mon", this);
  read_sqr = c_async_fifo_read_sqr::type_id::create("async_fifo_read_sqr", this);
  
  // Get the virtual interfaces read interfaces and pass them down to the read driver and monitor  
  if(!uvm_config_db#(virtual async_fifo_read_if)::get(this,"","read_vif",read_vif))
    `uvm_fatal(get_type_name(),"Read agent does not have access to read_vif")

  uvm_config_db#(virtual async_fifo_read_if)::set(this,"read_drv","read_vif",read_vif);
  uvm_config_db#(virtual async_fifo_read_if)::set(this,"read_mon","read_vif",read_vif);
  uvm_config_db#(virtual async_fifo_read_if)::set(this,"read_sqr","read_vif",read_vif);

  `uvm_info(get_type_name(), $sformatf("build phase completed"), UVM_LOW)
  
endfunction // build_phase


// Connect Phase
function void c_async_fifo_read_agt::connect_phase(uvm_phase phase);
  // Connect the driver and the sequencer
  read_drv.seq_item_port.connect(read_sqr.seq_item_export);  
  `uvm_info(get_type_name(), $sformatf("connect phase completed"), UVM_LOW)

endfunction // connect_phase



