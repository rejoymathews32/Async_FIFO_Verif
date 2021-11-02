// Author - Rejoy Roy Mathews
// Base test for Asynchronous FIFO

class async_fifo_base_test extends uvm_test;
  // Environment
  c_async_fifo_env env;
  // Sequences
  c_async_fifo_write_seq write_seq;
  c_async_fifo_read_seq read_seq;
  
  // Virtual interfaces
  asyn_fifo_write_if write_vif;
  asyn_fifo_read_if read_vif;

  // Function prototypes
  extern function new(string name = "async_fifo_base_test", uvm_component parent = null);
  extern function void build_phase(uvm_phase build);
  extern function void run_phase(uvm_phase build);

  // Factory registration
  `uvm_component_utils(async_fifo_base_test)
  
endclass; // async_fifo_base_test

function async_fifo_base_test::new(string name = "async_fifo_base_test", uvm_component parent = null);
  super.new(name, parent);  
endfunction

function void async_fifo_base_test::build_phase(uvm_phase build);
  
  // Create the environment
  env = c_async_fifo_env::type_id::create("env", this);

  // Get the virtual  write interfaces and pass them down to the env
  if(!config_db#(virtual asyn_fifo_write_if)::get(this,"","write_vif", write_vif))
    `uvm_fatal(get_type_name(),"write_vif is not avaiable in the base test")
  
  config_db#(virtual asyn_fifo_write_if)::set(this,"*","write_vif",write_vif);
  
  // Get the virtual  read interfaces and pass them down to the env
  if(!config_db#(virtual asyn_fifo_read_if)::get(this,"","read_vif", read_vif))
    `uvm_fatal(get_type_name(),"read_vif is not avaiable in the base test")

  config_db#(virtual asyn_fifo_read_if)::set(this,"*","read_vif",read_vif);

endfunction // build_phase

function void async_fifo_base_test::run_phase(uvm_phase build);
  
  write_seq = c_async_fifo_write_seq::type_id::create("Write sequence");
  read_seq = c_async_fifo_read_seq::type_id::create("Read sequence");

  phase.raise_objection(this, "Starting read and write sequences on the FIFO");  
  // Start read and write transactions on the FIFO in parallel
  fork
    write_seq.start(env.write_agt.write_sqr);
    read_seq.start(env.read_agt.read_sqr);    
  join
  phase.drop_objection(this, "Finished read and write sequences on the FIFO");
  
endfunction; // run_phase

