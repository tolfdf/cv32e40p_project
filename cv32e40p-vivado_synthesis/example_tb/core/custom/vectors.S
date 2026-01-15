/* ============================
 * Minimal Interrupt/Trap Vectors
 * ============================
 */

.section .text.vecs
.global __vector_start
.global __no_irq_handler

__vector_start:

    j handle_exception     /* 0: synchronous exceptions */
    j __no_irq_handler     /* 1: reserved */
    j __no_irq_handler     /* 2 */
    j __no_irq_handler     /* 3 */
    j __no_irq_handler     /* 4 */
    j __no_irq_handler     /* 5 */
    j __no_irq_handler     /* 6 */
    j __no_irq_handler     /* 7 */

__no_irq_handler:
    la a0, msg_noirq
    call putstr
    j .

handle_exception:
    la a0, msg_exception
    call putstr
    j .

/* Messages */
.section .rodata
msg_noirq:
    .asciz "Unhandled IRQ\n"
msg_exception:
    .asciz "Exception occurred\n"
