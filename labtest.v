module division (FLAG, qnt, rem, inA, inB, CLOCK, RESET, LOAD);

  input CLOCK, RESET, LOAD ;
  input [15:0]inA;
  input [7:0]inB;
  output [2:0] FLAG;
  output [15:0] qnt;
  output [7:0]rem;
  reg qnt;
  reg [15:0]temp;
  reg rem;
  reg done;
  reg isLoaded;
  assign FLAG = (RESET) ? 3'b000 : //RESET
         (inB == 0) ? 3'b011 : //Special Case 1
         (inB == 1) ? 3'b100 : //Case 2
         ((inB & (inB - 1)) == 0) ? 3'b101 : //Case 3
         (inA < inB) ? 3'b111 : //Case 5
         (done) ? 3'b010: 3'b001; 

  always @(posedge CLOCK)
  begin
    if(LOAD) begin
      isLoaded = 1'b1;
      temp = inA;
    end
    if(isLoaded)
    begin
      case(FLAG)
      //RESET
        3'b000:
        begin
          qnt = 0;
          isLoaded = 0;
          done = 0;
        end
        // Case 1
        3'b011:
        begin
          qnt = 16'hFFFF;
          rem = 8'hFF;
        end
        // Case 2
        3'b100:
        begin
          qnt = temp;
          rem = 0;
        end
        // Case 3
        3'b101:
        begin
            
        end
        // Case 5
        3'b111:
        begin
          qnt = 0;
          rem = temp;
        end
        3'b001:
        begin
          qnt = qnt + 1;
          // temp = temp - inB;
          // if(temp < inB)
          //   done = 1'b1;
          if(inB * qnt < temp)
            done = 1'b1;
          // qnt = qnt + 1;
          
        end
        default
        begin

        end
      endcase
    end
  end
endmodule

module Division_tb;
  reg CLOCK, RESET, LOAD ;
  reg [15:0]inA ;
  reg [7:0]inB;
  wire [2:0] FLAG;
  wire[15:0] qnt;
  wire[7:0]rem;
  division dv(FLAG, qnt, rem, inA, inB, CLOCK, RESET, LOAD);
  always #2 CLOCK = ~CLOCK;
  initial
  begin
    CLOCK = 1'b0;
    LOAD = 1'b1;
    RESET = 1'b0;
    $monitor($time, " RESET=%b, LOAD=%b, inA=%b, inB=%b, FlAG=%b, qnt=%b, rem=%b", RESET, LOAD, inA, inB, FLAG, qnt, rem);
  end

  initial
  begin
    #2 inA = 16'b0000_0000_0000_0001;
    inB = 8'b0000_0000;
    #4 inA = 16'b0000_0000_0000_0001;
    inB = 8'b0000_0001;
    #4 inA = 16'b0000_1000_0000_0000;
    inB = 8'b1000_0000;
    #4 inA = 16'b1100_0000_0000_0000;
    inB = 8'b1100_0000;
    //min delay case
    #4 inA = 16'b0000_0000_0000_0001;
    inB = 8'b0000_0001;
    //max delay case
    #4 inA = 16'b1111_1111_1111_1111;
    inB = 8'b0000_0010;
    //two random cases
    #4 inA = 16'b0000_0000_0000_1000;
    inB = 8'b0000_0100;
    #4 inA = 16'b0000_0000_0000_1001;
    inB = 8'b0000_0011;

  end
endmodule
