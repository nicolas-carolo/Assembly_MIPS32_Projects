		addiu	$s0, $zero, 1
		addiu 	$s1, $zero, 1
		addiu 	$s2, $zero, 100
ciclo:		add 	$t1, $s0, $s1
		add 	$s0, $s1, $zero
		add	$s1, $t1, $zero
		slt 	$t0, $s1, $s2
		bne	$t0, $zero, ciclo
fine:		j	fine
