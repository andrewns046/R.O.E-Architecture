// Created By:     Andrew N. Sanchez
// Create Date:    May 22, 2019
// LUT Table: Stores line instructions

module lut #(parameter addr_i_w = 8, addr_o_w = 16)(
  input logic[addr_i_w-1:0] lut_addr,
  output logic[addr_o_w-1:0] lut_out);

  logic [addr_o_w:0] lut_table [2**addr_i_w]; // holds 256 values that are 16 wide

  initial
  // test bench lut
  //$readmemb("C:/Users/Tonik/Desktop/CSE141LEMU/lut_test.txt", lut_table);
  //lut program 3
  $readmemb("C:/Users/Tonik/Desktop/CSE141LEMU/assembly/lut_program3assembly.txt", lut_table);

  // continuous combinational read output
  // change the pointer (from program counter) ==> change the output
  assign lut_out = lut_table[lut_addr];

endmodule
