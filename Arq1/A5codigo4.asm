.include "macros.asm"
.text 
main: 
	print_str(" digite um numero n: ")
	ler_int
	move $s0, $v0 		#s0 = n
	print_str(" digite um numero k: ")
	ler_int
	move $s1, $v0 		#s1 = k
	move $s2, $s1		#mult = k 
	bgt $s0, 1, a		
	beq $s0, 1, print	#se n=1
	erro
	a:
	bge $s1, 1, c		#se k<1
	erro
	c:
	
	li $t0, 1		#i=1
	loop: 
	addi $t0, $t0, 1	#i++
	mul $s2,$s2,$s1		#mult=mult*k
	blt $t0, $s0, loop	#loop
	j print	
print:
	print_int($s1)
	print_str("^")
	print_int($s0)
	print_str("= ")
	print_int($s2)
	done
	