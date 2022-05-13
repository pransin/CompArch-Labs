`include "1adder.v"

module _4adder(sum, cout, a, b, cin);
output [3:0]sum;
output cout;
input [3:0]a, b;
input cin;
wire c0, c1, c2;
_1adder_gate s0(sum[0], c0, a[0], b[0], cin);
_1adder_gate s1(sum[1], c1, a[1], b[1], c0);
_1adder_gate s2(sum[2], c2, a[2], b[2], c1);
_1adder_gate s3(sum[3], cout, a[3], b[3], c2);
endmodule

module testbench_4adder;
reg [3:0]a, b;
wire [3:0]sum;
wire cout;
_4adder a1(sum, cout, a, b, 1'b0);
initial begin
        $dumpfile("tb_fadder_4bit.vcd");
        $dumpvars;
end
initial begin
    $monitor("%3d : %b + %b = %b%b", $time, a, b, cout, sum);
    #0 a = 4'b0100;
    #0 b = 4'b0010;
    repeat(10)
        #5 b = b + 4'b0001;
        repeat(10)
            #5 a = a + 4'b0001;
end
endmodule;