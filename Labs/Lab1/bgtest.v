module testbench;
reg [3:0] a; wire [3:0]f; 
bcd2gray_gate foo (f,a); 
initial
    begin
    $monitor(,$time," a=%b, f=%b",a,f);
        #0 a=4'b1011;
        #2 a=4'b1100;
        #5 a=4'b0100;
        // #10 a=1'b1;b=1'b0;
        // #15 s=1'b1;
        // #20 s=1'b0;
        #100 $finish;
    end
endmodule