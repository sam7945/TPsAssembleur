;27.10.2021
;(C) INF2171 2021
; TP Par Samuel Dextraze DEXS03039604 dextraze.samuel@courrier.uqam.ca 
; et Christophe Cloutier CLOC21119501 cloutier.christophe@courrier.uqam.ca
;
; Ce programme invite l'utilisateur à entrer un texte de maximum 300 caractères
; et filtre les nombres entiers de 0 à 32767. Le programme réaffiche le texte
; entré par l'utilisateur et affiche tous les nombres entiers de 0 à 32767 contenus
; dans celui-ci.

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




;
; afftexte: Affiche le texte entré par l'utilisateur.
; Passage des arguments par variables globales.
; IN:  len = longueur du tampon buffer
; OUT:

afftexte:ldbytea buffer,d    ;    A = buffer
         ldx     0,i         ;    X = 0
         charo   '\n',i      ;Affiche un saut de ligne
loopaff: cpx     len,d       ;    while ( x >= len ) {
         brge    affin       ;        
         charo   buffer,x    ;        System.out.print( buffer[X] )
         addx    1,i         ;        X += 1
         br      loopaff     ;    }
affin:   charo   '\n',i      ;Affiche un saut de ligne suite a l'affichage du texte.
         ret0


;
; affint: Affiche les nombres entiers contenus dans le texte entré
;         par l'utilisateur.
; Passage des arguments par variables globales.
; IN:  sizetab = longueur du tableau d'entiers
;      tabint = tableau des entiers
; OUT:


affint:  lda     tabint,d    ;    A = tabint
         ldx     0,i         ;    X = 0
loopaffi:cpx     sizetab,d   ;    while ( x < sizetab ) {
         brge    affinint    ;
         deco    tabint,x    ;        System.out.print( tabint[X])
         charo   ' ',i       ;        System.out.print( ' ' )
         addx    2,i         ;        X += 2  
         lda     compint,d   ;        A = compint
         cpa     3,i         ;        if ( A >= 3 ) {
         brge    printsp     ;            branch a "printsp" (Change de ligne et nettoye compint)
         adda    1,i         ;        A += 1
         sta     compint,d   ;        compint = A
         br      loopaffi    ;    }
printsp: charo   '\n',i      ;    System.out.print( '\n' )
         lda     0,i         ;    A = 0
         sta     compint,d   ;    compint = A
         br      loopaffi
affinint:charo   '\n',i      ;    System.out.print( '\n' 
         ret0;


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



;
; convint: Convertit un texte numérique (chaine de caractères) en
;          nombres entiers.
; Passage des arguments par variables globales.
; IN:  chaine = tableau contenant les nombres à convertir en entiers.
;      sizeint = le nombre de caractères que contient la chaine
;                de caractères à convertir en nombre entier.
; OUT: chiffre = le nombre entier convertit.


convint: ldx     0,i         ;    X = 0
         lda     0,i         ;    A = 0
         sta     chiffre,d   ;    chiffre = A
loopconv:ldbytea chiffre,d   ;    while ( X < sizeint) { A = chiffre
         adda    chaine,x    ;        A = A + chaine[X]
         suba    '0',i       ;        A = A - '0'
         cpx     sizeint,d   ;        
         brlt    x10         ;        branch a "x10" }
         br      finconv     ;    branch a "finconv"
x10:     sta     tempchif,d  ;    tempchiff = A
         asla                ;    A = A*2
         asla                ;    A = A*2
         adda    tempchif,d  ;    A = A + tempchiff
         asla                ;    A = A*2
         stbytea chiffre,d   ;    chiffre = A
         addx    2,i         ;    X += 2
         br      loopconv    ;    branch a "loopconv"
finconv: sta     chiffre,d   ;    chiffre = A
         ldx     0,i         ;    X = 0
         stx     tempchai,d  ;    tempchai = 0 
         ret0                ;






buffer:  .block  300         ;Tableau buffer du texte entré par l'utilisateur 
size:    .equate 300         ;Constante de la grosseur du tableau buffer maximum (300)

tabint:  .block  300         ;Tableau des nombres entiers à imprimer. 
sizetab: .word   0           ;Grosseur du tableau des nombres entiers.
compint: .word   0           ;compteur du nombre de nombres entiers a imprimer sur une ligne.

chaine:  .block  10          ; Tableau de chaine de string du chiffre, 2 par chiffre 
sizeint: .word   0           ;Grosseur du tableau populer, doit être de (nb de digits*2)-2
chiffre: .word   0           ;Chiffre en int de retour
tempchif:.word   0           ;Nombre temporaire pour la conversion

tempbuff:.word   0           ;Variable temporaire du tableau tampon buffer.
tempchai:.word   0           ;Variable temporaire du tableau de chaine.

len:     .word   0           ;
temp:    .block  1           ;
temp2:   .word   0           ;
err:     .ASCII  "Erreur : Débordement de capacité\x00"
soll:    .ASCII  "Veuillez entrer le texte à déchiffrer : "




         .end