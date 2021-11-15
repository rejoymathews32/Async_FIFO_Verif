// Author - Rejoy Roy Mathews
// Testbench for an asynchronous FIFO

import uvm_pkg::*;

import async_fifo_env_pkg::*;

module tb();

  /*AUTOLOGIC*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  logic [FIFO_DATA_WIDTH-1:0] read_data;
  logic 		      read_fifo_empty;
  logic 		      write_fifo_full;
  // End of automatics
  logic 		      write_clk;
  logic 		      write_reset_n;

  logic 		      read_clk;
  logic 		      read_reset_n;
  
  //----------------------------------------------------------------------------
  // Design Under Test
  //----------------------------------------------------------------------------
  
  async_fifo_top
    #(
      /*AUTOINSTPARAM*/
      // Parameters
      .FIFO_DATA_WIDTH			(FIFO_DATA_WIDTH),
      .FIFO_DEPTH			(FIFO_DEPTH),
      .SYNCHRONIZER_FLOPS		(SYNCHRONIZER_FLOPS))
  dut
    (
     /*AUTOINST*/
     // Outputs
     .write_fifo_full			(write_if.write_fifo_full),
     .read_data				(read_if.read_data[FIFO_DATA_WIDTH-1:0]),
     .read_fifo_empty			(read_if.read_fifo_empty),
     // Inputs
     .write_clk				(write_clk),
     .write_reset_n			(write_reset_n),
     .write_fifo_push			(write_if.write_fifo_push),
     .write_data			(write_if.write_data[FIFO_DATA_WIDTH-1:0]),
     .read_clk				(read_clk),
     .read_reset_n			(read_reset_n),
     .read_fifo_pop			(read_if.read_fifo_pop));

  //----------------------------------------------------------------------------
  // Clock and reset
  //----------------------------------------------------------------------------
  // RRM - Fixme : Can we create interfaces for a clock?
  // Then pass these to config DB and have different clock frequencies
  // Depending on the testcase
  // Current scenario -> write clock is twice as fast as the read clock

  // Clock initial assignment
  initial begin
    write_clk 	  = 1'b0;
    read_clk 	  = 1'b0;    
  end

  always begin
    #5 write_clk  = ~write_clk;    
  end

  always begin
    #10 read_clk  = ~read_clk;    
  end  

  // Reset
  initial begin
    // Reset the FIFO
    write_reset_n <= 1'b0;
    #100;
    // The FIFO comes out of reset
    write_reset_n <= 1'b1;    
  end

  // Both read and write resets must be asserted at the same time
  assign read_reset_n = write_reset_n;

  //----------------------------------------------------------------------------
  // Interfaces
  //----------------------------------------------------------------------------

  // Write Interface
  async_fifo_write_if#(.FIFO_DATA_WIDTH(FIFO_DATA_WIDTH))
  write_if
    (
     .write_clk(write_clk),
     .write_reset_n(write_reset_n)
     );

  // Read interface
  async_fifo_read_if #(.FIFO_DATA_WIDTH(FIFO_DATA_WIDTH))
  read_if
    (
     .read_clk(read_clk),
     .read_reset_n(read_reset_n)    
     );

  //----------------------------------------------------------------------------
  // UVM Configuration
  //----------------------------------------------------------------------------

  initial begin
    // Set format - null ,scope, config_db_name, interface instance
    // Config DB can be thought of as a global space that maintains an associative array
    uvm_config_db#(virtual async_fifo_write_if)::set(null,"uvm_test_top","write_vif",write_if);

    uvm_config_db#(virtual async_fifo_read_if)::set(null,"uvm_test_top","read_vif",read_if);

    //Call the test - but passing run_test argument as test class name
    run_test("async_fifo_base_test");
  end
endmodule
