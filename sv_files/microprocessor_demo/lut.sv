module lut(
  input[2:0] lut_addr,
  output logic lut_val);

always_comb case(lut_addr)
  3'h0:	 lut_val = 1'b0;
  3'h1:	 lut_val = 1'b1;
  3'h2:	 lut_val = 1'b0;
  3'h3:	 lut_val = 1'b1;
  default: lut_val = 1'b1;
endcase

endmodule