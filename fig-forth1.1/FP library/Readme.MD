# Port of Turbo Basic math package for APX Forth/Fig-Forth 1.1

Using dmsc's MADS disassembly of Turbo Basic's math package as my source ([Turbo Basic XL v1.5 disassembly](https://github.com/dmsc/turbo-dis)), I ported all of
its floating-point functions to the Forth assembler, so that they can be used with Forth code, making it much faster than
using the floating-point package supplied with APX Forth.

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

## Some optimization

After writing this port, I realized that it ended up imposing some overhead by cycling float values between the parameter
stack and the Atari's floating-point registers, FR0 and FR1. Even though Turbo Basic largely doesn't use Atari's floating-
point package in ROM, it still uses these registers for all float operations. So, I created a set of words that instead of
returning float results back to the parameter stack, keeps them in a float register, and if need be, loads a second float
argument from the parameter stack into a second float register, allowing the next float operation to "continue" with those
arguments. So, I suffixed these words with "C" for "continue." They are F+C, F-C, F*C, F/C, FSQRC, SQRTC, FSINC, FCOSC,
and ATNC. I describe these words below. To make them easier to talk about, I've called them "C" words.

I also created a couple words that "swap and continue," for subtraction and division, since the ordering of the arguments in
the float registers is important, and you may need to switch them around. These words are F-CS, and F/CS (for "continue-
swap"). I describe these words below. I've called these "CS" words.

Two-argument float operations normally copy two float values from the parameter stack into FR1 and FR0, respectively, before
running the operation.

Single-argument float operations normally copy one float value from the parameter stack into FR0, before running the
operation.

An operation like TRND (which implements Turbo Basic's RND() function) takes no parameters, and just puts a random number
into FR0.

Every float operation puts its result in FR0. The normal float operations copy this value onto the parameter stack. The
"C" words do not. They keep the result from a prior float operation in FR0, and may load a second argument (if needed) into
FR1, before running their specified operation. When the operation is complete, the result will be in FR0, and *will not be
copied to the parameter stack*. This is so that if you have a chain of operations you want to run, you can load another
parameter into a float register, and continue with the next operation, without the performance penalty of copying results
back and forth, between FR0/FR1 and the parameter stack. If, after using a "C" or "CS" word, you want to copy a result to
the parameter stack, use the F> word.

The "continue-swap" words transfer the result from a prior float operation in FR0 to FR1, and then load a new parameter
into FR0 from the parameter stack. This would be equivalent to the FR0 result from a prior operation being transferred back
to the parameter stack, loading a second float value onto the stack, and swapping them, before running the next float
operation. The result of the specified operation will be in FR0, and again, will not be transferred to the parameter stack.
To transfer the result to the stack, use F>.

To prepare values for these "C" or "CS" operations, you can either run a normal floating-point operation, prior to running
a "C" or "CS" word, perhaps FDROP the result, load a second float value on the parameter stack, and run a "C" or "CS" word.
Or, you can load a single float onto the parameter stack, copy it into FR0, using the FS word (part of the APX
Forth floating-point library, standing for "float store"), then load a second float value on the parameter stack, and run
a "C" or "CS" word.

## Error logic

All of the error logic from Turbo Basic's math package has been implemented in this port. Though, I have not yet examined
how it works. This would come into play with, for example, division by zero. From what I can tell, it does not trigger any
sort of error/alert response from Forth, in error conditions. My guess is it uses the processor's "carry" flag to signal an
error to the caller, but don't quote me on that.

## The floating-point functions

In the "number of parameters" column, assume these are floating-point parameters, unless otherwise noted.

| Word | Number of parameters | Description |
| ---- | -------------------- | ----------- |
| TRND | 0 | TB's RND() function. Pushes FP random numbers on the stack. |
| F*   | 2 | Does FP multiplication |
| F/   | 2 | Does FP division |
| F+   | 2 | Does FP addition |
| F-   | 2 | Does FP subtraction |
| FEXP | 1 | TB's EXP() function, computes e<sup>x</sup> |
| FLOG10 | 1 | TB's CLOG() function, computes a base-10 logarithm |
| FLOG | 1 | TB's LOG() function, computes a natural logarithm (base-e) |
| INT | 1 | TB's INT() function. Implements INT()'s rounding logic. Converts a float value to a single-precision integer. |
| F= | 2 | Tests for a = b |
| F<> | 2 | Tests for a not equal b |
| F< | 2 | Tests for fl1 < fl2 |
| FGT | 2 | Tests for fl1 > fl2 |
| F<= | 2 | Tests for fl1 <= fl2 |
| F>= | 2 | Tests for fl1 >= fl2 |
| FLOAT | 1 (integer) | Takes one single-precision integer parameter. Implements TB's logic for converting an integer to a float value. Supercedes the APX FLOAT word. |
| F+C | 1 | This keeps the result from a prior float operation in FR0, transfers one FP number from the parameter stack to FR1, and runs a FP addition operation on these arguments, placing the result in FR0. It does not transfer this value to the parameter stack. |
| F-C | 1 | This keeps the result from a prior float operation in FR0, transfers one FP number from the parameter stack to FR1, and runs a FP subtraction operation (FR0 - FR1), which places the result in FR0. It does not transfer this value to the parameter stack. |
| F-CS | 1 | This keeps the result from a prior float operation (which starts in FR0), but transfers it to FR1, then copies one float value from the parameter stack into FR0, and then runs a FP subtraction operation (FR0 - FR1), which places the result in FR0. It does not transfer this value to the parameter stack. |
| F*C | 1 | This keeps the result from a prior float operation in FR0, transfers one FP number from the parameter stack to FR1, and runs a FP multiplication operation on these arguments, placing the result in FR0. It does not transfer this value to the parameter stack. |
| F/C | 1 | This keeps the result from a prior float operation in FR0, transfers one FP number from the parameter stack to FR1, and runs a FP division operation on these arguments (FR0 / FR1), placing the result in FR0. It does not transfer this value to the parameter stack. |
|  F/CS | 1 | This keeps the result from a prior float operation (which starts in FR0), but transfers it to FR1, then copies a float value from the parameter stack into FR0, and then runs a FP division operation (FR0 / FR1), which places the result in FR0. It does not transfer this value to the parameter stack. |
| FSQR | 1 | Squares the top FP number on the parameter stack (computes x<sup>2</sup>).
| FSQRC | 0 | This keeps the result from a prior float operation in FR0, and squares it. It does not transfer this value to the parameter stack. |
|  SQRT | 1 | TB's SQR() function (square root) |
| SQRTC | 0 | This keeps the result from a prior float operation in FR0, and computes its square root. It does not transfer this value to the parameter stack. |
| SIN | 1 | TB's SIN() function |
| SINC | 0 | This keeps the result from a prior float operation in FR0, and computes its sine. It does not transfer this value to the parameter stack. |
| COS | 1 | TB's COS() function |
| COSC | 0 | This keeps the result from a prior float operation in FR0, and computes its cosine. It does not transfer this value to the parameter stack. |
| DEG | 0 | Like in Basic, this puts trigonometric functions in "degree mode." (Default is radians.) |
| RAD | 0 | Like in Basic, this puts trigonometric functions in "radian mode." (This is the default.) |
| ATN | 1 | TB's ATN() function (arctangent) |
| ATNC | 0 | This keeps the result from a prior float operation in FR0, and computes its arctangent. It does not transfer this value to the parameter stack. |
| FABS | 1 | This is not an implementation from Turbo Basic. I wrote it up, but it is equivalent to Basic's ABS() function. It produces the absolute value of the given FP value. |

## Other words that come with this port

These are words I wrote up. They do not have equivalents in Turbo Basic.

| Word | Number of parameters | Description |
| ---- | -------------------- | ----------- |
| CREATE | 0 | I've had trouble understanding how to use the CREATE word that comes with APX Forth. So, I made this version. I've had no problems with it. |
| FGETEXP | 1 | This leaves the FP parameter on the stack, but pushes onto the stack the float's "exponent vitals," as separate integer values (from higher to lower in the stack): |
| | | 1. A flag to indicate that the value is between 1.0 and 0, or 0 and -1.0 (1 for "true", 0 for "false"). |
| | | 2. A flag to indicate if the value is negative (1 for "true", 0 for "false"), |
| | | 3. Its "exponent" value, taken from the first byte of the float number. |
| TAN | 1 | Computes the tangent of an angle. |
| FI? | 1 (address) | Takes the address of a FP value. It copies the float value at the address to the parameter stack, converts that to an integer, and prints it on the terminal. |
| FI@ | 1 (address) | Takes the address of a FP value. It copies the float value at the address to the parameter stack, and converts that to a single-precision integer. |
| FPOW | 2 | This does a x<sup>y</sup> operation, where both x and y are float values. Note that it uses APX Forth's FEXP10 word to compute this, since I don't have an equivalent (yet) from the Turbo Basic library. |
| FIPOW | 1 (float), 1 (integer) | Takes a FP parameter as its first parameter, and a single-precision integer as its second parameter. It does a x<sup>y</sup> operation, where x is a float value, and y is an integer. |
| FARRAY | 1 | This is sort of like Basic's numeric arrays. It sets up a FP array structure where you can set the number of cells in the array at initialization, and then you can store and retrieve float values by integer index values. |
| FNEG | 1 | This toggles a FP number's sign bit. If the number comes in negative, it comes out positive, and vice-versa. |
| FROT | 3 | Does the integer equivalent of a ROT operation. It takes the third FP value down on the parameter stack, and brings it to the top of the stack. |
| F, | 1 | This pops the float value off the stack, and puts it into the dictionary. This is useful for situations such as: CREATE FPLIST FP 5.5 F, FP 0.1 F, ... |
| LB | 1 (integer) | Takes one single-precision integer parameter. Pops the value off the stack, and replaces it with its low-byte value. |
| HB | 1 (integer) | Takes one single-precision integer parameter. Pops the value off the stack, and replaces it with its high-byte value. |

## Examples

You use this FP library a lot like you would the one that comes with APX Forth. Push the required number of FP values on the parameter stack, and then do the operation of your choice.

`FP 5.25 FP 6.0 F* F. 31.5 ok`

### FP arrays

Here, I create an array of 100 FP elements. I store 5.5 in the 4th cell (arrays are 0-based), then retrieve it, and print it out:
```
100 FARRAY MYFLOATS ok
FP 5.5 3 MYFLOATS F! ok
3 MYFLOATS F? 5.5 ok
```

I've created some abbreviated aliases for some integer and FP constructs that come with APX Forth, since they take up a lot
of space when writing screens:

| Word | Alias for |
| ---- | --------- |
| VAR | VARIABLE |
| CONST | CONSTANT |
| FVAR | FVARIABLE |
| FCONST | FCONSTANT |
