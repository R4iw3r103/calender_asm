  .section .text
  .global monthlen
  .type monthlen, %function

@ 閏年の計算
monthlen:
  push  {r4-r7, lr}
  mov   r4, r0 @ y
  mov   r5, r1 @ m

  @ q = (y%4==0) - (y%100==0) + (y%400==0);
  @ r6 == q, r7 = rv
  mov   r6, #0
  cmp   r5, #2   @if(m==2)
  bne   else2
  mov   r0, r4
  mov   r1, #4
  bl    modsub  @ y%4
  cmp   r0, #0   @ if y%4 == 0
  addeq r6, r6, #1
  mov   r0, r4
  mov   r1, #100
  bl    modsub      @ y%100
  cmp   r0, #0      @ if y%100 == 0
  subeq r6, r6, #1
  mov   r0, r4
  mov   r1, #400
  bl    modsub      @ y%400
  cmp   r0, #0      @ if y%400 == 0
  addeq r6, r6, #1

  @ if (m==2) {if(q) rv=29} else {rv=28}
  cmp   r5, #2      @ if (m == 2)
  cmpeq r6, #1      @ { if(q==True) {
  bne   else1
  moveq r7, #29
  beq   endmonthlen @ rv = 29 } }
else1:
  @ cmp   r5, #2
  @ r6, #1      @ else
  mov   r7, #28     @ rv = 28
  b     endmonthlen

else2:
  @ switch(m)
  cmp   r5, #1      @ case 1:
  moveq r7, #31
  beq   endmonthlen
  cmp   r5, #3      @ case 3:
  moveq r7, #31
  beq   endmonthlen
  cmp   r5, #5      @ case 5:
  moveq r7, #31
  beq   endmonthlen
  cmp   r5, #7      @ case 7:
  moveq r7, #31
  beq   endmonthlen
  cmp   r5, #8      @ case 8:
  moveq r7, #31
  beq   endmonthlen
  cmp   r5, #10     @ case 10:
  moveq r7, #31
  beq   endmonthlen
  cmp   r5, #12     @ case 12:
  moveq r7, #31     @ rv = 31
  beq   endmonthlen

  mov   r7, #30       @ default: rv = 30

endmonthlen:
  mov   r0, r7
  pop   {r4-r7, lr}
  bx    lr
@ monthlen 11/15 完了
