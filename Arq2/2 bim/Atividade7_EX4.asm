.include "macros.asm"
.data
# Arquivos
    	Entrada: .asciiz "/home/fuzeti/Imagens/mips/Arq2/2 bim/entrada.txt"
    	Saida: .asciiz "/home/fuzeti/Imagens/mips/Arq2/2 bim/saida.txt"
# Descriptor   
	descriptor: .word 0
    	fim_descriptor: .word 0
# Simbolos para escrita
    	buffer: .asciiz " "
      	pula_linha: .asciiz "\n"
    	espaco: .asciiz " "
	um: .asciiz "1"
    	zero: .asciiz "0"
# Vetor / Matriz 
    	inicio_vetor: .word 0
    	fim_vetor: .word 0
    	inicio_matriz: .word 0
    	tamanho_matriz: .word 0
    	colunas_matriz: .word 0
    	instrucao: .word 0

.text	
main:
	Tratamento_Arquivos:		
		arquivoLeitura(Entrada)	# Seta para leitura
    		abrirArquivo($s0)        		# Abre o arquivo
        	move $a0, $s0 			# File descriptor
        	sw $s0, descriptor		# Salva
        	la $a1, buffer 			# Buffer
        	li $a2, 1 					# 1 char por leitura
        	sw $sp, inicio_vetor		# Inicio do vetor
        	li $k0, 0
        	
        leitura:
        	li $v0, 14 				# Codigo de leitura de arquivo
        	syscall 					# Faz a leitura de 1 caractere
        	beqz $v0, l 				# if (EOF) termina a leitura
        	lb $t0, ($a1) 				# Carrega o caractere lido no buffer
        	beq $t0, 13, leitura 		# if (carriage return) ignora return) ignora
        	beq $t0, 32, l 			# if (espaco ignora)
        	beq $t0, 10, l 			# if (newline) goto l
        	
        	subi $t0,$t0, 48 			# Char para decimal
        	mul $t1, $t1, 10 			# Casa decimal para a esquerda
        	add $t1, $t1, $t0 			# soma a unidade lida
        	j leitura	

	l:	add $t2, $t2, $t1 			# Soma o numero lido
        	sw $t1, ($sp)				# Salva no stack pointer
        	sw $sp, fim_vetor		# Salva o fim do vetor
        	addi $sp, $sp, -4			# Uma posicao na pilha
        	li $t1, 0 					# Zera o numero
        	bnez $v0, leitura 			# Leitura do proximo numero
       
        	lw $a0, descriptor		# File descriptor para $a0
        	li $v0, 16
        	syscall
        
        	jal Aloca_Matriz			# Preparando uma matriz, alocando memoria
        	jal Transforma_matriz	# Inserindo os valores 0's e 1's na matriz
        	jal Escreve_Arquivo		# Passando para o arquivo
        
        	done 					# Encerra o programa

Aloca_Matriz:
    	lw $t0, inicio_vetor
    	lw $t1, ($t0) 					# Linhas
    	add $t0, $t0, -4
    	lw $t2, ($t0) 					# Colunas
    	add $t0, $t0, -4
    	sw $t0, instrucao
    	sw $a0, colunas_matriz 		# Salva o numero de elementos
    	mul $a0, $t1, $t2 				# Total de elementos
    	sw $a0, tamanho_matriz 		# Salva o numero de elementos
    	mul $a0, $a0, 4 				# Total de bytes
    	li $v0, 9 						# Codigo de alocacao de memoriaia
    	syscall						# Alocamos memória
    	sw $v0, inicio_matriz

    	li $t0, 0 						# Zera o contador
    	lw $t1, tamanho_matriz 		# Limite
    	li $t2, 1 						# O que vai em cada posicao

    	loop_inicio:					# Loop
        	sw $t2, ($v0)
        	add $v0, $v0, 4
        	add $t0, $t0, 1
        	blt $t0, $t1, loop_inicio

jr $ra 							# Retorna para a main

Transforma_matriz:
    	lw $s0, instrucao

    	lw $s1, ($s0) 				# Numero total de operacoes
    	add $s0, $s0, -4
    	li $s2, 0 						# Posicoes zeradas sao marcadas com zero 
    	li $s3, 0 						# Contagem de operacoes

    	loop_transforma:
        lw $t2, ($s0) 					# i
        add $s0, $s0, -4
        lw $t3, ($s0)					# j
        add $s0, $s0, -4

	li $v0, 0

        indice(inicio_matriz, colunas_matriz, $t2, $t3)
        sw $s2, ($v0)
        add $s3, $s3, 1
        blt $s3, $s1, loop_transforma

jr $ra 							# Retorna para a main

Escreve_Arquivo:
    	la $a0, Saida 				# Nome do arquivo
    	li $a1, 1 						# Somente escrita
    	li $v0, 13 					# Codigo de abertura de arquivo
    	syscall 						# Tenta abrir o arquivo
    	move $a0, $v0 				# Parametro file descriptor

	sw $a0, fim_descriptor
    	lw $s0, inicio_matriz
    	lw $s1, tamanho_matriz
    	li $s2, 0 						# Contador posicoes
    	li $s3, 0 						# Contador de formato
    	lw $s4, colunas_matriz

    	loop_escreve:
        	lw $t0, ($s0) 				# Valor da posicao
        	beq $t0, 0, coloca_zero
        	beq $t0, 1, coloca_um

        coloca_zero:
            la $a1, zero 				# Carrega o endereco da string zero
            j continua_escrita

        coloca_um:
            la $a1, um 				# Carrega o endereco da string um
            j continua_escrita

        continua_escrita:
            li $v0, 15
            lw $a0, fim_descriptor
            li $a2, 1 					# 1 caractere por escrita
            syscall
            li $v0, 15
            lw $a0, fim_descriptor
            la $a1, espaco 			# Carrega o endereco da string espaco
            li $a2, 1 					# 1 caractere por escrita
            syscall

        add $s2, $s2, 1
        add $s3, $s3, 1
        beq $s3, $s4, prox_linha
        j nxt

        prox_linha:
	    li $v0, 15
            lw $a0, fim_descriptor
            la $a1, pula_linha 			# Carrega o endereco da string espaco
            li $a2, 1 					# 1 caractere por escrita
            syscall
            li $s3, 0 					# Zera o contador de formato
	nxt:
        add $s0, $s0, 4
        blt $s2, $s1, loop_escreve

jr $ra							# Retorna para a main
