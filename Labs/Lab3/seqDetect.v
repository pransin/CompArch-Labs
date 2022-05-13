module seqDetect( 
    input inSeq,
    input clk,
    input reset);

    parameter  s0 = 3'b000,
               s1 = 3'b001,
               s2 = 3'b010,
               s3 = 3'b011,
               s4 = 3'b100;
    
    reg [2:0] state;

    always @(posedge clk or posedge reset) begin
        if( reset )
            state <= s0;
        else begin
            // $display("current state = %b ",state);
            // $display("input:= ", inSeq);
            case (state)
                s0 : begin
                    // $display("State0");
                    if (inSeq) 
                        state <= s1;
                    else
                        state <= s0;
                end
                s1 : begin
                    // $display("State1");
                    if (inSeq) 
                        state <= s1;
                    else 
                        state <= s2;
                end
                s2 : begin
                    // $display("State2");
                    if (inSeq) 
                        state <= s3;
                    else 
                        state <= s0;
                end
                s3 : begin
                    // $display("State3");
                    if (inSeq) 
                        state <= s4;
                    else 
                        state <= s2;
                end
                s4 : begin
                    // $display("State4");
                    
                    if (!inSeq) begin
                        $display("Sequence detected");
                        state <= s2;
                    end
                    else 
                        state <= s1;
                end
                
                default: begin
                    $display("Default state");
                    state <= s0;
                end
            endcase 
        end
    end
endmodule

module test_seqDetect();

    reg inSeq, clk, reset;
    wire [2:0] state;
    integer i;

    always @(posedge clk)
        $display("inSeq = ", inSeq, " reset = ", reset);

    seqDetect sq(inSeq, clk, reset);

    reg [0:15] sequence;

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        reset = 1'b1;
        sequence = 16'b1011_1000_1011_0000;
        #5 reset = 1'b0;

        for (i = 0; i < 16 ; i = i+1 ) begin
             inSeq = sequence[i];
            #2 clk = 1'b1;
            #2 clk = 1'b0;
        end
    end

endmodule