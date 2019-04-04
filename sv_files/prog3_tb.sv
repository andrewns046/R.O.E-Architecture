// CSE141L  test bench for program 3
// search for pattern in longer string
module prog3_tb();

logic[ 3:0] pat = 4'b1011;	 // "Waldo"
logic[63:0] str;			 // continuous "where's"
wire [ 7:0] ctb, cts;		 // Waldos/byte, /string

logic[7:0] mat_str[8];		 // break string into 8-byte matrix

prog3 p3(.*);				 // instantiate DUT

// copy string into matrix
always_comb 
  for(int i=0;i<8;i++)
    mat_str[7-i] = str>>(8*i);

initial begin
  str = 0;		              // expect 0
  #10 $display(ctb,,,cts);
  #10 str[15:12] = pat;		  // expect 1, 1
  #10 $display(ctb,,,cts);
  #10 str[23:16] = {pat,pat}; // expect 3, 3
  #10 $display(ctb,,,cts);
  #10 str[41:38] = pat;		  // expect 3, 4 because it spans bytes
  #10 $display(ctb,,,cts);
  #10 $stop;
end
  
endmodule