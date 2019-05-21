// Create Date:     May 5, 2019
// Created by:      Andrew N. Sanchez
// Design Name:     R.O.E arch
// Module Name:     ALU (Arithmetic Logical Unit)


//This is the ALU module of the core, alu_code is defined in definitions.v file
// Includes new enum op_mnemonic to make instructions appear literally on waveform.
import definitions::*;
module alu ( input [7:0] read1,   // value from read1
             input [7:0] read0,   // value from read0
             input [3:0] alu_op,  // alu operation
             output logic branch_result, // branch result either 0 or 1
             output logic [7:0] result); // result of alu operation

always_comb	begin
  result = 'd0;            // default or NOP result
  branch_result = 'd0;
  case (alu_op)
    SLB: result = {read1[7:4], read0[3:0]};
    ADD: result = read1 + read0;
    SUB: result = read1 - read0;
    SHIFTL: result = read1 << read0;
    SHIFTR: result = read1 >> read0;
    BNZ: branch_result = (read1 != 0) ? 1'b1 : 1'b0;
    ALU_SLT: result = (read1 < read0) ? 'd1 : 'd0;
    ALU_XOR: result = read1 ^ read0;
    ALU_AND: result = read1 & read0;
    ALU_OR: result = read1 | read0;
  endcase
end
endmodule
