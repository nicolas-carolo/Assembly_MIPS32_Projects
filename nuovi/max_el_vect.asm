# programma che trova il numero intero piu' elevato di un vettore

	.data
vect:			.word	10 20 -2 -2 200 200 -1
f_vect:
msg:			.asciiz "L'elemento piu' grande del vettore e' "

	.text

# $s0 = elemento maggiore del vettore
# $t0 = puntatore a vect
# $t1 = elemento del vettore da confrontare con l'attuale maggiore
# $t8 = indirizzo di fine vettore
	
			la		$t0, vect
			la		$t8, f_vect
			lw		$s0, 0 ($t0)				# si suppone che il primo elemento di vect sia il maggiore
			addiu		$t0, $t0, 4				# incrementa il puntatore a vect per puntare al secondo elemento del vettore
ciclo:			lw		$t1, 0 ($t0)				# legge l'elemento del vettore da confrontare
			bgt		$s0, $t1, no_change			# se l'elemento letto e' minore dell'attuale maggiore non avviene alcun 										# cambiamento, altrimenti
			move	$s0, $t1					# in $s0 viene salvato il nuovo maggiore
no_change:		addiu	$t0, $t0, 4					# incrementa il puntatore per puntare all'elemento (word) successivo del vettore
			blt		$t0, $t8, ciclo				# passa alla lettura dell'elemento successivo, altrimenti
			la		$a0, msg				# viene stampato a video l'elemento maggiore del vettore
			li		$v0, 4
			syscall
			move	$a0, $s0
			li		$v0, 1
			syscall
fine:			j		fine
