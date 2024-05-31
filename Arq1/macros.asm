#macro para imprimir string
.macro print_str (%str) 
	.data
myLabel: .asciiz %str
	.text
	li $v0, 4
	la $a0, myLabel
	syscall
.end_macro

# macro para ler um inteiro
.macro ler_int
	li $v0, 5	
	syscall	
.end_macro 

#macro para imprimir inteiros
.macro print_int (%x) 	
	li $v0, 1
	add $a0, $zero, %x
	syscall
.end_macro

#macro pra pular linha
.macro pulin
	print_str "\n"
.end_macro

#macro para finalizar programa
.macro done		
	li $v0,10
	syscall
.end_macro
	

# generic looping mechanism
.macro for (%regIterator, %from, %to, %bodyMacroName)
add %regIterator, $zero, %from
Loop:
%bodyMacroName ()
add %regIterator, %regIterator, 1
ble %regIterator, %to, Loop
.end_macro

#print for
.macro body()
print_int $t0
print_str "\n"
.end_macro

#fatorial for
.macro fat()
mul $s0, $s0, $t0
.end_macro

#mensagem de erro
.macro erro
pulin
print_str("!!erro!!entrada invalida!!")
pulin
done
.end_macro


