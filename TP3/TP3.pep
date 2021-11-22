;22.11.2021
;(C) INF2171 2021
; TP Par Samuel Dextraze DEXS03039604 dextraze.samuel@courrier.uqam.ca 
; et Christophe Cloutier CLOC21119501 cloutier.christophe@courrier.uqam.ca
; Ce programme gère un agenda hebdomadaire des évènements




         STOP

;Event*
agenda: ;ERROR: Must have mnemonic or dot command after symbol definition.

;saisir
;Cette methode affiche un menu contenant 2 options (1- Saisir 2- Quitter). La fonction
;Saisir permet à l'utilisateur d'entrer l'information sur un seul évènement. La fonction
;Quitter permet d'arrêter la saisie de nouveau évènements.
saisir:  STRO    menu,d      ;affiche le menu de saisi
         DECI    -2,s        ;assigne le choix de l'utilisateur a l'adresse pile - 2
         SUBSP   2,i         ;empile le choix de l'utilisateur
         DECO    0,s        ;


creer:


inserer:


menu:    .ASCII  " ****************** \n * [1]-Saisir     "
         .ASCII  "* \n * [2]-Quitter    * \n ******************\x00"
         .END