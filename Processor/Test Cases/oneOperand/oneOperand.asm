0         ;the program starts at address 0
125        ;ISR address

;set value 5d at In Port
IN R0      ;R0=5
SETC       ;C=1
;set value 4d at In Port
IN R1      ;R1=4
;set value 7d at In Port
IN R3      ;R3=7
RLC R0     ;R0=11   C=0
NOT R1     ;R1=-5=1111111111111011b   N=1 Z=0
NEG R3     ;R3=-7   N=1 Z=0
;set value 1d at In Port
IN R4      ;R4=1
;set value 3d at In Port
IN R5      ;R5=3
NOP 
RRC R4     ;R4=0  N=0 C=1 Z=1
INC R5     ;R5=4  N=0 C=0 Z=0
DEC R1     ;R1=-6 N=1 Z=0


.125
RTI

