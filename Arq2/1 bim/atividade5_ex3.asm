.include "macros.asm"

.text
main:

	criavetores:
		print_str(" Insira o numero de elementos dos vetores: ")
		ler_int
		move $t0, $v0
	        ble $t0, $zero, end
		mul $t1, $t0, 4
		dinamic $t1
	   	move $s1, $v0	# endereco do vetor A
		dinamic $t1
	   	move $s2, $v0	# endereco do vetor B
  	
  	vetorA:
  		move $a0, $s1
  		li $t3, 65
  		jal leitura 	
  		
	vetorB:
         	move $a0, $s2
         	li $t3, 66
  		jal leitura
  		
        printa:
        	pulin
        	li $t3, 65
        	move $a0, $s1 	# Endereço 
        	jal escrita 		# escrita
        	pulin
  		li $t3, 66
        	move $a0, $s2 	# Endereço 
        	jal escrita 		# escrita
  	
  	soma:
		mtc1 $zero, $f2
  		jal paresA
		mtc1 $zero, $f3
  		jal imparesB
  		sub.s $f4, $f2, $f3
  	
  	printaresultado:
  	   	pulin
  		print_str("Soma das posicoes pares de vetA com a subtracao das posicoes impares de vetB: ")
  		print_flt $f2
  		print_str " - "
  		print_flt $f3
  		print_str " = "
  		print_flt $f4
  		
  	done
  	
leitura:
   	subi $sp, $sp, 4 		# Espaço para 1 item na pilha
   	sw $ra, ($sp) 		# Salva o retorno para a main
   	move $a3, $a0 		# aux = endereço base 
  	
  	li $t2, 0
  	l:
  		print_str("vet")
  		print_char $t3
  		print_str("[")
  		print_int $t2
  		print_str("]: ")
  	
  		ler_flt
		mov.s $f1, $f0
		swc1 $f1, ($a3)		# armazena no vetor
	
  		addi $a3, $a3, 4		# atualiza endereco vetor
  		addi $t2, $t2, 1
  		blt $t2, $t0, l
  	
  		lw $ra, ($sp) 			# Recupera o retorno para a main
  		addi $sp, $sp, 4 		# Libera o espaço na pilha
  		move $v0, $a3 		# Endereço base  para retorno
  		jr $ra 				# Retorna para a main
  	
escrita:
   	subi $sp, $sp, 4 		# Espaço para 1 item na pilha
   	sw $ra, ($sp) 		# Salva o retorno para a main
   	move $a3, $a0 		# aux = endereço base 
   	li $t2, 0
  	print_str("vet")
  	print_char $t3
  	print_str(": ")
  	e:
		lwc1 $f1, ($a3)		# resgata do vetor
		print_flt $f1
		space
		space
  		addi $a3, $a3, 4		# atualiza endereco vetor
  		addi $t2, $t2, 1
  		blt $t2, $t0, e
  	
  	lw $ra, ($sp) 			# Recupera o retorno para a main
  	addi $sp, $sp, 4 		# Libera o espaço na pilha
  	move $v0, $a3 		# Endereço base  para retorno
  	jr $ra 				# Retorna para a main
  	
paresA:
   	subi $sp, $sp, 4 		# Espaço para 1 item na pilha
   	sw $ra, ($sp) 		# Salva o retorno para a main
   	move $a3, $s1 		# aux = endereço base 
   	li $t2, 0

  	p:
  		li $t4, 2
  		div $t2, $t4
  		mfhi $t6
  		bnez $t6, naop		# entra se for posicao par
		lwc1 $f1, ($a3)		# resgata do vetor
		add.s $f2, $f2, $f1	# soma
		naop:
  		addi $a3, $a3, 4		# atualiza endereco vetor
  		addi $t2, $t2, 1
  		blt $t2, $t0, p

  	lw $ra, ($sp) 			# Recupera o retorno para a main
  	addi $sp, $sp, 4 		# Libera o espaço na pilha
  	move $v0, $a3 		# Endereço base  para retorno
  	jr $ra 				# Retorna para a main

imparesB:
   	subi $sp, $sp, 4 		# Espaço para 1 item na pilha
   	sw $ra, ($sp) 		# Salva o retorno para a main
   	move $a3, $s2 		# aux = endereço base 
   	li $t2, 0

  	i:
  		li $t4, 2
  		div $t2, $t4
  		mfhi $t6
  		beqz $t6, naoim		# entra se for posicao par
		lwc1 $f1, ($a3)		# resgata do vetor
		add.s $f3, $f3, $f1	# soma
		naoim:
  		addi $a3, $a3, 4		# atualiza endereco vetor
  		addi $t2, $t2, 1
  		blt $t2, $t0, i

  	lw $ra, ($sp) 			# Recupera o retorno para a main
  	addi $sp, $sp, 4 		# Libera o espaço na pilha
  	move $v0, $a3 		# Endereço base  para retorno
  	jr $ra 				# Retorna para a main

end:
	done
