library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
--Money is entered **sequentially** NOT ALL AT ONE GO

--Money is represneted in quantities of 250L.L
--By defualt the machine(bank) has 26x500L.L and 24x250L.L

--idle state = defualt = enter money state

--Machine will not accept more than 5,000 L.L. in total (error = ExceedAllowedAmount)
--user_bank is the money entered by user

--If cost exceeds money entered (user_bank) stay in Select State, output problem
--WE CAN NOT RETURN 1000L.L or 5000L.L (Paper Bills)

--Secondary goals:
--Inventory tracking, default quantity is 10 of each item ✓


--optimization/minimization ideas:
--use nested IF statements ✓
--turn repetitive code to functions (mainly the inventory/selection bit) ✓


--NOTES:
--1) We can figure out the combination of input (250,500 etc.) by
--checking how much the amount is increasing each time money is added.

--2) In IDLE state, Error is set to NoError

--3)By default the machine(bank) has 26x500L.L and 24x250L.L

entity Vending_Machine is
  port (
--clock signal
  CLK: in std_logic;
--CashInput from the user, check NOTE1
  CashInput: in std_logic_vector(5 downto 0);
--SelectNo represents the number of the item to be selected
  SelectNo: in integer range 100 to 610 := 100; --default value is 100
--UserAction determines what action to take next
  UserAction: in std_logic_vector(2 downto 0);
--ErrorOut displays the error to the user
  ErrorOut: out std_logic_vector(2 downto 0);
--GiveOut indicates that an item was dispensed
  GiveOut: out std_logic;
--CashOutput amount of change we will return to the user
  CashOutput: out std_logic_vector(5 downto 0)
  );
end Vending_Machine;


architecture Vending_Machine_arch of Vending_Machine is

  TYPE states IS (IDLE, SelectItem, CollectItem);--IDLE is the default value
  TYPE errors IS (ExceedAllowedAmount, WrongInput, NoItem, NotEnoughCash, NoChange, NoError);--NoError is the default value
  TYPE actions IS (Abort, Neglect, NoAction); --NoAction is the default value
  --Possible Actions
  --Abort: CANCELS EVERYTHING AND RETURNS MONEY TO USER
  --NEGLECT: KEEPS CHANGE

--define our signals here
signal C_STATE, N_STATE: states := IDLE; --we use to move between states
signal ACTION : actions := NoAction; --Defines the action to take next action
signal ErrorOutS : errors := NoError; --Defines the erro we have
signal ItemNo : integer range 100 to 610 := 100;
signal Dispense : std_logic;
signal DispenseCash : std_logic_vector(5 downto 0);

signal ChangeToNeglect: std_logic_vector(5 downto 0) := "000000"; --will tell us how much change to neglect / practically we wil subtarct this value form the user_bank

  begin
--process sensitive to clock to update state
SEQ: process (CLK) -- sensitive on clock
  begin
    if CLK'event AND CLK = '1' then
      C_STATE <= N_STATE;
    end if;
  end process SEQ;


--combinational logic
COMB: process (C_STATE, ACTION, CashInput, SelectNo) -- sensitive on to INPUTs and StateChanges
--declare our variables here:
--check NOTE3
variable bank_250 : std_logic_vector(5 downto 0) := "011000" ; --start with 24 250L.L
variable bank_500 : std_logic_vector(5 downto 0) := "011010" ; --start with 26 500L.L
variable bank_1000: std_logic_vector(5 downto 0) := "000000" ;
variable bank_5000: std_logic_vector(5 downto 0) := "000000" ;
--the money entered by the user
variable user_bank: std_logic_vector(5 downto 0) := "000000" ;

--The quantity of each item, all default to 10.
variable I11,I12,I13,I14,I15,I16,
         I21,I22,I23,I24,I25,I26,
         I31,I32,I33,I34,I35,I36,
         I41,I42,I43,I44,I45,I46,I47,I48,I49,I40,I411,I412,
         I51,I52,I53,I54,I55,I56,I57,I58,I59,I50,
         I61,I62,I63,I64,I65,I66,I67,I68,I69,I60
         : integer range 0 to 10 := 10;

