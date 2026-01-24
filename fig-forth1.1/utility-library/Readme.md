# Utility library

These are words I wrote up to help me out. You may find them useful.

The APX Forth packages needed to use this library: The screen editor (starting at Screen 27), the assembler (starting at Screen 39), and the
floating-point library (starting at Screen 60). (It's compatible with my
[FP library](https://github.com/marktmiller/atari-8-bit-forth-projects/tree/main/fig-forth1.1/FP%20library), if desired.)

The following instructions executed with the APX Forth disk in your drive load these facilities into your dictionary:
```
27 LOAD
39 LOAD
60 LOAD
```

Words in this library:

| Word | Description |
| ---- | ----------- |
| TIME | Atari time value given as a floating-point number |
| ARRAY | 16-bit array structure |
| LB | Gives low-byte of 16-bit word |
| HB | Gives high-byte of 16-bit word |
| VAR | Alias for VARIABLE |
| CONST | Alias for CONSTANT |
| 1- | Decrements number at top of stack |
| ISQR | Integer square (n x n) |
| INC | Increments 16-bit value at address |
| DEC | Decrements 16-bit value at address |
| UPSCRS | Shifts range of screens up one screen |
| DSCRS | Shifts range of screens down one screen |
| MVLINES | Moves range of lines on screen(s) |
| CLS | Clears Gr. 0 text display |
| PLCUR | Places cursor after changing column, row |
| SVREG | Mnemonic for "poke" |
| 1-2SWAP | Does reverse of ROT |

## Illustrations
### ARRAY examples
`20 ARRAY SCORES` - Initializes a 16-bit array named SCORES of length 20

`5 2 SCORES !` - Stores 5 in the third cell of SCORES (zero-based indexing)

`2 SCORES @` - Retrieves value in the third cell of SCORES (zero-based indexing)

### LB, HB examples
`PTR LB PTR HB` - Gives low-byte and high-byte of pointer PTR as separate values

### INC, DEC examples
```
0 VAR COUNTER
COUNTER INC
```
Increments the value in COUNTER.
```
COUNTER DEC
```
Decrements the value in COUNTER.

### UPSCRS, DWNSCRS, MVLINES examples
The following three words access screens on disk.

`2 10 UPSCRS` - Moves contents of screens 2-10 to screens 3-11, and clears screen 2

`5 10 DSCRS` - Moves contents of screens 5-10 to screens 4-9, and clears screen 10

`3 9 12 4 2 MVLINES` - Moves lines 9-12 on Screen 3 to Screen 4, starting at Line 2, moving the contents of Screen 4's lines 2-15 down 4 lines.
(Lines moved past Line 15 are erased.)

### Notes
The TIME word accesses memory locations 18, 19, and 20 (decimal), and calculates the time value.

Re. the PLCUR word - The text cursor on the Atari normally does not move after a call to POS, until you print text. PLCUR will move the cursor
to the row and column you've set with POS, without printing text.

Re. the SVREG word - Normal Forth pointer dereferencing has you using the following syntax: `5 PTR !` - to store 5 at pointer PTR.

With SVREG you can use "poke order": `PTR 5 SVREG`. Address first, followed by the value to store.
