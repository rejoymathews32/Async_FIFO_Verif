// Author - Rejoy Roy Mathews
// This module defines the write and read transactions
// i.e (transactions into the FIFO and transactions out of the FIFO)

// ------------------------------------------------------------------------------
// Write sequence ---------------------------------------------------------------
// ------------------------------------------------------------------------------
class c_async_fifo_write_trans extends uvm_sequence;
  // Signals to be assigned to in the write sequence
  rand logic 		       write_fifo_push;
  rand logic [FIFO_DATA_WIDTH-1:0]  write_data;
  
  // Signals to be assigned to in the DUT. Will be sent to the scoreboard
  logic write_fifo_full;
  
  extern function new(string name = "c_async_fifo_write_trans");
  extern function string print_transaction();

  `uvm_object_utils(c_async_fifo_write_trans);
  
endclass // c_async_fifo_write_trans

function c_async_fifo_write_trans::new(string name = "c_async_fifo_write_trans");
  super.new(name);
endfunction // new

function string c_async_fifo_read_trans::print_transaction();
  $strobe("Read transaction data - 0x%x push asserted - 0x%x", read_data, read_fifo_push);  
endfunction // print_transaction

// ------------------------------------------------------------------------------
// Read sequence ----------------------------------------------------------------
// ------------------------------------------------------------------------------

class c_async_fifo_read_trans extends uvm_sequence;
  // Signals to be assigned to in the read sequence  
  rand logic 		       read_fifo_pop;  
  rand logic [FIFO_DATA_WIDTH-1:0]  read_data;

  // Signals to be assigned to in the DUT. Will be sent to the scoreboard
  logic read_fifo_empty;
  
  extern function new(string name = "c_async_fifo_read_trans");
  extern function string print_transaction();

  `uvm_object_utils(c_async_fifo_read_trans);
  
endclass // c_async_fifo_read_trans

function c_async_fifo_read_trans::new(string name = "c_async_fifo_read_trans");
  super.new(name);
endfunction // new

function string c_async_fifo_read_trans::print_transaction();
  $strobe("Read transaction data - 0x%x pop asserted - 0x%x", read_data, read_fifo_pop);  
endfunction // print_transaction
