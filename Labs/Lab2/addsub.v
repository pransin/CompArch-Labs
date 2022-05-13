module addsub(
    output [3:0] sum, 
    output cout, 
    output v, 
    input [3:0]a, 
    input [3:0]b, 
    input m);
wire[3:0] b_m;
wire[3:0] c;
assign b_m[0] = b[0] ^ m; 
assign b_m[1] = b[1] ^ m; 
assign b_m[2] = b[2] ^ m; 
assign b_m[3] = b[3] ^ m;
FULLADDER a1()
endmodule