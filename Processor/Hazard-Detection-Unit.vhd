Library ieee;
Use ieee.std_logic_1164.all;

Entity  My_Detection_Unit is
port(
Rd1,Rs,Rt : in std_logic_vector(2 downto 0);
Mread : in std_logic;
s1,s2,s3: out std_logic
);
end My_Detection_Unit; 

Architecture mdu of My_Detection_Unit is
Begin

s1 <=   '0' when (Mread = '1' and ( Rd1 = Rs or  Rd1 = Rt)) else --Selection line for PC
	'1';					

s2 <=   '0' when (Mread = '1' and ( Rd1 = Rs or  Rd1 = Rt)) else --Selection line for IF/ID
	'1';
	
s3<=	'1' when (Mread = '1' and ( Rd1 = Rs or  Rd1 = Rt)) else --Selection line for MUX
	'0';			
end mdu;
	
