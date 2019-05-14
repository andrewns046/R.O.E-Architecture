//This file defines the parameters used for control and alu
package definitions;

typedef enum logic[2:0] {
  REG = 3'b000,	    // since these start at 0 and are in
  ARITH = 3'b001,		//  increment-by-1 sequence, we could
  SHIFT = 3'b010,		//  omit the 3'bxxx values, but we
  HARD = 3'b011,		//  include these for clarity
  SLT = 3'b100,
  XOR = 3'b101,
  AND = 3'b110,
  OR = 3'b111
	 } op_code;

typedef enum logic [1:0] {
  REDEF = 2'b00,
  LW = 2'b01,
  SW = 2'b10,
  BRANCH = 2'b11
} func_code;

typedef enum logic [3:0] {
  SLB = 4'b0000,
  ADD = 4'b0001,
  SUB = 4'b0010,
  SHIFTL = 4'b0011,
  SHIFTR = 4'b0100,
  BNZ = 4'b0101,  //branch not equal to zero
  SLT = 4'b0110, // set on less than
  ALU_XOR = 4'b0111,
  ALU_AND = 4'b1000,
  ALU_OR = 4'b1001
} alu_code;

endpackage // defintions
