.include "macros.asm"

.data 
Arquivo: .asciiz "/home/fuzeti/Imagens/mips/Arq2/2 bim/dados.txt"
.text
main:

	la $a0, Arquivo	# Nome arquivo
	li $a1, 0 		# Somente leitura

	abertura($a0,$a1,$a2)
	
	print_str "deu certo!!"


fim:
	done
