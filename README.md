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

### M Type Instructions
The following table contains the detailed information of each M type instructions. Note that “aaaa” encodes the 4 bit address of data memory, and the “d” bit means destination of the result, i.e. if d = 1, result is written to Acc, otherwise the result is written to the same memory location as the operand.

|Instruction Mnemonics|Function|Encoding (Binary)|Status Affected|
|:-------------------:|:------:|:---------------:|:-------------:|
|ADD|Add a memory entry with accumulator|001d_0000_aaaa|Z, C, S, O|
|SUBAM|Subtract accumulator by a memory entry|001d_0001_aaaa|Z, C, S, O|
|MOVAM|Move the value of accumulator to a memory entry|0010_0010_aaaa|None|
|MOVMA|Move the value of a memory entry to accumulator|0011_0011_aaaa|None|
|AND|Bitwise AND a memory entry with accumulator|001d_0100_aaaa|Z|
|OR|Bitwise OR a memory entry with accumulator|001d_0101_aaaa|Z|
|XOR|Bitwise XOR a memory entry with accumulator|001d_0110_aaaa|Z|
|SUBMA|Subtract a memory entry by accumulator|001d_0111_aaaa|Z, C, S, O|
|INC|Increment a memory entry|0010_1000_aaaa|Z, C, S, O|
|DEC|Decrement a memory entry|0010_1000_aaaa|Z, C, S, O|
|ROTATEL|Circulate shift left a memory entry by number of bits specified by accumulator|0010_1010_aaaa|None|
|ROTATER|Circulate shift right a memory entry by number of bits specified by accumulator|0010_1011_aaaa|None|
|SLL|Shift a memory entry left (fill 0) by number of bits specified by accumulator|0010_1100_aaaa|Z, C|
|SRL|Shift a memory entry right (fill 0) by number of bits specified by accumulator|0010_1100_aaaa|Z, C|
|SRA|shift a memory entry right arithmetically (fill original MSB) by number of bits specified by accumulator|0010_1110_aaaa|Z, C, S|
|COMP|Take 2's complement of a memory entry|0010_1111_aaaa|Z, C, S, O|

### I Type Instructions
The following table contains the detailed information of each I type instructions.

|Instruction Mnemonics|Function|Encoding (Binary)|Status Affected|
|:-------------------:|:------:|:---------------:|:-------------:|
|GOTO|Unconditional Branch|0001_xxxx_xxxx|None|
|JZ|Jump to instruction indexed by immediate number, if Z flag is 1|0100_xxxx_xxxx|None|
|JC|Jump to instruction indexed by immediate number, if C flag is 1|0101_xxxx_xxxx|None|
|JS|Jump to instruction indexed by immediate number, if S flag is 1|0110_xxxx_xxxx|None|
|JO|Jump to instruction indexed by immediate number, if O flag is 1|0111_xxxx_xxxx|None|
|ADDI|Add accumulator with immediate number|1000_xxxx_xxxx|Z, C, S, O|
|SUBAI|Subtract accumulator with immediate number|1001_xxxx_xxxx|Z, C, S, O|
|RSV|Do Nothing (It moves the value of accumulator to itself)|1010_xxxx_xxxx|None|
|MOVIA|Move immediate number to accumulator|1011_xxxx_xxxx|None|
|ANDI|Bitwise AND accumulator with immediate number|1100_xxxx_xxxx|Z|
|ORI|Bitwise OR accumulator with immediate number|1101_xxxx_xxxx|Z|
|XORI|Bitwise XOR accumulator with immediate number|1110_xxxx_xxxx|Z|
|SUBIA|Subtract accumulator by immediate number|1111_xxxx_xxxx|Z, C, S, O|

### S Type Instruction
The only S type instruction is shown as following
|Instruction Mnemonics|Function|Encoding (Binary)|Status Affected|
|:-------------------:|:------:|:---------------:|:-------------:|
|NOP|No Operation|0000_0000_0000|None|

The program cam be found at https://www.edaplayground.com/x/XV23












