library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity cu is
port ( 
reset : in std_logic;
interrupt : in std_logic;
opcode : in std_logic_vector(4 downto 0);
F_D_Buffer_enable_i : in std_logic;
--Stack Pointer signals
Mux_SP_1 : out std_logic;
Mux_SP_2 : out std_logic;
Mux_SP_3 : out std_logic_vector(1 downto 0);

--Excute signals
ALUSig : out std_logic_vector(4 downto 0);
OutSig : out std_logic;
Mux_copy_EX : out std_logic;
Mux_Flag1 : out std_logic;
Flag_int_en : out std_logic;
Flag1_en : out std_logic;

--jump signals
JZSig : out std_logic;
JNSig : out std_logic;
JCSig : out std_logic;
JmpSig : out std_logic;
CallSig : out std_logic;

--Memory signals
Mux_mem_value : out std_logic_vector(1 downto 0);
Mux_mem_address : out std_logic_vector(1 downto 0);
Mem_We : out std_logic;

--Write Back signals
Mux_WB : out std_logic_vector(1 downto 0);
WE: out std_logic;


mux_PC : out std_logic;
F_D_Buffer_enable_o : out std_logic;
RetSig : out std_logic;
IntSig : out std_logic;
MreadSig : out std_logic;
Mux_FU_ALU : out std_logic
);
end entity cu;

architecture cu_a of cu is
begin
	Mux_SP_1<= '1' when (opcode="11100" or opcode="11101") and interrupt='0' and F_D_Buffer_enable_i='0' else
		'0';
	Mux_SP_2<= '1' when (opcode="01101" or opcode="11001" or opcode="11010") and interrupt='0' else
		'0';
	Mux_SP_3<= "10" when (opcode="01101" or opcode="11001" or opcode="11010") and interrupt='0' and reset='0' else
		"01" when (opcode="01100" or opcode="11000" or interrupt='1') and reset='0' else
		"00";
	
	ALUSig<= "00000" when (interrupt='1' or reset='1') else
		opcode;
	OutSig<= '1' when (opcode="01110") else
		'0';
	Mux_copy_EX<= '1' when (opcode="11010") else
		'0';
	Mux_Flag1<= '1' when (opcode="11010") else --RTI
		'0';
	Flag_int_en<= '1' when (interrupt='1') else --INT
		'0';
	Flag1_en<= '1';

	
	
	Mux_mem_value<= "10" when (opcode="11000" and interrupt='0') else --call push PC+1
		"01" when (interrupt='1') else --INT push PC
		"00"; --V.ALU
	Mux_mem_address<= "10" when (reset='1') else --0
		--"01" when (interrupt='1') else --1
		"00"; --Effective address
	Mem_We<= '1' when (opcode="01100" or opcode="11000" or interrupt='1'
						or (opcode="11101" and F_D_Buffer_enable_i='0'))
						and reset='0' else
		'0';
	
	Mux_WB<= "11" when (opcode="01111") else --In.Port
		"10" when (opcode="11100" or opcode="01101") else --Data
		"01" when (opcode="11011") else --Imm 16-bits
		"00"; --V.ALU
	WE<= '1' when (opcode="00001" or opcode="00010" or opcode="00011" or opcode="00100" or opcode="00101"
					or opcode="00110" or opcode="00111" or opcode="01000" or opcode="01001" or opcode="01101"
					or opcode="01111" or opcode="10000" or opcode="10001" or opcode="10010" or opcode="10011"
					or (opcode="11011" and F_D_Buffer_enable_i='0')
					or (opcode="11100" and F_D_Buffer_enable_i='0'))
					and reset='0' and interrupt='0' else
		'0';
	
	JZSig<= '1' when (opcode="10100" and interrupt='0') else
		'0';
	JNSig<= '1' when (opcode="10101" and interrupt='0') else
		'0';
	JCSig<= '1' when (opcode="10110" and interrupt='0') else
		'0';
	JmpSig<= '1' when (opcode="10111" and interrupt='0') else
		'0';
	CallSig<= '1' when (opcode="11000" and interrupt='0') else
		'0';
	
	
	
	mux_PC<= '1' when (opcode="11001" or opcode="11010" or interrupt='1') else
		'0';
	
	F_D_Buffer_enable_o<= '0' when (opcode="11011" or opcode="11100" or opcode="11101")
									and F_D_Buffer_enable_i='1' else
									'1';
	
	RetSig<= '1' when opcode="11001" or opcode="11010" else
		'0';
	
	IntSig<= '1' when interrupt='1' else
		'0';
	
	MreadSig<= '1' when (opcode="11100" and F_D_Buffer_enable_i='0') or opcode="01101" or opcode="01111" else
		'0';
	
	Mux_FU_ALU<= '1' when (opcode="11011" and F_D_Buffer_enable_i='0') else
		'0';
end architecture cu_a;