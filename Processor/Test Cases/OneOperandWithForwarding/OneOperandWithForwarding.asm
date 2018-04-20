5     ;the program starts at address 5
100   ;ISR address

;set value 5d at In Port
IN R0   ;R0=5
SETC    ;C=1
;set value 4d at In Port
IN R1   ;R1=4
RLC R0  ;R0=11   C=0
NOT R1  ;R1=-5   N=1 Z=0
;set value -7 at In Port
IN R3   ;R3=-7    
NEG R3  ;R3=7   N=0 Z=0


.100
RTI