//This file defines the parameters used in the alu
package definitions;
    
typedef enum logic[2:0] {
  SLL = 3'b000,	    // since these start at 0 and are in
  SRL = 3'b001,		//  increment-by-1 sequence, we could
  ADD = 3'b010,		//  omit the 3'bxxx values, but we 
  SUB = 3'b011,		//  include these for clarity
  LSW = 3'b100,
  CLR = 3'b101,
  EMK = 3'b110,
  INC = 3'b111
	 } op_code;
	 
endpackage // defintions
