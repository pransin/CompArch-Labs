module d_ff(q, d, clk, reset);
  input d, clk, reset;
  output q;
  reg q;
  always @ (posedge clk or negedge reset)
  begin
    if (!reset)
      q <= 1'b0;
    else
      q <= d;
  end
endmodule

module reg_32bit(q, d, clk, reset);
  input [31:0]d;
  input clk, reset;
  output [31:0]q;
  genvar j;
  generate for(j = 0; j < 32; j = j + 1)
    begin: ff32
      d_ff d1(q[j], d[j], clk, reset);
        // dff_sync_clear d1(d[j],reset, clk, q[j]); 
    end
  endgenerate
endmodule

module tb32reg;
  reg [31:0] d;
  reg clk,reset;
  wire [31:0] q;
  reg_32bit R(q,d,clk,reset);
  always
    #5 clk<=~clk;
  initial
  begin
    $monitor("clk: ",clk," Reset = ", reset, " D = %b ", d, "Q = %b ",q," time = ", $time);
    clk= 1'b1;
    reset=1'b0;//reset the register
    #20 reset=1'b1;
    #20 d=32'hAFAFAFAF;
    #200 $finish;
  end
endmodule


// module reg_32bit(
//     output [31:0] q,
//     input [31:0] d,
//     input clk,
//     input reset);

//   genvar num;

//   generate for (num = 0 ; num < 32 ; num = num + 1)
//     begin: ffs
//       dff_sync_clear dff( d[num], reset, clk, q[num] );
//     end
//   endgenerate
// endmodule

// module tb_reg32bit();

//   wire [31:0] q;
//   reg [31:0] d;
//   reg clk, reset;
//   reg_32bit register( q, d, clk, reset);

//   always @(clk)
//     #5 clk <= ~clk;

//   initial
//     $monitor("clk: ",clk," Reset = ", reset, " D = %b ", d, "Q = %b ",q," time = ", $time);

//   initial
//   begin
//     clk = 1'b1;
//     reset = 1'b0;
//     #20 reset = 1'b1;
//     #20 d = 32'hAFAFAFAF;
//     #200 $finish;
//   end

// endmodule
