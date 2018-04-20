Library ieee;
Use ieee.std_logic_1164.all;

Entity stack is
port( 
	Clk,Rst : in std_logic;
	Cu3 : in std_logic_vector(1 downto 0);
	Cu2 : in std_logic;
	Cu1 : in std_logic;
	EAi : in std_logic_vector(9 downto 0);
	EAo : out std_logic_vector(9 downto 0);
	enable : in std_logic
);
end stack;

Architecture structural of stack is 

component my_nadder is
generic (n : integer := 16);
port (
	a, b: in std_logic_vector(n - 1 downto 0); 
	cin: in std_logic; 
	s: out std_logic_vector(n - 1 downto 0);
	cout: out std_logic
	);
end component;

component General_Reg is 
Generic ( n : integer := 16);
port(
Clk : in std_logic;
Rst : in std_logic;
Enb : in std_logic;
D : in std_logic_vector((n-1) downto 0);
Q : out std_logic_vector((n-1) downto 0)
);
end component;

-- 
signal Sp_i, Spointer1, Spointer2, Spointer3, Sp_o, Spointerfinal : std_logic_vector(9 downto 0);
signal cout : std_logic;
begin
u0: General_Reg generic map (n=>10) port map(Clk, '0', enable, Sp_i, Sp_o);
u1: my_nadder generic map (n=>10) port map(Sp_o, "0000000001" , '0' , Spointer2 ,cout );
u2: my_nadder generic map (n=>10) port map(Sp_o, "1111111111", '0' , Spointer1 ,cout );

Sp_i <= "1111111111" when Rst='1' else
	Spointerfinal;

Spointerfinal<= Spointer2 when Cu3="10" else --Same SP
	Spointer1 when Cu3="01" else 
	Sp_o;

Spointer3 <= Spointer2 when Cu2 = '1' else
		Sp_o;

EAo <=	EAi when Cu1 = '1' else
	Spointer3;

end structural;
