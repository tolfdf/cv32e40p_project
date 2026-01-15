/* Minimal syscalls for bare-metal CV32E40P
 * No OS, no filesystem, no libc.
 */

#include <stddef.h>
#include <stdint.h>

/* Missing libc typedefs (because -nostdlib is used) */
typedef long ssize_t;
typedef long off_t;

/* UART + exit registers */
#define STDOUT_REG 0x10000000
#define EXIT_REG   0x20000004

/* ------------------------------------------
   UART PRINT FUNCTION (used by vectors.S)
------------------------------------------ */
void putstr(const char *s)
{
    while (*s)
        *(volatile uint32_t *)STDOUT_REG = *s++;
}

/* ------------------------------------------
   SYSTEM CALL STUBS (minimal required by GCC)
------------------------------------------ */

int _close(int file) { return -1; }
int _isatty(int file) { return 1; }

/* minimal stat struct */
struct stat {
    unsigned long st_mode;
};

int _fstat(int file, struct stat *st)
{
    st->st_mode = 0x2000;   /* S_IFCHR */
    return 0;
}

off_t _lseek(int file, off_t ptr, int dir)
{
    return 0;
}

ssize_t _read(int file, void *ptr, size_t len)
{
    return 0;   /* no input */
}

/* ------------------------------------------
   UART WRITE (used by printf-like output)
------------------------------------------ */
ssize_t _write(int file, const void *ptr, size_t len)
{
    const uint8_t *p = (const uint8_t *)ptr;

    for (size_t i = 0; i < len; i++)
        *(volatile uint32_t *)STDOUT_REG = p[i];

    return len;
}

/* ------------------------------------------
   EXIT FUNCTION (called when main returns)
------------------------------------------ */
void _exit(int status)
{
    *(volatile uint32_t *)EXIT_REG = status;

    while (1)
        __asm__ volatile ("wfi");
}

/* ------------------------------------------
   SIMPLE SBRK (heap)
------------------------------------------ */
extern char __heap_start[];
extern char __heap_end[];

static char *brk = __heap_start;

void * _sbrk(ptrdiff_t incr)
{
    char *old = brk;
    char *new_brk = brk + incr;

    if (new_brk >= __heap_end)
        return (void *) -1;

    brk = new_brk;
    return old;
}
