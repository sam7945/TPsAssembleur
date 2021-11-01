;27.10.2021
;(C) INF2171 2021
;TP Par Samuel Dextraze DEXS03039604 dextraze.samuel@courrier.uqam.ca 
; et Christophe Cloutier CLOC21119501 cloutier.christophe@courrier.uqam.ca

         call    Saisir



         STOP

************************************************************************
********************   METHODE SAISIR   ********************************
************************************************************************

Saisir:  lda     0,i         ;Nettoye le registre a 0
         ldx     0,i         ;Nettoye le registre a 0
loop:    chari   temp,d      ;Prend le premier caractere et l'assigne a temp
         ldbytea temp,d      ;Load le byte du char dans temp
         cpa     0x0a,i      ;Compare a "\n"
         breq    test        ;Si c'est "\n" branch a test
tts:     stbytea buffer,x    ;Si non store le byte dans buffer a l'indice x
         addx    1,i         ;Ajoute 1 a x (prochaine case du tableau)
         lda     len,d       ;Load la longueur du tableau actuel dans a
         adda    1,i         ;Ajoute 1 a cette valeur (compteur)
         sta     len,d       ;Store la valeur dans la variable len
         cpa     size,d      ;Compare cette valeur a la longueur max du tableau (300)
         breq    mess        ;Si len == size (300) branch a mess (message d'erreur)
         br      loop        ;Si non branch a loop

test:    chari   temp2,d     ;demande le prochain byte et l'assigne a la variable temp2 
         lda     0,i         ;nettoye le registre a
         ldbytea temp2,d     ;load la variable temp2 dans le registre a.
         cpa     0x0a,i      ;compare temp2 a "\n"
         breq    print       ;Si temp2 est un "\n" print le tableau (a modifier pour le projet final)
         br      tts         ;Si non on continue lexecution du programme
print:   ldx     len,d       ;ON NE VA PAS PRINT DANS CETTE METHODE *** A MODIFIER **
         subx    1,i;
loop2:   charo   buffer,x; 
         subx    1,i;
         cpx     0,i;
         brge    loop2;
         charo   '\n',i;
         deco    len,d;
         br      fin;
mess:    stro    err,d       ;Message d'erreur si debordement
fin:     ret0




************************************************************************
********************   METHODE SAISIR   ********************************
************************************************************************

buffer:  .block  300;
size:    .word   300;
len:     .word   0;
temp:    .block  1;
temp2:   .word   0;
err:     .ASCII  "Erreur : Débordement de capacité\x00"




         .end