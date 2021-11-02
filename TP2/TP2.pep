;27.10.2021
;(C) INF2171 2021
;TP Par Samuel Dextraze DEXS03039604 dextraze.samuel@courrier.uqam.ca 
; et Christophe Cloutier CLOC21119501 cloutier.christophe@courrier.uqam.ca

         call    Saisir
         call    afftexte
         ;call    affint

         STOP

;************************************************************************
;********************   METHODE SAISIR   ********************************
;************************************************************************

Saisir:  lda     0,i         ;Nettoye le registre a 0 pour analysé la variable 
         ldx     0,i         ;Nettoye le registre a 0 pour COMPTER
loop:    chari   temp,d      ;Prend le premier caractere et l'assigne a temp
         ldbytea temp,d      ;met la variable contenant le caractère dans le registre a
         cpa     '\n',i      ;Compare a "\n"
         breq    test        ;Si c'est "\n" branch a test
tts:     stbytea buffer,x    ;Si non store le byte dans buffer a l'indice x
         addx    1,i         ;Ajoute 1 a x (prochaine case du tableau)
         ;lda     len,d       ;Load la longueur du tableau actuel dans a
         ;adda    1,i         ;Ajoute 1 a cette valeur (compteur)
         ;sta     len,d       ;Store la valeur dans la variable len
         cpx     size,d      ;Compare cette valeur a la longueur max du tableau (300)
         breq    mess        ;Si len == size (300) branch a mess (message d'erreur)
         br      loop        ;Si non branch a loop

test:    stbytea buffer,x    ;même si la valeur suivante est probablement un autre '\n', il faut quand même l'inséré au cas ou ce n'est qu'un saut de ligne
         addx    1,i
         chari   temp2,d     ;demande le prochain byte et l'assigne a la variable temp2 
         ;lda     0,i         ;nettoye le registre a
         ldbytea temp2,d     ;load la variable temp2 dans le registre a.
         cpa     '\n',i      ;compare temp2 a "\n"
         breq    fin       ;Si temp2 est un "\n" print le tableau (a modifier pour le projet final)
         
         br      tts         ;Si non on continue lexecution du programme
;print:   ldx     len,d       ;ON NE VA PAS PRINT DANS CETTE METHODE *** A MODIFIER **
;         subx    1,i;
;loop2:   charo   buffer,x; 
;         subx    1,i;
;         cpx     0,i;
;         brge    loop2;
;         charo   '\n',i;
;         deco    len,d;
;         br      fin;
mess:    stro    err,d       ;Message d'erreur si debordement
fin:     stx     len,d
         ret0




;************************************************************************
;********************   METHODE SAISIR   ********************************
;************************************************************************

;************************************************************************
;********************  METHODE afftexte *********************************
;************************************************************************

afftexte:ldbytea     buffer,d;
         ldx     0,i;
loopaff: cpx     len,d; 
         brge    affin;
         charo   buffer,x;
         addx    1,i;
         br      loopaff;
affin:   charo   '\n',i; 
         ret0;

;************************************************************************
;********************  METHODE afftexte *********************************
;************************************************************************

;************************************************************************
;********************  METHODE affInts **********************************
;************************************************************************


affint:  lda     tabint,d;
         ldx     0,i;
loopaffi:cpx     sizetab,d; 
         brge    affinint;
         charo   tabint,x;
         addx    1,i;
         br      loopaffi;
affinint:charo   '\n',i; 
         ret0;



;************************************************************************
;********************  METHODE affInts **********************************
;************************************************************************





buffer:  .block  300;
size:    .word   300;

tabint:  .block  300; 
sizetab: .word   0;
sizeint: .word   0;

len:     .word   0;
temp:    .block  1;
temp2:   .word   0;
err:     .ASCII  "Erreur : Débordement de capacité\x00"




         .end