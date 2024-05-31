.include "macros.asm"
main:	la $t0,vetor	# o registrador $t0 contém o endereço do vetor
	la $t1,size 	# obtém o endereço da posição da memória de dados onde se guarda
        	    	# o tamanho do vetor (size)
        lw $t1,0($t1)   # o registrador $t1 contém o tamanho do vetor
        addi $s0,$zero,0 #soma positivos
        addi $s1,$zero,0 #soma negativos

loop:   blez    $t1,end         # se o tamanho chega a 0, fim do processamento
        lw      $t3,0($t0)      # obtém um elemento do vetor
	
	addi $t4,$zero,0 	#constante 0
	slt $t2,$t3,$t4 	#se t3 < 0; t2 = 1; senao t2 = 0 
	beq $t2,$zero,POS
	#beq $t2,1,NEG
	add $s1,$s1,$t3
	j apontador
	POS:add $s0,$s0,$t3
	j apontador
	
apontador:        
        addiu   $t0,$t0,4       # atualiza o apontador do vetor
        			# lembrar que 1 palavra no MIPS ocupa 4 bytes (4 endereços consecutivos) de memória
        addiu   $t1,$t1,-1      # decrementa o contador de tamanho do vetor
        j loop            # continua a execução
        
end:    print_str ("a soma dos positivos = ")
	print_int ($s0)
	print_str (" ")
        print_str ("a soma dos negativos = ")
     	print_int ($s1)
     	li $v0,10
	syscall
     	
#POS:add $s0,$s0,$t3
#fazer voltar
#NEG:add $s1,$s1,$t3
#fazer voltar
.data
vetor: .word -2, 4, 7, -3, 0, -3, 5, 6	# o vetor
size:  .word  8 #tamanho do vetor
