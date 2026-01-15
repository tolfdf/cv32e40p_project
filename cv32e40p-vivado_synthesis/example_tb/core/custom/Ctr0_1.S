.section .text.start
.globl _start
.type _start, @function

_start:
    /* set stack pointer */
    la sp, _sp

    /* set mtvec to vector base (optional but safe) */
    la t0, __vector_start
    csrw mtvec, t0

    /* jump to main */
    call main

1:  j 1b   /* never return */
