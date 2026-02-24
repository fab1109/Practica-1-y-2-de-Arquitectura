.data
    pregunta_tam: .asciiz "Ingrese la cantidad de elementos: "
    pregunta_num: .asciiz "Ingrese el numero: "
    .align 2
    arreglo:      .space 400    # Espacio para hasta 100 enteros (400 bytes)
    tam:          .word 0       # Aquí guardaremos cuántos ingresó el usuario
    
.text

	main:
    	# 1. Preguntar cuántos números quiere ingresar
    	li $v0, 4
    	la $a0, pregunta_tam
    	syscall
    
    	li $v0, 5           # syscall para leer entero
    	syscall
   	sw $v0, tam         # Guardamos el tamaño en la variable 'tam'
    	move $t2, $v0       # $t2 = límite del bucle
    
    	# 2. Bucle para llenar el arreglo
    	la $t0, arreglo      # $t0 = dirección base
   	li $t1, 0            # i = 0
    
	leer_loop:
    	beq $t1, $t2, iniciar_ordenamiento
    
    	# Imprimir "Ingrese el numero: "
    	li $v0, 4
    	la $a0, pregunta_num
    	syscall
    
    	# Leer el número
    	li $v0, 5
    	syscall
    	sw $v0, 0($t0)       # Guardar el número en arreglo[i]
    
    	addi $t0, $t0, 4     # Siguiente posición de memoria
   	addi $t1, $t1, 1     # i++
   	j leer_loop

	iniciar_ordenamiento:
    	# Ahora sí, preparamos los argumentos para QuickSort
    	la $a0, arreglo
    	li $a1, 0            # bajo = 0
    	lw $t0, tam
    	addi $a2, $t0, -1    # alto = tam - 1
    
    	jal quickSort
    
    # ... aquí vendría el código de imprimir que hicimos antes ...
    
    li $t0,0
    la $t1,arreglo
    lw $t2,tam

    imprimir:
    	beq $t0,$t2,terminar
    	lw $a0, 0($t1)
    	li $v0,1
    	syscall
    	
    	# Imprimir un espacio (para que no salgan pegados)
    	li $v0, 11           # Código syscall 11: imprimir carácter
   	 li $a0, 32           # ASCII 32 es el espacio ' '
    	syscall
    	
    	addi $t1,$t1,4
    	addi $t0,$t0,1
    	j imprimir
    
    # Terminar programa
    terminar:
   	 li $v0, 10
    	syscall

# --- Función QuickSort ---
quickSort:
    # Guardar en el stack (pila)
    addi $sp, $sp, -16
    sw $ra, 0($sp)       # Dirección de retorno
    sw $a1, 4($sp)       # bajo
    sw $a2, 8($sp)       # alto

    # Condición de parada: if (bajo < alto)
    bge,$a1,$a2, fin_quicksort

    # Llamar a Partición
    jal particion
    move $s0, $v0        # $s0 = indiceParticion (pivote)

    # Ordenar lado izquierdo: quickSort(arreglo, bajo, pivote - 1)
    lw $a1, 4($sp)       # Restaurar bajo original
    addi $a2, $s0, -1    # alto = pivote - 1
    jal quickSort

    # Ordenar lado derecho: quickSort(arreglo, pivote + 1, alto)
    addi $a1, $s0, 1     # bajo = pivote + 1
    lw $a2, 8($sp)       # Restaurar alto original
    jal quickSort

fin_quicksort:
    lw $ra, 0($sp)
    addi $sp, $sp, 16
    jr $ra

# --- Función Partición ---
particion:
    # $a0 = arreglo, $a1 = bajo, $a2 = alto
    # Usaremos el último elemento como pivote
    sll $t0, $a2, 2
    add $t0, $t0, $a0
    lw $t1, 0($t0)       # $t1 = pivote = arreglo[alto]
    
    addi $t2, $a1, -1    # $t2 = i (bajo - 1)
    move $t3, $a1        # $t3 = j (contador del loop)

loop_particion:
    bgt,$t3,$a2, colocar_pivote
    
    sll $t5, $t3, 2
    add $t5, $t5, $a0
    lw $t6, 0($t5)       # $t6 = arreglo[j]
    
    # if (arreglo[j] < pivote)
    bge,$t6,$t1, sig_iteracion
    
    addi $t2, $t2, 1     # i++
    # Intercambio arreglo[i] y arreglo[j]
    sll $t8, $t2, 2
    add $t8, $t8, $a0
    lw $t9, 0($t8)
    sw $t6, 0($t8)
    sw $t9, 0($t5)

sig_iteracion:
    addi $t3, $t3, 1
    j loop_particion

colocar_pivote:
    # Intercambiar arreglo[i+1] con arreglo[alto] (el pivote)
    addi $t2, $t2, 1
    sll $t8, $t2, 2
    add $t8, $t8, $a0
    lw $t9, 0($t8)
    sw $t1, 0($t8)
    sw $t9, 0($t0)
    
    move $v0, $t2        # Retornar el índice del pivote (i + 1)
    jr $ra
