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
         lda     0,i
         ldx     0,i
         CHARI   -2,s        ;assigne le choix de l'utilisateur a l'adresse pile - 2
         SUBSP   optMen,i    ;Empile le choix de l'utilisateur #optMen
         LDBYTEX 0,s         ;assigne le choix de l'utilisateur au registre x
cp:      CPX     '\n',i      ;if (x  == '\n' ) {
         BREQ    nextChar    ;    branch nextchar
         CPX     '1',i       ;} else if ( x == 1 ) {
         BREQ    nextEven    ;    branch "nexteven 
         CPX     '2',i       ;} else if ( x == 2 ) {
         BREQ    quitMenu    ;    branch "quitmenu"
         STRO    errMenu,d   ;} else {    System.out.println(errMenu)
         br      saisir      ;    branch "saisir" }
nextChar:CHARI   0,s         ;prochain char
         LDBYTEX 0,s         ;load le char dans X
         br      cp          ;branch cp
nextEven:ADDSP   optMen,i    ;Depile #optMen
         call    creer       ;call creer()
quitMenu:ADDSP   optMen,i    ;Depile #optMen
         RET0

;variable locale
optMen:  .EQUATE 2           ;#2d


creer:   SUBSP 2,i ; #eventC 
         LDA 6,i 
         CALL new ; eventC = malloc(8) #prJour #prDebut #prDuree #prSuiv #prPrec 
         STX eventC,s 
         LDA 3,i 
         STA prJour,x ; eventC->jour = 3; 
         LDA 1995,i 
         STA prDebut,x ; eventC->debut = 1995;
         LDA 2004,i          
         STA prDuree,x ; eventC->durée = 2004;
         LDA 0,i
         STA prSuiv,x  ; eventC->suivent = NULL
         STA prPrec,x  ; eventC->precedent=NULL
         LDA eventC,s 

         CALL prprod ; prprod(produitC); 
         RET2 ; #eventC 
eventC:  .EQUATE 0 ; #2h 
; ****** Structure event
prJour:  .EQUATE 0 ; #2d jour de l'évènement
prDebut: .EQUATE 2 ; #2d heure de début
prDuree: .EQUATE 4 ; #2d durée
prSuiv:  .EQUATE 6 ; #2h pointeur vers le suivent
prPrec:  .EQUATE 8 ; #2h pointeur vers le précédent



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
         CHARO ':',i ; print(":")

         
         CHARO '\n',i ; print("\n")
         LDA preventA,s ; restaure A
         LDX preventX,s ; restaure X
         RET6 ; #prevdstr #preventX #preventA










;inserer:


menu:    .ASCII  " ****************** "
         .ASCII  "\n * [1]-Saisir     * "
         .ASCII  "\n * [2]-Quitter    *" 
         .ASCII  "\n ******************\n"
         .ASCII  "Votre choix : \x00"
errMenu: .ASCII  "Erreur, votre choix doit être 1 ou 2.\x00"




;******* operator new 
; Precondition: A contains number of bytes
; Postcondition: X contains pointer to bytes
new:     LDX hpPtr,d         ;returned pointer
         ADDA hpPtr,d        ;allocate from heap
         STA hpPtr,d         ;update hpPtr
         RET0 
hpPtr:   .ADDRSS heap        ;address of next free byte 
heap:    .BLOCK 1            ;first byte in the heap
         .END