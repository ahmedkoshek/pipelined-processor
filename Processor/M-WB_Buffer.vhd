library ieee;
use ieee.std_logic_1164.all;
entity MWb_Reg is 
Generic ( n : integer := 16);
port(
	Clk : in std_logic;
	Rst : in std_logic;
	Enb : in std_logic;

	--INPUT
	--E-M Buffer directly
	Rd_i : in std_logic_vector(2 downto 0);
	imm16_i : in std_logic_vector(15 downto 0);

	Mux_WB_i : in std_logic_vector(1 downto 0);
	WE_i: in std_logic;

	ALU_Value_i : in std_logic_vector(15 downto 0);

	--Memory
	Data_Memory_i : in std_logic_vector(15 downto 0);
	mux_PC_i : in std_logic;
	RetSig_i : in std_logic;
	IntSig_i : in std_logic;
	
	--OUTPUT
	--E-M Buffer directly
	Rd_o : out std_logic_vector(2 downto 0);
	imm16_o : out std_logic_vector(15 downto 0);

	Mux_WB_o : out std_logic_vector(1 downto 0);
	WE_o: out std_logic;

	ALU_Value_o : out std_logic_vector(15 downto 0);

	--Memory
	Data_Memory_o : out std_logic_vector(15 downto 0);
	mux_PC_o : out std_logic;
	RetSig_o : out std_logic;
	IntSig_o : out std_logic
	);
end entity MWb_Reg;

architecture MWb_Reg_arch of MWb_Reg is
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

component One_Bit_Reg is 
port(
Clk : in std_logic;
Rst : in std_logic;
Enb : in std_logic;
D : in std_logic;
Q : out std_logic
);
end component;

begin

--E-M Buffer directly
Rd: General_Reg generic map (n=>3) port map(Clk,Rst,Enb,Rd_i,Rd_o);
imm16: General_Reg generic map (n=>16) port map(Clk,Rst,Enb,imm16_i,imm16_o);

Mux_WB: General_Reg generic map (n=>2) port map(Clk,Rst,Enb,Mux_WB_i,Mux_WB_o);
WE: One_Bit_Reg port map(Clk,Rst,Enb,WE_i,WE_o);

ALU_Value: General_Reg generic map (n=>16) port map(Clk,Rst,Enb,ALU_Value_i,ALU_Value_o);

--Memory
Data_Memory: General_Reg generic map (n=>16) port map(Clk,Rst,Enb,Data_Memory_i,Data_Memory_o);
mux_PC: One_Bit_Reg port map(Clk,Rst,Enb,mux_PC_i,mux_PC_o);
RetSig: One_Bit_Reg port map(Clk,Rst,Enb,RetSig_i,RetSig_o);
IntSig: One_Bit_Reg port map(Clk,Rst,Enb,IntSig_i,IntSig_o);

end MWb_Reg_arch; 
