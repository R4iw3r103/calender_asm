  .section .text
  .global monthwoffset
  .type monthwoffset, %function

monthwoffset:
  push  {r4-r7, lr}
  mov   r4, r0 @ y
  mov   r5, r1 @ m
  mov   r6, r2 @ d

@ if (m < 3) { y--; m += 12 }
  cmp   r5, #3
  sublt r4, r4, #1  @ y--
  addlt r5, r5, #12 @ m += 12

@ s = y + (y/4) - (y/100) + (y/400) + ((13*m+8)/5) + d;
@ s=0
  mov   r7, #0
@s += y
  mov   r7, r4
@s += y / 4
  mov   r0, r4 @ r0 = y
  mov   r1, #4 @ r1 = 4
  bl    divsub @ y / 4
  add   r7, r7, r0
@ s -= y / 100
  mov   r0, r4 @ r0 = y
  mov   r1, #100
  bl    divsub
  sub   r7, r7, r0
@ s += y / 400
  mov   r0, r4
  mov   r1, #400
  bl    divsub  @ y / 400
  add   r7, r7, r0
@ s += (13 * m + 8) / 5
  mov   r0, #13
  mul   r0, r0, r5
  add   r0, r0, #8
  mov   r1, #5
  bl    divsub @ (13*m+8)/5
  add   r7, r7, r0
@ s += d
  add   r7, r7, r6

@ w = s%7
  mov   r0, r7
  mov   r1, #7
  bl    modsub @ s % 7

  pop {r4-r7, lr}
  bx lr
