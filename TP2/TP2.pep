 ;27.10.2021
;(C) INF2171 2021
;TP Par Samuel Dextraze DEXS03039604 dextraze.samuel@courrier.uqam.ca 
; et Christophe Cloutier CLOC21119501 cloutier.christophe@courrier.uqam.ca

         call    Saisir
         call    afftexte
         call    extrints
         call    affint

         STOP

;
; Saisir: Stocker le texte saisi par l'utilisateur dans
;         un tampon buffer de 300 octets. Si le texte est
;         plus de 300 octets, un message d'erreur s'affiche
;         et le programme s'arrete.
; Passage des arguments et des résultats par variables globales.
; IN:
; OUT: len = longueur du tampon buffer

Saisir:  lda     0,i         ;Nettoye le registre A
         ldx     0,i         ;Nettoye le registre X
         stro    soll,d      ;Affiche le message de sollicitation
loop:    chari   temp,d      ;Prend le prochain caractere et l'assigne a temp
         ldbytea temp,d      ;Load la variable contenant le caractère dans le registre A
         cpa     '\n',i      ;    if ( A == '\n' ) {
         breq    test        ;        branch a "test"
tts:     stbytea buffer,x    ;    } else { buffer[x] = A }
         addx    1,i         ;    X += 1
         cpx     size,i      ;    if ( X == size(300) ) {
         breq    mess        ;        branch a "mess"
         br      loop        ;    } else { branch a "loop" } 
test:    stbytea buffer,x    ;    buffer[x] = A
         addx    1,i         ;    X += 1
         chari   temp2,d     ;Demande le prochain byte et l'assigne a la variable temp2 
         ldbytea temp2,d     ;    A = temp2
         cpa     '\n',i      ;    if ( A == '\n' ) {
         breq    fin         ;        branch a "fin"
         br      tts         ;    } else { branch a "tts" }
mess:    stro    err,d       ;Affiche le message d'erreur de debordement
         stop                ;Fin du programme
fin:     stx     len,d       ;    len = X
         ret0



;
; extrints: Extrait les caracteres entre '0' et '9' du tableau
;           buffer. Les nombres de plus de 5 caracteres et dont la
;           valeur n'est pas dans l'interval '0' - '32767' sont ignores
; Passage des arguments et des résultats par variables globales.
; IN:  len = longueur du tampon buffer
; OUT: tabint = tableau contenant les entiers

extrints:lda     0,i         ;Nettoye le registre A
         ldx     0,i         ;Nettoye le registre X

loop3:   lda     0,i
         ldx     tempbuff,d  ;    X = tempbuff (la variable tempbuff = position dans le tableau buffer)
         cpx     len,d       ;    if ( X >= len ) {
         brge    fin2        ;        branch a "fin2" 
         ldbytea buffer,x    ;    } else { A = buffer[x] }
         addx    1,i         ;    X += 1
         stx     tempbuff,d  ;    tempbuff = X 
         ldx     0,i         ;Nettoye le registre x
         call    nombre      ;Appel de la sous-methode "nombre"
         
caschiff:ldx     tempchai,d  ;Si le caractere est un chiffre, X = tempchai (tempchai = position dans le tableau chaine)
         addx    2,i         ;    X += 2
         stx     tempchai,d  ;    tempchai = X
         cpx     10,i        ;    if ( X > 10 ) {
         brgt    loop3       ;        branch a "loop3" } 
                             ;si on depasse le max du tableau, on ne prend pas le chiffre.
         subx    2,i         ;    X -= 2
         sta     chaine,x    ;    chaine[X] = A
         stx     sizeint,d   ;    sizeint = X (sizeint = nombre de caracte du chiffre)
         ldx     0,i         ;nettoye le registre x
         br      loop3       ;branch a loop3

