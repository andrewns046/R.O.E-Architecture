// Create Date:    2017.05.05
// Latest rev:     2017.10.26
// Created by:     J Eldon
// Design name:    CSE141L
// Module Name:    InstROM 

// Generic instruction memory
// same format as any lookup table
// width = 9 bits (per assignment spec.)
// depth = 2**IW (default IW=16)
module InstROM #(parameter IW=16, DW=9)(
  input       [IW-1:0] InstAddress,	// address pointer
  output logic[DW-1:0] InstOut);
	 
  logic [DW-1:0] inst_rom [2**IW];	   // 2**IW elements, DW bits each
// load machine code program into instruction ROM
  initial 
	$readmemb("instruct.txt", inst_rom);

// continuous combinational read output  
//   change the pointer (from program counter) ==> change the output
  assign InstOut = inst_rom[InstAddress];

endmodule
