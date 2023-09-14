# RV32-BM
A bare metal system for the 32-bit RISC-V processor using the Longan Nano development board (GD32VF103).

## Environment and Tools
### Toolchain
[riscv-collab/riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain)

According to the instructions, configure and compile the GCC toolchain and integrate it into the environment.
Ensure that the toolchain supports rv32imac/ilp32 with the following specifications: `@march=rv32imac` and `@mabi=ilp32`.

```bash
$ riscv64-unknown-elf-gcc -print-multi-lib
.;
rv32i/ilp32;@march=rv32i@mabi=ilp32
rv32im/ilp32;@march=rv32im@mabi=ilp32
rv32iac/ilp32;@march=rv32iac@mabi=ilp32
rv32imac/ilp32;@march=rv32imac@mabi=ilp32
rv32imafc/ilp32f;@march=rv32imafc@mabi=ilp32f
rv64imac/lp64;@march=rv64imac@mabi=lp64
rv64imafdc/lp64d;@march=rv64imafdc@mabi=lp64d
```

### Debug Tools
1. Use [GD32_MCU_Dfu_Tool](https://e-iot.info/e-iot-platform-hardware-software-manual/chapter-t-04.html)
2. Use JTAG debugger with OpenOCD.
    - [RV-Link](https://longan.sipeed.com/en/get_started/rv-link.html) / Jlink / FT2232H module / ...

## Specification Reference
- RISC-V spec.
    - [Volume 1, Unprivileged Specification version 20191213](https://riscv.org/technical/specifications/)
    - [Volume 2, Privileged Specification version 20211203](https://riscv.org/technical/specifications/)
- Core IP spec.
    - [Nuclei Bumblebee Core - N200](https://www.nucleisys.com/product/rvipes/n200/) (RISC-V ISA v2.2 RV32IMAC)
- Chip spec.
    - [GigaDevice GD32VF103 RISC-V 32-bit MCU Datasheet](https://www.gigadevice.com.cn/Public/Uploads/uploadfile/files/20230228/GD32VF103_Datasheet_Rev1.7.pdf)
    - [GigaDevice GD32VF103 RISC-V 32-bit MCU User Manual](https://www.gigadevice.com.cn/Public/Uploads/uploadfile/files/20230209/GD32VF103_User_Manual_EN_Rev1.4.pdf)
        - RISC-V little-endian RV32IMAC (with 32GPRs).
        - 2-stage pipeline.
        - Support Machine (M) / User (U) privilege level.
- Development Board spec.
    - [Longan Nano document](https://longan.sipeed.com/en/)
    - [Longan Nano schematic](https://doc.nucleisys.com/nuclei_sdk/_images/sipeed_longan_nano_schematic.png)
