// Create Date:    May 19, 2019
// Create by:      Andrew N. Sanchez
// Design Name:    R.O.E arch
// Module Name:    program counter

module program_counter #(parameter addr_w = 16)(input init, clk, bnz,
                               input [addr_w-1:0] jump_here,
                               output logic [addr_w-1:0] addr_out = 0);

always @(posedge clk) begin
	if(!init) begin  //holds while init = 1
    if(bnz)				    // jump to definite address
	    addr_out <= jump_here;
	  else							// normal advance thru program
	    addr_out <= addr_out + 1;
  end
end
endmodule
