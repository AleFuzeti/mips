.include "macros.asm"

.text
main:  

   criamatriz:
      print_str "Insira o numero de linhas: "
      ler_int
      move $s1, $v0 	# s1 = linhas
      ble $s1, $zero, end
      print_str "Insira o numero de colunas: "
      ler_int
      move $s2, $v0 	# s2 = colunas
      ble $s2, $zero, end
      pulin
      jal matriz
      move $s0, $t0

   funcoes:	
      move $a0, $s0 # Endereço base de Mat
      move $a1, $s1 # Número de linhas
      move $a2, $s2 # Número de colunas
   
      matrizentrada:
         jal leitura 		# leitura(mat, nlin, ncol)
         pulin
         print_str "A  matriz de entrada: "
         pulin
         move $a0, $s0 	# Endereço da matriz lida
         jal escrita 		# escrita(mat, nlin, ncol)
	
      vogais:
         pulin
         print_str  "A matriz com as vogais invertidas: "
         pulin
         move $a0, $s0
         jal invertevogais
         move $a0, $s0 	# Endereço da matriz lida
         jal escrita 		# escrita(mat, nlin, ncol)
         move $a0, $s0
         jal invertevogais
         print_str  "O numero de vogais da matriz é: "
         print_int $t4
         pulin

      diagonal:
         bne $s1,$s2, naoquad
         pulin
         print_str "A diagonal principal: "
         move $a0, $s0
         jal quadrada
         pulin
         naoquad:
   
      contacaractere:
         pulin
         move $a0, $s0
         jal contador

      trocas:
         pulin
         print_str  "A matriz com o conteúdo das linhas ímpares trocados: "
         pulin
         move $a0, $s0
         jal trocalinha
         move $a0, $s0
         jal escrita
         move $a0, $s0
         jal trocalinha
         print_str  "A matriz com o conteúdo das colunas pares trocados: "
         pulin
         move $a0, $s0
         jal trocacoluna
         move $a0, $s0
         jal escrita
         move $a0, $s0
         jal trocacoluna
   	
      palindromo:
         pulin
         move $a0, $s0
         jal calculapalindromo
            
      ordena:
      	pulin
      	print_str   "A matriz ordenada: "
      	pulin
      	move $a0, $s0
        jal ordenamatriz
        move $a0, $s0
        jal printaordenado
   done
 
matriz:   	      	
   mul $t0, $s1, $s2
   dinamic($t0) 	# memoria suficiente para a matriz
   move $t0, $v0	# endereço da matriz
   jr $ra

indice:
   mul $v0, $t0, $a2 	# i * ncol
   add $v0, $v0, $t1 	# (i * ncol) + j
   add $v0, $v0, $a3 	# Soma o endereço base de mat
   jr $ra 				# Retorna para o caller
   
leitura:
   subi $sp, $sp, 4 	# Espaço para 1 item na pilha
   sw $ra, ($sp) 		# Salva o retorno para a main
   move $a3, $a0 		# aux = endereço base de mat
   li $t0, 0
   li $t1, 0
   li $s5, 0			# minusculo
   li $s6, 0			# maiusculo	
   li $s7, 0			# simbolos
   l: print_str "Insira o valor de Mat["
      print_int($t0)		# imprime i
      print_str "]["
      print_int($t1)		# imprime j
      print_str  "]: "
      ler_char 
      move $t2, $v0 	# aux = valor lido
       
      bge $t2, 123, sim
      ble $t2, 64, sim
      ble $t2, 90, mai
      bge $t2, 97, min
      j sim
      min:
      addi $s5, $s5, 1
      j next
      mai:
      addi $s6, $s6, 1 
      j next
      sim:
      addi $s7, $s7, 1
      next:
      
      pulin
      jal indice 			# Calcula o endereço de mat[i][j]
      sb $t2, ($v0) 		# mat[i][j] = aux
      update_ij($t0, $t1, $a1, $a2, l, $s1)
      lw $ra, ($sp) 		# Recupera o retorno para a main
      addi $sp, $sp, 4 	# Libera o espaço na pilha
      move $v0, $a3 	# Endereço base da matriz para retorno
      jr $ra 			# Retorna para a main
 
