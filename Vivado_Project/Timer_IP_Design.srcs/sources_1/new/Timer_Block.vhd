LIBRARY ieee;
USE ieee.std_logic_1164. all ;
USE ieee.std_logic_arith. all ;
LIBRARY xil_defaultlib ;
USE xil_defaultlib.IP_Package.all ;
USE ieee.numeric_std. ALL ;
USE IEEE.STD_LOGIC_UNSIGNED. ALL ;

ENTITY Timer IS
PORT (
Config : IN Defdata; -- IP configuration : cintain the mode, the activation signal and the maximum value
Init_TO : IN DefValue;  -- The initial value of the timer 
CLK : IN DefBit; 
Gate : IN std_logic ; -- User input
nRST : IN DefBit;
IT : OUT DefBit; --Interruption signal
Signal_TO : OUT DefBit; -- Activation signal 
Timer_value : OUT DefValue -- Actual value of the timer
);

END Timer ;


ARCHITECTURE Timer_Architecture OF Timer IS
SIGNAL start, IT_Activation, New_Clock : DefBit;
BEGIN

Timer_Behavior : PROCESS (CLK, nRST)
VARIABLE Mode : STD_LOGIC_VECTOR ( 2 DOWNTO 0 );
VARIABLE Max : STD_LOGIC_VECTOR ( 10 DOWNTO 0 );
variable n: DefValue; --internal variable to define the value of the counter

BEGIN
-- Permanent assign
start <= Config( 4 );
IT_Activation <= Config( 3 );
Mode := Config( 2 DOWNTO 0 );
Max := Config( 15 DOWNTO 5 );

IF nRST = '1' THEN

start <= '0' ;
New_Clock <= '0' ;
n := Init_TO;

ELSIF RISING_EDGE(CLK) THEN
IF start = '1' THEN

CASE Mode is

-- 1. Mode Timer inactif
------------------------------------------
WHEN "000" =>
n := Init_TO;

-- 2. Mode Retriggerable en interne
------------------------------------------
WHEN "001" =>
if (n( 10 downto 0 ) = Max) then
n := Init_TO;
if (IT_Activation = '1' ) then
IT <= '1' ;
end if ;
else
n := n + 1 ;
IT <= '0' ;
end if ;

-- 3. Mode Retriggerable en externe
------------------------------------------
WHEN "010" =>
if (n( 10 downto 0 ) = Max) then
    if (Gate = '1' ) then
        n := Init_TO;
    end if ;
    if (IT_Activation = '1' ) then
        IT <= '1' ;
    end if ;
else
    n := n+ 1 ;
    IT <= '0' ;
end if ;

-- 4. Mode Non Retriggerable
------------------------------------------
WHEN "011" =>
if (n( 10 downto 0 ) = Max) then
n := ( OTHERS => 'Z' );
if (IT_Activation = '1' ) then
IT <= '1' ;
end if ;
else
n := n+ 1 ;
IT <= '0' ;
end if ;

-- 5. Mode Diviseur
------------------------------------------
WHEN "100" =>
if (n( 10 downto 0 ) = Max) then
--n <= (OTHERS => '0');
n := Init_TO;
New_Clock <= NOT New_Clock;
if (IT_Activation = '1' ) then
IT <= '1' ;
end if ;
else
n := n+ 1 ;
IT <= '0' ;
end if ;

-- 6. Mode Compteur
------------------------------------------
WHEN "101" =>
if (n( 10 downto 0 ) = Max) then
--n <= (OTHERS => 'Z');
n := ( OTHERS => 'Z' );
if (IT_Activation = '1' ) then
IT <= '1' ;
end if ;
else
if (Gate = '1' ) then
n := n+ 1 ;
IT <= '0' ;
end if ;
end if ;

WHEN OTHERS =>
n := ( OTHERS => 'Z' );
END CASE ;
END IF ;
Timer_value <= n;
Signal_TO <= New_Clock;
END IF ;

END PROCESS Timer_Behavior;
END ARCHITECTURE Timer_Architecture;