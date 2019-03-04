# programma che, data una lettera inserita da console, dice quante volte e' presente nella stringa salvata in memoria (CASE-SENSITIVE)

	.data
str:			.ascii "nel mezzo del cammin di nostra vita,"
			.ascii "mi ritrovai per una selva oscura,"
			.asciiz "che la diritta via era smarrita."
			
msg:			.asciiz "Inserire una lettera per effettuare il conteggio:\n"
a_capo:			.asciiz "\n"
			
	.text
	
# $s0 = carattere inserito da console
# $s1 = numero di volte che il carattere ricorre nel testo salvato in memoria
# $t0 = carattere letto dal testo
# $t8 = puntatore al testo salvato in memoria	
	
restart:		li		$v0, 4
			la		$a0, msg
			syscall							# stampa le istruzioni e lo scopo del programma
			li		$v0, 8					# prepara la syscall per la lettura di una stringa					
			li		$a1, 3					# di tre caratteri (carattere da conteggiare, andata a capo e terminatore di stringa)
			move		$a0, $sp				# assegna a $a0 l'indirizzo dello stack pointer
			syscall							# preleva il carattere letto da console e lo salva in cima allo stack
			lbu		$s0, 0, ($a0)				# memorizza in $s0 il carattere passato da console
			la		$t8, str					
			move		$s1, $zero				# inizializza il contatore a zero
ciclo:			lbu		$t0, 0 ($t8)				# legge il carattere del testo contenuto in memoria
			beq		$t0, $zero, print			# se trova il terminatore di stringa, stampa il risultato
			bne		$t0, $s0, no_change			# se il carattere letto nel testo non corrisponde a quello da conteggiare, passa al 											# carattere successivo;
			addiu		$s1, $s1, 1				# altrimenti incrementa il contatore
no_change:		addiu		$t8, $t8, 1				# incrementa il puntatore al testo per puntare al carattere successivo
			j		ciclo

print:			li		$v0, 1
			move		$a0, $s1
			syscall							# stampa il numero di volte che il carattere digitato da tastiera e' stato 											# trovato nel testo
			li		$v0, 4
			la		$a0, a_capo
			syscall							# stampa il carattere di andata a capo e
			j		restart					# riavvia il programma per conteggiare un altro carattere
			