escrita:
   subi $sp, $sp, 4 	# Espaço para 1 item na pilha
   sw $ra, ($sp) 		# Salva o retorno para a main
   move $a3, $a0 		# aux = endereço base de mat
   
   e: jal indice 		# Calcula o endereço de mat[i][j]
      lb $a0, ($v0) 		# Valor em mat[i][j]
      print_char ($a0)
      space
      update_ij($t0, $t1, $a1, $a2, e, $zero) 
      lw $ra, ($sp)		# Recupera o retorno para a main
      addi $sp, $sp, 4 	# Libera o espaço na pilha
      move $v0, $a3 	# Endereço base da matriz para retorno
      jr $ra 			# Retorna para a main      
   
invertevogais:
   subi $sp, $sp, 4 	# Espaço para 1 item na pilha
   sw $ra, ($sp) 		# Salva o retorno para a main
   move $a3, $a0 		# aux = endereço base de mat
   li $t0, 0
   li $t1, 0
   li $t4, 0
   
   i: jal indice 		# Calcula o endereço de mat[i][j]
      lb $a0, ($v0) 	# Valor em mat[i][j]
      verifica:
         beq $a0, 65, vog1 
         beq $a0, 69, vog1 
         beq $a0, 73, vog1 
         beq $a0, 79, vog1
         beq $a0, 85, vog1
         beq $a0, 97, vog2
         beq $a0, 101, vog2
         beq $a0, 105, vog2
         beq $a0, 111, vog2
         beq $a0, 117, vog2    
         j fim
      vog1:
         addi $a0, $a0, 32
         addi $t4, $t4, 1
         j fim
      vog2: 
         subi $a0, $a0, 32
         addi $t4, $t4, 1
         j fim
      fim:
      sb  $a0, ($v0)
      update_ij($t0, $t1, $a1, $a2, i, $s1)
      lw $ra, ($sp) 		# Recupera o retorno para a main
      addi $sp, $sp, 4 	# Libera o espaço na pilha
      move $v0, $a3 	# Endereço base da matriz para retorno
      jr $ra 			# Retorna para a main

quadrada:
   subi $sp, $sp, 4 	# Espaço para 1 item na pilha
   sw $ra, ($sp) 		# Salva o retorno para a main
   move $a3, $a0 		# aux = endereço base de mat
   li $t0, 0
   li $t1, 0
   
   q: jal indice 	# Calcula o endereço de mat[i][j]                                               
      lb $a0, ($v0) 	# Valor em mat[i][j]
      bne $t1, $t0, naodiag										
      print_char $a0
      space
      naodiag:
      update_ij($t0, $t1, $a1, $a2, q, $s1)
      lw $ra, ($sp) 		# Recupera o retorno para a main
      addi $sp, $sp, 4 	# Libera o espaço na pilha
      move $v0, $a3 	# Endereço base da matriz para retorno
      jr    $ra 			# Retorna para a main
      
contador:													
   subi $sp, $sp, 4 	# Espaço para 1 item na pilha
   sw $ra, ($sp) 		# Salva o retorno para a main
   move $a3, $a0 		# aux = endereço base de mat
   li $t0, 0			# i
   li $t1, 0			# j   
   move $t4, $s1 		# numero linhas
   mul $t4, $t4, $s2	# linhas x colunas
   li $t5, 0			# aux
   dinamic($t4)
   move $s3, $v0		#endereço do vetor
       li $s4, 0		# auxiliar para atualizar endereço no vetor
   c: jal indice 	# Calcula o endereço de mat[i][j]
      lb $a0, ($v0) 	# Valor em mat[i][j]
      li $t2, 0		# k
      li $t3, 0		# l
      li $t7, 0		# reseta repeticoes
      c1:
      add $t6, $s0, $t2			# endereco +k
      lb $t5, ($t6)				# aux  = mat[k]
      bne $t5, $a0, diferentes	# compara aux e a0
      addi $t7, $t7, 1			# soma 1 se forem iguais
      diferentes:
      addi $t2, $t2, 1			# k++
      blt $t2, $t4, c1			# volta para c1 
      blt $t7, 3, menosq3		# entra se repete por mais que 3 vezes 
      confere:
      bge $t3, $t4, segue		# se l for menor que num elem
      move $t8, $s3				# end vetor
      add $t8, $t8, $t3			# end vetor mais l
      lb $t9, ($t8)				# elemento do vetor
      addi $t3, $t3, 1			# atualiza l
      beq $t9, $a0, menosq3	# se elemento estiver no vetor, pula
      j confere
      segue:
      move $t8, $s3				# endereco base vetor
      add $t8, $s4, $t8			# aumenta o contador do vetor
      sb $a0, ($t8)				# coloca no vetor
      addi $s4, $s4, 1
      print_char $a0
      print_str " repete por "
      print_int $t7
      print_str " vezes."
      pulin
      menosq3:
      
      update_ij($t0, $t1, $a1, $a2, c, $s1)
      lw $ra, ($sp) 		# Recupera o retorno para a main
      addi $sp, $sp, 4 	# Libera o espaço na pilha
      move $v0, $a3 	# Endereço base da matriz para retorno
      jr    $ra 			# Retorna para a main

