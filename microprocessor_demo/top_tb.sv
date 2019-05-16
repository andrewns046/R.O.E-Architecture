// testbench for sample design
// CSE141L   Fall 2017
module top_tb();

bit clk, reset = 1;
wire done;	  // output from design

top t1(		  // our design itself
  clk,  
  reset,
  done);

always begin
  #5ns clk = 1;
  #5ns clk = 0;
end

initial begin
  t1.rf1.RF[0] = 8'h02;
  t1.rf1.RF[1] = 8'h03;
  t1.rf1.RF[2] = 8'h04;
  t1.rf1.RF[3] = 8'h05;
  t1.rf1.RF[4] = 8'h02;
  t1.rf1.RF[5] = 8'h03;
  t1.rf1.RF[6] = 8'h04;
  t1.rf1.RF[7] = 8'h05;

  #20ns reset = 0;
  #5000ns $display("I give up."); 
  $stop;
end
initial
  #50ns wait(done) #40ns $stop;

endmodule