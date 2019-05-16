// Create Date:        May 13, 2019
// Created by:         Andrew N. Sanchez
// Design Name:        R.O.E arch
// Module Name:        Reg Decode
module regdecode ( input [2:0] set_pa,
                   input [1:0] instr,
                   input clk,
                   output logic [3:0] reg_addr);
logic [1:0] pa;  //play area reg

always_ff @(posedge clk) begin
  if(set_pa[2] == 1'b1) begin     //check first bit for enable signal
    reg_addr <= {set_pa[1:0], instr};
    pa <= set_pa[1:0];  // update play area
  end else begin
    reg_addr <= {pa, instr};  //pass through
  end
end
endmodule
