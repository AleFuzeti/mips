.include "macros.asm"

.data
buffer: .asciiz " "
Vetor: .asciiz "/home/fuzeti/Imagens/mips/Arq2/2 bim/vetor.txt"
Aux: .asciiz "/home/fuzeti/Imagens/mips/Arq2/2 bim/aux.txt"

.text
main:
    	Abertura:
    		arquivoLeitura(Vetor)		# Seta para leitura
    		abrirArquivo($s0)        		# Abre o arquivo
    		arquivoEscrita(Aux)		# Seta para escrita
    		abrirArquivo($s1)        		# Abre o arquivo
    		
    		move $a0, $s0	         	# Move o descritor para $a0
    		la $a1, buffer              		# Endereço do buffer
    		li $a2, 1                   		# Caractere por leitura/escrita
 	
 	le_i:
 		print_str "Digite o i: "
 		ler_int
 		move $t1, $v0
 		pulin
 	
    	Leitura:
    		la $a1, buffer              		# Endereço do buffer
    		move $a0, $s0			# File descriptor leitura
    		
     		li $v0, 14				# Leitura de arquivo
    		syscall					# Syscall
    		beqz $v0, Encerramento	# Verifica se acabou
    		addi $t2, $t2, 1
    		lb  $t0, ($a1)				# Carrega o byte do caractere
    		verifica_espaco($t0,espaco)
    		
	Escrita:
		move $a0, $s1			# File descriptor escrita
		li $v0, 15				# Imprimir
		syscall					# Syscall
		j Leitura
	espaco:
	    	addi $t4, $t4, 1
	    	bne $t4, $t1, Escrita
    		move $t3, $t2
    		subi $t3, $t3, 1
    		j Escrita
    		
       	Encerramento:
		move $a0, $s1			# File descriptor escrita
    	    	fecharArquivo()			# Fecha o arquivo
		move $a0, $s0			# File descriptor leitura
    	    	fecharArquivo()			# Fecha o arquivo
    	    	
    	Abertura2:
    		arquivoLeitura(Aux)		# Seta para leitura
    		abrirArquivo($s0)        		# Abre o arquivo
    		arquivoEscrita(Vetor)		# Seta para escrita
    		abrirArquivo($s1)        		# Abre o arquivo
    		
    		move $a0, $s0	         	# Move o descritor para $a0
    		la $a1, buffer              		# Endereço do buffer
    		li $a2, 1                   		# Caractere por leitura/escrita
    		
    		li $t2, 0					# Reseta contador
    		
    	Leitura2:
    		la $a1, buffer              		# Endereço do buffer
    		move $a0, $s0			# File descriptor leitura
    		
     		li $v0, 14				# Leitura de arquivo
    		syscall					# Syscall
    		beqz $v0, Encerramento2	# Verifica se acabou
    		addi $t2, $t2, 1
    		lb  $t0, ($a1)				# Carrega o byte do caractere
    		
	Escrita2:
		beq $t2, $t3, mudai
		move $a0, $s1			# File descriptor escrita
		li $v0, 15				# Imprimir
		syscall					# Syscall
		j Leitura2
		
	mudai:
		addi $t0, $t0, 1
	    	sb  $t0, ($a1)			# Carrega o byte do caractere
	    	lb  $t0, ($a1)				# Carrega o byte do caractere

		move $a0, $s1			# File descriptor escrita
		li $v0, 15				# Imprimir
		syscall					# Syscall
		j Leitura2
   	   	
       	Encerramento2:
		move $a0, $s1			# File descriptor escrita
    	    	fecharArquivo()			# Fecha o arquivo
		move $a0, $s0			# File descriptor leitura
    	    	fecharArquivo()			# Fecha o arquivo 
    	    	   	    	
    	    	done					# Sai do programa
