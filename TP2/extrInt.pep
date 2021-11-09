 ;STORE les données
         lda     0,i;
         ldx     0,i;
loop1:   ;if (tempchai > 0) {branch a convertir le tableau chaine en int + nettoyer variable tempchai}
loop3:   ldx     tempbuff    ;load la valeur de la variable tempbuff dans le registre x (position du tableau buffer)
         cpx     len,d       ;verifie si on est a l'exterieur du tableau buffer
         brgt    fin         ;si nous sommes a l'exterieur du tableau buffer, branch a fin
         ldbytea buffer,x    ;load la valeur du premier element du buffer dans a
         addx    1,i         ;incremente la position dans le tableau buffer de 1
         stx     tempbuff    ;range la valeur de x (position tableau buffer) dans la variable tempbuff
         ldx     0,i         ;nettoye le registre x
         call    nombre      ;verifie si le caractere se situe entre 0 et 9
         ldx     tempchai,d  ;si oui, load la valeur de la variable tempchai dans le registre x (position du tableau chaine)
         sta     chaine,x    ;range la valeur dans le tableau string
         addx    2,i         ;ajoute x pour incrementer le tableau string
         cpx     10,i        ;verifie si on deborde du tableau chaine
         brgt    fin         ;si on depasse le max du tableau, on ne peut pas prendre le chiffre, on doit nettoyer le tableau chaine et continuer la lecture du texte.
         ldx     0,i         ;nettoye le registre x
         br      loop3


         ldbytea  '2',i
         sta  chaine,x;
         addx     2,i;
         ldbytea  '1',i 
         sta  chaine,x;
         addx     2,i;
         ldbytea  '1',i 
         sta  chaine,x;
         addx     2,i;
         ldbytea  '2',i 
         sta  chaine,x;
         addx     2,i;
         subx    2,i;Sinon dépasse
         stx     sizeint,d;
         ldx     0,i

         ;Lecture des données, pour convint
loop2:   ldbytea chiffre,d
         adda    chaine,x
         suba    '0',i; 
         cpx     sizeint,d
         brlt    x10
         br      fin

x10:     sta     tempchif,d;
         asla
         asla
         adda    tempchif,d
         asla   
         stbytea chiffre,d
         addx    2,i;
         br loop2

nombre:  cpa     '0',i
         brlt    loop1
         cpa     '9',i
         brgt    loop1
         ret0
         

 fin:    sta     chiffre,d
         deco    chiffre,d
         stop

chaine:  .block 10;Tableau de chaine de string du chiffre 
sizeint: .word 0;Grosseur du tableau populer
chiffre: .word 0;Chiffre en int de retour
tempchif:.word 0;

tempbuff:.word   0
tempchai:.word   0

.end