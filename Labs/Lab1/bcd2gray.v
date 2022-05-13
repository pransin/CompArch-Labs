module bcd2gray_gate(gray, bcd);
input [3:0]bcd;
output [3:0]gray;

buf x0(gray[3], bcd[3]);
xor x1(gray[2], bcd[3], bcd[2]);
xor x2(gray[1], bcd[2], bcd[1]);
xor x3(gray[0], bcd[1], bcd[0]);
endmodule

// module bcd2gray_df(gray, bcd);
// 	input [3:0]a;
// 	output [3:0]b;
	
// 	assign b[3] = a[3];
// 	assign b[2] = a[3] ^ a[2];
// 	assign b[1] = a[2] ^ a[1];
// 	assign b[0] = a[1] ^ a[0];
// endmodule
