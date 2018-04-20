library ieee;
use ieee.std_logic_1164.all;
entity DEx_Reg is 
Generic ( n : integer := 16);
port(
	Clk : in std_logic;
	Rst : in std_logic;
	Enb : in std_logic;

	--INPUT
	--Register File outputs
	Rs_Value_i : in std_logic_vector(15 downto 0);
	Rt_Value_i : in std_logic_vector(15 downto 0);
	--F-D Buffer directly
	Rs_i : in std_logic_vector(2 downto 0);
	Rt_i : in std_logic_vector(2 downto 0);
	Rd_i : in std_logic_vector(2 downto 0);
	imm4_i : in std_logic_vector(3 downto 0);
	imm16_i : in std_logic_vector(15 downto 0);
	PC_i : in std_logic_vector(9 downto 0);
	PC1_i : in std_logic_vector(9 downto 0);
	--Stack Pointer
	Effective_Address_i : in std_logic_vector(9 downto 0);
	--Control Unit signals
	--Excute signals
	ALUSig_i : in std_logic_vector(4 downto 0);
	OutSig_i : in std_logic;
	Mux_copy_EX_i : in std_logic;
	Mux_Flag1_i : in std_logic;
	Flag_int_en_i : in std_logic;
	Flag1_en_i : in std_logic;
	--jump signals
	JZSig_i : in std_logic;
	JNSig_i : in std_logic;
	JCSig_i : in std_logic;
	JmpSig_i : in std_logic;
	CallSig_i : in std_logic;
	--Memory signals
	Mux_mem_value_i : in std_logic_vector(1 downto 0);
	Mux_mem_address_i : in std_logic_vector(1 downto 0);
	Mem_We_i : in std_logic;
	--Write Back signals
	Mux_WB_i : in std_logic_vector(1 downto 0);
	WE_i: in std_logic;

	mux_PC_i : in std_logic;
	RetSig_i : in std_logic;
	IntSig_i : in std_logic;
	MreadSig_i : in std_logic;
	Mux_FU_ALU_i : in std_logic;
	
	--OUTPUT
	--Register File outputs
	Rs_Value_o : out std_logic_vector(15 downto 0);
	Rt_Value_o : out std_logic_vector(15 downto 0);
	--F-D Buffer directly
	Rs_o : out std_logic_vector(2 downto 0);
	Rt_o : out std_logic_vector(2 downto 0);
	Rd_o : out std_logic_vector(2 downto 0);
	imm4_o : out std_logic_vector(3 downto 0);
	imm16_o : out std_logic_vector(15 downto 0);
	PC_o : out std_logic_vector(9 downto 0);
	PC1_o : out std_logic_vector(9 downto 0);
	--Stack Pointer
	Effective_Address_o : out std_logic_vector(9 downto 0);
	--Control Unit signals
	--Excute signals
	ALUSig_o : out std_logic_vector(4 downto 0);
	OutSig_o : out std_logic;
	Mux_copy_EX_o : out std_logic;
	Mux_Flag1_o : out std_logic;
	Flag_int_en_o : out std_logic;
	Flag1_en_o : out std_logic;
	--jump signals
	JZSig_o : out std_logic;
	JNSig_o : out std_logic;
	JCSig_o : out std_logic;
	JmpSig_o : out std_logic;
	CallSig_o : out std_logic;
	--Memory signals
	Mux_mem_value_o : out std_logic_vector(1 downto 0);
	Mux_mem_address_o : out std_logic_vector(1 downto 0);
	Mem_We_o : out std_logic;
	--Write Back signals
	Mux_WB_o : out std_logic_vector(1 downto 0);
	WE_o: out std_logic;

	mux_PC_o : out std_logic;
	RetSig_o : out std_logic;
	IntSig_o : out std_logic;
	MreadSig_o : out std_logic;
	Mux_FU_ALU_o : out std_logic
	);
end entity DEx_Reg;

architecture DEx_Reg_arch of DEx_Reg is
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

