# programma che conta calcola delle statistiche sui caratteri presenti nella frase digitata da console

	.data
msg1:		.asciiz	"Inserire una frase sulla quale eseguire delle statistiche (max 510 caratteri)\n"
uguale:		.asciiz " = "
a_capo:		.asciiz "\n"
msg_err:	.asciiz "Si prega di inserire una frase!\n"
alpha:		.asciiz	"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
statistic:	.word	0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000
frase:		.space	512
print_char:	.space	3
	
	.text
start:		la		$a0, msg1
		li		$v0, 4
		syscall
			
		la		$a0, frase
		li		$a1, 512
		li		$v0, 8
		syscall
			
		la		$t8, frase
		lbu		$t0, 0, ($t8)
		beq		$t0, 0x0a, errore
			
ciclo:		la		$t7, statistic
		lbu		$t0, 0 ($t8)
		beq		$t0, 0x0a, print
		beq		$t0, 0x20, space
		addiu		$t0, $t0, -97
		addu		$t7, $t7, $t0
		lb		$t2, 0 ($t7)
		addiu		$t2, $t2, 1
		sb		$t2, 0 ($t7)
space:		addiu		$t8, $t8, 1
		j		ciclo
			
print:		la		$t7, statistic
		la		$t1, alpha
		la		$t4, print_char
ciclo_2:	lbu		$t3, 0 ($t1)
		sb		$t3, 0 ($t4)
		move		$t5, $zero
		sb		$t5, 1 ($t4)
		li		$v0, 4
		la		$a0, print_char
		syscall
		la		$a0, uguale
		syscall
		li		$v0, 1
		lbu		$a0, 0 ($t7)
		syscall
		li		$v0, 4
		la		$a0, a_capo
		syscall
		addiu		$t1, $t1, 1
		addiu		$t7, $t7, 1
		blt		$t3, 0x5a, ciclo_2
			
		la		$t7, statistic
		li		$t0, 0x00000000
		sw		$t0, 0 ($t7)
		sw		$t0, 4 ($t7)
		sw		$t0, 8 ($t7)
		sw		$t0, 12 ($t7)
		sw		$t0, 16 ($t7)
		sw		$t0, 20 ($t7)
		sw		$t0, 24 ($t7)
		j		start

errore:		li		$v0, 4
		la		$a0, msg_err
		syscall
		j		start
