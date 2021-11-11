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
         cpa     '\n',i      ; if ( A == '\n' ) {
         breq    test        ;    branch a "test"
tts:     stbytea buffer,x    ; } else { buffer[x] = A }
         addx    1,i         ; X += 1
         cpx     size,i      ; if ( X == size(300) ) {
         breq    mess        ;    branch a "mess"
         br      loop        ; } else { branch a "loop" } 
test:    stbytea buffer,x    ; buffer[x] = A
         addx    1,i         ; X += 1
         chari   temp2,d     ;Demande le prochain byte et l'assigne a la variable temp2 
         ldbytea temp2,d     ; A = temp2
         cpa     '\n',i      ; if ( A == '\n' ) {
         breq    fin         ;    branch a "fin"
         br      tts         ; } else { branch a "tts" }
mess:    stro    err,d       ;Affiche le message d'erreur de debordement
         stop                ;Fin du programme
fin:     stx     len,d       ; len = X
         ret0



;************************************************************************
;********************   METHODE extrInts  ********************************
;************************************************************************

extrints:lda     0,i;
         ldx     0,i;

loop3:   lda     0,i
         ldx     tempbuff,d  ;load la valeur de la variable tempbuff dans le registre x (position du tableau buffer) 
         cpx     len,d       ;verifie si on est a l'exterieur du tableau buffer
         brge    fin5        ;si nous sommes a l'exterieur du tableau buffer, branch a fin 
         ldbytea buffer,x    ;load la valeur du premier element du buffer dans a (LA METHODE SE FINI ICI)
         addx    1,i         ;incremente la position dans le tableau buffer de 1
         stx     tempbuff,d  ;range la valeur de x (position tableau buffer) dans la variable tempbuff 
         ldx     0,i         ;nettoye le registre x
         call    nombre      ;verifie si le caractere se situe entre 0 et 9
         
caschiff:ldx     tempchai,d  ;si oui, load la valeur de la variable tempchai dans le registre x (position du tableau chaine)
         addx    2,i         ;ajoute x pour incrementer le tableau string
         stx     tempchai,d  ;store la valeur du x (position du tableau) dans la variable tempchai
         cpx     10,i        ;verifie si on deborde du tableau chaine
         brgt    loop3       ;si on depasse le max du tableau, on ne peut pas prendre le chiffre, on doit nettoyer le tableau chaine et continuer la lecture du texte.
         subx    2,i
         sta     chaine,x
         stx     sizeint,d
         ldx     0,i         ;nettoye le registre x
         br      loop3       ;branche a loop3

caslett: ldx     tempchai,d
         cpx     10,i
         brgt    nettab
         cpx     0,i
         brgt    ajout
         br      loop3

ajout:   call    convint
         lda     0,i;
         lda     chiffre,d
         cpa     0,i
         brge    affect
         br      loop3;

affect:  ldx     sizetab,d
         sta     tabint,x
         addx    2,i
         stx     sizetab,d
         br      loop3

nettab:  ldx     0,i
         lda     0,i
nettab1: sta     chaine,x
         addx    2,i
         cpx     8,i
         brle    nettab1
         sta     tempchai,d
         br      loop3

fin5:    ret0




;************************************************************************
;********************   METHODE extrInts  ********************************
;************************************************************************



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


;************************************************************************
;******************** SOUS METHODE nombre ******************************
;************************************************************************


nombre:  cpa     '0',i
         brlt    caslett  
         cpa     '9',i
         brgt    caslett
         br      caschiff   
         ret0


;************************************************************************
;******************** SOUS METHODE nombre ******************************
;************************************************************************



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

chaine:  .block  10; Tableau de chaine de string du chiffre, 2 par chiffre 
sizeint: .word   0;Grosseur du tableau populer, doit être de (nb de digits*2)-2
chiffre: .word   0;Chiffre en int de retour
tempchif:.word   0;Nombre temporaire pour la conversion

tempbuff:.word 0;
tempchai:.word 0;

len:     .word   0;
temp:    .block  1;
temp2:   .word   0;
err:     .ASCII  "Erreur : Débordement de capacité\x00"
soll:    .ASCII  "Veuillez entrer le texte a dechiffrer : "




         .end