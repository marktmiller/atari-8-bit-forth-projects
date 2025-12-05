# *"Starting Forth"* upgrades
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
- UM/MOD
- \>NUMBER
- J
- ACCEPT

12/5/2025: Just found out M*/, UM*, and UM/MOD have a bug: While they work for positive numbers, they do not work for negative numbers. So, will
work on fixing these.

RANDOM is similar to the RANDOM word that's used in the book. It does not use the same algorithm as RND() that you find in Basic. (If you want a
word that works like RND() from Basic, see my [FP Library](https://github.com/marktmiller/atari-8-bit-forth-projects/tree/main/fig-forth1.1/FP%20library).)

I wrote ACCEPT to be a "simple" form of line input (analogous to INPUT in Basic), in that it does not allow you to use arrow keys, just the
alphanumeric keys (plus spaces and tabs), and Backspace. Though, I didn't think about most of the other editing keys, like "clear line," "delete
character." Hmm. I guess it needs more work...

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

## Some notes

APX Forth has a version of CREATE, but I found it difficult to use. So, I created my own that I found makes more sense. I suspect others, except
maybe more experienced Forth programmers, will agree.

A testament to how well-organized the Forth standard is was FM/MOD. I wasn't able to figure out on my own how to implement it, but
forth-standard.org solved that for me, by having a definition written in Forth that was easy to bring over to APX. Very nice. I forget if I
consulted it for a definition for M*/, but oh well. I've tested my version, and it works.
