4     ;the program starts at address 4
100

LDM R1,7  ;R1=7
LDM R2,6  ;R2=6
LDM R0,5  ;R0=5
LDM R4,10 ;R4=10
Add R1,R2,R1 ;R1=13 N=0  C=0  Z=0
OR  R2,R0,R2 ;R2=7  N=0  C=0  Z=0
Sub R0,R4,R0 ;R0=-5 N=1  
Mov R4,R1 ;R4=13 
AND R1,R2,R1 ;R1=5

.100
SETC
LDM R1,5
LDM R2,5
NOP
NOP
Sub R1,R2,R1  ;R1=0 Z=1
RTI

