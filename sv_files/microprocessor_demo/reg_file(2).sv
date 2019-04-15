// Create Date:    2017.05.05
// Latest rev:     2017.10.26s
// Created by:     J Eldon
// Design Name:    CSE141L
// Module Name:    Reg File

// register file with asynchronous read and synchronous write
// parameter raw = "RF address width" -- default is 4 bits,
//   for 16 words in the RF
// generic version has two separate read addresses and an
//  independent write address
// these may be strapped together or decoded in any way,
//  to save instruction or decoder bits
// reads are always enabled, hence no read enable control
module reg_file #(parameter raw = 4)
    (input             clk		     ,    // clock (for writes only)
    input   [raw-1:0]  rs_addr_i	 ,	  // read pointer rs
                       rt_addr_i	 ,	  // read pointer rt
                       write_addr_i  ,	  // write pointer (rd)
    input              wen_i		 ,	  // write enable
    input        [7:0] write_data_i	 ,	  // data to be written/loaded 
	output logic [7:0] rs_val_o	     ,	  // data read out of reg file
    output logic [7:0] rt_val_o
                );

logic [7:0] RF [2**raw];				  // core itself
// two simultaneous, continuous, combinational reads supported
assign rt_val_o = RF [rt_addr_i];		  // out = RF content pointed to
assign rs_val_o = RF [rs_addr_i];

// synchronous (clocked) write to selected RF content "bin"
always_ff @ (posedge clk)
  if (wen_i) 
	RF [write_addr_i] <= write_data_i;

endmodule

