library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity MemoryUnit is
port ( 
	clk : in std_logic;
	Mem_We : in std_logic;

	ALU_Value : in std_logic_vector(15 downto 0);
	PC : in std_logic_vector(9 downto 0);
	PC1 : in std_logic_vector(9 downto 0);
	Mux_mem_value : in std_logic_vector(1 downto 0);

	Mux_mem_address : in std_logic_vector(1 downto 0);
	address : in std_logic_vector(9 downto 0);

	dataout : out std_logic_vector(15 downto 0);
	data0: out std_logic_vector(15 downto 0);
	data1: out std_logic_vector(15 downto 0)
	);
end entity MemoryUnit;

architecture MemoryUnit_arch of MemoryUnit is

Component syncram is
Generic (n : integer := 10);
port ( 
clk : in std_logic;
we : in std_logic;
address : in std_logic_vector(n-1 downto 0);
datain : in std_logic_vector(15 downto 0);
dataout : out std_logic_vector(15 downto 0);
data0: out std_logic_vector(15 downto 0);
data1: out std_logic_vector(15 downto 0)
);
end Component;

signal DataINSIGNAL: std_logic_vector(15 downto 0);
signal EASIGNAL: std_logic_vector(9 downto 0);
begin
	DataINSIGNAL<= "000000" & PC1 when Mux_mem_value = "10" else
		"000000" & PC when Mux_mem_value = "01" else
		ALU_Value;
	
	EASIGNAL<= "0000000000" when Mux_mem_address = "10" else
		"0000000001" when Mux_mem_address = "01" else
		address;
	
	Mem: syncram port map (clk,Mem_We,EASIGNAL,DataINSIGNAL,dataout,data0,data1);
end architecture MemoryUnit_arch;


