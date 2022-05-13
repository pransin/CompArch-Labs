module mux2to1(out,sel,in1,in2);
  input in1,in2,sel;
  output out;
  wire not_sel,a1,a2;
  not (not_sel,sel);
  and (a1,sel,in2);
  and (a2,not_sel,in1);
  or(out,a1,a2);
endmodule

module bit32_2to1mux(out,sel,in1,in2);
input [31:0] in1,in2;
output [31:0] out;
input sel;
genvar j;
//this is the variable that is be used in the generate //block
generate for (j=0; j<32;j=j+1) begin: mux_loop //mux_loop is the name of the loop
mux2to1 m1(out[j],sel,in1[j],in2[j]);
//mux2to1 is instantiated every time it is called
end
endgenerate
endmodule

module mux3to1(out,sel,in1,in2,in3);
  input in1,in2,in3;
  input [1:0]sel;
  output out;
  wire not_sel[1:0],a1,a2,a3;
  not (not_sel[1],sel[1]);
  not (not_sel[0],sel[0]);
  and (a1,not_sel[0],not_sel[1],in1);
  and (a2,sel[0],not_sel[1],in2);
  and (a3,not_sel[0],sel[1],in3);
  or(out,a1,a2,a3);
endmodule

module bit32_3to1mux(out,sel,in1,in2,in3);
input [31:0] in1,in2,in3;
output [31:0] out;
input [1:0]sel;
genvar j;
//this is the variable that is be used in the generate //block
generate for (j=0; j<32;j=j+1) begin: mux_loop //mux_loop is the name of the loop
mux3to1 m1(out[j],sel,in1[j],in2[j],in3[j]);
//mux3to1 is instantiated every time it is called
end
endgenerate
endmodule

// module tb_32bitmux;
// reg [31:0] in1, in2;
// reg sel;
// wire [31:0] out;
// bit32_2to1mux mux1(out, sel, in1, in2);
// initial begin
//     $monitor("%0d -> in1: %0h, in2: %0h, sel: %b, out: %0h", $time, in1, in2, sel, out);
//     in1 = 32'h1AAA;
//     in2 = 32'h3A4C;
//     sel = 1'b0;
//     #5 sel = 1'b1;
//     #10 $finish;
// end
// endmodule

// module tb_32bitmux_3in;
// reg [31:0] in1, in2, in3;
// reg [1:0]sel;
// wire [31:0] out;
// bit32_3to1mux mux1(out, sel, in1, in2, in3);
// initial begin
//     $monitor("%0d -> in1: %0h, in2: %0h, in3: %0h, sel: %b, out: %0h", $time, in1, in2, in3,sel, out);
//     in1 = 32'h1AAA;
//     in2 = 32'h3A4C;
//     in3 = 32'h4BCA;
//     sel = 2'b00;
//     #5 sel = 2'b10;
//     #5 sel = 2'b01;
//     #10 $finish;
// end
// endmodule