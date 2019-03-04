# programma che data una frase presente in memoria, effettua la ricerca della parola inserita da console e mostra quante volte e' presente

		.data
str:			.ascii "nel mezzo del cammin di nostra vita "
			.ascii "mi ritrovai per vita una selva oscura "
			.asciiz "che la diritta via era smarrita "
			
msg1:			.asciiz "Inserire la parola da cercare:\n"
msg2:			.asciiz "La parola da te digitata ricorre "
msg3:			.asciiz " volta nel testo.\n"
msg_none:		.asciiz "Nessun risultato trovato!\n"
#a_capo:		.asciiz "\n"

parola:			.space 32
			
		.text
	
# $s0 = numero di volte che la parola e' stata trovata
# $t0 = serve per il caricamento dei caratteri del testo
# $t1 = serve per il caricamento dei caratteri della parola da cercare nel testo
# $t7 = puntatore al testo salvato in memoria
# $t8 = puntatore alla parola salvata in memoria
	
start:			move		$s0, $zero
			li		$v0, 4
			la		$a0, msg1
			syscall						# stampa la consegna del programma
			
			li		$v0, 8				# prepara la syscall per acquisire una stringa
			li		$a1, 32				# di 32 caratteri (compresa l'andata a capo e il terminatore di stringa)
			la		$a0, parola 			# carica in $a0 l'indirizzo di memoria a partire dal quale salvare la stringa inserita da console
			syscall						# acquisisce la parola da cercare passata da console
			
			la		$t7, str				
			la		$t8, parola
			
next_char:		lbu		$t0, 0 ($t7)			# carica un carattere dal testo in cui effettuare la ricerca
			lbu		$t1, 0 ($t8)			# carica un carattere della parola da cercare nel testo
			beq		$t0, $zero, print		# se si ha terminato la scansione di tutto il testo, salta alla stampa del risultato
			addiu		$t7, $t7, 1			# incrementa il puntatore al testo salvato in memoria, per puntare al carattere successivo
			addiu		$t8, $t8, 1			# incrementa il puntatore alla parola da cercare, per puntare al carattere successivo
			bne		$t1, 0x0a, salta		# se la parola da cercare e' terminata ($t1 = carattere di andata a capo),
			jal		found_1				# passa al primo controllo (found_1); altrimenti
salta:			beq		$t0, $t1, next_char		# controlla se il carattere del testo e quello della parola da cercare corrispondono;
									# se corrispondono passa alla verifica del carattere successivo,
			j		next_word			# altrimenti salta al controllo di uguaglianza della parola successiva
			
found_1:		beq		$t0, 0x20, found_2		# se la parola letta dal testo corrisponde a quella da cercare ($t0 = carattere di spaziatura),
									# salta all'istruzione per segnalare che e' stato trovato un risultato; altrimenti
			jr		$ra				# torna al programma chiamante
			
found_2:		addiu		$s0, $s0, 1			# incrementa il numero di volte che la parola e' stata trovata
			j		next_word			# si prepara alla comparazione della parola successiva del testo
			
next_word:		lbu		$t0, 0 ($t7)			# scansiona i caratteri successivi del testo
			addiu		$t7, $t7, 1			# e incrementa il puntatore al testo
			bne		$t0, 0x20, next_word		#fino a quando non trova il carattere di spazio (fine parola)
			la		$t8, parola			# il puntatore alla parola da cercare viene impostato per puntare al primo carattere
			j		next_char			# torna al confronto tra la parola successiva nel testo e la parola da cercare

print:			beq		$s0, $zero, p_none		# se non e' stato trovato alcun risultato stampa msg_none;
			li		$v0, 4
			la		$a0, msg2					
			syscall						# altriementi stampa quante volte la parola è stata trovata nel testo...
			li		$v0, 1
			move		$a0, $s0
			syscall
			li		$v0, 4
			la		$a0, msg3
			syscall
			j		start				# cicla il programma chiedendo di inserire un'altra parola da cercare

p_none:			li		$v0, 4
			la		$a0, msg_none
			syscall						# dopo aver mostrato il messaggio msg_none,
			j		start				# cicla il programma chiedendo di inserire un'altra parola da cercare
			
