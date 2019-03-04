# programma che ricevuto il numero n inserito da terminale, calcola la somma dei primi n numeri
		.data
msg1:			.asciiz "Inserisci il numero intero n per cui vuoi eseguire la somma dei primi n termini!\n"
msg2:			.asciiz "La somma dei primi n numeri interi e' pari a "
a_capo:			.asciiz "\n"
msg_err:			.asciiz "ERRORE: inserire un valore positivo!\n"
		
		.text
		
# $t0 = somma dei primi n numeri
# $t1 = numero da sommare a $t0 (n-1, n-2, n-3,..., 1)
		
			li		$v0, 4
			la		$a0, msg1
			syscall						# stampa il messaggio che mostra le istuzioni e lo scopo del programma
			li		$v0, 5
			syscall						# preleva il numero passato da terminale
			move		$t0, $v0			# sposta in $t0 il numero passato da terminale
			ble		$t0, $zero, errore		# restituisce un messaggio di errore se il numero inserito da terminale è negativo
			ble		$t0, 1, minore			# stampa il numero inserito da terminale se il numero inserito è 0 o 1
			addiu		$t1, $t0, -1			# $t1 = n - 1
ciclo:			addu 		$t0, $t0, $t1			# somma a $t0 il valore di $t1
			beq		$t1, 1, print			# se si ha ultimato la somma di tutti i primi n numeri si salta alla stampa del risultato
			addiu		$t1, $t1, -1			# decrementa di 1 il valore di $t1
			j		ciclo							
		
print:			li		$v0, 4				# stampa a video la somma dei primi n numeri...
			la		$a0, msg2
			syscall
			li		$v0, 1
			move		$a0, $t0
			syscall
			li		$v0, 4
			la		$a0, a_capo
			syscall
			
fine:			j 		fine

minore:			move 	$a0, $t0				# stampa il valore di $t0 nel caso in cui il valore inserito sia 0 o 1
			j 		print
			
errore:			li		$v0, 4				# stampa un messaggio di errore se il numero inserito è negativo
			la		$a0, msg_err
			syscall
			j 		fine

			
		
