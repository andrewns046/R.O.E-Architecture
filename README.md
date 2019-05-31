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
The compiler is written in Python v. 3.7, originally in a Jupyter notebook. If Python is installed on your machine and can be run from the command line, entering this command in the command line will place the compiled files in the same folder as the assembly code you have pointed to:

python PATH_TO_COMPILER PATH_TO_FILE

If Jupyter notebook is your preferred method of compilation, simply open the notebook and uncomment the line beginning with # sys.arg, replacing PATH_TO_PROGRAM with the relative or absolute path to the program's assembly text file. This will also place the compiled files in the same folder as the program text.

Assembly files are written in plaintext (.txt files) and there are a few syntax rules that must be follow for succcessful compilation:

1. Labels must be written without preceding whitespace.
2. Whitespace and colons (:) are invalid characters in a label.
3. Labels must be followed by an immediate colon (:) as such:
```
    label:
```   
4. Operations must be preceded by two spaces.
5. Valid registers are $\[p,q,r,s]\[0,1,2,3], examples of valid registers:
```
    $p0
    $r2
    $q1
```   
6. Operation names must be followed by whitespace only:

    Valid:
    
          addi $p0, 5
          
    Invalid:
    
          addi, $p0, 5
          
7. Operants are followed by a comma unless they are the final operant; see above.
8. Comments are preceded by an exclamation mark and a space, example:

    ! This is a comment
    
9. Comments may be written with no indent, with the same indent as an operation (2 spaces preceding the exclamation mark),
   or after an operation. Example code, with comments:
``` 
labelnospace:
  ! Two preceding spaces
  addi $p0, 5
  subi $p2, 5 ! Comment following an operation
! No preceding spaces
  redef 0101 ! Code continues, two white spaces preceding
```

10. Blank lines are not allowed; if you wish to add visual space in your assembly code, place an exclamation mark at the 
    beginning of the line:
```    
! This is a comment, below is a valid empty line
!
! This is a comment, below is not a valid empty line

! The above line will break the compiler :*(
```

11. Because our processor uses "sets" of registers to access, i.e. the register you type may not be the one selected by
    the processor (for example, $p0 could be interpreted as $r0), the `redef` operation is used to change the set to the
    one you actually intended to use. Thankfully, you don't need to call these statements yourself. The compiler will
    automagically insert the correct series of `redef` operations before every line of code. You may insert them yourself,
    but that's kind of pointless because the compiler will correct it if it's wrong anyway. It's cool like that.

12. That being said, `bnz` operations must be written with a label name for the second argument. The compiler will
    automatically insert the operations necessary to convert it into a machine-code-convertible operation, ex:

```
bnz $p0, labelnospace
```
13. The compiler uses register `$q3` to hold the conversion from a label to a line-based target. It is advised that you
    do not use this register if possible, because its contents will be erased every time a branch instruction is encountered
    whether or not the branch is taken. 

14. With a single assembly program, the compiler will automatically insert an operation at the bottom of the code to signal
    that the program is finished. This operation is always:
    `redef 1111`
    If you want to write several programs that execute from one file, signaling when each program is finished, you must
    insert that command between each program.

15. It is highly advised to use a label to indicate the beginning and a label to indicate the end of every program you
    write, especially when you write several programs in one file. The compiler inserts a series of `redef` operations
    after every label to ensure that program behavior is consistent when a label is reached, whether or not the label was
    branched to. Branches would otherwise create unpredictable `redef` usage.
    
16. Register values are not set to a specific value by default.

17. Immediate operations must be written in decimal format, ex:
`sli $p0, 4`
    the compiler will replace this with an appropriate binary value in the machine code.

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




