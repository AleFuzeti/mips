# macro para alocar memoria
.macro dinamic(%x)
	add $a0, $zero, %x
	li $v0, 9
	syscall
.end_macro

# macros para leitura

.macro ler_int 	# inteiro
	li $v0, 5	
	syscall	
.end_macro 

.macro ler_flt 	# inteiro
	li $v0, 6	
	syscall	
.end_macro 

.macro ler_char	# char
	li $v0 12
	syscall 
.end_macro 

# macros para impressao

.macro print_int (%x) 		# inteiro
	li $v0, 1
	add $a0, $zero, %x
	syscall
.end_macro

.macro print_flt (%x) 		# float
	li $v0, 2
	mov.s $f12, %x
	syscall
.end_macro

.macro print_char (%c) 	# char
	li $v0, 11
	add $a0, $zero, %c
	syscall
.end_macro

.macro print_str (%str) 	# string
	.data
myLabel: .asciiz %str
	.text
	li $v0, 4
	la $a0, myLabel
	syscall
.end_macro

# macro pra pular linha
.macro pulin
	 print_char '\n'
.end_macro

# macro para espaco
.macro space
	print_char ' '
.end_macro

# macro para conversao
.macro int_flt(%int,%flt)
	mtc1 %int, %flt
	cvt.s.w %flt, %flt
.end_macro

# macro para conversao
.macro flt_int(%flt,%int)
	cvt.w.s %flt, %flt
	mfc1 %int, %flt
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

# mensagem de erro
.macro erro
pulin
print_str("\n!!erro!!\n")
pulin
done
.end_macro

#macro para finalizar programa
.macro done		
	li $v0,10
	syscall
.end_macro
