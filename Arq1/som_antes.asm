.include "macros.asm"

j main

storevalues: blez $t1,esc  	# se o tamanho chega a 0, fim do processamento
        addi   $t2,$t2,1    	# i++
	mul $s1,$t2,$t2
	sw	$s1,vetor($t0)	# salva no vetor
	
        addiu   $t0,$t0,4     	# atualiza o apontador do vetor
       				# lembrar que 1 palavra no MIPS ocupa 4 bytes (4 endereços consecutivos) de memória
        addi   $t1,$t1,-1      	# decrementa o contador de tamanho do vetor
        j storevalues           	# continua a execução

computesum: blez $t1,esc
	lw  $s2,vetor($t0)
        addi   $t2,$t2,1    	# i++	
	add $s3,$s3,$s2		#soma
	
	addi   $t0,$t0,4     	# atualiza o apontador do vetor
        addi   $t1,$t1,-1      	# decrementa o contador de tamanho do vetor
	j computesum
esc:
	jr $ra
	
main:

	print_str (" Tamanho do vetor: (max 64) ")	#imprimindo
    	ler_int	# lendo o numero
    	move $s0, $v0	# movendo pra outro registrador
	
	move $t0,$zero 
	move $t1, $s0
        move $t2,$zero
	jal storevalues
	
	move $t0,$zero 
	move $t1, $s0
        move $t2,$zero    	
	jal computesum
   	
   	print_str (" soma = ")
   	print_int($s3)

end: done
	.data
vetor:	.align 2
	.space 	260	#tamanho do vetor
