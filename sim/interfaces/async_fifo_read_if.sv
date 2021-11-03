// Author - Rejoy Roy Mathews
// Defining an interface for the FIFO read channel

interface async_fifo_read_if 
  #(parameter FIFO_DATA_WIDTH = 32)(
				    input logic read_clk,
				    input logic read_reset_n);
  
  logic 					read_fifo_pop;
  logic [FIFO_DATA_WIDTH-1:0] 			read_data;
  logic 					read_fifo_empty;
  
  modport driver
    (
     output read_fifo_pop,
     output read_data,
     input  read_fifo_empty
     );

  modport monitor
    (
     input read_fifo_pop,
     input read_data,
     input read_fifo_empty
     );
  
endinterface
