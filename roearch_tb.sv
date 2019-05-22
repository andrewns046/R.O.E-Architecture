// Test bench to ensure all hardware in ROE is working properly

module roearch_tb();

logic clk = 0,
      reset = 1,
      req = 1;
wire ack;

prog DUT(.*);  // init roe arch

initial begin
  //test branch not equal to 0 instruction

  // test set lower bits instruction
  DUT.register_file.RF[0] = 8'b10101111; // put 0xAF in regfile[0]
  #10ns reset = 1'b0;
  #10ns req = 1'b1;  // pulse request to DUT
  #10ns req = 1'b0;
  wait(ack);        // wait for acknowledgment that instruction was done
  $display("Running slb p0, 0001");
  $display("Expected:\t0xA1\tResult:\t%2h", DUT.register_file.RF[0]);

  // test addi instruction
  DUT.register_file.RF[0] = 8'd100; // put 100 in regfile[0]
  #10ns req = 1'b1;  // pulse request to DUT
  #10ns req = 1'b0;
  wait(ack);        // wait for acknowledgment that instruction was done
  $display("Running addi $p0, 8");
  $display("Expected:\t108\tResult:\t%d", DUT.register_file.RF[0]);


  //test subtract instruction
  DUT.register_file.RF[0] = 8'd100; // put 100 in regfile[0]
  #10ns req = 1'b1;  // pulse request to DUT
  #10ns req = 1'b0;
  wait(ack);        // wait for acknowledgment that instruction was done
  $display("Running subi $p0, 7");
  $display("Expected:\t93\tResult:\t%d", DUT.register_file.RF[0]);

  //test shift left instruction
  DUT.register_file.RF[0] = 8'h02; // put 100 in regfile[0]
  #10ns req = 1'b1;  // pulse request to DUT
  #10ns req = 1'b0;
  wait(ack);        // wait for acknowledgment that instruction was done
  $display("Running sli $p0, 2");
  $display("Expected:\t8\tResult:\t%d", DUT.register_file.RF[0]);

  //test shift right instruction
  DUT.register_file.RF[0] = 8'h10; // put 100 in regfile[0]
  #10ns req = 1'b1;  // pulse request to DUT
  #10ns req = 1'b0;
  wait(ack);        // wait for acknowledgment that instruction was done
  $display("Running sri $p0, 1");
  $display("Expected:\t0x08\tResult:\t%2h", DUT.register_file.RF[0]);

  //test redef instruction
  DUT.register_file.RF[4] = 8'd99; // put 99 in regfile[0]
  #10ns req = 1'b1;  // pulse request to DUT
  #10ns req = 1'b0;
  wait(ack);        // wait for acknowledgment that instruction was done
  $display("Running redef and adding 99 + 2");
  $display("Expected:\t101\tResult:\t%d", DUT.register_file.RF[4]);

  //test load instruction
  DUT.dm1.core[0] = 8'hAD;  // place a value in data mem
  DUT.register_file.RF[0] = 8'd0;
  #10ns req = 1'b1;  // pulse request to DUT
  #10ns req = 1'b0;
  wait(ack);        // wait for acknowledgment that instruction was done
  $display("Trying ld $p1, $p0 ");
  $display("Expected:\tAD\tResult:\t%h", DUT.register_file.RF[1]);

  //test store instruction
  DUT.register_file.RF[0] = 8'd1;  // addr 1
  DUT.register_file.RF[1] = 8'hAA;
  #10ns req = 1'b1;  // pulse request to DUT
  #10ns req = 1'b0;
  wait(ack);        // wait for acknowledgment that instruction was done
  $display("Trying sw $p1, $p0 ");
  $display("Expected:\tAA\tResult:\t%2h", DUT.dm1.core[1]);

  //test set on less than instruction
  DUT.register_file.RF[0] = 8'd1;  // addr 1
  DUT.register_file.RF[1] = 8'd5;
  #10ns req = 1'b1;  // pulse request to DUT
  #10ns req = 1'b0;
  wait(ack);        // wait for acknowledgment that instruction was done
  $display("Trying slt $p2, $p1, $p0 ");
  $display("Expected:\t0\tResult:\t%d", DUT.register_file.RF[2]);

  //test XOR instruction
  DUT.register_file.RF[0] = 8'd1;  // addr 1
  DUT.register_file.RF[1] = 8'd0;
  #10ns req = 1'b1;  // pulse request to DUT
  #10ns req = 1'b0;
  wait(ack);        // wait for acknowledgment that instruction was done
  $display("Trying XOR $p2, $p1, $p0 ");
  $display("Expected:\t1\tResult:\t%d", DUT.register_file.RF[2]);

  //test AND instruction
  DUT.register_file.RF[0] = 8'd1;  // addr 1
  DUT.register_file.RF[1] = 8'd0;
  #10ns req = 1'b1;  // pulse request to DUT
  #10ns req = 1'b0;
  wait(ack);        // wait for acknowledgment that instruction was done
  $display("Trying XOR $p2, $p1, $p0 ");
  $display("Expected:\t0\tResult:\t%d", DUT.register_file.RF[2]);

  //test OR instruction
  DUT.register_file.RF[0] = 8'd1;  // addr 1
  DUT.register_file.RF[1] = 8'd0;
  #10ns req = 1'b1;  // pulse request to DUT
  #10ns req = 1'b0;
  wait(ack);        // wait for acknowledgment that instruction was done
  $display("Trying XOR $p2, $p1, $p0 ");
  $display("Expected:\t1\tResult:\t%d", DUT.register_file.RF[2]);
  #10ns $stop;
end

always begin
  #5ns clk = 1;
  #5ns clk = 0;
end
endmodule
