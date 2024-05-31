.include "macros.asm"
.data
.align 2
vetor:.space 200

.text
main:
	print_str("digite um numero n (max 50): ")
	ler_int
	move $s0, $v0 	#s0 = n
	move $t1, $s0   #t1 = s0
	
	li $t0, 0 	#t0 = i = 0
	li $t2, 1	#t2 = j = 1
	jal ler_vet
	
	li $t0, 0 	#t0 = i = 0
	li $t2, 1	#t2 = j = 1
	li $t7, 0	#t7 = k = 1
	move $t1, $s0   #t1 = s0
	jal ordena

	li $t0, 0 	#t0 = i = 0
	move $t1, $s0   #t1 = s0
	print_str("Vetor ordenado: ")
	jal imp_vetor
	
	li $t0, 0
	move $t1, $s0   #t1 = s0
	li $t4, 2
	li $t7, 0
	jal soma_par
	print_str(" A soma dos pares eh: ")
	print_int($t7)
	
	print_str(". Digite um numero k: ")
	ler_int
	move $s1, $v0 	#s0 = k
	move $t1, $s0   #t1 = s0
	li $t0, 0 	#t0 = i = 0
	print_str("Numeros maiores que k e menores que 2k: ")
	jal veri_k
	
	move $t1, $s0   #t1 = s0
	li $t2, 0
	li $t0, 0 	#t0 = i = 0
	print_str("Numero de elementos iguais a k: ")
	jal igual_k
	print_int($t2)
	done
	
ler_vet:beqz $t1, volta # se o tamanho chega a 0, fim do processamento
	print_str("digite o ")
	print_int($t2)
	print_str(" elemento: ")
	ler_int
	move $t3, $v0
	sw $t3, vetor($t0)
	addiu   $t0,$t0, 4      # atualiza o apontador do vetor
        addiu   $t1,$t1,-1 	#i = i--
        addiu   $t2,$t2,1	#j = j++
        j ler_vet
        
ordena: 
	beq $t2, 0, volta
	li $t2, 0
	li $t7, 0
	
	for:
	mul $t0, $t7, 4
	lw $t3, vetor($t0)
	addi $t6, $t0, 4       # atualiza o apontador do vetor
	lw $t4, vetor($t6)
	slt $t5, $t3, $t4 	#se vetor[i] < vetor [i+1], t5 = 1
	beq $t5, 1, fim_for
	beq $t3, $t4, fim_for	#se vetor[i] = vetor [i+1]
	
	li $t2, 1 		#faz a troca
	sw $t3, vetor($t6)
	sw $t4, vetor($t0)
	
	fim_for:
	addi $t7, $t7, 1
	addi $a1, $t1, -1
	slt $a1, $t7, $a1
	beq $a1, 1, for
	
	j ordena
	
imp_vetor:			#imprime o vetor
	beqz $t1, volta
	lw $t2, vetor($t0)
	print_int($t2)
	print_str(" ")
	addiu   $t0,$t0,4       # atualiza o apontador do vetor
        addiu   $t1,$t1,-1 	#i = i--
        j imp_vetor

soma_par:beqz $t1, volta
	lw $t2, vetor($t0)
	addi $t0, $t0, 4
	addi $t1, $t1,-1
	div $t2, $t4
	mfhi $t3 #resto
	beqz $t3, soma
	j soma_par
	soma: add $t7, $t7, $t2
	j soma_par

veri_k:beqz $t1, volta
	mul $t2, $s1, 2
	lw $t3, vetor($t0)
	addi $t0, $t0, 4
	addi $t1, $t1,-1
	slt $t4, $t3, $t2
	beq $t4, 1, menor_2k
	j veri_k
	menor_2k:slt $t4, $t3, $s1
	beq $t4, 1, veri_k
	print_int($t3)
	print_str(" ")
	j veri_k

igual_k:beqz $t1, volta
	lw $t3, vetor($t0)
	addi $t0, $t0, 4
	addi $t1, $t1,-1
	beq $t3, $s1, igual
	j igual_k
	igual: addi $t2, $t2, 1
	j igual_k
	
volta:
	jr $ra
