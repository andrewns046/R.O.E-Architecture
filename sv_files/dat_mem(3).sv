// Create Date:    2017.05.05
// Latest rev:     2017.10.26
// Created by:     J Eldon
// Design Name:    CSE141L
// Module Name:    Data Mem

// Generic data memory design for CSE141L projects
// width = 8 bits (per assignment spec.)
// depth = 2**W (default value of AW = 8, may be changed)
module dat_mem #(parameter AW=8)(
  input              CLK,                // clock
  input    [AW-1:0]  DataAddress,		 // pointer
  input              ReadMem,			 // read enable	(may be tied high)
  input              WriteMem,			 // write enable
  input       [7:0]  DataIn,			 // data to store (write into memory)
  output logic[7:0]  DataOut);			 //	data to load (read from memory)

  logic [7:0] core [2**AW]; 	   	     // create array of 2**AW elements (default = 256)

// optional initialization of memory, e.g. seeding with constants
//  initial 
//    $readmemh("dataram_init.list", my_memory);

// read from memory, e.g. on load instruction
  always_comb							 // reads are immediate/combinational
    if(ReadMem) begin
      DataOut = core[DataAddress];
// optional diagnostic print statement:
//	  $display("Memory read M[%d] = %d",DataAddress,DataOut);
    end else 
      DataOut = 8'bz;			         // z denotes high-impedance/undriven

// write to memory, e.g. on store instruction
  always_ff @ (posedge CLK)	             // writes are clocked / sequential
    if(WriteMem) begin
      core[DataAddress] <= DataIn;
//	  $display("Memory write M[%d] = %d",DataAddress,DataIn);
    end

endmodule
