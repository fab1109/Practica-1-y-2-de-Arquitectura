.data
vector: .word 5,4,3,2,1
n: .word 5

msg_des: .asciiz "Vector desordenado: "
msg_ord: .asciiz "\nVector ordenado: "
espacio: .asciiz " "
salto: .asciiz "\n"

.text
.globl main

main:
    # Cargar dirección del vector y tamaño
    la $a0, vector
    la $t0, n
    lw $a1, 0($t0)

    # ===== Imprimir vector desordenado =====
    la $a0, msg_des
    li $v0, 4          # print string
    syscall

    la $a0, vector
    jal print_vector

    # ===== Llamar a bubble sort =====
    la $a0, vector     # dirección base del vector
    la $t0, n
    lw $a1, 0($t0)     # tamaño del vector
    addi $a1, $a1, -1  # n - 1 para el límite externo
    jal bubble_sort

    # ===== Imprimir vector ordenado =====
    la $a0, msg_ord
    li $v0, 4
    syscall

    la $a0, vector
    la $t0, n
    lw $a1, 0($t0)
    jal print_vector

    # ===== Fin del programa =====
    li $v0, 10
    syscall


#################################################
# bubble_sort
# a0 -> dirección base del vector
# a1 -> tamaño del vector - 1
#################################################
bubble_sort:
    addi $sp, $sp, -4
    sw $ra, 0($sp)     # guardar dirección de retorno

    li $t0, 0          # i = 0 (bucle externo)

loop_i:
    bge $t0, $a1, fin_bubble
    li $t1, 0          # j = 0 (bucle interno)

loop_j:
    sub $a2, $a1, $t0 # límite interno: n - i - 1
    bge $t1, $a2, incrementar_i

    # Calcular dirección del elemento j
    sll $t2, $t1, 2
    add $t3, $a0, $t2

    # Cargar elementos consecutivos
    lw $t4, 0($t3)
    lw $t5, 4($t3)

    # Comparar y hacer swap si es necesario
    bgt $t4, $t5, swap

    addi $t1, $t1, 1
    j loop_j

swap:
    sw $t5, 0($t3)
    sw $t4, 4($t3)
    addi $t1, $t1, 1
    j loop_j

incrementar_i:
    addi $t0, $t0, 1
    j loop_i

fin_bubble:
    lw $ra, 0($sp)     # restaurar $ra
    addi $sp, $sp, 4
    jr $ra


#################################################
# print_vector
# a0 -> dirección base del vector
# a1 -> tamaño del vector
#################################################
print_vector:
    move $t3, $a0      # guardar dirección base
    li $t0, 0          # i = 0

print_loop:
    bge $t0, $a1, fin_print

    sll $t1, $t0, 2
    add $t2, $t3, $t1
    lw $a0, 0($t2)     # cargar elemento

    li $v0, 1          # print int
    syscall

    la $a0, espacio
    li $v0, 4          # print space
    syscall

    addi $t0, $t0, 1
    j print_loop

fin_print:
    la $a0, salto
    li $v0, 4
    syscall
    jr $ra
