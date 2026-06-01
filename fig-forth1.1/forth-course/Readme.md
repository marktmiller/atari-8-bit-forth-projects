# "Advanced APX Forth" slides
I produced a [series of videos on YouTube](https://www.youtube.com/playlist?list=PL9GQGINuWC-2bCTRWZHJzpXMXgmbpp5s6) jumping off
from Thom Cherryhomes's series on APX Forth on the Atari, extending to more advanced topics in the language. I've put the bootable
Forth disk I used for the slides here. Some of the screens contain in-screen demonstrations of code for the course, which can
be LOADed right off the screens, and run.

I used a little Forth code to run the "slide show." It's on Screen 78.
If you want to use it, you'll need to use `78 LOAD`, and then invoke the vocabulary for it with the word SLIDES.

The commands you can use with the "slide viewer" are:

* N - for "next," which will display the screen following the one you're on
* P - for "previous," which will take you back to a screen prior to the one you're viewing
* R - for "refresh," which will redisplay the current screen

If you run any Forth code besides these commands, you'll need to reinvoke the vocabulary, using the word SLIDES to get access to the
commands again.

In Part 9 of the series, I ran a little Forth simulator, showing actions I was taking in a simulated Forth stack and dictionary.
It's on screens 79-82 (You load it with `79 LOAD`). It was designed to be used with Screen 72 in the slides.

The simulator responds to five commands:

* SIMINIT - Starts up the simulator at the bottom of the display. This is the first command you should run, after loading the
  simulator
* PUSH \<number\> - Pushes a number on the "stack"
* POP - Pops the top value off the "stack"
* STORE \<number\> - Appends a number to the "dictionary"
* SUBST \<index\> \<number\> - Goes to the zero-based index in the "dictionary," and substitutes the number you give it in that slot.
