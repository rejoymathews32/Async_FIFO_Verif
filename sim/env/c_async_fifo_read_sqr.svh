// Author - Rejoy Roy Mathews
// Implementing a read sequencer

class c_async_fifo_read_sqr extends uvm_sequencer#(c_async_fifo_write_trans);

  extern function new(string name = "c_async_fifo_read_sqr", uvm_component parent = null);

  `uvm_component_utils(c_async_fifo_read_sqr)

endclass // c_async_fifo_read_sqr

function c_async_fifo_read_sqr::new(string name = "c_async_fifo_read_sqr", uvm_component parent = null);
  super.new(name,parent);  
endfunction
