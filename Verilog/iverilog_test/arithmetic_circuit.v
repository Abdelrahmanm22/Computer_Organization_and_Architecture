//we use 14 components: 3 from(4x1 MUX) and 3 from (2x1)MUX and 3 from (FullAdder) and 4 from (not gate) and 1 from AND gate

//We implemintation Full_adder using two half_adders
module half_adder(output sum, output carry, input a, input b);
   //make sum = a ^ b
   xor(sum, a, b);
   //make carry = a & b
   and(carry, a, b);
endmodule

module full_adder(output sum, output carry, input x, input y, input z);
   //Wires are used for connecting different elements(2 half_adders and or gate ).
   wire s1, c1, c2;
   //call half_adder1==> input:x,y -- output: S1,c1
   half_adder h1(s1, c1, x, y);
   
   //call half_adder2==> input:s1,z -- output: sum,c2
   half_adder h2(sum, c2, s1, z);
   // make carry = c1 | c2
   or(carry, c1, c2);
endmodule

//4*1 Multipluxer==> we have 7 components: 4 from (and gates) 2 from (not gates) and 1 from or gates
module Multipluxer4(I0,I1,I2,I3,S1,S0,Y);
    
    input I0,I1,I2,I3,S0,S1;
    output Y;
    //Wires are used for connecting different elements(4 AND gates and 1 (or) gate and 2 not gates ).
    wire N1,N2,W1,W2,W3,W4;
    //N1=~S0
    not (N1,S0);
    //N2=~S1
    not (N2,S1);
    //W1=I0&N2&N1
    and (W1,I0,N2,N1);
    //W2=I1&N2&S0
    and (W2,I1,N2,S0);
    //W3=I2&S1&N1
    and (W3,I2,S1,N1);
    //W4=I3&S1&S0
    and (W4,I3,S1,S0);
    //Y = W1 | W2 | W3 | W4
    or (Y,W1,W2,W3,W4);
endmodule

//2*1 Multipluxer we have 4 components: 2 from (and gates) 1 from (not gates) and 1 from or gates
module Multipluxer2(I0,I1,S,Y);
    input I0,I1,S;
    output Y;
    //Wires are used for connecting different elements(2 AND gates and 1 (or) gate and 1 not gates ).
    wire N,W1,W2;
    //N=~S
    not (N,S);
    //W1 = I0 & N
    and (W1,I0,N);
    //W2 = I1 & S
    and (W2,I1,S);
    //Y = W1 | W2
    or (Y,W1,W2);
endmodule

