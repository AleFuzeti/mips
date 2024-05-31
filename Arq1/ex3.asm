.include "macros.asm"

.text
j main

multi:
			addi $t6,$zero,1 #j = 1
			add $t7,$zero,$a2 #mult = argumento(2)
			
loop_multi:	slt $t8,$t6,$a3 #se j < argumento(3) ; t8 = 1; senao t8 = 0
			beq $t8,$zero,end_multi
			
			add $t7,$t7,$a2 #mult = mult + a2
			addi $t6,$t6,1 #t6++
			
			j loop_multi
			
end_multi:	add $v1,$zero,$t7
			jr $ra

fat:
		addi $t0,$zero,1 #i = 1
		addi $t1,$a0,0   #fatorial = $a0
		add  $t3,$zero,$ra #recebe memoria do ponto de retorno
		
loop_fat:	slt $t2,$t0,$a0 #se i < a0; t2 = 1; senao t2 = 0
		beq $t2,$zero,end_fat #desvia para FIM_FATORIAL se i>= a0
		
		add $a2,$zero,$t1 #a2 = fatorial
		sub $a3,$a0,$t0 #a3 = a0 - t0
		
		jal multi
		
		addi $t1,$v1,0 # fatorial = fatorial * (a0 - t0)
		addi $t0,$t0,1 #t0++
		
		j loop_fat
		
end_fat:
		add $v0,$zero,$t1 #v0 = $t1
		jr $t3
	
main:	
	print_str("digite um numero n: ")
	ler_int
	move $s0, $v0 	#s0 = n
	
	print_str("digite um numero p: ")
	ler_int
	move $s1, $v0 	#s1 = p
	sub $s1, $s0, $s1 #n - p
	
	
	#calcular o fatorial de $s0
	add $a0,$zero,$s0 #argumento(0) = s0
	jal fat
	add $s2,$v0,$zero
	
	#calcular o fatorial de $s1
	add $a0,$zero,$s1 #argumento(0) = s1
	jal fat
	add $s3,$v0,$zero
	
	div $s4, $s2, $s3
	print_str("arranjo: ")
	print_int($s2)
	print_str("/")
	print_int($s3)
	print_str("= ")
	print_int($s4)

	done	
