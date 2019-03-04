# programma che cripta una frase usando il cifrato di Cesare
# salvando in memoria la frase criptata
# il cifrato di Cesare consiste nel traslare ogni lettera della frase
# di tre posizioni piu' avanti

	.data
frase:		.asciiz "ci|o"
free:

	.text
# main program
# $s0 puntatore per il caricamento dei dati
# $s1 contiene il primo indirizzo in cui è possibile scrivere i dati
# $a0 usato per il caricamento dei caratteri
		la	$s0, frase
		la	$s1, free
cesare:		lbu	$a0, 0 ($s0)
		beq	$a0, $zero, fine
		jal	check
		addiu	$a0, $a0, 3
		sb	$a0, 0 ($s1)
		addiu	$s0, $s0, 1
		addiu	$s1, $s1, 1
		j 	cesare

check:		sltu	$t0, $a0, 0x61
		bne	$t0, $zero, error
		sltu	$t0, $a0, 0x7a
		beq	$t0, $zero, error
		j	$ra
	
fine:		j	fine

error:		j	error
