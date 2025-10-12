# APB_based_SPI_Project
This project implements SPI Controller integrated with an AMBA APB slave interface. It enables a processor or host to communicate with SPI-based peripherals.  Designed using Verilog RTL, verified through simulation, and validated using linting and synthesis flows, this project demonstrates end-to-end digital IP development.
# APB-Based SPI Protocol – RTL Design & Verification

### 📌 Project Repository: `APB_based_SPI_Project`  
### 👤 Author: **MaheswarReddy-21**

---

## 📘 Overview

This project implements a **Serial Peripheral Interface (SPI) Controller** integrated with an **AMBA APB (Advanced Peripheral Bus) slave interface**.  
It enables a processor or host to communicate with SPI-based peripherals using **memory-mapped register access**.

Designed using **Verilog RTL**, verified through **simulation**, and validated using **linting and synthesis flows**, this project demonstrates **end-to-end digital IP development**.

---

## 🧱 Block Architecture

```
   +------------------+
   |   APB Master     |
   +------------------+
           |
      APB Bus (PSEL, PENABLE, PADDR, PWDATA...)
           |
   +-----------------------------+
   |    APB-Based SPI Controller |
   |  -------------------------  |
   |  | APB Interface FSM     |  |
   |  | Control Registers     |  |
   |  | Baud Rate Generator   |  |
   |  | SPI Core (FSM Logic)  |  |
   |  -------------------------  |
   +-----------------------------+
           |
   SPI Signals --> MOSI | MISO | SCLK | SS
```

---

## ✅ Key Features

| Feature | Description |
|---------|-------------|
| **APB Slave Interface** | Allows processor-style register read/write operations |
| **SPI Mode Support** | CPOL & CPHA configurable (Modes 0–3) |
| **Master/Slave Selectable** | Operates in both configurations |
| **Programmable Clock (SCLK)** | Baud rate derived from divider registers |
| **Interrupt Support** | Based on transmit/receive events |
| **Fully Modular RTL Design** | Clean separation of APB, SPI logic, and clock unit |

---

## 🛠 Tools & Technologies

| Purpose | Tools Used |
|---------|------------|
| RTL Coding | Verilog HDL |
| Simulation | Xilinx ISE / ModelSim |
| Linting | Synopsys VCS |
| Synthesis | Synopsys Design Compiler |

---


## 🚀 Future Enhancements

- Add **multi-byte buffer (FIFO) support**
- Extend to **full-duplex / half-duplex selector**
- Convert to **AXI4-Lite** compatible interface

---

## 📄 Author

**MaheswarReddy-21**

If you like this project or want to collaborate — feel free to connect!

