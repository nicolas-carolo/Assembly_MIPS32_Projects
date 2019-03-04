# programma che calcola la somma degli elementi di un vettore vec memorizzato in memoria.
# poi stampa il risultato a video

	.data
msg1:			.asciiz "La somma dei numeri di vec e' "
a_capo:			.asciiz "\n"
vec:			.word	10 20 30 40 50 60
f_vec:

	.text
	
# $t0 = puntatore a vec
# $t1 = elemento da sommare alla somma degli elementi del vettore
# $t8 = indirizzo di fine vect
# $s0 = somma degli elementi del vettore
	
			la		$t0, vec
			la		$t8, f_vec
			move		$s0, $zero			# inizializza la somma a zero
ciclo:			lw		$t1, 0 ($t0)			# carica in $t1 l'elemento n-esimo del vettore
			addu		$s0, $s0, $t1			# somma l'elemento appena letto alla somma degli elementi del vettore
			addiu		$t0, $t0, 4			# incrementa il puntatore a vec per puntare alla word successiva
			blt		$t0, $t8, ciclo			# prosegue se si ha terminato la somma di tutti gli elementi, altrimenti somma l'elemento successivo
			
			la		$a0, msg1			# stampa il messaggio contenente il risultato della somma...
			li		$v0, 4
			syscall
			move		$a0, $s0
			li		$v0, 1
			syscall
			la		$a0, a_capo
			li		$v0, 4
			syscall
fine:			j		fine
			
