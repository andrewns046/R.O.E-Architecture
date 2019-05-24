#!/usr/bin/env python
# coding: utf-8

# In[1]:


import sys
current_line = 0
current_decode_sets = ['p','p','p']
lines_to_insert = []
label_dict = {}
label_number = 0

class Error(Exception):
    pass

class CompilationError(Error):
    """Exception raised for errors that occur during compilation.

    Attributes:
        message -- explanation of the error
    """

    def __init__(self, message):
        self.message = message
        
def update_decodes(code):
    global current_decode_sets
    # Basically just a switch case on the first two "digits" of the code
    decode_reg = code[0:2]
    decode_set = code[2:4]
    if(decode_reg == "00"):
        if(decode_set == "00"):
            current_decode_sets[0] = 'p'
        elif(decode_set == "01"):
            current_decode_sets[0] = 'q'
        elif(decode_set == "10"):
            current_decode_sets[0] = 'r'  
        elif(decode_set == "11"):
            current_decode_sets[0] = 's'  
        else:
            raise CompilationError("update_decodes: Encountered invalid redef code, Line: " + current_line)
    elif(decode_reg == "01"):
        if(decode_set == "00"):
            current_decode_sets[1] = 'p'            
        elif(decode_set == "01"):
            current_decode_sets[1] = 'q'         
        elif(decode_set == "10"):
            current_decode_sets[1] = 'r'                       
        elif(decode_set == "11"):
            current_decode_sets[1] = 's'                    
        else:
            raise CompilationError("update_decodes: Encountered invalid redef code, Line: " + current_line)
    elif(decode_reg == "10"):
        if(decode_set == "00"):
            current_decode_sets[2] = 'p'
        elif(decode_set == "01"):
            current_decode_sets[2] = 'q'
        elif(decode_set == "10"):
            current_decode_sets[2] = 'r'
        elif(decode_set == "11"):
            current_decode_sets[2] = 's'
        else:
            raise CompilationError("update_decodes: Encountered invalid redef code, Line: " + current_line)
    # redef 1111 is a valid operation that denotes the end of a program, but doesn't change the sets
    elif(decode_reg == "11"):
        if(decode_set == "11"):
            pass
    else:
        raise CompilationError("update_decodes: Encountered invalid redef code, Line: " + current_line)
    return
        
def handle_redef(read0=None,read1=None,write=None):
    global current_line
    if(read0 is not None):
        if(current_decode_sets[0] != read0[1]):
            if(read0[1] == 'p'):
                update_decodes("0000")
                lines_to_insert.append(("  redef 0000\n",current_line))
            elif(read0[1] == 'q'):
                update_decodes("0001")
                lines_to_insert.append(("  redef 0001\n",current_line))                
            elif(read0[1] == 'r'):
                update_decodes("0010")
                lines_to_insert.append(("  redef 0010\n",current_line))                
            elif(read0[1] == 's'):
                update_decodes("0011")
                lines_to_insert.append(("  redef 0011\n",current_line))                
            else:
                raise CompilationError("handle_redef: Invalid register name, " + read0 +" Line: " + str(current_line))
            current_line += 1
    if(read1 is not None):
        if(current_decode_sets[1] != read1[1]):
            if(read1[1] == 'p'):
                update_decodes("0100")
                lines_to_insert.append(("  redef 0100\n",current_line))
            elif(read1[1] == 'q'):
                update_decodes("0101")
                lines_to_insert.append(("  redef 0101\n",current_line))                
            elif(read1[1] == 'r'):
                update_decodes("0110")
                lines_to_insert.append(("  redef 0110\n",current_line))                
            elif(read1[1] == 's'):
                update_decodes("0111")
                lines_to_insert.append(("  redef 0111\n",current_line))                
            else:
                raise CompilationError("handle_redef: Invalid register name, " + read1 + " Line: " + str(current_line))
            current_line += 1
    if(write is not None):
        if(current_decode_sets[2] != write[1]):
            if(write[1] == 'p'):
                update_decodes("1000")
                lines_to_insert.append(("  redef 1000\n",current_line))
            elif(write[1] == 'q'):
                update_decodes("1001")
                lines_to_insert.append(("  redef 1001\n",current_line))
            elif(write[1] == 'r'):
                update_decodes("1010")
                lines_to_insert.append(("  redef 1010\n",current_line))
            elif(write[1] == 's'):
                update_decodes("1011")
                lines_to_insert.append(("  redef 1011\n",current_line))
            else:
                raise CompilationError("handle_redef: Invalid register name, " + write + " Line: " + str(current_line))
            current_line += 1
    return

