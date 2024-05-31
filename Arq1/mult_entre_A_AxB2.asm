.include "macros.asm"
j main

zero: 
	addi $t1,$zero,1 	#constante 1
	slt $t2,$t1,$a1 	#se s1 < 0; t2 = 0; senao t2 = 1 
	beq $t2,$zero,zero1
	jr $ra
	zero1:
	print_str ("Numero nao pode ser menor ou igual a zero")
     	done

multiplos:	div $t0,$s0 #i/A
		mfhi $s3 # s3 = resto
		beq $s3,$zero,imprime #se for multiplo, imprime
		jr $ra
		imprime:
		print_str ("  ")
		print_int($t0)
		print_str ("  ")
		jr $ra
		
loop:  		addi $t4,$zero,1
		slt $t2,$t4,$t0 #se 0 < i; t2 = 1; senao t2 = 0
		beq $t2,$zero,end #encerra se i < 1
		subi $t0,$t0,1 #i--
		
		jal multiplos 
		j loop


main:
   	print_str (" Digite um numero ")#imprimindo
    	ler_int	# lendo o numero
    	move $s0, $v0	# movendo pra outro registrador
    	move $a1, $s0	#aux = s0
    	jal zero
    	
   	print_str (" Digite outro numero ")
    	 ler_int
    	move $s1, $v0
    	move $a1, $s1	#aux = s0
    	jal zero
    	
    	mul $s2,$s0,$s1 #multiplica os valores e salva em s2
    	addi $t0,$s2,1	#salva s2+1 em t0
    	
      	print_str (" Multiplos de ")
	print_int($s0)
   	print_str (" entre ")
   	print_int($s0)
      	print_str (" e ")
	print_int($s2)
   	print_str (" : ")
   	
    	j loop

end:	done
