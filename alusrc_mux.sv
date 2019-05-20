// Create Date:        May 19, 2019
// Created by:         Andrew N. Sanchez
// Design Name:        R.O.E arch
// Module Name:        ALU MUX SRC SELECT

module alusrc_mux( input [1:0] alu_src,
                   input [7:0] read0,
                   input [3:0] to_ext,
                   input [3:0] to_inc,
                   output logic [7:0] sel_o);
always_comb begin
  case( alu_src ) begin
    2'b00: sel_o = {4'b0000, to_ext};
    2'b01: sel_o = to_inc + 'd1;
    2'b10: sel_o = read0;
    default: sel_o = 'bz;
end
endmodule
