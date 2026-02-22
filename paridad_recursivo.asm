.data
msg_1: .asciiz "Ingrese un numero para determinar si es par o impar: "
msg_par:   .asciiz "El numero ingresado es Par "
msg_impar: .asciiz "El numero ingresado es Impar "


.text
.globl main

# =========================
# Programa principal
# =========================
main:
    # Mostrar mensaje solicitando el número
    la $a0, msg_1      # Dirección del mensaje
    li $v0, 4          # Syscall 4: imprimir string
    syscall

    # Leer un entero ingresado por el usuario
    li $v0, 5          # Syscall 5: leer entero
    syscall

    # Pasar el número leído como argumento a la función
    move $a0, $v0      # $a0 contiene el número a evaluar

    # Llamada a la función recursiva par_impar
    jal par_impar

    beq $v0, $zero, es_par

    # Si no es par, imprimir mensaje de impar
    la $a0, msg_impar
    li $v0, 4
    syscall

    j fin_main         # Salto al final del programa

es_par:
    # Imprimir mensaje de número par
    la $a0, msg_par
    li $v0, 4
    syscall

fin_main:
    # Finalizar el programa
    li $v0, 10         
    syscall      


# =========================
# Función recursiva par_impar
# =========================

par_impar:

    # Reservar espacio en la pila para:
    # - el argumento ($a0)
    # - la dirección de retorno ($ra)
    addi $sp, $sp, -8
    sw $a0, 0($sp)
    sw $ra, 4($sp)

    # Caso base: si el número es 0, es par
    beq $a0, $zero, caso_base

    # Paso recursivo:
    # Se reduce el número en 1
    addi $a0, $a0, -1

    # Llamada recursiva
    jal par_impar

    # Al regresar, se alterna el resultado:
    # v0 = 1 - v0
    li $t0, 1
    sub $v0, $t0, $v0

    j fin_funcion

caso_base:
    # Si el número llegó a 0, es par
    li $v0, 0

fin_funcion:
    # Restaurar valores guardados en la pila
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    # Retornar a la función llamadora
    jr $ra
