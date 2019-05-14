// Create Date:        May 13, 2019
// Created by:         Andrew N. Sanchez
// Design Name:        R.O.E arch
// Module Name:        Reg Decode
module regdecode ( input [2:0] set_pa,
                   input [1:0] instr,
                   input clk,
                   output [3:0] reg_addr);

always_ff @(posedge clk) begin
  if( set_pa[2] == 1'b1)      //check first bit for enable signal
    reg_addr <= {pa, instr};  // write new header
  else
    reg_addr <= {reg_addr[3:2], instr};  //use old header
end
endmodule
