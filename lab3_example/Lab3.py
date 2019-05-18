

print('Running Lab3:')



#fileObj = open("filename", "mode") 
filename = "Assembly3.txt"

read_file = open(filename, "r") 

#Print read_file

#w_file is the file we are writing to

w_file = open("Machine3.txt", "w")


#Open a file name and read each line
#to strip \n newline chars
#lines = [line.rstrip('\n') for line in open('filename')]  

#1. open the file
#2. for each line in the file,
#3.     split the string by white spaces
#4.      if the first string == SET then op3 = 0, else op3 = 1
#5.      
with open(filename, 'r') as f:
  for line in f:
    print line
    str_array = line.split()
    instruction = str_array[0]

    print instruction
    print str_array

    if instruction == "SET":
      op3 = "1"
      imm = str_array[1]  #need to reformat without the hashtag
      imm = imm[1:]
      bin_imm = '{0:08b}'.format(int(imm)) #8 bit immediate
      #str_array[2] should be the comment
      return_set = op3 + bin_imm + '\t' + "#" + " " + instruction \
           + " " + "#" + imm 
      w_file.write(return_set + '\n')
    else:
      op3 = "0"      
      op1 = str_array[1]

      if instruction == "LB":
        opcode = "000"
        op2 = str_array[2]
      elif instruction == "SB":
        opcode = "001" 
        op2 = str_array[2]
      elif instruction == "XOR":
        opcode = "010"
        op2 = str_array[2]
      elif instruction == "AND":
        opcode = "011"
        op2 = str_array[2]
      elif instruction == "ADD":
        opcode = "100" 
        op2 = str_array[2]
      elif instruction == "SLP": 
        opcode = "101"
        op2 = "000"         # slp only has 1 arg
      elif instruction == "CMP":
        opcode = "110"
        op2 = str_array[2]
      elif instruction == "BNE":
        opcode = "111" 
        op2 = "000"         # bne only has 1 arg
      else:
        opcode = "error: undefined opcode"
        print "error: undefined opcode"
    

      if ((op1 == "$t2" or op1 == "$t3" or op1 == "$t4") 
            or (op2 == "$t2" or op2 == "$t3" or op2 == "$t4")):
         level = "1"
      else:
         level = "0"

      print op1

      if (op1 == "$r0,"):
        reg1 = "00"
      elif (op1 == "$LFSR,"):
        reg1 = "01"
      elif (op1 == "$t0,"):
        reg1 = "10" 
      elif (op1 == "$t1,"):
        reg1 = "11"
      elif (op1 == "$t2,"):
        reg1 = "01"
      elif (op1 == "$t3,"):
        reg1 = "10"
      elif (op1 == "$t4,"):
        reg1 = "11"

      if (op2 == "$r0"):
        reg2 = "00"
      elif (op2 == "$LFSR"):
        reg2 = "01"
      elif (op2 == "$t0"):
        reg2 = "10" 
      elif (op2 == "$t1"):
        reg2 = "11"
      elif (op2 == "$t2"):
        reg2 = "01"
      elif (op2 == "$t3"):
        reg2 = "10"
      elif (op2 == "$t4"):
        reg2 = "11"

      if op2 == "000":
        return_rtype = op3 + opcode + reg1 + reg2 + level \
                    + '\t' + "#" + " " + instruction \
                    + " " + op1 
      else:
        return_rtype = op3 + opcode + reg1 + reg2 + level \
                    + '\t' + "#" + " " + instruction \
                    + " " + op1 + " " + op2
        

      w_file.write(return_rtype + '\n' )



w_file.close()
   

      


