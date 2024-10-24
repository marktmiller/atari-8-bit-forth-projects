# Port of Turbo Basic math package for APX Forth/Fig-Forth 1.1

Using dmsc's MADS disassembly of Turbo Basic's math package (https://github.com/dmsc/turbo-dis) as my source, I ported all of
its floating-point functions to the Forth assembler, so that they can be used with Forth code, making it much faster than using
the floating-point package supplied with APX Forth.

This is not a complete replacement of APX Forth's math library. It replaces all of the math words, but still depends on many
of the APX floating-point utility words.

My goal with this library was to bring over the same floating-point logic that is in Turbo Basic, since I wanted to port some
floating-point code in Basic to Forth, and do speed comparisons between it and the same programs in Basic. As a consequence,
it brings over Basic's INT() function, which converts floating-point numbers to Forth single-precision integers, but uses
Basic's rounding logic. Also, even though the library contains a FEXP10 word, since Basic doesn't support the exponent
function for base 10, this word is not usable in the same way the other floating-point words are. As of this writing, it is
strictly used by the library as a support function. APX Forth has a FEXP10 word, which is superceded by the one in this
library. It also replaces the APX FLOAT word with logic from Turbo Basic's FP math package. I wasn't satisfied with the APX
version. I think this'll work better.

I also wrote a complete set of floating-point value-comparison words, replacing the ones that come with APX, and adding many
more. In addition, I wrote a FROT word, that does the FP equivalent of ROT, and a F, word for adding float constants to the
dictionary.

To import this library into Forth, you will need the APX Forth's assembler (39 LOAD) and its floating-point library (60 LOAD).
You will then need to import the contents of the file "Turbo Basic supplement", and then finally, import the contents of the
file "Turbo Basic floating-point port".

You create float values the same way you would using APX Forth's floating-point library, by either using the FP word, or
FLOAT.
