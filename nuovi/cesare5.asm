# programma che cripta una frase usando il cifrato di Cesare
# salvando in memoria la frase criptata
# il cifrato di Cesare consiste nel traslare ogni lettera della frase
# di tre posizioni piu' avanti

	.data
msg1:		.asciiz "Inserire una frase da cifrare (max 510 caratteri e solo caratteri alfabetici):\n"
msg_err:	.asciiz "Si prega di utilizzare solo i caratteri dell'alfabeto (a...Z, A...Z)!\n"
msg_err2:	.asciiz "Si prega di inserire una frase!\n"
a_capo:		.asciiz "\n"
frase:		.space 512
cifrata:	.space 512
f_cifrata:

	.text
# main program
# $s0 puntatore per il caricamento dei dati
# $s1 contiene il primo indirizzo in cui è possibile scrivere i dati
# $t0 usato per il caricamento dei caratteri
# $t8 contiene l'indirizzo di fine stringa cifrata
# $v1 usato per segnalare se il carattere è minuscolo (0) o maiuscolo (1)

start:		li		$v0, 4					
		la		$a0, msg1
		syscall						# stampa il messaggio di partenza
			
		li		$v0, 8
		li		$a1, 512
		la		$a0, frase
		syscall						# salva in memoria la stringa inserita da terminale
			
		lbu		$t0, 0 ($a0)
		bne		$t0, 0x0a, continue		# non accetta stringhe vuote ("\n")
		li		$v0, 4
		la		$a0, msg_err2
		syscall						# se la stringa e' vuota segnala l'errore
		j		reset				# salta alla funzione di reset di input e output e riavvia il programma
			
continue:	la		$s0, frase			# se la stringa contiene almeno un carattere alfabetico prosegue con l'elaborazione
		la		$s1, cifrata

cesare:		lbu		$t0, 0 ($s0)			
		beq		$t0, 0x0a, print		# termina quando trova il carattere di andata a capo e passa alla stampa della frase cifrata
		beq		$t0, 0x20, space		# se viene rilevato il carattere di spaziatura, viene saltata la procedura di traslazione
		move		$a0, $t0			# il registro argomento assume il valore del carattere letto dalla memoria
		jal		uptodown
		jal		check
		move		$t0, $a0
		blt		$t0, 0x78, stnd			# se $t0 = a...w salta alla traslazione di 3
		addiu		$t0, $t0, -26			# invece, nel caso di x (-> a), y (-> b), z (-> c), bisogna prima sottrarre 26 e poi
stnd:		addiu		$t0, $t0, 3			# si somma 3
		beq		$v1, $zero, space		# se in precedenza il carattere era maiuscolo ($v1 = 1)
		move		$a0, $t0			# copia il carattere nel registro argomento
		jal		downtoup			# ed esegue la chiamata a sottoprogramma per trasformarlo in maiuscolo
		move		$t0, $a0
space:		sb		$t0, 0 ($s1)			# altrimenti salta a questa per il salvataggio nell'area di memoria dedicata alla frase cifrata 
		addiu		$s0, $s0, 1			# incrementa il puntatore a "frase"
		addiu		$s1, $s1, 1			# incrementa il puntatore a "cifrata"
		j 		cesare				# passa all'elaborazione del carattere successivo

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
no_utd:		j		$ra				# se il carattere non e' una maiuscola si ritorna alla funzione chiamante

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
			
reset:		la		$s0, frase			# azzera l'input...
		la		$s1, cifrata
ciclo_r_f:	sb		$zero, 0 ($s0)
		addiu		$s0, $s0, 1
		blt		$s0, $s1, ciclo_r_f
			
		la		$s1, cifrata			# azzera l'output...
		la		$t8, f_cifrata
ciclo_r_c:	sb		$zero, 0 ($s1)
		addiu		$s1, $s1, 1
		blt		$s1, $t8, ciclo_r_c
		j		start				# e riavvia il programma
