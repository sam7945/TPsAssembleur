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
         SUBSP   optmen,i    ;#optmen empile le choix de l'utilisateur 
         LDBYTEX 0,s         ;assigne le choix de l'utilisateur au registre x
cp:      CPX     '\n',i
         BREQ    nextchar
         CPX     '1',i         ;if ( x == 1 ) {
         BREQ    nexteven    ;    branch "nexteven 
         CPX     '2',i         ;if ( x == 2 ) {
         BREQ    quitmenu    ;    branch "quitmenu"
nextchar:CHARI   0,s
         LDBYTEX 0,s
         br      cp 
nexteven:ADDSP   optmen,i    ;#optmen
         BR      saisir
quitmenu:ADDSP   optmen,i    ;#optmen
         RET0

;creer:

;inserer:


;VARIABLE LOCALE
optmen:  .EQUATE 2           ;#2d



menu:    .ASCII  " ****************** "
         .ASCII  "\n * [1]-Saisir     * "
         .ASCII  "\n * [2]-Quitter    *" 
         .ASCII  "\n ******************\n"
         .ASCII  "Votre choix : \x00"
         .END