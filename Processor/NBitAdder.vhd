library ieee;
use ieee.std_logic_1164.all;

entity my_nadder is 
generic (n : integer := 16);
port (
	a, b: in std_logic_vector(n - 1 downto 0); 
	cin: in std_logic; 
	s: out std_logic_vector(n - 1 downto 0);
	cout: out std_logic
	);
end entity my_nadder;

architecture a_my_nadder of my_nadder is
component my_adder is
port (
	a, b, cin: in std_logic; 
	s, cout: out std_logic
	);
end component;
signal temp : std_logic_vector(n-1 downto 0);
begin

f0 : my_adder port map(a(0),b(0),cin,s(0),temp(0));
loop1: for i in 1 to n-1 generate
fx: my_adder port map(a(i),b(i),temp(i-1),s(i),temp(i));
cout <= temp(n-1);
end generate;

end architecture a_my_nadder;
