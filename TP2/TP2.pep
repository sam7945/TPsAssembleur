 ;27.10.2021
;(C) INF2171 2021
;TP Par Samuel Dextraze DEXS03039604 dextraze.samuel@courrier.uqam.ca 
; et Christophe Cloutier CLOC21119501 cloutier.christophe@courrier.uqam.ca

         call    Saisir
         call    afftexte
         call    extrints
extr:    call    affint

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
         cpx     size,d      ;Compare cette valeur a la longueur max du tableau (300)
         breq    mess        ;Si len == size (300) branch a mess (message d'erreur)
         br      loop        ;Si non branch a loop

test:    stbytea buffer,x    ;même si la valeur suivante est probablement un autre '\n', il faut quand même l'inséré au cas ou ce n'est qu'un saut de ligne
         ;addx    1,i
         chari   temp2,d     ;demande le prochain byte et l'assigne a la variable temp2 
         ldbytea temp2,d     ;load la variable temp2 dans le registre a.
         cpa     '\n',i      ;compare temp2 a "\n"
         breq    fin       ;Si temp2 est un "\n" print le tableau (a modifier pour le projet final)
         br      tts         ;Si non on continue lexecution du programme
mess:    stro    err,d       ;Message d'erreur si debordement
fin:     stx     len,d
         ret0




;************************************************************************
;********************   METHODE SAISIR   ********************************
;************************************************************************



;************************************************************************
;********************   METHODE extrInts  ********************************
;************************************************************************

extrints:lda     0,i;
         ldx     0,i;

loop3:   lda     0,i
         ldx     tempbuff,d  ;load la valeur de la variable tempbuff dans le registre x (position du tableau buffer) 
         cpx     len,d       ;verifie si on est a l'exterieur du tableau buffer
         brge    extr        ;si nous sommes a l'exterieur du tableau buffer, branch a fin 
         ldbytea buffer,x    ;load la valeur du premier element du buffer dans a (LA METHODE SE FINI ICI)
         addx    1,i         ;incremente la position dans le tableau buffer de 1
         stx     tempbuff,d  ;range la valeur de x (position tableau buffer) dans la variable tempbuff 
         ldx     0,i         ;nettoye le registre x
         
         call    nombre      ;verifie si le caractere se situe entre 0 et 9
         
caschiff:ldx     tempchai,d  ;si oui, load la valeur de la variable tempchai dans le registre x (position du tableau chaine)
         addx    2,i         ;ajoute x pour incrementer le tableau string
         stx     tempchai,d  ;store la valeur du x (position du tableau) dans la variable tempchai
         cpx     8,i         ;verifie si on deborde du tableau chaine
         brgt    loop3       ;si on depasse le max du tableau, on ne peut pas prendre le chiffre, on doit nettoyer le tableau chaine et continuer la lecture du texte.
         subx    2,i
         sta     chaine,x
         stx     sizeint,d
         ldx     0,i         ;nettoye le registre x
         br      loop3       ;branche a loop3

caslett: ldx     tempchai,d
         cpx     8,i
         brgt    nettab
         cpx     0,i
         brgt    ajout
         br      loop3

ajout:   call    convint
         lda     0,i;
         lda     chiffre,d
         cpa     0,i
         brge    affect
         cpa     32767,i;
         brgt    loop3
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






;************************************************************************
;********************   METHODE extrInts  ********************************
;************************************************************************



;************************************************************************
;********************  METHODE afftexte *********************************
;************************************************************************

afftexte:ldbytea buffer,d;
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
         deco   tabint,x;
         addx    2,i;
         br      loopaffi;
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
size:    .equate 300;

tabint:  .block  300; 
sizetab: .word   0;

chaine:  .block  10;Tableau de chaine de string du chiffre, 2 par chiffre
sizeint: .word   0;Grosseur du tableau populer, doit être de (nb de digits*2)-2
chiffre: .word   0;Chiffre en int de retour
tempchif:.word   0;Nombre temporaire pour la conversion

tempbuff:.word 0;
tempchai:.word 0;

len:     .word   0;
temp:    .block  1;
temp2:   .word   0;
err:     .ASCII  "Erreur : Débordement de capacité\x00"




         .end