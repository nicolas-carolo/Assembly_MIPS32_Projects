# programma che per decriptare una frase criptata con il cifrario di cesare

	.data
msg1:			.asciiz "Inserire la frase da decriptare!\n"
msg_err1:		.asciiz "Si prega di utilizzare solo i caratteri dell'alfabeto (a...Z, A...Z)!\n"
msg_err2:		.asciiz "Si prega di inserire una frase da decifrare!\n"
a_capo:			.asciiz "\n"

cifrata:		.space 512
decifrata:		.space 512
f_decifrata:

	.text
	
# $t0 = carattere da decifrare
# $t6 = indirizzo di fine frase decifrata
# $t7 = puntatore alla frase da decifrare
# $t8 = puntatore alla frase decifrata
# $v1 = indicatore di carattere maiuscolo
	
start:			la		$a0, msg1					# chiede di inserire la frase da decriptare
			li		$v0, 4
			syscall
				
			li		$v0, 8						# prepara la syscall a ricevere una stringa
			li		$a1, 512					# da 512 caratteri (510 caratteri, andata a capo, terminatore di stringa)
			la		$a0, cifrata					# da salvare all'indirizzo etichettato con 'cifrata'
			syscall								# riceve la frase da decifrare
				
			la		$t7, cifrata
			la		$t8, decifrata
				
			lbu		$t0, 0 ($t7)					# legge il primo carattere
			bne		$t0, 0x0a, cesare				# e verifica che non si tratti di un'andata a capo (= stringa vuota)
			j		no_cifrata					# se e' una stringa vuota mostra un messaggio di errore, altrimenti prosegue

cesare:			lbu		$t0, 0 ($t7)					# legge il carattere puntato dal puntatore alla frase da decifrare
			beq		$t0, 0x0a, print				# se il carattere e' un carattere di andata a capo (fine frase), passa al
											# procedimento di stampa della frase decifrata
			beq		$t0, 0x32, space				# se il carattere letto e' il carattere di spaziatura salta a 'space'
											# in quanto non bisogna effettuare una traslazione
			move		$a0, $t0
			jal		up_to_down					# chiama il sottoprogramma per trasformare un carattere maiuscolo in 												# minuscolo
			jal		check						# chiama il sottoprogramma per controllare che il carattere inserito sia 												# valido (a...z)
			move		$t0, $a0
			bgt		$t0, 0x63, standard				# se il carattere e' d...z, va alla traslazione di 3 posizioni indietro, altrimenti
			addiu		$t0, $t0, 26					# somma al carattere il valore numerico decimale 26 e poi
standard:		addiu		$t0, $t0, -3					# effettua la traslazione di 3 posizioni indietro
			beq		$v1, $zero, space				# se il carattere da traslare era una maiuscola,
			move		$a0, $t0
			jal		down_to_up					# chiama il sottoprogramma per trasformarlo di nuovo in una maiuscola; 												# altrimenti
			move		$t0, $a0
space:			sb		$t0, 0 ($t8)					# salva il carattere nella stringa della frase decifrata
			addiu		$t7, $t7, 1					# incrementa il puntatore alla frase da decifrare
			addiu		$t8, $t8, 1					# incrementa il puntatore alla frase decifrata
			j		cesare
				
print:			la		$t8, decifrata
			move		$a0, $t8
			li		$v0, 4
			syscall								# stampa la frase decifrata
				
			la		$a0, a_capo
			li		$v0, 4
			syscall								# stampa il carattere di andata a capo
			j		reset						# e salta al reset del programma per riavviarlo successivamente
				
up_to_down:		move		$v1, $zero					# inizializza a zero l'indicatore di maiuscola
			blt		$a0, 0x41, no_utd				# se il carattere e' minore di A
			bgt		$a0, 0x5a, no_utd				# o maggiore di Z, non effettua alcuna operazione, altrimenti
			addiu		$a0, $a0, 0x20					# converte la maiuscola in minuscola
			li		$v1, 1						# e lo segnala ponendo l'indicatore di maiuscola a 1
no_utd:			jr		$ra						# torna al programma chiamante

down_to_up:		addiu		$a0, $a0, -32					# sottrae al carattere il valore numerico decimale 32 per ottenere il carattere 											# maiuscolo
			jr		$ra						# torna al programma chiamante

check:			blt		$a0, 0x61, error				# se il carattere e' minore di a
			bgt		$a0, 0x7a, error				# o maggiore di z mostra un messaggio di errore, altrimenti
			jr		$ra						# torna al programma chiamante
				
error:			la		$a0, msg_err1
			li		$v0, 4
			syscall								# avvisa l'utente che la frase da decifrare contiene un carattere non valido
			j		reset						# salta alla funzione di reset per riavviare il programma
				
no_cifrata:		la		$a0, msg_err2					# mostra un messaggio di errore nel caso in cui l'input sia una stringa vuota
			li		$v0, 4
			syscall
			j		reset
				
reset:			la		$t7, cifrata					# azzera l'input...
			la		$t8, decifrata
ciclo_r_c:		sb		$zero, 0 ($t7)
			addiu		$t7, $t7, 1
			blt		$t7, $t8, ciclo_r_c
						
			la		$t6, f_decifrata				# azzera l'output...
ciclo_r_d:		sb		$zero, 0 ($t8)
			addiu		$t8, $t8, 1
			blt		$t8, $t6, ciclo_r_d
			j		start						# e riavvia il programma
