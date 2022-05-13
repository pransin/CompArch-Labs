`include "32bitAND.v"
`include "32bitOR.v"
`include "32bitadder.v"
// `include "32bitALU.v"
`include "32bitmux.v"

module ALU(result, carryout, binvert, operation, a, b, carryin);
  output [31:0]result;
  output carryout;
  input binvert, carryin;
  input [1:0]operation;
  input [31:0]a, b;
  wire [31:0]bin_out, and_out, or_out, add_out;
  bit32_2to1mux bin_mux(bin_out, binvert, b, ~b);
  bit32AND and_op(and_out, a, bin_out);
  bit32OR or_op(or_out, a, bin_out);
  FA_dataflow adder(carryout, add_out, a, bin_out, binvert);
  bit32_3to1mux out_mux(result, operation, and_out, or_out, add_out);
endmodule


module tbALU();
  reg Binvert, Carryin;
  reg [1:0] Operation;
  reg [31:0] a,b;
  wire [31:0] Result;
  wire CarryOut;
  ALU alu(Result, CarryOut, Binvert, Operation, a, b, Carryin);
  initial
  begin
    $monitor("%0d -> in1: %0h, in2: %0h, out: %0h", $time, a, b, Result);
    a=32'ha5a5a5a5;
    b=32'h5a5a5a5a;
    Operation=2'b00;
    Binvert=1'b0;
    Carryin=1'b0; //must perform AND resulting in zero
    #100 Operation=2'b01; //OR
    #100 Operation=2'b10; //ADD
    #100 Binvert=1'b1;//SUB
    #300 $finish;
  end
endmodule
