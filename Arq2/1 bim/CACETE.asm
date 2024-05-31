.include "macros.asm"
.data

buffer:     .space 256  # Aloca 256 bytes de espaço

msg1:       .asciiz "Digite uma frase (máximo de 256 caracteres): "

result:     .asciiz "Você digitou: "

        .text
main: 
        la  $a0, msg1    # Carrega no endereço $a0 o conteúdo de msg1 
        li  $v0, 4   # Imprimi o conteúdo de msg1
        syscall

        li  $v0, 8   # Pega a entrada

        la  $a0, buffer   
        li  $a1, 256

        move    $t0, $a0   # Salva a string digitada em $t0
        syscall

altera:
        lb  $a0, ($t0)
        beq $a0,0,termina
        
verifica:
	ble $a0, 90, mai
	ble $a0, 122, men
	j fim
	mai:
	bge $a0, 65, mai2
	j fim
	mai2:
	addi $a0, $a0, 32	
	j fim
	men:
	bge $a0, 97, men2
	j fim	
	men2:
	subi $a0, $a0, 32
	j fim
	fim:
        sb  $a0, ($t0)

proximo:
        add $t0,$t0,1
        j   altera
termina:

        la  $a0, result    # Carrega e mostra "sua resposta" que é uma string
        li  $v0, 4   # Imprimi a string
        syscall

        la  $a0, buffer  
        li  $v0, 4   # Imprimi a string  
        syscall	
	
end:
        li $v0, 10  # Encerra o programa
        syscall


	


