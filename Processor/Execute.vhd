library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Execute is 
	port (
		r1, r2, mem, wb: in std_logic_vector(15 downto 0);
		mux1, mux2: in std_logic_vector(1 downto 0); 
		s: in std_logic_vector(4 downto 0);
		imm: in std_logic_vector(3 downto 0);
		f, oPort: out std_logic_vector(15 downto 0);
		CLK, ef1, ef2, m1, m2, m3 : in std_logic;
		oFlags: out std_logic_vector(3 downto 0);
		Rs_Data_Chosen: out std_logic_vector(15 downto 0);
		Reset: in std_logic
	);
end entity Execute;

-- xFlags(0) = Zero Flag
-- xFLags(1) = Negative Flag
-- xFlags(2) = Carry Flag
-- xFlags(3) = Overflow Flag

architecture execute of Execute is
	
	component ALU is 
		port (
			a, b: in std_logic_vector(15 downto 0); 
			s: in std_logic_vector(4 downto 0);
			imm: in std_logic_vector(3 downto 0);
			iFlags : in std_logic_vector(3 downto 0);
			f: out std_logic_vector(15 downto 0);
			oFlags: out std_logic_vector(3 downto 0) 
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
	
	signal a1, b1: std_logic_vector(15 downto 0);
	signal if1, of1, of2, of3, of4: std_logic_vector(3 downto 0);
	signal rst1, rst2: std_logic;
	
	begin
	
	aluC: ALU port map (a1, b1, s, imm, of1, f, of3);
	flagsR: General_Reg generic map (n => 4) port map (CLK, rst1, ef1, if1, of1);
	flagsRI: General_Reg generic map (n => 4) port map (CLK, rst2, ef2, of4, of2);
	
	oPort <=	a1 when m3 = '1' else
	(others => '0');
	
	if1 <=	of3 when m1 = '0' else
	of4;
	
	of4 <=	of1 when m2 = '0' else
	of2;
	
	a1 <=	r1 when mux1 = "00" else
	mem when mux1 = "01" else
	wb when mux1 = "10" else
	(others => '0');
	
	b1 <=	r2 when mux2 = "00" else
	mem when mux2 = "01" else
	wb when mux2 = "10" else
	(others => '0');
	
	rst1 <=	'1' when Reset = '1' else
			'0';
	
	rst2 <=	'1' when Reset = '1' else
			'0';
	
	oFlags <= of1;
	
	Rs_Data_Chosen <= a1;
	
end architecture execute;
