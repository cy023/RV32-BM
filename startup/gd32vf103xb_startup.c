#include <stdint.h>

extern uint32_t _data_start;
extern uint32_t _data_end;
extern uint32_t _data_load;
extern uint32_t _bss_start;
extern uint32_t _bss_end;
extern uint32_t _heap_start;
extern uint32_t _stack_end;
extern uint32_t _global_pointer;
extern uint32_t _start_vectors;

extern int main(void);

/**
 * @brief Copy initialized data from .sidata (Flash) to .data (RAM)
 */
void copy_data_section(void)
{
    uint8_t *src = (uint8_t *) &_data_load;
    uint8_t *des = (uint8_t *) &_data_start;
    while (des < (uint8_t *) &_data_end) {
        *des++ = *src++;
    }
}

/**
 * @brief Clear the .bss RAM section.
 */
void clear_bss_section(void)
{
    uint8_t *src = (uint8_t *) &_bss_start;
    while (src < (uint8_t *) &_bss_end) {
        *src++ = 0;
    }
}

/**
 * @brief The entry point after Hardware reset.
 *
 * Initialize .data and .bss sections and then start main().
 */
__attribute__((section(".reset"), naked)) void Reset_Handler(void)
{
    // Disable interrupts handler.
    asm volatile("csrc mstatus, 0x00000008");  // 0x8: MIE flag.

    // Setup global pointer and stack.
    asm volatile("la gp, _global_pointer");

    // Load the initial stack pointer value.
    asm volatile("la sp, _stack_end");

    // TODO: Set up vectored interrupt table.

    // Copy initialized data from Flash to RAM.
    copy_data_section();

    // Clear the .bss section in RAM.
    clear_bss_section();

    main();

    while (1)
        ;
}
