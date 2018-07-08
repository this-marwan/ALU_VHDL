library ieee;
use ieee.std_logic_1164.all;


entity FA_N is
generic (NBITS : positive); -- the number of bits we're dealing with
port(X,Y : in std_logic_vector(NBITS-1 downto 0);
     cin0: in std_logic;
     S: out std_logic_vector(NBITS-1 downto 0);
     coutN: out std_logic);
end FA_N;

architecture FA_N_arch of FA_N is
--structural approach
component FA
port(a,b, cin: in std_logic;
      s, cout: out std_logic);
end component;

signal m: std_logic_vector(NBITS downto 0);
begin
A1 : for i in 0 to NBITS-1 generate
U1 : FA port map(X(i),Y(i),m(i),S(i),m(i+1));
end generate;
m(0) <= cin0;
coutN <= m(NBITS-1);

end FA_N_arch;
