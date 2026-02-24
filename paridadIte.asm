.data
	men1: .asciiz "Ingrese el número a evaluar: "
	men2: .asciiz "0 si es par, 1 si es impar: "

.text
	#Imprimir mensaje 1 
	li $v0,4
	la $a0,men1
	syscall
	
	li $v0,5 #Leer el número ingresado
	syscall
	move $s0,$v0 #Mover valor ingresaso a $s0
	li $t1,0 #Inicializar t1
	
	#Bucle para evaluar el número
	
	Bucle:
		beq $s0,0,resultado #Caso Base (n=0)
	
		xori $t1,$t1,1 #Va rotando por cada iteración entre 0 y 1
		subi $s0,$s0,1 #Rresta 1 al numero evaluado
		j Bucle
		
	resultado:
		#Imprimir mensaje2
		li $v0,4
		la $a0,men2
		syscall
		
		#Imprimir el resultado de la evaluacion
		li $v0,1
		move $a0,$t1
		syscall
		
		#Finalizar
		li $v0,10
		syscall
	
	

		
