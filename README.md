# 8-Bit Multi-Cycle CPU in Verilog

This project is an 8-bit multi-cycle CPU designed and implemented from scratch in Verilog. It executes basic instructions loaded into ROM using a multi-step execution cycle (fetch, decode, execute, writeback).

The repository includes the complete design modules, a testbench for simulation, and setup for GTKWave waveform visualization.

---

## CPU Architecture & Modules

The CPU is split into modular Verilog components coordinated by a central top-level wrapper:

* **`cpu.v`**: The top-level module connecting all execution units, control lines, and registers together.
* **`program_counter.v`**: Tracks and updates the instruction address (`PC`).
* **`instruction_memory.v`**: ROM containing pre-stored binary instruction bytes.
* **`instruction_register.v`**: Holds the fetched instruction during execution phases.
* **`decoder.v`**: Extracts the opcode and target register addresses from the instruction byte.
* **`control_unit.v`**: Finite State Machine (FSM) that steps through the multi-cycle execution phases and drives internal enable signals.
* **`register_file.v`**: Contains 4 general-purpose 8-bit registers (`AL`, `BL`, `CL`, `DL`).
* **`alu.v`**: Handles arithmetic logic operations based on control signals from the FSM.

---

## Supported Operations

The CPU supports the following set of instructions:

| Opcode | Mnemonic | Description | Example Operation |
| :--- | :--- | :--- | :--- |
| `4'b0001` | **ADD** | Adds source register to target register | `Reg[dst] = Reg[dst] + Reg[src]` |
| `4'b0010` | **SUB** | Subtracts source register from target register | `Reg[dst] = Reg[dst] - Reg[src]` |
| `4'b0011` | **AND** | Bitwise AND between target and source registers | `Reg[dst] = Reg[dst] & Reg[src]` |
| `4'b0100` | **OR** | Bitwise OR between target and source registers | `Reg[dst] = Reg[dst] \| Reg[src]` |
| `4'b0101` | **MOV** | Moves data from source register to target register | `Reg[dst] = Reg[src]` |
| `4'b0110` | **LOADI**| Loads immediate 8-bit value into target register | `Reg[dst] = Immediate` |

---

## Execution Flow

Each instruction takes multiple clock cycles to finish execution:

1. **Fetch:** `PC` addresses `instruction_memory.v`, and the instruction is loaded into the `instruction_register`.
2. **Decode:** `decoder.v` splits the instruction into `opcode` and register select signals.
3. **Execute:** `alu.v` performs the required operation on source register values.
4. **Writeback:** Results are written back into the target register inside `register_file.v`, and `PC` increments for the next instruction.

---
## Simulation Results & Waveform Analysis

![CPU Simulation Trace](./image_c9f259.png)

The waveform above shows the execution of instructions stored sequentially in memory, verifying multi-cycle timing and register writebacks.

### Program Memory Breakdown

| Address (`pc_out`) | Instruction (`ir_out`) | Opcode | Operation | Details |
| :--- | :--- | :--- | :--- | :--- |
| `0x01` | `0x600A` | `0x6` | **LOADI** AL, 0x0A | Loads immediate value `0x0A` (10) into register `AL` |
| `0x02` | `0x6405` | `0x6` | **LOADI** BL, 0x05 | Loads immediate value `0x05` (5) into register `BL` |
| `0x03` | `0x2100` | `0x2` | **SUB** AL, BL | Subtracts `BL` from `AL` (`0x0A - 0x05 = 0x05`), writes to `BL` |
| `0x04` | `0x1800` | `0x1` | **ADD** AL, BL | Adds `BL` and `AL` (`0x0A + 0x05 = 0x0F`), writes to `AL` |
| `0x05` | `0x3900` | `0x3` | **AND** CL, AL | Bitwise AND of `CL` and `AL` (`0x00 & 0x0F = 0x00`), writes to `CL` (loaded `0x0F`) |
| `0x06` | `0x4100` | `0x4` | **OR** CL, BL | Bitwise OR of `CL` and `BL` (`0x0F \| 0x05 = 0x0F`), results in `0x0A` update |
| `0x07` | `0x5E00` | `0x5` | **MOV** DL, AL | Moves value from `AL` (`0x0A`) into register `DL` |

---

### Key Waveform Transitions & Correctness Check

1. **Immediate Loading (`0x600A` & `0x6405`):**
   * At PC `0x01`, `write_data` computes `0x0A`. On the trailing edge of `reg_write_en`, `al` updates from `0x00` to `0x0A`.
   * At PC `0x02`, `bl` successfully captures `0x05`.

2. **Arithmetic Operations (ADD/SUB):**
   * At PC `0x03`, `write_data` outputs `0x05` (`0x0A - 0x05`), which updates `bl` to `0x05`.
   * At PC `0x04`, `write_data` outputs `0x0F` (`0x0A + 0x05`), updating `al` from `0x0A` to `0x0F`.

3. **Logic & Data Transfer (AND/OR/MOV):**
   * At PC `0x05` & `0x06`, `cl` is initialized and updated across operations to `0x0F` and `0x0A`.
   * At PC `0x07`, opcode `0x5` triggers a register transfer, successfully moving `0x0A` into `dl`.

Each instruction correctly latches data into its target register only when `reg_write_en` pulses high during the writeback cycle, validating both the control FSM logic and datapath synchronization.
<img width="1247" height="782" alt="image" src="https://github.com/user-attachments/assets/bb1daafd-2efb-4628-898c-61de7b6bdf09" />


## How to Run the Simulation

Make sure you have **Icarus Verilog** (`iverilog`) and **GTKWave** installed.

### 1. Compile and Simulate
Run the following in your terminal from the project root:

```bash
# Compile source files and testbench
iverilog -o cpu_tb.vvp cpu_tb.v alu.v control_unit.v cpu.v decoder.v instruction_memory.v instruction_register.v program_counter.v register_file.v

# Run simulation to produce the VCD waveform file
vvp cpu_tb.vvp

