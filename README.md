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

## Execution Flow

Each instruction takes multiple clock cycles to finish execution:

1. **Fetch:** `PC` addresses `instruction_memory.v`, and the instruction is loaded into the `instruction_register`.
2. **Decode:** `decoder.v` splits the instruction into `opcode` and register select signals.
3. **Execute:** `alu.v` performs the required operation on source register values.
4. **Writeback:** Results are written back into the target register inside `register_file.v`, and `PC` increments for the next instruction.

---

## How to Run the Simulation

Make sure you have **Icarus Verilog** (`iverilog`) and **GTKWave** installed.

### 1. Compile and Simulate
Run the following in your terminal from the project root:

```bash
# Compile source files and testbench
iverilog -o cpu_tb.vvp cpu_tb.v alu.v control_unit.v cpu.v decoder.v instruction_memory.v instruction_register.v program_counter.v register_file.v

# Run simulation to produce the VCD waveform file
vvp cpu_tb.vvp