--INPUT
--Register File outputs
Rs_Value: General_Reg generic map (n=>16) port map(Clk,Rst,Enb,Rs_Value_i,Rs_Value_o);
Rt_Value: General_Reg generic map (n=>16) port map(Clk,Rst,Enb,Rt_Value_i,Rt_Value_o);
--F-D Buffer directly
Rs: General_Reg generic map (n=>3) port map(Clk,Rst,Enb,Rs_i,Rs_o);
Rt: General_Reg generic map (n=>3) port map(Clk,Rst,Enb,Rt_i,Rt_o);
Rd: General_Reg generic map (n=>3) port map(Clk,Rst,Enb,Rd_i,Rd_o);
imm4: General_Reg generic map (n=>4) port map(Clk,'0',Enb,imm4_i,imm4_o);
imm16: General_Reg generic map (n=>16) port map(Clk,Rst,Enb,imm16_i,imm16_o);
PC: General_Reg generic map (n=>10) port map(Clk,Rst,Enb,PC_i,PC_o);
PC1: General_Reg generic map (n=>10) port map(Clk,Rst,Enb,PC1_i,PC1_o);
--Stack Pointer
Effective_Address: General_Reg generic map (n=>10) port map(Clk,Rst,Enb,Effective_Address_i,Effective_Address_o);
--Control Unit signals
--Excute signals
ALUSig: General_Reg generic map (n=>5) port map(Clk,Rst,Enb,ALUSig_i,ALUSig_o);
OutSig: One_Bit_Reg port map(Clk,Rst,Enb,OutSig_i,OutSig_o);
Mux_copy_EX: One_Bit_Reg port map(Clk,Rst,Enb,Mux_copy_EX_i,Mux_copy_EX_o);
Mux_Flag1: One_Bit_Reg port map(Clk,Rst,Enb,Mux_Flag1_i,Mux_Flag1_o);
Flag_int_en: One_Bit_Reg port map(Clk,Rst,Enb,Flag_int_en_i,Flag_int_en_o);
Flag1_en: One_Bit_Reg port map(Clk,Rst,Enb,Flag1_en_i,Flag1_en_o);
--jump signals
JZSig: One_Bit_Reg port map(Clk,Rst,Enb,JZSig_i,JZSig_o);
JNSig: One_Bit_Reg port map(Clk,Rst,Enb,JNSig_i,JNSig_o);
JCSig: One_Bit_Reg port map(Clk,Rst,Enb,JCSig_i,JCSig_o);
JmpSig: One_Bit_Reg port map(Clk,Rst,Enb,JmpSig_i,JmpSig_o);
CallSig: One_Bit_Reg port map(Clk,Rst,Enb,CallSig_i,CallSig_o);
--Memory signals
Mux_mem_value: General_Reg generic map (n=>2) port map(Clk,Rst,Enb,Mux_mem_value_i,Mux_mem_value_o);
Mux_mem_address: General_Reg generic map (n=>2) port map(Clk,Rst,Enb,Mux_mem_address_i,Mux_mem_address_o);
Mem_We: One_Bit_Reg port map(Clk,Rst,Enb,Mem_We_i,Mem_We_o);
--Write Back signals
Mux_WB: General_Reg generic map (n=>2) port map(Clk,Rst,Enb,Mux_WB_i,Mux_WB_o);
WE: One_Bit_Reg port map(Clk,Rst,Enb,WE_i,WE_o);

mux_PC: One_Bit_Reg port map(Clk,Rst,Enb,mux_PC_i,mux_PC_o);
RetSig: One_Bit_Reg port map(Clk,Rst,Enb,RetSig_i,RetSig_o);
IntSig: One_Bit_Reg port map(Clk,Rst,Enb,IntSig_i,IntSig_o);
MreadSig: One_Bit_Reg port map(Clk,Rst,Enb,MreadSig_i,MreadSig_o);
Mux_FU_ALU: One_Bit_Reg port map(Clk,Rst,Enb,Mux_FU_ALU_i,Mux_FU_ALU_o);

end DEx_Reg_arch; 
