;22.11.2021
;(C) INF2171 2021
; TP Par Samuel Dextraze DEXS03039604 dextraze.samuel@courrier.uqam.ca 
; et Christophe Cloutier CLOC21119501 cloutier.christophe@courrier.uqam.ca
; Ce programme gère un agenda hebdomadaire des évènements


         CALL    agenda
         CALL    affAgd

         STOP

;Event*


agenda:  CALL    saisir      ;Appel de la fonction saisir
         RET0 
         
         

;saisir
;Cette methode affiche un menu contenant 2 options (1- Saisir 2- Quitter). La fonction
;Saisir permet à l'utilisateur d'entrer l'information sur un seul évènement. La fonction
;Quitter permet d'arrêter la saisie de nouveau évènements.
;
saisir:  STRO    menu,d      ;    Print( menu )
         subsp   variable,i  ;    allocation pile #optMen
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
         addsp   variable,i  ;        dealocate #optMen
         br      saisir      ;        branch "saisir" }
nextChar:CHARI   0,s         ;    prochain caractere
         LDBYTEX 0,s         ;    X = optMen
         br      cp          ;    branch cp
nextEven:CALL    creer       ;    call creer()
         CALL    inserer     ;    call inserer() 
         ADDSP   variable,i  ;    desalocation pile #optMen
         BR      saisir          
quitMenu:addsp   variable,i  ;    desalocation pile #optMen
         RET0                ;Retourne à agenda et quitte 
;Variables Locales
optMen:  .EQUATE 0           ;#2d
variable:.EQUATE 2           


;creer
;Cette methode permet de saisir les donnees sur un nouvel evenement soit
;le jour, l'heure et la duree. Si les donnees sont conformes, l'objet est
;cree.
;OUT: X = adresse d'un maillon evenement
;
creer:   SUBSP   2,i         ;    allocation pile #eventC 
         LDA     adrObj,i    ;    A = adrObj 
         CALL    new         ;    eventC = malloc(10) #prJour #prDebut #prDuree #prSuiv #prPrec
         LDA     0,i 
         STX     eventC,s    ;    eventC = adresse du nouvel objet
         CALL    evenJour
         CPA     NULL,i      ;    if ( A == NULL ) {
         BREQ    fin         ;        branch "fin" }
         STA     prJour,x    ;    eventC[jour] = A
         LDA     0,i
         CALL    evenHeur
         CPA     NULL,i      ;    if ( A == NULL ) {
         BREQ    fin         ;        branch "fin" }
         STA     prDebut,x   ;    eventC[debut] = A
         LDA     0,i
         CALL    evenDure
         CPA     NULL,i      ;    if ( A == NULL ) {
         BREQ    fin         ;        branch "fin" }
         STA     prDuree,x   ;    eventC[durée] = A
         LDA     NULL,i      ;    A = NULL
         STA     prSuiv,x    ;    eventC[suivant] = NULL
         STA     prPrec,x    ;    eventC[precedent] = NULL
         LDX     eventC,s    ;    X = addresse eventC
         CALL    prprod      ;    prprod(produitC)
         RET2                ;    Desallocation pile #eventC 
