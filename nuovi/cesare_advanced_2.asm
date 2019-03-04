# cifrario di Cesare con traslazione in avanti selezionata dall'utente

		.data
msg1:		.asciiz "Inserire una frase da cifrare (max 510 caratteri e solo caratteri alfabetici):\n"
msg2:		.asciiz	"Indicare di quante posizioni in avanti deve essere traslata ogni lettera:\n"
msg_err:	.asciiz "Si prega di utilizzare solo i caratteri dell'alfabeto (a...Z, A...Z)!\n"
msg_err2:	.asciiz "Si prega di inserire una frase!\n"
msg_err3:	.asciiz	"Si prega di inserire un numero compreso tra 1 e 26!\n"
a_capo:		.asciiz "\n"
frase:		.space 512
cifrata:	.space 512
f_cifrata:

		.text

# $s0 puntatore per il caricamento dei dati
# $s1 contiene il primo indirizzo in cui è possibile scrivere i dati
# $s2 contiene in numero di taslazioni in avanti che bisogna fare per ogni lettera
# $t0 usato per il caricamento dei caratteri
# $t8 contiene l'indirizzo di fine della stringa cifrata
# $v1 usato per segnalare se il carattere è minuscolo (0) o maiuscolo (1)

start:		li		$v0, 4					
		la		$a0, msg1
		syscall							# stampa il messaggio di partenza
		
		li		$v0, 8
		li		$a1, 512
		la		$a0, frase
		syscall							# salva in memoria la stringa inserita da terminale
			
		lbu		$t0, 0 ($a0)
		bne		$t0, 0x0a, continue			# non accetta stringhe vuote ("\n")
		li		$v0, 4
		la		$a0, msg_err2
		syscall							# se la stringa e' vuota segnala l'errore
		j		reset					# salta alla funzione di reset di input e output e riavvia il programma
			
continue:	li		$v0, 4					# se la stringa contiene almeno un carattere alfabetico prosegue con l'elaborazione
		la		$a0, msg2
		syscall
			
		li		$v0, 5
		syscall							# riceve la costante necessaria per la traslazione
		ble		$v0, $zero, s_error			# la quale deve essere maggiore o uguale a 1
		bgt		$v0, 26, s_error			# e minore o uguale a 26
		move		$s2, $v0				# memorizza la costante passata da console nel registro $s2

		la		$s0, frase
		la		$s1, cifrata

cesare:		lbu		$t0, 0 ($s0)			
		beq		$t0, 0x0a, print			# termina quando trova il carattere di andata a capo e passa alla stampa della frase cifrata
		beq		$t0, 0x20, space			# se viene rilevato il carattere di spaziatura, viene saltata la procedura di traslazione
		move		$a0, $t0				# il registro argomento assume il valore del carattere letto dalla memoria
		jal		uptodown
		jal		check
		move		$t0, $a0
		li		$t1, 0x7a				# calcolo di...
		subu		$t1, $t1, $s2				# ...
		addiu		$t1, $t1, 1				# ...(z - $s2 + 1)
		blt		$t0, $t1, stnd				# se $t0 = a...(z - $s2) salta alla traslazione di $s2 posizioni piu' avanti; altrimenti
		addiu		$t0, $t0, -26				# bisogna prima sottrarre 26 e poi
stnd:		addu		$t0, $t0, $s2				# si somma $s2
		beq		$v1, $zero, space			# se in precedenza il carattere era maiuscolo ($v1 = 1)
		move		$a0, $t0				# copia il carattere nel registro argomento
		jal		downtoup				# ed esegue la chiamata a sottoprogramma per trasformarlo in maiuscolo
		move		$t0, $a0
space:		sb		$t0, 0 ($s1)				# altrimenti salta a questa per il salvataggio nell'area di memoria dedicata alla frase cifrata 
		addiu		$s0, $s0, 1				# incrementa il puntatore a "frase"
		addiu		$s1, $s1, 1				# incrementa il puntatore a "cifrata"
		j 		cesare					# passa all'elaborazione del carattere successivo

# sottoprogramma che verifica se il carattere inserito e' valido (a...z)
# se non lo e' stampa un messaggio di errore sulla console,
# altrimenti ritorna al programma chiamante
check:		blt		$a0, 0x61, error
		bgt		$a0, 0x7b, error
		j		$ra

# sottoprogramma che controlla se il carattere letto e' maiuscolo.
# in tal caso lo trasforma in minuscolo e il registro valore $v1 viene forzato a 1
uptodown:	move		$v1, $zero
		blt		$a0, 0x41, no_utd
		bgt		$a0, 0x5b, no_utd
		addiu		$a0, $a0, 32
		li		$v1, 1
no_utd:		j		$ra					# se il carattere non e' una maiuscola si ritorna alla funzione chiamante

# sottoprogramma che trasforma una minuscola in maiusola
downtoup:	addiu		$a0, $a0, -32
		j		$ra

# stampa la frase cifrata		
print:		li		$v0, 4
		la		$a0, cifrata
		syscall
		la		$a0, a_capo
		syscall
		j		reset

# stampa il messaggio di errrore se e' presente un carattere non valido
error:		li		$v0, 4
		la		$a0, msg_err
		syscall
		j		reset
			
# stampa il messaggio di errrore se la costante di traslazione non è valida
s_error:	li		$v0, 4
		la		$a0, msg_err3
		syscall
		j		reset
			
reset:		la		$s0, frase				# azzera l'input...
		la		$s1, cifrata
ciclo_r_f:	sb		$zero, 0 ($s0)
		addiu		$s0, $s0, 1
		blt		$s0, $s1, ciclo_r_f
			
		la		$s1, cifrata				# azzera l'output...
		la		$t8, f_cifrata
ciclo_r_c:	sb		$zero, 0 ($s1)
		addiu		$s1, $s1, 1
		blt		$s1, $t8, ciclo_r_c
		j		start					# e riavvia il programma
