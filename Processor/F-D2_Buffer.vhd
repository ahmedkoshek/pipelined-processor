library ieee;
use ieee.std_logic_1164.all;
entity FD2_Reg is 
Generic ( n : integer := 16);
port(
	Clk : in std_logic;
	Rst : in std_logic;
	Enb : in std_logic;
	inst_i : in std_logic_vector(15 downto 0);
	inst_o : out std_logic_vector(15 downto 0)
	);
end FD2_Reg;

architecture FD2_Reg_arch of FD2_Reg is
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
begin
Instruction_Reg: General_Reg generic map (n=>16) port map(Clk,Rst,Enb,inst_i,inst_o);
end FD2_Reg_arch;
