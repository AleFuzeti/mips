.include "macros.asm"

.data
buffer: .asciiz " "
msg: .asciiz "*"
Entrada: .asciiz "/home/fuzeti/Imagens/mips/Arq2/2 bim/entrada.txt"
Saida: .asciiz "/home/fuzeti/Imagens/mips/Arq2/2 bim/saida.txt"

.text

main:
    	Abertura:
    		arquivoLeitura(Entrada)	# Seta para leitura
    		abrirArquivo($s0)        		# Abre o arquivo
    		arquivoEscrita(Saida)		# Seta para escrita
    		abrirArquivo($s1)        		# Abre o arquivo
    		
    		move $a0, $s0	         	# Move o descritor para $a0
    		la $a1, buffer              		# Endereço do buffer
    		li $a2, 1                   		# Caractere por leitura/escrita
 	
    	Leitura:
    		la $a1, buffer              		# Endereço do buffer
    		move $a0, $s0			# File descriptor leitura
    		
     		li $v0, 14				# Leitura de arquivo
    		syscall					# Syscall
    		beqz $v0, Encerramento	# Verifica se acabou
    		
    		lb  $t0, ($a1)				# Carrega o byte do caractere
    		jal verifica_vogal
		
	Escrita:
		move $a0, $s1			# File descriptor escrita
		li $v0, 15				# Imprimir
		syscall					# Syscall
		j Leitura
   	
   		vog:
			move $a0, $s1		# File descriptor escrita
			la $a1, msg			# Asterisco
			li $v0, 15			# Imprimir
			syscall				# Syscall
			j Leitura

       	Encerramento:
		move $a0, $s1			# File descriptor escrita
    	    	fecharArquivo()			# Fecha o arquivo
		move $a0, $s0			# File descriptor leitura
    	    	fecharArquivo()			# Fecha o arquivo
    	    	done					# Sai do programa

verifica_vogal:
    	stack_pointer()				# Stack pointer
       	beq $t0, 65, vog				# A
	beq $t0, 69, vog				# E
        beq $t0, 73, vog				# I
        beq $t0, 79, vog				# O
        beq $t0, 85, vog				# U
        beq $t0, 97, vog				# a
        beq $t0, 101, vog				# e
        beq $t0, 105, vog				# i
        beq $t0, 111, vog				# o
        beq $t0, 117, vog   			# u
        retorna()						# Retorno