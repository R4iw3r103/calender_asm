  .global div10
  .type div10 %function

div10:
  push  {r1, r2, r3}
  ldr   r1, div10magic
  smull r3, r2, r1, r0
  asr   r0, r2, #2
  asr   r3, r0, #31
  sub   r0, r2, r3
  pop   {r1, r2, r3}
  bx    lr

div10magic:
  .word 0x66666667
