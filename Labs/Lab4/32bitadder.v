module FA_dataflow (Cout, Sum,In1,In2,Cin);
  input [31:0]In1,In2;
  input Cin;
  output Cout;
  output [31:0]Sum;
  assign {Cout,Sum}=In1+In2+Cin;
endmodule

module tb_FA;
    reg [31:0]in1, in2;
    reg cin;
    wire cout;
    wire [31:0]sum;
    FA_dataflow fa1(cout, sum, in1, in2, cin);
    initial begin
        $monitor("%0d -> in1: %0h, in2: %0h, cin: %0b, sum: %0h, cout: %b", $time, in1, in2, cin, sum, cout);
        in1=32'hA4F5;
        in2=32'h3AF2;
        cin=1'b1;
        #10 in1=32'h4F32;
        #10 cin = 1'b0;
        #400 $finish;
    end
    initial
    begin
        $dumpfile("adder.vcd");
        $dumpvars;
    end
endmodule