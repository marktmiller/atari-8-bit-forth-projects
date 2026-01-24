( Atari time value - floating-point)
: TIME ( -f1) DECIMAL 18 C@
  FLOAT FP 65536 F* 19 C@
  FLOAT FP 256 F* F+ 20 C@ FLOAT
  F+ ;

( Example: 1000 ARRAY BPS-N - Creates BPS-N
  as 1000-element array,)
( each element is 16-bits.)
( Is addressed as: <value> <index> BPS-N ! -
  Stores <value> at <index>)
( <index> BPS-N @ - Retrieves value from <index>)
: ARRAY <BUILDS 2 * ALLOT
  DOES> SWAP 2 * + ;

( Gives high-byte and low-
  byte)
CODE LB ( n-lb) 0 ,X LDA,
INX, INX, PUSH0A JMP,
CODE HB ( n-hb) 1 ,X LDA,
INX, INX, PUSH0A JMP,

: VAR VARIABLE ;
: CONST CONSTANT ;

: 1- 1 - ;

( Shifts range of scrn's up 1
 scrn.)
: UPSCRS ( s1 s2 —) OVER 1 - SWAP
  DO
  I I 1+ EDITOR [COMPILE] COPY
  FORTH -1 +LOOP
  EDITOR [COMPILE] CLEAR FORTH ;

( Shifts range of scrn's down 1
  scrn.)
: DSCRS ( s1 s2 —) DUP 1+ ROT
  DO 
  I I 1- EDITOR [COMPILE] COPY
  FORTH LOOP
  EDITOR [COMPILE] CLEAR FORTH ;

( Factorial)
: FACT ( n-'n) DUP 2 SWAP DO
  I 1- * -1 +LOOP ;
: ISQR DUP * ;
: INC ( addr- ) DUP @ 1 + SWAP ! ;
: CLS 125 EMIT ; ( Clears scrn)
( Places curs., after using POS)
: PLCUR 159 EMIT 158 EMIT ;
: DEC ( addr- ) DUP @ 1- SWAP ! ;
( Same as POKE)
: SVREG ( addr b -) SWAP C! ;
( Does reverse of ROT)
: 1-2SWAP ROT ROT ;

( Moves a set of lines on screens)
( s1 l1 l2 s2 l3 -)
: MVLINES DUP 15 > 23 ?ERROR >R
  >R
  2DUP 15 > SWAP 15 > OR
  23 ?ERROR
  OVER - 1+ R> SWAP R> DUP ROT +
  SWAP >R >R ROT R> R>
  DO DUP SCR ! 1-2SWAP OVER DUP
  LINE DROP
  DUP 15 = IF DUP EDITOR H E
  ELSE EDITOR D THEN
  FORTH DUP SCR ! I DUP LINE DROP
  EDITOR I FORTH ROT
  LOOP FLUSH 2DROP DROP ;
