module jkffmodule (
    output reg q,
    input j, k, clk, clr
  );
  always @(posedge clk)
  begin
    if(!clr)
      q <= 1'b0;
    else if(j && k)
    begin
      q <= ~q;
    end
    else if(!j && k)
    begin
      q <= 1'b0;
    end
    else if(j && !k)
    begin
      q <= 1'b1;
    end
  end
endmodule

module sync_counter (
    input clk, reset,
    output wire [3:0]q
  );
  wire q0q1;
  assign q0q1 = q[0] & q[1];

  wire q0q1q2;
  assign q0q1q2 = q0q1 & q[2];
//   Is this sequential or concurrent? If concurrent look at 4adder.v
  jkffmodule f0(q[0], 1'b1, 1'b1, clk, reset);
  jkffmodule f1(q[1], q[0], q[0], clk, reset);
  jkffmodule f2(q[2], q0q1, q0q1, clk, reset);
  jkffmodule f3(q[3], q0q1q2, q0q1q2, clk, reset);
endmodule


module tb_sync_counter;
  wire [3:0] q;
  reg clk, reset;

  initial
    clk = 0;

  always
    #2 clk = ~clk;

  initial
  begin
    $monitor("q = %b ", q, " clk = %b ", clk," reset = %b ", reset);
  end

  sync_counter ctr(clk, reset, q);

  initial
  begin
    reset = 1'b0;
    #4 reset = 1'b1;
    // #10 reset = 1'b1;
    #64 $finish;
  end
endmodule
