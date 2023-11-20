  .section .text
  .global mk1cal
  .type mk1cal, %function

  @ r4 = y　
  @ r5 = m
  @ r6 = r
  @ r7 = dlen
  @ r8 = woff
  @ r9 = c
  @ r10= b
  @ r11= canvas[6*21]
  @ r12= d
mk1cal:
  push  {r3-r12, lr}
  mov   r4, r0      @ y
  mov   r5, r1      @ m
  mov   r11, r2     @ canvas
  mov   r2, #0     @ count = 0

loop:
  @ 13月になった時に1年足して1月にリセット
  cmp   r5, #13
  addge r4, r4, #1
  subge r5, r5, #12

  push  {r2}
  mov   r0, r4      @ r0 = y
  mov   r1, r5      @ r1 = m
  mov   r2, #1      @ r2 = d == 1
  bl    monthwoffset
  mov   r8, r0      @ woff = monthwoffset(y, m, 1)
  pop   {r2}

  mov   r0, r4      @ r0 = y
  mov   r1, r5      @ r1 = m
  bl    monthlen
  mov   r7, r0      @ dlen = mouthlen(y, m) mov   r12, #1      @ d = 1

  mov   r6, #0      @ r = 0
  mov   r12, #1      @ d = 1

loop1:
  cmp   r12, r7
  addgt r2, r2, #1@ count++
  addgt r5, r5, #1
  bgt   loop        @ d<=dlen

  cmp   r2, r3
  bgt   loopend
  @ add   r12, r12, #1  @ d++ )
  add   r9, r8, r12  @ c = (woff + d)
  sub   r9, r9, #1  @ c = (woff + d - 1)
  add   r9, r9, #7  @ c = (woff + d - 1 + 7)
  add   r9, r9, #6  @ c = (woff + d - 1 + 7 + 6), 月曜始まりにする
  mov   r0, r9
  mov   r1, #7
  bl    modsub      @ c = (woff + d - 1 + 7) % IW(7)
  mov   r9, r0
  mov   r0, #66
  mul   r10, r6, r0 @ b = r * OW(66)
  mov   r0, #3
  mul   r0, r9, r0  @ c * CW(3)
  add   r10, r10, r0@ b = r*OW + c*CW
  mov   r0, #22
  mul   r0, r2, r0 @ count * 22
  add   r10, r10, r0@ b = r*OW+c*CW+count*22;

  cmp   r12, #10     @ if(d>=10)
  blt   mod10add0
  mov   r0, r12
  mov   r1, #10
  bl    divsub     @ d/10
  add   r0, r0, #48 @ + '0'
  strb  r0, [r11, r10] @ canvas[b] = d/10 + '0'

mod10add0:
  add   r10, r10, #1@ b++
  mov   r0, r12
  mov   r1, #10
  bl    modsub      @ d%10
  add   r0, r0, #48 @ + '0'
  strb  r0, [r11, r10] @ canvas[b] = d%10 + '0'
  cmp   r9, #6      @ if(c >= IW(7)-1) {
  addge r6, r6, #1  @   r++ }
  add   r12, r12, #1  @ d++
  b     loop1

loopend:
  pop   {r3-r12, lr}
  bx    lr

