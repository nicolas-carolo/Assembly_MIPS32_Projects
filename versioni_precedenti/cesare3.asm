# programma che cripta una frase usando il cifrato di Cesare
# salvando in memoria la frase criptata
# il cifrato di Cesare consiste nel traslare ogni lettera della frase
# di tre posizioni piu' avanti

	.data
frase:		.asciiz "Dadum, tractum est"
free:
	.text
		.globl __start
#main program
#$s0 puntatore per il caricamento dei dati
#$s1 contiene il primo indirizzo in cui è possibile scrivere i dati
#$a0 usato per il caricamento dei caratteri
__start:	la	$s0, frase
		la	$s1, free
		addiu	$t8, $zero, 32

cesare:		lbu	$a0, 0 ($s0)
		beq	$a0, $zero, fine
		beq	$a0, $t8, space
		jal	uptodown
		jal	check
		blt	$a0, 0x78, stnd
		addiu	$a0, $a0, -26
stnd:		addiu	$a0, $a0, 3
		beq	$a1, $zero, space
		jal	downtoup
space:		sb	$a0, 0 ($s1)
		addiu	$s0, $s0, 1
		addiu	$s1, $s1, 1
		j 	cesare

check:		blt	$a0, 0x61, error
		bgt	$a0, 0x7b, error
		j	$ra

uptodown:	move	$a1, $zero

		blt	$a0, 0x41, no_utd
		bgt	$a0, 0x5b, no_utd
		addiu	$a0, $a0, 32
		addiu	$a1, $a1, 1
no_utd:		j	$ra

downtoup:	addiu	$a0, $a0, -32
		j	$ra
	
fine:		j	fine

error:		j	error
