# trova la parola digitata dall'utente e la sostituisce con una a sua scelta

		.data
str:			.ascii "nel mezzo del cammin di nostra vita "
			.ascii "mi ritrovai per una selva oscura, "
			.ascii "che la diritta via era smarrita. "
			.ascii "ahi quanto a dir qual era cosa dura "
			.ascii "esta selva selvaggia e aspra e forte "
			.asciiz "che nel pensier rinnova la paura!"
			
msg1:			.asciiz "Inserire la parola da sostituire:\n"
msg2:			.asciiz "Inserire la parola con cui la vuoi sostituire:\n"
a_capo:			.asciiz	"\n\n"

parola_t:		.space	32		
parola_s:		.space	32
parola_print:		.space	32
punt:			.space	3	

		.text
# $a0 = usato per passare le stringhe alla syscall		
# $a1 = puntatore al vettore 'punt'
# $t0 = serve per il caricamento dei caratteri del testo
# $t1 = serve per il caricamento dei caratteri della parola da cercare nel testo
# $t3 = puntatore al vettore 'parola_print'
# $t4 = serve per la lettura e la scrittura dei caratteri della parola presente nel testo che va copiata nel vettore 'parola_print' per poi stamparla
# $t5 = puntatore alla parola presente nel testo da stampare successivamente
# $t6 = indirizzo del carattere di spaziatura presente dopo la parola da stampare
# $t7 = puntatore al testo salvato in memoria
# $t8 = puntatore alla parola salvata in memoria
# $v0 = usato per pssare il codice identificativo della syscall
		
			li		$v0, 4
			la		$a0, str
			syscall							# stampa il testo presente in memoria
			
			li		$v0, 4
			la		$a0, a_capo
			syscall							# stampa un carattere di andata a capo
			
start:			li		$v0, 4
			la		$a0, msg1
			syscall							# chiede di inserire la parola da sostituire
				
			li		$v0, 8					# prepara la syscall a ricevere una stringa da console
			li		$a1, 32					# costituita da 32 caratteri (30 caratteri, andata a capo e terminatore di stringa)
			la		$a0, parola_t				# da mettere nello spazio di allocazione etichettato con 'parola_t'
			syscall							# riceve la parola da sostituire da console
				
			li		$v0, 4
			la		$a0, msg2
			syscall							# chiede di inserire la parola da usare in sostituzione
				
			li		$v0, 8					# prepara la syscall a ricevere una stringa da console
			li		$a1, 32					# costituita da 32 caratteri (30 caratteri, andata a capo e terminatore di stringa)
			la		$a0, parola_s				# da allocare nello spazio di memoria indicato con l'etichetta 'parola_s'
			syscall							# riceve la parola da usare in sostituzione da console
			
			la		$t3, parola_s
ciclo:			lbu		$t0, 0 ($t3)				# legge i caratteri dalla 'parola_s'
			addiu		$t3, $t3, 1				# e incrementa il puntatore a 'parola_s'
			bne		$t0, 0x0a, ciclo			# fino a quando trova il carattere di andata a capo
			sb		$zero, -1 ($t3)				# e sostituisce quest'ultimo con il terminatore di stringa
				
			la		$t7, str
			la		$t8, parola_t

after_p_w:		move		$t5, $t7				# memorizza l'indirizzo di partenza della parola da leggere nel testo
next_char:		lbu		$t0, 0 ($t7)				# carica un carattere dal testo in cui effettuare la ricerca
			lbu		$t1, 0 ($t8)				# carica un carattere della parola da cercare nel testo
			addiu		$t7, $t7, 1				# incrementa il puntatore al testo salvato in memoria, per puntare al carattere successivo
			addiu		$t8, $t8, 1				# incrementa il puntatore alla parola da cercare, per puntare al carattere successivo
			bne		$t1, 0x0a, salta			# se la parola da cercare e' terminata ($t1 = carattere di andata a capo),
			jal		found_1					# passa al primo controllo (found_1); altrimenti
salta:			beq		$t0, $t1, next_char			# controlla se il carattere del testo e quello della parola da cercare corrispondono;
										# se corrispondono passa alla verifica del carattere successivo, altrimenti
			j		next_word				# salta al controllo di uguaglianza della parola successiva
			
found_1:		beq		$t0, 0x20, found_2			# se la parola letta dal testo corrisponde a quella da cercare ($t0 = carattere di 											# spaziatura),
										# salta all'istruzione per segnalare che e' stato trovato un risultato; oppure
			beq		$t0, 0x21, found_2			# se la parola letta dal testo corrisponde a quella da cercare ($t0 = punto esclamativo),
										# salta all'istruzione per segnalare che e' stato trovato un risultato; oppure
			beq		$t0, 0x2c, found_2			# se la parola letta dal testo corrisponde a quella da cercare ($t0 = virgola),
										# salta all'istruzione per segnalare che e' stato trovato un risultato; oppure
			beq		$t0, 0x2e, found_2			# se la parola letta dal testo corrisponde a quella da cercare ($t0 = punto),
										# salta all'istruzione per segnalare che e' stato trovato un risultato; altrimenti
			beq		$t0, 0x3a, found_2			# se la parola letta dal testo corrisponde a quella da cercare ($t0 = due punti),
										# salta all'istruzione per segnalare che e' stato trovato un risultato; altrimenti
			beq		$t0, 0x3b, found_2			# se la parola letta dal testo corrisponde a quella da cercare ($t0 = punto e virgola),
										# salta all'istruzione per segnalare che e' stato trovato un risultato; altrimenti
			beq		$t0, 0x3f, found_2			# se la parola letta dal testo corrisponde a quella da cercare ($t0 = punto di domanda),
										# salta all'istruzione per segnalare che e' stato trovato un risultato; oppure
			beq		$t0, $zero, found_2			# se la parola letta dal testo corrisponde a quella da cercare ($t0 = terminatore di 											# stringa),
										# salta all'istruzione per segnalare che e' stato trovato un risultato; altrimenti
			jr		$ra					# torna al programma chiamante
			
