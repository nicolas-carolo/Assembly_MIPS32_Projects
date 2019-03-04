# esegue il quadrato di un numero passato con la syscall
	.data
msg1:		.asciiz "Inserisci un numero intero da elevare al quadrato\n"
msg2:		.asciiz "Il risultato e' pari a "
msg_err:	.asciiz "Errore: capacita' di rappresentazione superata!"
		
	.text
	
# $t0 = quadrato del numero passato da terminale
# $v0 = numero passato da terminale
	
		li		$v0, 4
		la		$a0, msg1
		syscall							# stampa la consegna e le istruzioni del programma
		li		$v0, 5
		syscall							# preleva il valore intero inserito da terminale e lo copia in $v0
		bgt		$v0, 46340, error			# se il numero inserito e' maggiore di 46340 stampa un messaggio di errore
		mul		$t0, $v0, $v0				# calcola il quadrato del numero
		li		$v0, 4
		la		$a0, msg2
		syscall							# stampa la stringa per mostrare il risultato		
		li		$v0, 1
		move		$a0, $t0
		syscall							# stampa il valore numerico
		
fine:		j		fine

error: 		li		$v0, 4					# stampa il messaggio di errore
		la		$a0, msg_err
		syscall
		j		fine
