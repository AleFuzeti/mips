.include "macros.asm"
.data
Buffer: .space 20	
linha: .asciiz "/r/n"
Arquivo: .ascii "/home/fuzeti/Imagens/mips/Arq2/2 bim/gemeos.txt"
.text

main:
    	Abertura:
	    	arquivoEscrita(Arquivo)	# Seta para escrita
    		abrirArquivo($s0)        		# Abre o arquivo   		    	

	le_n:				
		print_str "digite N: "		# Printa a string
		ler_int					# Le o n
		blt $v0, 3, menor_que_3	# Verifica se n > 2 
		move $s1, $v0			# Salva n
		pulin
		
	gemeo:
		move $a0, $s0			# Salva o file descriptor
		jal escreveGemeo		# Vai para a função
		move $a0, $s0			# Salva o file descriptor

       	Encerramento:
    	    	fecharArquivo()			# Fecha o arquivo
    	    	done					# Sai do programa
	
intstring:
	div $a0, $a0, 10				# Divide por 10
	mfhi $t0						# Pega o resto
	subi $sp, $sp, 4				# Ajusta o stack pointer
	sw $t0, ($sp)					# Salva no stack
	addi $v0, $v0, 1				# Soma 1 em v0
	bnez $a0, intstring			# Loop
i:	lw $t0, ($sp)					# Carrega o stack
	addi $sp, $sp, 4				# Ajusta de volta o stack
	add $t0, $t0, 48				# Transforma em string
	sb $t0, ($a1)					# Salva no a1
	addi $a1, $a1, 1				# Soma o endereço em 1
	addi $t1, $t1, 1				# Atualiza t1
	bne $t1, $t0, i				# condição de loop
	sb $zero, ($a1)				# Salva 0 em a1
	jr $ra						# Volta
	
escreveGemeo:
	move $t2, $ra				# Salva o end de retorno
	
	li $t0, 3						# Carrega 3 
	print_int $t0
	space
	jal escreve_arquivo			# Printa no arquivo

	li $t5, 4						# Inicia o aux em 4
e:	
	bgt $s4, $s1, s				# Para se passar o N
	addi $s4, $s4, 1				# t4++
	
	addi $t5, $t5, 1				# Iteracao externa
	
	bgt $t5, $s1, s				# Condicao de parada
		li $t6, 2					# Aux interno
		loop1:					# Loop interno
		div $t5, $t6				# Verifica se eh primo
		mfhi $t7					# Resto
		beqz $t7, e				# Se nao for primo
		addi $t6, $t6, 1			# Iteracao interna
		div $a3, $t5, 2			# faz t5/2
		blt $t6, $a3, loop1		# Condicao de parada
		
	move $s3, $t5				# Val2
	sub $t4, $s3, $s2				# Verifica se val2 eh val1 + 2
	beq $t4, 2, printa				# Printa
	move $s2, $s3				# Val1 = val2

	blt $t5, $s1, e				# Condicao de parada
	j s

printa:
	print_int $s2
	space
	print_int $s3
	space
	move $t0, $s2				# Val1 
	jal escreve_arquivo
	move $t0, $s3				# Val2
	jal escreve_arquivo
	
	j e
s:	jr $t2
	
menor_que_3:
	print_str "N deve ser maior que 2\n"
	j le_n

escreve_arquivo:
	move $t9, $ra				# Retorno
	move $a0, $t0				# Valor
	la $a1, Buffer				# Buffer
	li $v0, 0						# Seta v0
	li $t1, 0						# Seta t1
	jal intstring					# Transforma
	move $a0, $s0				# File descriptor
	la $a1, Buffer				# Buffer
	move $a2, $v0				# Num caracteres
	li $v0, 15					# Imprimir
	syscall						# Syscall
	
	la $a1, linha
	li $a2, 2						# Num caracteres
	li $v0, 15					# Imprimir
	syscall						# Syscall
	
	jr $t9
