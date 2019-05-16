// Create Date:        May 13, 2019
// Created by:         Andrew N. Sanchez
// Design Name:        R.O.E arch
// Module Name:        Reg Decode

module regdecode ( input [2:0] set_pa,
                   input [1:0] lower_reg_addr,
                   input clk,
                   output logic [3:0] reg_addr);

logic [1:0] pa;  // play area
logic enable_write;
assign enable_write = set_pa[2];  // 3rd bit is enable

always_ff @(posedge clk) begin
  if( enable_write == 1'b1 ) begin
    reg_addr <= {set_pa[1:0], lower_reg_addr};
    pa <= set_pa[1:0];
  end else if( enable_write == 1'b0 )
    reg_addr <= {pa, lower_reg_addr};
  else
    reg_addr <= 4'bXXXX;  //some garbage
end
endmodule
