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
         BR      saisir      ;branch a saisir
quitMenu:ADDSP   optMen,i    ;Depile #optMen
         RET0

;variable locale
optMen:  .EQUATE 2           ;#2d

;creer:

;inserer:




menu:    .ASCII  " ****************** "
         .ASCII  "\n * [1]-Saisir     * "
         .ASCII  "\n * [2]-Quitter    *" 
         .ASCII  "\n ******************\n"
         .ASCII  "Votre choix : \x00"
errMenu: .ASCII  "Erreur, votre choix doit être 1 ou 2.\x00"
         .END