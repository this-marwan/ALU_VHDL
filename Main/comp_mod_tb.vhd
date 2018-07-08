library ieee;
use ieee.std_logic_1164.all;
--test file for the Nibit comparator
-- set the number of bits below
entity tb3 is
end tb3;

architecture comp_mod_test of tb3 is
component comp_N
generic (NBITS : positive); -- the number of bits we're dealing with
    port(X,Y : in std_logic_vector(NBITS-1 downto 0);
    eqlN, grtN: out std_logic;
    eqliN,grtiN: in std_logic);
end component;

constant n : integer := 6; --determine how many bits to test
signal XT, YT: std_logic_vector(0 to n-1);
signal eqlNT, grtNT,eqliNT,grtiNT : std_logic;

begin
U1: comp_N
    generic map(NBITS => n)
    port map(XT,YT, eqlNT, grtNT, eqliNT, grtiNT);
process begin
XT<="100100"; YT<="100100"; eqliNT<='1'; grtiNT<='0'; wait for 10 ns;
XT<="101100"; YT<="001100"; eqliNT<='1'; grtiNT<='0'; wait for 10 ns;
XT<="000100"; YT<="000000"; eqliNT<='1'; grtiNT<='0'; wait for 10 ns;
XT<="000011"; YT<="010000"; eqliNT<='1'; grtiNT<='0'; wait for 10 ns;
wait;

end process;
end comp_mod_test;
