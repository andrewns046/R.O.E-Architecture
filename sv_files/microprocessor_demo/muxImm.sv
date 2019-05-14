// Mux between instruction memory and reg decode
module muxImm (input [1:0] b,
              input [1:0] a,
              input sel,
              output z);
always_comb begin
  case(sel)
    0: z = a;
    1: z = b;
    default: z = 2'bXX;
  endcase
end
endmodule
