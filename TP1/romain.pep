;A,T 29.09 
;(C) GG 2021 
;TP1 Par Samuel Dextraze DEXS03039604 dextraze.samuel@courrier.uqam.ca 
; et Christophe Cloutier

         lda 0,i; 
         ldx 0,i;
         stro msg,d;
         deci number,d;
         lda number,d; A=number
         suba highlim,d;A=number-3999
         brgt toohigh;
         lda number,d;
         brle toolow;

loop:    ldx 0,i; 
         sta number,d;
         lda number,d;
         cpa millier,d;
         brge mille;
         cpa centaine,d;
         brge cent;
         cpa dixaine,d;
         brge dix;
         cpa unite,d;
         brge unit;
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

printX: stro M,d; 
        subx 1,i;
        br printM;



cent:    suba centaine,d;
         addx unite,d;
         cpa centaine,d;
         brlt centnum;
         brge cent;
         br loop;

centnum: cpx 9,i;
         breq print900;
         cpx 8,i;
         breq print800;
         cpx 7,i;
         breq print700;
         cpx 6,i;
         breq print600;
         cpx 5,i;
         breq print500;
         cpx 4,i;
         breq print400;
         cpx 3,i;
         breq print300;
         cpx 2,i;
         breq print200;
         cpx 1,i;
         breq print100;
         br loop;
         
print900:stro CM,d; 
         br loop;
print800:stro DCCC,d;
         br loop;
print700:stro DCC,d;
         br loop;
print600:stro DC,d;
         br loop;
print500:stro D,d;
         br loop;
print400:stro CD,d;
         br loop;
print300:stro CCC,d;
         br loop;
print200:stro CC,d;
         br loop;
print100:stro C,d;
         br loop;


dix:     suba dixaine,d;
         addx unite,d;
         cpa dixaine,d;
         brlt dixnum;
         brge dix;
         br loop;

dixnum:  cpx 9,i;
         breq print90;
         cpx 8,i;
         breq print80;
         cpx 7,i;
         breq print70;
         cpx 6,i;
         breq print60;
         cpx 5,i;
         breq print50;
         cpx 4,i;
         breq print40;
         cpx 3,i;
         breq print30;
         cpx 2,i;
         breq print20;
         cpx 1,i;
         breq print10;
         br loop;

print90:stro XC,d; 
         br loop;
print80:stro LXXX,d;
         br loop;
print70:stro LXX,d;
         br loop;
print60:stro LX,d;
         br loop;
print50:stro L,d;
         br loop;
print40:stro XL,d;
         br loop;
print30:stro XXX,d;
         br loop;
print20:stro XX,d;
         br loop;
print10:stro X,d;
         br loop;


unit:    suba unite,d;
         addx unite,d;
         cpa unite,d;
         brlt unitnum;
         brge unit;
         br loop;

unitnum:  cpx 9,i;
         breq print9;
         cpx 8,i;
         breq print8;
         cpx 7,i;
         breq print7;
         cpx 6,i;
         breq print6;
         cpx 5,i;
         breq print5;
         cpx 4,i;
         breq print4;
         cpx 3,i;
         breq print3;
         cpx 2,i;
         breq print2;
         cpx 1,i;
         breq print1;
         br loop;

print9:  stro IX,d; 
         br loop;
print8:  stro VIII,d;
         br loop;
print7:  stro VII,d;
         br loop;
print6:  stro VI,d;
         br loop;
print5:  stro V,d;
         br loop;
print4:  stro IV,d;
         br loop;
print3:  stro III,d;
         br loop;
print2:  stro II,d;
         br loop;
print1:  stro I,d;
         br loop;




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
M:       .ascii  "M\x00" 

CM:      .ascii  "CM\x00"
DCCC:    .ascii  "DCCC\x00"
DCC:     .ascii  "DCC\x00"
DC:      .ascii  "DC\x00"
D:       .ascii  "D\x00"
CD:      .ascii  "CD\x00"
CCC:     .ascii  "CCC\x00"
CC:      .ascii  "CC\x00"
C:       .ascii  "C\x00"

XC:      .ascii  "XC\x00"
LXXX:    .ascii  "LXXX\x00"
LXX:     .ascii  "LXX\x00"
LX:      .ascii  "LX\x00"
L:       .ascii  "L\x00"
XL:      .ascii  "XL\x00"
XXX:     .ascii  "XXX\x00"
XX:      .ascii  "XX\x00"
X:       .ascii  "X\x00"
     
IX:      .ascii "IX\x00"
VIII:    .ascii "VIII\x00"
VII:     .ascii "VII\x00"
VI:      .ascii "VI\x00"
V:       .ascii "V\x00"
IV:      .ascii "IV\x00"
III:     .ascii "III\x00"
II:      .ascii "II\x00"
I:       .ascii "I\x00"



         .end