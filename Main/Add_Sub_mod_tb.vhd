library ieee;
use ieee.std_logic_1164.all;
--test file for the N-bit adder
-- set the number of bits below
entity tb1 is
end tb1;

architecture Add_Sub_mod_test of tb1 is

component FA_N
generic (NBITS : positive); -- the number of bits we're dealing with
port(X,Y : in std_logic_vector(NBITS downto 0);
     cin0: in std_logic;
     S: out std_logic_vector(NBITS downto 0);
     coutN: out std_logic);
end component;

constant n : integer := 6; --determine how many bits to test
signal XT, YT , ST: std_logic_vector(0 to n-1);
signal CINT, COUTT: std_logic;

begin
U1: FA_N
    generic map(NBITS => n)
    port map(XT,YT,CINT,ST,COUTT);
process begin
XT<="000000"; YT<="000000"; CINT<='0'; wait for 10 ns;
XT<="001100"; YT<="001100"; CINT<='0'; wait for 10 ns;
XT<="000100"; YT<="000000"; CINT<='0'; wait for 10 ns;
XT<="001100"; YT<="010000"; CINT<='0'; wait for 10 ns;
XT<="000000"; YT<="010000"; CINT<='0'; wait for 10 ns;
XT<="000100"; YT<="111111"; CINT<='0'; wait for 10 ns;
XT<="001000"; YT<="100011"; CINT<='0'; wait for 10 ns;
XT<="010000"; YT<="000001"; CINT<='1'; wait for 10 ns;
wait;

end process;
end Add_Sub_mod_test;
