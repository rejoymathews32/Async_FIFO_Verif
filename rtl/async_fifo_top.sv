// Author - Rejoy Roy Mathews
// Top level stitching module for the Asynchronous FIFO
// write_reset_n and read_reset_n are asynchronous and
// are to be applied simultaneously

module async_fifo_top
  #(
    parameter FIFO_DATA_WIDTH = 32,
    parameter FIFO_DEPTH = 8,
    parameter SYNCHRONIZER_FLOPS = 2
    )
  (
   // Write channel
   input logic 			      write_clk,
   input logic 			      write_reset_n,
   input logic 			      write_fifo_push,
   input logic [FIFO_DATA_WIDTH-1:0]  write_data,
   output logic 		      write_fifo_full,
   // Read channel
   input logic 			      read_clk,
   input logic 			      read_reset_n,
   input logic 			      read_fifo_pop,
   output logic [FIFO_DATA_WIDTH-1:0] read_data,
   output logic 		      read_fifo_empty
   );

  // Example - an 8 deep FIFO will have 3 bits + 1 bit for full empty compute
  localparam COUNTER_BITS = $clog2(FIFO_DEPTH) + 1;

  /*AUTOLOGIC*/
  logic 			      write_en;
  logic [COUNTER_BITS-1:0] 	      read_gcode_ptr;
  logic [COUNTER_BITS-1:0] 	      read_gcode_ptr_wr_sync;
  logic [$clog2(FIFO_DEPTH)-1:0]      read_memory_addr;
  logic [COUNTER_BITS-1:0] 	      write_gcode_ptr;
  logic [COUNTER_BITS-1:0] 	      write_gcode_ptr_rd_sync;
  logic [$clog2(FIFO_DEPTH)-1:0]      write_memory_addr;

  genvar 			      i;


  assign write_en = write_fifo_push && !write_fifo_full;

  //----------------------------------------------------------------------------
  // Read controller
  //----------------------------------------------------------------------------
  /* async_fifo_flop_read_control AUTO_TEMPLATE
   (
   .READ_COUNTER_BITS                (COUNTER_BITS),
   .\(.*\)                           (\1),
   .clk                              (read_clk),
   .fifo_empty		        (read_fifo_empty),
   .fifo_pop 		        (read_fifo_pop),
   .reset_n                          (read_reset_n),

   );
   */ 
  async_fifo_flop_read_control
    #(
      /*AUTOINSTPARAM*/
      // Parameters
      .READ_COUNTER_BITS		(COUNTER_BITS))		 // Templated
  u_async_fifo_flop_read_control
    (
     /*AUTOINST*/
     // Outputs
     .read_memory_addr			(read_memory_addr),	 // Templated
     .read_gcode_ptr			(read_gcode_ptr),	 // Templated
     .fifo_empty			(read_fifo_empty),	 // Templated
     // Inputs
     .clk				(read_clk),		 // Templated
     .reset_n				(read_reset_n),		 // Templated
     .fifo_pop				(read_fifo_pop),	 // Templated
     .write_gcode_ptr_rd_sync		(write_gcode_ptr_rd_sync)); // Templated

  //----------------------------------------------------------------------------
  // Write controller
  //----------------------------------------------------------------------------
  /* async_fifo_flop_write_control AUTO_TEMPLATE
   (
   .WRITE_COUNTER_BITS               (COUNTER_BITS),
   .\(.*\)                           (\1),
   .clk                              (write_clk),
   .fifo_push 		        (write_fifo_push),
   .fifo_full		        (write_fifo_full),
   .reset_n                          (write_reset_n),

   );
   */
  async_fifo_flop_write_control
    #(
      /*AUTOINSTPARAM*/
      // Parameters
      .WRITE_COUNTER_BITS		(COUNTER_BITS))		 // Templated
  u_async_fifo_flop_write_control
    (
     /*AUTOINST*/
     // Outputs
     .write_memory_addr			(write_memory_addr),	 // Templated
     .write_gcode_ptr			(write_gcode_ptr),	 // Templated
     .fifo_full				(write_fifo_full),	 // Templated
     // Inputs
     .clk				(write_clk),		 // Templated
     .reset_n				(write_reset_n),	 // Templated
     .fifo_push				(write_fifo_push),	 // Templated
     .read_gcode_ptr_wr_sync		(read_gcode_ptr_wr_sync)); // Templated


  //----------------------------------------------------------------------------
  // FIFO memory
  //----------------------------------------------------------------------------

  /* async_fifo_memory AUTO_TEMPLATE
   (
   .MEMORY_WIDTH                     (FIFO_DATA_WIDTH),
   .MEMORY_DEPTH                     (FIFO_DEPTH),
   .\(.*\)                           (\1),
   .clk                              (write_clk),
   .reset_n                          (write_reset_n),
   .write_addr                       (write_memory_addr),
   .read_addr                        (read_memory_addr),
   );
   */
  async_fifo_memory
    #(
      /*AUTOINSTPARAM*/
      // Parameters
      .MEMORY_WIDTH			(FIFO_DATA_WIDTH),	 // Templated
      .MEMORY_DEPTH			(FIFO_DEPTH))		 // Templated
  u_async_fifo_memory
    (
     /*AUTOINST*/
     // Outputs
     .read_data				(read_data),		 // Templated
     // Inputs
     .write_clk				(write_clk),		 // Templated
     .write_en				(write_en),		 // Templated
     .write_data			(write_data),		 // Templated
     .write_addr			(write_memory_addr),	 // Templated
     .read_addr				(read_memory_addr));	 // Templated

  generate

    for(i = 0; i < COUNTER_BITS; i++) begin

      //----------------------------------------------------------------------------
      // Read pointer sync in write clk domain
      //----------------------------------------------------------------------------
      /* async_fifo_flop_sync AUTO_TEMPLATE
       (
       .FLOP_CNT			     (SYNCHRONIZER_FLOPS),
       .\(.*\)                           (\1),
       .q                                (read_gcode_ptr_wr_sync[i]),
       .d                                (read_gcode_ptr[i]),
       .clk                              (write_clk),
       .reset_n                          (write_reset_n),
       );
       */
      async_fifo_flop_sync
	    #(
	      /*AUTOINSTPARAM*/
	      // Parameters
	      .FLOP_CNT			(SYNCHRONIZER_FLOPS))	 // Templated
      u_async_fifo_flop_wr_domain_sync
	    (
	     /*AUTOINST*/
	     // Outputs
	     .q				(read_gcode_ptr_wr_sync[i]), // Templated
	     // Inputs
	     .d				(read_gcode_ptr[i]),	 // Templated
	     .clk			(write_clk),		 // Templated
	     .reset_n			(write_reset_n));	 // Templated

      //----------------------------------------------------------------------------
      // Write pointer sync in read clk domain
      //----------------------------------------------------------------------------
      /* async_fifo_flop_sync AUTO_TEMPLATE
       (
       .FLOP_CNT			     (SYNCHRONIZER_FLOPS),
       .\(.*\)                           (\1),
       .q                                (write_gcode_ptr_rd_sync[i]),
       .d                                (write_gcode_ptr[i]),
       .clk                              (read_clk),
       .reset_n                          (read_reset_n),
       );
       */
      async_fifo_flop_sync
	#(
	  /*AUTOINSTPARAM*/
	  // Parameters
	  .FLOP_CNT			(SYNCHRONIZER_FLOPS))	 // Templated
      u_async_fifo_flop_rd_domain_sync
	(
	 /*AUTOINST*/
	 // Outputs
	 .q				(write_gcode_ptr_rd_sync[i]), // Templated
	 // Inputs
	 .d				(write_gcode_ptr[i]),	 // Templated
	 .clk				(read_clk),		 // Templated
	 .reset_n			(read_reset_n));		 // Templated

    end

  endgenerate

  //----------------------------------------------------------------------------
  // Assertions
  //----------------------------------------------------------------------------
`ifdef ASSERT_ON

  // Check that FIFO does not overflow
  // If FIFO is full, then on the next cycle, the write pointer should remain the same
  property p_overflow;
  @(posedge write_clk)
    disable iff (!write_reset_n)
      write_fifo_full |=> (write_gcode_ptr == $past(write_gcode_ptr));
endproperty

  assert property(p_overflow);

  // Check that FIFO does not underflow
  // If FIFO is empty, then on the next cycle, the read pointer should remain the same
  property p_underflow;
    @(posedge read_clk)
      disable iff (!read_reset_n)
	read_fifo_empty |=> (read_gcode_ptr == $past(read_gcode_ptr));
  endproperty

  assert property(p_underflow);

`endif

endmodule
