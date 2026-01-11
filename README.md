
# APB-Based SPI Project – UVM Verification

---

## 1.Project Description (Design + Verification)

### APB-Based SPI Controller – RTL Design & UVM Verification

This project implements a **Serial Peripheral Interface (SPI) Controller integrated with an AMBA APB (Advanced Peripheral Bus) slave interface**. It enables a processor or host to communicate with SPI-based peripherals using memory-mapped register access.

The project demonstrates a **complete IP development and verification flow**, including:

* Verilog RTL design
* SystemVerilog UVM-based verification
* Register Abstraction Layer (RAL)
* Functional, code, and assertion coverage closure
* Linting and synthesis validation

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
   |  | slave controller      |  |
   |  -------------------------  |
   +-----------------------------+
           |
   SPI Signals --> MOSI | MISO | SCLK | SS
```

## 🛠 Tools & Technologies

| Purpose | Tools Used |
|---------|------------|
| RTL Coding | Verilog HDL |
| Simulation | Xilinx ISE / QuestaSim / VCS simulator|
| Linting | Synopsys VCS spyglass |
| Synthesis | Synopsys Design Compiler |
| coverage anlaysis | VCS verdi / Questasim |

---

## 2. Key Features 

| Feature                    | Description                                    |
| -------------------------- | ---------------------------------------------- |
| APB Slave Interface        | Processor-style register read/write access     |
| SPI Mode Support           | CPOL & CPHA configurable (Modes 0–3)           |
| Master / Slave Support     | Configurable SPI operation                     |
| Programmable SCLK          | Baud rate derived from divider registers       |
| Interrupt Support          | Interrupts based on transmit/receive events    |
| Modular RTL Design         | Clean separation of APB, SPI, and clock logic  |
| **UVM-Based Verification** | Reusable, scalable SystemVerilog UVM testbench |
| **RAL Model**              | Register abstraction with frontdoor APB access |
| **Coverage Closure**       | 100% Functional, 100% Code & Assertion coverage |

---


## 3. Verification Folder Structure (UVM)

```
APB_based_SPI_Project/
│
|   ├── rtl/
│      ├── spi_core.v         //core DUT
│      ├── baud_generator.v
│      ├── spi_slave_select.v
│      ├── shifter.v
│      ├── apb_slave.v
│      ├── apb_intf.sv
│      ├── spi_intf.sv
│      ├── apb_defs.v
│      └── timescale.v
│
│   ├── test/         //test class
│      ├── test_lib.sv        
│      └── spi_pkg.sv           
│   
│   ├── apb_control/         //apb agent
│      ├── apb_xtn.sv
│      ├── apb_config.sv         
│      ├── apb_seqs.sv
│      ├── apb_driver.sv
│      ├── apb_monitor.sv
│      ├── apb_sequencer.sv
│      └── apb_agent.sv
│      └── apb_agent_top.sv│
│   
│   ├── spi_control/         //spi agent
│      ├── spi_xtn.sv
│      ├── spi_config.sv         
│      ├── spi_seqs.sv
│      ├── spi_driver.sv
│      ├── spi_monitor.sv
│      ├── spi_sequencer.sv
│      └── spi_agent.sv
│      └── spi_agent_top.sv│
│   
│   ├── tb/                  //environment
│      ├── env_config.sv
│      ├── virtual_sequence.sv
│      ├── virtual_sequencer.sv
│      ├── scoreboard.sv
│      └── environment.sv
│      └── top.sv
│   
│   ├── ral_control/            // RAL model
│      ├── spi_registers.sv     
│      └── spi_registers_block.sv
│   
│   └── sim/
│       ├── Makefile          //all related simulation files
│
├── docs/
│   ├── block_diagram.png
│   ├── register_map.pdf
│   └── coverage_results.png
│
├── README.md
└── LICENSE


      rtl2 is logically same as rtl but code is different...
```

---

## 4. UVM Verification Environment – Block Diagram

```
                           +----------------------+
                           |      UVM Test        |
                           |  (apb_spi_test)     |
                           +----------+-----------+
                                      |
                                      v
                           +----------------------+
                           |   UVM Environment    |
                           |  (apb_spi_env)       |
                           +----------+-----------+
                                      |
        ----------------------------------------------------------------
        |                              |                               |
        v                              v                               v
+-------------------+        +-------------------+          +----------------------+
|   APB Agent       |        |    SPI Agent      |          |     Scoreboard       |
|                   |        |                   |          |                      |
| +---------------+ |        | +---------------+ |          |  APB vs SPI Data     |
| | APB Sequencer | |        | | SPI Sequencer | |          |  Comparison          |
| +-------+-------+ |        | +-------+-------+ |          |                      |
|         |         |        |         |         |          +----------------------+
| +-------v-------+ |        | +-------v-------+ |
| | APB Driver    | |        | | SPI Driver    | |
| +-------+-------+ |        | +-------+-------+ |
|         |         |        |         |         |
| +-------v-------+ |        | +-------v-------+ |
| | APB Monitor   | |        | | SPI Monitor   | |
| +-------+-------+ |        | +-------+-------+ |
+---------|---------+        +---------|---------+
          |                            |
          |                            |
          v                            v
   +-------------+              +-------------+
   |   APB IF    |              |   SPI IF    |
   +------+------+              +------+------+
          |                            |
          v                            v
   +-------------------------------------------+
   |              DUT (APB SPI)                |
   |                                           |
   |  APB Interface | SPI Core | Clock Gen     |
   +-------------------------------------------+

        ------------------------------------------------------------
        |                                                          |
        v                                                          v
+----------------------+                              +----------------------+
|   RAL (Reg Model)    |                              | Functional Coverage  |
|  (apb_spi_reg_block)|                              |  & Assertions        |
+----------------------+                              +----------------------+
```

---

## 5. Coverage Summary

| Coverage Type       | Achieved |
| ------------------- | -------- |
| Functional Coverage | 100%     |
| Code Coverage       | 100%     |
| Assertion Coverage  | 100%     |

---

```
## 🧪 Verification

The APB-based SPI controller is verified using a SystemVerilog UVM testbench. The environment includes APB and SPI agents, RAL-based register modeling, scoreboarding, functional coverage, and protocol assertions. High coverage closure ensures correctness across normal, corner, and error scenarios. Regarding to testplan and the verification plan those are included in docs folder
```

---

**Author:** --->  MaheswarReddy-21

If you like this project or want to collaborate — feel free to connect!


