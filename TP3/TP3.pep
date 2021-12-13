;22.11.2021
;(C) INF2171 2021
; TP Par Samuel Dextraze DEXS03039604 dextraze.samuel@courrier.uqam.ca 
; et Christophe Cloutier CLOC21119501 cloutier.christophe@courrier.uqam.ca
; Ce programme g�re un agenda hebdomadaire des �v�nements


         CALL    agenda
         CALL    affAgd

         STOP

;agenda
;Cette methode permet de prendre en note les �v�nements d'un agenda
;par un utilisateur.
;
agenda:  CALL    saisir      ;Appel de la fonction saisir
         RET0 
         
         

;saisir
;Cette methode affiche un menu contenant 2 options (1- Saisir 2- Quitter). La fonction
;Saisir permet � l'utilisateur d'entrer l'information sur un seul �v�nement. La fonction
;Quitter permet d'arr�ter la saisie de nouveau �v�nements.
;
saisir:  STRO    menu,d      ;    Print( menu )
         subsp   variable,i  ;    allocation pile #optMen #saveX #saveA 
         lda     0,i
         ldx     0,i
         CHARI   optMen,s    ;    Sollicitation optMen
         LDBYTEX optMen,s    ;    X = optMen
cp:      CPX     '\n',i      ;    if (x  == '\n' ) {
         BREQ    nextChar    ;        branch nextchar
         CPX     '1',i       ;    } else if ( x == 1 ) {
         BREQ    nextEven    ;        branch "nexteven 
         CPX     '2',i       ;    } else if ( x == 2 ) {
         BREQ    quitMenu    ;        branch "quitmenu"
         STRO    errMenu,d   ;    } else {    Print(errMenu)
         addsp   variable,i  ;        dealocate #optMen #saveX #saveA 
         br      saisir      ;        branch "saisir" }
nextChar:CHARI   0,s         ;    prochain caractere
         LDBYTEX 0,s         ;    X = optMen
         br      cp          ;    branch cp
nextEven:CALL    creer       ;    call creer()
         CALL    inserer     ;    call inserer() 
         ADDSP   variable,i  ;    desalocation pile #optMen #saveX #saveA 
         BR      saisir          
quitMenu:addsp   variable,i  ;    desalocation pile #optMen #saveX #saveA 
         RET0                ;Retourne � agenda et quitte 
;Variables Locales
saveA:   .EQUATE 0           ;#2d
saveX:   .EQUATE 2           ;#2d
optMen:  .EQUATE 4          ;#2d option du menu
variable:.EQUATE 6           


;creer
;Cette methode permet de saisir les donnees sur un nouvel evenement soit
;le jour, l'heure et la duree. Si les donnees sont conformes, l'objet est
;cree.
;OUT: saveX = adresse d'un maillon evenement
;
creer:   SUBSP   2,i         ;    allocation pile #eventC 
         LDA     adrObj,i    ;    A = adrObj 
         CALL    new         ;    eventC = malloc(10) #prJour #prDebut #prDuree #prSuiv #prPrec
         LDA     0,i 
         STX     eventC,s    ;    eventC = adresse du nouvel objet
         CALL    evenJour
         LDA     4,s         ;    A = saveA
         CPA     NULL,i      ;    if ( A == NULL ) {
         BREQ    fin         ;        branch "fin" }
         STA     prJour,x    ;    eventC[jour] = A
         LDA     0,i
         CALL    evenHeur
         LDA     4,s         ;    A = saveA
         CPA     0,i         ;    if ( A < 0 ) {
         BRLT    fin         ;        branch "fin" }
         CPA     1440,i      ;    } else if ( A > 1440 )
         BRGT    fin         ;        branch "fin" }
         STA     prDebut,x   ;    eventC[debut] = A
         LDA     0,i
         CALL    evenDure
         LDA     4,s         ;    A = saveA
         CPA     NULL,i      ;    if ( A == 0 ) {
         BREQ    fin         ;        branch "fin" }
         CPA     1440,i      ;    } else if ( A > 1440 ) {
         BRGT    fin         ;        branch "fin"
         STA     prDuree,x   ;    } else { eventC[dur�e] = A }
         LDA     NULL,i      ;    A = NULL
         STA     prSuiv,x    ;    eventC[suivant] = NULL
         STA     prPrec,x    ;    eventC[precedent] = NULL
         LDX     eventC,s    ;    X = addresse eventC
         STX     6,s 
         RET2                ;    Desallocation pile #eventC 
