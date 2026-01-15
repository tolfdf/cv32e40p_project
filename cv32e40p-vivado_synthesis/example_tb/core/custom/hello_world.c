#include <stdint.h>

// UART base address
#define UART_TX_BASE   0x10000000
#define UART_STATUS    0x10000004  // optional: FIFO ready flag if available

// pointers to UART registers
volatile uint8_t *UART_TX   = (uint8_t *)UART_TX_BASE;
volatile uint32_t *UART_STAT = (uint32_t *)UART_STATUS; // optional

// simple blocking write for UART
static void uart_write(char c)
{
    // optional: wait for FIFO not full
    /*
    while (!(*UART_STAT & 0x1)) {
        // wait until FIFO has space
    }
    */

    *UART_TX = (uint8_t)c;

    // small delay to allow FIFO / TX shift register to accept the character
    for (volatile int i = 0; i < 500; i++) {
        asm volatile("nop");
    }
}

int main(void)
{
    const char *msg = "hello world\n";

    // send each character
    while (*msg) {
        uart_write(*msg++);
    }

    // keep CPU alive forever so UART can finish
    while (1) {
        asm volatile("nop"); // or wfi if supported
    }
}
