// CSE141L Spring 2019
// test bench for Hamming block code demo
// no timing -- just correct numeric matching
module prog1_2_tb();

logic[11:1] d_in;	              // original data
wire [11:1] d_out_corr;			  // recovered data
wire [15:1] d_out;				  // what is transmitted
logic[ 3:0] flip;				  // corruption position
logic[15:1] d_out_bad;			  // what is received
prog1 p1(.d_in (d_in),            // transmitter -- adds parity
         .d_out(d_out));
prog2 p2(.d_in      (d_out_bad),  // receiver -- uses parity to
         .d_out_corr(d_out_corr));//  correct any 1-bit error

initial begin
  $display(
   "  data_in      data_sent      corruption      data_out    error");
  for(int i=0; i<50; i++) begin
    d_in = $random;				  // randomize 11-bit data input
    flip = $random;				  // randomly flip one bit
	#1 d_out_bad = d_out ^ (1'b1<<flip);
	#1 $displayb(d_in,,d_out,,d_out^d_out_bad,,d_out_corr,,d_in^d_out_corr);
    #1;
  end
  $stop;
end


endmodule
