module _1adder_gate(sum, cout, a, b, cin);
  input a, b, cin;
  output sum, cout;
  wire t1, t2, t3;
  xor(sum, a, b, cin);
  and(t1, a, b);
  and(t2, b, cin);
  and(t3, cin, a);
  or(cout, t1, t2, t3);
endmodule

module _1adder_df(sum, cout, a, b, cin);
  input a, b, cin;
  output sum, cout;
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (b & cin) | (a & cin);
endmodule
module testbench;
  reg [2:0]in;
  wire sum, cout;
  _1adder_df a1(sum, cout, in[0], in[1], in[2]);
  initial
  begin
    $monitor("%2d ", $time, "input = %3b, sum = %b, cout = %b", in, sum, cout);
    #0 in = 3'b000;
    repeat(8)
      #10 in = in + 4'b0001;
    // #180 $finish;
  end
endmodule
