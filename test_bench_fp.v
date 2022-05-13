module fpdiv;
    reg InputA, InputB, CLOCK, RESET;
    wire EXCEPTION, DONE, AbyB;
    fpdiv fpdiv_test(InputA, InputB, CLOCK, RESET);
    initial
        begin
            $monitor("EXCEPTION=%b, DONE=%b, AbyB=%f",EXCEPTION,DONE,AbyB);
            #0 InputA=1'b0;InputB=1'b1;CLOCK=;RESET=;
            // #2 s=1'b1;
            // #5 s=1'b0;
            // #10 a=1'b1;b=1'b0;
            // #15 s=1'b1;
            // #20 s=1'b0;
            #100 $finish;
        end
endmodule