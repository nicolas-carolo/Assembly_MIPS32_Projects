# ordina i dati del vettore in ordine crescente

		.data
		
dati:			.word	10 25 -5 0 -20
f_dati:
		
		.text
			la	$t7, dati
			la	$t8, f_dati
			j	start_ciclo
ciclo_ext:		addiu	$t7, $t7, 4
			beq	$t7, $t8, fine
start_ciclo:		lw	$t0, 0 ($t7)
			addiu	$t6, $t7, 4
			beq	$t6, $t8, fine
ciclo_int:		lw	$t1, 0 ($t6)
			blt	$t0, $t1, no_change
			jal	swap
no_change:		addiu	$t6, $t6, 4
			blt	$t6, $t8, ciclo_int
			j	ciclo_ext
				
fine:			j	fine

swap:			sw	$t0, 0 ($t6)
			sw	$t1, 0 ($t7)
			move	$t0, $t1
			jr	$ra
