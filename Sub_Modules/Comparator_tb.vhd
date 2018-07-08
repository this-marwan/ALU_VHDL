--test bench for Comparator.vhd
library IEEE;
use ieee.std_logic_1164.all;

entity tb2 is
end tb2;

architecture comp_test of tb2 is
  component comp
    port(X,Y : in std_logic;
          eql, grt: out std_logic;
          eqli: in std_logic := '1';
          grti: in std_logic := '0');
end component;

signal xt, yt, eqlit, grtit, eO, gO : std_logic; --inputs


begin
U1: comp port map(xt,yt,eO,gO,eqlit,grtit);

process begin

xt<= '0'; yt<='0'; eqlit<='1'; grtit<='0'; wait for 10ns;
xt<= '0'; yt<='1'; eqlit<='1'; grtit<='1'; wait for 10ns;
xt<= '1'; yt<='0'; eqlit<='1'; grtit<='0'; wait for 10ns;
xt<= '1'; yt<='1'; eqlit<='1'; grtit<='1'; wait for 10ns;
wait;

end process;
end comp_test;
