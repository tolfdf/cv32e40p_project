/* ============================
 * Minimal Bare-Metal crt0.S
 * ============================
 */

.section .text.start
.global _start
.type _start, @function

_start:

    /* initialize global pointer */
    .option push
    .option norelax
1:  auipc gp, %pcrel_hi(__global_pointer$)
    addi  gp, gp, %pcrel_lo(1b)
    .option pop

    /* initialize stack pointer */
    la sp, _sp

    /* set vector table address and vectored mode */
    la a0, __vector_start
    ori a0, a0, 1
    csrw mtvec, a0

    /* clear .bss */
    la a0, __bss_start
    la a1, __bss_end
bss_clear:
    bge a0, a1, bss_done
    sw zero, 0(a0)
    addi a0, a0, 4
    j bss_clear
bss_done:

    /* call main() */
    li a0, 0          /* argc = 0 */
    li a1, 0          /* argv = NULL */
    call main

    /* call custom _exit from syscalls.c */
    call _exit

.size _start, .-_start
