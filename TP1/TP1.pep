;A,T 29.09 
;(C) GG 2021 
;TP1

         lda 0,i; 
         ldx 0,i;
         stro msg,d;
         deci number,d;
         lda number,d; A=number
         suba highlim,d;A=number-3999
         brgt toohigh;
         lda number,d;
         brle toolow;

loop:    sta number,d;
         lda number,d;
         cpa millier,d;
         brge mille;
         br exit;

mille:   suba millier,d;
         addx unite,d;
         cpa millier,d;
         brlt printM;
         brge mille;
         br loop;

printM:  cpx unite,d;
         brge printX;
         br loop;








printX: stro X,d; 
        subx 1,i;
        br printM;


toohigh: stro msgdepa,d;
         br exit;

toolow:  stro msgerr0,d;
         br exit;

exit:    stop






number:  .word   0;
millier: .word   1000;
centaine:.word   100;
dixaine: .word   10;
unite:   .word   1;

highlim: .word   3999;

msg:     .ascii  "Entrer un nombre de 1 à 3999:\x00"
msgerr0: .ascii  "Le nombre est inférieur à 1,INVALID\x00"
msgdepa: .ascii  "Le nombre est supérieure à la limite maximal(3999),INVALID\x00"
X:       .ascii  "X\x00" 
         .end