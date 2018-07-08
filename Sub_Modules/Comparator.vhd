library ieee;
use ieee.std_logic_1164.all;
-- one bit comparator

entity comp is
  port(X,Y : in std_logic;
      eql, grt: out std_logic;
        eqli: in std_logic; --defualt value is 1
        grti: in std_logic); --defualt value is 0
end comp;


architecture comp_arch of comp is
 begin
eql <= ((X XNOR Y) AND eqli); --both bits are equal AND so is the previous bit(s)
grt <= (((X AND (NOT Y)) AND eqli) OR grti); --bit X is 1 while bit Y is 0 OR if the it was determined previously that X>Y.

end comp_arch;
