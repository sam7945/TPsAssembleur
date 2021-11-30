;22.11.2021
;(C) INF2171 2021
; TP Par Samuel Dextraze DEXS03039604 dextraze.samuel@courrier.uqam.ca 
; et Christophe Cloutier CLOC21119501 cloutier.christophe@courrier.uqam.ca
; Ce programme gère un agenda hebdomadaire des évènements


         call    agenda

         STOP

;Event*


agenda:  call    saisir      ;Appel de la fonction saisir
         ret0 
         
         

;saisir
;Cette methode affiche un menu contenant 2 options (1- Saisir 2- Quitter). La fonction
;Saisir permet à l'utilisateur d'entrer l'information sur un seul évènement. La fonction
;Quitter permet d'arrêter la saisie de nouveau évènements.
;
saisir:  STRO    menu,d      ;affiche le menu de saisi
         subsp   variable,i  ;allocate #optMen
         lda     0,i
         ldx     0,i
         CHARI   optMen,s    ;assigne le choix de l'utilisateur a l'adresse pile optMen
         LDBYTEX optMen,s    ;assigne le choix de l'utilisateur au registre x
cp:      CPX     '\n',i      ;if (x  == '\n' ) {
         BREQ    nextChar    ;    branch nextchar
         CPX     '1',i       ;} else if ( x == 1 ) {
         BREQ    nextEven    ;    branch "nexteven 
         CPX     '2',i       ;} else if ( x == 2 ) {
         BREQ    quitMenu    ;    branch "quitmenu"
         STRO    errMenu,d   ;} else {    print(errMenu)
         addsp   variable,i  ;dealocate #optMen
         br      saisir      ;    branch "saisir" }
nextChar:CHARI   0,s         ;prochain char
         LDBYTEX 0,s         ;load le char dans X
         br      cp          ;branch cp
nextEven:call    creer       ;call creer()
         call    inserer     ;call inserer()
         addsp   variable,i  ;deallocate #optMen
         br      saisir          
quitMenu:addsp   variable,i  ;deallocate #optMen
         RET0                ;Retourne à agenda et quitte 

optMen:  .EQUATE 0           ;local variable #2d
variable:.EQUATE 2           


;creer
;Cette methode permet de creer un nouvel objet evenement.
;
creer:   SUBSP   2,i         ; #eventC 
         LDA     10,i 
         CALL    new         ; eventC = malloc(10) #prJour #prDebut #prDuree #prSuiv #prPrec
         LDA     0,i 
         STX     eventC,s
         CALL    evenJour
         CPA     NULL,i
         BREQ    fin 
         STA     prJour,x    ; eventC->jour = 3;LDA     0,i 
         CALL    evenHeur
         CPA     NULL,i
         BREQ    fin
         STA     prDebut,x   ; eventC->debut = 1995;
         LDA     0,i
         CALL    evenDure
         CPA     NULL,i
         BREQ    fin         
         STA     prDuree,x   ; eventC->durée = 2004;
         LDA     NULL,i
         STA     prSuiv,x    ; eventC->suivent = NULL
         STA     prPrec,x    ; eventC->precedent=NULL
         LDX     eventC,s    ; X = addresse eventC (retourne l'adresse de l'évènement)
         CALL    prprod      ; prprod(produitC)
         RET2                ;#eventC 
