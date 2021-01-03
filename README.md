# CPU Using Verilog HDL
In this project, Verilog code for a microcontroller is presented.

## Instruction Set Architecture
Each instruction is 12 bits. There are 3 types of instructions by encoding, shown as following:
1. M type: one operand is accumulator (sometimes ignored) and the other operand is from data memory; the result can be stored into accumulator or the data memory entry (same entry as the second operand).
2. I type: one operand is accumulator and the other operand is immediate number encoded in instruction; the result is stored into accumulator. 
3. S type: special instruction, no operand required. (e.g. NOP)

The instruction encoding is shown in the following table
|Code space (binary)|Code space (Hex)|Type|Number of Instructions|Note|
|:-----------------:|:--------------:|:--:|:--------------------:|:--:|
|0000_0000_0000 - 0000_1111_1111|000-0FF|Special instructions  (S type)|256|Currently only NOP used,255 free slots|
|0001_0000_0000 - 0001_1111_1111|100-1FF|Unconditional jump (I type)|1|GOTO|
|0010_0000_0000 - 0011_1111_1111|200-3FF|ALU instructions (M type)|32|16 instructions, 2 destination choices|
|0100_0000_0000 - 0111_1111_1111|400-7FF|Conditional jump (I type)|4|JZ,JC,JS,JO|
|1000_0000_0000 - 1111_1111_1111|800-FFF|ALU instructions (I type)|8|Currently 7 used, 1 free slot|
