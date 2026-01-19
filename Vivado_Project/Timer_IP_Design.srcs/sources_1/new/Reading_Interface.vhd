LIBRARY ieee;
USE ieee.std_logic_1164. all ;
USE ieee.std_logic_arith. all ;
LIBRARY xil_defaultlib ;
USE xil_defaultlib.IP_Package.all ;

ENTITY Read_IF IS
PORT (
Addr : IN DefAddr;
CLK : IN DefBit;
RnW : IN DefBit;
Timer_value : IN DefValue;
nAS : IN DefBit;
nBE0_nBE1 : IN DefnBE;
nRST : IN DefBit;
nWAIT : IN DefBit;
CS : IN DefBit;
DBus : OUT Defdata
);
END Read_IF ;

ARCHITECTURE ArchRIF OF Read_IF IS
BEGIN

ReadIFBehavior : process (CS,RnW,Addr)
begin

DBus <= TriState;
if CS = '1' and RnW = '1' then

case Addr is

when AddrTimerValueLSB =>
DBus <= Timer_value ( 15 downto 0 );

when AddrTimerValueMSB =>
DBus <= Timer_value ( 31 downto 16 );

when others =>

end case ;
end if ;
end process ReadIFBehavior;
END ARCHITECTURE ArchRIF;


