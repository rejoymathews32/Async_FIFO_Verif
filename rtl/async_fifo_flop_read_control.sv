// Author - Rejoy Roy Mathews
// This module implements the FIFO read controls
// The module generates the binary read address, the greycode read pointer
// as well as the control signal to indicate FIFO is empty

module async_fifo_flop_read_control
  #(
    parameter READ_COUNTER_BITS = 4
    )
  (
   input logic 				clk, // clock
   input logic 				reset_n, // reset
   input logic 				fifo_pop, // pop an entry into the FIFO
   // write clk domain gcrey code pointer - synchronized  in read clk domain
   input logic [READ_COUNTER_BITS-1:0] 	write_gcode_ptr_rd_sync,
   output logic [READ_COUNTER_BITS-2:0] read_memory_addr, // FIFO read memory address
   // read grey code pointer - to be synchronized in write clk domain in another module
   output logic [READ_COUNTER_BITS-1:0] read_gcode_ptr,
   output logic 			fifo_empty // fifo empty logic
   );

  logic 				 counter_en;

  assign counter_en = !fifo_empty;
  
  //----------------------------------------------------------------------------
  // Counter
  //----------------------------------------------------------------------------

  /* async_fifo_gcode_counter AUTO_TEMPLATE
   (
      .COUNTER_BITS			(READ_COUNTER_BITS),
      .\(.*\)                           (\1),
      .counter_incr			(fifo_pop),
      .gcode_ptr			(read_gcode_ptr),
      .memory_addr			(read_memory_addr),
   );
  */
  async_fifo_gcode_counter
    #(
      /*AUTOINSTPARAM*/
      // Parameters
      .COUNTER_BITS			(READ_COUNTER_BITS))	 // Templated
  u_gcode_counter
  (
   /*AUTOINST*/
   // Outputs
   .memory_addr				(read_memory_addr),	 // Templated
   .gcode_ptr				(read_gcode_ptr),	 // Templated
   // Inputs
   .counter_incr			(fifo_pop),		 // Templated
   .counter_en				(counter_en),		 // Templated
   .clk					(clk),			 // Templated
   .reset_n				(reset_n));		 // Templated

  //----------------------------------------------------------------------------
  // Logic for FIFO empty
  
  assign fifo_empty = (read_gcode_ptr == write_gcode_ptr_rd_sync);

  //----------------------------------------------------------------------------
		      
		      
endmodule
