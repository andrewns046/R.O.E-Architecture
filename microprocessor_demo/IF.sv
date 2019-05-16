// Create Date:    17:44:49 2012.16.02
// Latest rev:     2017.10.26
// Design Name:    CSE141L
// Module Name:    IF (Instruction Fetch)

// generic program counter
module IF #(parameter PCW=16)(
  input              Abs_Jump,      // branch to "offset"
                     Rel_Jump,		// branch by "offset"
  input signed[PCW-1:0] Offset,
  input Reset,
  input Halt,
  input CLK,
  output logic[PCW-1:0] PC             // pointer to insr. mem
  );

  always @(posedge CLK)
	if(Reset)                       // reset to 0 and hold there
	  PC <= 'b0;
	else if(Halt)					// freeze
	  PC <= PC;
    else if(Abs_Jump)				// jump to definite address
	  PC <= Offset;
	else if(Rel_Jump)				// jump by specified amount
	  PC <= PC + Offset;
	else							// normal advance thru program
	  PC <= PC+'b1;

endmodule
