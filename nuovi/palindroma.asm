# verifica se una stringa è palindroma

	.data
str:			.asciiz "rafar"
f_str:
msg_yes:		.asciiz "La stringa e' palindroma!"
msg_no:			.asciiz "La stringa non e' palindroma!"

	.text

# $s0 = lunghezza della stringa
# $t0 = puntatore (da sinistra a destra) alla stringa salvata in memoria
# $t1 = carattere letto da sinistra a destra
# $t2 = carattere letto da destra a sinistra
# $t7 = indirizzo di fine stringa
# $t8 = puntatore (da destra a sinistra) alla stringa salvata in memoria

			la	$t0, str
			la	$t8, f_str
			addiu	$t8, $t8, -1
			subu	$s0, $t8, $t0			# calcola la lunghezza della stringa
			move	$t7, $t8
			addiu	$t8, $t8, -1			# il puntatore da destra a sinistra viene preparato a puntare l'ultimo carattere della stringa
ciclo:			lb	$t1, 0 ($t0)			# legge il carattere da sinistra verso destra
			lb	$t2, 0 ($t8)			# legge il carattere da destra verso sinistra
			bne	$t1, $t2, no_pal		# se i caratteri precedentemente letti son diversi, allora la stringa non e' palindroma
			addiu	$t0, $t0, 1			# incrementa di uno il puntatore da sinistra a destra
			addiu	$t8, $t8, -1			# decrementa di uno il puntatore da destra a sinistra
			beq	$t0, $t7, pal			# se si e' giunti a fine lettura da destra a sinistra, allora la stringa e' palindroma
			j	ciclo
			
no_pal:			la	$a0, msg_no			# la stringa non e' palindroma
			j	print
			
pal:			la	$a0, msg_yes			# la stringa e' palindroma

print:			li	$v0, 4
			syscall					# stampa

fine:			j	fine
