# entre os ########## estão os códigos que fiz

.include "macros.asm"
.data
Mat: .space 256 # max 8x8 * 4 (inteiro) 
Ent1: .asciiz " Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "

	###########################################
	
	array:	.word	0 : 65 	# array com os valores ordenados
	size:	.word	5		# numero de elementos

	linha: .asciiz  " \n "
	espaco: .asciiz  "  "

	###########################################

.text
main:  

	###########################################
	print_str " Insira a ordem da matriz (min 2, max 8): "
   	ler_int
   	move $t2, $v0 # aux = valor lido
   	
   	ble $t2, 1, end # encerra se a ordem for menor ou igual a 1
   	bgt $t2, 8, end # encerra se a ordem for maior a 8
   	
   	move $t8, $t2
   	mul $t8, $t8, $t8 	# max elementos
   	move $t3, $t8	# t3 = t8
   
	la	$t9, size		
	sw	$t8, 0($t9)	# array ordenado
   	la 	$t8, array  	

   	move $t9, $t2	# t9 = ordem
	###########################################
	
   la $a0, Mat # Endereço base de Mat
   move $a1, $t2 # Número de linhas
   move $a2, $t2 # Número de colunas
   jal leitura # leitura(mat, nlin, ncol)
   move $a0, $v0 # Endereço da matriz lida
   jal escrita # escrita(mat, nlin, ncol)
   	j sort
   	back:
   li $v0, 10 # Código para finalizar o programa
   syscall # Finaliza o programa

indice:
   mul $v0, $t0, $a2 # i * ncol
   add $v0, $v0, $t1 # (i * ncol) + j
   sll $v0, $v0, 2 # [(i * ncol) + j] * 4 (inteiro)
   add $v0, $v0, $a3 # Soma o endereço base de mat
   jr $ra # Retorna para o caller
   
leitura:
   subi $sp, $sp, 4 # Espaço para 1 item na pilha
   sw $ra, ($sp) # Salva o retorno para a main
   move $a3, $a0 # aux = endereço base de mat

	###########################################
	li $t5, 0 # soma das diagonais
        li $t6, -30000# seta um valor bem pequeno (maior acima)
        li $t7, 30000 # seta um valor bem grande  (menor abaixo)
	###########################################
	
l: la $a0, Ent1 # Carrega o endereço da string
   li $v0, 4 # Código de impressão de string
   syscall # Imprime a string
   move $a0, $t0 # Valor de i para impressão
   li $v0, 1 # Código de impressão de inteiro
   syscall # Imprime i
   la $a0, Ent2 # Carrega o endereço da string
   li $v0, 4 # Código de impressão de string
   syscall # Imprime a string
   move $a0, $t1 # Valor de j para impressão
   li $v0, 1 # Código de impressão de inteiro
   syscall # Imprime j
   la $a0, Ent3 # Carrega o endereço da string
   li $v0, 4 # Código de impressão de string
   syscall # Imprime a string
   li $v0, 5 # Código de leitura de inteiro
   syscall # Leitura do valor (retorna em $v0)
   move $t2, $v0 # aux = valor lido
   
   	###########################################
     	sw	$t2, 0($t8)		# adiciona no array.
	addi $t8, $t8, 4		# incrementa  ponteiro em 4.

   	j cimabaixo			# chama a funçao para localizar
   	volta:
	###########################################
	
   jal indice # Calcula o endereço de mat[i][j]
   sw $t2, ($v0) # mat[i][j] = aux
   addi $t1, $t1, 1 # j++
   blt $t1, $a2, l # if(j < ncol) goto l
   li $t1, 0 # j = 0
   addi $t0, $t0, 1 # i++
   blt $t0, $a1, l # if(i < nlin) goto l
   li $t0, 0 # i = 0
   lw $ra, ($sp) # Recupera o retorno para a main
   addi $sp, $sp, 4 # Libera o espaço na pilha
   move $v0, $a3 # Endereço base da matriz para retorno
   jr $ra # Retorna para a main
   
    	###########################################
 	sort:
 			move $t0, $t9		# t0 = ordem
 			la	$t8, array		# carrega array em $t8.
			lw	$t9, size			# carrega tamanho do array em $t9.
			li	$t2, 1			# contador
			move $t9, $t3		# t9 = max elementos
			
	loop_fora:
			la	$t8, array		# carrega array em $t8.
			bge	$t2, $t9, loop_fora_fim	# enquanto (t2 < $t9).
			move	$t1, $t2		# copia $t2 para $t1.
	loop_dentro:
			la	$t8, array		# carrega array em $t8.
			mul	$t5, $t1, 4		# multiplica $t1 por 4, e coloca em $t5
			add	$t8, $t8, $t5		# adiciona ao endereço
			ble	$t1, $zero, loop_dentro_fim	# enquanto (t3 > 0).
			lw	$t7, 0($t8)		# carrega array[$t8] to $t7.
			lw	$t6, -4($t8)		# carrega array[$t8 - 1] to $t6.
			bge	$t7, $t6, loop_dentro_fim	# enquanto (array[$t8] < array[$t8 - 1]).
			lw	$t4, 0($t8)
			sw	$t6, 0($t8)
			sw	$t4, -4($t8)
			subi	$t1, $t1, 1
			j	loop_dentro		# volta para loop_dentro.
	loop_dentro_fim:
			addi	$t2, $t2, 1	# contador++.
			j	loop_fora		# volta para loop_fora.
	 loop_fora_fim:
   			print_str ". \n A matriz ordenada: "
   	
					
	print:
			la	$t8, array		# carrega o array
			lw	$t9, size			# carrega o tamanho
			li	$t2, 0			# contador
		print_loop:
			bge	$t2, $t9, print_end	# pula para o fim
			div $t2, $t0				# verifica se o j é
			mfhi $s0				# multiplo da ordem
			beqz $s0,  pulalinha           	# e pula a linha
			volt:
			
			li	$v0, 1				
			lw	$a0, 0($t8)			# imprime os valores ordenados
			syscall
			addi	$t8, $t8, 4		# atualiza o endereço
			addi	$t2, $t2, 1		# atualiza o contador
			
			space
				
			j	print_loop			# volta para o loop
		print_end:	
			j back
    	###########################################
 
