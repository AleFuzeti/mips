.include "macros.asm"
.data
.align 2
vet1:.space 200

.align 2
vet2: .space 200

.text 
 main:
	
	print_str("digite um numero n (max 50): ")
	ler_int
	move $s0, $v0 	#s0 = n
	
	print_str("digite um numero k: ")
	ler_int
	move $s1, $v0 	#s1 = k
	
	move $t1, $s0   #t1 = s0
	li $t0, 0 	#t0 = i = 0
	li $t2, 1	#t2 = j = 1
	jal ler_vet
	
	move $t1, $s0   #t1 = s0
	li $t0, 0 	#t0 = i = 0
	li $t2, 1	#t2 = j = 1
	move $t3, $s1 	#t3 = k
	jal rotaciona

	li $t0, 0 	#t0 = i = 0
	move $t1, $s0   #t1 = s0
	print_str("Vetor rotacionado: ")
	jal imp_vetor

	done

ler_vet:   beq $t1,$zero, volta # se o tamanho chega a 0, fim do processamento
	print_str("digite o ")
	print_int($t2)
	print_str(" elemento:")
	ler_int
	move $t3, $v0
	sw $t3, vet1($t0)
	
	addiu   $t0,$t0,4       # atualiza o apontador do vetor
        addiu   $t1,$t1,-1 	#i = i--
        addiu   $t2,$t2,1	#j = j++
        j ler_vet
                
rotaciona:
	beqz  $t3, volta
	addi $t6, $t0, 4	#t6 = i+1
	mul $t4, $t1, 4 	#t4 = 4*n (ultima posicao do vetor)
	addi $t4, $t4,-4	#t4 = t4-4 (ultima posicao do vetor)
		
	for:
	beq $t4, $t0, end_for
	lw $t5, vet1($t0)
	sw $t5, vet2($t6)
	addi $t0, $t0, 4	# atualiza o apontador do vetor
	addi $t6, $t0, 4
	j for
	end_for:
	lw $t5, vet1($t0)
	sw $t5, vet2($zero)
	
	addiu   $t3, $t3,-1 	#k = k--
	
	li $t0, 0
	addi $t4, $t4, 4
	j salva
	fim_salva:
	li $t0, 0
	j rotaciona

salva: 
	beq $t4, $t0, fim_salva
	lw $t7, vet2($t0)
	sw $t7, vet1($t0)
	addi $t0, $t0, 4
	j salva
imp_vetor:
	beqz $t1, volta
	lw $t2, vet2($t0)
	print_int($t2)
	print_str(" ")
	addiu   $t0,$t0,4       # atualiza o apontador do vetor
        addiu   $t1,$t1,-1 	#i = i--
        j imp_vetor

volta:
	jr $ra