--define functions here
--fucntion to check if Change is available
impure function checkChange (value,Num500,Num250: std_logic_vector(5 downto 0)) return errors is
variable A : std_logic_vector(5 downto 0) := value;
variable B : std_logic_vector(5 downto 0) := Num500;
variable C : std_logic_vector(5 downto 0) := Num250;
begin
while A > "000000" AND B > "000000" loop
A := A - "000010";
B := B - "000010";
end loop;

while A > "000000" AND C > "000000" loop
A := A - "000001";
C := C - "000001";
end loop;
ChangeToNeglect <= A; --we'll need this incase we need to neglect change
if A = "000000" then
  return NoError ;
else
  return NoChange;
end if;

end checkChange;

--function to calculate how many 500L.L to return
function returnChange500 (value,Num500: std_logic_vector(5 downto 0)) return std_logic_vector is
variable A : std_logic_vector(5 downto 0) := value;
variable B : std_logic_vector(5 downto 0) := Num500;
variable C : std_logic_vector(5 downto 0) := "000000"; --this will indicate how many 500 to return
begin
while A > "000000" AND B > "000000" loop
A := A - "000010";
B := B - "000010";
C := C + "000010";
end loop;
return C;
end returnChange500;

--function to calculate how many 250L.L to return
function returnChange250 (value,Num250: std_logic_vector(5 downto 0)) return std_logic_vector is
variable A : std_logic_vector(5 downto 0) := value;
variable B : std_logic_vector(5 downto 0) := Num250;
variable C : std_logic_vector(5 downto 0) := "000000"; --this will indicate how many 500 to return
begin
while A > "000000" AND B > "000000" loop
A := A - "000001";
B := B - "000001";
C := C + "000001";
end loop;
return C;
end returnChange250;

--Return change to the user
impure function returnChange(value: std_logic_vector(5 downto 0)) return std_logic_vector is
  variable A : std_logic_vector(5 downto 0);
  variable B : std_logic_vector(5 downto 0);
begin
A := returnChange500(value,bank_500);
bank_500 := bank_500 - A;

B := returnChange500(value,bank_250);
bank_250 := bank_250 - B;

return A + B;

end returnChange;


--function to check if selected item can be purchased (i.e enough cash + inventory)
impure function selected(ItemVar: integer range 0 to 10; ItemPr:std_logic_vector(5 downto 0)) return errors is
begin
   if ItemVar > 0 then --item is available
     if user_bank >= ItemPr then --there is enough money to purchase it
        return checkChange((user_bank - ItemPr),bank_500,bank_250); --check to see if there is change incase of purchase
     else
         return NotEnoughCash;
     end if;
   else
       return NoItem;
end if;
return NoError;
end selected;

--function to actually purchase the ITEM --identical to function selected, except that now we take action
impure function purchase(ItemVar: integer range 0 to 10; ItemPr:std_logic_vector(5 downto 0)) return errors is
begin
   if ItemVar > 0 then --item is available
     if user_bank >= ItemPr then --there is enough money to purchase it
         user_bank := user_bank - ItemPr;
         dispense <= '1';
         DispenseCash <= returnChange(user_bank);
         N_STATE <= IDLE;
         return NoError; --we do this to resolve any previous error
     else
         return NotEnoughCash;
     end if;
   else
       return NoItem;
 end if;
end purchase;


begin

--map user input to action type
  if UserAction = "00" then
    ACTION <= NoAction;
  elsif UserAction = "01" then
    ACTION <= Neglect;
  elsif UserAction = "10" then
    ACTION <= Abort;
  else --none of the above acctions chosen
  Action <= NoAction;
  end if;


case C_STATE is

  when IDLE =>
  --default states
  ErrorOutS <= NoError;
  Dispense <= '0';
  ItemNo <= 100;
  Action <= NoAction;
  DispenseCash <= "000000";
 --If money has been inputted move to next stage
  if CashInput /= "000000" then
    N_STATE <= SelectItem;
  end if;