trocalinha:
   subi $sp, $sp, 4 		# Espaço para 1 item na pilha
   sw $ra, ($sp) 			# Salva o retorno para a main
   move $a3, $a0 			# aux = endereço base de mat
   
   li $t2, 1				# linha inicial para fazer a troca
   tl: jal indice 			# Calcula o endereço de mat[i][j]
      lb $a0, ($v0) 			# Valor em mat[i][j]
      bne $t0, $t2, naoimpar	# esta na linha pra fazer a troca
      addi $t4, $t0, 3		
      bgt $t4, $s1, naoimpar # i +2 existe
      add $t5, $v0, $s2		# msm j, prox linha
      add $t5, $t5, $s2		# msm j, prox linha
      lb $t6($t5)			# aux 
      sb $a0($t5)
      sb $t6($v0)
      naoimpar:
      addi $t1, $t1, 1 	# j++
      blt $t1, $a2, tl 		# if(j < ncol) goto tl
      li $t1, 0 			# j = 0
      bne $t2, $t0, naoim
      addi $t2, $t2, 4 	# soma 4 na linha a ser trocada
      naoim:
      addi $t0, $t0, 1 	# i++
      blt $t0, $a1, tl 		# if(i < nlin) goto tl
      li $t0, 0 			# i = 0
   
      lw $ra, ($sp) 		# Recupera o retorno para a main
      addi $sp, $sp, 4 	# Libera o espaço na pilha
      move $v0, $a3 	# Endereço base da matriz para retorno
      jr $ra 			# Retorna para a main    
      
trocacoluna:
   subi $sp, $sp, 4 		# Espaço para 1 item na pilha
   sw $ra, ($sp) 			# Salva o retorno para a main
   move $a3, $a0 			# aux = endereço base de mat
   li $t0, 0
   li $t1, 0
   li $t2, 0				# coluna inicial para fazer a troca
   tc: jal indice 			# Calcula o endereço de mat[i][j]
      lb $a0, ($v0) 			# Valor em mat[i][j]
      bne $t1, $t2, naopar	# esta na coluna pra fazer a troca
      addi $t4, $t1, 3		
      bgt $t4, $s2, naopar # j +2 existe
      li $t5, 2
      add $t5, $v0, $t5		# msm lilha, prox 2 j
      lb $t6($t5)			# aux 
      sb $a0($t5)			# faz a troca
      sb $t6($v0)
      naopar:
      move $t3, $t1
      addi $t1, $t1, 1 	# j++
      bne $t2, $t3, naop
      addi $t2, $t2, 4 	# soma 2 na coluna a ser trocada
      naop:
      blt $t1, $a2, tc 	# if(j < ncol) goto tl
      li $t1, 0 			# j = 0
      li $t2, 0
      addi $t0, $t0, 1 	# i++
      blt $t0, $a1, tc 	# if(i < nlin) goto tl
      li $t0, 0 			# i = 0
      lw $ra, ($sp) 		# Recupera o retorno para a main
      addi $sp, $sp, 4 	# Libera o espaço na pilha
      move $v0, $a3 	# Endereço base da matriz para retorno
      jr $ra 			# Retorna para a main          
      
calculapalindromo:   
   subi $sp, $sp, 4 		# Espaço para 1 item na pilha
   sw $ra, ($sp) 			# Salva o retorno para a main
   move $a3, $a0 			# aux = endereço base de mat
   li $t0, 0
   li $t1, 0
   div $t3, $s2, 2			# metade das colunas
   p:
      mul $v0, $t0, $a2  	# i * ncol
      add $v0, $v0, $a3 	# Soma o endereço base de mat  
      move $t2, $v0
      li $t4, 0			# k
      li $t5, 0			# l
      palindromoloop:
         addi $t4, $t4, 1	# k++
         sub $t6, $a2, $t4	# max colunas - k
         add $t6, $t6, $t2	# endereço de tras pra frente
         add $t7, $v0, $t5	# endereço de frente pra tras
         lb $t8, ($t6)		# tras p frente
         lb $t9, ($t7)		# frente pra tras
         bne $t8, $t9, endloop
         addi $t5, $t5, 1	# l++
         blt $t4, $t3, palindromoloop
      print_str "Palindromo na linha "
      print_int $t0
      print_str ": "
      li $t3, 0				# k = 0
      imprimepalindromo:	# loop de impressao
         add $t5, $t2, $t3
         lb $t6, ($t5)
         print_char $t6
         addi $t3, $t3, 1
         blt $t3, $a2, imprimepalindromo
      pulin
      
      endloop:
      addi $t0, $t0, 1 	# i++
      blt $t0, $a1, p 		# if(i < nlin) goto p
      li $t0, 0 			# i = 0
      lw $ra, ($sp) 		# Recupera o retorno para a main
      addi $sp, $sp, 4 	# Libera o espaço na pilha
      move $v0, $a3 	# Endereço base da matriz para retorno
      jr $ra 			# Retorna para a main          
      
