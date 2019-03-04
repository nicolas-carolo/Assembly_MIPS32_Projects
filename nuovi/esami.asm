# programma che calcola la media pesata dei voti degli esami

	.data
msg1:		.asciiz	"Calcola la tua media pesata! Il programma termina quado si inserisce un voto con valore 0\n"
msg2:		.asciiz "La media pesata e' "
msg_voto:	.asciiz	"Voto:\n"
msg_cred:	.asciiz	"Crediti:\n"
msg_err:	.asciiz	"Errore!!!\n"
a_capo:		.asciiz	"\n"
n_18:		.float	18.0
n_33:		.float	33.0

	.text
start:		mtc1		$zero, $f31				# $f31 = 0
		mov.s		$f1, $f31				# inizializza a zero la somma dei voti*crediti
		mov.s		$f2, $f31				# inizializza a zero la somma dei crediti
		lwc1		$f18, n_18				# $f18 = 18 (valore minimo consentito)
		lwc1		$f30, n_33				# $f30 = 33 (valore massimo consentito)
			
		li		$v0, 4
		la		$a0, msg1
		syscall							# stampa lo scopo e le istruzioni del programma
			
ciclo:		li		$v0, 4
		la		$a0, msg_voto
		syscall							# chiede di inserire il voto
			
		li		$v0, 6
		syscall							# riceve il voto inserito tramite console
		c.eq.s		$f0, $f31				# verifica se l'inserimento dei dati è terminato (voto = 0)
		bc1t		media					# e in tal caso passa al calcolo della media
		c.lt.s		$f0, $f18				# verifica che voto >= 18
		bc1t		error					# altrimenti mostra un messaggio di errore e riavvia il programma
		c.lt.s		$f30, $f0				# verifica che voto <= 33
		bc1t		error					# altrimenti mostra un messaggio di errore e riavvia il programma
		mov.s		$f3, $f0				# se il dato inserito e' valido, lo copia in $f3
			
		li		$v0, 4
		la		$a0, msg_cred
		syscall							# chiede di inserire il numero di crediti
			
		li		$v0, 6
		syscall							# riceve il numero di crediti da console
		c.le.s		$f0, $f31				# verifica che il numero di crediti sia un numero maggiore di zero
		bc1t		error					# in caso contrario mostra un messaggio di errore e riavvia il programma; altrimenti
		add.s		$f2, $f2, $f0				# aggiorna la somma dei crediti
		mul.s		$f3, $f3, $f0				# $f3 = voto * crediti		
		add.s		$f1, $f1, $f3				# aggiorna la somma voto * crediti
		j		ciclo					# si prepara a ricevere il nuovo dato
			
media:		div.s		$f4, $f1, $f2				# calcola la media pesata e stampa il risultato...
		li		$v0, 4
		la		$a0, msg2			
		syscall							
		li		$v0, 2
		mov.s		$f12, $f4
		syscall
		li		$v0, 4
		la		$a0, a_capo
		syscall
		syscall
		j		start					# riavvia il programma
			
error:		li		$v0, 4
		la		$a0, msg_err
		syscall							# mostra un messaggio di errore inserimento dati
		j		start					# e riavvia il programma
