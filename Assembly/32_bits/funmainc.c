// To download gcc on windows:
// download mingw (and make sure gcc is chosen while installation) from: 
// mingw-get-setup.exe at the site https://osdn.net/projects/mingw/
// then append c:\mingw\bin; to the start of the PATH environment variable from control panel

// To compile this assembly program on windows:
// gcc -O3 -m32 -o funmainc.exe funmainc.c fun.s
// After running the program, enter a positive integer (n<=100) and then enter n integers then press enter

// ------------------------------------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>

int SumIntegers(int*, int);

int main()
{
    int i, n=7;
    int* olda=malloc(n*sizeof(int)+3*sizeof(int)+15*sizeof(int));
    int* a=(int*)((((int)olda)+15)&(~15));
    
    //printf("%d %d\n", (int)olda, (int)a); fflush(stdout);
    
    for(i=0;i<n;i++) a[i]=i+1;
    
    int x=SumIntegers(a, n);
    printf("Sum=%d\n", x); fflush(stdout);
    
    free(olda);
    return 0;
}

// ------------------------------------------------------------------------------------------------------
