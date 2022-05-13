`define ADD 3'b000
`define SUB 3'b001
`define XOR 3'b010
`define OR 3'b011
`define AND 3'b100
`define NOR 3'b101
`define NAND 3'b110
`define XNOR 3'b111

module pipelineAlu(
    input [2:0] opcode,
    input [3:0] srcA,
    input [3:0] srcB,
    output [3:0] aluOut
  );

  wire [3:0] aluOut;

  assign aluOut = (opcode == `ADD) ? (srcA + srcB) :
         (opcode == `SUB) ? (srcA - srcB) :
         (opcode == `XOR) ? (srcA ^ srcB) :
         (opcode == `OR) ? (srcA | srcB) :
         (opcode == `AND) ? (srcA & srcB) :
         (opcode == `NOR) ? ~(srcA | srcB) :
         (opcode == `NAND) ? ~(srcA & srcB) :
         (opcode == `XNOR) ? ~(srcA ^ srcB) : 4'b0;


endmodule
