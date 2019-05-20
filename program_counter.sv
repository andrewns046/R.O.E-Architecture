// Create Date:    May 19, 2019
// Create by:      Andrew N. Sanchez
// Design Name:    R.O.E arch
// Module Name:    program counter

module program_counter #(parameter addr_w = 16)( input logic[addr_w-1:0] jump_here,
                               input bnz, reset, halt, clk,
                               output logic[addr_w-1:0] addr_out);

  always_ff @(posedge clk)
	if(reset)             // reset to 0 and hold there
	  addr_out <= 'b0;
	else if(halt)					// freeze
	  addr_out <= addr_out;
  else if(bnz)				// jump to definite address
	   addr_out <= jump_here;
	else							// normal advance thru program
	  addr_out <= addr_out + 'b1;

endmodule
