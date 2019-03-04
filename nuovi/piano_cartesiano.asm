# programma che dati una serie di punti nel piano cartesiano individua quello piu' vicino all'origine (x = -128...127, y = -128...127)

		.data
p_1:			.byte	10	9
p_2:			.byte	23 	-2
p_3:			.byte	-3 	-9
p_4:			.byte	-1	-2
p_5:			.byte	100 100
			.space	6
dist:			.space	20

msg_1:			.asciiz	"Il punto piu' vicino all'origine e' p_"

		.text
		
# $t0 = x^2
# $t1 = y^2
# $t2 = dist^2
# $t6 = contatore numero di punti elaborati
# $t7 = puntatore al vettore delle distanze
# $t8 = puntatore alle coordinate dei punti salvati in memoria

			li		$t6, 1
			la		$t7, dist
			la		$t8, p_1
ciclo:			lb		$t0, 0 ($t8)			# carica in $t0 la x del punto
			mul		$t0, $t0, $t0			# x^2
			addiu		$t8, $t8, 1			# incrementa il puntatore delle coordinate per leggere la y del punto
			lb		$t1, 0 ($t8)			# carica in $t1 la y del punto
			mul		$t1, $t1, $t1			# y^2
			addu		$t2, $t0, $t1			# calcola la distanza^2
			sw		$t2, 0 ($t7)			# salva la distanza^2 nel vettore dist
			beq		$t6, 5, compare			# se si ha calcolato la distanza^2 di tutti i punti si va a cercare quella minore
			addiu		$t7, $t7, 4			# incrementa il puntatore al vettore dist
			addiu		$t8, $t8, 1			# incrementa il puntatore alle cordinate per leggere la x del punto successivo
			addiu		$t6, $t6, 1			# incrementa di uno il contatore del punto
			j		ciclo

# $t0 = distanza^2 minore
# $t1 = distanza^2 da confrontare con quella che precedentemente era minore	
# $t5 = numero del punto con distanza minore dall'origine		
			
compare:		la		$t7, dist
			li		$t6, 1
			li		$t5, 1				# si suppone che il punto con distanza minore dall'orgine sia p_1
			lw		$t0, 0 ($t7)			# e si carica il valore della sua distanza^2 in $t0
			addiu		$t7, $t7, 4			# incrementa il puntatore al vettore dist
ciclo_2:		beq		$t6, 5, print			# salta alla stampa del punto con distanza minore dall'origine se si ha terminato il confronto
			lw		$t1, 0, ($t7)			# carica il $t1 il valore della distanza^2 da confrontare con quella attualmente minore
			addiu		$t7, $t7, 4			# incrementa il puntatore al vettore dist
			addiu		$t6, $t6, 1			# incrementa il contatore del punto
			blt		$t0, $t1, ciclo_2		# se la distanza^2 minore è quella precedente passa al confronto con quella del punto successivo, altrimenti						 
			move		$t0, $t1			# aggiorna $t0 con la nuova distanza^2 minore
			move		$t5, $t6			# e $t5 con il numero del punto a cui appartiene
			j		ciclo_2

#stampa il numero del punto con la distanza minore dall'origine			
print:			li		$v0, 4
			la		$a0, msg_1
			syscall
			li		$v0, 1
			move		$a0, $t5
			syscall
fine:			j		fine
