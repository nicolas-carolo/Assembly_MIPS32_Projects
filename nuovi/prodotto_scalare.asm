# calcola il prodotto scalare di due vettori

	.data
msg_err:			.asciiz "Non e' possibile calcolare il prodotto scalare poiche' i due vettori non hanno le stesse dimensioni!"
msg_ris:			.asciiz "Il prodotto scalare e' pari a "
vect1:				.word	-1 2 -3 5 -4
f_vect1:
vect2:				.word	3 7 -3 6 1
f_vect2:
				
	.text

# $s0 = prodotto scalare	
# $t0 = puntatore a vect1
# $t1 = puntatore a vect2
# $t2 = n-esimo elemento di vect1
# $t3 = n-esimo elemento di vect2
# $t4 = $t2 * $t3
# $t5 = dimensione di vect1
# $t6 = dimensione di vect2
# $t7 = indirizzo di fine vect1
# $t8 = indirizzo di fine vect2
	
				la		$t0, vect1
				la		$t7, f_vect1
				la		$t1, vect2
				la		$t8, f_vect2
				subu		$t5, $t7, $t0			# calcola la dimensione di vect1
				subu		$t6, $t8, $t1			# calcola la dimensione di vect2
				bne		$t5, $t6, errore		# stampa un messaggio di errore se i due vettori non hanno la stessa dimensione
				move		$s0, $zero			# inizializza a zero il prodotto scalare
ciclo:				lw		$t2, 0 ($t0)			# carica in $t2 l'n-esimo elemento di vect1
				lw		$t3, 0 ($t1)			# carica in $t3 l'n-esimo elemento di vect2
				mul		$t4, $t2, $t3			# moltiplicazione fra gli n-esimi elementi di vect1 e vect2
				add		$s0, $s0, $t4			# somma la moltiplicazione eseguita precedentemente al prodotto scalare
				addiu		$t0, $t0, 4			# incrementa il puntatore a vect1
				addiu		$t1, $t1, 4			# incrementa il puntatore a vect2
				bne		$t0, $t7, ciclo			# cicla il procedimento di moltiplicazione e somma fino all'ultimo elemento
				j		print

errore:				la		$a0, msg_err
				li		$v0, 4
				syscall						# stampa il messaggio di errore se i due vettori non hanno la stessa dimensione
				j 		fine

print:				la		$a0, msg_ris
				li		$v0, 4
				syscall						# stampa la stringa relativa al risultato
				move		$a0, $s0
				li		$v0, 1
				syscall						# stampa il risultato numerico

fine:				j 		fine