//The input is two selection inputs, and two signed integers in 2's complement form: A and B, each integer is 3-bits.
module arithmatic(G, A,B, S1, S0,FinalCarry);
    //output in 3-bit and carry
    output [3:0] G;
    output FinalCarry;//for carry
    input S0,S1;//for selection
    input [2:0]A;//two signed integers in 2's complement form: A and B
    input [2:0]B;
    // output reg c=1'b0;
    
    //To make and gate
    wire S;
    and (S,S0,S1); //S=S0&S1

    //To make clear componet    
    wire clear;
    not (clear,0);

    //To make not firt bit for b
    wire b0;
    not (b0,B[0]);

   //To make not second bit for b
    wire b1;
    not (b1,B[1]);

    //To make not third bit for b
    wire b2;
    not (b2,B[2]);

    //Wires are used for connecting 3 MUX(4x1) with Full Adder
    wire out1,out2,out3;
    Multipluxer4 m1(clear,B[0],b0,b0,S1,S0,out1);
    Multipluxer4 m2(clear,B[1],b1,b1,S1,S0,out2);
    Multipluxer4 m3(clear,B[2],b2,b2,S1,S0,out3);

    //Wires are used for connecting 3 MUX(2x1) with Full Adder
    wire ouT1,ouT2,ouT3; 
    Multipluxer2 a1(A[0],1'b0,S,ouT1);
    Multipluxer2 a2(A[1],1'b0,S,ouT2);
    Multipluxer2 a3(A[2],1'b0,S,ouT3);

    //here connect S1 and output from 3 MUX(2x1) and output from 3 MUX(4x1) with FullAdder 
    wire carry1,carry2;
    full_adder f1(G[0],carry1,out1,ouT1,S1);//we pass S1 first time
    full_adder f2(G[1],carry2,out2,ouT2,carry1);//we pass carry1 from f1
    full_adder f3(G[2],FinalCarry,out3,ouT3,carry2);//we pass carry2 from f2 and output finalCarry



endmodule
//------------------------------------------------------------------our_main--------------------------------------//
module arithmatic_test();
    wire [3:0] G;
    wire FinalCarry;
    reg [2:0]A;
    reg [2:0]B;
    reg S0,S1;
    
    arithmatic Ar(G, A,B, S1, S0,FinalCarry);//to call module arithmatic 

   initial
   begin
        //To display test cases
      $monitor($time," ","A=%b,B=%b",A,B," ","S1=%b,S0=%b",S1,S0," ","G[2]=%b, G[1]=%b, G[0]=%b", G[2], G[1], G[0]," FinalCarry: ",FinalCarry );
      begin
        //our test cases//
        
        A=3'b101;
        B=3'b101;
        S1=1'b0;
        S0=1'b0;
        #1 S1=1'b0; S0=1'b0;
        #1 S1=1'b0; S0=1'b1;
        #1 S1=1'b1; S0=1'b0;
        #1 S1=1'b1; S0=1'b1;



        A=3'b001;
        B=3'b000;
        #1 S1=1'b0; S0=1'b0;
        #1 S1=1'b0; S0=1'b1;
        #1 S1=1'b1; S0=1'b0;
        #1 S1=1'b1; S0=1'b1;

        A=3'b010;
        B=3'b000;
        #1 S1=1'b0; S0=1'b0;
        #1 S1=1'b0; S0=1'b1;
        #1 S1=1'b1; S0=1'b0;
        #1 S1=1'b1; S0=1'b1;

        A=3'b011;
        B=3'b000;
        #1 S1=1'b0; S0=1'b0;
        #1 S1=1'b0; S0=1'b1;
        #1 S1=1'b1; S0=1'b0;
        #1 S1=1'b1; S0=1'b1;

        A=3'b100;
        B=3'b000;
        #1 S1=1'b0; S0=1'b0;
        #1 S1=1'b0; S0=1'b1;
        #1 S1=1'b1; S0=1'b0;
        #1 S1=1'b1; S0=1'b1;

        A=3'b101;
        B=3'b000;
        #1 S1=1'b0; S0=1'b0;
        #1 S1=1'b0; S0=1'b1;
        #1 S1=1'b1; S0=1'b0;
        #1 S1=1'b1; S0=1'b1;

        A=3'b110;
        B=3'b000;
        #1 S1=1'b0; S0=1'b0;
        #1 S1=1'b0; S0=1'b1;
        #1 S1=1'b1; S0=1'b0;
        #1 S1=1'b1; S0=1'b1;

        A=3'b111;
        B=3'b000;
        #1 S1=1'b0; S0=1'b0;
        #1 S1=1'b0; S0=1'b1;
        #1 S1=1'b1; S0=1'b0;
        #1 S1=1'b1; S0=1'b1;

        A=3'b000;
        B=3'b001;
        #1 S1=1'b0; S0=1'b0;
        #1 S1=1'b0; S0=1'b1;
        #1 S1=1'b1; S0=1'b0;
        #1 S1=1'b1; S0=1'b1;

        A=3'b000;
        B=3'b010;
        #1 S1=1'b0; S0=1'b0;
        #1 S1=1'b0; S0=1'b1;
        #1 S1=1'b1; S0=1'b0;
        #1 S1=1'b1; S0=1'b1;

        A=3'b000;
        B=3'b011;
        #1 S1=1'b0; S0=1'b0;
        #1 S1=1'b0; S0=1'b1;
        #1 S1=1'b1; S0=1'b0;
        #1 S1=1'b1; S0=1'b1;


      $finish;
      end
   end
endmodule
//------------------------------------------------------------------our_main--------------------------------------//
