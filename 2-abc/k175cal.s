.section .text
.global mk1cal
.type mk1cal, %function

mk1cal:
    push {r4-r12, lr}
    mov r4, r0
    mov r5, r1
    mov r6, r2

    mov r2, #0          @ add
loop:                   @ add

    cmp r5, #13         @ add
    addge r4, r4, #1    @ add
    subge r5, r5, #12   @ add

    push {r2}           @ add
    mov r0, r4
    mov r1, r5
    mov r2, #1
    bl monthwoffset
    mov r7, r0
    pop {r2}            @ add

    mov r0, r4
    mov r1, r5
    bl monthlen
    mov r8, r0

    mov r9, #1          @ move
    mov r12, #0
loop1:
    cmp r9, r8
    addgt r2, r2, #1    @ add
    addgt r5, r5, #1    @ add
    bgt loop            @ add

    cmp r2, #2          @ add
    bgt loopout

    add r10, r7, r9
    sub r10, r10, #1
    add r10, r10, #7
    mov r0, r10
    mov r1, #7
    bl modsub
    mov r10, r0

    mov r0, #66         @ change
    mul r11, r12, r0
    mov r0, #3
    mul r0, r10, r0
    add r11, r11, r0
    mov r0, #22         @ add
    mul r0, r2, r0      @ add
    add r11, r11, r0    @ add

    cmp r9, #10
    blt loop2

    mov r0, r9
    mov r1, #10
    bl divsub
    add r0, r0, #48
    strb r0, [r6, r11]

loop2:
    add r11, r11, #1

    mov r0, r9
    mov r1, #10
    bl modsub
    add r0, r0, #48
    strb r0, [r6, r11]

    cmp r10, #6
    addge r12, r12, #1
    add r9, r9, #1
    b loop1
loopout:
    pop {r4-r12, lr}
    bx lr
