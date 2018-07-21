library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ALU_tb is
end entity;

architecture ALU_tb_test of ALU_tb is
    component ALU
    generic (NBIT : positive); -- the number of bits we're dealing with
    port(
         A,B: in std_logic_vector(NBIT-1 downto 0); --A,B are inputs we will operate on
         C: in std_logic_vector (3 downto 0); --control Input
         O: out std_logic_vector(NBIT-1 downto 0); --Output (it is twice the size of the input as we have a multiplictaion op)
         OM:out std_logic_vector(2*NBIT-1 downto 0) ---output for multiplication only
         );
  end component;

  constant n : integer := 8; --determine how many bits to test

  signal XT,YT:std_logic_vector(n-1 downto 0);
  signal CT : std_logic_vector(3 downto 0);
  signal OT : std_logic_vector(n-1 downto 0);
  signal OMT: std_logic_vector(2*n-1 downto 0);

begin
  M1: ALU
  generic map(NBIT => n)
  port map(XT,YT,CT,OT,OMT);
process
begin
  --addition test
  CT<= "0000";XT<= "10100010"; YT<="10100010"; wait for 10 ns;
  CT<= "0000";XT<= "10110001"; YT<="10110001"; wait for 10 ns;
  CT<= "0000";XT<= "10000001"; YT<="00000001"; wait for 10 ns;
  CT<= "0000";XT<= "10101010"; YT<="10101010"; wait for 10 ns;
 ----------------
 --increment test
 wait for 100ns;
 CT<= "0001";XT<= "10100010"; YT<="10100010"; wait for 10 ns;
 CT<= "0001";XT<= "10110001"; YT<="10110001"; wait for 10 ns;
 CT<= "0001";XT<= "10000001"; YT<="00000001"; wait for 10 ns;
 CT<= "0001";XT<= "10101010"; YT<="10101010"; wait for 10 ns;
 --------------
 --subtraction test
 wait for 100ns;
 CT<= "0010";XT<= "10100010"; YT<="10100010"; wait for 10 ns;
 CT<= "0010";XT<= "10110001"; YT<="10110001"; wait for 10 ns;
 CT<= "0010";XT<= "10000001"; YT<="00000001"; wait for 10 ns;
 CT<= "0010";XT<= "10101010"; YT<="10101010"; wait for 10 ns;
 ---
 --decrememnt test
  wait for 100ns;
 CT<= "0011";XT<= "10100010"; YT<="10100010"; wait for 10 ns;
 CT<= "0011";XT<= "10110001"; YT<="10110001"; wait for 10 ns;
 CT<= "0011";XT<= "10000001"; YT<="00000001"; wait for 10 ns;
 CT<= "0011";XT<= "10101010"; YT<="10101010"; wait for 10 ns;
 ---
 --multiplicaton test
 wait for 100ns;
 CT<= "0100";XT<= "10100010"; YT<="10100010"; wait for 10 ns;
 CT<= "0100";XT<= "10110001"; YT<="10110001"; wait for 10 ns;
 CT<= "0100";XT<= "10000001"; YT<="00000001"; wait for 10 ns;
 CT<= "0100";XT<= "10101010"; YT<="10101010"; wait for 10 ns;
 --
 --minimum
  wait for 100ns;
 CT<= "0101";XT<= "10100010"; YT<="10100010"; wait for 10 ns;
 CT<= "0101";XT<= "10110001"; YT<="10110001"; wait for 10 ns;
 CT<= "0101";XT<= "10000001"; YT<="00000001"; wait for 10 ns;
 CT<= "0101";XT<= "10101010"; YT<="10101010"; wait for 10 ns;
 --
 -- max
  wait for 100ns;
 CT<= "0110";XT<= "10100010"; YT<="10100010"; wait for 10 ns;
 CT<= "0110";XT<= "10110001"; YT<="10110001"; wait for 10 ns;
 CT<= "0110";XT<= "10000001"; YT<="00000001"; wait for 10 ns;
 CT<= "0110";XT<= "10101010"; YT<="10101010"; wait for 10 ns;

 --circular shift right and left
  wait for 100ns;
 CT<= "1000";XT<= "10100010"; YT<="10100010"; wait for 10 ns;
 CT<= "1000";XT<= "10110001"; YT<="10110001"; wait for 10 ns;
 CT<= "1000";XT<= "10000001"; YT<="00000001"; wait for 10 ns;
 CT<= "1000";XT<= "10101010"; YT<="10101010"; wait for 10 ns;
 wait for 100ns;
 CT<= "1001";XT<= "10100010"; YT<="10100010"; wait for 10 ns;
 CT<= "1001";XT<= "10110001"; YT<="10110001"; wait for 10 ns;
 CT<= "1001";XT<= "10000001"; YT<="00000001"; wait for 10 ns;
 CT<= "1001";XT<= "10101010"; YT<="10101010"; wait for 10 ns;

 --logical shift right and left
  wait for 100ns;
  CT<= "1010";XT<= "10100010"; YT<="10100010"; wait for 10 ns;
  CT<= "1010";XT<= "10110001"; YT<="10110001"; wait for 10 ns;
  CT<= "1010";XT<= "10000001"; YT<="00000001"; wait for 10 ns;
  CT<= "1010";XT<= "10101010"; YT<="10101010"; wait for 10 ns;
  wait for 100ns;
  CT<= "1011";XT<= "10100010"; YT<="10100010"; wait for 10 ns;
  CT<= "1011";XT<= "10110001"; YT<="10110001"; wait for 10 ns;
  CT<= "1011";XT<= "10000001"; YT<="00000001"; wait for 10 ns;
  CT<= "1011";XT<= "10101010"; YT<="10101010"; wait for 10 ns;

--airthmatic shifts
 wait for 100ns;
  CT<= "1110";XT<= "10100010"; YT<="10100010"; wait for 10 ns;
  CT<= "1110";XT<= "10110001"; YT<="10110001"; wait for 10 ns;
  CT<= "1110";XT<= "10000001"; YT<="00000001"; wait for 10 ns;
  CT<= "1110";XT<= "10101010"; YT<="10101010"; wait for 10 ns;
    wait for 100ns;
  CT<= "1101";XT<= "10100010"; YT<="10100010"; wait for 10 ns;
  CT<= "1101";XT<= "10110001"; YT<="10110001"; wait for 10 ns;
  CT<= "1101";XT<= "10000001"; YT<="00000001"; wait for 10 ns;
  CT<= "1101";XT<= "10101010"; YT<="10101010"; wait for 10 ns;

wait;
end process;

end ALU_tb_test;
