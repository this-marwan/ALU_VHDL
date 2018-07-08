--test bench for Full_Adder.vhd
library IEEE;
use ieee.std_logic_1164.all;

entity tb is
end tb;

architecture test of tb is
component FA port (
    a,b, cin: in std_logic;
    s, cout: out std_logic
);
end component;

signal xt, yt, ct, co, z : std_logic; --inputs


begin
U1: FA port map(xt,yt,ct,z,co);

process begin

xt<= '0'; yt<='0'; ct<='0'; wait for 10ns;
xt<= '0'; yt<='1'; ct<='0'; wait for 10ns;
xt<= '1'; yt<='0'; ct<='0'; wait for 10ns;
xt<= '1'; yt<='1'; ct<='0'; wait for 10ns;
wait;

end process;
end test;
