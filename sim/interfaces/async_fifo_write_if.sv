// Author - Rejoy Roy Mathews
// Defining an interface for the FIFO write channel

interface asyn_fifo_write_if 
  #(parameter FIFO_DATA_WIDTH = 32)(
				    input logic write_clk,
				    input logic write_reset_n);
  
  logic 					write_fifo_push;
  logic [FIFO_DATA_WIDTH-1:0] 			write_data;
  logic 					write_fifo_full;
  
  modport driver
    (
     output write_fifo_push,
     output write_data,
     input  write_fifo_full
     );

  modport monitor
    (
     input write_fifo_push,
     input write_data,
     input write_fifo_full
     );
  
endinterface
