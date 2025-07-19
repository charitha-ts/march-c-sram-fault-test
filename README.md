# march-c-sram-fault-test
SystemVerilog implementation of March C and March X memory test algorithms for detecting stuck-at, transition, and coupling faults in SRAM. 

# 📁 Files
- `mem.sv`: SRAM module with per-bit mask
- `mem_tb.sv`: Testbench for March C, includes fault injection

# SRAM module
The mem.sv module implements a 64x8 single-port synchronous SRAM with bitwise write masking. On each rising clock edge:
If write enable (we) is active, only the bits selected by we_mask are updated.
The output data_out always reflects the current memory contents at the selected address.

# March C SRAM Testbench 
mem_tb.sv implements a fault-injection testbench for SRAM module (mem.sv) along with the March C- algorithm in SystemVerilog. It simulates stuck-at ,transition faults and coupling faults, providing insight into memory reliability and DFT techniques.

## 📜 March C Sequence
↑ Write 0 to all
↑ Read 0, Write 1
↑ Read 1, Write 0
↓ Read 0, Write 1
↓ Read 1, Write 0
↓ Read 0

## 🧪 Faults Injected 
- `mem[60][3]`= stuck-at-0
- `mem[10][2]` = stuck-at-1
- `mem[15][5]`= up -transition fault
- `mem[25][5]` = down -transition fault
- `mem[20][6]` and `mem[33][7]` = coupling fault

## 🖥️ Tools
- Language: SystemVerilog
- Simulator: ModelSim / Questa
