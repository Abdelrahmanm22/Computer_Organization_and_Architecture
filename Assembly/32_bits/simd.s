# To download gcc on windows:
# download mingw (and make sure gcc is chosen while installation) from: 
# mingw-get-setup.exe at the site https://osdn.net/projects/mingw/
# then append c:\mingw\bin; to the start of the PATH environment variable from control panel

# To compile this assembly program on windows:
# gcc -O3 -o simd.exe simd.s
# After running the program, enter a positive integer (n<=100) and then enter n integers then press enter

#------------------------------------------------------------------------------------------------------

.intel_syntax noprefix  # use the intel syntax, not AT&T syntax. do not prefix registers with %

#------------------------------------------------------------------------------------------------------

.section .data        # initialized memory variables, will be part of the exe

input: .asciz "%d"    # string terminated by 0 that will be used for scanf parameter
outsum: .asciz "The sum is: %d\n"     # string terminated by 0 that will be used for printf parameter
outavg: .asciz "The average is: %f\n"     # string terminated by 0 that will be used for printf parameter
n: .int 0             # the variable n which we will get from user using scanf
res: .fill 16         # 16 bytes, each bytes is filled with zero
avg: .double 0

#------------------------------------------------------------------------------------------------------

.section .bss         # uninitialized memory variables, may not be part of the exe

.align 16
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
   push OFFSET input  # push to stack the first parameter to scanf
   call _scanf        # call scanf, it will use the two parameters on the top of the stack in the reverse order
   add esp, 8         # pop the above two parameters from the stack
   
   pop ebx            # pop ebx
   pop ecx            # pop ecx

   add ebx, 4
   add ecx, 1
   
   cmp n, ecx         # compare n and ecx and update some status flags that will be used by ja below
   ja input_loop      # ja = jump if above: goto input_loop only if n > ecx

   # sum the n integers -----------------------------------------------------------------

   mov ecx, n       
   sal ecx, 2      # shift left ecx by 2, ecx=4*n

   movdqu xmm1, res        # xmm1 contains 4 integers, each integer will store a partial sum. initialize to zeros
   movdqu [arr+ecx], xmm1  # put 4 additional zeros at the end of the input array (to avoid problems when n is not multiple of 4)

   mov ebx, OFFSET arr     # ebx iterates over the integer array (arr+0, arr+4*4, arr+8*4, ...)
   add ecx, OFFSET arr     # now ecx contains the after-last address of the array (will be used to stop the loop)
   
comp_loop:

   # printf changes sse-registers (xmm0-xmm3), so do not try to printf here for debugging

   movdqa xmm0, [ebx]      # move 4 integers from arr to xmm0. use aligned move for better performance
   paddd xmm1, xmm0        # add these 4 integers to the partial sums in xmm1
   
   # This line can be used instead of the above lines, but which method is faster?
   # paddd xmm1, [ebx]     # add these 4 integers to the partial sums in xmm1

   add ebx, 16             # go to the next 4 integers

   cmp ecx, ebx            # compare ecx and ebx
   ja comp_loop            # ja = jump if above: goto input_loop only if %ecx is above %ebx
   
   # extract and sum the resulting 4 integers in xmm1 ----------------------------------

   movdqu res, xmm1
   
   mov eax, 0
   add eax, res
   add eax, res+4
   add eax, res+8
   add eax, res+12

   # print the sum of integers ---------------------------------------------------------

   push eax                # the printf call will corrupt eax

   push eax                # push to stack the second parameter to printf
   push OFFSET outsum      # push to stack the first parameter to printf
   call _printf            # call printf
   add esp, 8              # pop the two parameters

   pop eax                 # the printf call will corrupt eax

   # calculate the average of integers -------------------------------------------------

   # the following lines convert from integer eax to double avg
   mov res, eax
   fild dword ptr res     # convert res to double and push it to stack
   fild dword ptr n       # convert n to double and push it to stack
   fdivp st(1), st(0)     # divides the two items on stack top and pops them and pushes the result
   fstp qword ptr avg

   # print the average of integers -------------------------------------------------------------

   push avg+4
   push avg
   push OFFSET outavg    # push to stack the first parameter to printf
   call _printf          # call printf
   add esp, 12           # pop the two parameters

   ret                # end the main function
   
#------------------------------------------------------------------------------------------------------
