#ifndef _REG_H_
#define _REG_H_

#define __REG_TYPE volatile uint32_t
#define __REG      __REG_TYPE *

/* BUS Memory Map */
#define AHB1_BUS_BASE ((__REG_TYPE) 0x40018000UL)
#define APB2_BUS_BASE ((__REG_TYPE) 0x40010000UL)

/* RCC Memory Map */
#define RCU_BASE   ((__REG_TYPE) (AHB1_BUS_BASE + 0x00009000UL))
#define RCU_APB2EN (*(__REG) (RCU_BASE + 0x18UL))

#define RCU_APB2EN_PAEN (2)
#define RCU_APB2EN_PCEN (4)

/* GPIO Memory Map */
#define GPIO_BASE  ((__REG_TYPE) (APB2_BUS_BASE + 0x00000800UL))
#define GPIOA_BASE ((__REG_TYPE) (GPIO_BASE + 0x00000000UL))
#define GPIOC_BASE ((__REG_TYPE) (GPIO_BASE + 0x00000800UL))
#define GPIOA_CRL  (*(__REG) (GPIOA_BASE + 0x00UL))
#define GPIOA_CRH  (*(__REG) (GPIOA_BASE + 0x04UL))
#define GPIOA_ODR  (*(__REG) (GPIOA_BASE + 0x0CUL))
#define GPIOC_CRL  (*(__REG) (GPIOC_BASE + 0x00UL))
#define GPIOC_CRH  (*(__REG) (GPIOC_BASE + 0x04UL))
#define GPIOC_ODR  (*(__REG) (GPIOC_BASE + 0x0CUL))

#define GPIO_CRL_MODE1  (0x3UL << 4)
#define GPIO_CRL_MODE2  (0x3UL << 8)
#define GPIO_CRH_MODE13 (0x3UL << 20)

#define GPIO_CRL_CNF1  (0x3UL << 6)
#define GPIO_CRL_CNF2  (0x3UL << 10)
#define GPIO_CRH_CNF13 (0x3UL << 22)

#endif
