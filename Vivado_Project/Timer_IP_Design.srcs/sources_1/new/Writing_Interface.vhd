LIBRARY ieee;
USE ieee.std_logic_1164. all ;
USE ieee.std_logic_arith. all ;

LIBRARY xil_defaultlib ;
USE xil_defaultlib.IP_Package.all ;


ENTITY Write_IF IS
PORT (
Addr : IN DefAddr;
CLK : IN DefBit;
RnW : IN DefBit;
nAS : IN DefBit;
nBE0_nBE1 : IN DefnBE;
nRST : IN DefBit;
nWAIT : IN DefBit;
Config : OUT Defdata;
Init_TO : OUT DefValue;
RC_PWM : OUT Defdata;
Validation_PWM : OUT DefBit;
DBus : IN Defdata;
CS : IN DefBit
);
END Write_IF ;

ARCHITECTURE ArchWIF OF Write_IF IS
BEGIN

WriteIFBehavior : process (nRst,CLK)
begin

if nRst = '1' then
Init_TO <= (others => '0' );

elsif rising_edge (CLK) then
if CS= '1' and RnW= '0' then

case Addr is

when AddrInit_TO_LSB =>
Init_TO ( 15 downto 0 ) <= DBus;

when AddrInit_TO_MSB =>
Init_TO ( 31 downto 16 ) <= DBus;

when AddrConfig =>
Config <= DBus;

when AddrRCPWM =>
RC_PWM <= DBus;

when AddrValidationPWM =>
Validation_PWM <= DBus ( 0 );

when others =>

end case ;
end if ;
end if ;
end process WriteIFBehavior;
END ARCHITECTURE ArchWIF;
