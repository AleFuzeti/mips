j MAIN

MULTIPLICAR:
			addi $t6,$zero,1 #j = 1
			add $t7,$zero,$a2 #mult = argumento(2)
			
LOOP_MULTIPLICAR:	slt $t8,$t6,$a3 #se j < argumento(3) ; t8 = 1; senao t8 = 0
			beq $t8,$zero,FIM_MULTIPLICAR
			
			add $t7,$t7,$a2 #mult = mult + a2
			addi $t6,$t6,1 #t6++
			
			j LOOP_MULTIPLICAR
			
FIM_MULTIPLICAR:	add $v1,$zero,$t7
			jr $ra

FATORIAL:
		addi $t0,$zero,1 #i = 1
		addi $t1,$a0,0   #fatorial = $a0
		add  $t3,$zero,$ra #recebe memoria do ponto de retorno
		
LOOP_FATORIAL:	slt $t2,$t0,$a0 #se i < a0; t2 = 1; senao t2 = 0
		beq $t2,$zero,FIM_FATORIAL #desvia para FIM_FATORIAL se i>= a0
		
		add $a2,$zero,$t1 #a2 = fatorial
		sub $a3,$a0,$t0 #a3 = a0 - t0
		
		jal MULTIPLICAR 
		
		addi $t1,$v1,0 # fatorial = fatorial * (a0 - t0)
		addi $t0,$t0,1 #t0++
		
		j LOOP_FATORIAL
		
FIM_FATORIAL:
		add $v0,$zero,$t1 #v0 = $t1
		jr $t3
	
MAIN:
	#calcular o fatorial de $s0
	add $a0,$zero,$s0 #argumento(0) = s0
	jal FATORIAL
	add $s1,$v0,$zero
	