;data segment
0
10
20
30
40
50
60
70


LDD R2,5  ;R2=50
LDD R1,4  ;R1=40
PUSH R1
PUSH R2
POP R1
POP R2
ADD R1,R1,R3 ;R3=100
ADD R2,R2,R4 ;R4=80