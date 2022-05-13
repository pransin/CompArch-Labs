module inMem(pc, ins);
  input [4:0]pc;
  output reg [31:0]ins;
  reg [31:0][31:0] mem;
  initial
  begin
    mem[0] = 32'h00000200;
    mem[1] = 32'h00000201;
    mem[2] = 32'h00000204;
    mem[3] = 32'h00000108;
  end

  always @(pc)
    ins = mem[pc]; 
endmodule
