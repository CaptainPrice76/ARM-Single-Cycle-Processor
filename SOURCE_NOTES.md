# Source organization notes

This repository uses the original modular RTL source tree as its primary implementation. The former single-file consolidated RTL is intentionally not included, to avoid presenting two competing implementations.

## Small integration repairs made for this repository

- Added the `flopenr` enabled, resettable register module required by `conditional_logic.sv`; it was instantiated by the original modular source but was not present as a module in that source tree.
- Moved the parameterized `adder` definition out of `flopr.v` into its own `adder.sv` file. The original `adder.v` file was empty, while the adder implementation was appended to `flopr.v`.
- Corrected the `for` loop syntax in `memory_and_top.sv`.
- Updated the `$readmemh` path to `program/memfile.dat`; run simulations from the repository root.
- Renamed source files to `.sv` to reflect their SystemVerilog constructs.

These are source-level integration fixes, not a claim of full verification. The supplied waveform is retained as an existing simulation artifact. Please run the testbench in Vivado or another SystemVerilog simulator before relying on the design or publishing a claim that the packaged sources reproduce the waveform.
