library ieee;
use ieee.std_logic_1164.all;


entity FA is
port(a,b, cin: in std_logic;
      s, cout: out std_logic);
end FA;

architecture FA_arch of FA is
--dataflow approach
begin
process (a,b,cin)
begin
s <= a xor b xor cin;
cout <= (a and b) or (cin and a) or (cin and b);
end process;
end FA_arch;
