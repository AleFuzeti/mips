.include "macros.asm"

.text
main:

	criavetores:
		print_str(" Insira o numero de elementos: ")
		ler_int
		move $t0, $v0
		ble $t0, $zero, end
		mul $t1, $t0, 4
		dinamic $t1
	   	move $s1, $v0	# endereco do vetor A
		dinamic $t1
	   	move $s2, $v0	# endereco do vetor aux
  	
  	vetor:
  		move $a0, $s1
  		jal leitura 	
  		
        printa:
        	pulin
        	move $a0, $s1 	# endereço 
        	jal escrita 		# escrita

	contafloat:
		pulin
        	move $a0, $s1 	# endereço 
        	jal contador 		# contador

  	done
  
leitura:
   	subi $sp, $sp, 4 		# Espaço para 1 item na pilha
   	sw $ra, ($sp) 		# Salva o retorno para a main
   	move $a3, $a0 		# aux = endereço base 
  	
  	li $t2, 0
  	l:
  		print_str("[")
  		print_int $t2
  		print_str("]: ")
  	
  		ler_flt
		mov.s $f1, $f0
		swc1 $f1, ($a3)	# armazena no vetor
	
  		addi $a3, $a3, 4	# atualiza endereco vetor
  		addi $t2, $t2, 1
  		blt $t2, $t0, l
  	
  		lw $ra, ($sp) 		# Recupera o retorno para a main
  		addi $sp, $sp, 4 	# Libera o espaço na pilha
  		move $v0, $a3 	# Endereço base  para retorno
  		jr $ra 			# Retorna para a main
  	
escrita:
   	subi $sp, $sp, 4 		# Espaço para 1 item na pilha
   	sw $ra, ($sp) 		# Salva o retorno para a main
   	move $a3, $a0 		# aux = endereço base 
   	li $t2, 0
  	print_str("vet")
  	print_str(": ")
  	e:
		lwc1 $f1, ($a3)	# resgata do vetor
		print_flt $f1
		space
  		addi $a3, $a3, 4	# atualiza endereco vetor
  		addi $t2, $t2, 1
  		blt $t2, $t0, e
  	
  	lw $ra, ($sp) 			# Recupera o retorno para a main
  	addi $sp, $sp, 4 		# Libera o espaço na pilha
  	move $v0, $a3 		# Endereço base  para retorno
  	jr $ra 				# Retorna para a main
  	
contador:													
   	subi $sp, $sp, 4 		# Espaço para 1 item na pilha
   	sw $ra, ($sp) 		# Salva o retorno para a main
   	move $a3, $a0 		# aux = endereço base
   	pulin
   	li $t2, 0 				# auxiliar vetor unico
   	li $t3, 0				# aux para finalizar
   	c:					# loop externo
      		lwc1 $f1, ($a3) 	# Valor 
      		li $t4, 0			# i
      		li $t5, 0			# j
      		li $t6, 0      		# repeticoes
      		c1: 				# loop interno
      			add $t7, $a3, $t4 		# vetor principal + i
      			lwc1 $f2, ($t7)		# aux
   			c.eq.s $f1, $f2		# compara valor com aux
   			bc1f diferentes
   			addi $t6, $t6, 1		# +1 repeticao
   			diferentes:
   			addi $t4, $t4, 4		# i++
   			ble $t4, $t1, c1		# compara com o espaco total do vetor
     		confere:
      			bgt $t5, $t1, segue	# se j for menor que espaco vetor
      			move $t8, $s2		# end vetor
      			add $t8, $t8, $t5		# end vetor mais j
      			lwc1 $f3, ($t8)		# elemento do vetor
      			addi $t5, $t5, 4		# atualiza l
      			c.eq.s $f1, $f3			
      			bc1t jaesta			# se elemento estiver no vetor, pula
      			j confere
      		segue:
      		move $t8, $s2			# endereco base vetor
      		add $t8, $t2, $t8			# aumenta o contador do vetor
      		swc1 $f1, ($t8)			# coloca no vetor
      		addi $t2, $t2, 4
      		print_flt $f1
      		print_str " repete por "
      		print_int $t6
      		print_str " vez(es)."
      		pulin
      		jaesta:
      		addi $a3, $a3, 4
      		addi $t3, $t3, 4
      		ble $t3, $t1, c
      		
      lw $ra, ($sp) 			# Recupera o retorno para a main
      addi $sp, $sp, 4 		# Libera o espaço na pilha
      move $v0, $a3 		# Endereço base da matriz para retorno
      jr    $ra 				# Retorna para a main

end:
	done
