module prog3(input[3:0] pat,
  input[63:0] str,
  output logic[7:0] ctb,cts,cto);

logic[7:0] mat_str[2][8];
logic[63:0] str2; 
logic ctp;
always_comb begin
  ctb = 0;
  for(int i=0;i<8;i++)
    mat_str[1][7-i] = str>>(8*i);
  for(int j=0;j<8;j++) begin
    for(int k=0;k<6;k++) begin
      if(pat==mat_str[1][j][3:0]) ctb++;     
	  mat_str[1][j] = mat_str[1][j]>>1;
	end
  end
end

always_comb begin
  cto = 0;
  for(int i=0;i<8;i++)
    mat_str[0][7-i] = str>>(8*i);
  for(int j=0;j<8;j++) begin
    ctp = 0;
    for(int k=0;k<6;k++) begin
      if(pat==mat_str[0][j][3:0]) ctp=1;     
	  mat_str[0][j] = mat_str[0][j]>>1;
	end
    cto = cto + ctp;
  end
end

always_comb begin
  cts = 0;
  str2 = str;
  for(int j=0; j<65; j++) begin
    if(pat==str2[3:0]) cts++;
	str2 = str2>>1;
  end
end    
endmodule