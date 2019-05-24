// Create Date:        May 13, 2019
// Created by:         Andrew N. Sanchez
// Design Name:        R.O.E arch
// Module Name:        Control

import definitions::*;
module control (input [8:0] instr,
                output logic [2:0] set_read0,
                output logic [2:0] set_read1,
                output logic [2:0] set_write,
                output logic reg_imm,
                output logic reg_write_src,
                output logic mem_write,
                output logic mem_read,
                output logic [3:0] alu_op,
                output logic [1:0] alu_src,
                output logic reg_write,
                output logic reg_read_write,
                output logic reg_write_read);
op_code op;
func_code fun2;
logic fun1;
assign op = op_code'(instr[8:6]);
assign fun2 = func_code'(instr[5:4]);
assign fun1 = instr[5];

always_comb begin
  //default behavior
  set_read0 = 'd0;
  set_read1 = 'd0;
  set_write = 'd0;
  reg_imm = 'd0;
  reg_write_src = 'd0;
  mem_write = 'd0;
  mem_read = 'd0;
  alu_op = 'd0;
  alu_src = 'd0;
  reg_write = 'd0;
  reg_read_write = 'd0;
  reg_write_read = 'd0;
  case(op)
    REG: begin
      reg_write = 1'b1;
      alu_src = 2'b01;
      alu_op = SLB;
    end
    ARITH: begin
      reg_imm = 1'b1;
      reg_read_write = 1'b1;
      reg_write_read = 1'b1;
      reg_write = 1'b1;

      if( fun1 == 1'b0 ) begin //add
        alu_op = ADD;
      end else begin //subtract
        alu_op = SUB;
      end
    end
    SHIFT: begin
      reg_imm = 1'b1;
      reg_read_write = 1'b1;
      reg_write_read = 1'b1;
      reg_write = 1'b1;
      if( fun1 == 1'b0 ) begin // shift left
        alu_op = SHIFTL;
      end else begin // shift right
        alu_op = SHIFTR;
      end
    end
    HARD: begin
      case(fun2)
        REDEF: begin
          case(instr[3:2])
            2'b00: set_read0 = {1'b1,instr[1:0]}; // change read 0 pa
            2'b01: set_read1 = {1'b1,instr[1:0]}; // change read 1 pa
            2'b10: set_write = {1'b1,instr[1:0]}; // change write pa
            2'b11: reg_write = 'd0;
          endcase
        end
        LW: begin
          reg_read_write = 1'b1;
          reg_write = 1'b1;
          mem_read = 1'b1;
          reg_write_src = 1'b1;
        end
        SW: begin
          reg_write_read = 1'b1;
          mem_write = 1'b1;
        end
        BRANCH:begin
          reg_write_read = 1'b1;
          alu_op = BNZ; // tell alu to test for branch
          alu_src = 2'b10; // 3
        end
      endcase
    end
    SLT: begin
      reg_write_read = 1'b1;
      reg_write = 1'b1;
      alu_src = 2'b10;
      alu_op = ALU_SLT;
    end
    XOR: begin
      reg_write_read = 1'b1;
      reg_write = 1'b1;
      alu_src = 2'b10;
      alu_op = ALU_XOR;
    end
    AND: begin
      reg_write_read = 1'b1;
      reg_write = 1'b1;
      alu_src = 2'b10;
      alu_op = ALU_AND;
    end
    OR: begin
      reg_write_read = 1'b1;
      reg_write = 1'b1;
      alu_src = 2'b10;
      alu_op = ALU_OR;
    end
  endcase
end
endmodule
