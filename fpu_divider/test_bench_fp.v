module tb_fp_div();
    initial begin
        $display ("The Group Members are:");
        $display ("********************************************");
        $display ("2019A7PS0146P Pranjal Singhal");
        $display ("2019A7PS0038P Ayush Agrawal");
        $display ("2018A7PS0096P Jainam Shah");
        $display ("2018A7PS0049P Harsh Agarwal");
        $display ("********************************************");
    end
    initial begin
        $display ("A few thigs about our design:");
        $display ("********************************************");
        $display ("It works on the Positive edge of the CLOCK signal");
        $display ("We have used the guard bits");
        $display ("********************************************");
    end
    reg [31:0]InputA;
    reg [31:0]InputB;
    reg CLOCK;
    reg RESET;
    wire [1:0]EXCEPTION;
    wire DONE;
    wire [31:0]AbyB;
    fpdiv fpdiv_test(AbyB, DONE, EXCEPTION, InputA, InputB, CLOCK, RESET);
    always @(CLOCK)
    #5 CLOCK <= ~CLOCK; //Toggle clock after every 5 time units
    initial
        begin
            $monitor("EXCEPTION=%b, DONE=%b, AbyB=%b, InputA=%b, InputB=%b",EXCEPTION,DONE,AbyB, InputA, InputB); //AbyB will be in binary representation
            // Divide by zero
            InputA= 32'b01000000100000000000000000000000; // 4.0
            InputB= 32'b00000000000000000000000000000000; // 0.0            
            RESET <= 1'b1;
            CLOCK <= 1'b0; //Initialize Clock
            #13 RESET <= 1'b0; //Reset goes off after 13 time units
            while(DONE == 0) // Wait till previous computation is finished
            begin
            #1;
            end
            RESET <= 1'b1;
            // Normal division
            InputA= 32'b01000000100000000000000000000000; // 4.0
            InputB= 32'b01000000000000000000000000000000; // 2.0
            #13 RESET <= 1'b0;
            
            while(DONE == 0)
            begin
            #1;
            end
            RESET <= 1'b1;

            //Inf divides Inf
            InputA= 32'b01111111100000000000000000000000; // Infinity
            InputB= 32'b01111111100000000000000000000000; // Infinity
            #13 RESET <= 1'b0;

            while(DONE == 0)
            begin
            #1;
            end
            RESET <= 1'b1;

            //Regular Division
            InputA= 32'b01000001000110011001100110011010; // 9.6
            InputB= 32'b01000000100110011001100110011010; // 4.8
            #13 RESET <= 1'b0;

            while(DONE == 0)
            begin
            #1;
            end
            RESET <= 1'b1;

            //One operand is NaN
            InputA= 32'b01111111100000000000000000000001; // NaN
            InputB= 32'b01000000100110011001100110011010; // 4.8
            #13 RESET <= 1'b0;
            


            while(DONE == 0)
            begin
            #1;
            end
            RESET <= 1'b1;

            //Overflow
            InputA= 32'b01101111100110011001100110011010; // 9.5 * 10^28;
            InputB= 32'b00000000100110011001100110011010; // 1.41 * 10^-31;
            #13 RESET <= 1'b0;

            while(DONE == 0)
            begin
            #1;
            end
            RESET <= 1'b1;

            //Underflow
            InputA= 32'b00000000100110011001100110011010; // 1.41 * 10^-31;
            InputB= 32'b01101111100110011001100110011010; // 9.5 * 10^28;
            #13 RESET <= 1'b0;

            #10000 $finish;
        end
endmodule
