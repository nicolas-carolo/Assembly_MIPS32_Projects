# programma che cripta una frase usando il cifrato di Cesare
# salvando in memoria la frase criptata
# il cifrato di Cesare consiste nel traslare ogni lettera della frase
# di tre posizioni piu' avanti

		.data
frase:			.asciiz "AbCdEfGhIjKlMnOpQrStUvWxYz"
free:
		.text
			.globl __start
# main program
# $s0 puntatore per il caricamento dei dati
# $s1 contiene il primo indirizzo in cui è possibile scrivere i dati
# $t0 usato per il caricamento dei caratteri
# $v1 usato per segnalare se il carattere è minuscolo (0) o maiuscolo (1)
__start:		la	$s0, frase
			la	$s1, free
			addiu	$t8, $zero, 32

cesare:			lbu	$t0, 0 ($s0)
			beq	$t0, $zero, fine
			beq	$t0, $t8, space
			move	$a0, $t0
			jal	uptodown
			jal	check
			move	$t0, $a0
			blt	$t0, 0x78, stnd
			addiu	$t0, $t0, -26
stnd:			addiu	$t0, $t0, 3
			beq	$v1, $zero, space		#se $v1 = 1 forza la lettera in minuscolo, altrimenti niente
			move	$a0, $t0
			jal	downtoup
			move	$t0, $a0
space:			sb	$t0, 0 ($s1)
			addiu	$s0, $s0, 1
			addiu	$s1, $s1, 1
			j 	cesare

check:			blt	$a0, 0x61, error
			bgt	$a0, 0x7b, error
			j	$ra

uptodown:		move	$v1, $zero
			blt	$a0, 0x41, no_utd
			bgt	$a0, 0x5b, no_utd
			addiu	$a0, $a0, 32
			li	$v1, 1
no_utd:			j	$ra

downtoup:		addiu	$a0, $a0, -32
			j	$ra
	
fine:			j	fine

error:			j	error
