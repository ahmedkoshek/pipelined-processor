library ieee;
use ieee.std_logic_1164.all;
entity EMem_Reg is 
Generic ( n : integer := 16);
port(
	Clk : in std_logic;
	Rst : in std_logic;
	Enb : in std_logic;

	--INPUT
	--D-E Buffer directly
	Rd_i : in std_logic_vector(2 downto 0);
	imm16_i : in std_logic_vector(15 downto 0);
	PC_i : in std_logic_vector(9 downto 0);
	PC1_i : in std_logic_vector(9 downto 0);
	--Stack Pointer
	Effective_Address_i : in std_logic_vector(9 downto 0);
	--Memory signals
	Mux_mem_value_i : in std_logic_vector(1 downto 0);
	Mux_mem_address_i : in std_logic_vector(1 downto 0);
	Mem_We_i : in std_logic;
	--Write Back signals
	Mux_WB_i : in std_logic_vector(1 downto 0);
	WE_i: in std_logic;

	--ALU
	ALU_Value_i : in std_logic_vector(15 downto 0);
	mux_PC_i : in std_logic;
	RetSig_i : in std_logic;
	IntSig_i : in std_logic;
	Mux_FU_ALU_i : in std_logic;
	
	--OUTPUT
	--D-E Buffer directly
	Rd_o : out std_logic_vector(2 downto 0);
	imm16_o : out std_logic_vector(15 downto 0);
	PC_o : out std_logic_vector(9 downto 0);
	PC1_o : out std_logic_vector(9 downto 0);
	--Stack Pointer
	Effective_Address_o : out std_logic_vector(9 downto 0);
	--Memory signals
	Mux_mem_value_o : out std_logic_vector(1 downto 0);
	Mux_mem_address_o : out std_logic_vector(1 downto 0);
	Mem_We_o : out std_logic;
	--Write Back signals
	Mux_WB_o : out std_logic_vector(1 downto 0);
	WE_o: out std_logic;

	--ALU
	ALU_Value_o : out std_logic_vector(15 downto 0);
	mux_PC_o : out std_logic;
	RetSig_o : out std_logic;
	IntSig_o : out std_logic;
	Mux_FU_ALU_o : out std_logic

	);
end entity EMem_Reg;

architecture EMem_Reg_arch of EMem_Reg is
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

Rd: General_Reg generic map (n=>3) port map(Clk,Rst,Enb,Rd_i,Rd_o);
imm16: General_Reg generic map (n=>16) port map(Clk,Rst,Enb,imm16_i,imm16_o);
PC: General_Reg generic map (n=>10) port map(Clk,Rst,Enb,PC_i,PC_o);
PC1: General_Reg generic map (n=>10) port map(Clk,Rst,Enb,PC1_i,PC1_o);
--Stack Pointer
Effective_Address: General_Reg generic map (n=>10) port map(Clk,Rst,Enb,Effective_Address_i,Effective_Address_o);
--Memory signals
Mux_mem_value: General_Reg generic map (n=>2) port map(Clk,Rst,Enb,Mux_mem_value_i,Mux_mem_value_o);
Mux_mem_address: General_Reg generic map (n=>2) port map(Clk,Rst,Enb,Mux_mem_address_i,Mux_mem_address_o);
Mem_We: One_Bit_Reg port map(Clk,Rst,Enb,Mem_We_i,Mem_We_o);
--Write Back signals
Mux_WB: General_Reg generic map (n=>2) port map(Clk,Rst,Enb,Mux_WB_i,Mux_WB_o);
WE: One_Bit_Reg port map(Clk,Rst,Enb,WE_i,WE_o);

--ALU
ALU_Value: General_Reg generic map (n=>16) port map(Clk,Rst,Enb,ALU_Value_i,ALU_Value_o);
mux_PC: One_Bit_Reg port map(Clk,Rst,Enb,mux_PC_i,mux_PC_o);
RetSig: One_Bit_Reg port map(Clk,Rst,Enb,RetSig_i,RetSig_o);
IntSig: One_Bit_Reg port map(Clk,Rst,Enb,IntSig_i,IntSig_o);
Mux_FU_ALU: One_Bit_Reg port map(Clk,Rst,Enb,Mux_FU_ALU_i,Mux_FU_ALU_o);

end EMem_Reg_arch; 
