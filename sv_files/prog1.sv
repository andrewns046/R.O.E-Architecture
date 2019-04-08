// CSE141L   Spring 2019   Program 1 -- Hamming Block Code generator
// demonstration module -- computes 4 parity bits for any given
//   combination of 11 data bits
module prog1(input       [11:1] d_in,	    // data bits (payload)
             output logic[15:1]	d_out);	    // data with parity embedded
logic p8, p4, p2, p1;		 // error correction parity bits (overhead)

// generate parity bits
assign p8 = ^d_in[11:5];
assign p4 = (^d_in[11:8])^(^d_in[4:2]); 
assign p2 = d_in[11]^d_in[10]^d_in[7]^d_in[6]^d_in[4]^d_in[3]^d_in[1];
assign p1 = d_in[11]^d_in[ 9]^d_in[7]^d_in[5]^d_in[4]^d_in[2]^d_in[1];
// assemble output (data with parity embedded)
assign d_out = {d_in[11:5],p8,d_in[4:2],p4,d_in[1],p2,p1};

endmodule