fin:     LDA     NULL,i      ;    A = NULL
         STA     prJour,x    ;    prJour = A
         STA     prDebut,x   ;    prDebut = A
         STA     prDuree,x   ;    prDuree = A
         STA     prSuiv,x    ;    prSuiv = A
         STA     prPrec,x    ;    prPrec = A
         LDX     NULL,i      ;    X = NULL  (retourne l'adresse NULL puisque l'évènement n'est pas créé)
         RET2                ;    Desallocation pile #eventC 
eventC:  .EQUATE 0 ; #2h 
NULL:    .EQUATE 0 ; #2d null
; ****** Structure event
prJour:  .EQUATE 0 ; #2d jour de l'évènement
prDebut: .EQUATE 2 ; #2d heure de début
prDuree: .EQUATE 4 ; #2d durée
prSuiv:  .EQUATE 6 ; #2h pointeur vers le suivent
prPrec:  .EQUATE 8 ; #2h pointeur vers le précédent
adrObj:  .EQUATE 10






;evenJour
;Cette methode fait la sollicitation du Jour pour la creation d'un evenement.
;OUT : A = jour
;
evenJour:STRO    sollJour,d  ;    Print(sollJour)
         SUBSP   resJour,i   ;    allocation pile #resJour 
         DECI    spJour,s    ;    spJour = choix utilisateur
         LDA     spJour,s    ;    A = spJour
         CPA     minJour,i   ;    if ( A < 1 ) {
         BRLT    errJour     ;        branch "errJour" 
         CPA     maxJour,i   ;    } else if ( A > 7 ) {
         BRGT    errJour     ;        branch "errJour" }
         ADDSP   resJour,i   ;    desalocation pile #resJour
         RET0
errJour: STRO    errForma,d  ;    Print(errForma)
         LDA     NULL,i      ;    A = NULL
         ADDSP   resJour,i   ;    desallocation pile #resJour
         RET0
;variables locales
spJour:  .EQUATE 0           ;#2d
resJour: .EQUATE 2           ;#2d
minJour: .EQUATE 1
maxJour: .EQUATE 7

;evenHeur
;Cette methode fait la sollicitation de l'Heure/minutes de debut pour la creation d'un evenement.
;OUT : A = heure/minute
;
evenHeur:STRO    sollHeur,d  ;    Print(sollHeur) 
         SUBSP   resHeure,i  ;    allocation pile #resHeure
         DECI    spHeure,s   ;    spHeure = choix utilisateur
         LDA     spHeure,s   ;    A = spHeure
         CPA     minHeur,i   ;    if ( A < 1 ) {
         BRLT    errHeure    ;        branch "errHeure"
         CPA     maxHeur,i   ;    } else if ( A > 1440 ) {
         BRGT    errHeure    ;        branch "errHeure" }
         ADDSP   resHeure,i  ;    Desallocation pile #resHeure
         RET0
errHeure:STRO    errForma,d  ;    Print(errForma)
         LDA     NULL,i      ;    A = NULL
         ADDSP   resHeure,i  ;    Desallocation pile #resHeure
         RET0
;variable locale
spHeure: .EQUATE 0           ;#2d
resHeure:.EQUATE 2           ;#2d
minHeur: .EQUATE 0
maxHeur: .EQUATE 1440

;evenDure
;Cette methode fait la sollicitation de l'Heure/minutesde duree pour la creation d'un evenement.
;OUT : A = heure/minute
;
evenDure:STRO    sollDure,d  ;    Print(sollDure)
         SUBSP   resDuree,i  ;    Allocation pile #resDuree
         DECI    spDuree,s   ;    spDuree = choix utilisateur
         LDA     spDuree,s   ;    A = spDuree
         CPA     minDuree,i  ;    if ( A < 1 ) {
         BRLT    errDuree    ;        branch "errDuree"
         CPA     maxDuree,i  ;    } else if ( A > 1440 ) {
         BRGT    errDuree    ;        branch "errDuree"
         ADDSP   resDuree,i  ;    Desallocation pile #resDuree
         RET0
errDuree:STRO    errForma,d  ;    Print(errForma)
         LDA     NULL,i      ;    A = NULL
         ADDSP   resDuree,i  ;    Desallocation pile #resDuree
         ret0
;variable locale
spDuree: .EQUATE 0           ;#2d
resDuree:.EQUATE 2           ;#2d
minDuree:.EQUATE 1
maxDuree:.EQUATE 1440









; ****** prprod: Affiche un produit 
; IN A=adresse de event (#2h)
preventA: .EQUATE 0 ; #2h paramètre A
preventX: .EQUATE 2 ; #2h sauve X
prevdstr: .EQUATE 4 ; #2h adresse du nom du produit (pour STRO)
prprod:  SUBSP 6,i ; #prevdstr #preventX #preventA
         STA preventA,s ; range A 
         STX preventX,s ; sauve X
         LDX prJour,i 
         DECO preventA,sxf ; print(prprodA->prJour) 
         CHARO ':',i ; print(":")

         LDX prDebut,i 
         DECO preventA,sxf ; print(prprodA->prDebut) 
         CHARO ':',i ; print(":")

         LDX prDuree,i 
         DECO preventA,sxf ; print(prprodA->prDuree) 
         CHARO ':',i ; print(":")

         LDX prSuiv,i 
         DECO preventA,sxf ; print(prprodA->prSuiv) 
         CHARO ':',i ; print(":")

         LDX prPrec,i 
         DECO preventA,sxf ; print(prprodA->prPrec) 

         
         CHARO '\n',i ; print("\n")
         LDA preventA,s ; restaure A
         LDX preventX,s ; restaure X
         RET6 ; #prevdstr #preventX #preventA




;inserer
;Cette methode permet d'insérer un évènement dans la liste chainée d'évènement
;seulement si celui-ci est conforme. (pas d'erreur de format)
;
;IN : X = Adresse de l'évènement a inserer
;OUT : A = Evenement insérer. (0 False, 1 True)
inserer: CPX     NULL,i      ;vérifie si l'évènement est bien conforme (pas d'erreur de format)
         BREQ    nonConf     ;si non conforme (null), branch fin2
         LDA     compteur,d  ;else load le compteur dans A
         ADDA    1,i         ;A += 1
         STA     compteur,d  ;compteur = A
         CPA     1,i         ; if (A == 1) {
         BREQ    premEven    ;    branch fin2 (il n'y a pas d'autres evenements)
         LDA     debChain,d
         CALL    comparer    ; } else { compare pour l'insertion }
nonConf: LDA     0,i
         RET0
premEven:STX     debChain,d  ; X = debChain
         ADDX    evenPr,i    ;adresse eventC + 8 (adresse evenement precedent)
         LDA     NULL,i      ;A = NULL
         STA     eventC,x    ;evenement prec = NULL
         SUBX    evenPr,i
         ADDX    suivEven,i  ; X = adresse evenement suivant
         LDA     NULL,i         ; A = NULL
         STA     eventC,x    ; evenement suivant = NULL
         RET0
;variable locales
suivEven:.EQUATE 6 
evenPr:  .EQUATE 8
compteur:.WORD   0           ;compteur du nombre d'évènement existant dans la liste chainée
debChain:.WORD   0


;comparer
;Cette methode permet de comparer deux objets evenements en commencant
;au premier evenemnt de la liste chaine.
;
;IN : X = Adresse de l'objet Evenement a inserer
;     A = Adresse du début de la liste chainée
;
comparer:SUBSP   20,i        ; #dureComp #heurComp #jourComp #chainDur #chainHeu #chainJour #nextcomp #addObjCh #addNewOb #addTempo
         STA     addObjCh,s
         STX     addNewOb,s
loop:    ADDX    day,i
         STX     tempo,d
         LDX     tempo,n
         STX     jourComp,s
         LDX     tempo,d
         SUBX    day,i

         ADDX    hour,i
         STX     tempo,d
         LDX     tempo,n
         STX     heurComp,s
         LDX     tempo,d
         SUBX    hour,i

         ADDX    time,i
         STX     tempo,d
         LDX     tempo,n
         STX     dureComp,s
         LDX     tempo,d
         SUBX    time,i

         ADDA    day,i
         STA     tempo,d
         LDA     tempo,n
         STA     chainJou,s
         LDA     tempo,d
         SUBA    day,i

         ADDA    hour,i
         STA     tempo,d
         LDA     tempo,n
         STA     chainHeu,s
         LDA     tempo,d
         SUBA    hour,i

         ADDA    time,i
         STA     tempo,d
         LDA     tempo,n
         STA     chainDur,s
         LDA     tempo,d
         SUBA    time,i

compa1:  LDA     jourComp,s
         CPA     chainJou,s
         BRLT    preced
         CPA     chainJou,s
         BREQ    compa2
         BR      suivant
compa2:  LDA     heurComp,s
         CPA     chainHeu,s
         BREQ    conflit
         CPA     chainHeu,s
         BRLE    veriMoin
         BR      veriPlus
veriMoin:ADDA    dureComp,s
         CPA     chainHeu,s
         BRGT    conflit
         BR      suivant
veriPlus:LDA     chainHeu,s
         ADDA    chainDur,s
         CPA     heurComp,s 
         BRGT    conflit 
         BR      suivant


preced:  LDA     addObjCh,s
         ADDA    prec,i         ; A = "objet chaine -> precedent"
         STA     addObjCh,s
         LDA     addObjCh,sf ; A = adresse objet chaine precedent
         CPA     NULL,i
         BREQ    listPrem 
         BR      listAutr
suivant: LDA     addObjCh,s
         ADDA    suiv,i
         STA     addObjCh,s
         LDA     addObjCh,sf
         CPA     NULL,i
         BREQ    listFin
         STA     addObjCh,s
         BR      loop
listPrem:LDA     addObjCh,s
         SUBA    prec,i
         STA     addObjCh,s
         LDX     addNewOb,s 
         ADDX    suiv,i         ; nouvel objet[suivant]
         STX     addNewOb,s
         STA     addNewOb,sf  ; "nouvel objet[suivant]" = adresse objet chaine
         SUBX    suiv,i         ; X = adresse du nouvel objet
         ADDA    prec,i         ; A = objet chaine -> precedent
         STA     addObjCh,s  ; addObjCh = A
         STX     addObjCh,sf  ; "objet chaine[precedent]" = adresse nouvel objet
         STX     debChain,d
         ADDSP   20,i        ; #dureComp #heurComp #jourComp #chainDur #chainHeu #chainJour #nextcomp #addObjCh #addNewOb #addTempo
         RET0
listAutr:LDA     addObjCh,s  ;newEvent[suivant]
         SUBA    prec,i
         ;ADDA    prec,i 
         STA     addObjCh,s
         LDX     addNewOb,s 
         ADDX    suiv,i         ; nouvel objet[suivant]
         STX     addNewOb,s
         STA     addNewOb,sf  ; "nouvel objet[suivant]" = adresse objet chaine suivant
         SUBX    suiv,i         ; X = adresse du nouvel objet
         STX     addNewOb,s
         ;newEvent[precedent]
         LDX     addNewOb,s
         ADDX    prec,i
         STX     addNewOb,s
         LDA     addObjCh,s
         ADDA    prec,i
         STA     addObjCh,s
         LDA     addObjCh,sf
         STA     addNewOb,sf  ; "nouvel objet[precedent]" = adresse objet chaine precedent
         LDA     addObjCh,s
         SUBA    prec,i
         STA     addObjCh,s
         SUBX    prec,i
         STX     addNewOb,s
         
         ;oldEvent[precedent] + oldevent[suivant]
         LDX     addNewOb,s
         LDA     addObjCh,s
         STA     addTempo,s
         ADDA    prec,i
         STA     addObjCh,s
         STX     addObjCh,sf
         LDA     addNewOb,s
         ADDA    prec,i
         STA     addTempo,s
         LDA     addTempo,sf
         ADDA    suiv,i
         STA     addTempo,s
         LDA     addNewOb,s
         STA     addTempo,sf

         ADDSP   20,i        ; #dureComp #heurComp #jourComp #chainDur #chainHeu #chainJour #nextcomp #addObjCh #addNewOb #addTempo 
         RET0
listFin: LDA     addObjCh,s
         SUBA    suiv,i
         STA     addObjCh,s
         ;LDA     NULL,i
         LDX     addNewOb,s
         ADDX    prec,i
         STX     addNewOb,s
         STA     addNewOb,sf
         SUBX    prec,i
         STX     addNewOb,s

         LDA     addObjCh,s
         ADDA    suiv,i
         STA     addObjCh,s
         LDX     addNewOb,s
         STX     addObjCh,sf
         SUBA    suiv,i
         STA     addObjCh,s

         ADDSP   20,i        ; #dureComp #heurComp #jourComp #chainDur #chainHeu #chainJour #nextcomp #addObjCh #addNewOb #addTempo
         RET0

conflit: LDA     NULL,i
         STRO    errHorai,d
         ADDSP   20,i        ; #dureComp #heurComp #jourComp #chainDur #chainHeu #chainJour #nextcomp #addObjCh #addNewOb #addTempo
         RET0
         ;variables locales
day:     .EQUATE 0
hour:    .EQUATE 2
time:    .EQUATE 4
dureComp:.EQUATE 18          ;#2d
heurComp:.EQUATE 16          ;#2d
jourComp:.EQUATE 14           ;#2d
chainDur:.EQUATE 12           ;#2d
chainHeu:.EQUATE 10           ;#2d
chainJou:.EQUATE 8          ;#2d
nextcomp:.EQUATE 6          ;#2d
addObjCh:.EQUATE 4          ;#2d
addNewOb:.EQUATE 2          ;#2d
addTempo:.EQUATE 0          ;#2d
suiv:    .EQUATE 6
prec:    .EQUATE 8
newChain:.WORD   0
tempo:   .WORD   0 



;affAgd
;Cette methode permet d'afficher les evenements de l'agenda en
;ordre chronologique.
;IN : debChain = Adresse du premier évènement
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
affiJour:SUBSP   2,i         ; Allocation de la pile #jour1
         STA     jour1,s     ; Store l'adresse evenement[jour] dans la pile 
         LDX     jour1,sf    ; X = evenement[jour]
         CPX     1,i
         BREQ    lun
         CPX     2,i
         BREQ    mar
         CPX     3,i
         BREQ    mer
         CPX     4,i
         BREQ    jeu
         CPX     5,i
         BREQ    ven
         CPX     6,i
         BREQ    sam
         CPX     7,i
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
affiHeur:SUBSP   8,i         ; Allocation de la pile #heure1 #comptr #minute #addeven1
         STA     addeven1,s
         ADDA    posHeure,i
         STA     heure1,s    ; Store l'adresse evenement[heure] dans la pile 
         LDX     heure1,sf   ; X = evenement[heure]
         LDA     0,i
loop3:   SUBX    minuHeur,i
         ADDA    1,i
         STA     comptr,s
         CPX     minuHeur,i
         BRGE    loop3
         STX     minute,s
         DECO    comptr,s
         STRO    h,d
         DECO    minute,s
         CHARO   ' ',i 
         LDA     addeven1,s     
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
affiDure:SUBSP   6,i         ; Allocation de la pile #duree1 #comptr2 #minute2
         ADDA    posDuree,i
         STA     duree1,s    ; Store l'adresse evenement[heure] dans la pile 
         LDX     duree1,sf   ; X = evenement[heure]
         LDA     0,i
loop4:   SUBX    minuHr,i 
         ADDA    1,i
         STA     comptr2,s
         CPX     minuHr,i
         BRGE    loop4
         STX     minute2,s
         DECO    comptr2,s
         STRO    h,d
         DECO    minute2,s      
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
errMenu: .ASCII  "Erreur, votre choix doit être 1 ou 2.\x00"
sollJour:.ASCII  "Jours : \x00"
sollHeur:.ASCII  "Heure de début : \x00"
sollDure:.ASCII  "Durée : \x00"
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