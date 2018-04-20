0

LDM R0,3  ; # of occurance of loop
LDM R1,5  ; R1=5
LDM R2,14 ; R2=11
LDM R3,10  ; R3=7
LDM R4,24 ; R4=19
Add R1,R1,R1 ; R1 Will be 40 at the end of loop 
DEC R0
JZ  R2
JMP R3
call R4   
LDM R5,26
Nop
Jmp R5
Nop
Nop
Nop
Nop
Nop
DEC R1  
RET

RTI
