# incrementa fino a 100 il contenuto del registro $s0
	add	$s0, $zero, $zero
	addi	$t0, $zero, 100

for: 	slt	$t1, $s0, $t0
	beq	$t1, $zero, fine
	addi	$s0, $s0, 1
	j	for

fine:	nop
	j	fine
	
