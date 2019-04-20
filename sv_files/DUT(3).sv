// dummy DUT -- substitute your own
// CSE141L
// This is NOT synthesizable / realizable in hardware,
//  but fine for simulation only to enable the test bench
//  to function
module DUT(input clk, start, output logic done);
parameter AW = 8;		// mem pointer width
logic[  15:0] ct;  		// clock cycle counter
logic[AW-1:0] MemAdr;   // memory pointer
logic         WrMem;    // write (store) enable
logic[   7:0] toMem;	// data to write into memory
logic[   7:0] fmMem;    // data read from memory

// data memory
dat_mem #(.AW(AW)) dat_mem1
  (.CLK         (clk   ),
   .DataAddress (MemAdr),
   .ReadMem     (1'b1  ),
   .WriteMem    (WrMem ),
   .DataIn      (toMem ),
   .DataOut     (fmMem ));

always @(posedge clk)
  if(start) begin
    ct   <= 0;
	done <= 0;
// *note* -- hierarchical "drill-down" access is NOT permitted
//  in synthesizable code -- must point to a value using the
//  DataAddress = MemAdr pointer and receive the contents over
//  DataOut = fmMem
    dat_mem1.core[ 4] <= 0;
    dat_mem1.core[ 5] <= 0;
    dat_mem1.core[ 6] <= 0;
    dat_mem1.core[10] <= 0;
    dat_mem1.core[11] <= 0;
    dat_mem1.core[15] <= 0;
  end
  else begin
    ct   <= ct + 1;
	done <= ct[7:1]==16;
// divide-by-0 traps, limiter to all 1s (max), added
	if(!{dat_mem1.core[8],dat_mem1.core[9]})
	  {dat_mem1.core[10],dat_mem1.core[11]} <= '1;
	if(!dat_mem1.core[2])
	  {dat_mem1.core[4],dat_mem1.core[5],dat_mem1.core[6]} <= '1;
// sqrt(0) fast exit
	if(!{dat_mem1.core[13],dat_mem1.core[14]})
	  dat_mem1.core[15] <= 0;
  end
endmodule