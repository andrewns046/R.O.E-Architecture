// Mux between instruction memory and reg decode
module muxImm ( input [1:0] b_i,
              input [1:0] a_i,
              input sel_i,
              output z_o);
always_comb unique case(sel_i)
  0: z_o = a_i;
  1: z_o = b_i;
endcase
endmodule
