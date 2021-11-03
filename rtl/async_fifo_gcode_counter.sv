// Author - Rejoy Roy Mathews
// This module implements a Binary counter and instantiates
// a binary to greycode converter to allow grey code pointers
// to be propagated to other clock domains to
// allow synchronization


module async_fifo_gcode_counter
  #(
    parameter COUNTER_BITS = 4
    )
  (
   input logic 			   counter_incr, // control signal to increament the counter
   input logic 			   counter_en, // control signal to enable the counter
   input logic 			   clk, // clock
   input logic 			   reset_n, // reset
   output logic [COUNTER_BITS-2:0] memory_addr, // memory access address
   output logic [COUNTER_BITS-1:0] gcode_ptr // grey code pointer
   );

  // Counter register
  logic [COUNTER_BITS-1:0] 	   counter_binary;
  logic [COUNTER_BITS-1:0] 	   counter_binary_next;
  logic [COUNTER_BITS-1:0] 	   counter_greycode;
  logic [COUNTER_BITS-1:0] 	   counter_greycode_next;
  
  // Exclude the MSB for memory_addr.
  // The MSB is used for full/empty check in the other clk domain
  assign memory_addr = counter_binary[COUNTER_BITS-2:0];
  assign gcode_ptr = counter_greycode;

  //----------------------------------------------------------------------------
  // Combinational components  
  //----------------------------------------------------------------------------
  
  always_comb begin
    counter_binary_next = counter_binary;
    // Increament if counter is enabled and increament is requestedd
    if(counter_incr && counter_en) begin
      // Rollover intentional
      counter_binary_next = counter_binary + 1'b1;
    end
  end


  // Instantiate a binary to greycode converter
 /* async_fifo_bintogcode AUTO_TEMPLATE
  (
    .SIGNAL_WIDTH			(COUNTER_BITS),
    .\(.*\)                             (counter_\1_next),
  ); */
 async_fifo_bintogcode
  #(
    /*AUTOINSTPARAM*/
    // Parameters
    .SIGNAL_WIDTH			(COUNTER_BITS))		 // Templated
  u_bintogcode
  (
    /*AUTOINST*/
   // Outputs
   .greycode				(counter_greycode_next), // Templated
   // Inputs
   .binary				(counter_binary_next));	 // Templated


  //----------------------------------------------------------------------------
  // Sequential components
  //----------------------------------------------------------------------------  

  always @(posedge clk, negedge reset_n) begin
    if(!reset_n) begin
      counter_binary <= '0;
    end
    else begin
      counter_binary <= counter_binary_next;
    end
  end

  always @(posedge clk, negedge reset_n) begin
    if(!reset_n) begin
      counter_greycode <= '0;
    end
    else begin
      // Roll-over intentional
      counter_greycode <= counter_greycode_next;
    end
  end


  //----------------------------------------------------------------------------  
  // Assertions
  //----------------------------------------------------------------------------  

  // Assert that on every cycle the greycode flopped value is infact the greycode value for the
  // flopped binary value
`ifdef ASSERT_ON

  logic [COUNTER_BITS-1:0] 	   counter_greycode_model;
  
  async_fifo_bintogcode
  #(
    /*AUTOINSTPARAM*/
    // Parameters
    .SIGNAL_WIDTH			(COUNTER_BITS))		 // Templated
  u_bintogcode_assert
  (
    /*AUTOINST*/
   // Outputs
   .greycode				(counter_greycode_model), // Templated
   // Inputs
   .binary				(counter_binary));	 // Templated


  property p_counter_valid;
    @(posedge clk)
      disable iff (!reset_n)
	counter_greycode_model == counter_greycode;
  endproperty
  
  assert property (p_counter_valid);  
  
`endif  
endmodule
