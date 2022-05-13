module tb_fp_div();
    initial begin
        $display ("The Group Members are:");
        $display ("********************************************");
        $display ("2019A7PS0146P Pranjal Singhal");
        $display ("2019A7PS0038P Ayush Agrawal");
        $display ("2019A7PS0096P Jainam Shah");
        $display ("2019A7PS0049P Harsh Agarwal");
        $display ("********************************************");
    end
    initial begin
        $display ("A few things about our design:");
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


module fpdiv(
        AbyB, 
        DONE, 
        EXCEPTION,
        InputA, 
        InputB, 
        CLOCK,
        RESET);
  input     CLOCK;
  input     RESET;
  // 0 -> div by zero
  // 1 -> under flow
  // 2 -> Over flow
  // 3 -> Invalid operands 
  input     [31:0] InputA;
  input     [31:0] InputB;

  output    [31:0] AbyB;
  output    [1:0]EXCEPTION;
  output    DONE;

  reg       z_ready;
  reg       [31:0] s_output_z;
  reg       [3:0] state;
// These parameters represent state of the program
  parameter get_a         = 4'd0,
            get_b         = 4'd1,
            unpack        = 4'd2,
            cases = 4'd3,
            normalise_a   = 4'd4,
            normalise_b   = 4'd5,
            divide_0      = 4'd6,
            divide_1      = 4'd7,
            divide_2      = 4'd8,
            divide_3      = 4'd9,
            normalise_1   = 4'd10,
            normalise_2   = 4'd11,
            round         = 4'd12,
            pack          = 4'd13,
            put_z         = 4'd14;

  reg       [31:0] a, b, z; // Load values to registers
  reg       [23:0] a_m, b_m, z_m; // Mantissa
  reg       [9:0] a_e, b_e, z_e; // exponent
  reg       a_s, b_s, z_s; // sign
  reg       guard, round_bit, sticky;
  reg       [50:0] quotient, divisor, dividend, remainder; //No idea why this is 51 bits
  reg       [5:0] count; //what is this??
  reg       [1:0] exec;
  
  always @(posedge CLOCK)
  begin
    case(state)
      get_a:
      begin
        a <= InputA;
        b <= InputB;

        state <= unpack;
      end

      unpack:
      begin
        a_m <= a[22 : 0];
        b_m <= b[22 : 0];
        a_e <= a[30 : 23] - 127; //Adjust bias
        b_e <= b[30 : 23] - 127;
        a_s <= a[31];
        b_s <= b[31];
        state <= cases;
      end

      cases:
      begin
        //if a is NaN or b is NaN return NaN 
        if ((a_e == 128 && a_m != 0) || (b_e == 128 && b_m != 0)) begin
          z[31] <= 1; //sign bit 1?
          z[30:23] <= 255;
          z[22] <= 1;
          z[21:0] <= 0;
          exec[1:0] <= 3;
          state <= put_z;
          //if a is inf and b is inf return NaN 
        end else if ((a_e == 128) && (b_e == 128)) begin
          z[31] <= 1;
          z[30:23] <= 255;
          z[22] <= 1;
          z[21:0] <= 0;
          exec[1:0] <= 3;
          state <= put_z;
        //if a is inf return inf
        end else if (a_e == 128) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 255;
          z[22:0] <= 0;
          exec[1:0] <= 3;
          state <= put_z;
           //if b is zero return NaN
          if ($signed(b_e == -127) && (b_m == 0)) begin
            z[31] <= 1;
            z[30:23] <= 255;
            z[22] <= 1;
            z[21:0] <= 0;
            exec[1:0] <= 0;
            state <= put_z;
          end
        //if b is inf return zero
        end else if (b_e == 128) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 0;
          z[22:0] <= 0;
          state <= put_z;
        //if a is zero return zero
        end else if (($signed(a_e) == -127) && (a_m == 0)) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 0;
          z[22:0] <= 0;
          state <= put_z;
           //if b is zero return NaN
          if (($signed(b_e) == -127) && (b_m == 0)) begin
            z[31] <= 1;
            z[30:23] <= 255;
            z[22] <= 1;
            z[21:0] <= 0;
            state <= put_z;
            exec[1:0] <= 0;
          end
        //if b is zero return inf
        end else if (($signed(b_e) == -127) && (b_m == 0)) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 255;
          z[22:0] <= 0;
          exec[1:0] <= 0;
          
          state <= put_z;
        end else begin
          // Check if a is denormalized number
          // a_m[23] and b_m[23] indicates if they are normalized
         
          if ($signed(a_e) == -127) begin
            a_e <= -126;
          end else begin
            a_m[23] <= 1;
          
          end
          // Check if b is denormalized number
          if ($signed(b_e) == -127) begin
            b_e <= -126;
          end else begin
            b_m[23] <= 1;
          end

          state <= normalise_a;
        end
      end

      normalise_a:
      begin
      // if a is normalized, then normalize b, otherwise normalize a.
        if (a_m[23]) begin
          state <= normalise_b;
        end else begin
          a_m <= a_m << 1;
          a_e <= a_e - 1;
        end
      end
      // if b is normalized, then proceed with actual division, otherwise normalize b.
      normalise_b:
      begin
        if (b_m[23]) begin
          state <= divide_0;
        end else begin
          b_m <= b_m << 1;
          b_e <= b_e - 1;
        end
      end
    // Normal division
      divide_0:
      begin
        z_s <= a_s ^ b_s;
        z_e <= a_e - b_e;
        quotient <= 0;
        remainder <= 0;
        count <= 0;
        dividend <= a_m << 27;
        divisor <= b_m;
        state <= divide_1;
      end

      divide_1:
      begin
        quotient <= quotient << 1;
        remainder <= remainder << 1;
        remainder[0] <= dividend[50];
        dividend <= dividend << 1;
        state <= divide_2;
      end

      divide_2:
      begin
        if (remainder >= divisor) begin
          quotient[0] <= 1;
          remainder <= remainder - divisor;
        end
        if (count == 49) begin
          state <= divide_3;
        end else begin
          count <= count + 1;
          state <= divide_1;
        end
      end

      divide_3:
      begin
        z_m <= quotient[26:3];
        guard <= quotient[2];
        round_bit <= quotient[1];
        sticky <= quotient[0] | (remainder != 0);
        state <= normalise_1;
      end
    // Begin Normalization
      normalise_1:
      begin
        if (z_m[23] == 0 && $signed(z_e) > -126) begin
          z_e <= z_e - 1;
          z_m <= z_m << 1;
          z_m[0] <= guard;
          guard <= round_bit;
          round_bit <= 0;
        end else begin
          state <= normalise_2;
        end
      end

      normalise_2:
      begin
        if ($signed(z_e) < -126) begin
          z_e <= z_e + 1;
          z_m <= z_m >> 1;
          guard <= z_m[0];
          round_bit <= guard;
          sticky <= sticky | round_bit;
        end else begin
          state <= round;
        end
      end

      round:
      begin
        if (guard && (round_bit | sticky | z_m[0])) begin
          z_m <= z_m + 1;
          if (z_m == 24'hffffff) begin
            z_e <=z_e + 1;
          end
        end
        state <= pack;
      end

      pack:
      begin
        z[22 : 0] <= z_m[22:0];
        z[30 : 23] <= z_e[7:0] + 127;
        z[31] <= z_s;
        // Underflow
        if ($signed(z_e) == -126 && z_m[23] == 0) begin
          z[30 : 23] <= 0;
          exec[1:0] <= 1;
        end
        //if overflow occurs, return inf
        if ($signed(z_e) > 127) begin
          z[22 : 0] <= 0;
          z[30 : 23] <= 255;
          z[31] <= z_s;
          exec[1:0] <= 2;
        end
        state <= put_z;
      end

      put_z:
      begin
        z_ready <= 1;
        s_output_z <= z;
        if (RESET) begin
          z_ready <= 0;
          state <= get_a;
        end
      end

    endcase

    if (RESET == 1) begin
      state <= get_a;
      z_ready <= 0;
    end
  
  end
  assign DONE = z_ready;
  assign AbyB = s_output_z;
  assign EXCEPTION = exec;
  
endmodule