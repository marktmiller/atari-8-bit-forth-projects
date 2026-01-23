# *"Starting Forth"* upgrades
These are some words I wrote, along with adaptations of working routines from other authors, to make
APX Forth "work better" with the First Edition of the book ["Starting Forth"](https://www.forth.com/starting-forth/).
I've written my routines to conform to the inputs and/or outputs that the book specifies. You can read in the book to
see what they do.

- R@
- 0>
- CREATE
- 2*
- 2/
- RANDOM
- MOVE
- M+
- SM/REM
- FM/MOD (by NieDzejkob)
- NEGATE
- DNEGATE
- D=
- D0=
- D-
- D<
- M*/
- UM* (by Garth Wilson)
- UM/MOD (by Garth Wilson)
- \>NUMBER
- J
- ACCEPT

I've included a disk image called StartingForth.atr that contains the complete source code for this library. You will need a separate,
bootable APX Forth disk. Once you have booted into Forth, mount this disk image in one of the drives, and execute: `1 LOAD`. If you've
mounted the disk image in Drive 2, you will need to execute the command `DR1` before the LOAD command (to get Forth back to Drive 1
after the load, execute `DR0`).

To download the image, click on the .atr file in this repository, and then click the "Raw" button. This will automatically download it.

RANDOM is similar to the RANDOM word that's used in the book. It does not use the same algorithm as RND() that you find
in Basic. (If you want a word that works like RND() from Basic, see my [FP Library](https://github.com/marktmiller/atari-8-bit-forth-projects/tree/main/fig-forth1.1/FP%20library).)

Re. UM/MOD, see note at bottom.

I wrote ACCEPT to be a "simple" form of line input (analogous to INPUT in Basic), in that it does not allow you to use
arrow keys, just the alphanumeric keys (plus spaces and tabs), and Backspace. Though, I didn't think about most of the
other editing keys, like "clear line," "delete character." Hmm. I guess it needs more work...

The J word does the functional equivalent of the J word described in _"Starting Forth"_, but it works with how Fig-Forth
does DO-loops. The point of J is to help you deal with nested DO-loops. It accesses an index from a DO-loop at the next
higher level. Think of constructions like this in Basic, or some other language:

```
for j=1 to 10
  for i=1 to 5
  ...
  next i
next j
```

The I word accesses the inner-loop index. The J word accesses the outer index.

I don't know why, but the Forth described in the book stores two values on the return stack for every DO-loop currently
executing, but Fig-Forth stores three, which seems like a waste, because all it needs is the "stop" value at the end of
the loop, and the current index. So, this version of J has to go down to the fourth value in the return stack to get the
outer index.

Like with the I word, which copies the top value on the return stack, J can be used outside of DO-loops for making copies
of the fourth value on the return stack.

This set of words doesn't make APX completely compatible with "Starting Forth," but it helps.

Some exceptions remain:

"Starting Forth" says that you can declare a variable like so:

`VARIABLE SOMEVAR`

APX Forth needs an initialization value for variables:

`0 VARIABLE SOMEVAR`

Though, Screen 85 on the APX disk contains a series of definitions designed for use with "Starting Forth," including a
definition for VARIABLE that is compatible with how the book uses it. (Screen 85 also contains a definition for the J
word, slightly different from mine).

Screen 85 can be brought into the dictionary by simply using:

`85 LOAD`

when you're ready to set up your boot disk.

I didn't create a definition for CELLS. It seemed easy enough to use multiples to do the same thing. Though, I'm guessing
a definition for CELLS would be easy enough to add.

"Starting Forth" says that WORD puts the address of the input string on the stack. The APX version of WORD does not. You
need to use HERE to push the address of the input string on the stack.

"Starting Forth" says that NUMBER just pushes the converted number on the stack. The APX version of NUMBER pushes two
values on the stack: the converted number, and then it pushes 0. I'm not sure what the 0 represents.

There is a quirk with NUMBER to keep in mind. "Starting Forth" says that NUMBER expects the first byte at the starting address you give it to
be a count of the number of bytes in the string to convert. NUMBER in APX Forth completely ignores the first byte (I guess expecting it to be
a length byte), and proceeds with converting the string from the 2nd byte until it finds a non-numeric character.

## Other routines

To help with the logic in words for this library, or to just be helpful in using them, I created some other words:

| word | description |
| ---- | ------------|
| NOT | Logical NOT (0 -> 1, 1 -> 0) |
| 1- | single-length decrement |
| <> | "not equal" |
| 0<> | "not equal zero" |
| 1-2SWAP | Does the reverse of ROT |
| UD. | The double equivalent of "." Prints an unsigned double-length number, with a trailing space |
| IEXP | Integer exponent. Single-length. (ex: 5 2 IEXP -> 25) |
| DO-1 | Decrements the local index (referenced with I) for a DO-loop |
| SCNVN | Converts n bytes at addr to a single-length number |

While ROT does (n1 n2 n3 -> n2 n3 n1), 1-2SWAP does (n1 n2 n3 -> n3 n1 n2).

DO-1 is useful for temporarily suspending the advance of I in DO-loops.

SCNVN is a helper for using NUMBER. I designed SCNVN to be used in conjunction with ACCEPT. To use, first push the count of bytes to convert on
the stack (ACCEPT does this automatically), and then push the start address.

To account for the quirk I talk about above with NUMBER, a tactic I used was to add 1 to the address I gave to ACCEPT, so the complete
numeric string would be where NUMBER would expect to find it. NUMBER's behavior also sometimes led to erroneous results. Since it does not take
a length byte in its input, it only stops converting when it finds a non-numeric character. There were sometimes numeric characters in memory
after my intended string. SCNVN prevents this by putting a space character after the last character of the string. It also accounts for NUMBER's
"length byte skip" by adding 1 to the length you give it. So, unlike with ACCEPT, you don't need to add 1 to the address you give to SCNVN,
since it does that for you. The idea with the trailing blank is this stops NUMBER's conversion after the last character.

## Some notes

APX Forth has a version of CREATE, but I found it difficult to use. So, I created my own that I found makes more sense.

From what I've read, the standard reference source code for UM* and UM/MOD in Fig-Forth contain bugs. The version of these words I've
included with this library are debugged.

There is a word in APX Forth called U* that is based on the buggy version of what's called UM* in "Starting Forth."

The version of UM/MOD included in this library has detection for overflow (whether the quotient will be more than 65535, the maximum
unsigned single-length value). If there is overflow, it returns 65535 for both the quotient and the remainder.
