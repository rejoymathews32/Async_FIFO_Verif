// Author - Rejoy Roy Mathews
// Implementing a write sequencer

class c_async_fifo_write_sqr extends uvm_sequencer#(c_async_fifo_write_trans);

  extern function new(string name = "c_async_fifo_write_sqr", uvm_component parent = null);

  `uvm_component_utils(c_async_fifo_write_sqr)

endclass // c_async_fifo_write_sqr

function c_async_fifo_write_sqr::new(string name = "c_async_fifo_write_sqr", uvm_component parent = null);
  super.new(name,parent);  
endfunction
