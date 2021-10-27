// Author - Rejoy Roy Mathews
// This module implements the FIFO write controls
// The module generates the binary write address, the greycode write pointer
// as well as the control signal to indicate FIFO is full

module async_fifo_flop_write_control
  #(
    parameter WRITE_COUNTER_BITS = 4
    )
  (
   input logic 				 clk, // clock
   input logic 				 reset_n, // reset
   input logic 				 fifo_push, // push an entry into the FIFO
   // read clk domain gcrey code pointer - synchronized  in write clk domain
   input logic [WRITE_COUNTER_BITS-1:0]  read_gcode_ptr_wr_sync,
   output logic [WRITE_COUNTER_BITS-2:0] write_memory_addr, // FIFO write memory address
   // write grey code pointer - to be synchronized in read clk domain in another module
   output logic [WRITE_COUNTER_BITS-1:0] write_gcode_ptr,
   output logic 			 fifo_full // fifo full logic
   );

  logic 				 counter_en;

  assign counter_en = !fifo_full;

  //----------------------------------------------------------------------------
  // Counter
  //----------------------------------------------------------------------------

  /* async_fifo_gcode_counter AUTO_TEMPLATE
   (
      .COUNTER_BITS			(WRITE_COUNTER_BITS),
      .\(.*\)                           (\1),
      .counter_incr			(fifo_push),
      .gcode_ptr			(write_gcode_ptr),
      .memory_addr			(write_memory_addr),
   );
  */
  async_fifo_gcode_counter
    #(
      /*AUTOINSTPARAM*/
      // Parameters
      .COUNTER_BITS			(WRITE_COUNTER_BITS))	 // Templated
  u_gcode_counter
  (
   /*AUTOINST*/
   // Outputs
   .memory_addr				(write_memory_addr),	 // Templated
   .gcode_ptr				(write_gcode_ptr),	 // Templated
   // Inputs
   .counter_incr			(fifo_push),		 // Templated
   .counter_en				(counter_en),		 // Templated
   .clk					(clk),			 // Templated
   .reset_n				(reset_n));		 // Templated

  //----------------------------------------------------------------------------
  // Logic for FIFO full
  // Explanation Example- For greycode values from 0-15, the values from 0-7 are
  // mirror images of values from 8-15 except for the MSB.
  // On account the negation of the first 2 bits are compared
  assign fifo_full = (write_gcode_ptr ==
		      {~read_gcode_ptr_wr_sync[WRITE_COUNTER_BITS-1-:2],
		       read_gcode_ptr_wr_sync[WRITE_COUNTER_BITS-1-2:0]});
  
  //----------------------------------------------------------------------------
  
endmodule