ordenamatriz:
   subi $sp, $sp, 4 	# Espaço para 1 item na pilha
   sw $ra, ($sp) 		# Salva o retorno para a main
   move $a3, $a0 		# aux = endereço base de mat
   
   dinamic $s5
   move $t5, $v0		# endereco vetor minusculas
   dinamic $s6
   move $t6, $v0		# endereco vetor maiusculas
   dinamic $s7
   move $t7, $v0   		# endereco vetor simbolos
   
   o: jal indice 		# Calcula o endereço de mat[i][j]
      lb $a0, ($v0) 		# Valor em mat[i][j]
     
      bge $a0, 123, simbol 
      ble $a0, 64, simbol
      ble $a0, 90, maius
      bge $a0, 97, minus
      j simbol
      minus:
      
      sb $a0, ($t5)
      addi $t5, $t5, 1
      j prox
      maius:
      sb $a0, ($t6)
      addi $t6, $t6, 1 
      j prox
      simbol:
      sb $a0, ($t7)
      addi $t7, $t7, 1
      prox:	
     
      update_ij($t0, $t1, $a1, $a2, o, $s1) 
      
      sub $t5, $t5, $s5
      sub $t6, $t6, $s6
      sub $t7, $t7, $s7
      
      lw $ra, ($sp)		# Recupera o retorno para a main
      addi $sp, $sp, 4 	# Libera o espaço na pilha
      move $v0, $a3 	# Endereço base da matriz para retorno
      jr $ra 			# Retorna para a main      
      
printaordenado:
   subi $sp, $sp, 4 	# Espaço para 1 item na pilha
   sw $ra, ($sp) 		# Salva o retorno para a main
   move $a3, $a0 		# aux = endereço base de mat
   li $t1, 0
   li $t2, 0
   li $t2, 0			# aux contador
   printaminus:
      beqz $s5, printamaius
      lb  $t3, ($t5)
      print_char $t3
      space
      addi $t1, $t1, 1 	# j++
      blt $t1, $a2, nx1 	# if(j < ncol)
      li $t1, 0 			# j = 0
      pulin
      nx1:
      addi $t2, $t2, 1
      addi $t5, $t5 , 1
      blt $t2, $s5, printaminus
      li $t2, 0			# aux contador
      
   printamaius:
      beqz $s6, printasimbol
      lb  $t3, ($t6)
      print_char $t3
      space
      addi $t1, $t1, 1 	# j++
      blt $t1, $a2, nx2	# if(j < ncol) 
      li $t1, 0 			# j = 0
      pulin
      nx2:
      addi $t2, $t2 , 1
      addi $t6, $t6 , 1
      
      blt $t2, $s6, printamaius   
      li $t2, 0			# aux contador
      
   printasimbol:
      beqz $s7, nx
      lb  $t3, ($t7)
      print_char $t3
      space
      addi $t1, $t1, 1 	# j++
      blt $t1, $a2, nx3 	# if(j < ncol) 
      li $t1, 0 			# j = 0
      pulin
      nx3:
      addi $t2, $t2 , 1
      addi $t7, $t7 , 1
      blt $t2, $s7, printasimbol   
      li $t2, 0			# aux contador

      lw $ra, ($sp) 		# Recupera o retorno para a main
      addi $sp, $sp, 4 	# Libera o espaço na pilha
      move $v0, $a3 	# Endereço base da matriz para retorno
      jr $ra 			# Retorna para a main   
     
   nx:
   lw $ra, ($sp)		# Recupera o retorno para a main
   addi $sp, $sp, 4 	# Libera o espaço na pilha
   move $v0, $a3 		# Endereço base da matriz para retorno
   jr $ra 				# Retorna para a main         

end:
   done	
