library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity processor is 
Generic ( n : integer := 16);
port(
	Clk : in std_logic;
	Rst : in std_logic;
	interrupt : in std_logic;
	in_port : in std_logic_vector(15 downto 0);
	out_port : out std_logic_vector(15 downto 0)
	);
end processor;

architecture processor_arch of processor is

---------------------------------------------Components--------------------------------------
-----------Buffers--
component FD_Reg is 
Generic ( n : integer := 16);
port(
	Clk : in std_logic;
	Rst : in std_logic;
	Enb : in std_logic;
	inst_i : in std_logic_vector(15 downto 0);
	inst_o : out std_logic_vector(15 downto 0);
	PC_i : in std_logic_vector(9 downto 0);
	PC_o : out std_logic_vector(9 downto 0);
	PC1_i : in std_logic_vector(9 downto 0);
	PC1_o : out std_logic_vector(9 downto 0)
	);
end component;

component FD2_Reg is 
Generic ( n : integer := 16);
port(
	Clk : in std_logic;
	Rst : in std_logic;
	Enb : in std_logic;
	inst_i : in std_logic_vector(15 downto 0);
	inst_o : out std_logic_vector(15 downto 0)
	);
end component;

component DEx_Reg is 
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
	--Execute signals
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
	--Execute signals
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
end component;

component EMem_Reg is 
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
end component;

component MWb_Reg is 
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
end component;

