// Create Date:     May
// Created by:      Andrew N Sanchez
// Design Name:     R.O.E arch
// Module Name:     top (top of R.O.E arch design)

module prog #(parameter AW = 8, DW = 8)
 (input        clk,
               reset,	       // master reset from bench: "start over"
		           req,		       // from test bench: "do next program"
  output logic ack);	       // to test bench: "done with that program"

parameter pc_w = 16;

//control wires
wire [2:0] set_read0, set_read1, set_write;
wire reg_imm,
     reg_write_src,
     mem_write,
     mem_read,
     reg_write,
     reg_read_write,
     reg_write_read;
wire [3:0] alu_op;
wire [1:0] alu_src;

// lut wires
wire [pc_w-1:0] jump_addr_o;  // output of LUT

// pc wires
logic halt;
wire [pc_w-1:0] pc_o;  // program counter output

//instruction mem wires
wire [8:0] instr_o;	   // 9-bit machine code from instr ROM

// register decode wires
wire [3:0] reg_code0;
wire [3:0] reg_code1;
wire [3:0] reg_code_w;

// Register File wires
wire [7:0] read0_o, read1_o;  //output wire

// AlU wires
wire [7:0] alu_input2;  // input coming from alu mux
wire [7:0] result_o;    // result of alu
wire alu_bnz;         // alu signal to branch

// data memory wires
wire [7:0] readdata_o;

// write src mux
logic [7:0] writesrc_mux;
assign writesrc_mux = reg_write_src ? readdata_o : result_o;

// initialize look up table
lut lut1(read1_o, jump_addr_o);

// initialize program counter
program_counter pc( req, clk, alu_bnz, jump_addr_o, pc_o);

// initialize instrution memory
InstROM instr_mem( pc_o, instr_o );

//initialize control module
control ctrl(instr_o, set_read0, set_read1,
             set_write, reg_imm, reg_write_src,
             mem_write, mem_read, alu_op, alu_src,
             reg_write, reg_read_write, reg_write_read);


// initialize all 3 reg decode modules
regdecode regdecode_read0(set_read0, instr_o[1:0], clk, reg_code0);

// reg immediate mux before register decode read1
logic [1:0] regimm_mux;
assign regimm_mux = reg_imm ? instr_o[4:3]: instr_o[3:2]; // check control signal
regdecode regdecode_read1(set_read1, regimm_mux, clk, reg_code1);

regdecode regdecode_write(set_write, instr_o[5:4], clk, reg_code_w);

// initialize register file
// mux before read1 input
logic [3:0] regwr_mux;
assign regwr_mux = reg_write_read ? reg_code1 : reg_code_w;

// mux before write input
logic [3:0] regrw_mux;
assign regrw_mux = reg_read_write ? reg_code1 : reg_code_w;

reg_file register_file(clk, reg_code0, regwr_mux, regrw_mux,
                       reg_write, writesrc_mux, read0_o, read1_o);

// initialize alu
// mux before alu
alusrc_mux alu_mux( alu_src, read0_o, instr_o[3:0],
                    instr_o[2:0],
                    alu_input2);
alu alu1( read1_o, alu_input2, alu_op, alu_bnz, result_o);

// initialize data memory
dm dm1( clk, read1_o, mem_read,
              mem_write, read0_o, readdata_o);

// the following sequence makes sure the test bench
//  stops; in practice, you will want to tie your ack
//  flags to the completion of each program
always @(posedge clk) begin
  if(reset) begin
	   ack <= 0;
  end
  else if(req) begin
	   ack <= 0;
  end
  else if (instr_o == 9'b011_00_1111) begin  //redef 1111
      ack <= 1;				   // tells test bench to request next program
  end
end
endmodule
