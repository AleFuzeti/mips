.include "macros.asm"

.text
main:
	print_str(" Digite um numero n: ")
	ler_int
	move $s0, $v0 	#s0 = n
	print_str(" Digite um numero a: ")
	ler_int
	move $s1, $v0 	#s1 = a
	print_str(" Digite um numero b: ")
	ler_int
	move $s2, $v0 	#s2 = b
	
	li $t0, 0
	loop: 
	addi $t0, $t0, 1
	
	div $t0,$s1 #argumento(0)/i
	mfhi $t1 # t1 = resto
	beq $t1,$zero,imprime
	
	div $t0,$s2 #argumento(0)/i
	mfhi $t2 # t2 = resto
	beq $t2,$zero,imprime
	
	blt $t0, $s0, loop
	
	done
	

imprime:
	print_int($t0)
	pulin
	
	blt $t0, $s0, loop
	done