-----------Stages--
component cu is
port ( 
reset : in std_logic;
interrupt : in std_logic;
opcode : in std_logic_vector(4 downto 0);
F_D_Buffer_enable_i : in std_logic;
--Stack Pointer signals
Mux_SP_1 : out std_logic;
Mux_SP_2 : out std_logic;
Mux_SP_3 : out std_logic_vector(1 downto 0);

--Execute signals
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
end component;

component RegFile is
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
end component;

component stack is
port( 
	Clk,Rst : in std_logic;
	Cu3 : in std_logic_vector(1 downto 0);
	Cu2 : in std_logic;
	Cu1 : in std_logic;
	EAi : in std_logic_vector(9 downto 0);
	EAo : out std_logic_vector(9 downto 0);
	enable : in std_logic
);
end component;

component Execute is 
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
end component;

component MemoryUnit is
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
end component;

component ForwardUnit is
port ( 
	M_WRg: in std_logic_vector(2 downto 0);
	E_MRg: in std_logic_vector(2 downto 0);
	D_ERgA: in std_logic_vector(2 downto 0);
	D_ERgB: in std_logic_vector(2 downto 0);
	M_WWB: in std_logic;
	E_MWB: in std_logic;
	DecMuxA: out std_logic_vector(1 downto 0);
	DecMuxB: out std_logic_vector(1 downto 0)
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

component syncram is
Generic (n : integer := 10);
port ( 
	clk : in std_logic;
	we : in std_logic;
	address : in std_logic_vector(n-1 downto 0);
	datain : in std_logic_vector(15 downto 0);
	dataout : out std_logic_vector(15 downto 0);
	data0: out std_logic_vector(15 downto 0)
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

component  My_Detection_Unit is
port(
	Rd1,Rs,Rt : in std_logic_vector(2 downto 0);
	Mread : in std_logic;
	s1,s2,s3: out std_logic
);
end component; 

---------------------------------------------Signals--------------------------------------
signal SP_enable: std_logic;
signal Selector: std_logic;
signal PC_temp: std_logic_vector(9 downto 0);
signal ClkInv: std_logic;

--signal bakhod feha el output bta3 instruction memory of zero malosh lazma
signal Nothing: std_logic_vector(15 downto 0);

signal FD_Rst: std_logic;
signal FD2_Rst: std_logic;
signal DEx_Rst: std_logic;
signal ExMem_Rst: std_logic;
signal MemWB_Rst:std_logic;

signal PC_i: std_logic_vector(9 downto 0);
--signals kharga mn el PC Register
signal PC_o: std_logic_vector(9 downto 0);
signal PC1_o: std_logic_vector(9 downto 0);

--signals kharga mn el Instruction Memory
signal InstOut_InstMem: std_logic_vector(15 downto 0);

--signals kharga mn el Fetch-Decode Buffer 1
signal InstOut_FD: std_logic_vector(15 downto 0);
signal PC_o_FD: std_logic_vector(9 downto 0);
signal PC1_o_FD: std_logic_vector(9 downto 0);
--signals kharga mn el Fetch-Decode Buffer 2
signal InstOut_FD2: std_logic_vector(15 downto 0);

--Signals kharga mn el Register File
signal Rs_Data: std_logic_vector(15 downto 0);
signal Rt_Data: std_logic_vector(15 downto 0);

--signals kharga mn el stack pointer
signal EA_out_SP: std_logic_vector(9 downto 0);

--signals kharga mn el control unit lel stack pointer
signal Mux_SP1: std_logic;
signal Mux_SP2: std_logic;
signal Mux_SP3: std_logic_vector(1 downto 0);

--signals kharga mn el control unit lel D-E buffer
--Execute signals
signal ALUSig: std_logic_vector(4 downto 0);
signal OutSig: std_logic;
signal Mux_copy_EX: std_logic;
signal Mux_Flag1: std_logic;
signal Flag_int_en: std_logic;
signal Flag1_en: std_logic;

--jump signals
signal JZSig: std_logic;
signal JNSig: std_logic;
signal JCSig: std_logic;
signal JmpSig: std_logic;
signal CallSig: std_logic;

--Memory signals
signal Mux_mem_value: std_logic_vector(1 downto 0);
signal Mux_mem_address: std_logic_vector(1 downto 0);
signal Mem_We: std_logic;

--Write Back signals
signal Mux_WB: std_logic_vector(1 downto 0);
signal WE: std_logic;

signal mux_PC: std_logic;
signal RetSig: std_logic;
signal IntSig: std_logic;

signal F_D_Buffer_enable_o: std_logic; --de kharga mn el control unit w dakhla 3la el register
signal F_D_Buffer_enable_i: std_logic; --de dakhla 3la el control unit w kharga mn el register
------------------------------------------------------------
signal F_D2_Buffer_enable: std_logic;

-- signals kharga mn el Decode-Execute Buffer
signal Rs_Data_DExOut, Rt_Data_DExOut: std_logic_vector(15 downto 0);
signal Rs_DExOut, Rt_DExOut, Rd_DExOut: std_logic_vector(2 downto 0);
signal imm4_DExOut: std_logic_vector(3 downto 0);
signal imm16_DExOut: std_logic_vector(15 downto 0);
signal PC_o_DExOut, PC1_o_DExOut: std_logic_vector(9 downto 0);
signal EA_out_SP_DExOut: std_logic_vector(9 downto 0); 
signal ALUSig_DExOut: std_logic_vector(4 downto 0); 
signal OutSig_DExOut: std_logic;
signal Mux_copy_EX_DExOut: std_logic;
signal Mux_Flag1_DExOut: std_logic;
signal Flag_int_en_DExOut: std_logic;
signal Flag1_en_DExOut: std_logic;
signal JZSig_DExOut, JNSig_DExOut, JCSig_DExOut, JmpSig_DExOut, CallSig_DExOut: std_logic;
signal Mux_mem_value_DExOut: std_logic_vector(1 downto 0);
signal Mux_mem_address_DExOut: std_logic_vector(1 downto 0);
signal Mem_We_DExOut: std_logic;
signal Mux_WB_DExOut: std_logic_vector(1 downto 0);
signal WE_DExOut: std_logic;
signal mux_PC_DExOut: std_logic;
signal RetSig_DExOut: std_logic;
signal IntSig_DExOut: std_logic;

--signals kharga mn el ALU
signal ALU_Value: std_logic_vector(15 downto 0);
signal Flags: std_logic_vector(3 downto 0);
signal Rs_Data_outEx: std_logic_vector(15 downto 0);

--signals kharga mn el Forward Unit
signal Forward_MuxRs_Selector: std_logic_vector(1 downto 0);
signal Forward_MuxRt_Selector: std_logic_vector(1 downto 0);

--signals kharga mn Execute-Memory Buffer
signal Rd_ExMemOut: std_logic_vector(2 downto 0);
signal imm16_ExMemOut: std_logic_vector(15 downto 0);
signal PC_o_ExMemOut: std_logic_vector(9 downto 0);
signal PC1_o_ExMemOut: std_logic_vector(9 downto 0);
signal EA_out_SP_ExMemOut: std_logic_vector(9 downto 0);
signal Mux_mem_value_ExMemOut: std_logic_vector(1 downto 0);
signal Mux_mem_address_ExMemOut: std_logic_vector(1 downto 0);
signal Mem_We_ExMemOut: std_logic;
signal Mux_WB_ExMemOut: std_logic_vector(1 downto 0);
signal WE_ExMemOut: std_logic;
signal ALU_Value_ExMemOut: std_logic_vector(15 downto 0);
signal mux_PC_ExMemOut: std_logic;
signal RetSig_ExMemOut: std_logic;
signal IntSig_ExMemOut: std_logic;

--signals kharga mn el Memory Unit
signal DataOut_Mem: std_logic_vector(15 downto 0);
signal Data0_Mem: std_logic_vector(15 downto 0);
signal Data1_Mem: std_logic_vector(15 downto 0);

--signals kharga mn el Memory-WriteBack Buffer
signal Rd_MemWBOut: std_logic_vector(2 downto 0);
signal imm16_MemWBOut: std_logic_vector(15 downto 0);
signal Mux_WB_MemWBOut: std_logic_vector(1 downto 0);
signal WE_MemWBOut: std_logic;
signal ALU_Value_MemWBOut: std_logic_vector(15 downto 0);
signal DataOut_Mem_MemWBOut: std_logic_vector(15 downto 0);
signal mux_PC_MemWBOut: std_logic;
signal RetSig_MemWBOut: std_logic;
signal IntSig_MemWBOut: std_logic;

--signals gayaly mn el WB stage
signal Write_Data_WB: std_logic_vector(15 downto 0);

--signals kharga mn el Hazard Detection Unit
signal HDU_PC_enable: std_logic;
signal HDU_FD_Buffer_enable: std_logic;
signal HDU_DEx_Buffer_reset: std_logic;

signal MreadSig: std_logic;
signal MreadSig_DExOut: std_logic;
signal F_D_Buffer_enable: std_logic;

signal ALU_Value_To_Ex : std_logic_vector(15 downto 0);
signal Mux_FU_ALU : std_logic;
signal Mux_FU_ALU_ExMemOut : std_logic;
signal Mux_FU_ALU_DExOut : std_logic;

begin
---------------------------------------------Create Modules--------------------------------------
-------------------------------------------------Fetch-------------------------------------------
ClkInv<= not Clk;
PC1_o <= PC_o + "0000000001";
F_D2_Buffer_enable<= not F_D_Buffer_enable_o;
F_D_Buffer_enable<= '0' when F_D_Buffer_enable_o='0' or HDU_FD_Buffer_enable='0' else
	'1';

Fetch_reg: General_Reg generic map (n=>10) port map(Clk,'0', HDU_PC_enable,PC_i,PC_o);
Instruction_Memory: syncram port map (Clk,'0', PC_o,"0000000000000000", InstOut_InstMem, Nothing);
-----------------------------------------Fetch-Decode Buffer-------------------------------------
FD_buffer: FD_Reg port map (
			Clk,FD_Rst,F_D_Buffer_enable, InstOut_InstMem, InstOut_FD, PC_o, PC_o_FD, PC1_o, PC1_o_FD
			);
FD2_buffer: FD2_Reg port map (
			Clk,FD2_Rst,F_D2_Buffer_enable, InstOut_InstMem, InstOut_FD2
			);
-------------------------------------------------Decode-------------------------------------------
FD_Enable_reg: One_Bit_Reg port map(Clk, '0', '1', F_D_Buffer_enable_o, F_D_Buffer_enable_i);

RegF: RegFile port map(ClkInv, RST, InstOut_FD(10 downto 8), InstOut_FD(4 downto 2),
						WE_MemWBOut, Rd_MemWBOut, Write_Data_WB, Rs_Data, Rt_Data);

Control_Unit: cu port map(
				Rst, interrupt, InstOut_FD(15 downto 11), F_D_Buffer_enable_i,
				Mux_SP1, Mux_SP2, Mux_SP3,
				ALUSig, OutSig, Mux_copy_EX, Mux_Flag1, Flag_int_en, Flag1_en,
				JZSig, JNSig, JCSig, JmpSig, CallSig,
				Mux_mem_value, Mux_mem_address, Mem_We,
				Mux_WB, WE,
				mux_PC,
				F_D_Buffer_enable_o,
				RetSig,
				IntSig,
				MreadSig,
				Mux_FU_ALU
				);

SP: stack port map(Clk, RST, Mux_SP3, Mux_SP2, Mux_SP1, InstOut_FD2(9 downto 0), EA_out_SP, SP_enable);

-----------------------------------------Decode-Execute Buffer-------------------------------------
DEx_buffer: DEx_Reg port map (
	Clk, DEx_Rst, '1',
	Rs_Data, Rt_Data,
	InstOut_FD(10 downto 8), InstOut_FD(4 downto 2), InstOut_FD(7 downto 5),
	InstOut_FD(4 downto 1),	InstOut_FD2, PC_o_FD, PC1_o_FD,
	EA_out_SP, 
	ALUSig, OutSig, Mux_copy_EX, Mux_Flag1, Flag_int_en, Flag1_en,
	JZSig, JNSig, JCSig, JmpSig, CallSig,
	Mux_mem_value, Mux_mem_address, Mem_We,
	Mux_WB, WE,
	mux_PC,
	RetSig,
	IntSig,
	MreadSig,
	Mux_FU_ALU,
	Rs_Data_DExOut, Rt_Data_DExOut,
	Rs_DExOut, Rt_DExOut, Rd_DExOut,
	imm4_DExOut, imm16_DExOut, PC_o_DExOut, PC1_o_DExOut,
	EA_out_SP_DExOut, 
	ALUSig_DExOut, OutSig_DExOut, Mux_copy_EX_DExOut, Mux_Flag1_DExOut, Flag_int_en_DExOut, Flag1_en_DExOut,
	JZSig_DExOut, JNSig_DExOut, JCSig_DExOut, JmpSig_DExOut, CallSig_DExOut,
	Mux_mem_value_DExOut, Mux_mem_address_DExOut, Mem_We_DExOut,
	Mux_WB_DExOut, WE_DExOut,
	mux_PC_DExOut,
	RetSig_DExOut,
	IntSig_DExOut,
	MreadSig_DExOut,
	Mux_FU_ALU_DExOut
	);
-------------------------------------------------Execute-------------------------------------------
EX: Execute port map(
	Rs_Data_DExOut, Rt_Data_DExOut, ALU_Value_To_Ex, Write_Data_WB,
	Forward_MuxRs_Selector, Forward_MuxRt_Selector,
	ALUSig_DExOut,
	imm4_DExOut,
	ALU_Value, out_port,
	Clk, Flag1_en_DExOut, Flag_int_en_DExOut, Mux_Flag1_DExOut, Mux_copy_EX_DExOut, OutSig_DExOut,
	Flags,
	Rs_Data_outEx,
	RST
	);
-----------------------------------------Execute-Memory Buffer-------------------------------------
EMem_buffer: EMem_Reg port map (
	Clk, ExMem_Rst, '1',
	Rd_DExOut,
	imm16_DExOut,
	PC_o_DExOut,
	PC1_o_DExOut,
	EA_out_SP_DExOut,
	Mux_mem_value_DExOut, Mux_mem_address_DExOut, Mem_We_DExOut,
	Mux_WB_DExOut, WE_DExOut,
	ALU_Value,
	mux_PC_DExOut,
	RetSig_DExOut,
	IntSig_DExOut,
	Mux_FU_ALU_DExOut,
	
	Rd_ExMemOut,
	imm16_ExMemOut,
	PC_o_ExMemOut,
	PC1_o_ExMemOut,
	EA_out_SP_ExMemOut,
	Mux_mem_value_ExMemOut,
	Mux_mem_address_ExMemOut,
	Mem_We_ExMemOut,
	Mux_WB_ExMemOut,
	WE_ExMemOut,
	ALU_Value_ExMemOut,
	mux_PC_ExMemOut,
	RetSig_ExMemOut,
	IntSig_ExMemOut,
	Mux_FU_ALU_ExMemOut
	);

-------------------------------------------------Memory-------------------------------------------
Mem: MemoryUnit port map(
	Clk,
	Mem_We_ExMemOut,
	ALU_Value_ExMemOut,
	PC_o_ExMemOut,
	PC1_o_ExMemOut,
	Mux_mem_value_ExMemOut,
	Mux_mem_address_ExMemOut,
	EA_out_SP_ExMemOut,
	DataOut_Mem,
	Data0_Mem,
	Data1_Mem
	);

-----------------------------------------Memory-WriteBack Buffer-------------------------------------
MWb_buffer: MWb_Reg port map (
	Clk, MemWB_Rst, '1',
	Rd_ExMemOut,
	imm16_ExMemOut,
	Mux_WB_ExMemOut,
	WE_ExMemOut,
	ALU_Value_ExMemOut,
	DataOut_Mem,
	mux_PC_ExMemOut,
	RetSig_ExMemOut,
	IntSig_ExMemOut,
	
	Rd_MemWBOut,
	imm16_MemWBOut,
	Mux_WB_MemWBOut,
	WE_MemWBOut,
	ALU_Value_MemWBOut,
	DataOut_Mem_MemWBOut,
	mux_PC_MemWBOut,
	RetSig_MemWBOut,
	IntSig_MemWBOut
	);
----------------------------------------------Foward Unit--------------------------------------------
FU: ForwardUnit port map(
	Rd_MemWBOut,
	Rd_ExMemOut,
	Rs_DExOut,
	Rt_DExOut,
	WE_MemWBOut,
	WE_ExMemOut,
	Forward_MuxRs_Selector,
	Forward_MuxRt_Selector
	);

------------------------------------------Hazard Detection Unit---------------------------------------
HDU: My_Detection_Unit port map(
	Rd_DExOut,InstOut_FD(10 downto 8), InstOut_FD(4 downto 2),
	MreadSig_DExOut,
	HDU_PC_enable, HDU_FD_Buffer_enable, HDU_DEx_Buffer_reset
	);
-------------------------------------------- Mux el Write Back--------------------------------
Write_Data_WB<= in_port when Mux_WB_MemWBOut="11" else
		DataOut_Mem_MemWBOut when Mux_WB_MemWBOut="10" else
		imm16_MemWBOut when Mux_WB_MemWBOut="01" else
		ALU_Value_MemWBOut;


Selector<= '1' when ((JZSig_DExOut='1' and Flags(0)='1') or
					(JNSig_DExOut='1' and Flags(1)='1') or
					(JCSig_DExOut='1' and Flags(2)='1') or
					JmpSig_DExOut='1' or CallSig_DExOut='1') else
			'0';

PC_temp<= DataOut_Mem_MemWBOut(9 downto 0) when mux_PC_MemWBOut='1' else
	PC1_o;

--ana hena bakhod el makan ely ha jump 3aleh mn el F-D Buffer a7tmal a7tag ab3ato lel buffer ely ba3deh w akhdo mno
PC_i<= Data0_Mem(9 downto 0) when Rst ='1' else
	Data1_Mem(9 downto 0) when IntSig_MemWBOut='1' else
	Rs_Data_outEx(9 downto 0) when Selector ='1' else
	PC_temp;

-- Reset Signals --
FD_Rst <= Rst or Selector or RetSig or RetSig_DExOut or RetSig_ExMemOut or RetSig_MemWBOut
			or IntSig or IntSig_DExOut or IntSig_ExMemOut or IntSig_MemWBOut;
FD2_Rst <= Rst or Selector or RetSig or RetSig_DExOut or RetSig_ExMemOut or RetSig_MemWBOut
			or IntSig or IntSig_DExOut or IntSig_ExMemOut or IntSig_MemWBOut;
DEx_Rst <= Rst or Selector or HDU_DEx_Buffer_reset;
ExMem_Rst <= Rst or RetSig_MemWBOut;
MemWB_Rst <= Rst ;

SP_enable <= not (Selector or RetSig_DExOut or RetSig_ExMemOut or RetSig_MemWBOut);

ALU_Value_To_Ex <= imm16_ExMemOut when Mux_FU_ALU_ExMemOut='1' else
	ALU_Value_ExMemOut;


end processor_arch;