# programma che controlla il valore contenuto in $s0 (anni) e che intraprende varie decisioni

# (input)
		add 	$s0, $zero, 21

# se $s0 > 18 allora $s2 = 1; 0 altrimenti
		addi 	$s1, $zero, 18
		slt 	$s2, $s1, $s0

# fine
fine: 		nop
		j 	fine
