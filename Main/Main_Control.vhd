library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; --contains the shift functions we need

--Notes: Multiplication outputs in OM not OT





entity ALU is
generic (NBIT : positive); -- the number of bits we're dealing with
port(
     A,B: in std_logic_vector(NBIT-1 downto 0); --A,B are inputs we will operate on
     C: in std_logic_vector (3 downto 0); --control Input
     O: out std_logic_vector(NBIT-1 downto 0); --Output (it is twice the size of the input as we have a multiplictaion op)
     OM:out std_logic_vector(2*NBIT-1 downto 0) ---output for multiplication only
     );
end ALU;

architecture ALU_arch of ALU is
component FA_N
generic (NBITS : positive); -- the number of bits we're dealing with
port(X,Y : in std_logic_vector(NBITS-1 downto 0);
     cin0: in std_logic;
     S: out std_logic_vector(NBITS-1 downto 0);
     coutN: out std_logic);
end component;

component comp_N
  generic (NBITS : positive); -- the number of bits we're dealing with
  port(X,Y : in std_logic_vector(NBITS-1 downto 0);
  eqlN, grtN: out std_logic;
  eqliN,grtiN: in std_logic); --these inputs are for expandibily purposes default is 1 0
end component;


signal O1,O2,O3,O4,BC: std_logic_vector (NBIT-1 downto 0);
signal eql,grtr: std_logic;

begin
U1: FA_N generic map(NBITS => NBIT) port map (A, B , '0' , O1 ); --ADD A AND B
U2: FA_N generic map(NBITS => NBIT) port map (A, "00000000" , '1' , O2 ); --INCREMENT A BY 1

BC <= std_logic_vector(not(B)); --get B's complement
U3: FA_N generic map(NBITS => NBIT) port map (A,  BC, '1' , O3 ); -- A MINUS B
U4: FA_N generic map(NBITS => NBIT) port map (A, "11111111", '0' , O4 ); --DECREMENT A BY 1

U6: COMP_N generic map(NBITS => NBIT) port map (A, B, eql, grtr, '0', '0');

process(A, B, C, O1, O2 ,O3, O4)
begin
CASE C IS
--ADD/SUBTRACT
WHEN "0000" => O <= O1;
WHEN "0001" => O <= O2;
WHEN "0010" => O <= O3;
WHEN "0011" => O <= O4;
-- --MULTIPLY
WHEN "0100" => OM <= A*B;
--COMPARISON
WHEN "0101" => --minimum
if eql = '1' or grtr ='1' then
O <= B;
else
O <= A;
end if;

WHEN "0110" => --maximum
if eql = '1' or grtr ='1' then
O <= A;
else
O <= B;
end if;
--SHIFTING
WHEN "1000" => O <= std_logic_vector((unsigned(A) ror 1)); --circular shift right
WHEN "1001" => O <= std_logic_vector((unsigned(A) rol 1)); --circular shift left

WHEN "1010" => O <= std_logic_vector((unsigned(A) srl 1)); --logical shift right
WHEN "1011" => O <= std_logic_vector((unsigned(A) sll 1)); --logical shift left

WHEN "1110" => O <= to_stdlogicvector(to_bitvector(A) sra 1);
WHEN "1101" => O <= to_stdlogicvector(to_bitvector(A) sla 1);

WHEN OTHERS => O <= (OTHERS => 'U') ;
END CASE;
END PROCESS;


end ALU_arch;
