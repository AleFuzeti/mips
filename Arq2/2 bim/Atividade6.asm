.include "macros.asm"

.data
buffer: .asciiz " "
Arquivo: .asciiz "/home/fuzeti/Imagens/mips/Arq2/2 bim/dados.txt"

.text
main:
    	Abertura:
    		arquivoLeitura(Arquivo)	# Seta para leitura
    		abrirArquivo($s0)        		# Abre o arquivo
    		move $a0, $s0             	# Move o descritor para $a0
    		la $a1, buffer              		# Endereço do buffer
    		li $a2, 1                   		# Caractere por leitura
 	
	Variaveis:
     	    	li $t3, 1600				# Tamanho vetor ordenado
    		dinamic($t3)				# Vetor para ordenação
    		move $s5, $v0			# Endereço
    		li $t3, 0					# Variavel auxiliar
    		
    		move $a0, $s0             	# Move o descritor para $a0
    		
    		li $s0, -100000			# Variavel maior valor
    		li $s1,  100000			# Variavel menor valor
		li $s6, 1					# Variavel produto
		li $t2, 1					# Variavel numero negativo

    	    	Leitura:
     		li $v0, 14				# Leitura de arquivo
    		syscall					# Syscall
    		beqz $v0, fimLeitura		# Verifica se acabou
    		
    		addi $s7, $s7, 1			# Conta o caractere
    		lb  $t0, ($a1)				# Carrega o byte do caractere
   		verifica_espaco($t0, funcoes)# Verifica se é \n \r ou espaço
   		
   		bne $t0, 45, pos			# Compara com sinal de " -"
   		li $t2, -1					# Seta variavel de negativo
		addi $t9, $t9, 1			# Conta o caractere
   		j Leitura
   		pos:

    		subi $t0, $t0, 48			# Tranforma em inteiro
    		mul $t1, $t1, 10			# Transforma em dezena
    		add $t1, $t1, $t0			# Soma a unidade lida
		addi $t9, $t9, 1			# Conta o caractere
		
    		bne $t1, $zero, Leitura	# Se o valor lido for 0
	    	jal TodasFuncoes		# Chama as funcoes
    		j Leitura
    		
    		funcoes:
    	    	mul $t1, $t1, $t2			# Multiplica pela variavel de negativo
	    	jal TodasFuncoes		# Chama as funcoes
		
            	li $t1, 0               			# Reseta o valor lido
            	li $t2, 1					# Reseta a variavel para negativo
            	j Leitura
		
		
    		fimLeitura:
   	   	verifica_espaco($t0, Next) # Verifica se é \n \r ou espaço
   	    	beq $t1, $zero, Next		# Verifica se é zero erroneamente
    	    	mul $t1, $t1, $t2			# Multiplica pela variavel de negativo
	    	jal TodasFuncoes		# Chama as funcoes
    	    	Next:
    	    	
    	MaiorValor:
    	    	print_str "a) Maior valor do arquivo: "
            	print_int $s0         
            	pulin
       	MenorValor:
            	print_str "b) Menor valor do arquivo: "
            	print_int $s1         
            	pulin
        Soma:
    	    	print_str "c) Soma dos numeros do arquivo: "
            	print_int $s2   
            	pulin         
        NumImpar:  	
    	    	print_str "d) Quantidade de numeros ímpares: "
            	print_int $s3   
            	pulin         
        NumPar:  	
    	    	print_str "e) Quantidade de numeros pares: "
            	print_int $s4   
            	pulin         
        Decrescente:  	
    	    	print_str "f) Numeros em ordem decrescente: "
            	jal printa_ordenado 
            	pulin         
        Produto:
    	    	print_str "g) Produto dos numeros: "
            	print_int $s6   
            	pulin         
        NumeroCaracteres:
    	    	print_str "h) Numero total de caracteres: "
            	print_int $s7  
            	pulin         
    	    	print_str "   Numero de caracteres sem espacos: "
            	print_int $t9
            	pulin         
       	Encerramento:
    	    	fecharArquivo()			# Fecha o arquivo
    	    	done					# Sai do programa


TodasFuncoes:
	stack_pointer()				# Salva retorno
	        
	Maior($s0, $t1)				# Maior valor
    	Menor($s1, $t1)				# Menor valor 
    	add $s2, $s2, $t1				# Soma dos números
	Impar($s3, $t1)				# Quantidade de impares
	Par($s4, $t1)					# Quantidade de pares
  	jal Ordena					# Ordena
  	mul $s6, $s6, $t1				# Multiplica
  	retorna()						# Retorna
  	
Ordena:
	stack_pointer()				# Salva retorno
	addi $t3, $t3, 1				# Soma o contador em 1
	li $t4, -4						# Inicia o auxiliar
	move $t7, $t1				# Variavel com valor lido
	move $t8, $t3				# Variavel com num de elem lidos
	mul $t8, $t8, 4				# Total de espaco usado no vetor
	ord:
	addi $t4, $t4, 4				# Soma o auxiliar pra proxima posiçao
	bgt $t4, $t8, pula				# Continua até passar todos os elementos
	move $t5, $s5				# Endereço base
	add $t5, $t5, $t4				# Endereco na posicao
	lw $t6, ($t5)					# Carrega o numero
	bltz $t7, negat
	ble $t7, $t6, ord				# Troca a posicao se necessario
	sw $t7, ($t5)					# Salva o num
	move  $t7, $t6				# Ajeita para proxima posicao
	j ord
	
	negat:
	bnez $t6, ord
	sw $t7, ($t5)					# Salva o num
	move  $t7, $t6				# Ajeita para proxima posicao
	j ord
	pula:

  	retorna()						# Retorna
  	
  	
printa_ordenado:
	stack_pointer()				# Salva retorno
	li $t4, -4						# Inicia o auxiliar
	move $t8, $t3				# Variavel com num de elem lidos
	mul $t8, $t8, 4				# Total de espaco usado no vetor
	printa:
	addi $t4, $t4, 4				# Soma o auxiliar pra proxima posiçao
	bge $t4, $t8, jump			# Continua até passar todos os elementos
	move $t5, $s5				# Endereço base
	add $t5, $t5, $t4				# Endereco na posicao
	lw $t6, ($t5)					# Carrega o numero
	print_int $t6					# Printa o num
	space
	j printa
	jump:
	retorna()						# Retorna
	
