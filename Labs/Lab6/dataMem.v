
module dataMem(addr, writeData, memWrite, memRead, data);
  input [4:0]addr;
  output reg [31:0]data;
  reg [31:0][31:0] mem;
  input [31:0]writeData;
  input memWrite, memRead;
  integer i;
  initial
  begin
    for(i = 0; i < 32; i = i + 1)
    begin
      mem[i] = 32'd0;
    end
  end
  always @(memRead)
    if(memRead)
      data = mem[addr];
  always @(posedge memWrite)
  begin
    mem[addr] = writeData;
  end
endmodule
