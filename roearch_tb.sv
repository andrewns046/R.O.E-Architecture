// Test bench to ensure all hardware in ROE is working properly

module roearch_tb();

logic clk = 0;
reset = 1;
req = 1;
wire ack;

prog DUT(.*);  // init roe arch

initial begin
  // test set lower bits instruction
  DUT.reg_file.RF[0] = 8'b10101111; // put 0xAF in regfile[0]
  #10ns reset = 1'b0;
  #10ns req = 1'b1;  // pulse request to DUT
  #10ns req = 1'b0;
  wait(ack);        // wait for acknowledgment that instruction was done
  $display("Running slb p0, 0001");
  $display("Expected:\t0xA1\tResult:\t%2h", DUT.reg_file.RF[0]);

  // test addi instruction
  DUT.reg_file.RF[0] = 8'd100; // put 100 in regfile[0]
  #10ns req = 1'b1;  // pulse request to DUT
  #10ns req = 1'b0;
  wait(ack);        // wait for acknowledgment that instruction was done
  $display("Running slb p0, 0001");
  $display("Expected:\t0xA1\tResult:\t%2h", DUT.reg_file.RF[0]);

end

always begin
  #5ns clk = 1;
  #5ns clk = 0;
end
endmodule