--Check to see what the 'combination' of money is, check NOTE1
  if CashInput = "000001" then
    bank_250 := bank_250 + "000001";
    user_bank := user_bank + CashInput;
  elsif CashInput = "000010" then
    bank_500 := bank_500 + "000001";
    user_bank := user_bank + CashInput;
  elsif CashInput = "000100" then
    bank_1000 := bank_1000 + "000001";
    user_bank := user_bank + CashInput;
  elsif CashInput = "010100" then
    bank_5000 := bank_5000 + "000001";
    user_bank := user_bank + CashInput;
  end if;


  when SelectItem =>

 --Incase the user is still adding money
 --Check to see what the 'combination' of money is, check NOTE1
if ((user_bank + CashInput) <= "010100") AND (CashInput /= "000000")  then  --we also need to make sure the amount doesn't exceed 5,000 L.L
  --only add more money if input did not exceed 5000L.L
   if CashInput = "000001" then
     bank_250 := bank_250 + "000001";
     user_bank := user_bank + CashInput;
   elsif CashInput = "000010" then
     bank_500 := bank_500 + "000001";
     user_bank := user_bank + CashInput;
   elsif CashInput = "000100" then
     bank_1000 := bank_1000 + "000001";
     user_bank := user_bank + CashInput;
   end if;
   ErrorOutS <= NoError;
else

  ErrorOutS <= ExceedAllowedAmount; --reject any more added money

end if;

--check if any action has been taken
if ACTION = Abort then
  --the only case in which we could return paper bills
  while user_bank > "000000" AND bank_5000 > "000000" loop
  user_bank := user_bank - "010100";
  bank_5000 := bank_5000 - "010100";
  DispenseCash <= DispenseCash + "010100";
  end loop;

  while user_bank > "000000" AND bank_1000 > "000000" loop
  user_bank := user_bank - "000100";
  bank_1000 := bank_1000 - "000100";
  DispenseCash <= DispenseCash + "000100";
  end loop;

  while user_bank > "000000" AND bank_500 > "000000" loop
  user_bank := user_bank - "000010";
  bank_500 := bank_500 - "000010";
  DispenseCash <= DispenseCash + "000010";
  end loop;

  while user_bank > "000000" AND bank_250 > "000000" loop
  user_bank := user_bank - "000001";
  bank_250 := bank_250 - "000001";
  DispenseCash <= DispenseCash + "000001";
  end loop;

  N_STATE <= IDLE;

elsif ErrorOutS = NoChange then
   if ACTION = Neglect then
     user_bank := user_bank - ChangeToNeglect;
   end if;
end if;



