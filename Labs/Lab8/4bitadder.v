module FA_dataflow (Cout, Sum,In1,In2,Cin);
  input [3:0]In1,In2;
  input Cin;
  output Cout;
  output [3:0]Sum;
  wire [3:0]binvert;
  assign binvert = In2 ^ {3{Cin}};
  assign {Cout,Sum}=In1+In2+Cin;
endmodule