# confronta due vettori salvati in memoria

	.data
msg1:			.asciiz "I due vettori "
msg2:			.asciiz "non "
msg3:			.asciiz "sono uguali!\n"
vect1:			.word 10 20 30 40
f_vect1:
vect2:			.word 10 30 30 40
f_vect2:

	.text
	
# $t0 = puntatore a vect_1
# $t1 = puntatore a vect_2
# $t2 = elemneto di vect_1 da confrontare (uguaglianza)
# $t3 = elemento di vect_2 da confrontare (uguaglianza)
# $t5 = dimensione di vect_1
# $t6 = dimensione di vect_2	
# $t7 = indirizzo di fine vect_1
# $t8 = indirizzo di fine vect_2
	
			la		$t0, vect1
			la		$t1, vect2
			la		$t7, f_vect1
			la		$t8, f_vect2
			la		$a0, msg1			# prepara la syscall...
			li		$v0, 4				# ...per la stampa di una stringa (equal/not equal)
			subu		$t5, $t7, $t0			# calcola la dimensione di vect_1
			subu		$t6, $t8, $t1			# calcola la dimensione di vect_2
			bne		$t5, $t6, not_equal		# se i due vettori non hanno la stessa dimensione, allora non sono uguali
ciclo:			lw		$t2, 0 ($t0)			# carica in $t2 l'n-esimo elemento di vect_1
			lw		$t3, 0 ($t1)			# carica in $t3 l'n-esimo elemento di vect_2
			bne		$t2, $t3, not_equal		# se $t2 e $t3 non sono uguali, allora i due vettori non sono uguali
			addiu		$t0, $t0, 4			# incrementa il puntatore di vect_1 per puntare all'elemento successivo
			addiu		$t1, $t1, 4			# incrementa il puntatore di vect_2 per puntare all'elemento successivo
			beq		$t0, $t7, equal			# se si hanno confrontati tutti gli elementi dei due vettori, allora i due vettori sono uguali,
			j		ciclo				# altrimenti si confrontano gli elementi successivi
			
equal:			syscall						# i due vettori sono uguali...
			la		$a0, msg3
			syscall
			j		fine
			
not_equal:		syscall						# i due vettori sono diversi...
			la		$a0, msg2
			syscall
			la		$a0, msg3
			syscall
			j 		fine
			
fine:			j		fine
