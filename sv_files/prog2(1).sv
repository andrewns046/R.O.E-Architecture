// CSE141L  Spring 2019
// Program 2 -- receiver / error corrector
module prog2(input        [15:1] d_in,		    // data w/ parity
             output logic [11:1] d_out_corr);	// corrected data

logic  [15:1] d_in_corr;		       // corrected data w/ parity
logic         p8, p4, p2, p1;		   // received parity
logic  [11:1] d_out;				   // uncorrected data
logic         s8, s4, s2, s1;		   // reconstructed parity
logic  [ 3:0] err;					   // disparity

// pattern: d[11:5] p8 d[4:2] p4 d[1] p2 p1
assign d_out[11:5] = d_in[15:9];	   // parse 11 received data bits
assign p8          = d_in[   8];       // parse 4 received parity bits
assign d_out[ 4:2] = d_in[ 7:5];
assign p4          = d_in[   4];
assign d_out[   1] = d_in[   3];
assign p2          = d_in[   2];
assign p1          = d_in[   1];

// reconstruct parity according to received data
assign s8 = ^d_out[11:5];
assign s4 = (^d_out[11:8])^(^d_out[4:2]); 
assign s2 = d_out[11]^d_out[10]^d_out[7]^d_out[6]^d_out[4]^d_out[3]^d_out[1];
assign s1 = d_out[11]^d_out[ 9]^d_out[7]^d_out[5]^d_out[4]^d_out[2]^d_out[1];

// find where reconstructed parity != received parity
assign err = {s8^p8,s4^p4,s2^p2,s1^p1};

// the binary number "err" will point to the bad bit, if any
always_comb for(int k=1;k<16;k++)
  if(err==k) d_in_corr[k] = !d_in[k];
  else       d_in_corr[k] =  d_in[k];
// select the 11 corrected data bits from the 15 corrected data w/ parity
assign d_out_corr[11:5] = d_in_corr[15:9];
assign d_out_corr[ 4:2] = d_in_corr[ 7:5];
assign d_out_corr[   1] = d_in_corr[   3];

endmodule

