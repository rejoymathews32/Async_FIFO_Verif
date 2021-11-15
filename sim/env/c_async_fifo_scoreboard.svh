// Author - Rejoy Roy Mathews
// Scoreboard for the Asynchronous FIFO
// This module compares if the DUT FIFO entires matches the reference FIFO
// implemented in the scoreboard

class c_async_fifo_scoreboard extends uvm_scoreboard;

  // Macro to make multiple write methods available
  `uvm_analysis_imp_decl(_write_fifo)
  `uvm_analysis_imp_decl(_read_fifo)
  
  // Define a bounded queue as a reference for the FIFO
  logic [FIFO_DATA_WIDTH-1:0] reference_fifo [$:FIFO_DEPTH];
  
  uvm_analysis_imp_write_fifo #(c_async_fifo_write_trans, c_async_fifo_scoreboard) fifo_write_fifo_imp;
  uvm_analysis_imp_read_fifo #(c_async_fifo_read_trans, c_async_fifo_scoreboard) fifo_read_fifo_imp;

  extern function new(string name = "",uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void write_write_fifo(c_async_fifo_write_trans write_trans);
  extern function void write_read_fifo(c_async_fifo_read_trans read_trans);
  
  `uvm_component_utils(c_async_fifo_scoreboard)
  
endclass // c_async_fifo_scoreboard

function c_async_fifo_scoreboard::new(string name = "",uvm_component parent = null);
  super.new(name, parent);
endfunction

function void c_async_fifo_scoreboard::build_phase(uvm_phase phase);
  fifo_write_fifo_imp = new("uvm_analysis_imp_write_fifo", this);
  fifo_read_fifo_imp  = new("uvm_analysis_imp_read_fifo", this);
  `uvm_info(get_type_name(), $sformatf("build phase completed"), UVM_LOW)
endfunction // build_phase

function void c_async_fifo_scoreboard::write_write_fifo(c_async_fifo_write_trans write_trans);
  c_async_fifo_write_trans write_trans_store;

  if (write_trans.write_fifo_push) begin
    // Store an entry in the FIFO only if the FIFO is not full
    if(reference_fifo.size() != FIFO_DEPTH) begin
      // Have to clone because only a handle is passed in write
      $cast(write_trans_store, write_trans.clone());      
      reference_fifo.push_back(write_trans_store.write_data);      
    end
  end
  
endfunction // write_write_fifo

function void c_async_fifo_scoreboard::write_read_fifo(c_async_fifo_read_trans read_trans);
  // Assigning an intial value
  logic [FIFO_DATA_WIDTH-1:0] read_data_ref = '0;
  
  if (read_trans.read_fifo_pop) begin
    // Store an entry in the FIFO only if the FIFO is not full
    if(reference_fifo.size() != 0) begin
      // Have to clone because only a handle is passed in write
      read_data_ref = reference_fifo.pop_front();
      // Check if every popped entry is equal to the expected popped entry
      if (read_data_ref != read_trans.read_data) begin
	`uvm_error(get_type_name(), $sformatf("RTL Popped FIFO data does not match expected popped FIFO data expected 0x%x != actual 0x%x", read_data_ref, read_trans.read_data))
      end
      else begin
	`uvm_info(get_type_name(), $sformatf("RTL Popped FIFO matches expected popped FIFO data expected 0x%x == actual 0x%x", read_data_ref, read_trans.read_data), UVM_LOW)
      end
    end
  end
  
endfunction // write_read_fifo