found_2:		la		$a1, punt				# inizializza il puntatore al vettore 'punt'
			sb		$t0, 0 ($a1)				# scrive nel vettore 'punt' il carattere presente dopo la parola da sostituire
			addiu		$a1, $a1, 1				# incrementa il puntatore a 'punt'			
			beq		$t0, 0x20, j_point			# se alla fine della parola da sostituire troviamo un carattere di spaziatura,
										# allora salta a 'j_point'; altrimenti,
			beq		$t0, $zero, j_null			# se alla fine della parola da sostituire troviamo il terminatore di stringa,
										# allora salta a 'j_null'; altrimenti
			li		$t0, 0x20
			sb		$t0, 0 ($a1)				# al carattere di punteggiatura, fa seguire un carattere di spaziatura
			addiu		$a1, $a1, 1				# incrementa il puntatore a 'punt'
j_point:		sb		$zero, 0 ($a1)				# e inserisce un terminatore di stringa in coda al vettore
j_null:			jal		print_s					# chiamata al sottoprogramma 'print_s' per la stampa della parola da usare in sostituzione
			la		$t8, parola_t				# inizializza il puntatore alla parola da cercare nel testo in modo da puntare al primo 										# carattere
			j		after_p_w				# va alla lettura del primo carattere della parola successiva
			
next_word:		lbu		$t0, 0 ($t7)				# scansiona i caratteri successivi del testo
			addiu		$t7, $t7, 1				# e incrementa il puntatore al testo
			beq		$t0, $zero, term_str			# fino a quando non trova il terminatore di stringa (fine lettura del testo) e salta a 											# 'term_str'
			bne		$t0, 0x20, next_word			# oppure fino a quando non trova il carattere di spazio (fine parola)
term_str:		addiu		$t6, $t7, -1 				# salva l'indirizzo di memoria in cui si trova lo spazio dopo la parola appena letta
			la		$t8, parola_t				# il puntatore alla parola da cercare viene impostato per puntare al primo carattere
			jal		print_word				# chiamata al sottoprogramma per stampare la parola (tale e quale e' stata trovata nel 											# testo)
			beq		$t4, $zero, fine			# se la lettura del testo e' stata completata (terminatore di stringa), va a 'fine'
			j		after_p_w				# torna al confronto tra la parola successiva nel testo e la parola da cercare

print_word:		la		$t3, parola_print			# inizializza il puntatore a puntare al primo byte del vettore 'parola_print'
ciclo_p:		lbu		$t4, 0 ($t5)				# legge il carattere della parola da stampare presente nel testo
			sb		$t4, 0 ($t3)				# per poi salvarlo nel vettore 'parola_print'
			beq		$t4, 0x20, print			# se il carattere letto e riscritto e' un carattere di spaziatura, va alla stampa della 										# parola; altrimenti
			beq		$t4, $zero, print			# se il carattere letto e riscritto e' un carattere di andata a capo, va alla stampa della 											# parola; altrimenti
			addiu		$t5, $t5, 1				# incrementa il puntatore a 'parola_print'
			addiu		$t3, $t3, 1				# incrementa il puntatore a alla parola da stamapre presente nel testo
			j		ciclo_p					# va alla lettura del carattere successivo della parola da stampare presente nel testo

print:			addiu		$t3, $t3, 1				# incrementa di uno il puntatore a 'parola_print'
			sb		$zero, 0 ($t3)				# aggiunge un terminatore di stringa in coda al vettore
			li		$v0, 4
			la		$a0, parola_print
			syscall							# stampa la parola letta nel testo
			jr		$ra					# ritorna al programma chiamante
			
print_s:		li		$v0, 4
			la		$a0, parola_s
			syscall							# stampa la parola da usare in sostituzione
			li		$v0, 4
			la		$a0, punt
			syscall							# e stampa i caratteri di punteggiatura e spaziatura da porre in coda alla parola
ciclo_2:		lbu		$t0, 0 ($t7)				# legge i successivi caratteri dal testo
			bne		$t0, 0x20, back				# finche' trova il carattere di spaziatura
			addiu		$t7, $t7, 1				# incrementa il puntatore al testo per puntare al primo carattere della parola successiva
			j		ciclo_2
back:			lbu		$t0, -1 ($t7)
			beq		$t0, $zero, fine
			jr		$ra					# ritorna al programma chiamante

fine:			li		$v0, 4
			la		$a0, a_capo
			syscall							# quando il programma e' terminato stampa il carattere di andata a capo
			j		start					# e fa ripartire il programma dalla prima istruzione
