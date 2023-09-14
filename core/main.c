#include <stdint.h>
#include "reg.h"

__attribute__((optimize("O0"))) void delay_ms(uint32_t ms)
{
    uint32_t i, tick = ms * (1000);
    for (i = 0; i < tick; i++) {
        __asm__("nop");
    }
}

int main(void)
{
    // Enable the GPIOA and GPIOC peripherals.
    RCU_APB2EN |= (1 << RCU_APB2EN_PAEN) | (1 << RCU_APB2EN_PCEN);

    // Configure PA1, PA2 as low-speed push-pull outputs.
    GPIOA_CRL &=
        ~(GPIO_CRL_MODE1 | GPIO_CRL_CNF1 | GPIO_CRL_MODE2 | GPIO_CRL_CNF2);
    GPIOA_CRL |= (0x2 << 4 | 0x2 << 8);

    // Configure PC13 as low-speed push-pull outputs.
    GPIOC_CRH &= ~(GPIO_CRH_MODE13 | GPIO_CRH_CNF13);
    GPIOC_CRH |= (0x2 << 20);

    // Turn all LEDs OFF.
    GPIOA_ODR |= (0x1 << 1 | 0x1 << 2);
    GPIOC_ODR |= (0x1 << 13);

    while (1) {
        // Green ON.
        GPIOA_ODR &= ~(0x1 << 1);
        delay_ms(100);
        // Green OFF.
        GPIOA_ODR |= (0x1 << 1);
        delay_ms(100);

        // Blue ON.
        GPIOA_ODR &= ~(0x1 << 2);
        delay_ms(100);
        // Blue OFF.
        GPIOA_ODR |= (0x1 << 2);
        delay_ms(100);

        // Red ON.
        GPIOC_ODR &= ~(0x1 << 13);
        delay_ms(100);
        // Red OFF.
        GPIOC_ODR |= (0x1 << 13);
        delay_ms(100);
    }
    return 0;
}
