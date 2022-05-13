`include "parity.v"
`include "alu.v"
`include "encoder.v"

module pipelineCircuit(
    input [7:0] fncode,
    input [3:0] srcA,
    input [3:0] srcB,
    output parity
  );
  /*
  	ToDo: Use these registers for implementation, Code not correct right now as per labsheet requirements.
  */
  reg [10:0] IF_EXReg;
  reg [3:0] EX_PARReg;

  wire [2:0] opcode;
  wire [3:0] aluOut;

  encoder enc(fncode, opcode);
  pipelineAlu alu(opcode, srcA, srcB, aluOut);
  pg pargen(aluOut, parity);


endmodule

module tb_pipeline();

  reg [7:0] fncode;
  reg [3:0] srcA, srcB;

  wire parity;

  pipelineCircuit pc(fncode, srcA, srcB, parity);

  initial
  begin

    fncode = 8'b00000001;
    srcA   = 4'b0001;
    srcB   = 4'b0001;

    #100	fncode = 8'b00000010;
    #200	fncode = 8'b00000100;
    #300	fncode = 8'b00001000;
    #400	fncode = 8'b00010000;
    #500	fncode = 8'b00100000;
    #600	fncode = 8'b01000000;
    #700	fncode = 8'b10000000;

    #10 	$display("");

    #100	fncode = 8'b00000001;
    srcA   = 4'b0101;
    srcB   = 4'b1010;

    #100	fncode = 8'b00000010;
    #200	fncode = 8'b00000100;
    #300	fncode = 8'b00001000;
    #400	fncode = 8'b00010000;
    #500	fncode = 8'b00100000;
    #600	fncode = 8'b01000000;
    #700	fncode = 8'b10000000;
  end

  initial
  begin
    $monitor( "fncode : %b ",fncode, " srcA: %b ", srcA," srcB: %b ", srcB, " aluOut: %b ",pc.aluOut, " parity: %b ", parity  );
  end

endmodule
