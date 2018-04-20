library ieee;
use ieee.std_logic_1164.all;

entity RegFile is
port(
	CLK: in std_logic; 
	RST: in std_logic;
	Rs_sel: in std_logic_vector(2 downto 0);
	Rt_sel: in std_logic_vector(2 downto 0);
	W_en: in std_logic;
	Rd_sel: in std_logic_vector(2 downto 0);
	Write_value: in std_logic_vector(15 downto 0);
	Rs_data: out std_logic_vector(15 downto 0);
	Rt_data: out std_logic_vector(15 downto 0)
	);
end RegFile;


architecture regFile of RegFile is
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

signal e1, e2, e3, e4, e5, e6 : std_logic;
signal r1, r2, r3, r4, r5, r6 : std_logic_vector(15 downto 0);

begin

e1 <= 	W_en when Rd_sel = "001" else
	'0';
e2 <= 	W_en when Rd_sel = "010" else
	'0';
e3 <= 	W_en when Rd_sel = "011" else
	'0';
e4 <= 	W_en when Rd_sel = "100" else
	'0';
e5 <= 	W_en when Rd_sel = "101" else
	'0';
e6 <= 	W_en when Rd_sel = "110" else
	'0';

reg1 : General_Reg generic map (n => 16) port map(CLK, RST, e1, Write_value, r1);
reg2 : General_Reg generic map (n => 16) port map(CLK, RST, e2, Write_value, r2);
reg3 : General_Reg generic map (n => 16) port map(CLK, RST, e3, Write_value, r3);
reg4 : General_Reg generic map (n => 16) port map(CLK, RST, e4, Write_value, r4); 
reg5 : General_Reg generic map (n => 16) port map(CLK, RST, e5, Write_value, r5); 
reg6 : General_Reg generic map (n => 16) port map(CLK, RST, e6, Write_value, r6); 

Rs_data <=	r1 when Rs_sel = "001" else
		r2 when Rs_sel = "010" else
		r3 when Rs_sel = "011" else
		r4 when Rs_sel = "100" else
		r5 when Rs_sel = "101" else
		r6 when Rs_sel = "110";

Rt_data <=	r1 when Rt_sel = "001" else
		r2 when Rt_sel = "010" else
		r3 when Rt_sel = "011" else
		r4 when Rt_sel = "100" else
		r5 when Rt_sel = "101" else
		r6 when Rt_sel = "110";

end architecture regFile;