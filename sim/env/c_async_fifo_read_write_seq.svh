// Author - Rejoy Roy Mathews
// This module defines the write and read sequences
// i.e (sequences into the FIFO and sequences out of the FIFO)

// ------------------------------------------------------------------------------
// Write sequence ---------------------------------------------------------------
// ------------------------------------------------------------------------------
class c_async_fifo_write_seq extends uvm_sequence#(c_async_fifo_write_trans);
  
  extern function new(string name = "c_async_fifo_write_seq");
  extern task body();
  
  `uvm_object_utils(c_async_fifo_write_seq)
  
endclass // c_async_fifo_write_seq

function c_async_fifo_write_seq::new(string name = "c_async_fifo_write_seq");
  super.new(name);
endfunction // new

task c_async_fifo_write_seq::body();
  c_async_fifo_write_trans async_fifo_write_trans;
  // Create 100 randon write transactions and send to the FIFO
  repeat(100) begin    
    async_fifo_write_trans = c_async_fifo_write_trans::type_id::create("Async fifo write trans");
    start_item(async_fifo_write_trans);
    // Late randomization
    finish_item(async_fifo_write_trans);    
  end
endtask // body

// ------------------------------------------------------------------------------
// Read sequence ----------------------------------------------------------------
// ------------------------------------------------------------------------------

class c_async_fifo_read_seq extends uvm_sequence#(c_async_fifo_read_trans);
  
  extern function new(string name = "c_async_fifo_read_seq");
  extern task body();

  `uvm_object_utils(c_async_fifo_read_seq)
  
endclass // c_async_fifo_read_seq

function c_async_fifo_read_seq::new(string name = "c_async_fifo_read_seq");
  super.new(name);
endfunction // new

task c_async_fifo_read_seq::body();
  c_async_fifo_read_trans async_fifo_read_trans;
  // Create 100 randon read transactions and send to the FIFO
  repeat(100) begin    
    async_fifo_read_trans = c_async_fifo_read_trans::type_id::create("Async fifo read trans");
    start_item(async_fifo_read_trans);
    // Late randomization
    finish_item(async_fifo_read_trans);    
  end
endtask // body

