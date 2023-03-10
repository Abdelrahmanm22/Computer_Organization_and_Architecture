///////////////////////////////////////////////////////////////////////////////////////
//      Assignment -1 (( 4-bit ALU ))         
//      Abdalla Fadl Shehata  -    20190305  
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
module adding_one(a,s,cin,cout); // adding one to first number (a) 4 bits if selection inputs are s0=0,s1=0,s2=0 ( 0 0 0 )
    input [3:0] a;
    input cin;
    output cout;
    output [4:0] s;
    wire [3:0] b = 4'b0001;
    wire carry1,carry2,carry3,carry4;
    full_adder fa0(a[0],b[0],cin,s[0],carry1);
    full_adder fa1(a[1],b[1],carry1,s[1],carry2);
    full_adder fa2(a[2],b[2],carry2,s[2],carry3);
    full_adder fa3(a[3],b[3],carry3,s[3],carry4);
    full_adder fa4(1'b0,1'b0,carry4,s[4],cout);
endmodule
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
module arithmetic_shift_right(A,C); // arithmetic shift right for first number (a) 4 bits if selection inputs are s0=0,s1=0,s2=1 ( 0 0 1 )
    input [3:0] A;                    // input number (a) should be any number from 0 : 7  
    output[4:0] C;
    buf  b1(C[0],A[1]);
    buf  b2(C[1],A[2]);
    buf  b3(C[2],A[3]);
    buf  b4(C[3],A[3]);
    buf  b5(C[4],1'b0);
endmodule
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
module full_adder(a,b,cin,s,cout);   // full adder module for ripple carry 4 bit adder
    output s,cout; 
    wire w1,w2,w3; 
    input a,b,cin; 
    xor(w1,a,b);
    xor(s,w1,cin);
    and(w2,a,b);
    and(w3,w1,cin);
    or(cout,w3,w2);
endmodule
/////////////////////////////////////////////////////////////////////////////////////
module full_adder_test(a,b,s,cin,cout); // full adder test if  selection inputs are s0=0,s1=1,s2=0    ( 0 1 0 )
    input [3:0] a,b;
    input cin;
    output cout;
    output [4:0] s;
    wire carry1,carry2,carry3,carry4;
    full_adder fa0(a[0],b[0],cin,s[0],carry1);
    full_adder fa1(a[1],b[1],carry1,s[1],carry2);
    full_adder fa2(a[2],b[2],carry2,s[2],carry3);
    full_adder fa3(a[3],b[3],carry3,s[3],carry4);
    full_adder fa4(1'b0,1'b0,carry4,s[4],cout);
endmodule
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
module twos_complement(A,Z); // Two's complement of a 4 bit number
    input [3:0] A; 
    output [4:0] Z; 
    output cout;
    wire  a0,a1,a2,a3;
    not(a0,A[0]);
    not(a1,A[1]);
    not(a2,A[2]);
    not(a3,A[3]);
    wire [3:0] in;
    assign in[0]=a0;
    assign in[1]=a1;
    assign in[2]=a2;
    assign in[3]=a3;
    full_adder_test fa0(in,4'b0001,Z,1'b0,cout);
endmodule
//////////////////////////////////////////////////////////////////////////////////////
module substract_test(A,B,C); // substract two 4 bits number if selection inputs are s0=0,s1=1,s2=1 ( 0 1 1 )
    input [3:0] A,B;
    output [4:0] C;
    output [4:0] C2; 
    output cout;
    wire [4:0] out;
    twos_complement fa1(B,out);
    wire [3:0] out2 ;
    buf  b1(out2[0],out[0]);
    buf  b2(out2[1],out[1]);
    buf  b3(out2[2],out[2]);
    buf  b4(out2[3],out[3]);
    full_adder_test fa0(A,out2,C2,1'b0,cout);
    buf  b5(C[0],C2[0]);
    buf  b6(C[1],C2[1]);
    buf  b7(C[2],C2[2]);
    buf  b8(C[3],C2[3]);
    not(C[4],C2[4]);
endmodule
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
module substract_one(A,C); // substract one from first number (a) 4 bits if selection inputs are s0=1,s1=0,s2=0 ( 1 0 0 )
    input [3:0] A;
    output [4:0] C;
    output [4:0] C2; 
    output cout;
    wire [4:0] out;
    wire [3:0] B = 4'b0001;
    twos_complement fa1(B,out);
    wire [3:0] out2 ;
    buf  b1(out2[0],out[0]);
    buf  b2(out2[1],out[1]);
    buf  b3(out2[2],out[2]);
    buf  b4(out2[3],out[3]);
    full_adder_test fa0(A,out2,C2,1'b0,cout);
    buf  b5(C[0],C2[0]);
    buf  b6(C[1],C2[1]);
    buf  b7(C[2],C2[2]);
    buf  b8(C[3],C2[3]);
    not(C[4],C2[4]);
endmodule
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
module AND(a,b,c);    //    AND operation of 2 Numbers A and B if selection inputs are s0=1,s1=0,s2=1 ( 1 0 1 )
    input [3:0] a,b;
    output [4:0] c;
    and(c[0],a[0],b[0]);    
    and(c[1],a[1],b[1]);
    and(c[2],a[2],b[2]);
    and(c[3],a[3],b[3]);
endmodule
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
module OR(a,b,c);    //    OR operation of 2 Numbers A and B if selection inputs are s0=1,s1=1,s2=0 ( 1 1 0 )  
    input [3:0] a,b;
    output [4:0] c;
    or(c[0],a[0],b[0]);    
    or(c[1],a[1],b[1]);
    or(c[2],a[2],b[2]);
    or(c[3],a[3],b[3]);
endmodule
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
module XOR(a,b,c);     //         XoR operation of 2 Numbers A and B if selection inputs are s0=1,s1=1,s2=1 ( 1 1 1 )
    input [3:0] a,b; output [4:0] c;
    xor(c[0],a[0],b[0]);
    xor(c[1],a[1],b[1]);
    xor(c[2],a[2],b[2]);
    xor(c[3],a[3],b[3]);
endmodule
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
module mux_8to_1(out,i0,i1,i2,i3,i4,i5,i6,i7,s0,s1,s2); // 8:1 multiplexer 
    input i0,i1,i2,i3,i4,i5,i6,i7,s0,s1,s2;
    output out;
    wire w1,w2,w3,w4,w5,w6,w7,w8,s00,s01,s02;
    not(s00,s0);
    not(s01,s1);
    not(s02,s2);
    and(w1,i0,s00,s01,s02);
    and(w2,i1,s00,s01,s2);
    and(w3,i2,s00,s1,s02);
    and(w4,i3,s00,s1,s2);
    and(w5,i4,s0,s01,s02);
    and(w6,i5,s0,s01,s2);
    and(w7,i6,s0,s1,s02);
    and(w8,i7,s0,s1,s2);
    or(out,w1,w2,w3,w4,w5,w6,w7,w8);
endmodule

module ALU(a,b,outp1,outp2,outp3,outp4,outp5,s0,s1,s2);
    input [3:0] a,b;
    input s0,s1,s2;
    output cout;
    wire [4:0] c1,c2,c3,c4,c5,c6,c7,c8;
    output outp1,outp2,outp3,outp4,outp5;
    adding_one fa0(a,c1,1'b0,cout);            //      carry = 0 
    arithmetic_shift_right fa1(a,c2);
    full_adder_test fa2(a,b,c3,1'b0,cout);     //      carry = 0 
    substract_test fa3(a,b,c4);
    substract_one fa4(a,c5);
    AND fa5(a,b,c6);
    OR fa6(a,b,c7);
    XOR fa7(a,b,c8);
    mux_8to_1 b0(outp1,c1[4],c2[4],c3[4],c4[4],c5[4],c6[4],c7[4],c8[4],s0,s1,s2);
    mux_8to_1 b1(outp2,c1[3],c2[3],c3[3],c4[3],c5[3],c6[3],c7[3],c8[3],s0,s1,s2);
    mux_8to_1 b2(outp3,c1[2],c2[2],c3[2],c4[2],c5[2],c6[2],c7[2],c8[2],s0,s1,s2);    
    mux_8to_1 b3(outp4,c1[1],c2[1],c3[1],c4[1],c5[1],c6[1],c7[1],c8[1],s0,s1,s2);
    mux_8to_1 b4(outp5,c1[0],c2[0],c3[0],c4[0],c5[0],c6[0],c7[0],c8[0],s0,s1,s2);
endmodule
//*************************************************************************************************************//
//*************************************************************************************************************//
//*************************************************[[[[[[[Main]]]]]]]******************************************//
module main();
    reg [3:0] a,b; //A,B
    reg s0,s1,s2; //S
    wire opt1,opt2,opt3,opt4,opt5; //G
    ALU obj(a,b,opt1,opt2,opt3,opt4,opt5,s0,s1,s2);
    
    initial    
    begin
        s0=0;s1=0;s2=0;
        a<= 4'b1111;
        b<= 4'b1010;   
        $monitor("RESULT = %b %b %b %b %b\n",opt1,opt2,opt3,opt4,opt5);        
    end
    
endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*

<<selection inputs>>       <<operation>>

s0     s1     s2              output

0      0      0                a+1

0      0      1             shift right (a)

0      1      0                 a+b

0      1      1                 a-b

1      0      0                 a-1

1      0      1               a and b 

1      1      0               a or b

1      1      1               a xor b

*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////