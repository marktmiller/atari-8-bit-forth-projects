## Starting Forth upgrades
These are some words I wrote to make APX Forth "work better" with the First Edition of the book ["Starting Forth"](https://www.forth.com/starting-forth/).
I've written them to conform to the inputs and/or outputs that the book specifies.

- CREATE
- RANDOM
- MOVE
- M+
- SM/REM
- FM/MOD
- M*/
- UM*
- \>NUMBER
- J
- ACCEPT

Most of the arithmetic operators were pretty easy to convert from what APX uses to what's in "Starting Forth." One case, SM/REM, was literally just
a matter of renaming M/! M*/ was the most challenging, since APX didn't have anything like it, nor, it seemed, anything I could use to make the
result. So, I wrote it from scratch using the assembler.

This set of words doesn't make APX completely compatible with "Starting Forth," but it helps.

Some exceptions remain:

"Starting Forth" says that you can declare a variable like so:

`VARIABLE SOMEVAR`

APX Forth needs an initialization value for variables:

`0 VARIABLE SOMEVAR`

Though, Screen 85 on the APX disk contains a series of definitions designed for use with "Starting Forth," including a definition for VARIABLE
that is compatible with how the book uses it. (Screen 85 also contains a definition for the J word, slightly different from mine).

Screen 85 can be brought into the dictionary by simply using:

`85 LOAD`

when you're ready to set up your boot disk.

I didn't create a definition for CELLS. It seemed easy enough to use multiples to do the same thing. Though, I'm guessing a definition for CELLS
would be easy enough to add.

"Starting Forth" says that WORD puts the address of the input string on the stack. The APX version of WORD does not. You need to use HERE to push
the address of the input string on the stack.

"Starting Forth" says that NUMBER just pushes the converted number on the stack. The APX version of NUMBER pushes two values on the stack:
the converted number, and then it pushes 0. I'm not sure what the 0 represents.
