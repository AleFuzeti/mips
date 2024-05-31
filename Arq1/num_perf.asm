.include "macros.asm"
j MAIN

VERIFICAR:	div $a0,$t0 #argumento(0)/i
		mfhi $s2 # s2 = resto
		beq $s2,$zero,SOMA
		jr $ra
		SOMA:add $t1,$t1,$t0 #soma=soma+1 se for divisivel
		jr $ra
PERFEITO:
		add $t0,$zero,$a0 #i = argumento(0)
		addi $t1,$zero,0 #soma = 0
		beq $s0,1,TRUE #caso o n seja 1
		
LOOP_PERFEITO:  addi $t4,$zero,1
		slt $t2,$t4,$t0 #se 0 < i; t2 = 1; senao t2 = 0
		beq $t2,$zero,FIM_PERFEITO #desvia para FIM_PERFEITO se i < 1
		subi $t0,$t0,1 #i--
		
		jal VERIFICAR 
		j LOOP_PERFEITO

FIM_PERFEITO:
		beq $t1,$s0,TRUE

   		print_str ("Não eh perfeito")
    		done	
		TRUE:
   		print_str ("eh perfeito")
		done
MAIN:

 	# imprimindo
   	print_str ("Digite um numero")
   	print_str ("  ")
    	# lendo o numero
    	ler_int
    	# movendo pra outro registrador
    	move $s0, $v0
	#calcular se $s0 é perfeito
	add $a0,$zero,$s0 #argumento(0) = s0
	jal PERFEITO
