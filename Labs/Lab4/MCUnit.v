module mainCU ( RegDest, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1, op );

input [5:0] op;
output RegDest, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1;

wire rformat, lw, sw, beq;

assign rformat = ~(op[0] | op[1] | op[2] | op[3] | op[4] | op[5]);
assign lw = (op[0] & op[1] & (~op[2]) & (~op[3]) & (~op[4]) & op[5]);
assign sw = (op[0] & op[1] & (~op[2]) & op[3] & (~op[4]) & op[5]);
assign beq = ((~op[0]) & (~op[1]) & op[2] & (~op[3]) & (~op[4]) & (~op[5]));

assign RegDest = rformat;
assign ALUSrc = lw | sw;
assign MemToReg = lw;
assign RegWrite = rformat | lw;
assign MemRead = lw;
assign MemWrite = sw;
assign Branch = beq;
assign ALUOp0 = rformat;
assign ALUOp1 = beq;

endmodule

module test_mainCU();
    
    reg [5:0] opcode;
    wire RegDest, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1;
    mainCU mcu(RegDest, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1, opcode);

    initial
    $monitor("Opcode: %b ",opcode," RegDest = %b ",RegDest," ALUSrc = %b ",ALUSrc," MemToReg = %b ",MemToReg, " RegWrite = %b ",RegWrite," MemRead = %b ",MemRead," MemWrite = %b ",MemWrite," Branch = %b ",Branch," ALUOp0 = %b ",ALUOp0," ALUOp1 = %b",  ALUOp1);

    always @(opcode) begin
        $display("Active Signals : ");
        if(RegDest)
            $display("RegDest");
        if(ALUSrc)
            $display("ALUSrc");
        if(MemToReg)
            $display("MemToReg");
        if(RegWrite)
            $display("RegWrite");
        if(MemRead)
            $display("MemRead");
        if(MemWrite)
            $display("MemWrite");
        if(Branch)
            $display("Branch");
        if(ALUOp0)
            $display("ALUOp0");
        if(ALUOp1)
            $display("ALUOp1");
    end


    initial begin
             opcode = 6'b000000;
        #500 opcode = 6'b100011;
        #1000 opcode = 6'b101011;
        #1500 opcode = 6'b000100;
        #2000 $finish;
    end


endmodule