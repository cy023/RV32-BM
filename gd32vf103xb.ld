OUTPUT_ARCH("riscv")
ENTRY(Reset_Handler)

/**
 * Reference: 
 *  GigaDevice Semiconductor Inc.
    GD32VF103 RISC-V 32-bit MCU User Manual Revision 1.4
 *  Table 1-2. Memory map of GD32VF103 devices
 * 
 * 0x2000_8000 ----------------  ----------------- <--- `_stack_end`
 *             |              |  |     .stack    |
 *             |              |  -----------------
 *             |              |  |     .heap     |
 *             |  RAM (32KB)  |  ----------------- <--- `_bss_end` / `_end` / `_heap_start`
 *             |              |  |     .bss      |
 *             |              |  ----------------- <--- `_data_end` / `_bss_start`
 *             |              |  |     .data     |
 * 0x2000_0000 ----------------  ----------------- <--- `_text_end` / `_data_start`
 *             |              |  |               |
 *             |              |  |               |
 *             |              |  |               |
 *             | Flash (128KB)|  |     .text     |
 *             |              |  |               |
 *             |              |  |               |
 *             |              |  |               |
 * 0x0000_0000 ----------------  ----------------- <--- `_text_start`
 * 
 */

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 128K
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 32K
}

SECTIONS
{
    .text :
    {
        _text_start = .;
        KEEP(*(.reset))
        . = ALIGN(64);
        /* _start_vectors = .; */
        /* KEEP(*(.vector_table)) */
        *(.text*)
        *(.rodata*)
        *(.srodata*)
        . = ALIGN(4);
        _text_end = .;
    } >FLASH

    .data : AT(ADDR(.text) + SIZEOF(.text))
    {
        _data_start = .;
        *(.rdata*)
        *(.data*)
        *(.sdata*)
        _global_pointer = . + 0x400;
        . = ALIGN(4);
        _data_end = .;
    } >RAM

    .bss :
    {
        _bss_start = .;
        *(.sbss*)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _bss_end = .;
        _end = .;
    } >RAM

    PROVIDE(_heap_start = _end);
    PROVIDE(_stack_end = ORIGIN(RAM) + LENGTH(RAM));
    PROVIDE(_data_load = LOADADDR(.data));
}
