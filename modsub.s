  .section .text
  .global modsub
  .type modsub, %function

modsub:
loop:
  cmp r0, r1
  blt loopout
  sub r0, r0, r1
  b loop

loopout:
  bx lr
