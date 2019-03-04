# programma che controlla il valore contenuto in $s0 (anni) e che intraprende varie decisioni
# programma con ciclo

# (input)
		add 	$s0, $zero, $zero

# se $s0 >= 18 allora $s2 = 1; 0 altrimenti
ciclo: 		addi 	$s1, $zero, 18
		slt 	$s2, $s1, $s0
		beq 	$s0, $s1, uguali

# torna da capo
		j	ciclo

# pone $s2 = 1 se $s0 = $s1
uguali:		addi	$s2, $zero, 1
		j 	ciclo
