.intel_syntax noprefix  # use the intel syntax, not AT&T syntax. do not prefix registers with %

.section .data        # memory variables

input: .asciz "%d"    # string terminated by 0 that will be used for scanf parameter
output: .asciz "Your sum Equal= %f\n"     # string terminated by 0 that will be used for printf parameter

num: .int 0             # num which we will get from user using scanf
sum1: .double 0.0        # sum1=(1/1) + (1/4) + (1/9) + (1/16) + ... + (1/(n^2)). that will be calculated by the program and will be printed by printf
one: .double 1.0        #initialized to 1 to push it in stack
denominator: .double 1.0       #denominator to divide it


sum2: .double 0.0              #to sum2= 1 +2 +3+ ....+num
denominator2: .double 1.0       #denominator2 to divide it

.section .text        # instructions
.globl _main          # make _main accessible from external

_main:                # the label indicating the start of the program
   push OFFSET num      # push to stack the second parameter to scanf (the address of the integer variable num)
   push OFFSET input  # push to stack the first parameter to scanf
   call _scanf        # call scanf, it will use the two parameters on the top of the stack in the reverse order
   add esp, 8         # pop the above two parameters from the stack (the esp register keeps track of the stack top, 8=2*4 bytes popped as param was 4 bytes)
   
   mov ecx, num         # ecx <- num (the number of iterations)
loop1:
   # the following 4 instructions increase sum1 by 1/denominator
   fld qword ptr one            # push 1 to the floating point stack
   fdiv qword ptr denominator             # pop the floating point stack top (1), divide it over denominator and push the result (1/denominator)
   fdiv qword ptr denominator             # pop the floating point stack top (1/denominator), divide it over denominator and push the result (1/denominator*denominator)
   fadd qword ptr sum1             # pop the floating point stack top (1/denominator*denominator), add it to sum1, and push the result (sum1+(1/denominator*denominator))
   fstp qword ptr sum1             # pop the floating point stack top (sum1+(1/denominator*denominator)) into the memory variable sum1

   # the following 3 instructions increase denominator by 1   
   fld qword ptr denominator              # push 1 to the floating point stack
   fadd qword ptr one           # pop the floating point stack top (1), add it to denominator and push the result (denominator+1)
   fstp qword ptr denominator             # pop the floating point stack top (denominator+1) into the memory variable denominator
   loop loop1         # ecx -=1 , exit if ecx =0
mov ecx ,num 
loop2:
fld qword ptr denominator2                 # push 1 to the floating point stack
fadd qword ptr sum2                # pop the floating point stack top (1+denominator2), add it to sum1, and push the result (sum2+(1+denominator2))
fstp qword ptr sum2                # pop the floating point stack top (sum2+(1+denominator2)) into the memory variable sum2
 # the following 3 instructions increase denominator2 by 1   
   fld qword ptr denominator2              # push 1 to the floating point stack
   fadd qword ptr one           # pop the floating point stack top (1), add it to denominator2 and push the result (denominator2+1)
   fstp qword ptr denominator2             # pop the floating point stack top (denominator2+1) into the memory variable denominator2
loop loop2                      # ecx -=1 , exit if ecx =0
fld qword ptr sum2                #push sum2 to the floating point stack
fadd qword ptr sum1                #pop the floating point stack top (sum2), add it to sum1, and push the result (sum2+sum1))
fstp qword ptr sum1                #pop the floating point stack top  (sum2+sum1))into the memory variable sum1
   push [sum1+4]         # push to stack the high 32-bits of the second parameter to printf (the double at label sum1)
   push sum1             # push to stack the low 32-bits of the second parameter to printf (the double at label sum1)
   push OFFSET output # push to stack the first parameter to printf
   call _printf       # call printf
   add esp, 12        # pop the two parameters
   ret                # end the main function