def handle_bnz(read1_new, label):
    global current_line
    if(label not in label_dict):
        raise CompilationError("handle_bnz: Label \"" + label + "\" not found, Line: " + str(current_line))
    label_lut_addr = label_dict[label]
    binary_lut_addr = to_binary(label_lut_addr,8)
    handle_redef(read1 = "$q3", read0 = "$q3", write = "$q3")
    lines_to_insert.append(("  slb $q3, " + binary_lut_addr[0:4]+"\n", current_line))
    current_line += 1
    lines_to_insert.append(("  sli $q3, 4\n", current_line))
    current_line += 1
    lines_to_insert.append(("  slb $q3, " + binary_lut_addr[4:8]+"\n", current_line))
    current_line += 1
    handle_redef(read1 = read1_new)
    return

def to_binary(dec_value, n_bits):
    ret_binary = ""
    if( dec_value >= 2**n_bits):
        raise CompilationError("to_binary: Given decimal value " + str(dec_value) + " does not fit in " + str(n_bits) + " bits")
    for i in reversed(range(n_bits)):
        if(dec_value >= 2**i):
            ret_binary += "1"
            dec_value -= 2**i
        else:
            ret_binary += "0"
    return ret_binary

def get_regno(register):
    return to_binary(int(register[2]),2)


# In[171]:


#sys.argv = ['compiler','../assembly/program3assembly.txt']
program_path = sys.argv[1]
program_name = program_path.split("/")[len(program_path.split("/"))-1]
directory = ""
for seg in program_path.split("/")[:len(program_path.split("/"))-1]:
    directory += seg + "/"
assembly_file = open(program_path,'r')
current_line = 0
current_decode_sets = ['p','p','p']
lines_to_insert = []
label_dict = {}
label_number = 0

for line in assembly_file:
    if(line[0] != ' ' and line[0] != '!'):
        split = line.split()
        label = split[0].partition(':')[0]
        if(label in label_dict):
            raise CompilationError("Label \"" + label + "\" appears twice!")
        label_dict[label] = label_number
        label_number += 1

assembly_file.close()
assembly_file = open(program_path,'r')
for line in assembly_file:
    if(line[0] != ' ' and line[0] != '!'):
        split = line.split()
        current_line += 1
        # handle_redef(read0 = "$p0", read1 = "$p0", write = "$p0")
        update_decodes("0000")
        lines_to_insert.append(("  redef 0000\n",current_line))
        current_line += 1
        update_decodes("0100")
        lines_to_insert.append(("  redef 0100\n",current_line))
        current_line += 1
        update_decodes("1000")
        lines_to_insert.append(("  redef 1000\n",current_line))
        current_line += 1
    elif(line[0] == ' ' and line[2] != '!'):
        split = line.split()
        if(split[0] == "slb"):
            handle_redef(write=split[1])
        elif(split[0] == "addi"):
            handle_redef(read1=split[1])
        elif(split[0] == "subi"):
            handle_redef(read1=split[1])
        elif(split[0] == "sli"):
            handle_redef(read1=split[1])
        elif(split[0] == "sri"):
            handle_redef(read1=split[1])
        elif(split[0] == "redef"):
            update_decodes(split[1])
        elif(split[0] == "lw"):
            handle_redef(read1=split[1],read0=split[2])
        elif(split[0] == "sw"):
            handle_redef(read1=split[1],read0=split[2])
        elif(split[0] == "bnz"):
            handle_bnz(read1_new=split[1],label=split[2])
        elif(split[0] == "slt"):
            handle_redef(write=split[1],read1=split[2],read0=split[3])
        elif(split[0] == "xor"):
            handle_redef(write=split[1],read1=split[2],read0=split[3])
        elif(split[0] == "and"):
            handle_redef(write=split[1],read1=split[2],read0=split[3])
        elif(split[0] == "or"):
            handle_redef(write=split[1],read1=split[2],read0=split[3])
        else:
            raise CompilationError("Encountered invalid opcode: " + split[0])
        current_line += 1
    else:
        current_line += 1
lines_to_insert.append(("  redef 1111\n",current_line))
assembly_file.close()
assembly_file = open(program_path,'r')
updated_contents = assembly_file.readlines()
for line in lines_to_insert:
    updated_contents.insert(line[1],line[0])

updated_assembly_file = open(directory + "updated_" + program_name,'w')
updated_contents = "".join(updated_contents)
updated_assembly_file.write(updated_contents)
updated_assembly_file.close()


# In[172]:


updated_assembly_file = open(directory + "updated_" + program_name,"r")
label_lut = []
current_line = 0
for line in updated_assembly_file:
    if(line[0] != ' ' and line[0] != '!'):
        label = line.split()[0].partition(":")[0]
        #label_lut.append(str(current_line))
        label_lut.append(to_binary(current_line,16) + "\n")
    elif(line[0] == ' ' and line[2] != '!'):
        current_line += 1
updated_assembly_file.close()
lut_file = open(directory + "lut_" + program_name,"w")
label_lut = "".join(label_lut)
lut_file.write(label_lut)
lut_file.close()


