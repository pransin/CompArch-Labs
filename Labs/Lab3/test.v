module test;
reg x, y;
reg [1:0] z, w;
initial
begin
$monitor("%d, %d, %d, %d %d",$time, x, y, z, w);
fork
x = 1'b0; //completes at simulation time 0
#5 y = 1'b1; //completes at simulation time 5
#10 z = {x, y}; //completes at simulation time 10
#20 w = {y, x}; //completes at simulation time 20
join
#30 x = 1'b1;
end
endmodule