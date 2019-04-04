module prog3(input[3:0] pat,
 input[63:0] str,
  output logic[7:0] ctb,cts);

logic[7:0] mat_str[8];
logic[63:0] str2; 
always_comb begin
  for(int i=0;i<8;i++)
    mat_str[7-i] = str>>(8*i);
  ctb = 0;
  for(int j=0;j<8;j++) begin
    for(int k=0;k<5;k++) begin
      if(pat==mat_str[j][3:0]) ctb++;     
	  mat_str[j] = mat_str[j]>>1;
	end
  end
end
always_comb begin
  cts = 0;
  str2 = str;
  for(int j=0; j<59; j++) begin
    if(pat==str2[3:0]) cts++;
	str2 = str2>>1;
  end
end    
endmodule