library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is 
port (
	a, b: in std_logic_vector(15 downto 0); 
	s: in std_logic_vector(4 downto 0);
	imm: in std_logic_vector(3 downto 0);
	iFlags : in std_logic_vector(3 downto 0);
	f: out std_logic_vector(15 downto 0);
	oFlags: out std_logic_vector(3 downto 0) 
	);
end entity ALU;

-- xFlags(0) = Zero Flag
-- xFLags(1) = Negative Flag
-- xFlags(2) = Carry Flag
-- xFlags(3) = Overflow Flag

architecture alu of ALU is
component my_nadder is 
generic (n : integer := 16);
port (
	a, b: in std_logic_vector(n - 1 downto 0); 
	cin: in std_logic; 
	s: out std_logic_vector(n - 1 downto 0);
	cout: out std_logic
	);
end component;

signal a1, b1, result, zeros : std_logic_vector(15 downto 0);
signal zero, negative, cin, cout, coutt, overflow : std_logic;
signal immI : integer;

begin

adder: my_nadder generic map (n => 16) port map(a1, b1, cin, result, coutt);

immI <= to_integer(unsigned(imm));

zeros <= (others => '0');

zero <= '1' when (result = "0000000000000000") and (s = "00010" or s = "00011" or s = "00100" or s = "00101" or s = "10000" or s = "10001" or s = "10010" or s = "10011") else
	'0' when (result /= "0000000000000000") and (s = "00010" or s = "00011" or s = "00100" or s = "00101" or s = "10000" or s = "10001" or s = "10010" or s = "10011") else
	iFlags(0);

negative <=	'1' when result(15) = '1' and (s = "00010" or s = "00011" or s = "00100" or s = "00101" or s = "10000" or s = "10001" or s = "10010" or s = "10011") else
		'0' when result(15) /= '1' and (s = "00010" or s = "00011" or s = "00100" or s = "00101" or s = "10000" or s = "10001" or s = "10010" or s = "10011") else
		iFlags(1);

overflow <=	'1' when ((a(15) = b(15)) and  ((a(15) and b(15)) /= result(15)) and (s = "00010" or s = "10010")) else
		'1' when ((result(15) = b(15)) and  ((result(15) and b(15)) /= a(15)) and (s = "00011" or s = "10011")) else
		'0' when (s = "00010" or s = "10010" or s = "00011" or s = "10011") else
		iFlags(3);

a1 <=	not a when s = "10001" else
	a;

b1 <=	not b when s = "00011" else
	(0 => '1', others => '0') when s = "10001" else
	(0 => '1', others => '0') when s = "10010" else
	(others => '1') when s = "10011" else
	b;

cin <=	'1' when s = "00011" else
	'0';

cout <= a(15) when s = "00110" else
	a(0) when s = "00111" else
	'1' when s = "01010" else
	'0' when s = "01011" else
	not coutt when s = "00011" else
	not coutt when s = "10011" else
	coutt when s = "00010" else
	coutt when s = "10010" else
	iFlags(2);

f <=	a when s = "00001" else								--MOV
	result when s = "00010" else							--ADD
	result when s = "00011" else							--SUB
	a and b when s = "00100" else							--AND
	a or b when s = "00101" else							--OR
	a(14 downto 0) & iFlags(2) when s = "00110" else					--RLC
	iFlags(2) & a(15 downto 1) when s = "00111" else					--RRC
	a(15-immI downto 0) & zeros(immI-1 downto 0)  when s = "01000" else		--SHL
	zeros(immI-1 downto 0) & a(15 downto immI) when s = "01001" else		--SHR
	a when s = "01100" else								--PUSH
	not a when s = "10000" else							--NOT
	result when s = "10001" else							--NEG
	result when s = "10010" else							--INC
	result when s = "10011" else							--DEC
	a when s = "11000" else								--CALL
	a when s = "11101" else								--STD
	(others => '0');

oFlags <= overflow & cout & negative & zero;

end architecture alu;