// Author - Rejoy Roy Mathews
// Environment class for the Asynchronous FIFO

// The enviroment class instantiates the FIFO read agent
// and the FIFO write agent along with the enviroment configuration object

// The evironment class accesses the read and write interfaces from the global space
// and passes it to the agents

// Defining a constructor, build phase, connect phase, reset phase, run phase, 

class c_async_fifo_env extends uvm_env;

  // Instantiate the FIFO read and write agent
  c_async_fifo_write_agt write_agt;
  c_async_fifo_read_agt read_agt;

  // Class method prototypes
  extern function new(string name = "async_fifo_env", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);

  // Virtual read and write interfaces
  virtual async_fifo_write_if write_vif;
  virtual async_fifo_read_if read_vif;

  // Register the env with the factory
  `uvm_component_utils(c_async_fifo_env)
  
endclass // c_async_fifo_env

// Constructor
function c_async_fifo_env::new(string name = "async_fifo_env", uvm_component parent = null);
  super.new(name,parent);  
endfunction

// Build Phase
function void c_async_fifo_env::build_phase(uvm_phase phase);

  // Construct the agents
  write_agt = c_async_fifo_write_agt::type_id::create("write_agt", this);
  read_agt  = c_async_fifo_read_agt::type_id::create("read_agt", this);
  
  // Get the virtual interfaces write interfaces and pass them down to the write agent
  if(!uvm_config_db#(virtual async_fifo_write_if)::get(this,"","write_vif", write_vif))
    `uvm_fatal(get_type_name(),"write_vif is not avaiable in env")
  
  uvm_config_db#(virtual async_fifo_write_if)::set(this,"write_agt","write_vif",write_vif);

  // Get the virtual interfaces read interfaces and pass them down to the agents
  if(!uvm_config_db#(virtual async_fifo_read_if)::get(this,"","read_vif", read_vif))
    `uvm_fatal(get_type_name(),"read_vif is not avaiable in env")

  uvm_config_db#(virtual async_fifo_read_if)::set(this,"read_agt","read_vif",read_vif);

endfunction // build_phase

