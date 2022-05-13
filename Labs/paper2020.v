module counter_3bit(input clk, input clear, output reg [2:0]val);
  reg [2:0]stored;
  always @(posedge clk or clear)
  begin
    if(!clear)
      stored = 0;
    else
    begin
      stored = 1 + stored;
    end
    val = stored;
  end
endmodule

module decoder(input [2:0]in, input en, output reg [7:0]out);
  always @(in or en)
  begin
    if (en)
    begin
      case(in)
        3'b000:
          out = 8'b00000001;
        3'b001:
          out = 8'b00000010;
        3'b010:
          out = 8'b00000100;
        3'b011:
          out = 8'b00001000;
        3'b100:
          out = 8'b00010000;
        3'b101:
          out = 8'b00100000;
        3'b110:
          out = 8'b01000000;
        3'b111:
          out = 8'b10000000;
      endcase
    end
  end
endmodule
