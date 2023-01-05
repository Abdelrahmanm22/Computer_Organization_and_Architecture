# To download gcc on windows:
# download mingw (and make sure gcc is chosen while installation) from: 
# mingw-get-setup.exe at the site https://osdn.net/projects/mingw/
# then append c:\mingw\bin; to the start of the PATH environment variable from control panel

# To compile this assembly program on windows:
# gcc -O3 -o funwithmain.exe funwithmain.s
# After running the program, enter a positive integer (n<=100) and then enter n integers then press enter

#------------------------------------------------------------------------------------------------------

.intel_syntax noprefix  # use the intel syntax, not AT&T syntax. do not prefix registers with %

#------------------------------------------------------------------------------------------------------

.section .data        # initialized memory variables, will be part of the exe

input: .asciz "%d"    # string terminated by 0 that will be used for scanf parameter
outsum: .asciz "The sum is: %d\n"     # string terminated by 0 that will be used for printf parameter

n: .int 0             # the variable n which we will get from user using scanf

#------------------------------------------------------------------------------------------------------

.section .bss         # uninitialized memory variables, may not be part of the exe

.align 16
.lcomm arr, 400       # arr is an array that can hold at most 400 32-bits integers
                      # lcomm means that the variable cannot be accessed from other files

#------------------------------------------------------------------------------------------------------

.section .text        # instructions

.globl _SumIntegers

_SumIntegers:       # it takes as parameters the address of the array and the size of the array. it returns the sum in %eax. C expects that too.

   push ebp         # we will use %ebp to access parameters and local variables. before doing this, we will save the old one
   mov ebp, esp     # now we can use %ebp to access parameters and local variables
   sub esp, 16      # reserve space for the local variables (not related to the following 3 lines) # res: 16 bytes, each byte is filled with zero
   
   push edi         # the registers %edi, %esi, %ebx must be preserved (for C) if they will be used here
   push esi
   push ebx

   #--------------------------------------------------------------------------------------------

   #         Function parameter 2   [ebp+16]
   #         Function parameter 1   [ebp+8]
   #         Return Address         [ebp+4]
   # ebp ->  Old ebp Value          [ebp]
   # esp ->  Local Variable 1       [ebp-16]

   #--------------------------------------------------------------------------------------------
   
   mov  ecx, [ebp+12]
   sal  ecx, 2         # shift left ecx by 2, ecx=4*n

   mov  dword ptr [ebp-16], 0
   mov  dword ptr [ebp-12], 0
   mov  dword ptr [ebp-8], 0
   mov  dword ptr [ebp-4], 0

   movdqu xmm1, [ebp-16]     # xmm1 contains 4 integers, each integer will store a partial sum. initialize to zeros
   
   mov ebx, [ebp+8]     # ebx iterates over the integer array (arr+0, arr+4*4, arr+8*4, ...)
   add ecx, [ebp+8]     # now ecx contains the after-last address of the array (will be used to stop the loop)

   mov dword ptr [ecx], 0
   mov dword ptr [ecx+4], 0
   mov dword ptr [ecx+8], 0
   
comp_loop:

   # printf changes sse-registers (xmm0-xmm3), so do not try to printf here for debugging

   movdqa xmm0, [ebx]  # move 4 integers from arr to xmm0. use aligned move for better performance
   paddd xmm1, xmm0    # add these 4 integers to the partial sums in xmm1
   
   add ebx, 16         # go to the next 4 integers

   cmp ecx, ebx        # compare ecx and ebx
   ja comp_loop        # ja = jump if above: goto input_loop only if ecx > ebx
   
   # extract and sum the resulting 4 integers in xmm1 ----------------------------------

   movdqu [ebp-16], xmm1
   
   mov eax, [%ebp-16]
   add eax, [%ebp-12]
   add eax, [%ebp-8]
   add eax, [%ebp-4]

   #--------------------------------------------------------------------------------------------

   pop ebx
   pop esi
   pop edi
   
   mov esp, ebp
   pop ebp
   
   ret

#------------------------------------------------------------------------------------------------------

.globl _main          # make _main accessible from external

_main:                # the label indicating the start of the program

   # get the number of integers from the user -------------------------------------------

   push OFFSET n           # push to stack the second parameter to scanf (the address of the integer variable n)
   push OFFSET input       # push to stack the first parameter to scanf
   call _scanf      # call scanf, it will use the two parameters on the top of the stack in the reverse order
   add esp, 8       # pop the above two parameters from the stack (the esp register keeps track of the stack top, 8=2*4 bytes popped as param was 4 bytes)

   # get the n integers from the user ---------------------------------------------------

   mov ecx, 0      # ecx iterates over the integer array (0,1,...,n-1)
   mov ebx, OFFSET arr  # ebx iterates over the integer array (0,4,8, ...)
   
input_loop:
   
   push ecx         # push to stack ecx because _scanf may change it
   push ebx         # push to stack ebx because _scanf may change it

   push ebx         # push to stack the second parameter to scanf
   push OFFSET input       # push to stack the first parameter to scanf
   call _scanf      # call scanf, it will use the two parameters on the top of the stack in the reverse order
   add esp, 8       # pop the above two parameters from the stack
   
   pop ebx          # pop ebx
   pop ecx          # pop ecx

   add ebx, 4
   add ecx, 1
   
   cmp n, ecx       # compare ecx and n and update some status flags that will be used by ja below
   ja input_loop    # ja = jump if above: goto input_loop only if n > ecx

   # sum the n integers -----------------------------------------------------------------

   push n            # push to stack the second parameter to SumIntegers
   push OFFSET arr   # push to stack the first parameter to SumIntegers
   call _SumIntegers
   add esp, 8       # pop the above two parameters from the stack

   # print the sum of integers ---------------------------------------------------------

   push eax         # push to stack the second parameter to printf
   push OFFSET outsum      # push to stack the first parameter to printf
   call _printf     # call printf
   add esp, 8       # pop the two parameters

   ret              # end the main function
   
#------------------------------------------------------------------------------------------------------

#.type SumIntegers, @function  # this line is needed for linux