--check for the item selected--
case ItemNo is
    when 100 => --nothing selected yet, nothing selected
    --FROMAT: when *item code* => ErrorOutS <= selected(*item var*,*item price*); if ErrorOutS = NoError then ErrorOutS <= purchase(*item var*,"*item price*); *item var* := *item var* - 1; end if;

    when 101 => ErrorOutS <= selected(I11,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I11,"000010"); I11 := I11 - 1; end if;
    when 102 => ErrorOutS <= selected(I12,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I12,"000100"); I12 := I12 - 1; end if;
    when 103 => ErrorOutS <= selected(I13,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I13,"000100"); I13 := I13 - 1; end if;
    when 104 => ErrorOutS <= selected(I14,"000110"); if ErrorOutS = NoError then ErrorOutS <= purchase(I14,"000110"); I14 := I14 - 1; end if;
    when 105 => ErrorOutS <= selected(I15,"000110"); if ErrorOutS = NoError then ErrorOutS <= purchase(I15,"000110"); I15 := I15 - 1; end if;
    when 106 => ErrorOutS <= selected(I16,"000110"); if ErrorOutS = NoError then ErrorOutS <= purchase(I16,"000110"); I16 := I16 - 1; end if;

    when 201 => ErrorOutS <= selected(I21,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I21,"000100"); I21 := I21 - 1; end if;
    when 202 => ErrorOutS <= selected(I22,"000010"); if ErrorOutS = NoError then ErrorOutS <= purchase(I22,"000010"); I22 := I22 - 1; end if;
    when 203 => ErrorOutS <= selected(I23,"000010"); if ErrorOutS = NoError then ErrorOutS <= purchase(I23,"000010"); I23 := I23 - 1; end if;
    when 204 => ErrorOutS <= selected(I24,"000110"); if ErrorOutS = NoError then ErrorOutS <= purchase(I24,"000110"); I24 := I24 - 1; end if;
    when 205 => ErrorOutS <= selected(I25,"000010"); if ErrorOutS = NoError then ErrorOutS <= purchase(I25,"000010"); I25 := I25 - 1; end if;
    when 206 => ErrorOutS <= selected(I26,"000010"); if ErrorOutS = NoError then ErrorOutS <= purchase(I26,"000010"); I26 := I26 - 1; end if;

    when 301 => ErrorOutS <= selected(I31,"000010"); if ErrorOutS = NoError then ErrorOutS <= purchase(I31,"000010"); I31 := I31 - 1; end if;
    when 302 => ErrorOutS <= selected(I32,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I32,"000100"); I32 := I32 - 1; end if;
    when 303 => ErrorOutS <= selected(I33,"001000"); if ErrorOutS = NoError then ErrorOutS <= purchase(I33,"001000"); I33 := I33 - 1; end if;
    when 304 => ErrorOutS <= selected(I34,"000110"); if ErrorOutS = NoError then ErrorOutS <= purchase(I34,"000110"); I34 := I34 - 1; end if;
    when 305 => ErrorOutS <= selected(I35,"000110"); if ErrorOutS = NoError then ErrorOutS <= purchase(I35,"000110"); I35 := I35 - 1; end if;
    when 306 => ErrorOutS <= selected(I36,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I36,"000100"); I36 := I36 - 1; end if;

    when 401 => ErrorOutS <= selected(I41,"000110"); if ErrorOutS = NoError then ErrorOutS <= purchase(I41,"000110"); I41 := I41 - 1; end if;
    when 402 => ErrorOutS <= selected(I42,"000110"); if ErrorOutS = NoError then ErrorOutS <= purchase(I42,"000110"); I42 := I42 - 1; end if;
    when 403 => ErrorOutS <= selected(I43,"000110"); if ErrorOutS = NoError then ErrorOutS <= purchase(I43,"000110"); I43 := I43 - 1; end if;
    when 404 => ErrorOutS <= selected(I44,"000110"); if ErrorOutS = NoError then ErrorOutS <= purchase(I44,"000110"); I44 := I44 - 1; end if;
    when 405 => ErrorOutS <= selected(I45,"001000"); if ErrorOutS = NoError then ErrorOutS <= purchase(I45,"001000"); I45 := I45 - 1; end if;
    when 406 => ErrorOutS <= selected(I46,"001000"); if ErrorOutS = NoError then ErrorOutS <= purchase(I46,"001000"); I46 := I46 - 1; end if;
    when 407 => ErrorOutS <= selected(I47,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I47,"000100"); I47 := I47 - 1; end if;
    when 408 => ErrorOutS <= selected(I48,"000010"); if ErrorOutS = NoError then ErrorOutS <= purchase(I48,"000010"); I48 := I48 - 1; end if;
    when 409 => ErrorOutS <= selected(I49,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I48,"000100"); I49 := I49 - 1; end if;
    when 410 => ErrorOutS <= selected(I40,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I40,"000100"); I40 := I40 - 1; end if;
    when 411 => ErrorOutS <= selected(I411,"000010"); if ErrorOutS = NoError then ErrorOutS <= purchase(I411,"000010"); I411 := I411 - 1; end if;
    when 412 => ErrorOutS <= selected(I412,"000010"); if ErrorOutS = NoError then ErrorOutS <= purchase(I412,"000010"); I412 := I412 - 1; end if;

    when 501 => ErrorOutS <= selected(I51,"000110"); if ErrorOutS = NoError then ErrorOutS <= purchase(I51,"000110"); I51 := I51 - 1; end if;
    when 502 => ErrorOutS <= selected(I52,"000110"); if ErrorOutS = NoError then ErrorOutS <= purchase(I52,"000110"); I52 := I52 - 1; end if;
    when 503 => ErrorOutS <= selected(I53,"000110"); if ErrorOutS = NoError then ErrorOutS <= purchase(I53,"000110"); I53 := I53 - 1; end if;
    when 504 => ErrorOutS <= selected(I54,"000110"); if ErrorOutS = NoError then ErrorOutS <= purchase(I54,"000110"); I54 := I54 - 1; end if;
    when 505 => ErrorOutS <= selected(I55,"001000"); if ErrorOutS = NoError then ErrorOutS <= purchase(I55,"001000"); I55 := I55 - 1; end if;
    when 506 => ErrorOutS <= selected(I56,"001000"); if ErrorOutS = NoError then ErrorOutS <= purchase(I56,"001000"); I56 := I56 - 1; end if;
    when 507 => ErrorOutS <= selected(I57,"001000"); if ErrorOutS = NoError then ErrorOutS <= purchase(I57,"001000"); I57 := I57 - 1; end if;
    when 508 => ErrorOutS <= selected(I58,"001100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I58,"001100"); I58 := I58 - 1; end if;
    when 509 => ErrorOutS <= selected(I59,"001100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I59,"001100"); I59 := I59 - 1; end if;
    when 510 => ErrorOutS <= selected(I50,"001110"); if ErrorOutS = NoError then ErrorOutS <= purchase(I50,"001110"); I50 := I50 - 1; end if;

    when 601 => ErrorOutS <= selected(I61,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I61,"000100"); I61 := I61 - 1; end if;
    when 602 => ErrorOutS <= selected(I62,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I62,"000100"); I62 := I62 - 1; end if;
    when 603 => ErrorOutS <= selected(I63,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I63,"000100"); I63 := I63 - 1; end if;
    when 604 => ErrorOutS <= selected(I64,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I64,"000100"); I64 := I64 - 1; end if;
    when 605 => ErrorOutS <= selected(I56,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I56,"000100"); I56 := I56 - 1; end if;
    when 606 => ErrorOutS <= selected(I66,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I66,"000100"); I66 := I66 - 1; end if;
    when 607 => ErrorOutS <= selected(I67,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I67,"000100"); I67 := I67 - 1; end if;
    when 608 => ErrorOutS <= selected(I68,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I68,"000100"); I68 := I68 - 1; end if;
    when 609 => ErrorOutS <= selected(I69,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I69,"000100"); I69 := I69 - 1; end if;
    when 610 => ErrorOutS <= selected(I60,"000100"); if ErrorOutS = NoError then ErrorOutS <= purchase(I60,"000100"); I60 := I60 - 1; end if;


    when others => ErrorOutS <= WrongInput; --put a wrong number

    end case;


  when others => --incase of unexpected state
    -- return to IDLE state
    N_STATE <= IDLE;


end case;

--By the end of the process we output the error
if ErrorOutS = NoError then
ErrorOut <= "000";
elsif ErrorOutS = ExceedAllowedAmount then
ErrorOut <= "001";
elsif ErrorOutS = WrongInput then
ErrorOut <= "010";
elsif ErrorOutS = NotEnoughCash then
ErrorOut <= "011";
elsif ErrorOutS = NoChange then
ErrorOut <= "100";
elsif ErrorOutS = NoItem then
ErrorOut <= "101";
else --none of the above errors
ErrorOut <= "111";
end if;

GiveOut <= Dispense;
CashOutput <= DispenseCash;
  end process COMB;

 end Vending_Machine_arch;
