volatile unsigned int *UART = (unsigned int *)0x10000000;

int main() {
    const char *s = "hello world\n";
    while (*s) {
        *UART = *s++;
    }

    // tell TB we’re done
    *((volatile int *)0x20000004) = 0;
    while (1);       
}
