# programma che esegue il controllo del corretto funzionamento della memoria RAM
# scrivendo in memoria e controllando se ciò che viene letto corrisponde a quello
# scritto in precedenza

# $t0 usato come puntatore alla memoria
# e come dato da memorizzare/controllare
# $t1 usato come indice di fine check
# $t2 usato per il dato riletto

	li	$t0, 0x10000000
	lui	$t1, 0x1001

write:	sw	$t0, 0 ($t0)
	addi	$t0, $t0, 4
	slt	$t3, $t0, $t1
	bne	$t3, $zero, write

	li	$t0, 0x10000000
	
read:	lw	$t2, 0, ($t0)
	bne	$t2, $t0, error
	addi 	$t0, $t0, 4 
	slt	$t3, $t0, $t1
	bne	$t3, $zero, read

ok:	j	ok

error:	j	error
