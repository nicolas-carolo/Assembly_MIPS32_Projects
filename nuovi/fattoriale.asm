# programma che calcola e stampa a video il fattoriale di un numero n letto da console

	.data
msg1:			.asciiz "Inserire il numero di cui si vuole calcolare il fattoriale:\n"
msg2:			.asciiz "! = "
a_capo:			.asciiz "\n"
msg_err:		.asciiz "Errore! Il risultato e' un numero troppo grande per essere rappresentato con 32 bit.\n"
msg_small:		.asciiz "Si prega di inserire un numero intero positivo!\n"

	.text
	
# $s0 = risultato operazione di fattoriale
# $t0 = numero n passato da console
# $t1 = k < n da moltiplicare ad ogni iterazione per $s0 fino a quando k = n
	
start:			li		$v0, 4
			la		$a0, msg1
			syscall							# stampa le istruzioni e lo scopo del programma
			li		$v0, 5							
			syscall							# preleva il numero intero n da console
			move		$t0, $v0				# sposta il numero n nel registro $t0
			blt		$t0, $zero, too_small			# se il numero e' negativo mostra un avviso di errore
			ble		$t0, 2, print_ex			# se n =< 2 ricade in un caso particolare e chiama la funzione print_ex
			bgt		$t0, 12, error				# se n > 12 mostra un avviso di errore (superata capacita' di rappresentazione) 
			li		$s0, 2					# $s0 = 2 = k!, in quanto 0 annulla il prodotto e' ininfluente sul 											risultato 
			addiu		$t1, $s0, 1				# $t1 = 3
ciclo:			mul		$s0, $s0, $t1				# $s0 = k! * (k + 1)
			addiu		$t1, $t1, 1				# k++	
			bgt		$t1, $t0, print				# se k > n, allora esce dal ciclo e stampa il risultato
			j ciclo

print_ex:		beq		$t0, 0, print_0				# se n = 0, salta a print_0
			move		$s0, $t0				# se n = 1 o n = 2, n! = n
			j		print					# chiama la funzione di stampa che stampera' $s0
			
print_0:		addi 		$s0, $zero, 1				# 0! = 1
			j		print					# chiama la funzione di stampa che stampera' 1
			

print:			li		$v0, 1					# stampa il risultato contenuto in $s0
			move		$a0, $t0
			syscall
			li		$v0, 4
			la		$a0, msg2
			syscall
			li		$v0, 1
			move		$a0, $s0
			syscall
			li		$v0, 4
			la		$a0, a_capo
			syscall							# stampa l'andata a capo e
			j		start					# riavvia il programma
			
error:			li		$v0, 4
			la		$a0, msg_err
			syscall							# mostra il messaggio di superamento della capacita' di rappresentazione
			j		start					# e riavvia il programma
			
too_small:		li		$v0, 4
			la		$a0, msg_small
			syscall							# mostra un avviso di inserire un numero positivo
			j		start					# e riavvia il programma
