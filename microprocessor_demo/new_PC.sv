// CSE141L    very simple PC	  Winter 2019
// Eliminates the need for a 3-state machine to tell us 
//   which program we are on
// Important: assumes that three programs are concenated
//   in the instr_ROM, i.e., the last line of Program 1 
//   issues a done flag, then the next line of machine 
//   code is the first line of Program 2 
// Note that we need to initialize PC to 0
// init no longer resets PC, but does stall it to allow
//   the test bench to load operands and read results
//   in data_memory 
module new_PC(
  input              init,			// from test bench
                     clk,
                     jump_rel,		// relative jump/branch
		             jump_abs,		// absolute jump/branch
  input       [15:0] target,		// jump/branch "where to?"
  output logic[15:0] PC = 0);		// to instruction memory

always @(posedge clk) begin
  if(!init) begin					// PC holds while init = 1
    if(jump_rel)
	  PC <= PC + target;
	else if(jump_abs)
	  PC <= target;
	else
      PC <= PC + 1;
  end
end 

endmodule


