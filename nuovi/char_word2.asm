# programma che stampa a video le parole che contengono il carattere inserito da console

	.data
str:		.ascii "nel mezzo del cammin di nostra vita, "
			.ascii "mi ritrovai per una selva oscura, "
			.asciiz "che la diritta via era smarrita."
			
msg:		.asciiz "Inserire una lettera per cercare le parole che la contengono:\n"
a_capo:		.asciiz "\n"
alloc:		.space 30
mem_alloc:	.space 30
			
	.text
restart:	la		$t6, alloc
		move		$s1, $t6
		la		$s2, mem_alloc
		la		$a0, msg
		li		$v0, 4
		syscall
		move		$a0, $sp
		li		$v0, 8
		li		$a1, 3
		syscall
		lbu		$s0, 0 ($a0)
		la		$t8, str
ciclo:		lbu		$t0, 0 ($t8)
		bne		$t0, $s0, no_search
		move		$t7, $t8
		move		$t6, $s1
		jal		find_word
no_search:	addiu		$t8, $t8, 1
		bne		$t0, $zero, ciclo
		li		$v0, 4
		la		$a0, a_capo
		syscall
		j		restart
			
find_word:	beq		$t0, 0x20, space
		addiu		$t7, $t7, -1
		lbu		$t0, 0 ($t7)
		j		find_word

space:		addiu		$t7, $t7, 1
		lbu		$t0, 0 ($t7)
		sb		$t0, 0 ($t6)
		addiu		$t6, $t6, 1
		bne		$t0, 0x20, space
		sb		$zero, 0, ($t6)
		j		test_rep
			
test_rep:	la		$t6, alloc
		move		$t5, $s2
ciclo_rep:	lbu		$t1, 0 ($t6)
		lbu		$t2, 0 ($t5)
		bne		$t1, $t2, mem
		addiu		$t6, $t6, 1
		addiu		$t5, $t5, 1
		beq		$t1, $zero, no_print
		j		ciclo_rep
			
mem:		la		$t6, alloc
		move		$t5, $s2
ciclo_mem:	lbu		$t1, 0 ($t6)
		sb		$t1, 0 ($t5)
		addiu		$t6, $t6, 1
		addiu		$t5, $t5, 1
		bne		$t1, $zero, ciclo_mem
		j		print
			
print:		li		$v0, 4
		la		$a0, alloc
		syscall
			la		$a0, a_capo
			syscall
no_print:	jr		$ra			
