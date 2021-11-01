package async_fifo_env_pkg;

// Parameters  
`include "async_fifo_params.svh"

//---------------------------------  
// Transactions
`include "c_async_fifo_read_write_trans.svh"
`include "c_async_fifo_read_write_seq.svh"

//---------------------------------  
// Components
  
// Write channel  
`include "c_async_fifo_write_sqr.svh"
`include "c_async_fifo_write_mon.svh"
`include "c_async_fifo_write_drv.svh"
`include "c_async_fifo_write_agt.svh"

// Read channel  
`include "c_async_fifo_read_sqr.svh"
`include "c_async_fifo_read_mon.svh"
`include "c_async_fifo_read_drv.svh"
`include "c_async_fifo_read_agt.svh"

// Environment  
`include "c_async_fifo_env.svh"

endpackage // async_fifo_env_pkg
