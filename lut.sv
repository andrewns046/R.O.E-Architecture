module lut #(parameter addr_i_w = 8, addr_o_w = 16)(
  input logic[addr_i_w:0] lut_addr,
  output logic[addr_o_w-1:0] lut_val);

// TODO: FILL this with addresses
always_comb case(lut_addr)
  3'h0:	 lut_val = 1'b0;
  3'h1:	 lut_val = 1'b1;
  3'h2:	 lut_val = 1'b0;
  3'h3:	 lut_val = 1'b1;
  default: lut_val = 1'b1;
endcase

endmodule
