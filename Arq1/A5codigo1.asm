.include "macros.asm"

.data
vetor: .ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

.text
j main
troca:			#void troca(int vetor[], int i, int j)
	move $t0, $s1 	#int aux = vetor[i];
	move $s1, $s2	#vetor[i] = vetor[j];
	move $s2, $t0	#vetor[j] = aux;
	jr $ra

# generic looping mechanism
.macro forperm (%regIterator, %from, %to)
add %regIterator, $zero, %from
Loop:
mul $t1, $a3, 4
perm ()
add %regIterator, %regIterator, 1
ble %regIterator, %to, Loop
.end_macro

#print forperm
.macro perm()

lb    $a0, $t0($t2)           # vetor
li    $v0, 11                 #print_char
syscall   
                   
addi $t1, $t1, 1

.end_macro

main: 			#int main(int argc, char *argv[])

	print_str ("digite um numero n(max 26):")
	ler_int
	move $s0, $v0 		#s0 = n
	la $t2, vetor        	# address of the first element
	li $a1, 0 		#inf = 0
	addi $a2, $s0, -1 	#tam_v - 1 = n - 1
	j permuta		#permuta(v, 0, tam_v - 1);

permuta:		#void permuta(int vetor[], int inf, int sup)
	bne $a1, $a2, else   		#if(inf == sup)
		li $a3, 0		#(int i = 0)
		li $t1, 0 		#
		forperm($a3,1,$a2)	#for(int i = 0; i <= sup; i++)
		pulin
	else:
		move $t4, $a1		#int i = inf
		repeat:
		jal troca		#troca(vetor, inf, i);
		addi $a1,$a1, 1
		j permuta		#permuta(vetor, inf + 1, sup);
		jal troca		#troca(vetor, inf, i); // backtracking
		beq $t4, $a2, repeat 	#for(int i = inf; i <= sup; i++)
		addi $t4,$t4, 1
	
	done
	

