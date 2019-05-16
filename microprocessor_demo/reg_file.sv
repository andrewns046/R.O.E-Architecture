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
module reg_file #(parameter addr_w = 4)
    (input clk,                         // clock (for writes only)
     input [addr_w-1:0]  read0_addr,	  // read pointer rs
     input [addr_w-1:0]  read1_addr,	  // read pointer rt
     input [addr_w-1:0]  write_addr,	  // write pointer (rd)
     input wen,	                        // write enable
     input [7:0] write_data,          // data to be written/loaded
	   output logic [7:0] read0_val_o,	      // data read out of reg file
     output logic [7:0] read1_val_o);

logic [7:0] RF [2**addr_w];				  // core itself NOTE: ** means power
// two simultaneous, continuous, combinational reads supported
assign read0_val_o = RF [read0_addr];		  // out = RF content pointed to
assign read1_val_o = RF [read1_addr];

// synchronous (clocked) write to selected RF content "bin"
always_ff @ (posedge clk)
  if (wen)
	RF [write_addr] <= write_data;

endmodule