fin:     LDA     NULL,i      ;    A = NULL
         STA     prJour,x    ;    prJour = A
         STA     prDebut,x   ;    prDebut = A
         STA     prDuree,x   ;    prDuree = A
         STA     prSuiv,x    ;    prSuiv = A
         STA     prPrec,x    ;    prPrec = A
         LDX     NULL,i      ;    X = NULL  (retourne l'adresse NULL puisque l'�v�nement n'est pas cr��)
         STX     6,s
         RET2                ;    Desallocation pile #eventC 
eventC:  .EQUATE 0           ; #2h 
NULL:    .EQUATE 0           ; #2d null
; ****** Structure event
prJour:  .EQUATE 0           ; #2d jour de l'�v�nement
prDebut: .EQUATE 2           ; #2d heure de d�but
prDuree: .EQUATE 4           ; #2d dur�e
prSuiv:  .EQUATE 6           ; #2h pointeur vers le suivent
prPrec:  .EQUATE 8           ; #2h pointeur vers le pr�c�dent
adrObj:  .EQUATE 10






;evenJour
;Cette methode fait la sollicitation du Jour pour la creation d'un evenement.
;OUT : saveA = jour
;
evenJour:STRO    sollJour,d  ;    Print(sollJour)
         SUBSP   resJour,i   ;    allocation pile #resJour 
         DECI    spJour,s    ;    spJour = choix utilisateur
         LDA     spJour,s    ;    A = spJour
         CPA     minJour,i   ;    if ( A < 1 ) {
         BRLT    errJour     ;        branch "errJour" 
         CPA     maxJour,i   ;    } else if ( A > 7 ) {
         BRGT    errJour     ;        branch "errJour" }
         STA     8,s         ;    saveA = A
         ADDSP   resJour,i   ;    desalocation pile #resJour
         RET0
errJour: STRO    errForma,d  ;    Print(errForma)
         LDA     NULL,i      ;    A = NULL
         STA     8,s         ;    saveA = A
         ADDSP   resJour,i   ;    desallocation pile #resJour
         RET0
;variables locales
spJour:  .EQUATE 0           ;#2d
resJour: .EQUATE 2           ;#2d
minJour: .EQUATE 1
maxJour: .EQUATE 7

;evenHeur
;Cette methode fait la sollicitation de l'Heure/minutes de debut pour la creation d'un evenement.
;OUT : saveA = le temps en minute
;
evenHeur:STRO    sollHeur,d  ;    Print(sollHeur) 
         SUBSP   resHeure,i  ;    allocation pile #resHeure
         DECI    spHeure,s   ;    spHeure = choix utilisateur
         LDA     spHeure,s   ;    A = spHeure
         CPA     minHeur,i   ;    if ( A < 0 ) {
         BRLT    errHeure    ;        branch "errHeure"
         CPA     maxHeur,i   ;    } else if ( A > 1440 ) {
         BRGT    errHeure    ;        branch "errHeure" }
         STA     8,s         ;    saveA = A
         ADDSP   resHeure,i  ;    Desallocation pile #resHeure
         RET0
errHeure:STRO    errForma,d  ;    Print(errForma)
         STA     8,s         ;    saveA = A
         ADDSP   resHeure,i  ;    Desallocation pile #resHeure
         RET0
;variable locale
spHeure: .EQUATE 0           ;#2d
resHeure:.EQUATE 2           ;#2d
minHeur: .EQUATE 0
maxHeur: .EQUATE 1440

;evenDure
;Cette methode fait la sollicitation de l'Heure/minutesde duree pour la creation d'un evenement.
;OUT : saveA = le temps en minute
;
evenDure:STRO    sollDure,d  ;    Print(sollDure)
         SUBSP   resDuree,i  ;    Allocation pile #resDuree
         DECI    spDuree,s   ;    spDuree = choix utilisateur
         LDA     spDuree,s   ;    A = spDuree
         CPA     minDuree,i  ;    if ( A < 1 ) {
         BRLT    errDuree    ;        branch "errDuree"
         CPA     maxDuree,i  ;    } else if ( A > 1440 ) {
         BRGT    errDuree    ;        branch "errDuree"
         STA     8,s         ;    saveA = A
         ADDSP   resDuree,i  ;    Desallocation pile #resDuree
         RET0
errDuree:STRO    errForma,d  ;    Print(errForma)
         STA     8,s         ;    saveA = A    
         ADDSP   resDuree,i  ;    Desallocation pile #resDuree
         ret0
;variable locale
spDuree: .EQUATE 0           ;#2d
resDuree:.EQUATE 2           ;#2d
minDuree:.EQUATE 1
maxDuree:.EQUATE 1440


;inserer
;Cette methode permet d'ins�rer un �v�nement dans la liste chain�e d'�v�nement
;seulement si celui-ci est conforme au format demand�.
;
;IN : saveX = Adresse de l'�v�nement a inserer
;OUT : saveA = Evenement ins�rer. (0 False, 1 True)
inserer: LDX     4,s         ;    X = saveX
         CPX     NULL,i      ;    if ( X == NULL ) {
         BREQ    nonConf     ;        branch "nonConf"
         LDA     compteur,d  ;    } else { A = compteur
         ADDA    1,i         ;        A += 1
         STA     compteur,d  ;        compteur = A
         CPA     1,i         ;    if (A == 1) {
         BREQ    premEven    ;        branch "premEven"
         LDA     debChain,d  ;    } else { A = debChain
         CALL    comparer    ;        call comparer }
nonConf: LDA     0,i         ;    A = 0
         STA     2,s         ;    saveA = A
         RET0
premEven:STX     debChain,d  ;    X = debChain
         ADDX    evenPr,i    ;    X += evenPr (adresse evenement precedent)
         LDA     NULL,i      ;    A = NULL
         STA     eventC,x    ;    evenement precedent = NULL
         SUBX    evenPr,i    ;    X = debChain
         ADDX    suivEven,i  ;    X = adresse evenement suivant
         LDA     NULL,i      ;    A = NULL
         STA     eventC,x    ;    evenement suivant = NULL
         LDA     1,i
         STA     2,s         ;    saveA = A
         RET0
;variable locales
suivEven:.EQUATE 6           ; adresse de l'evenement suivant
evenPr:  .EQUATE 8           ; adresse de l'evenement precedent
compteur:.WORD   0           ;compteur du nombre d'�v�nement existant dans la liste chain�e
debChain:.WORD   0           ; Adresse du debut de la liste chaine


;comparer
;Cette methode permet de comparer deux objets evenements en commencant
;au premier evenement de la liste chaine (ordre chronologique) et fait l'insertion
;de celui-ci au bon endroit.
;
;IN : saveX = Adresse de l'objet Evenement a inserer
;
comparer:SUBSP   20,i        ; #dureComp #heurComp #jourComp #chainDur #chainHeu #chainJour #nextcomp #addObjCh #addNewOb #addTempo
         LDX     26,s        ;    X = saveX
         LDA     debChain,d  ;
         STA     addObjCh,s  ;    addObjCh = A
         STX     addNewOb,s  ;    addNewOb = X
loop:    ADDX    day,i       ;    X += day
         STX     tempo,d     ;    tempo = X
         LDX     tempo,n     ;    X = evenement[jour]
         STX     jourComp,s  ;    jourComp = X
         LDX     tempo,d     ;    X = Evenement[jour]
         SUBX    day,i       ;    X = adresse Evenement

         ADDX    hour,i      ;    X += hour
         STX     tempo,d     ;    tempo = X
         LDX     tempo,n     ;    X = evenement[heure]
         STX     heurComp,s  ;    heurComp = X
         LDX     tempo,d     ;    X = evenement[jour]
         SUBX    hour,i      ;    X = adresse Evenement

         ADDX    time,i      ;    X += time
         STX     tempo,d     ;    tempo = X
         LDX     tempo,n     ;    X = evenement[duree]
         STX     dureComp,s  ;    dureComp = X
         LDX     tempo,d     ;    X = evenement[duree]
         SUBX    time,i      ;    X = adresse Evenement

         ADDA    day,i       ;    A += day
         STA     tempo,d     ;    tempo = A
         LDA     tempo,n     ;    A = evenementchaine[jour]
         STA     chainJou,s  ;    chainJour = A
         LDA     tempo,d     ;    A = evenementchaine[jour]
         SUBA    day,i       ;    A = adresse evenementchaine

         ADDA    hour,i      ;    A += hour
         STA     tempo,d     ;    tempo = A
         LDA     tempo,n     ;    A = evenementchaine[heure]
         STA     chainHeu,s  ;    chainHeu = A
         LDA     tempo,d     ;    A = evenementchaine[heure]
         SUBA    hour,i      ;    A = adresse evenementchaine
         
         ADDA    time,i      ;    A += time
         STA     tempo,d     ;    tempo = A
         LDA     tempo,n     ;    A = evenementchaine[duree]
         STA     chainDur,s  ;    chainDur = A
         LDA     tempo,d     ;    A = evenementchaine[duree]
         SUBA    time,i      ;    A = adresse evenementchaine
compa1:  LDA     jourComp,s  ;    A = jourComp
         CPA     chainJou,s  ;    if ( jourComp < chainJou ) {
         BRLT    preced      ;        branch "preced"
         CPA     chainJou,s  ;    } else if ( jourComp == chainJou ) {
         BREQ    compa2      ;        branch "compa2"
         BR      suivant     ;    } else { branch "suivant" }
compa2:  LDA     heurComp,s  ;    A = heurComp
         CPA     chainHeu,s  ;    if ( heurComp = chainHeu ) {
         BREQ    conflit     ;        branch "conflit"
         CPA     chainHeu,s  ;    } else if ( heurComp < chainHeu ) {
         BRLT    veriMoin    ;        branch "veriMoin"
         BR      veriPlus    ;    } else { branch "veriPlus" }
veriMoin:ADDA    dureComp,s  ;    A += dureComp
         CPA     chainHeu,s  ;    if ( A > chainHeu) {
         BRGT    conflit     ;        branch "conflit"
         BR      suivant     ;    } else { branch "suivant" }
veriPlus:LDA     chainHeu,s  ;    A = chainHeu
         ADDA    chainDur,s  ;    A += chainDur
         CPA     heurComp,s  ;    if ( A > heurComp) {
         BRGT    conflit     ;        branch "conflit"
         BR      suivant     ;    } else { branch "suivant" }
preced:  LDA     addObjCh,s  ;    A = adresse addObjCh
         ADDA    prec,i      ;    A = adresse evenementchain[precedent]
         STA     addObjCh,s  ;    addObjCh = A
         LDA     addObjCh,sf ;    A = evenement chaine precedent
         CPA     NULL,i      ;    if ( A == NULL ) {
         BREQ    listPrem    ;        branch "listPrem"
         BR      listAutr    ;    } else { branch "listAutr" }
suivant: LDA     addObjCh,s  ;    A = addObjCh
         ADDA    suiv,i      ;    A = adresse evenementchain[suivant]
         STA     addObjCh,s  ;    addObjCh = A
         LDA     addObjCh,sf ;    A = evenement chaine suivant
         CPA     NULL,i      ;    if ( A == NULL ) {
         BREQ    listFin     ;        branch "listFin"
         STA     addObjCh,s  ;    } else { addObjCh = A }
         BR      loop        ;    branch "loop"
listPrem:LDA     addObjCh,s  ;    A = addObjCh
         SUBA    prec,i      ;    A = A - prec
         STA     addObjCh,s  ;    addObjCh = A
         LDX     addNewOb,s  ;    X = addNewOb
         ADDX    suiv,i      ;    X = X + suiv
         STX     addNewOb,s  ;    addNewOb = X
         STA     addNewOb,sf ;    nouvel objet[suivant] = adresse objet chaine
         SUBX    suiv,i      ;    X = X - suiv
         ADDA    prec,i      ;    A = A + prec
         STA     addObjCh,s  ;    addObjCh = A
         STX     addObjCh,sf ;   objet chaine[precedent] = adresse nouvel objet
         STX     debChain,d
         ADDSP   20,i        ; #dureComp #heurComp #jourComp #chainDur #chainHeu #chainJour #nextcomp #addObjCh #addNewOb #addTempo
         RET0
listAutr:LDA     addObjCh,s  ;    A = addObjCh
         SUBA    prec,i      ;    A = A - prec
         STA     addObjCh,s  ;    addObjCh = A
         LDX     addNewOb,s  ;    X = addNewOb
         ADDX    suiv,i      ;    X += suiv
         STX     addNewOb,s  ;    addNewOb = X
         STA     addNewOb,sf ;    nouvel objet[suivant] = adresse objet chaine suivant
         SUBX    suiv,i      ;    X = X - suiv
         STX     addNewOb,s  ;    addNewOb = X 
         ;nouvel objet[precedent]
         LDX     addNewOb,s  ;    X = addNewOb
         ADDX    prec,i      ;    X += prec
         STX     addNewOb,s  ;    addNewOb = X
         LDA     addObjCh,s  ;    A = addObjCh
         ADDA    prec,i      ;    A += prec
         STA     addObjCh,s  ;    addObjCh = A
         LDA     addObjCh,sf ;    
         STA     addNewOb,sf ;    nouvel objet[precedent] = adresse objet chaine precedent
         LDA     addObjCh,s  ;    A = addObjCh
         SUBA    prec,i      ;    A = A - prec
         STA     addObjCh,s  ;    addObjCh = A
         SUBX    prec,i      ;    X = X - prec
         STX     addNewOb,s  ;    addNewOb = X
         ;objet suivant[precedent] et objet precedent[suivant]
         LDX     addNewOb,s  ;    X = addNewOb
         LDA     addObjCh,s  ;    A = addObjCh
         STA     addTempo,s  ;    addTempo = A
         ADDA    prec,i      ;    A += prec
         STA     addObjCh,s  ;    addObjCh = A
         STX     addObjCh,sf ;    objet chaine[precedent] = adresse nouvel objet[precedent]
         LDA     addNewOb,s  ;    A = addNewOb
         ADDA    prec,i      ;    A += prec
         STA     addTempo,s  ;    addTempo = A
         LDA     addTempo,sf ;    A = adresse nouvel objet
         ADDA    suiv,i      ;    A += suiv
         STA     addTempo,s  ;    addTempo = A
         LDA     addNewOb,s  ;    A = addNewOb
         STA     addTempo,sf ;    addTempo = A
         ADDSP   20,i        ; #dureComp #heurComp #jourComp #chainDur #chainHeu #chainJour #nextcomp #addObjCh #addNewOb #addTempo 
         RET0
listFin: LDA     addObjCh,s  ;    A = addObjCh
         SUBA    suiv,i      ;    A = A - suiv
         STA     addObjCh,s  ;    addObjCh = A
         LDX     addNewOb,s  ;    X = addNewOb
         ADDX    prec,i      ;    X += prec
         STX     addNewOb,s  ;    addNewOb = X
         STA     addNewOb,sf ;    nouvel objet[precedent] = A
         SUBX    prec,i      ;    X = X - prec
         STX     addNewOb,s  ;    addNewOb = X

         LDA     addObjCh,s  ;    A = addObjCh
         ADDA    suiv,i      ;    A += suiv
         STA     addObjCh,s  ;    addObjCh = A 
         LDX     addNewOb,s  ;    X = addNewOb
         STX     addObjCh,sf ;    objet chaine[suivant] = X
         SUBA    suiv,i      ;    A = A - suiv
         STA     addObjCh,s  ;    addObjCh = A
         ADDSP   20,i        ; #dureComp #heurComp #jourComp #chainDur #chainHeu #chainJour #nextcomp #addObjCh #addNewOb #addTempo
         RET0
conflit: LDA     NULL,i      ;    A = NULL
         STRO    errHorai,d  ;    Print(errHorai)
         ADDSP   20,i        ; #dureComp #heurComp #jourComp #chainDur #chainHeu #chainJour #nextcomp #addObjCh #addNewOb #addTempo
         RET0
         ;variables locales
dureComp:.EQUATE 18          ;#2d
heurComp:.EQUATE 16          ;#2d
jourComp:.EQUATE 14          ;#2d
chainDur:.EQUATE 12          ;#2d
chainHeu:.EQUATE 10          ;#2d
chainJou:.EQUATE 8           ;#2d
nextcomp:.EQUATE 6           ;#2d
addObjCh:.EQUATE 4           ;#2d
addNewOb:.EQUATE 2           ;#2d
addTempo:.EQUATE 0           ;#2d
day:     .EQUATE 0
hour:    .EQUATE 2
time:    .EQUATE 4
suiv:    .EQUATE 6
prec:    .EQUATE 8
newChain:.WORD   0
tempo:   .WORD   0 



;affAgd
;Cette methode permet d'afficher les evenements de l'agenda en
;ordre chronologique.
;IN : debChain = Adresse du premier �v�nement
;
affAgd:  LDA     debChain,d
         SUBSP   4,i         ; #addrEv #tempo1
loop2:   STA     addrEv,s         ;store l'adresse de l'evenement dans la pile
         CHARO   '\n',i
         CALL    affiJour
         CALL    affiHeur 
         CALL    affiDure 

         LDA     addrEv,s
         ADDA    addrSuiv,i
         STA     tempo1,s
         LDX     tempo1,sf
         CPX     NULL,i
         BREQ    fin2
         LDA     tempo1,sf
         BR      loop2

fin2:    ADDSP   4,i         ; #addrEv #tempo1
         RET0
;Variable Locale
addrEv:  .EQUATE 2           ; #2d
tempo1:  .EQUATE 0           ; #2d
addrSuiv:.EQUATE 6



;affiJour
;Cette methode permet d'afficher le jour de l'evenement.
;IN : A = adresse de l'evenement.
;         
affiJour:SUBSP   2,i         ;    Allocation de la pile #jour1
         STA     jour1,s     ;    jour1 = A 
         LDX     jour1,sf    ;    X = jour1
         CPX     1,i         ;    if ( X = 1 ) {
         BREQ    lun         ;        branch "lun"
         CPX     2,i         ;    } else if ( X = 2 ) {
         BREQ    mar         ;        branch "mar"
         CPX     3,i         ;    } else if ( X = 3 ) {
         BREQ    mer         ;        branch "mer"
         CPX     4,i         ;    } else if ( X = 4 ) {
         BREQ    jeu         ;        branch "jeu"
         CPX     5,i         ;    } else if ( X = 5 ) {
         BREQ    ven         ;        branch "ven"
         CPX     6,i         ;    } else if ( X = 6 ) {
         BREQ    sam         ;        branch "sam"
         CPX     7,i         ;    } else { branch "dim" }
         BREQ    dim
lun:     STRO    lundi,d
         ADDSP   2,i         ; #jour1
         RET0
mar:     STRO    mardi,d
         ADDSP   2,i         ; #jour1
         RET0
mer:     STRO    mercredi,d
         ADDSP   2,i         ; #jour1
         RET0
jeu:     STRO    jeudi,d
         ADDSP   2,i         ; #jour1
         RET0
ven:     STRO    vendredi,d
         ADDSP   2,i         ; #jour1
         RET0
sam:     STRO    samedi,d
         ADDSP   2,i         ; #jour1
         RET0
dim:     STRO    dimanche,d
         ADDSP   2,i         ; #jour1
         RET0
;Variable Locale
jour1:   .EQUATE 0           ; #2d

;affiHeur
;Cette methode permet d'afficher l'heure du debut de l'evenement.
;IN : A = adresse de l'evenement.
;         
affiHeur:SUBSP   8,i         ;    Allocation de la pile #heure1 #comptr #minute #addeven1
         STA     addeven1,s  ;    addeen1 = A
         ADDA    posHeure,i  ;    A += posHeure
         STA     heure1,s    ;    heure1 = A
         LDX     heure1,sf   ;    X = evenement[heure]
         LDA     0,i         ;    A = 0
         CPX     60,i        ;    if ( X < 60 ) {
         BRLT    skip        ;        branch "skip" }
loop3:   SUBX    minuHeur,i  ;    X = X - minuHeur
         ADDA    1,i         ;    A += 1
skip:    STA     comptr,s    ;    Comptr = A
         CPX     minuHeur,i  ;    if ( X >= minuHeur ) {
         BRGE    loop3       ;        branch "loop3"
         STX     minute,s    ;    Minute = X
         DECO    comptr,s    ;    Print(comptr)
         STRO    h,d         ;    Print(h)
         DECO    minute,s    ;    Print(minute)
         CHARO   ' ',i       ;    Print( )
         LDA     addeven1,s  ;    A = addeven1   
         ADDSP   8,i         ; #heure1 #comptr #minute #addeven1 
         RET0
;Variable Locale
heure1:  .EQUATE 6           ; #2d
comptr:  .EQUATE 4           ; #2d
minute:  .EQUATE 2           ; #2d
addeven1:.EQUATE 0           ; #2d
minuHeur:.EQUATE 60
posHeure:.EQUATE 2

;affiDure
;Cette methode permet d'afficher la duree de l'evenement.
;IN : A = adresse de l'evenement.
;         
affiDure:SUBSP   6,i         ;    Allocation de la pile #duree1 #comptr2 #minute2
         ADDA    posDuree,i  ;    A += posDuree
         STA     duree1,s    ;    duree1 = A
         LDX     duree1,sf   ;    X = evenement[heure]
         LDA     0,i         ;    A = 0
         CPX     60,i        ;    if ( X < 60 ) {
         BRLT    skip1       ;        branch "skip1" }
loop4:   SUBX    minuHr,i    ;    X = X - minuHr
         ADDA    1,i         ;    A += 1
skip1:   STA     comptr2,s   ;    comptr2 = A
         CPX     minuHr,i    ;    if ( X >= minuHr) {
         BRGE    loop4       ;        branch "loop4" }
         STX     minute2,s   ;    minute2 = X
         DECO    comptr2,s   ;    Print(comptr2)
         STRO    h,d         ;    Print(h)
         DECO    minute2,s   ;    Print(minute2)
         ADDSP   6,i         ; #heure1 #comptr #minute 
         RET0
;Variable Locale
duree1:  .EQUATE 4           ; #2d
comptr2: .EQUATE 2           ; #2d
minute2: .EQUATE 0           ; #2d
minuHr:  .EQUATE 60 
posDuree:.EQUATE 4


menu:    .ASCII  " ****************** "
         .ASCII  "\n * [1]-Saisir     * "
         .ASCII  "\n * [2]-Quitter    *" 
         .ASCII  "\n ******************\n"
         .ASCII  "Votre choix : \x00"
errMenu: .ASCII  "Erreur, votre choix doit �tre 1 ou 2.\n\x00"
sollJour:.ASCII  "Jours : \x00"
sollHeur:.ASCII  "Heure de d�but : \x00"
sollDure:.ASCII  "Dur�e : \x00"
errForma:.ASCII  "Erreur de format."
         .ASCII  "\n \x00"
errHorai:.ASCII  "la planification de cet evenement est impossible en raison d'un conflit d'horaire. \n\x00"
lundi:   .ASCII  "Lundi \x00"
mardi:   .ASCII  "Mardi \x00"
mercredi:.ASCII  "Mercredi \x00"
jeudi:   .ASCII  "Jeudi \x00"
vendredi:.ASCII  "Vendredi \x00"
samedi:  .ASCII  "Samedi \x00"
dimanche:.ASCII  "Dimanche \x00"
h:       .ASCII  "H\x00"



;******* operator new 
; Precondition: A contains number of bytes
; Postcondition: X contains pointer to bytes
;RETURN X = pointer
new:     LDX     hpPtr,d         ;returned pointer
         ADDA    hpPtr,d         ;allocate from heap
         STA     hpPtr,d         ;update hpPtr
         RET0 
hpPtr:   .ADDRSS heap        ;address of next free byte 
heap:    .BLOCK  1            ;first byte in the heap
         .END