escrita:
   subi $sp, $sp, 4 # Espaço para 1 item na pilha
   sw $ra, ($sp) # Salva o retorno para a main
   move $a3, $a0 # aux = endereço base de mat
e: jal indice # Calcula o endereço de mat[i][j]
   lw $a0, ($v0) # Valor em mat[i][j]
   print_int($a0)
   space
   addi $t1, $t1, 1 # j++
   blt $t1, $a2, e # if(j < ncol) goto e
   la $a0, 10 # Código ASCII para newline ('\n')
   syscall # Pula a linha
   li $t1, 0 # j = 0
   addi $t0, $t0, 1 # i++
   blt $t0, $a1, e # if(i < nlin) goto e
   li $t0, 0 # i = 0
   lw $ra, ($sp) # Recupera o retorno para a main
   addi $sp, $sp, 4 # Libera o espaço na pilha
   
   	###########################################
	print_str " O maior valor acima da diagonal é:  "
   	move $a0, $t6 # Carrega com o maior valor
   	li $v0, 1 # Código de impressão de inteiro
   	syscall # Imprime
   	
   	print_str ". \n O menor valor abaixo da diagonal é: "
   	move $a0, $t7 # Carrega com o menor valor
   	li $v0, 1 # Código de impressão de inteiro
   	syscall # Imprime
   	
   	print_str ". \n A subtração dos elementos acima da diagonal com os elementos abaixo da diagonal é:  "
   	move $a0, $t5 # Carrega com a soma
   	li $v0, 1 # Código de impressão de inteiro
   	syscall # Imprime
   	
      	###########################################
   move $v0, $a3 # Endereço base da matriz para retorno
   jr $ra # Retorna para a main 
   
      	###########################################
      	
   cimabaixo:
   	blt $t0, $t1, cima  	# i < j (acima da diagonal)
   	blt $t1, $t0, baixo	# i > j (abaixo da diagonal)
	j volta
	
   cima:
   	add $t5, $t5, $t2
   	blt $t2, $t6, men	# entra se for maior
	move $t6, $t2		# seta como o maior 
	men:
   	j volta
   
   baixo:
   	sub $t5, $t5, $t2
   	bgt $t2, $t7, mai	# entra se for menor
	move $t7, $t2		# seta como o menor 
	mai:
   	j volta
   
   end:
      	li $v0, 10 # Código para finalizar o programa
      	syscall # Finaliza o programa
	
	###########################################
		
	pulalinha:
		pulin
	j volt
