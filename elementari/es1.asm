#programma che dati due valori presi in memoria calcola l'espressione (a+3)*b salvando il risultato nella cella di memoria adiacente

	.data
dati:		.word	12 2
	
	.text
		la	$t0, dati
		lw	$s0, 0 ($t0)	#valore di a
		lw	$s1, 4 ($t0)	#valore di b
		addi 	$s0, $s0, 3
		mul	$s2, $s0, $s1
		sw	$s2, 8 ($t0)
fine:		j 	fine
		
	
