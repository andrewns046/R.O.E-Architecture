module prog2(input        [15:1] d_in,
             output logic [11:1] d_out_corr);

logic  [15:1] d_in_corr;
logic         p8, p4, p2, p1;
logic  [11:1] d_out;
logic         s8, s4, s2, s1;
logic  [ 3:0] err;

assign p8 = d_in[8];
assign p4 = d_in[4];
assign p2 = d_in[2];
assign p1 = d_in[1];
assign d_out[11:5] = d_in[15:9];
assign d_out[ 4:2] = d_in[ 7:5];
assign d_out[   1] = d_in[   3];

assign s8 = ^d_out[11:5];
assign s4 = (^d_out[11:8])^(^d_out[4:2]); 
assign s2 = d_out[11]^d_out[10]^d_out[7]^d_out[6]^d_out[4]^d_out[3]^d_out[1];
assign s1 = d_out[11]^d_out[ 9]^d_out[7]^d_out[5]^d_out[4]^d_out[2]^d_out[1];

assign err = {s8^p8,s4^p4,s2^p2,s1^p1};

always_comb for(int k=1;k<16;k++)
  if(err==k) d_in_corr[k] = !d_in[k];
  else       d_in_corr[k] =  d_in[k];
assign d_out_corr[11:5] = d_in_corr[15:9];
assign d_out_corr[ 4:2] = d_in_corr[ 7:5];
assign d_out_corr[   1] = d_in_corr[   3];

endmodule

