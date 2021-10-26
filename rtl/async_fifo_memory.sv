// Author - Rejoy Roy Mathews
// This module models memory. The memory has 2 ports
// A read port and a write port.
// The data is written to memory via the write port on the rising edge of a clock if write is enabled
// The data can be read from memory via the read port. The read port is always active

module async_fifo_memory
  #(
    parameter MEMORY_WIDTH = 3,
    parameter MEMORY_DEPTH = 8
    )
  (
   // Memory write port control and data signals
   input logic 				  w_clk, // write clock
   input logic 				  w_en, // enable memory
   input logic [MEMORY_WIDTH-1:0] 	  w_data, // write data
   input logic [$clog2(MEMORY_DEPTH)-1:0] w_addr, // write address
   // Memory read port control and data signals
   input logic [$clog2(MEMORY_DEPTH)-1:0] r_addr, // read address
   output logic [MEMORY_WIDTH-1:0] 	  r_data // read data
   );

  // Defining the memory
  logic [MEMORY_WIDTH-1:0] 		  memory [0:MEMORY_DEPTH-1];

  // Reset is not present to minimize area
  // Writing to the memory
  always @(posedge w_clk) begin
    if (w_en) begin
      memory[w_addr] <= w_data;      
    end    
  end

  // Reading from the memory
  // Should read 'X' is memory location is not previously written to
  assign r_data = memory[r_addr];

endmodule
