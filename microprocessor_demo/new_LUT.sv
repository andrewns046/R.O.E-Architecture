// CSE141L   Win2019
// application shown: Program Counter; 
//   you could use it elsewhere, as well
// problem -- need different PC branch/jump target values for each program
// solution 1 (shown here): single LUT with prog_state and PC target pointer 
//   concatenated as the independent variable for the case statement
// solution 2 (not shown): three separate LUTs with a 3:1 mux controlled
//   by prog_state
module new_LUT(
  input       [2:0] addr,                // PC target (or other) LUT pointer
  input       [1:0] prog_state,			 // program tracker from last week's lecture
  output logic[9:0] PC_target);			 // to instruction fetch / PC generator
// prog_state increments on each init pulse from the test bench
// The concatenation {} enables the designer to reuse the same 3-bit LUT pointer
//   with different values for each of the three programs
  always_comb case({prog_state,addr})
// for program 1
    5'b00_000: PC_target = ;			 // fill in the PC_target values as needed
	5'b00_001: PC_target = ;
...
    5'b00_111: PC_target = ;
// for program 2
    5'b01_000: PC_target = ; 
	5'b01_001: PC_target = ;
...
    5'b01_111: PC_target = ;
// for program 3
    5'b10_000: PC_target = ;
	5'b10_001: PC_target = ;
...
    5'b10_111: PC_target = ;
  endcase

endmodule