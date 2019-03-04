# verifica se il numero inserito da console è un numero primo
	.data
msg_yes:			.asciiz "Il numero inserito e' primo!\n"
msg_no:				.asciiz "Il numero inserito non e' primo!\n"
msg_nullo:			.asciiz "E' l'elemento nullo!\n"
msg_neutro:			.asciiz "E' l'elemento neutro!\n"
msg1:				.asciiz "Inserire un numero per verificare se e' primo:\n"
msg_neg:			.asciiz "Si prega di inserire un numero positivo!\n"
	
	.text
	
# $t0 = numero da verificare
# $t1 = divisore per verifica (min($t1) = 2)
# $t2 = risultato della divisione ($t0 / $t1)
# $t3 = resto della divione
	
restart:			li		$v0, 4
				la		$a0, msg1
				syscall							# stampa le istruzioni e lo scopo del programma
				li		$v0, 5
				syscall							# preleva da console il numero da verificare 
				move		$t0, $v0				# e lo pone in $t0
				blt		$t0, $zero, print_neg			# se il numero inserito da console e' negativo, chiede di inserirne uno positivo
				beq		$t0, 0, print_nullo			# stampa il risultato relativo allo zero
				beq		$t0, 1, print_neutro			# stampa il risultato relativo al numero 1
				beq		$t0, 2, print_yes			# se il numero inserito e' 2 dice che si tratta di un numero primo
				addi		$t1, $zero, 2				# inizializza il divisore a 2
ciclo:				div		$t2, $t0, $t1				# $t2 = $t0 / $t1
				mfhi		$t3					# copia il resto della divisione in $t3
				beq		$t3, $zero, print_no			# se il resto = 0, allora il numero inserito da console non e' primo; altrimenti,
				beq		$t1, 2, add_1				# se il divisore = 2, lo pone uguale a 3 (incrementa di 1)
				addi		$t1, $t1, 1						
add_1:				addi		$t1, $t1, 1				# se il divisore != 2, lo incrementa di 2
				blt		$t1, $t0, ciclo				# ripete il ciclo fino a che il divisore e' minore del dividendo
				j		print_yes
			

print_no:			li		$v0, 4
				la		$a0, msg_no
				syscall							# il numero non e' primo
				j		restart					# cicla il programma

print_yes:			li		$v0, 4
				la		$a0, msg_yes
				syscall							# il numero e' primo
				j		restart					# cicla il programma
			
print_nullo:			li		$v0, 4
				la		$a0, msg_nullo
				syscall							# elemento nullo
				j		restart					# cicla il programma
				
print_neutro:			li		$v0, 4
				la		$a0, msg_neutro
				syscall							# elemento neutro
				j		restart					# cicla il programma

print_neg:			li		$v0, 4
				la		$a0, msg_neg
				syscall							# errore: inserimento numero negativo!
				j		restart					# cicla il programma
