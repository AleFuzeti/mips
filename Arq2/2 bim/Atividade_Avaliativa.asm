.data
ErroMenor: .asciiz " Ordem invalida, minimo é 2"
ErroMaior: .asciiz " Ordem invalida, maximo é 5"

Ent0: .asciiz " Insira a ordem da matriz (max 5): "
Ent1: .asciiz " Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "

Produto: .asciiz "\n O produto do menor elemento ímpar pelo maior elemento par eh: "
SomaLinhas: .asciiz "\n A soma dos indices das linhas eh: "

.text
main:  
	LeOrdem:
		li $v0, 4					# Codigo p/ printar string
		la $a0, Ent0				# Carrega a string
		syscall					# Syscall
		li $v0, 5					# Codigo p/ ler inteiro
		syscall					# Syscall
		
	InicializaVariaveis:
   		move $t2, $v0 			# Ordem
   		move $a1, $v0			# Linhas
     		move $a2, $v0			# Colunas
		li $t1, 1 					# j = 1  
		li $t0, 1 					# i = 1  	
		li $s0, 99999				# Menor impar
		li $s2, -99999				# Maior par

	ConfereOrdem:
   		bge $t2, 2, ok1 			# Encerra se a ordem for menor que 2
   		li $v0, 4					# Codigo p/ printar string
		la $a0, ErroMenor		# Carrega a string
		syscall					# Syscall
		j end					# Finaliza
		ok1:
   		ble $t2, 5, ok2 			# Encerra se a ordem for maior que 5
   		li $v0, 4					# Codigo p/ printar string
		la $a0, ErroMaior			# Carrega a string
		syscall					# Syscall
		j end					# Finaliza
   		ok2:
   		
   	CriaMatriz:
   		mul $t2, $t2, $t2			# Numero de elementos
   		mul $t2, $t2, 4			# Tamanho de inteiros			
   		add $a0, $zero, $t2		# Move para o a0
   		li $v0, 9					# Codigo para alocacao de memoria
		syscall					# Syscall
		move $a0, $v0			# Endereco da matriz
		
	LeMatriz:
		jal le_mat
	
	Multiplicacao:
		mul $s0, $s0, $s2		# Multiplicacao do menor impar e do maior par
		li $v0, 4					# Codigo p/ printar string
		la $a0, Produto			# Carrega a string
		syscall					# Syscall		
		move $a0, $s0 			# Produto do menor impar e do maior par
		li $v0, 1 					# Código de impressão de inteiro
		syscall					# Syscall
	
	IndiceLinhas:
		add $s1, $s1, $s3		# Soma dos indices das linhas
 		li $v0, 4					# Codigo p/ printar string
		la $a0, SomaLinhas		# Carrega a string
		syscall					# Syscall		
		move $a0, $s1 			# Soma dos indices das linhas
		li $v0, 1 					# Código de impressão de inteiro
		syscall					# Syscall
	
	Fim:
		j end
		
indice:
	mul $v0, $t0, $a2 			# i * ncol
	add $v0, $v0, $t1 				# (i * ncol) + j
	sll $v0, $v0, 2				# [(i * ncol) + j] * 4 (inteiro)
	add $v0, $v0, $a3				# Soma o endereço base de mat
	jr $ra						# Retorna para o caller
   
le_mat:
	subi $sp, $sp, 4 				# Espaço para 1 item na pilha
	sw $ra, ($sp)				# Salva o retorno para a main
	move $a3, $a0				# aux = endereço base de mat

	l: la $a0, Ent1 				# Carrega o endereço da string
	li $v0, 4 						# Código de impressão de string
	syscall						# Syscall
	move $a0, $t0 				# Valor de i para impressão
	li $v0, 1 						# Código de impressão de inteiro
	syscall						# Syscall
	la $a0, Ent2 					# Carrega o endereço da string
	li $v0, 4 						# Código de impressão de string
	syscall						# Syscall
	move $a0, $t1 				# Valor de j para impressão
	li $v0, 1 						# Código de impressão de inteiro
	syscall						# Syscall
	la $a0, Ent3 					# Carrega o endereço da string
	li $v0, 4 						# Código de impressão de string
	syscall						# Syscall
	
	li $v0, 5 						# Código de leitura de inteiro
	syscall 						# Leitura do valor 
	move $t2, $v0 				# aux = valor lido
   	
   	j verifica
   	verificado:
   	
	jal indice 					# Calcula o endereço de mat[i][j]
	sw $t2, ($v0) 				# mat [ i ] [ j ] = aux
	addi $t1, $t1, 1 				# j++
	ble $t1, $a2, l 				# if(j < ncol) goto l
	li $t1, 1 						# j = 1
	addi $t0, $t0, 1 				# i++
	ble $t0, $a1, l 				# if(i < nlin) goto l
	li $t0, 1 						# i = 1
	lw $ra, ($sp) 					# Recupera o retorno para a main
	addi $sp, $sp, 4 				# Libera o espaço na pilha
	move $v0, $a3 				# Endereço base da matriz para retorno
	jr $ra 						# Retorna para a main
		
verifica:
	li $t3, 2						# Aux para divisao
	div $t2, $t3					# Divide por 2
	mfhi $t3						# Resto da divisao
	beqz $t3, par					# Verifica se eh par ou impar
	
	impar:
	bge  $t2, $s0, verificado		# Entra so o menor impar
	move $s0, $t2				# Salva o menor impar
	move $s1, $t0				# Salva o num da linha
	j verificado
	
	par:
	blt $t2, $s2, verificado			# Entra so o maior par
	move $s2, $t2				# Salva o maior par
	move $s3, $t0				# Salva o num da linha
	j verificado
	
end:
	li $v0,10						# Finaliza o programa
	syscall						# Syscall
	
