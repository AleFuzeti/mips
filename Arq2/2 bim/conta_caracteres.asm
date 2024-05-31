.include "macros.asm"

.data
buffer: .asciiz " "
Arquivo: .asciiz "/home/fuzeti/Imagens/mips/Arq2/2 bim/dados.txt"

.text
main:
    la $a0, Arquivo             # Nome do arquivo
    li $a1, 0                   # Somente leitura
    abrirArquivo($s0)           # Abre o arquivo
    move $a0, $s0               # Move o descritor para $a0
    la $a1, buffer              # Endereço do buffer
    li $a2, 1                   # Caractere por leitura

    li $t0, 0                   # Contador de caracteres
    contaCaractere($t0)         # Chama a função contagem
    move $s1, $t0               # Move o valor de retorno para $s1
    print_int $s1               # Imprime o valor de retorno

    fecharArquivo               # Fecha o arquivo
    done                        # Sai do programa

