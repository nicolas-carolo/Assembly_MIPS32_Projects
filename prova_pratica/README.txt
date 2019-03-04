il vettore 'accentate' contiene le lettere accentate espresse in codifica ASCII estesa.
Dal momento che la codifica ASCII estesa (8 bit = 256 configurazioni) può variare da calcolatore
a calcolatore (mentre le prime 128 sono universali), nel caso in cui non trovi compatibilità con Macintosh, tieni conto che l'ordine è il seguente:
à a(acuta) è é ì i(acuta) ò o(acuta) ù u(acuta) à a(acuta) è é ...
fino ad ottenere un vettore di 26 caratteri dal momento che il programma permettere di fare traslazioni
da 1 a 26 posizioni.