module signExtender(in16, out32);
input [15:0]in16;
output [31:0]out32;
assign out32 = {{16{in16[15]}}, in16[15:0]};
endmodule
