// Author - Rejoy Roy Mathews
// This module models a flop synchronizer with the option to have
// 2 or 3 flops in the synchronizer. Assertions are defined in place
// to check the number of flop synchronizers defined via parameter FLOP_CNT

module async_fifo_flop_sync
  #(
    parameter FLOP_CNT = 2,
  )
  (
   input logic 	d, // Input
   input logic 	clk, // Clock
   input logic 	reset_n, // Reset
   output logic q //Output
   );

  logic [FLOP_CNT-1:0]	intermediate_d;

  genvar 		i;
  
  generate
    
    for (i = 0; i < FLOP_CNT; i++) begin
      // First flop of the synchronizer
      if(i == 0) begin
	always @(posedge clk, negedge reset_n) begin
	  if(!reset_n) begin
	    intermediate_d[0] <= 1'b0;	    
	  end
	  else begin
	    intermediate_d[0] <= d;	    
	  end
	end	
      end
      // Last flop of the synchronizer
      else if (i = (FLOP_CNT-1)) begin
	always @(posedge clk, negedge reset_n) begin
	  if(!reset_n) begin
	    q <= 1'b0;
	  end
	  else begin
	    q <= intermediate_d[FLOP_CNT-2];	    
	  end
	end	
      end
      // Intermediate flops in the synchronizer
      // i.e Neither first or last flop
      else begin
	always @(posedge clk, negedge reset_n) begin
	  if(!reset_n) begin
	    intermediate_d[i] <= 1'b0;
	  end
	  else begin
	    intermediate_d[i] <= intermediate_d[i-1];	    
	  end
	end	
      end
      
    end
    
  endgenerate
  

  //--------------------------------------------------------------------
  // Assertions

`ifdef ASSERT_ON
  // Assert that FLOP_CNT cannot be less than 2 or greater than 3
  assert(FLOP_CNT == 2 || FLOP_CNT ==3);
  else $error("Flop synchronizer should be configured for either 2 or 3 flops");
`endif  

endmodule
