module bit4AND (out,in1,in2);
  input [3:0] in1,in2;
  output [3:0] out;
  assign out= ~(in1 & in2);
endmodule