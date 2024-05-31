.include "macros.asm"

.data
  radformula: .float 0.01745329251

.text
main:  

	entrada:
		print_str(" Insira um real X em graus: ")
		ler_flt
		mov.s $f1, $f0
		
		print_str(" Insira um inteiro N: ")
		ler_int
		move $s1, $v0
		ble $s1, $zero, end
		
	grauradiano:
		jal graurad
		
	calcula_cos:
		li $s0, 1				# cos
		int_flt $s0, $f8		# (float *) cos
		jal cos
		
	printa:
		print_str(" A aproximacao do cosseno de ") 
		print_flt $f10
		print_str (" graus eh: ")
		print_flt $f8
		
	done
	
graurad:
	subi $sp, $sp, 4 			# Espaço para 1 item na pilha
	sw $ra, ($sp) 			# Salva o retorno para a main

	lwc1 $f10, radformula
	mul.s  $f9, $f1, $f10
	mov.s $f10, $f1
	mov.s $f1, $f9
	
        lw $ra, ($sp)				# Recupera o retorno para a main
        addi $sp, $sp, 4 			# Libera o espaço na pilha
        move $v0, $a3 			# Endereço base da matriz para retorno
        jr $ra 					# Retorna para a main     	
        
cos:	
   	subi $sp, $sp, 4 			# Espaço para 1 item na pilha
	sw $ra, ($sp) 			# Salva o retorno para a main
	li $t0, 0					# k
	loop:
		bge $t0, $s1, endloop	# k < n
		addi $t0, $t0, 1		# k++
		#pulin
		#print_int $t0
		#space
		 
		jal calculo
		j loop
	endloop:
        lw $ra, ($sp)				# Recupera o retorno para a main
        addi $sp, $sp, 4 			# Libera o espaço na pilha
        move $v0, $a3 			# Endereço base da matriz para retorno
        jr $ra 					# Retorna para a main      
        
calculo:

	li $t1, -1					# a = -1
	int_flt $t1, $f2			# fa = -1
	
	move $t1, $t0			# a = k
	mov.s $f3, $f2		
	pot($a0, $f2, $f3, $t1) 		# fb = (-1)^k 
	
	mul $t1, $t1, 2			# a = 2k
	mov.s  $f2, $f1			# fa = x	
	mov.s $f4, $f2
	pot($a0, $f2, $f4, $t1)		# fc = x^2k	
	#print_flt $f4
	#space
	
	fat($a1, $t1, $t2)			# b = (2k)! 
	int_flt $t2, $f5			# fd = flt{ (2k)! }
	#print_flt $f5
	#space	
	
	mul.s $f7, $f4, $f3		# (-1)^k * x^2k
	div.s $f7, $f7, $f5		 	# [(-1)^k * x^2k] / (2k)! 
	#print_flt $f7
	
	add.s $f8, $f8, $f7		# cos
	
        jr $ra 					# Retorna    
end:
	done
