// Create Date:        May 13, 2019
// Created by:         Andrew N. Sanchez
// Design Name:        R.O.E arch
// Module Name:        Reg Decode

module regdecode ( input [2:0] set_pa,
                   input [1:0] lower_reg_addr,
                   input clk,
                   output logic [3:0] reg_addr);

logic [1:0] pa = 0;  // play area
logic enable_write;
assign enable_write = set_pa[2];  // 3rd bit is enable

always_comb begin
  reg_addr = {pa, lower_reg_addr};
end

always @(posedge clk) begin
  if( enable_write == 1'b1 ) begin
    pa <= set_pa[1:0];
  end
end
endmodule
