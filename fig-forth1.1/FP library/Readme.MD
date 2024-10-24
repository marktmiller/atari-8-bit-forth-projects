# Port of Turbo Basic math package for APX Forth/Fig-Forth 1.1

Using dmsc's MADS disassembly of Turbo Basic's math package (https://github.com/dmsc/turbo-dis) as my source, I ported all of
its floating-point functions to the Forth assembler, so that they can be used with Forth code, making it much faster than using
the floating-point package supplied with APX Forth.

This is not a complete replacement of APX Forth's math library. It supercedes most of the math words, but still has you using
many of the floating-point utility functions of APX Forth.

My goal with this library was to bring over the same floating-point logic that is in Turbo Basic, since I wanted to port some
floating-point code in Basic to Forth, and do speed comparisons between it and the same programs in Basic. As a consequence,
it brings over Basic's INT() function, which converts floating-point numbers to Forth single-precision integers, but uses
Basic's rounding logic.

Even though the library contains a EXP10 word, since Basic doesn't support the exponent function for base 10, this word is not
usable in the same way the other floating-point words are. As of this writing, it is strictly used by the library as a support
routine. APX Forth has a FEXP10 word, which is still usable after this library is loaded, but it uses the slower math
package in ROM.

This port also supercedes the APX FLOAT word with logic from Turbo Basic's FP math package. I wasn't satisfied with the APX
version. I think this'll work better.

I also wrote a complete set of floating-point value-comparison words, superceding the ones that come with APX, and adding
many more. In addition, I wrote a FROT word, that does the FP equivalent of ROT, and a F, word for adding float constants to
the dictionary (the float equivalent of , and C,).

To import this library into Forth, you will need APX Forth's assembler (39 LOAD) and its floating-point library (60 LOAD)
to be loaded first. You will then need to import the contents of the file "Turbo Basic supplement", and then finally, import
the contents of the file "Turbo Basic floating-point port".

In using this library, you create float values the same way you would in APX Forth's floating-point library, by either using
the FP word for literals, or FLOAT to convert single-precision integers.
