  .section .text
  .global mk1cal
  .type mk1cal, %function

  @ r2 = count
  @ r3 = n
  @ r4 = y
  @ r5 = m
  @ r6 = r
  @ r7 = d
  @ r8 = dlen
  @ r9 = woff
  @ r10= c
  @ r11= b
  @ r12= canvas
mk1cal:
  push  {r4-r12, lr}
  mov   r4, r0      @ y
  mov   r5, r1      @ m
  mov   r12, r2     @ canvas
  mov   r2, #0      @ count = 0

loop:
  cmp   r2, r3      @ if (count == n) {
  beq   loopend     @   goto loopend; }

  @ 13月になった時に、+1年して月をリセット
  cmp   r5, #13
  addge r4, r4, #1
  subge r5, r5, #12

  push  {r2}
  mov   r0, r4      @ r0 = y
  mov   r1, r5      @ r1 = m
  mov   r2, #1      @ r2 = d == 1
  bl    monthwoffset
  mov   r9, r0      @ woff = monthwoffset(y, m, 1)
  pop   {r2}

  mov   r0, r4      @ r0 = y
  mov   r1, r5      @ r1 = m
  bl    monthlen
  mov   r8, r0      @ dlen = mouthlen(y, m)

  mov   r6, #0      @ r = 0
  mov   r7, #1      @ d = 1

  @ カレンダーの月の数を引数(n)に合わせて増やす
  mov   r0, #6
  mul   r6, r0, r2  @ r *= 6

loop1:
  cmp   r7, r8      @ if (d<=dlen) {
  addgt r2, r2, #1  @ count++
  addgt r5, r5, #1  @ m++
  bgt   loop        @ goto loop }

  add   r10, r9, r7 @ c = (woff + d)
  sub   r10, r10, #1@ c = (woff + d - 1)
  add   r10, r10, #7@ c = (woff + d - 1 + 7)
  mov   r0, r10
  mov   r1, #7
  bl    modsub      @ c = (woff + d - 1 + 7) % IW(7)
  mov   r10, r0
  mov   r0, #21
  mul   r11, r6, r0 @ b = r * OW(21)
  mov   r0, #3
  mul   r0, r10, r0 @ c * CW(3)
  add   r11, r11, r0@ b = r*OW + c*CW

  cmp   r7, #10     @ if(d>=10)
  blt   mod10add0
  mov   r0, r7
  mov   r1, #10
  bl    divsub      @ d/10
  add   r0, r0, #48 @ + '0'
  strb  r0, [r12, r11] @ canvas[b] = d/10 + '0'

mod10add0:
  add   r11, r11, #1@ b++
  mov   r0, r7
  mov   r1, #10
  bl    modsub      @ d%10
  add   r0, r0, #48 @ + '0'
  strb  r0, [r12, r11] @ canvas[b] = d%10 + '0'
  cmp   r10, #6      @ if(c >= IW(7)-1) {
  addge r6, r6, #1  @   r++ }
  add   r7, r7, #1  @ d++

  b loop1

loopend:
  pop   {r4-r12, lr}
  bx    lr
