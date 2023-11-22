  .section .text
  .global pch
  .type   pch, %function
  @ pch(char)

pch:
  push {r1, r2, r7}

  ldr r1, =pchbuf
  strb r0, [r1, #0]

  @ write(1, pchbuf, 1);
  mov r0, #1
  ldr r1, =pchbuf
  mov r2, #1
  mov r7, #4
  svc #0

  pop {r1, r2, r7}
  mov r0, #0
  bx lr

  .section .data

pchbuf:
  .asciz "XYZ"
