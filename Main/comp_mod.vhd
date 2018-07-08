library ieee;
use ieee.std_logic_1164.all;
--comparator file
entity comp_N is
  generic (NBITS : positive); -- the number of bits we're dealing with
  port(X,Y : in std_logic_vector(NBITS-1 downto 0);
  eqlN, grtN: out std_logic;
  eqliN,grtiN: in std_logic); --these inputs are for expandibily purposes default is 1 0
end comp_N;

architecture comp_mod_arch of comp_N is
component comp --include bit comparator
  port( X,Y : in std_logic;
        eql, grt: out std_logic;
        eqli: in std_logic;
        grti: in std_logic);
  end component;

signal m: std_logic_vector(NBITS downto 0); --to hold the eql, eqli
signal n: std_logic_vector(NBITS downto 0); --to hold the grt, grti

begin
A1 : for i in 0 to NBITS - 1 generate
U1 : comp port map(X(NBITS - 1 - i),Y(NBITS - 1 - i),m(i + 1),n(i + 1),m(i),n(i));
end generate;
m(0) <= '1';
n(0) <= '0';
eqlN <= m(NBITS);
grtN <= n(NBITS);

end comp_mod_arch;
