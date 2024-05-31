#	Indice
#	
#	Alocar memoria		- 10 	|	Conversao			- 120
#	Stackpointer			- 17		|	Iteração matriz		- 145
#	Leitura				- 28		|	Aritmetica			- 159
#	Impressao			- 45		|	Arquivos tratamento	- 210
#	Utilidades			- 74		|	Arquivos operacoes	- 237
#	Par e impar			- 100	|

# macro para alocar memoria
	.macro dinamic(%x)
		add $a0, $zero, %x
		li $v0, 9
		syscall
	.end_macro

# macros para stackpointer
	.macro stack_pointer()
	   	subi $sp, $sp, 4 		
	   	sw $ra, ($sp) 		
	.end_macro 
	.macro retorna()
 		lw $ra, ($sp) 			
  		addi $sp, $sp, 4 		
  		jr $ra 				
	.end_macro 

# macros para leitura
# inteiro
	.macro ler_int 	
		li $v0, 5	
		syscall	
	.end_macro 
# float
	.macro ler_flt 	
		li $v0, 6	
		syscall	
	.end_macro 
# char
	.macro ler_char			
		li $v0 12
		syscall 
	.end_macro 

# macros para impressao
# inteiro
	.macro print_int (%x) 		
		li $v0, 1
		add $a0, $zero, %x
		syscall
	.end_macro
# float
	.macro print_flt (%x) 		
		li $v0, 2
		mov.s $f12, %x
		syscall
	.end_macro
# char
	.macro print_char (%c) 	
		li $v0, 11
		add $a0, $zero, %c
		syscall
	.end_macro
# string
	.macro print_str (%str) 	
		.data
		myLabel: .asciiz %str
		.text
		li $v0, 4
		la $a0, myLabel
		syscall
	.end_macro

# macros para utilidades
# pular linha
	.macro pulin
		print_char '\n'
	.end_macro
# espaco
	.macro space
		print_char ' '
	.end_macro
# mensagem de erro
	.macro erro
		pulin
		print_str("\n!!erro!!\n")
		pulin
		done
	.end_macro
# finalizar programa
	.macro done		
		li $v0,10
		syscall
	.end_macro





# macros para par e impar
# impar
	.macro Impar(%cont, %num)
		li $v0, 2
		div %num, $v0
		mfhi $v0
		beqz $v0, par
		addi %cont, %cont, 1
		par:
	.end_macro 
# par
	.macro Par(%cont, %num)
		li $v0, 2
		div %num, $v0
		mfhi $v0
		bnez $v0, impar
		addi %cont, %cont, 1
		impar:
	.end_macro 

# macros para conversao
# inteiro -> float
	.macro int_flt(%int,%flt)
		mtc1 %int, %flt
		cvt.s.w %flt, %flt
	.end_macro
# float -> inteiro
	.macro flt_int(%flt,%int)
		cvt.w.s %flt, %flt
		mfc1 %int, %flt
	.end_macro
	
	
	
	
	
# macro para atualizar iteração da matriz
.macro indice(%matrix_start, %matrix_size, %i, %j)
		lw $a2, %matrix_size
		lw $a3, %matrix_start
		mul $v0, %i, $a2 # i * ncol
		add $v0, $v0, %j # (i * ncol) + j
		mul $v0, $v0, 4 # *4 por ser int
		add $v0, $v0, $a3 # Soma o endereco base de mat
.end_macro
# macro para atualizar iteração da matriz
	.macro update_ij (%i, %j, %ni, %nj, %label, %jump)
	      addi %j, %j, 1 # j++
	      blt %j,  %nj, %label # if(j < ncol) goto label
	      li %j, 0 # j = 0
	      addi %i, %i, 1 # i++
	      move $a0, %jump
	      bne $a0, $zero, jump
	      pulin
	      jump:
	      blt %i, %ni, %label # if(i < nlin) goto label
	      li %i, 0 # i = 0
	.end_macro

# macros para aritmetica
# fatorial
	.macro fat (%i, %n, %fat)
		move %i, $zero
		li $a0, 1
		move %fat, $a0 
		FatLoop:
		add %i, %i, 1
		mul %fat, %fat, %i
		blt %i, %n, FatLoop
	.end_macro
# potencia
	.macro pot (%i, %x, %pot, %n)
		move %i, $zero
		add %i, %i, 1
		beq %n, 1,  zr
		PotLoop:
		add %i, %i, 1
		mul.s %pot, %pot, %x
		blt %i, %n, PotLoop
		zr:
	.end_macro





























# macros para tratamento de arquivos
# leitura
	.macro arquivoLeitura(%Arquivo)
    		la $a0, %Arquivo             	
	    	li $a1, 0                   	
	.end_macro 
# escrita
	.macro arquivoEscrita( %Arquivo)
	    	la $a0, %Arquivo             	
	    	li $a1, 1                  	
	.end_macro 
# abertura
	.macro abrirArquivo (%end) 
		j aA
		fecha:
		print_str "\n"
		print_str "Arquivo não encontrado" 
		done
		aA:
		li $v0, 13		
		syscall			
		move %end, $v0
		bltz %end, fecha
		move $a0,$v0
	.end_macro
# encerramento
	.macro fecharArquivo 			
		li $v0, 16
		syscall
	.end_macro

# macros para operacoes em arquivos
# contar caracteres
	.macro contaCaractere (%cont)		
    		cont:
		li $v0, 14                  
    		syscall                     
    		addi %cont, %cont, 1        
    		bnez $v0, cont	          	
    		subi %cont, %cont, 1                
	.end_macro
# maior valor
	.macro Maior(%maior, %lido)
	 	bgt %lido, %maior, Mai
	 	j Nem
	 	Mai:
		move %maior, %lido
		Nem:
	.end_macro 
# menor valor
	.macro Menor(%menor, %lido)
	 	blt %lido, %menor, Men
	 	j nem
	 	Men:
		move %menor, %lido
		nem:
	.end_macro 
# verifica espacos
	.macro verifica_espaco(%lido, %label)
		beq %lido, 32, %label
		beq %lido, 13, %label
		beq %lido, 10, %label
	.end_macro 