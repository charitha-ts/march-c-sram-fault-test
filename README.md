# 🧠 March-C SRAM Fault Test

SystemVerilog implementation of **March C** and **March X** memory test algorithms for detecting **stuck-at**, **transition**, and **coupling faults** in SRAM.

---

## 📁 Files
- `mem.sv` — SRAM module with per-bit write mask
- `mem_tb.sv` — Testbench implementing March C algorithm with fault injection

---

## 🔧 SRAM Module (`mem.sv`)

The `mem.sv` module implements a **64×8 single-port synchronous SRAM** with **bitwise write masking**.  
On each rising clock edge:
- If write enable (`we`) is active, only the bits selected by `we_mask` are updated.
- The output `data_out` always reflects the current memory contents at the selected address, even during writes.

---

## 🧪 March C SRAM Testbench (`mem_tb.sv`)

The `mem_tb.sv` testbench applies the **March C** algorithm to the SRAM module and injects controlled faults using `force`/`release`.  
It simulates:
- **Stuck-at faults**
- **Up/down transition faults**
- **Coupling faults**  
This testbench provides a comprehensive memory reliability analysis and demonstrates techniques relevant to **DFT and memory BIST**.

---

## 📜 March C Sequence
↑ Write 0 to all
↑ Read 0, Write 1
↑ Read 1, Write 0
↓ Read 0, Write 1
↓ Read 1, Write 0
↓ Read 0

---

## 🧪 Faults Injected 
- `mem[60][3]`= stuck-at-0
- `mem[10][2]` = stuck-at-1
- `mem[15][5]`= up -transition fault
- `mem[25][5]` = down -transition fault
- `mem[20][6]` and `mem[33][7]` = coupling fault

---

## 🖥️ Tools
- Language: SystemVerilog
- Simulator: ModelSim / Questa
