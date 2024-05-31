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
		jal escreveGemeo
		move $a0, $s0

       	Encerramento:
    	    	fecharArquivo()			# Fecha o arquivo
    	    	done					# Sai do programa
	
intstring:
	div $a0, $a0, 10
	mfhi $t0
	subi $sp, $sp, 4
	sw $t0, ($sp)
	addi $v0, $v0, 1
	bnez $a0, intstring
i:	lw $t0, ($sp)
	addi $sp, $sp, 4
	add $t0, $t0, 48
	sb $t0, ($a1)
	addi $a1, $a1, 1
	addi $t1, $t1, 1
	bne $t1, $t0, i
	sb $zero, ($a1)
	jr $ra
	
escreveGemeo:
	move $t2, $ra
	
	li $s2, 3
	print_int $s2
	space
	li $s2, 4
	
	li $t0, 4						# Aux externo
	loop:						# Loop externo
	addi $t0, $t0, 1				# Iteracao externa
	bgt $t0, $s1, e
		li $t1, 2					# Aux interno
		loop1:					# Loop interno
		div $t0, $t1
		mfhi $t2
		beqz $t2, loop
		addi $t1, $t1, 1			# Iteracao interna
		blt $t1, $t0, loop1
		
	move $s3, $t0
	sub $t4, $s3, $s2
	beq $t4, 2, printa
	move $s2, $s3

	blt $t0, $s1, loop
	j e
	
	printa:
	print_int $s2
	space
	print_int $s3
	space
	move $s2, $s3
	blt $t0, $s1, loop
	
e:	li $v0, 5
	syscall
	blez $v0, s
	
	andi $t0, $v0, 1
	bnez $t0, e
	
	move $a0, $v0
	la $a1, Buffer
	li $v0, 0
	li $t1, 0
	jal intstring
	move $a0, $s0
	la $a1, Buffer
	move $a2, $v0
	li $v0, 15
	syscall
	la $a1, linha
	li $a2, 2
	li $v0, 15
	syscall
	j e
s:	jr $t2
	
	
menor_que_3:
	print_str "N deve ser maior que 2\n"
	j le_n