caslett: ldx     tempchai,d  ;Si le caractere est une lettre, X = tempchai
         cpx     10,i        ;    if ( X > 10 ) {
         brgt    nettab      ;        branch a "nettab" (nettoyer tabeleau)
         cpx     0,i         ;    } else if ( X > 0 ) {
         brgt    ajout       ;        branch a "ajout" (ajouter caractere dans le tableau chaine) }
         br      loop3       ;branch a "loop3"

ajout:   call    convint     ;Appel le sous programme convint
         lda     0,i         ;Nettoye le registre A
         lda     chiffre,d   ;    A = chiffre
         cpa     0,i         ;    if ( A >= 0 ) {
         brge    affect      ;        branch a "affect" (ajoute le chiffre dans le tableau de int) }
         br      loop3       ;Branch a "loop"

affect:  ldx     sizetab,d   ;    X = sizetab
         sta     tabint,x    ;    tabint[X] = A
         addx    2,i         ;    X += 2
         stx     sizetab,d   ;    sizatab = X
         br      loop3       ;Branch a "loop3"

nettab:  ldx     0,i         ;Nettoye le registre X
         lda     0,i         ;Nettoye le registre A
nettab1: sta     chaine,x    ;    while ( X < 8 ) {
         addx    2,i         ;        chaine[X] = 0
         cpx     8,i         ;        X += 2
         brle    nettab1     ;    }
         sta     tempchai,d  ;    tempchai = 0
         br      loop3       ;Branch a "loop3"

fin2:    ret0




;************************************************************************
;********************  METHODE afftexte *********************************
;************************************************************************

afftexte:ldbytea buffer,d;
         ldx     0,i;
         charo   '\n',i
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
         deco    tabint,x;
         charo   ' ',i
         addx    2,i;
         lda     compint,d
         cpa     3,i
         brge    printsp
         adda    1,i
         sta     compint,d
         br      loopaffi;
printsp: charo   '\n',i
         lda     0,i
         sta     compint,d
         br      loopaffi
affinint:charo   '\n',i; 
         ret0;



;************************************************************************
;********************  METHODE affInts **********************************
;************************************************************************


;
; Nombre: Identifier si un carractere represente le texte
;         numerique '0' a '9'.
; Passage des arguments par registres.
; IN: A = Caractere

nombre:  cpa     '0',i       ;    if ( A < 0 ) {
         brlt    caslett     ;        branch a "caslett" 
         cpa     '9',i       ;    } else if ( A > 9 ) {
         brgt    caslett     ;        branch a "caslett" }
         br      caschiff    ;    } else { branch a "caschiff" }
         ret0



;************************************************************************
;******************** SOUS METHODE convInt ******************************
;************************************************************************


convint: ldx     0,i;
         lda     0,i;
         sta     chiffre,d;
loopconv:ldbytea chiffre,d;
         adda    chaine,x;
         suba    '0',i;
         cpx     sizeint,d;
         brlt    x10;
         br      finconv;

x10:     sta tempchif,d; 
         asla
         asla
         adda tempchif,d
         asla 
         stbytea chiffre,d
         addx 2,i;
         br loopconv


finconv: sta chiffre,d
         ldx     0,i
         stx     tempchai,d;
         ret0;


;************************************************************************
;******************** SOUS METHODE convInt ******************************
;************************************************************************





buffer:  .block  300; 
size:    .equate   300;

tabint:  .block  300; 
sizetab: .word   0;
compint: .word   0           ;compteur du nombre de int a imprimer sur une ligne

chaine:  .block  10          ; Tableau de chaine de string du chiffre, 2 par chiffre 
sizeint: .word   0           ;Grosseur du tableau populer, doit être de (nb de digits*2)-2
chiffre: .word   0           ;Chiffre en int de retour
tempchif:.word   0           ;Nombre temporaire pour la conversion

tempbuff:.word 0;
tempchai:.word 0;

len:     .word   0;
temp:    .block  1;
temp2:   .word   0;
err:     .ASCII  "Erreur : Débordement de capacité\x00"
soll:    .ASCII  "Veuillez entrer le texte a dechiffrer : "




         .end