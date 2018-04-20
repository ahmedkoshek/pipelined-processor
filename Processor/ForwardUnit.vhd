library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


Entity ForwardUnit is

port ( M_WRg: in std_logic_vector(2 downto 0);
       E_MRg: in std_logic_vector(2 downto 0);
       D_ERgA: in std_logic_vector(2 downto 0);
       D_ERgB: in std_logic_vector(2 downto 0);
       M_WWB: in std_logic;
       E_MWB: in std_logic;
       DecMuxA: out std_logic_vector(1 downto 0);
       DecMuxB: out std_logic_vector(1 downto 0)
       );
       
end entity ForwardUnit;

architecture ForwardUnit_function of ForwardUnit is

begin

DecMuxA <= "01" when ( D_ERgA = E_MRg and E_MWB='1' ) else
          "10" when ( D_ERgA = M_WRg and M_WWB='1' ) else
          "00";

DecMuxB <= "01" when ( D_ERgB = E_MRg and E_MWB='1' ) else
          "10" when ( D_ERgB = M_WRg and M_WWB='1' ) else
          "00";

end architecture ForwardUnit_function;
