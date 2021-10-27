// Author - Rejoy Roy Mathews
// This module implements a binary to graycode converter
// This module is completely combinational

// We can convert n-bit (bnb(n-1)...b2b1b0) Binary number into Gray code (gng(n-1)...g2g1g0).
// For least significant bit (LSB) g0=b0^b1, g1=b1^b2, g2=b1^b2 ,... g(n-1)=b(n-1)^bn, gn=bn.

module async_fifo_bintogcode
  #(
    parameter SIGNAL_WIDTH = 4
    )
  (
   input logic [SIGNAL_WIDTH-1:0]  binary,
   output logic [SIGNAL_WIDTH-1:0] greycode
   );

  assign greycode[SIGNAL_WIDTH-1] = binary[SIGNAL_WIDTH-1];

  genvar 			   i;
  
  generate
    for(i = 0; i < SIGNAL_WIDTH-1; i++) begin      
      assign greycode[i] = binary[i] ^ binary[i+1];
    end
  endgenerate

endmodule
