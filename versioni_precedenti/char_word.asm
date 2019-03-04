# programma che stampa a video le parole che contengono il carattere inserito da console

	.data
str:			.ascii "nel mezzo del cammin di nostra vita, "
			.ascii "mi ritrovai per una selva oscura, "
			.asciiz "che la diritta via era smarrita."
			
msg:			.asciiz "Inserire una lettera per cercare le parole che la contengono:\n"
a_capo:			.asciiz "\n"
alloc:			.space 30
			
	.text
	
# $s0 = carattere da cercare nelle parole
# $s1 = indirizzo di partenza dell'area di allocazione della parola da stampare
# $t0 = carattere del testo puntato da $t8
# $t6 = puntatore all'area di memoria per allocare la parola da stamapre
# $t7 = puntatore alla parola da stampare
# $t8 = puntatore al testo	
	
restart:		la		$t6, alloc 
			move		$s1, $t6				
			la		$a0, msg
			li		$v0, 4
			syscall						# stampa lo scopo e le istruzioni del programma
			move		$a0, $sp			# assegna a $a0 l'indirizzo di memoria relativo allo stack pointer
			li		$v0, 8				# prepara la syscall per acquisire una stringa passata da console
			li		$a1, 3				# la stringa è lunga 3 caratteri (carattere sul quale effettuare la 										# ricerca, andata a capo e terminatore di stringa
			syscall						# acquisisce la stringa passata da console e la salva nello stack
			lbu		$s0, 0 ($a0)			# carica in $s0 il carattere inserito dall'utente tramite console
			la		$t8, str
ciclo:			lbu		$t0, 0 ($t8)			# carica in $t0 il carattere puntato dal puntatore al testo
			bne		$t0, $s0, no_search		# salta a 'no_search' se il carattere letto e' diverso da quello da cercare,
			move		$t7, $t8			# altrimenti il puntatore alla parola da stamapre assume il valore del puntatore al testo
			move		$t6, $s1			# copia il valore di $s1 in $t6
			jal		find_word			# chiamata al sottoprogramma 'find_word' per trovare l'indirizzo d'inizio della parola,
									# allocare la parola da stampare e infine procedere alla stampa a video
no_search:		addiu		$t8, $t8, 1			# incrementa in puntatore al testo
			bne		$t0, $zero, ciclo		# intera il processo di ricerca fino a quando non trova il terminatore di stringa nel
									# testo salvato in memoria
			li		$v0, 4							
			la		$a0, a_capo
			syscall						# al termine dell'esecuzione del programma, stampa il carattere di andata a capo
			j		restart				# e riavvia il programma
			
find_word:		beq		$t0, 0x20, space		# finche' non trova il carattere di spaziatura,
			addiu		$t7, $t7, -1			# decrementa il valore del puntatore alla parola da stampare
			lbu		$t0, 0 ($t7)			# legge il carattere puntato dal puntatore al testo
			j		find_word

space:			addiu		$t7, $t7, 1			# quando viene trovato lo spazio prima della parola da stampare,
									# il puntatore alla parola da stamapre viene incrementato per puntare al primo carattere;
									# poi si limita ad incrementare il puntatore per puntare al 										# carattere successivo della parola da stampare
			lbu		$t0, 0 ($t7)			# carica in $t0 il carattere puntato dal puntatore alla parola da stampare
			sb		$t0, 0 ($t6)			# salva il carattere nell'area di allocazione dedicato alla parola da stampare
			addiu		$t6, $t6, 1			# incrementa il puntatore all'area di allocazione della parola da stampare
			bne		$t0, 0x20, space		# continua ad allocare caratteri fino alla fine della parola da trovare,
									# ovvero fino a quando non viene trovato il carattere di spaziatura; a questo punto
			sb		$zero, 0, ($t6)			# aggiunge il terminatore di stringa a fine vettore di allocazione
			j		print				# e passa alla fase di stampa della parola
			
print:			li		$v0, 4
			la		$a0, alloc
			syscall						# stampa la parola che contiene il carattere indicato dall'utente
			la		$a0, a_capo
			syscall						# stampa il carattere di andata a capo
			jr		$ra				# e torna all'esecuzione del programma chiamante
