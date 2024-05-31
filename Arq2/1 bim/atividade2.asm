# Programa que faz a leitura e escrita de uma matriz de inteiros de ordem até 10x10

# entre os ########## estão os códigos que fiz

.data
Mat: .space 400 # max 10x10 * 4 (inteiro)
Ent1: .asciiz " Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "

	###########################################
EntIni:   .asciiz " Insira a ordem da matriz (max 10):"
EntMenor: .asciiz " O menor valor lido da matriz é: "
EntImpar: .asciiz ". A linha com o maior valor ímpar é a linha "
EntImpar2:.asciiz " com o valor: "
SemImpar: .asciiz " A matriz não possui números ímpares."
	###########################################

.text
main:  
	###########################################
	la $a0, EntIni #carrega a string
	li $v0, 4 # Código de impressão de string
   	syscall # Imprime a string 
   	li $v0, 5 # Código de leitura de inteiro
   	syscall # Leitura do valor (retorna em $v0)
   	move $t2, $v0 # aux = valor lido
   	
   	ble $t2, 0, end # encerra se a ordem for menor ou igual a 0
   	
	###########################################
	
      la $a0, Mat # Endereço base de Mat
      move $a1, $t2 # Número de linhas
      move $a2, $t2 # Número de colunas
      jal leitura # leitura(mat, nlin, ncol)
      move $a0, $v0 # Endereço da matriz lida
      jal escrita # escrita(mat, nlin, ncol)
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
        li $t7, 30000 # seta um valor bem grande
        li $t6, -30000# seta um valor bem pequeno
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
   	j nlmaiorimpar
   	par:
   	
   	j menor
   	maior:
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
   
escrita:
   subi $sp, $sp, 4 # Espaço para 1 item na pilha
   sw $ra, ($sp) # Salva o retorno para a main
   move $a3, $a0 # aux = endereço base de mat
e: jal indice # Calcula o endereço de mat[i][j]
   lw $a0, ($v0) # Valor em mat[i][j]
   li $v0, 1 # Código de impressão de inteiro
   syscall # Imprime mat[i][j]
   la $a0, 32 # Código ASCII para espaço
   li $v0, 11 # Código de impressão de caractere
   syscall # Imprime o espaço
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
   	la $a0, EntMenor #carrega a string
	li $v0, 4 # Código de impressão de string
   	syscall # Imprime a string 
   	move $a0, $t7 # Carrega com o menor valor
   	li $v0, 1 # Código de impressão de inteiro
   	syscall # Imprime
   	
   	bne $t6, -30000, ip #entra se não tivr nenhum impar
   	la $a0, SemImpar #carrega a string
	li $v0, 4 # Código de impressão de string
   	syscall # Imprime a string 
   	j p
   	
   	ip:
   	la $a0, EntImpar #carrega a string
	li $v0, 4 # Código de impressão de string
   	syscall # Imprime a string 
   	move $a0, $t4 # Carrega com o menor valor
   	li $v0, 1 # Código de impressão de inteiro
   	syscall # Imprime
   	
   	la $a0, EntImpar2 #carrega a string
	li $v0, 4 # Código de impressão de string
   	syscall # Imprime a string 
   	move $a0, $t6 # Carrega com o menor valor
   	li $v0, 1 # Código de impressão de inteiro
   	syscall # Imprime
   	p:
   	###
   move $v0, $a3 # Endereço base da matriz para retorno
   jr $ra # Retorna para a main $
   
      	###########################################
   menor:
   	bge $t2, $t7, maior #só entra se for menor
   	move $t7, $t2 # move o valor para $t7
  	j maior
   
   nlmaiorimpar:
	li $t5, 2	# carrega 2 em $t5
   	div $t2, $t5 	# divide o numero por 2 (resto: HI)
	mfhi $t5	# carrega o resto em $t6
	bne $t5, 1, par # volta se for par
	
	ble $t2, $t6, mn# entra só se for maior
	move $t6, $t2   # carrega o valor de $t2 em $t6
	move $t4, $t0   # carrega o valor da linha
	mn:
	j par		# volta
	
   end:
      	li $v0, 10 # Código para finalizar o programa
      	syscall # Finaliza o programa
	
	###########################################
	
