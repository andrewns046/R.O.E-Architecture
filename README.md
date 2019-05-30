# R.O.E-Architecture
Running On Empty is a 9 bit Architecture designed to perform fec encoding/decoding and bit pattern searches. Below is the final architecture's datapath schematic:
![alt text](https://raw.githubusercontent.com/tonikhd/R.O.E-Architecture/master/roearchv9.png)

# ISA Table
Below is R.O.E's instruction set inspired by MIPS reg to reg architecture:
![alt text](https://raw.githubusercontent.com/tonikhd/R.O.E-Architecture/master/isatable.PNG)

# Emulator Files
This emulator was created to solidify the fec encoder/decoder and bit pattern searching algorithms. Inside the arch_emulator folder you will find two C programs:
  
  program1.c (fec encoder/decoder)
  
    - requires program1_2_results.txt(console output from SystemVerilog fec encoder/decoder)  
  
  program3.c (bit pattern search)
    
# Assembly Files
Assembly files for fec encoding/decoding and bit pattern searches are found in the assembly folder(program1.txt, program2.txt, program3.txt). In the assembly folder you will also find compiled machine code of the programs with the header "machine_code" followed by an underscore and the program name.(See compiler section for more details)

# Compiler
TODO: Mathew mention your other readme if you want but talk about the compilers purpose and our special memory redef statement plz. :)

# Tests
The test folder contains a test bench that tests each instruction in our ISA works properly with the the architecture's SystemVerilog code i.e the purpose of this test bench was to ensure the synthesized hardware works.

# How to run fec decoding/encoding and bit pattern searching

Inside the assembly folder are two already compiled machine code files that you will need.

1. Modify lut.sv line 16 to the path lut_allprograms.txt. Ex.

     $readmemb("C:/Users/USERNAME/Desktop/R.O.E-Architecture/assembly/lut_allprograms.txt", lut_table);

This file contains line numbers (in binary) that the compiler determined and stored in a text file for branching.

2. Next, modify InstROM.sv line 25 to the path of machine_code_allprograms.txt. Ex:

  $readmemb("C:/Users/USERNAME/Desktop/R.O.E-Architecture/assembly/machine_code_allprograms.txt", inst_rom);

This file contains machine code that will fire the programs in the test bench.

3. Finally, in Modelsim, compile all .sv files in the top level directory and load program123_tb.sv. Hit "run all" and look for the output in the console/transcript.