fin:     LDA     NULL,i
         STA     prJour,x
         STA     prDebut,x
         STA     prDuree,x
         STA     prSuiv,x
         STA     prPrec,x
         LDX     NULL,i      ; X = NULL  (retourne l'adresse NULL puisque l'évènement n'est pas créé)
         RET2                ; #eventC 
eventC:  .EQUATE 0 ; #2h 
NULL:    .EQUATE 0 ; #2d null
; ****** Structure event
prJour:  .EQUATE 0 ; #2d jour de l'évènement
prDebut: .EQUATE 2 ; #2d heure de début
prDuree: .EQUATE 4 ; #2d durée
prSuiv:  .EQUATE 6 ; #2h pointeur vers le suivent
prPrec:  .EQUATE 8 ; #2h pointeur vers le précédent






;evenJour
;Cette methode fait la sollicitation du Jour pour la creation d'un evenement.
;OUT : A = jour
;
evenJour:STRO    sollJour,d  ;Print(sollJour)
         SUBSP   resJour,i   ;#resJour 
         DECI    spJour,s    ;assigne le choix de l'utilisateur a la pile spJour
         LDA     spJour,s    ;
         CPA     minJour,i   ;compare au jour minimum (lundi)
         BRLT    errJour
         CPA     maxJour,i   ;compare au jour maximum (dimanche)
         BRGT    errJour
         ADDSP   resJour,i   ;#resJour
         RET0
errJour: STRO    errForma,d  ;Print(errForma)
         LDA     NULL,i
         ADDSP   resJour,i   ;#resJour
         RET0
;variable locale
spJour:  .EQUATE 0           ;#2d
resJour: .EQUATE 2           ;#2d
minJour: .EQUATE 1
maxJour: .EQUATE 7

;evenHeur
;Cette methode fait la sollicitation de l'Heure/minutes de debut pour la creation d'un evenement.
;OUT : A = heure/minute
;
evenHeur:STRO    sollHeur,d  ;Print(sollHeur) 
         SUBSP   resHeure,i  ;#resHeure
         DECI    spHeure,s   ;assigne le choix de l'utilisateur a la pile spHeur
         LDA     spHeure,s   ;
         CPA     minHeur,i   ;compare aux heures/minutes minimum (1)
         BRLT    errHeure
         CPA     maxHeur,i   ;compare aux heures/minutes maximum (1440)
         BRGT    errHeure
         ADDSP   resHeure,i  ;#resHeure
         RET0
errHeure:STRO    errForma,d  ;Print(errForma)
         LDA     NULL,i
         ADDSP   resHeure,i  ;#resHeure
         RET0
;variable locale
spHeure: .EQUATE 0           ;#2d
resHeure:.EQUATE 2           ;#2d
minHeur: .EQUATE 1
maxHeur: .EQUATE 1440

;evenDure
;Cette methode fait la sollicitation de l'Heure/minutesde duree pour la creation d'un evenement.
;OUT : A = heure/minute
;
evenDure:STRO    sollDure,d  ;Print(sollDure)
         SUBSP   resDuree,i  ;#resDuree
         DECI    spDuree,s   ;assigne le choix de l'utilisateur a la pile spDuree
         LDA     spDuree,s   ;
         CPA     minDuree,i  ;compare aux heures/minutes minimum (1)
         BRLT    errDuree
         CPA     maxDuree,i  ;compare aux heures/minutes maximum (1440)
         BRGT    errDuree
         ADDSP   resDuree,i  ;#resDuree
         RET0
errDuree:STRO    errForma,d  ;Print(errForma)
         LDA     NULL,i
         ADDSP   resDuree,i  ;#resDuree
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
;
inserer: CPX     NULL,i      ;vérifie si l'évènement est bien conforme (pas d'erreur de format)
         BREQ    nonConf     ;si non conforme (null), branch fin2
         LDA     compteur,d  ;else load le compteur dans A
         ADDA    1,i         ;A += 1
         STA     compteur,d  ;compteur = A
         CPA     1,i         ; if (A == 1) {
         BREQ    premEven    ;    branch fin2 (il n'y a pas d'autres evenements)
         CALL    comparer    ; } else { compare pour l'insertion }
         BR      evenSuiv    ; insertion evenement suivant


nonConf: RET0
premEven:STX     debChain,d  ;garde le debut de la chaine dans une variable globale......
         ADDX    evenPr,i    ;adresse eventC + 8 (adresse evenement precedent)
         LDA     NULL,i      ;A = NULL
         STA     eventC,x    ;evenement prec = NULL
         SUBX    evenPr,i
         ADDX    suivEven,i  ; X = adresse evenement suivant
         LDA     2,i         ; A = NULL
         STA     eventC,x    ; evenement suivant = NULL
         RET0
evenSuiv:ADDX    evenPr,i    ;adresse eventC + 8 (adresse evenement precedent)
         LDA     3,i         ;le 3 est temporaire, on va LDA l'adresse prec
         STA     eventC,x
         SUBX    evenPr,i
         LDA     3,i         ;3 temporaire, on va LDA l'adresse suivante
         ADDX    suivEven,i
         STA     eventC,x
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
;
comparer:LDA     heap,i
         STA     addObjCh,s
         STX     addNewOb,s
         SUBSP   18,i        ; #chainJou #chainHeu #chainDur #jourComp #heurComp #dureComp #nextcomp #addObjCh #addNewOb
 
         ADDX    day,i
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

         ;LDA     addObjCh,s
         BR      compa1

compa1:  LDA     jourComp,s
         CPA     chainJou,s
         BRLT    preced
         CPA     chainJou,s
         BREQ    compa2
         ;BR      suivant 
         ADDSP   18,i        ; #chainJou #chainHeu #chainDur #jourComp #heurComp #dureComp #nextcomp #addObjCh #addNewOb 
         RET0
compa2:  LDA     heurComp,s
         ADDA    dureComp,s
         CPA     chainHeu,s
         BRLE    preced
         CPA     chainHeu,s
         ;BRGT    conflit 
         ;BREQ    comp3 
         ;BR      suivant 

preced:  LDA     addObjCh,s
         ADDA    6,i         ; A = "objet chaine -> suivant"
         STA     addObjCh,s
         LDA     addObjCh,sx ; A = adresse objet chaine suivant
         CPA     NULL,i
         BREQ    listPrem 
         BR      listAutr

listPrem:SUBA    6,i
         STA     addObjCh,s
         LDX     addNewOb,s 
         ADDX    6,i         ; nouvel objet[suivant]
         STX     addNewOb,s
         STA     addNewOb,n  ; "nouvel objet[suivant]" = adresse objet chaine
         SUBX    6,i         ; X = adresse du nouvel objet
         ADDA    8,i         ; A = objet chaine -> precedent
         STA     addObjCh,s  ; addObjCh = A
         STX     addObjCh,n  ; "objet chaine[precedent]" = adresse nouvel objet
         ADDSP   18,i        ; #chainJou #chainHeu #chainDur #jourComp #heurComp #dureComp #nextcomp #addObjCh #addNewOb
         RET0
listAutr:SUBA    6,i 
         STA     addObjCh,s
         LDX     addNewOb,s 
         ADDX    6,i         ; nouvel objet[suivant]
         STX     addNewOb,s
         STA     addNewOb,n  ; "nouvel objet[suivant]" = adresse objet chaine suivant
         SUBX    6,i         ; X = adresse du nouvel objet
         ADDX    8,i

         LDX     addNewOb,s
         ADDX    8,i
         STX     addNewOb,s
         LDA     addObjCh,s
         SUBA    10,i
         ADDA    8,i
         STA     addNewOb,n  ; "nouvel objet[precedent]" = adresse objet chaine precedent

         LDX     addNewOb,s
         LDA     addObjCh,s
         ADDA    8,i
         STA     addObjCh,s
         STX     addObjCh,n
         SUBA    8,i
         SUBA    10,i
         ADDA    6,i
         STA     addObjCh,s
         STX     addObjCh,n
         

         ADDA    8,i         ; A = objet chaine -> precedent
         STA     addObjCh,s  ; addObjCh = A
         STX     addObjCh,n  ; "objet chaine[precedent]" = adresse nouvel objet
         ADDSP   18,i        ; #chainJou #chainHeu #chainDur #jourComp #heurComp #dureComp #nextcomp #addObjCh #addNewOb
         RET0

;conflit:

;suivant: 
         
;variables locales
day:     .EQUATE 0
hour:    .EQUATE 2
time:    .EQUATE 4
dureComp:.EQUATE 0           ;#2d
heurComp:.EQUATE 2           ;#2d
jourComp:.EQUATE 4           ;#2d
chainDur:.EQUATE 6           ;#2d
chainHeu:.EQUATE 8           ;#2d
chainJou:.EQUATE 10          ;#2d
nextcomp:.EQUATE 12          ;#2d
addObjCh:.EQUATE 14          ;#2d
addNewOb:.EQUATE 16          ;#2d
prec:    .EQUATE 14
newChain:.WORD   0
tempo:   .WORD   0 



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