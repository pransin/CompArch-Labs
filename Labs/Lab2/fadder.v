module FULLADDER(sum, a, b, cin);
output reg [1:0]sum;
input a, b, cin;
always @(a or b or cin) begin
    sum = a + b + cin;
end
endmodule

module testbench;
    reg [2:0]in;
    wire [1:0]out;
    FULLADDER f1(out, in[2], in[1], in[0]);
    initial begin
        $monitor("%2d: %b + %b + %b = %2b", $time, in[2], in[1], in[0], out);
        in = 3'b000;
        #5 in = 3'b001;
        #5 in = 3'b011;
        #5 in = 3'b101;
        #5 in = 3'b111;
        #5 in = 3'b010;
        #5 in = 3'b100;
        #5 in = 3'b110;
    end
endmodule