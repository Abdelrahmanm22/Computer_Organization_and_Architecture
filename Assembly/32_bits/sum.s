# To download gcc on windows:
# download mingw (and make sure gcc is chosen while installation) from: 
# mingw-get-setup.exe at the site https://osdn.net/projects/mingw/
# then append c:\mingw\bin; to the start of the PATH environment variable from control panel

# To compile this assembly program on windows:
# gcc -O3 -o sum.exe sum.s
# After running the program, enter a positive integer (n<=100) and then enter n integers then press enter

#------------------------------------------------------------------------------------------------------

.intel_syntax noprefix  # use the intel syntax, not AT&T syntax. do not prefix registers with %

#------------------------------------------------------------------------------------------------------

.section .data        # initialized memory variables, will be part of the exe

input: .asciz "%d"    # string terminated by 0 that will be used for scanf parameter
output: .asciz "The sum is: %d\n"     # string terminated by 0 that will be used for printf parameter
n: .int 0             # the variable n which we will get from user using scanf

#------------------------------------------------------------------------------------------------------

.section .bss         # uninitialized memory variables, may not be part of the exe

.lcomm arr, 400       # arr is an array that can hold at most 100 32-bits integers
                      # lcomm means that the variable cannot be accessed from other files

#------------------------------------------------------------------------------------------------------

.section .text        # instructions

.globl _main          # make _main accessible from external

_main:                # the label indicating the start of the program

   # get the number of integers from the user -------------------------------------------

   push OFFSET n      # push to stack the second parameter to scanf (the address of the integer variable n)
   push OFFSET input  # push to stack the first parameter to scanf
   call _scanf        # call scanf, it will use the two parameters on the top of the stack in the reverse order
   add esp, 8         # pop the above two parameters from the stack (the esp register keeps track of the stack top, 8=2*4 bytes popped as param was 4 bytes)

   # get the n integers from the user ---------------------------------------------------

   mov ecx, 0         # ecx iterates over the integer array (0,1,...,n-1)
   mov ebx, OFFSET arr  # ebx iterates over the integer array (0,4,8, ...)
 
input_loop:
   
   push ecx           # push to stack ecx because _scanf may change it
   push ebx           # push to stack ebx because _scanf may change it

   push ebx           # push to stack the second parameter to scanf
   push OFFSET input         # push to stack the first parameter to scanf
   call _scanf        # call scanf, it will use the two parameters on the top of the stack in the reverse order
   add esp, 8         # pop the above two parameters from the stack
   
   pop ebx            # pop ebx
   pop ecx            # pop ecx

   add ebx, 4
   add ecx, 1
   
   cmp n, ecx         # compare ecx and n and update some status flags that will be used by ja below
   ja input_loop      # ja = jump if above: goto input_loop only if n > ecx

   # sum the n integers ------------------------------------------------------------------

   mov ecx, 0         # ecx iterates over the integer array (0,1,...,n-1)
   mov eax, 0         # eax stores the sum

comp_loop:

   add eax, [arr + ecx*4] # [base + index*size] will get the value at: (OFFSET base) + index*size

   add ecx, 1

   cmp n, ecx         # compare ecx and n and update some status flags that will be used by ja below
   ja comp_loop       # ja = jump if above: goto input_loop only if n > ecx
   
   # print the sum of integers -------------------------------------------------------------

   push eax           # push to stack the second parameter to printf
   push OFFSET output # push to stack the first parameter to printf
   call _printf       # call printf
   add esp, 8         # pop the two parameters

   ret                # end the main function
   
#------------------------------------------------------------------------------------------------------
