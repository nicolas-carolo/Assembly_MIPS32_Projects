# programma che stampa il punto più vicino a quello inserito da console

		.data
p_1:			.byte	20 	-2
p_2:			.byte	10	-4
p_3:			.byte	-5	2
p_4:			.byte	100	100
p_5:			.byte	-2	-10
		
				.space	6
		
msg_x:			.asciiz "x = "
msg_y:			.asciiz	"y = "
msg_1:			.asciiz	"Il seguente programma trova il punto nel piano cartesiano che si trova piu' vicino a quello digitato dall'utente (x,y = -128...127).\n"
msg_2:			.asciiz	"Il punto più vicino a p_u ("
msg_3:			.asciiz	";"
msg_4:			.asciiz	") e' p_"
a_capo:			.asciiz "\n"
msg_err:		.asciiz	"Inserire le coordinate rimandendo nell'intervallo di rappresentazione!\n"

		.text
		
# $t0 = x di p_u
# $t1 = y di p_u
# $t2 = x^2 di p_n
# $t3 = y^2 di p_n
# $t4 = distanza^2 di p_n da p_u
# $t5 = p_n con distanza minore
# $t6 = distanza^2 minore
# $t7 = contatore di n
# $t8 = puntatore alle coordinate dei punti salvati in memoria
		
			li		$v0, 4
			la		$a0, msg_1
			syscall							# stampa a video lo scopo del programma
				
start:			li		$v0, 4
			la		$a0, msg_x
			syscall							# stampa "x ="
				
			li		$v0, 5
			syscall							# legge x da console
			move		$t0, $v0					# e pone il valore in $t0
				
			li		$v0, 4
			la		$a0, msg_y
			syscall							# stampa "y ="
			
			li		$v0, 5
			syscall							# legge y da console
			move		$t1, $v0					# e pone il valore in $t1
			
			blt		$t0, -128, errore			# verifica che -128<= x <= 127
			bgt		$t0, 127, errore			# ...
			blt		$t1, -128, errore			# verifica che -128<= y <= 127
			bgt		$t1, 127, errore			# ...
			
			la		$t8, p_1
			li		$t7, 1					# inizializza a 1 il contatore di n
ciclo:			lb		$t2, 0 ($t8)				# carica in $t2 la x di p_n
			sub		$t2, $t2, $t0				# $t2 = x_p_n - x_p_u
			mul		$t2, $t2, $t2				# $t2 = $t2^2
			addiu		$t8, $t8, 1				# incrementa il puntatore all'area dati per puntare alla y di p_n
			lb		$t3, 0 ($t8)				# carica in $t3 la y di p_n
			sub		$t3, $t3, $t1				# $t3 = y_p_n - y_p_u
			mul		$t3, $t3, $t3				# $t3 = $t3^2
			addu		$t4, $t2, $t3				# calcola la distanza^2 di p_n dall'origine
			addiu		$t8, $t8, 1				# incrementa il puntatore all'area dati per puntare alla x di p_n+1
			bgt		$t7, 1, compare				# se n e' maggiore di 1 salta alla comparazione con la distanza^2 attualmente 											# minore, altrimenti
			move		$t6, $t4				# salva la prima distanza^2 calcolata in $t6
			move		$t5, $t7				# supponendo che essa sia la minore
			j		maggiore				# e salta a 'maggiore' per incrementare il valore di n
compare:		bgt		$t4, $t6, maggiore			# se la distanza^2 appena calcolata e' maggiore salta per incrementare il valore 											# di n, altrimenti
			move		$t6, $t4				# memorizza il valore di n
			move		$t5, $t7				# e salva la nuova distanza^2
maggiore:		addiu		$t7, $t7, 1				# incrementa il valore di n
			beq		$t7, 6, print				# se ha effettutao il calcolo e la comparazione di tutti i 5 punti, passa alla 											# stampa del risultato, altrimenti
			j		ciclo					# passa all'elaborazione della distanza^2 successiva

print:			li		$v0, 4					# stampa il punto con la distanza 											# minore...					
			la		$a0, msg_2
			syscall
			li		$v0, 1
			move		$a0, $t0
			syscall
			li		$v0, 4
			la		$a0, msg_3
			syscall
			li		$v0, 1
			move		$a0, $t1
			syscall
			li		$v0, 4
			la		$a0, msg_4
			syscall
			li		$v0, 1
			move		$a0, $t5
			syscall
			li		$v0, 4
			la		$a0, a_capo
			syscall
			j		start					# ...e riavvia il programma

errore:			li		$v0, 4
			la		$a0,msg_err
			syscall							# mostra un messaggio di errore se i parametri di input non sono 											# rispettati
			j		start					# e riavvia il programma