# In[173]:


updated_assembly_file = open(directory + "updated_" + program_name,"r")
machine_code_lines = []
label = ""
for line in updated_assembly_file:
    if(line[0] != ' ' and line[0] != '!'):
        label = line.split()[0].partition(":")[0]
    if(line[0] == ' ' and line[2] != '!'):
        split = line.split()
        op = split[0]
        line = line.rstrip()
        if(op == "slb"):
            machine_code = "000"
            machine_code += get_regno(split[1])
            machine_code += split[2]
            machine_code += " //" + line + " " + ("" if label == "" else "_(" + label + ")_") + "\n"
            machine_code_lines.append(machine_code)
            label = ""
        elif(op == "addi"):
            machine_code = "001"
            machine_code += "0"
            machine_code += get_regno(split[1])
            machine_code += to_binary(int(split[2])-1,3)
            machine_code += " //" + line + " " + ("" if label == "" else "_(" + label + ")_") + "\n"
            machine_code_lines.append(machine_code)
            label = ""
        elif(op == "subi"):
            machine_code = "001"
            machine_code += "1"
            machine_code += get_regno(split[1])
            machine_code += to_binary(int(split[2])-1,3)
            machine_code += " //" + line + " " + ("" if label == "" else "_(" + label + ")_") + "\n"
            machine_code_lines.append(machine_code)
            label = ""
        elif(op == "sli"):
            machine_code = "010"
            machine_code += "0"
            machine_code += get_regno(split[1])
            machine_code += to_binary(int(split[2])-1,3)
            machine_code += " //" + line + " " + ("" if label == "" else "_(" + label + ")_") + "\n"
            machine_code_lines.append(machine_code)
            label = ""
        elif(op == "sri"):
            machine_code = "010"
            machine_code += "1"
            machine_code += get_regno(split[1])
            machine_code += to_binary(int(split[2])-1,3)
            machine_code += " //" + line + " " + ("" if label == "" else "_(" + label + ")_") + "\n"
            machine_code_lines.append(machine_code)
            label = ""
        elif(op == "redef"):
            machine_code = "011"
            machine_code += "00"
            machine_code += split[1]
            machine_code += " //" + line + " " + ("" if label == "" else "_(" + label + ")_") + "\n"
            machine_code_lines.append(machine_code)
            label = ""
        elif(op == "lw"):
            machine_code = "011"
            machine_code += "01"
            machine_code += get_regno(split[1])
            machine_code += get_regno(split[2])
            machine_code += " //" + line + " " + ("" if label == "" else "_(" + label + ")_") + "\n"
            machine_code_lines.append(machine_code)
            label = ""
        elif(op == "sw"):
            machine_code = "011"
            machine_code += "10"
            machine_code += get_regno(split[1])
            machine_code += get_regno(split[2])
            machine_code += " //" + line + " " + ("" if label == "" else "_(" + label + ")_") + "\n"
            machine_code_lines.append(machine_code)
            label = ""
        elif(op == "bnz"):
            machine_code = "011"
            machine_code += "11"
            machine_code += get_regno(split[1])
            machine_code += get_regno("$q3")
            machine_code += " //" + line + " " + ("" if label == "" else "_(" + label + ")_") + "\n"
            machine_code_lines.append(machine_code)
            label = ""
        elif(op == "slt"):
            machine_code = "100"
            machine_code += get_regno(split[1])
            machine_code += get_regno(split[2])
            machine_code += get_regno(split[3])
            machine_code += " //" + line + " " + ("" if label == "" else "_(" + label + ")_") + "\n"
            machine_code_lines.append(machine_code)
            label = ""
        elif(op == "xor"):
            machine_code = "101"
            machine_code += get_regno(split[1])
            machine_code += get_regno(split[2])
            machine_code += get_regno(split[3])
            machine_code += " //" + line + " " + ("" if label == "" else "_(" + label + ")_") + "\n"
            machine_code_lines.append(machine_code)
            label = ""
        elif(op == "and"):
            machine_code = "110"
            machine_code += get_regno(split[1])
            machine_code += get_regno(split[2])
            machine_code += get_regno(split[3])
            machine_code += " //" + line + " " + ("" if label == "" else "_(" + label + ")_") + "\n"
            machine_code_lines.append(machine_code)
            label = ""
        elif(op == "or"):
            machine_code = "111"
            machine_code += get_regno(split[1])
            machine_code += get_regno(split[2])
            machine_code += get_regno(split[3])
            machine_code += " //" + line + " " + label + "\n"
            machine_code_lines.append(machine_code)
            label = ""
machine_code_file = open(directory + "machine_code_" + program_name,"w")
machine_code_lines = "".join(machine_code_lines)
machine_code_file.write(machine_code_lines)
machine_code_file.close()


# In[174]:


to_binary(30,8)


# In[ ]:




