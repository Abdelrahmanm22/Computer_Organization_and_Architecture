# Computer_Organization_and_Architecture
Computer Organization and Architecture Course ( CS331 )

Assignments
***************************************************************************************************
Assignment 1  ( Verilog )

* Write a Verilog HDL code that does the following:
* You must use only the MINIMUM number of the follwing components: Full-adders, 4x1 Multiplexers, 2x1 Multiplexers, or, and, not, xor gates.
* A full-adder counts only as 1 component, not counting the small components inside. Also, a multiplexer counts as 1 component.
* At the beginning of the file, write a comment including the components you have used and the number of them.
* You must implement multiplexers using structural Verilog descriptions as explained in figure 2-4 in section 2-3 in book "Computer system architecture".
* The input is two selection inputs, and two signed integers in 2's complement form: A and B, each integer is 3-bits.
* The output is a signed integer in 2's complement from: G, its size is 3-bits.
* When the selection inputs are 00, G = A-1
* When the selection inputs are 01, G = A+B
* When the selection inputs are 10, G = A-B
* When the selection inputs are 11, G = -B
* You must provide a test bench that tests all aspects of the implemented circuit with at least 40 test cases on various input values.
* You are not allowed to use behavioral Verilog descriptions (if, switch, ..etc) for multiplexers or any other aspects except for test bench.
* Use structured Verilog descriptions for all aspects, except for test bench, so you can use behavioral Verilog description for test bench only.
* The Verilog HDL code must be able to be compiled in the same way the provided lab samples are compiled with the instructions at top of them.
* Half the mark is dedicatd to comments explaining the code before each code line and test cases.

******************************************************************************************************
Assignment 2  ( Assembly )

* Write a 32-bits intel-syntax assembly program that can be compiled in the same way the 32-bits lab samples are compiled.
The program should take the following inputs from the user:
* An integer n.
* n floating point numbers (Use the "double" type. Do not use "float" type.)
The program should output (1 + 1/1) + (2 + 1/4) + (3 + 1/9) + (4 + 1/16) + ... + (n + 1/(n^2)).
Example:
The user inputs: 3
The program outputs: sum=7.361

