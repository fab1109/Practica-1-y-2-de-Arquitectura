.data
vector: .space 400          # espacio para hasta 100 enteros (100 * 4 bytes)
n: .word 0

msg_n: .asciiz "Ingrese el tamaño del vector: "
msg_elem: .asciiz "Ingrese un numero: "
msg_des: .asciiz "\nVector desordenado: "
msg_ord: .asciiz "\nVector ordenado: "
espacio: .asciiz " "
salto: .asciiz "\n"

.text
.globl main

main:
    # ===== Leer tamaño del vector =====
    la $a0, msg_n
    li $v0, 4
    syscall

    li $v0, 5          # syscall para leer entero
    syscall
    sw $v0, n          # guardar n en memoria

    # ===== Leer elementos del vector =====
    la $t0, vector     # dirección base del vector
    lw $t1, n          # t1 = n
    li $t2, 0          # i = 0

leer_vector:
    bge $t2, $t1, fin_leer

    la $a0, msg_elem
    li $v0, 4
    syscall

    li $v0, 5          # leer entero
    syscall
    sw $v0, 0($t0)     # guardar en vector[i]

    addi $t0, $t0, 4   # avanzar a siguiente posición
    addi $t2, $t2, 1
    j leer_vector

fin_leer:

    # ===== Imprimir vector desordenado =====
    la $a0, msg_des
    li $v0, 4
    syscall

    la $a0, vector
    lw $a1, n
    jal print_vector

    # ===== Llamar a bubble sort =====
    la $a0, vector
    lw $a1, n
    addi $a1, $a1, -1  # n - 1 (límite externo)
    jal bubble_sort

    # ===== Imprimir vector ordenado =====
    la $a0, msg_ord
    li $v0, 4
    syscall

    la $a0, vector
    lw $a1, n
    jal print_vector

    # ===== Fin del programa =====
    li $v0, 10
    syscall




# bubble_sort(vector, n-1)
# a0 = dirección base del vector
# a1 = tamaño - 1

bubble_sort:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $t0, 0          # i = 0 (bucle externo)

loop_i:
    bge $t0, $a1, fin_bubble
    li $t1, 0          # j = 0 (bucle interno)

loop_j:
    sub $a2, $a1, $t0  # limite interno = n - 1 - i
    bge $t1, $a2, incrementar_i

    sll $t2, $t1, 2   # j * 4
    add $t3, $a0, $t2 # &vector[j]

    lw $t4, 0($t3)    # vector[j]
    lw $t5, 4($t3)    # vector[j+1]

    bgt $t4, $t5, swap

    addi $t1, $t1, 1
    j loop_j

swap:
    sw $t5, 0($t3)    # intercambio
    sw $t4, 4($t3)
    addi $t1, $t1, 1
    j loop_j

incrementar_i:
    addi $t0, $t0, 1
    j loop_i

fin_bubble:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra




# print_vector(vector, n)
# a0 = dirección base
# a1 = tamaño

print_vector:
    move $t3, $a0     # guardar base del vector
    li $t0, 0         # i = 0

print_loop:
    bge $t0, $a1, fin_print

    sll $t1, $t0, 2
    add $t2, $t3, $t1
    lw $a0, 0($t2)    # cargar vector[i]

    li $v0, 1         # imprimir entero
    syscall

    la $a0, espacio
    li $v0, 4
    syscall

    addi $t0, $t0, 1
    j print_loop

fin_print:
    la $a0, salto
    li $v0, 4
    syscall
    jr $ra