# programma che eleva il numero 2 (contenuto in $t0) per $t1 (numeri positivi)
# $t2 è la variabile i del ciclo for
# il risultato viene salvato in $s0


# imposta il valore di $t0 e di $t1
	addiu	$t0, $zero, 2
	# addiu	$t1, $zero, 10
	add 	$t1, $zero, $zero

# programma...
	addiu 	$t2, $zero, 1
	move	$s0, $t0

	beq	$t1, $zero, el1

for:	sll 	$s0, $s0, 1		# moltiplicazione per 2
	addiu	$t2, $t2, 1
	slt	$t3, $t2, $t1
	bne	$t3, $zero, for

fine:	j	fine

el1:	addi	$s0, $zero, 1
	j	el1
	
