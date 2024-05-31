.include "macros.asm"
.text
main: 
	print_str(" digite um numero n: ")
	ler_int
	move $s0, $v0 		#s0 = n
	
	bge $s0, 0, a
	erro
	a:
	
	li $t0, 0		#i = 1
	li $s1, 1		#c = 1
	jal print		#print c(i)
	
	blt $t0, $s0, loop
	done
	
	loop: 
	addi $t0, $t0, 1	#i++
	
	mul $t1, $t0, 2  	#t1= 2n
	addi $t1, $t1, -1	#t1= 2n-1
	mul $t1, $t1, 2 	#t1= 2(2n-1)
	
	mul $t3, $t1, $s1	#t3= 2(2n-1)*C[n-1]
	addi $t2, $t0, 1	#t2= n+1
	div $s1, $t3, $t2	#s1= 2(2n-1)*C[n-1]/(n+1)
	jal print	
	blt $t0, $s0, loop
	
	done
	
print:
	print_int($s1)
	pulin
	jr $ra
